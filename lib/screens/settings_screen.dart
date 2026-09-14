import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/fortunes.dart';
import '../services/fortune_service.dart';

/// 생년월일 설정 화면. 첫 실행 시 온보딩으로도 쓰인다.
class SettingsScreen extends StatefulWidget {
  final FortuneService service;
  final bool isOnboarding;
  const SettingsScreen({super.key, required this.service, this.isOnboarding = false});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late DateTime _birth = widget.service.birthDate ?? DateTime(1990, 1, 1);

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

  Future<void> _save() async {
    await widget.service.setBirthDate(_birth);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final zi = FortuneData.zodiacIndex(_birth.year);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isOnboarding ? '시작하기' : '설정'),
        automaticallyImplyLeading: !widget.isOnboarding,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.isOnboarding) ...[
              const SizedBox(height: 24),
              Text('생년월일을 알려주세요',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('띠와 생일을 기준으로 매일 다른 운세를 보여드려요.\n입력한 정보는 기기에만 저장됩니다.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 32),
            ],
            Card(
              elevation: 0,
              color: cs.surfaceContainerHigh,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Text(FortuneData.zodiacEmoji[zi], style: const TextStyle(fontSize: 36)),
                title: Text(DateFormat('yyyy년 M월 d일').format(_birth)),
                subtitle: Text('${FortuneData.zodiacAnimals[zi]}띠'),
                trailing: const Icon(Icons.edit_calendar_outlined),
                onTap: _pickDate,
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: Text(widget.isOnboarding ? '운세 보러 가기' : '저장'),
            ),
          ],
        ),
      ),
    );
  }
}
