import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/fortunes.dart';
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
      locale: const Locale('ko'),
      helpText: '생년월일 선택',
    );
    if (picked != null) setState(() => _birth = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _notifTime,
      helpText: '알림 시간',
    );
    if (picked != null) setState(() => _notifTime = picked);
  }

  Future<void> _save() async {
    await widget.service.setBirthDate(_birth);
    await widget.notifications.setEnabled(_notifOn);
    await widget.notifications.setTime(_notifTime.hour, _notifTime.minute);
    if (!mounted) return;
    if (widget.isOnboarding) {
      widget.onSaved?.call();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final zi = FortuneData.zodiacIndex(_birth.year);
    final cardShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isOnboarding ? '시작하기' : '설정'),
        automaticallyImplyLeading: !widget.isOnboarding,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (widget.isOnboarding) ...[
            const SizedBox(height: 16),
            Text('생년월일을 알려주세요',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('띠와 생일을 기준으로 매일 다른 운세를 보여드려요.\n입력한 정보는 기기에만 저장됩니다.',
                style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 24),
          ],

          // ── 생년월일 ────────────────────────────────────────────
          Text('생년월일', style: theme.textTheme.labelLarge?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: cs.surfaceContainerHigh,
            shape: cardShape,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: Text(FortuneData.zodiacEmoji[zi], style: const TextStyle(fontSize: 36)),
              title: Text(DateFormat('yyyy년 M월 d일').format(_birth)),
              subtitle: Text('${FortuneData.zodiacAnimals[zi]}띠'),
              trailing: const Icon(Icons.edit_calendar_outlined),
              onTap: _pickDate,
            ),
          ),
          const SizedBox(height: 28),

          // ── 알림 ────────────────────────────────────────────────
          Text('아침 알림', style: theme.textTheme.labelLarge?.copyWith(color: cs.onSurfaceVariant)),
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
                  title: const Text('매일 운세 알림'),
                  subtitle: const Text('오늘의 운세 지수와 총운을 알려드려요'),
                  value: _notifOn,
                  onChanged: (v) => setState(() => _notifOn = v),
                ),
                if (_notifOn)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: const Icon(Icons.schedule_outlined),
                    title: const Text('알림 시간'),
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
            child: Text(widget.isOnboarding ? '운세 보러 가기' : '저장'),
          ),
        ],
      ),
    );
  }
}
