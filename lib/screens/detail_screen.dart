import 'package:flutter/material.dart';

import '../data/fortunes.dart';
import '../services/fortune_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/star_rating.dart';

class DetailScreen extends StatelessWidget {
  final DailyFortune fortune;
  const DetailScreen({super.key, required this.fortune});

  static const _icons = {
    '총운': Icons.wb_sunny_outlined,
    '애정운': Icons.favorite_outline,
    '금전운': Icons.savings_outlined,
    '직장·학업운': Icons.work_outline,
    '건강운': Icons.monitor_heart_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final f = fortune;

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
          Text(
            '운세는 재미로 보는 콘텐츠예요. 오늘도 좋은 하루 보내세요 🌙',
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
