import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/app_localizations.dart';
import '../l10n/lang.dart';
import 'fortune_service.dart';

/// 매일 아침 "오늘의 운세" 알림.
///
/// 반복 알림 대신 **앞으로 7일치를 개별 예약**한다. 그래야 각 알림 본문에 그 날의
/// 실제 운세 문구를 넣을 수 있다. 앱을 열 때마다 [reschedule] 로 다시 7일치를 잡는다.
class NotificationService {
  static const _kEnabled = 'notif_enabled';
  static const _kHour = 'notif_hour';
  static const _kMinute = 'notif_minute';
  static const _days = 7;
  static const _channelId = 'daily_fortune';

  final SharedPreferences _prefs;
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  NotificationService(this._prefs);

  // ------------------------------------------------------------- 설정값

  bool get enabled => _prefs.getBool(_kEnabled) ?? true;
  int get hour => _prefs.getInt(_kHour) ?? 8;
  int get minute => _prefs.getInt(_kMinute) ?? 0;

  Future<void> setEnabled(bool v) => _prefs.setBool(_kEnabled, v);

  Future<void> setTime(int h, int m) async {
    await _prefs.setInt(_kHour, h);
    await _prefs.setInt(_kMinute, m);
  }

  // ------------------------------------------------------------- 초기화

  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (e) {
      debugPrint('timezone fallback: $e');
      tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    }
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    _initialized = true;
  }

  /// OS 알림 권한 요청 (Android 13+, iOS). 허용 여부 반환.
  Future<bool> requestPermission() async {
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }
    return false;
  }

  // ------------------------------------------------------------- 예약

  /// 기존 예약을 모두 지우고, 설정이 켜져 있으면 앞으로 7일치를 다시 예약한다.
  Future<void> reschedule(FortuneService fortune) async {
    await init();
    await _plugin.cancelAll();
    if (!enabled) return;

    final l = lookupL10n(Locale(AppLang.current));
    final now = tz.TZDateTime.now(tz.local);
    for (var i = 0; i < _days; i++) {
      final day = tz.TZDateTime(tz.local, now.year, now.month, now.day + i, hour, minute);
      if (day.isBefore(now)) continue; // 오늘 알림 시간이 이미 지났으면 건너뜀

      final f = fortune.fortuneFor(DateTime(day.year, day.month, day.day));
      final title = l.notifTitle;
      final body = l.notifBody(
        l.zodiacLabel(f.zodiacAnimal.of(AppLang.current)),
        f.percent,
        f.overall.text.of(AppLang.current),
      );

      await _plugin.zonedSchedule(
        i,
        title,
        body,
        day,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            l.notifChannelName,
            channelDescription: l.notifChannelDesc,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            styleInformation: BigTextStyleInformation(body),
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        // 정확한 알람 권한 없이도 동작. 몇 분 오차는 허용.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }
}
