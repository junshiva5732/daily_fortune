import 'package:flutter/material.dart';

import '../ads/ad_manager.dart';
import '../data/fortunes.dart';
import '../services/fortune_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/star_rating.dart';

class DetailScreen extends StatefulWidget {
  final FortuneService service;
  final DailyFortune fortune;
  const DetailScreen({super.key, required this.service, required this.fortune});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late DailyFortune _fortune = widget.fortune;

  static const _icons = {
    '총운': Icons.wb_sunny_outlined,
    '애정운': Icons.favorite_outline,
    '금전운': Icons.savings_outlined,
    '직장·학업운': Icons.work_outline,
    '건강운': Icons.monitor_heart_outlined,
  };

  /// 보상형 광고를 본 사용자에게 운세를 한 번 더 뽑아준다.
  Future<void> _reroll() async {
    final shown = AdManager.instance.showRewarded(onReward: () async {
      await widget.service.reroll(_fortune.date);
      if (!mounted) return;
      setState(() => _fortune = widget.service.fortuneFor(_fortune.date));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('새로운 운세가 도착했어요 ✨')),
      );
    });
    if (!shown && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('광고를 준비 중입니다. 잠시 후 다시 시도해주세요.')),
      );
      AdManager.instance.loadRewarded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final f = _fortune;

    return Scaffold(
      appBar: AppBar(title: Text('${f.zodiacName}띠 상세 운세')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          for (final category in FortuneData.categories) ...[
            _CategoryCard(
              icon: _icons[category]!,
              title: category,
              line: f.byCategory[category]!,
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _reroll,
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('광고 보고 운세 다시 뽑기'),
          ),
          const SizedBox(height: 8),
          Text(
            '마음에 들지 않는 운세라면 짧은 광고를 보고 한 번 더 뽑을 수 있어요.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final FortuneLine line;
  const _CategoryCard({required this.icon, required this.title, required this.line});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Card(
      elevation: 0,
      color: cs.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: cs.primary),
                const SizedBox(width: 10),
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                StarRating(score: line.score, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Text(line.text, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
          ],
        ),
      ),
    );
  }
}
