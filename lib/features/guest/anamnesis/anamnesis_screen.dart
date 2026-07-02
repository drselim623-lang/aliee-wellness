import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/api/anamnesis_service.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/anamnesis.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/botanical_scaffold.dart';

// Anamnez hibrit yaklaşım: genel öykü + yaşam tarzı + şikayet/hedef.

class AnamnesisScreen extends StatefulWidget {
  const AnamnesisScreen({super.key});

  @override
  State<AnamnesisScreen> createState() => _AnamnesisScreenState();
}

class _AnamnesisScreenState extends State<AnamnesisScreen> {
  int _step = 0;
  bool _submitting = false;

  // --- Step 1: Genel öykü
  final _chronic = TextEditingController();
  final _meds = TextEditingController();
  final _allergies = TextEditingController();
  final _family = TextEditingController();
  final _surgeries = TextEditingController();

  // --- Step 2: Yaşam tarzı
  double _sleepHours = 7;
  String _sleepQuality = 'fair';
  String _dietType = 'omnivore';
  int _exerciseDays = 2;
  bool _smokes = false;
  String _alcoholFreq = 'rarely';
  double _stressLevel = 5;

  // --- Step 3: Şikayet/hedef
  final _complaints = TextEditingController();
  final _goals = TextEditingController();
  final _freeText = TextEditingController();

  final _labs = <_PendingLabUpload>[];
  bool _uploadingLab = false;

  @override
  void dispose() {
    _chronic.dispose();
    _meds.dispose();
    _allergies.dispose();
    _family.dispose();
    _surgeries.dispose();
    _complaints.dispose();
    _goals.dispose();
    _freeText.dispose();
    super.dispose();
  }

