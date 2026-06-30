import 'package:flutter/material.dart';

import '../../../core/data/services_seed.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/botanical_scaffold.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final isTr = Localizations.localeOf(context).languageCode == 'tr';
    return DefaultTabController(
      length: ServiceCategory.values.length,
      child: BotanicalScaffold(
        appBar: AppBar(
          title: Text(l.services),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (final c in ServiceCategory.values)
                Tab(text: isTr ? c.trLabel : c.enLabel),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top +
                kToolbarHeight +
                kTextTabBarHeight,
          ),
          child: TabBarView(
            children: [
              for (final c in ServiceCategory.values) _CategoryList(category: c),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  final ServiceCategory category;
  const _CategoryList({required this.category});

  @override
  Widget build(BuildContext context) {
    final isTr = Localizations.localeOf(context).languageCode == 'tr';
    final services =
        kServicesSeed.where((s) => s.category == category).toList();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final s = services[i];
        final name = isTr ? s.nameTr : s.nameEn;
        final desc = isTr ? s.descriptionTr : s.descriptionEn;
        return Card(
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            title: Text(name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.ink)),
            subtitle: desc != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(desc,
                        style: const TextStyle(color: AppColors.inkSoft)),
                  )
                : null,
          ),
        );
      },
    );
  }
}
