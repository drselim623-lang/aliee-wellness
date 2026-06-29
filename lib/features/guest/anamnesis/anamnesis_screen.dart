import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

/// Bölümlü anamnez formu (3 step) — hibrit yaklaşım.
/// İlk sürüm: UI iskelet + lokal state. Gönderim Cloud Function üzerinden olacak.
class AnamnesisScreen extends StatefulWidget {
  const AnamnesisScreen({super.key});

  @override
  State<AnamnesisScreen> createState() => _AnamnesisScreenState();
}

class _AnamnesisScreenState extends State<AnamnesisScreen> {
  int _step = 0;

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _submit() async {
    // TODO: Cloud Function call — anamnez kayıt + program önerisi tetikleme.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anamnez gönderildi (stub)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final body = switch (_step) {
      0 => const _GeneralHistoryStep(),
      1 => const _LifestyleStep(),
      _ => const _ComplaintGoalStep(),
    };
    return Scaffold(
      appBar: AppBar(title: Text(l.discoverHealth)),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_step + 1) / 3,
            backgroundColor: AppColors.line,
            color: AppColors.sageDark,
          ),
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: body,
          )),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _back,
                        child: const Text('Geri'),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _next,
                      child: Text(_step < 2 ? 'İleri' : 'Gönder'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneralHistoryStep extends StatelessWidget {
  const _GeneralHistoryStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Genel sağlık öyküsü',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text(
            'Bilinen hastalıklar, kullandığınız ilaçlar, alerjiler ve aile öykünüz.'),
        const SizedBox(height: 24),
        const _LabeledField(label: 'Bilinen kronik hastalıklar'),
        const _LabeledField(label: 'Kullandığınız ilaçlar'),
        const _LabeledField(label: 'Bilinen alerjiler'),
        const _LabeledField(label: 'Aile öyküsü (kalp, kanser, diyabet vb.)'),
        const _LabeledField(label: 'Geçirilmiş ameliyatlar'),
        const SizedBox(height: 16),
        const _LabUploadCard(),
      ],
    );
  }
}

class _LifestyleStep extends StatelessWidget {
  const _LifestyleStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Yaşam tarzı',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('Uyku, beslenme, egzersiz ve stres alışkanlıklarınız.'),
        const SizedBox(height: 24),
        const _LabeledField(label: 'Ortalama uyku saati (sayı)'),
        const _LabeledField(label: 'Uyku kaliteniz (kötü / orta / iyi)'),
        const _LabeledField(label: 'Beslenme tipi (omnivor / vejetaryen / vegan / keto / diğer)'),
        const _LabeledField(label: 'Haftada kaç gün egzersiz?'),
        const _LabeledField(label: 'Alkol sıklığı (yok / nadiren / haftalık / günlük)'),
        const _LabeledField(label: 'Algıladığınız stres (1-10)'),
      ],
    );
  }
}

class _ComplaintGoalStep extends StatelessWidget {
  const _ComplaintGoalStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Şikayet ve hedef',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('Şu anki yakınmalarınız ve longevity programından beklentiniz.'),
        const SizedBox(height: 24),
        const _LabeledField(label: 'Mevcut şikayetleriniz'),
        const _LabeledField(label: 'Hedefleriniz (enerji, anti-aging, kilo, uyku, biliş…)'),
        const _LabeledField(label: 'Eklemek istediğiniz başka bir şey', maxLines: 5),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final int maxLines;
  const _LabeledField({required this.label, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _LabUploadCard extends StatelessWidget {
  const _LabUploadCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.upload_file_outlined, color: AppColors.sageDark),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                  'Geçmiş laboratuvar kayıtlarınız varsa yükleyin (PDF / foto).'),
            ),
            FilledButton.tonal(
              onPressed: () {
                // TODO: file_picker + Firebase Storage upload (after Firebase setup)
              },
              child: const Text('Yükle'),
            ),
          ],
        ),
      ),
    );
  }
}
