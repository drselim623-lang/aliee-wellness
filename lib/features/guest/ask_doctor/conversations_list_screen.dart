import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/api/chat_service.dart';
import '../../../core/models/chat.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/botanical_scaffold.dart';

class ConversationsListScreen extends StatelessWidget {
  const ConversationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BotanicalScaffold(
      appBar: AppBar(
        title: const Text('Doktoruma Sor'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.guestPickDoctor),
        icon: const Icon(Icons.chat_bubble_outline),
        label: const Text('Yeni Soru'),
        backgroundColor: AppColors.sageDark,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
        ),
        child: StreamBuilder<List<Question>>(
          stream: ChatService.instance.guestQuestionsStream(),
          builder: (context, snap) {
            if (snap.hasError) {
              return Center(child: Text('Yüklenemedi: ${snap.error}'));
            }
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final questions = snap.data!;
            if (questions.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Henüz soru sormadın.\nAlttaki butona basarak yeni soru başlatabilirsin.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: questions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final q = questions[i];
                return _ConversationTile(question: q, isGuest: true);
              },
            );
          },
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Question question;
  final bool isGuest;
  const _ConversationTile({required this.question, required this.isGuest});

  @override
  Widget build(BuildContext context) {
    final unread = isGuest ? question.unreadForGuest : question.unreadForDoctor;
    final title = isGuest ? question.doctorName : question.guestName;
    final time = question.lastMessageAt;
    return Card(
      child: ListTile(
        onTap: () => context.push(
          AppRoutes.guestChat.replaceFirst(':questionId', question.id),
        ),
        leading: CircleAvatar(
          backgroundColor: AppColors.sage.withValues(alpha: 0.3),
          child: Icon(
            isGuest ? Icons.medical_services_outlined : Icons.person_outline,
            color: AppColors.sageDark,
          ),
        ),
        title: Text(
          title.isEmpty ? '—' : title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          question.lastMessagePreview,
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
                style: const TextStyle(fontSize: 12, color: AppColors.inkSoft),
              ),
            const SizedBox(height: 4),
            if (unread > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.terracotta,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unread',
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
  }
}
