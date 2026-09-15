import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ads/ad_manager.dart';
import 'l10n/app_localizations.dart';
import 'l10n/lang.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'services/fortune_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // 광고 SDK 초기화는 앱 표시를 막지 않도록 기다리지 않는다.
  AdManager.instance.init(prefs);
  await initializeDateFormatting();
  final service = FortuneService(prefs);
  final notifications = NotificationService(prefs);
  runApp(FortuneApp(service: service, notifications: notifications));
}

class FortuneApp extends StatelessWidget {
  final FortuneService service;
  final NotificationService notifications;
  const FortuneApp({super.key, required this.service, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      onGenerateTitle: (context) => L10n.of(context).appTitle,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      localeResolutionCallback: AppLang.resolve,
      home: _Root(service: service, notifications: notifications),
    );
  }
}

/// 생년월일이 없으면 온보딩(설정 화면)을 홈 대신 보여준다.
/// 온보딩은 별도 라우트가 아니라 루트 자체이므로 뒤로가기로 건너뛸 수 없다.
class _Root extends StatefulWidget {
  final FortuneService service;
  final NotificationService notifications;
  const _Root({required this.service, required this.notifications});

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  @override
  Widget build(BuildContext context) {
    if (widget.service.birthDate == null) {
      return SettingsScreen(
        service: widget.service,
        notifications: widget.notifications,
        isOnboarding: true,
        onSaved: () => setState(() {}),
      );
    }
    return HomeScreen(service: widget.service, notifications: widget.notifications);
  }
}
