import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/api/auth_service.dart';
import '../../core/api/chat_service.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/chat.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/botanical_scaffold.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return BotanicalScaffold(
      appBar: AppBar(
        title: Text(l.doctorHomeTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: l.signOut,
            onPressed: () async {
              await AuthService.instance.signOut();
              if (context.mounted) context.go(AppRoutes.root);
            },
            icon: const Icon(Icons.logout, color: AppColors.sageDark),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
        ),
        child: StreamBuilder<List<Question>>(
          stream: ChatService.instance.doctorQuestionsStream(),
          builder: (context, snap) {
            if (snap.hasError) {
              return Center(child: Text('${l.loadFailed}: ${snap.error}'));
            }
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final qs = snap.data!;
            if (qs.isEmpty) {
              return Center(child: Text(l.noQuestionsYet));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: qs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final q = qs[i];
                final time = q.lastMessageAt;
                return Card(
                  child: ListTile(
                    onTap: () => context.push(
                      AppRoutes.doctorChat
                          .replaceFirst(':questionId', q.id),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.sage.withValues(alpha: 0.3),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColors.sageDark,
                      ),
                    ),
                    title: Text(
                      q.guestName.isEmpty ? '—' : q.guestName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      q.lastMessagePreview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (time != null)
                          Text(
                            DateFormat('HH:mm').format(time),
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.inkSoft),
                          ),
                        const SizedBox(height: 4),
                        if (q.unreadForDoctor > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.terracotta,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${q.unreadForDoctor}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