  List<String> _splitToList(TextEditingController c) {
    final text = c.text.trim();
    if (text.isEmpty) return const [];
    return text
        .split(RegExp(r'[,;\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _pickAndUploadLab() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galeriden seç'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Kamera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    final xfile = await picker.pickImage(source: source, imageQuality: 90);
    if (xfile == null || !mounted) return;

    setState(() => _uploadingLab = true);
    try {
      final bytes = await xfile.readAsBytes();
      final rec = await AnamnesisService.instance.uploadLab(
        bytes: bytes,
        fileName: xfile.name,
        contentType: xfile.mimeType ?? 'image/jpeg',
      );
      setState(() {
        _labs.add(_PendingLabUpload(fileName: rec.fileName));
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yükleme hatası: $e')),
      );
    } finally {
      if (mounted) setState(() => _uploadingLab = false);
    }
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final answers = AnamnesisAnswers(
        chronicConditions: _splitToList(_chronic),
        currentMedications: _splitToList(_meds),
        allergies: _splitToList(_allergies),
        familyHistory: _splitToList(_family),
        surgeries: _splitToList(_surgeries),
        sleepHoursAvg: _sleepHours.round(),
        sleepQuality: _sleepQuality,
        dietType: _dietType,
        exerciseDaysPerWeek: _exerciseDays,
        smokes: _smokes,
        alcoholFrequency: _alcoholFreq,
        perceivedStress: _stressLevel.round(),
        currentComplaints: _splitToList(_complaints),
        healthGoals: _splitToList(_goals),
        freeText: _freeText.text.trim().isEmpty ? null : _freeText.text.trim(),
        submittedAt: DateTime.now(),
      );
      await AnamnesisService.instance.submit(answers);
      if (!mounted) return;
      context.go(AppRoutes.guestProgram);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gönderilemedi: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final body = switch (_step) {
      0 => _generalHistoryStep(),
      1 => _lifestyleStep(),
      _ => _complaintGoalStep(),
    };
    return BotanicalScaffold(
      appBar: AppBar(
        title: Text(l.discoverHealth),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
          LinearProgressIndicator(
            value: (_step + 1) / 3,
            backgroundColor: AppColors.line,
            color: AppColors.sageDark,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: body,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _submitting
                            ? null
                            : () => setState(() => _step--),
                        child: const Text('Geri'),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _submitting
                          ? null
                          : () {
                              if (_step < 2) {
                                setState(() => _step++);
                              } else {
                                _submit();
                              }
                            },
                      child: _submitting
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(_step < 2 ? 'İleri' : 'Gönder ve öneri al'),
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

  // -----------------------------------------------------------------
  //   STEP 1 — Genel öykü
  // -----------------------------------------------------------------
  Widget _generalHistoryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Genel sağlık öyküsü',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text(
            'Bilinen hastalıklar, kullandığınız ilaçlar, alerjiler ve aile öyküsü. Birden fazlaysa virgülle ayırın.'),
        const SizedBox(height: 20),
        _multiField(
          controller: _chronic,
          label: 'Bilinen kronik hastalıklar',
          hint: 'örn. hipertansiyon, diyabet, tiroit',
        ),
        _multiField(
          controller: _meds,
          label: 'Kullandığınız ilaçlar',
          hint: 'örn. metformin, tiroit ilacı',
        ),
        _multiField(
          controller: _allergies,
          label: 'Bilinen alerjiler',
          hint: 'örn. penisilin, fıstık, polen',
        ),
        _multiField(
          controller: _family,
          label: 'Aile öyküsü (kalp, kanser, diyabet vb.)',
          hint: 'örn. anne — meme kanseri, baba — kalp',
        ),
        _multiField(
          controller: _surgeries,
          label: 'Geçirilmiş ameliyatlar',
          hint: 'örn. safra kesesi ameliyatı, dolgu vb.',
        ),
        const SizedBox(height: 16),
        _labUploadCard(),
      ],
    );
  }

  Widget _multiField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        minLines: 1,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }

  Widget _labUploadCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.upload_file_outlined,
                    color: AppColors.sageDark),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Geçmiş laboratuvar sonuçlarınız varsa yükleyin (foto).',
                  ),
                ),
                FilledButton.tonal(
                  onPressed: _uploadingLab ? null : _pickAndUploadLab,
                  child: _uploadingLab
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Yükle'),
                ),
              ],
            ),
            if (_labs.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _labs
                    .map(
                      (l) => Chip(
                        avatar: const Icon(Icons.check,
                            size: 16, color: AppColors.sageDark),
                        label: Text(l.fileName,
                            style: const TextStyle(fontSize: 12)),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------------
  //   STEP 2 — Yaşam tarzı
  // -----------------------------------------------------------------
  Widget _lifestyleStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Yaşam tarzı',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('Uyku, beslenme, egzersiz ve stres alışkanlıklarınız.'),
        const SizedBox(height: 20),

        _sliderRow(
          label: 'Ortalama uyku saati',
          value: _sleepHours,
          min: 3,
          max: 12,
          divisions: 9,
          onChanged: (v) => setState(() => _sleepHours = v),
          valueDisplay: '${_sleepHours.round()} saat',
        ),
        _choiceRow(
          label: 'Uyku kaliteniz',
          options: const {
            'poor': 'Kötü',
            'fair': 'Orta',
            'good': 'İyi',
          },
          value: _sleepQuality,
          onChanged: (v) => setState(() => _sleepQuality = v),
        ),
        _choiceRow(
          label: 'Beslenme tipi',
          options: const {
            'omnivore': 'Omnivor',
            'vegetarian': 'Vejetaryen',
            'vegan': 'Vegan',
            'keto': 'Keto',
            'other': 'Diğer',
          },
          value: _dietType,
          onChanged: (v) => setState(() => _dietType = v),
        ),
        _sliderRow(
          label: 'Haftada egzersiz günü',
          value: _exerciseDays.toDouble(),
          min: 0,
          max: 7,
          divisions: 7,
          onChanged: (v) => setState(() => _exerciseDays = v.round()),
          valueDisplay: '$_exerciseDays gün',
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Sigara kullanıyorum'),
          value: _smokes,
          onChanged: (v) => setState(() => _smokes = v),
        ),
        _choiceRow(
          label: 'Alkol sıklığı',
          options: const {
            'none': 'Yok',
            'rarely': 'Nadiren',
            'weekly': 'Haftalık',
            'daily': 'Günlük',
          },
          value: _alcoholFreq,
          onChanged: (v) => setState(() => _alcoholFreq = v),
        ),
        _sliderRow(
          label: 'Algıladığınız stres (1-10)',
          value: _stressLevel,
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: (v) => setState(() => _stressLevel = v),
          valueDisplay: '${_stressLevel.round()}',
        ),
      ],
    );
  }

  Widget _sliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String valueDisplay,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(valueDisplay,
                  style: const TextStyle(
                      color: AppColors.sageDark, fontWeight: FontWeight.w600)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: AppColors.sageDark,
          ),
        ],
      ),
    );
  }

  Widget _choiceRow({
    required String label,
    required Map<String, String> options,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(label),
          ),
          Wrap(
            spacing: 8,
            children: options.entries.map((entry) {
              final selected = value == entry.key;
              return ChoiceChip(
                label: Text(entry.value),
                selected: selected,
                onSelected: (_) => onChanged(entry.key),
                selectedColor: AppColors.sage.withValues(alpha: 0.35),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  //   STEP 3 — Şikayet / hedef
  // -----------------------------------------------------------------
  Widget _complaintGoalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Şikayet ve hedef',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text(
            'Şu anki yakınmalarınız ve longevity programından beklentiniz. Birden fazlaysa virgülle ayırın.'),
        const SizedBox(height: 20),
        _multiField(
          controller: _complaints,
          label: 'Mevcut şikayetleriniz',
          hint: 'örn. yorgunluk, uyku problemi, cilt sorunu',
        ),
        _multiField(
          controller: _goals,
          label: 'Hedefleriniz',
          hint: 'örn. anti-aging, enerji, cilt, kilo, uyku',
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
            controller: _freeText,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Eklemek istediğiniz başka bir şey',
            ),
          ),
        ),
      ],
    );
  }
}

class _PendingLabUpload {
  final String fileName;
  _PendingLabUpload({required this.fileName});
}
