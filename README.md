# 오늘의 운세 (daily_fortune)

생년월일 기반 오늘의 운세 + 명언 앱. AdMob 광고(배너 / 전면 / 보상형)로 수익화.
Flutter 로 작성, Android + iOS 대상.

## 구조

```
lib/
  main.dart                    앱 진입, 테마, 온보딩 분기
  ads/ad_ids.dart              AdMob 광고 단위 ID  ← 출시 전 교체
  ads/ad_manager.dart          전면·보상형 광고 로드/노출 싱글톤
  widgets/banner_ad_widget.dart 하단 적응형 배너
  data/fortunes.dart           운세 문구(5개 카테고리), 띠, 행운 아이템
  data/quotes.dart             명언 목록
  services/fortune_service.dart 날짜+생년월일 시드 → 결정적 운세, 리롤 카운터
  screens/home_screen.dart     홈 (운세 지수·행운 아이템·명언·공유)
  screens/detail_screen.dart   카테고리별 상세 + 보상형 광고 리롤
  screens/settings_screen.dart 생년월일 설정 (첫 실행 온보딩 겸용)
```

## 광고 노출 지점

| 위치 | 종류 | 동작 |
|---|---|---|
| 홈·상세 하단 | 배너 | 항상 표시 |
| "상세 운세 보기" 탭 | 전면 | 2번 진입마다 1회 (`AdManager.interstitialEvery`) |
| "광고 보고 운세 다시 뽑기" | 보상형 | 끝까지 시청 시 운세 재생성 |

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
- [ ] 광고 단위 3개 생성: 배너 / 전면 / 보상형 (플랫폼별 → 총 6개)
- [ ] `lib/ads/ad_ids.dart` 의 테스트 ID → 실제 ID 교체
- [ ] `android/app/src/main/AndroidManifest.xml` 의 `APPLICATION_ID` 교체
- [ ] `ios/Runner/Info.plist` 의 `GADApplicationIdentifier` 교체
- [ ] 개발 중 실제 ID로 광고 클릭 금지 (계정 정지 사유). 테스트 기기 등록 권장.
- [ ] AdMob 결제 정보 + 세금 정보 입력 (첫 수익 $100 도달 시 지급)

### 2. 개인정보 / 정책
- [ ] 개인정보처리방침 URL 준비 (AdMob·스토어 모두 필수). 무료 생성기 사용 가능.
- [ ] iOS: ATT(앱 추적 투명성) 팝업 — `Info.plist` 에 문구는 넣어둠. 필요 시 `app_tracking_transparency` 패키지로 요청.
- [ ] EU 대상이면 UMP(동의 메시지) 설정 — `google_mobile_ads` 의 `ConsentInformation` API.

### 3. Android 출시
- [ ] `flutter doctor --android-licenses` 로 라이선스 동의
- [ ] 릴리즈 서명 키 생성: `keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
- [ ] `android/key.properties` 작성 + `build.gradle.kts` 의 `signingConfig` 를 release 키로 교체
- [ ] 앱 아이콘 교체 (`flutter_launcher_icons` 패키지 권장)
- [ ] `flutter build appbundle --release` → `.aab` 업로드
- [ ] Google Play Console 개발자 등록 ($25, 1회)
- [ ] 스토어 등록 정보: 스크린샷(최소 2장), 512px 아이콘, 1024x500 배너, 설명, 데이터 보안 양식

### 4. iOS 출시 (Mac 필요)
- [ ] Apple Developer Program 가입 (연 $99)
- [ ] Xcode 에서 Bundle ID / 팀 설정, `pod install`
- [ ] `flutter build ipa` → Transporter 또는 Xcode 로 App Store Connect 업로드
- [ ] 심사 시 광고 사용 여부 "예" 표시

### 5. 출시 후
- [ ] 운세 문구 수 늘리기 (현재 카테고리당 11~12개, 최소 30개 권장)
- [ ] 푸시 알림(매일 아침 "오늘의 운세 도착") — 리텐션 핵심
- [ ] 위젯 / 공유 이미지 카드 등 확장
