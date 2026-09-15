# 오늘의 운세 (daily_fortune)

생년월일 기반 오늘의 운세 + 명언 앱. AdMob 광고(배너 / 전면)로 수익화.
Flutter 로 작성, Android + iOS 대상. 한국어 · 영어 · 일본어 · 중국어(간체) 지원.

## 구조

```
lib/
  main.dart                    앱 진입, 테마, 온보딩 분기
  ads/ad_ids.dart              AdMob 광고 단위 ID  ← 출시 전 교체
  ads/ad_manager.dart          전면 광고 로드/노출 싱글톤
  widgets/banner_ad_widget.dart 하단 적응형 배너
  l10n/app_*.arb               UI 문자열 (ko/en/ja/zh) → flutter gen-l10n 이 L10n 클래스 생성
  l10n/lang.dart               시스템 언어 → 지원 언어 매핑 (미지원은 en)
  data/fortunes.dart           운세 문구 157개 × 4개 언어, 띠, 행운 아이템 (T 클래스로 병기)
  data/quotes.dart             명언 82개 × 4개 언어
  services/fortune_service.dart 날짜+생년월일 시드 → 결정적 운세, 리롤 카운터
  services/notification_service.dart 매일 아침 알림 (7일치 개별 예약, 앱 열 때마다 갱신)
  screens/home_screen.dart     홈 (운세 지수·행운 아이템·명언)
  screens/detail_screen.dart   카테고리별 상세
  screens/share_card_screen.dart 이미지 카드 공유 (RepaintBoundary → PNG)
  screens/settings_screen.dart 생년월일·알림 설정 (첫 실행 온보딩 겸용, 건너뛰기 불가)
```

## 광고 노출 지점

| 위치 | 종류 | 동작 |
|---|---|---|
| 홈·상세 하단 | 배너 | 항상 표시 |
| "상세 운세 보기" 탭 | 전면 | **하루 첫 1회만** (`AdManager.showInterstitialOncePerDayThen`, 날짜를 prefs 에 기록) |
| 설정 화면 "저장" | 전면 | 저장 시 매번 (하루 1회 카운트와 별개, 첫 실행 온보딩 제외) |

## 다국어

- UI 문자열: `lib/l10n/app_<lang>.arb` 에 키 추가 → `flutter gen-l10n` (빌드 시 자동 실행).
- 콘텐츠: `T('한국어', 'English', '日本語', '中文')` 로 4개 언어를 한 항목에 병기. 운세는 인덱스로
  뽑히므로 **한 언어만 추가/삭제하면 안 되고**, 항목 끝에만 추가할 것 (중간 삽입 시 그날 운세가 바뀜).
- 새 언어 추가: `T` 에 필드 추가 + `FortuneData.supportedLangs` + ARB 파일 + 콘텐츠 번역.
- 앱 이름: Android `res/values-<lang>/strings.xml`, iOS `ios/Runner/<lang>.lproj/InfoPlist.strings`
  (iOS 는 Mac 에서 Xcode 로 lproj 파일을 프로젝트에 추가해야 번들에 포함됨).
- 스토어 문구 번역: `store/listing_i18n.md`.

## 개발 빌드

```bash
flutter pub get
flutter build apk --debug
```

에뮬레이터: `flutter emulators --launch Small_Phone_API_35` 후 `flutter run`.

### 이 PC 전용 메모
Java 의 AF_UNIX 소켓이 `%TEMP%` 아래에서 실패해 Gradle 이 "Unable to establish loopback connection" 으로
죽는 문제가 있어, `android/gradle.properties` 와 `android/gradlew.bat` 에
`-Djdk.net.unixdomain.tmpdir=C:/tmp` 를 넣어 두었다. `C:\tmp` 폴더가 있어야 한다.

## 출시 체크리스트

### 1. AdMob
- [ ] https://admob.google.com 에서 앱 등록 (Android, iOS 각각)
- [x] 광고 단위 (Android): 배너 / 전면 — 보상형은 사용 안 함
- [ ] `lib/ads/ad_ids.dart` 의 테스트 ID → 실제 ID 교체
- [ ] `android/app/src/main/AndroidManifest.xml` 의 `APPLICATION_ID` 교체
- [ ] `ios/Runner/Info.plist` 의 `GADApplicationIdentifier` 교체
- [ ] 개발 중 실제 ID로 광고 클릭 금지 (계정 정지 사유). 테스트 기기 등록 권장.
- [ ] AdMob 결제 정보 + 세금 정보 입력 (첫 수익 $100 도달 시 지급)

### 2. 개인정보 / 정책
- [x] 개인정보처리방침: https://junshiva5732.github.io/daily_fortune/privacy-policy.html (원본 `docs/privacy-policy.html`, GitHub Pages)
- [ ] iOS: ATT(앱 추적 투명성) 팝업 — `Info.plist` 에 문구는 넣어둠. 필요 시 `app_tracking_transparency` 패키지로 요청.
- [ ] EU 대상이면 UMP(동의 메시지) 설정 — `google_mobile_ads` 의 `ConsentInformation` API.

### 3. Android 출시
- [ ] `flutter doctor --android-licenses` 로 라이선스 동의
- [x] 릴리즈 서명 키: `android/upload-keystore.jks` + `android/key.properties` (git 제외 — **반드시 백업**)
- [x] 앱 아이콘: `tool/make_icon.py` → `dart run flutter_launcher_icons`
- [ ] `flutter build appbundle --release` → `.aab` 업로드
- [ ] Google Play Console 개발자 등록 ($25, 1회)
- [ ] 스토어 등록 정보: 스크린샷(최소 2장), 512px 아이콘, 1024x500 배너, 설명, 데이터 보안 양식

### 4. iOS 출시 (Mac 필요)
- [ ] Apple Developer Program 가입 (연 $99)
- [ ] Xcode 에서 Bundle ID / 팀 설정, `pod install`
- [ ] `flutter build ipa` → Transporter 또는 Xcode 로 App Store Connect 업로드
- [ ] 심사 시 광고 사용 여부 "예" 표시

### 5. 출시 후
- [x] 운세 문구 카테고리당 31~33개, 명언 82개
- [x] 매일 아침 알림 (설정에서 시간 변경·끄기 가능)
- [x] 공유 이미지 카드
- [ ] 홈 위젯, 다국어 등 확장
