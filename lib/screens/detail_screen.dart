import 'package:flutter/material.dart';

import '../data/fortunes.dart';
import '../l10n/app_localizations.dart';
import '../l10n/lang.dart';
import '../services/fortune_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/star_rating.dart';

class DetailScreen extends StatelessWidget {
  final DailyFortune fortune;
  const DetailScreen({super.key, required this.fortune});

  static const _icons = {
    Category.overall: Icons.wb_sunny_outlined,
    Category.love: Icons.favorite_outline,
    Category.money: Icons.savings_outlined,
    Category.work: Icons.work_outline,
    Category.health: Icons.monitor_heart_outlined,
  };

  static String categoryName(L10n l, Category c) => switch (c) {
        Category.overall => l.catOverall,
        Category.love => l.catLove,
        Category.money => l.catMoney,
        Category.work => l.catWork,
        Category.health => l.catHealth,
      };

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final lang = AppLang.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final f = fortune;

    return Scaffold(
      appBar: AppBar(title: Text(l.detailTitle(l.zodiacLabel(f.zodiacAnimal.of(lang))))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          for (final category in Category.values) ...[
            _CategoryCard(
              icon: _icons[category]!,
              title: categoryName(l, category),
              line: f.byCategory[category]!,
              lang: lang,
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          Text(
            l.detailFooter,
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
  final String lang;
  const _CategoryCard({required this.icon, required this.title, required this.line, required this.lang});

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
                Expanded(
                  child: Text(title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ),
                StarRating(score: line.score, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Text(line.text.of(lang), style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
          ],
        ),
      ),
    );
  }
}
