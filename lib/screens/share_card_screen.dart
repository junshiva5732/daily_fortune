import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import '../l10n/lang.dart';
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

      if (!mounted) return;
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path, mimeType: 'image/png')],
        text: L10n.of(context).shareImageCaption,
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _shareText() {
    final f = widget.fortune;
    final l = L10n.of(context);
    final lang = AppLang.of(context);
    final date = DateFormat.MMMMd(lang).format(f.date);
    final zodiac = l.zodiacLabel(f.zodiacAnimal.of(lang));
    final text = '${l.shareTextHeader(date, zodiac)}\n'
        '${'⭐' * f.overallScore} ${l.shareTextScore(f.percent)}\n\n'
        '${f.overall.text.of(lang)}\n\n'
        '${l.shareTextLucky(f.luckyNumber, f.luckyColor.of(lang), f.luckyItem.of(lang))}\n\n'
        '"${f.quote.text.of(lang)}" - ${f.quote.author.of(lang)}';
    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = L10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.shareTitle)),
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
                    label: Text(l.shareAsImage),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _shareText,
                    icon: const Icon(Icons.text_fields),
                    label: Text(l.shareAsText),
                  ),
                  Text(
                    l.shareHint,
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
    final l = L10n.of(context);
    final lang = AppLang.of(context);
    final date = DateFormat.yMMMMEEEEd(lang).format(f.date);
    final total = f.overall;

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
          Text(l.shareCardTitle(l.zodiacLabel(f.zodiacAnimal.of(lang))),
              style: const TextStyle(color: _cream, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Text('${f.percent}',
              style: const TextStyle(color: _cream, fontSize: 64, fontWeight: FontWeight.w800, height: 1)),
          Text(l.fortuneIndex, style: const TextStyle(color: Color(0xFFD9CCFF), fontSize: 13)),
          const SizedBox(height: 10),
          StarRating(score: total.score, size: 26, color: _gold),
          const SizedBox(height: 16),
          Text(
            total.text.of(lang),
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
              children: [
                Expanded(child: _Lucky(label: l.luckyNumber, value: '${f.luckyNumber}')),
                Expanded(child: _Lucky(label: l.luckyColor, value: f.luckyColor.of(lang))),
                Expanded(child: _Lucky(label: l.luckyItem, value: f.luckyItem.of(lang))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '"${f.quote.text.of(lang)}"',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFE8E0FF), fontSize: 13, fontStyle: FontStyle.italic, height: 1.5),
          ),
          const SizedBox(height: 4),
          Text('— ${f.quote.author.of(lang)}', style: const TextStyle(color: Color(0xFFB8A8E8), fontSize: 12)),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🌙', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(l.shareAppFooter, style: const TextStyle(color: Color(0xFFB8A8E8), fontSize: 12)),
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
        Text(label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFFB8A8E8), fontSize: 10, height: 1.2)),
        const SizedBox(height: 2),
        Text(value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _FortuneCard._cream, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
