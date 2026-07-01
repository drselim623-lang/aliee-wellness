import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/widgets/botanical_scaffold.dart';
import '../../core/widgets/feature_card.dart';

class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return BotanicalScaffold(
      appBar: AppBar(
        title: Text(l.guestHomeTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          20,
          MediaQuery.of(context).padding.top + kToolbarHeight + 8,
          20,
          20,
        ),
        children: [
          FeatureCard(
            icon: Icons.favorite_outline,
            title: l.discoverHealth,
            description: l.discoverHealthDesc,
            onTap: () => context.push(AppRoutes.guestAnamnesis),
          ),
          const SizedBox(height: 12),
          FeatureCard(
            icon: Icons.grid_view_outlined,
            title: l.services,
            description: l.servicesDesc,
            onTap: () => context.push(AppRoutes.guestServices),
          ),
          const SizedBox(height: 12),
          FeatureCard(
            icon: Icons.chat_bubble_outline,
            title: l.askDoctor,
            description: l.askDoctorDesc,
            onTap: () => context.push(AppRoutes.guestAskDoctor),
          ),
          const SizedBox(height: 12),
          FeatureCard(
            icon: Icons.event_available_outlined,
            title: l.planStay,
            description: l.planStayDesc,
            onTap: () {/* TODO: konaklama başvurusu */},
          ),
        ],
      ),
    );
  }
}
