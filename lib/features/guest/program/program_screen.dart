import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/anamnesis_service.dart';
import '../../../core/data/services_seed.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/service.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/botanical_scaffold.dart';

class ProgramScreen extends StatelessWidget {
  const ProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final isTr = Localizations.localeOf(context).languageCode == 'tr';

    return BotanicalScaffold(
      appBar: AppBar(
        title: Text(l.programTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<AnamnesisResult?>(
        stream: AnamnesisService.instance.myRecommendationStream(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Text('${l.error}: ${snap.error}'),
            );
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final result = snap.data;
          if (result == null || result.recommendations.isEmpty) {
            return _emptyState(context, l);
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    MediaQuery.of(context).padding.top + kToolbarHeight + 8,
                    20,
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.programTitle,
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        l.programSubtitle,
                        style: const TextStyle(color: AppColors.inkSoft),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList.separated(
                  itemCount: result.recommendations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final rec = result.recommendations[i];
                    final service = _findService(rec.serviceId);
                    if (service == null) return const SizedBox.shrink();
                    return _RecommendationCard(
                      service: service,
                      reasons: rec.reasons,
                      isTr: isTr,
                      whyRecommendedLabel: l.whyRecommended,
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: OutlinedButton.icon(
                    onPressed: () => context.push(AppRoutes.guestAnamnesis),
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(l.updateAnamnesis),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _emptyState(BuildContext context, AppL10n l) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_outline,
                size: 48, color: AppColors.sageDark),
            const SizedBox(height: 12),
            Text(
              l.programEmptyText,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.inkSoft),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.go(AppRoutes.guestAnamnesis),
              icon: const Icon(Icons.play_arrow_outlined),
              label: Text(l.discoverHealth),
            ),
          ],
        ),
      ),
    );
  }

  WellnessService? _findService(String id) {
    try {
      return kServicesSeed.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}

class _RecommendationCard extends StatelessWidget {
  final WellnessService service;
  final List<String> reasons;
  final bool isTr;
  final String whyRecommendedLabel;
  const _RecommendationCard({
    required this.service,
    required this.reasons,
    required this.isTr,
    required this.whyRecommendedLabel,
  });

  @override
  Widget build(BuildContext context) {
    final name = isTr ? service.nameTr : service.nameEn;
    final desc = isTr ? service.descriptionTr : service.descriptionEn;
    final category = isTr ? service.category.trLabel : service.category.enLabel;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(
          AppRoutes.guestServiceDetail.replaceFirst(':serviceId', service.id),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.sage.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.sageDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right,
                      color: AppColors.inkSoft, size: 20),
                ],
              ),
              const SizedBox(height: 10),
              Text(name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.ink,
                  )),
              if (desc != null && desc.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(desc,
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 13,
                    )),
              ],
              if (reasons.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(whyRecommendedLabel.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.inkSoft,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 6),
                ...reasons.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(Icons.check_circle_outline,
                              size: 14, color: AppColors.sageDark),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(r,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.ink,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
