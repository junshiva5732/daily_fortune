import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../services/fortune_service.dart';
import '../widgets/star_rating.dart';

/// 운세를 예쁜 카드 이미지로 만들어 공유하는 화면.
/// 카드 위젯을 RepaintBoundary 로 감싸 PNG 로 캡처한 뒤 share_plus 로 넘긴다.
class ShareCardScreen extends StatefulWidget {
  final DailyFortune fortune;
  const ShareCardScreen({super.key, required this.fortune});

  @override
  State<ShareCardScreen> createState() => _ShareCardScreenState();
}

class _ShareCardScreenState extends State<ShareCardScreen> {
  final _cardKey = GlobalKey();
  bool _busy = false;

  Future<void> _shareImage() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final boundary =
          _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/fortune_${widget.fortune.date.toIso8601String().substring(0, 10)}.png');
      await file.writeAsBytes(bytes!.buffer.asUint8List());

      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path, mimeType: 'image/png')],
        text: '오늘의 운세 ✨',
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _shareText() {
    final f = widget.fortune;
    final date = DateFormat('M월 d일').format(f.date);
    final text = '📅 $date 오늘의 운세 (${f.zodiacName}띠)\n'
        '${'⭐' * f.overallScore} 운세 지수 ${f.percent}점\n\n'
        '${f.byCategory['총운']!.text}\n\n'
        '🍀 행운의 숫자 ${f.luckyNumber} · ${f.luckyColor} · ${f.luckyItem}\n\n'
        '"${f.quote.text}" - ${f.quote.author}';
    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('공유하기')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: RepaintBoundary(
                  key: _cardKey,
                  child: _FortuneCard(fortune: widget.fortune),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: _busy ? null : _shareImage,
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    icon: _busy
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.image_outlined),
                    label: const Text('이미지로 공유'),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _shareText,
                    icon: const Icon(Icons.text_fields),
                    label: const Text('텍스트로 공유'),
                  ),
                  Text(
                    '카카오톡, 인스타그램 스토리, 문자 등으로 보낼 수 있어요',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 공유용 카드. 앱 테마와 무관하게 고정 색상(보라 그라데이션)으로 그린다.
class _FortuneCard extends StatelessWidget {
  final DailyFortune fortune;
  const _FortuneCard({required this.fortune});

  static const _cream = Color(0xFFFFF6D6);
  static const _gold = Color(0xFFFFD656);

  @override
  Widget build(BuildContext context) {
    final f = fortune;
    final date = DateFormat('yyyy년 M월 d일 EEEE', 'ko').format(f.date);
    final total = f.byCategory['총운']!;

    return Container(
      width: 340,
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7654C4), Color(0xFF3A226E)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(date, style: const TextStyle(color: Color(0xFFD9CCFF), fontSize: 13)),
          const SizedBox(height: 16),
          Text(f.zodiacEmoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 4),
          Text('${f.zodiacName}띠 오늘의 운세',
              style: const TextStyle(color: _cream, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Text('${f.percent}',
              style: const TextStyle(color: _cream, fontSize: 64, fontWeight: FontWeight.w800, height: 1)),
          const Text('운세 지수', style: TextStyle(color: Color(0xFFD9CCFF), fontSize: 13)),
          const SizedBox(height: 10),
          StarRating(score: total.score, size: 26, color: _gold),
          const SizedBox(height: 16),
          Text(
            total.text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _cream, fontSize: 15, height: 1.55),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Lucky(label: '행운의 숫자', value: '${f.luckyNumber}'),
                _Lucky(label: '행운의 색', value: f.luckyColor),
                _Lucky(label: '아이템', value: f.luckyItem),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '"${f.quote.text}"',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFE8E0FF), fontSize: 13, fontStyle: FontStyle.italic, height: 1.5),
          ),
          const SizedBox(height: 4),
          Text('— ${f.quote.author}', style: const TextStyle(color: Color(0xFFB8A8E8), fontSize: 12)),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('🌙', style: TextStyle(fontSize: 14)),
              SizedBox(width: 6),
              Text('오늘의 운세 앱', style: TextStyle(color: Color(0xFFB8A8E8), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Lucky extends StatelessWidget {
  final String label;
  final String value;
  const _Lucky({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFB8A8E8), fontSize: 11)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(color: _FortuneCard._cream, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
