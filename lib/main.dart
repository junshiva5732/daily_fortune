import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'ads/ad_manager.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'services/fortune_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 광고 SDK 초기화는 앱 표시를 막지 않도록 기다리지 않는다.
  AdManager.instance.init();
  await initializeDateFormatting('ko');
  final service = await FortuneService.create();
  runApp(FortuneApp(service: service));
}

class FortuneApp extends StatelessWidget {
  final FortuneService service;
  const FortuneApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '오늘의 운세',
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
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('ko'), Locale('en')],
      locale: const Locale('ko'),
      home: _Root(service: service),
    );
  }
}

/// 생년월일이 없으면 온보딩(설정 화면)을 먼저 보여준다.
class _Root extends StatefulWidget {
  final FortuneService service;
  const _Root({required this.service});

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  @override
  void initState() {
    super.initState();
    if (widget.service.birthDate == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SettingsScreen(service: widget.service, isOnboarding: true),
          ),
        );
        if (mounted) setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) => HomeScreen(service: widget.service);
}
