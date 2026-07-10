import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/widgets/botanical_scaffold.dart';
import '../../core/widgets/image_tile.dart';

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
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.of(context).padding.top + kToolbarHeight + 8,
          16,
          16,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tiles = [
              ImageTile(
                imagePath: 'assets/images/home_discover_health.jpg',
                title: l.discoverHealth,
                subtitle: l.discoverHealthDesc,
                fallbackIcon: Icons.favorite_outline,
                onTap: () => context.push(AppRoutes.guestAnamnesis),
              ),
              ImageTile(
                imagePath: 'assets/images/home_services.jpg',
                title: l.services,
                subtitle: l.servicesDesc,
                fallbackIcon: Icons.grid_view_outlined,
                onTap: () => context.push(AppRoutes.guestServices),
              ),
              ImageTile(
                imagePath: 'assets/images/home_ask_doctor.jpg',
                title: l.askDoctor,
                subtitle: l.askDoctorDesc,
                fallbackIcon: Icons.chat_bubble_outline,
                onTap: () => context.push(AppRoutes.guestAskDoctor),
              ),
              ImageTile(
                imagePath: 'assets/images/home_plan_stay.jpg',
                title: l.planStay,
                subtitle: l.planStayDesc,
                fallbackIcon: Icons.event_available_outlined,
                onTap: () {/* TODO: konaklama başvurusu */},
              ),
            ];

            // Geniş ekran (web/tablet): 2x2 grid, dar ekran: 4 dikey kart.
            // Her iki düzen de sayfayı tamamen doldurur.
            if (constraints.maxWidth > 700) {
              return Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: tiles[0]),
                        const SizedBox(width: 12),
                        Expanded(child: tiles[1]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: tiles[2]),
                        const SizedBox(width: 12),
                        Expanded(child: tiles[3]),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                for (var i = 0; i < tiles.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  Expanded(child: tiles[i]),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
