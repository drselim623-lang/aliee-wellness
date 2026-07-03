import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/api/chat_service.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/chat.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/botanical_scaffold.dart';

/// Doktoruma Sor — üstte doktor listesi (yatay scroll), altta mevcut konuşmalar.
/// Doktora tıklayınca bu misafirin o doktorla açık konuşması varsa onu açar,
/// yoksa yeni sohbet başlatır (chat ekranına new_ prefix ile).
class ConversationsListScreen extends StatelessWidget {
  const ConversationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return BotanicalScaffold(
      appBar: AppBar(
        title: Text(l.askDoctorTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  l.ourMedicalTeam,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _DoctorsHorizontal(
                onDoctorTap: (doctor) =>
                    _openChatWithDoctor(context, doctor),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  l.myConversations,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            const _ConversationsSliver(),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Future<void> _openChatWithDoctor(
    BuildContext context,
    Doctor doctor,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Bu misafirin bu doktorla açık bir konuşması var mı?
    final snap = await FirebaseFirestore.instance
        .collection('questions')
        .where('guestId', isEqualTo: uid)
        .where('doctorId', isEqualTo: doctor.id)
        .limit(1)
        .get();

    if (!context.mounted) return;
    if (snap.docs.isNotEmpty) {
      // Mevcut konuşmayı aç
      context.push(
        AppRoutes.guestChat.replaceFirst(':questionId', snap.docs.first.id),
      );
    } else {
      // Yeni sohbet başlat
      context.push(
        AppRoutes.guestChat.replaceFirst(':questionId', 'new_${doctor.id}'),
      );
    }
  }
}

class _DoctorsHorizontal extends StatelessWidget {
  final void Function(Doctor doctor) onDoctorTap;
  const _DoctorsHorizontal({required this.onDoctorTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Doctor>>(
      stream: ChatService.instance.activeDoctorsStream(),
      builder: (context, snap) {
        final l = AppL10n.of(context);
        if (snap.hasError) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Text('${l.error}: ${snap.error}'),
          );
        }
        if (!snap.hasData) {
          return const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final doctors = snap.data!;
        if (doctors.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              l.noConversationsHint,
              style: const TextStyle(color: AppColors.inkSoft),
            ),
          );
        }
        return SizedBox(
          height: 172,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: doctors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _DoctorCard(
              doctor: doctors[i],
              onTap: () => onDoctorTap(doctors[i]),
            ),
          ),
        );
      },
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;
  const _DoctorCard({required this.doctor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.sage.withValues(alpha: 0.28),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.sageDark.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _initials(doctor),
                      style: const TextStyle(
                        color: AppColors.sageDark,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  doctor.displayName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.ink,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                if (doctor.specialty.isNotEmpty)
                  Text(
                    doctor.specialty,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _initials(Doctor d) {
    final a = d.firstName.isNotEmpty ? d.firstName[0] : '';
    final b = d.lastName.isNotEmpty ? d.lastName[0] : '';
    return (a + b).toUpperCase();
  }
}

class _ConversationsSliver extends StatelessWidget {
  const _ConversationsSliver();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Question>>(
      stream: ChatService.instance.guestQuestionsStream(),
      builder: (context, snap) {
        final l = AppL10n.of(context);
        if (snap.hasError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('${l.error}: ${snap.error}'),
            ),
          );
        }
        if (!snap.hasData) {
          return const SliverToBoxAdapter(
            child: Center(child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            )),
          );
        }
        final questions = snap.data!;
        if (questions.isEmpty) {
          return const SliverToBoxAdapter(child: _EmptyHint());
        }
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          sliver: SliverList.separated(
            itemCount: questions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) =>
                _ConversationTile(question: questions[i]),
          ),
        );
      },
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.creamSoft.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.sageDark),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l.noConversationsHint,
                style: const TextStyle(color: AppColors.inkSoft),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Question question;
  const _ConversationTile({required this.question});

  @override
  Widget build(BuildContext context) {
    final unread = question.unreadForGuest;
    final time = question.lastMessageAt;
    return Card(
      child: ListTile(
        onTap: () => context.push(
          AppRoutes.guestChat.replaceFirst(':questionId', question.id),
        ),
        leading: CircleAvatar(
          backgroundColor: AppColors.sage.withValues(alpha: 0.28),
          child: const Icon(
            Icons.medical_services_outlined,
            color: AppColors.sageDark,
          ),
        ),
        title: Text(
          question.doctorName.isEmpty ? '—' : question.doctorName,
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
