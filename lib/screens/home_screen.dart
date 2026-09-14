import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../ads/ad_manager.dart';
import '../services/fortune_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/star_rating.dart';
import 'detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final FortuneService service;
  const HomeScreen({super.key, required this.service});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DailyFortune _fortune;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final now = DateTime.now();
    _fortune = widget.service.fortuneFor(DateTime(now.year, now.month, now.day));
  }

  Future<void> _openDetail() async {
    // 전면 광고 → 닫히면 상세 화면 진입. 광고 없으면 바로 진입.
    AdManager.instance.showInterstitialThen(() async {
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DetailScreen(service: widget.service, fortune: _fortune),
        ),
      );
      // 상세 화면에서 "다시 뽑기"를 했을 수 있으니 갱신.
      if (mounted) setState(_refresh);
    });
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingsScreen(service: widget.service)),
    );
    if (mounted) setState(_refresh);
  }

  void _share() {
    final f = _fortune;
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
    final f = _fortune;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dateLabel = DateFormat('yyyy년 M월 d일 EEEE', 'ko').format(f.date);

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 운세'),
        actions: [
          IconButton(onPressed: _share, icon: const Icon(Icons.share_outlined), tooltip: '공유'),
          IconButton(onPressed: _openSettings, icon: const Icon(Icons.settings_outlined), tooltip: '설정'),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(dateLabel, style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 12),

          // ── 총운 카드 ──────────────────────────────────────────
          Card(
            elevation: 0,
            color: cs.primaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(f.zodiacEmoji, style: const TextStyle(fontSize: 56)),
                  const SizedBox(height: 4),
                  Text('${f.zodiacName}띠',
                      style: theme.textTheme.titleMedium?.copyWith(color: cs.onPrimaryContainer)),
                  const SizedBox(height: 16),
                  Text('${f.percent}',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onPrimaryContainer,
                        height: 1,
                      )),
                  Text('운세 지수',
                      style: theme.textTheme.labelLarge?.copyWith(color: cs.onPrimaryContainer)),
                  const SizedBox(height: 12),
                  StarRating(score: f.overallScore, size: 28),
                  const SizedBox(height: 16),
                  Text(
                    f.byCategory['총운']!.text,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(color: cs.onPrimaryContainer, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── 행운 아이템 ─────────────────────────────────────────
          Row(
            children: [
              _LuckyTile(label: '행운의 숫자', value: '${f.luckyNumber}', icon: Icons.tag),
              const SizedBox(width: 10),
              _LuckyTile(label: '행운의 색', value: f.luckyColor, icon: Icons.palette_outlined),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _LuckyTile(label: '행운의 아이템', value: f.luckyItem, icon: Icons.card_giftcard_outlined),
              const SizedBox(width: 10),
              _LuckyTile(label: '행운의 방향', value: f.luckyDirection, icon: Icons.explore_outlined),
            ],
          ),
          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: _openDetail,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('상세 운세 보기'),
          ),
          const SizedBox(height: 24),

          // ── 오늘의 명언 ─────────────────────────────────────────
          Text('오늘의 명언', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: cs.surfaceContainerHighest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote_rounded, color: cs.primary, size: 32),
                  const SizedBox(height: 8),
                  Text(f.quote.text,
                      style: theme.textTheme.titleMedium?.copyWith(height: 1.5)),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('— ${f.quote.author}',
                        style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }
}

class _LuckyTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _LuckyTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: cs.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
                  Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
