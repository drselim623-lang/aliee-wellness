import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/chat_service.dart';
import '../../../core/models/chat.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/botanical_scaffold.dart';

class PickDoctorScreen extends StatelessWidget {
  const PickDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BotanicalScaffold(
      appBar: AppBar(
        title: const Text('Doktor seç'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
        ),
        child: StreamBuilder<List<Doctor>>(
          stream: ChatService.instance.activeDoctorsStream(),
          builder: (context, snap) {
            if (snap.hasError) {
              return Center(child: Text('Yüklenemedi: ${snap.error}'));
            }
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final doctors = snap.data!;
            if (doctors.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Henüz kayıtlı doktor yok. Lütfen sonra tekrar deneyin.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: doctors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final d = doctors[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.sage.withValues(alpha: 0.3),
                      child: const Icon(
                        Icons.medical_services_outlined,
                        color: AppColors.sageDark,
                      ),
                    ),
                    title: Text(
                      d.displayName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: d.specialty.isEmpty ? null : Text(d.specialty),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      // Chat ekranı yeni bir soru başlatma modu ile açılır.
                      // questionId "new:<doctorId>" olarak encode ederiz.
                      await context.push(
                        AppRoutes.guestChat.replaceFirst(
                          ':questionId',
                          'new_${d.id}',
                        ),
                      );
                    },
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
