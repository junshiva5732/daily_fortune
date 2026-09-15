import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../ads/ad_manager.dart';
import '../data/fortunes.dart';
import '../l10n/app_localizations.dart';
import '../l10n/lang.dart';
import '../services/fortune_service.dart';
import '../services/notification_service.dart';

/// 생년월일 · 알림 설정 화면. 첫 실행 시 온보딩으로도 쓰인다.
class SettingsScreen extends StatefulWidget {
  final FortuneService service;
  final NotificationService notifications;
  final bool isOnboarding;

  /// 온보딩 모드에서 저장 완료 시 호출. (일반 모드에서는 pop 한다.)
  final VoidCallback? onSaved;

  const SettingsScreen({
    super.key,
    required this.service,
    required this.notifications,
    this.isOnboarding = false,
    this.onSaved,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late DateTime _birth = widget.service.birthDate ?? DateTime(1990, 1, 1);
  late bool _notifOn = widget.notifications.enabled;
  late TimeOfDay _notifTime =
      TimeOfDay(hour: widget.notifications.hour, minute: widget.notifications.minute);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      helpText: L10n.of(context).birthDatePickerHelp,
    );
    if (picked != null) setState(() => _birth = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _notifTime,
      helpText: L10n.of(context).notificationTimeHelp,
    );
    if (picked != null) setState(() => _notifTime = picked);
  }

  Future<void> _save() async {
    await widget.service.setBirthDate(_birth);
    await widget.notifications.setEnabled(_notifOn);
    await widget.notifications.setTime(_notifTime.hour, _notifTime.minute);
    if (!mounted) return;
    if (widget.isOnboarding) {
      // 첫 실행 온보딩에서는 광고 없이 바로 진입.
      widget.onSaved?.call();
    } else {
      // 설정 저장 시 전면 광고 → 닫히면 이전 화면으로.
      AdManager.instance.showInterstitialThen(() {
        if (mounted) Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final lang = AppLang.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final zi = FortuneData.zodiacIndex(_birth.year);
    final cardShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isOnboarding ? l.onboardingTitle : l.settingsTitle),
        automaticallyImplyLeading: !widget.isOnboarding,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (widget.isOnboarding) ...[
            const SizedBox(height: 16),
            Text(l.onboardingHeadline,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(l.onboardingBody,
                style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 24),
          ],

          // ── 생년월일 ────────────────────────────────────────────
          Text(l.birthDateSection, style: theme.textTheme.labelLarge?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: cs.surfaceContainerHigh,
            shape: cardShape,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: Text(FortuneData.zodiacEmoji[zi], style: const TextStyle(fontSize: 36)),
              title: Text(DateFormat.yMMMMd(lang).format(_birth)),
              subtitle: Text(l.zodiacLabel(FortuneData.zodiacAnimals[zi].of(lang))),
              trailing: const Icon(Icons.edit_calendar_outlined),
              onTap: _pickDate,
            ),
          ),
          const SizedBox(height: 28),

          // ── 알림 ────────────────────────────────────────────────
          Text(l.notificationSection, style: theme.textTheme.labelLarge?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: cs.surfaceContainerHigh,
            shape: cardShape,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: Text(l.notificationToggleTitle),
                  subtitle: Text(l.notificationToggleSubtitle),
                  value: _notifOn,
                  onChanged: (v) => setState(() => _notifOn = v),
                ),
                if (_notifOn)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: const Icon(Icons.schedule_outlined),
                    title: Text(l.notificationTime),
                    trailing: Text(
                      _notifTime.format(context),
                      style: theme.textTheme.titleMedium?.copyWith(color: cs.primary),
                    ),
                    onTap: _pickTime,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: Text(widget.isOnboarding ? l.goSeeFortune : l.save),
          ),
        ],
      ),
    );
  }
}
