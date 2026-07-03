import 'package:flutter/material.dart';

import '../../../core/data/services_seed.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/botanical_scaffold.dart';

/// Bir hizmetin (test / panel / IV / estetik) detay ekranı.
/// `protocolTr` alanı doluysa Spektrum Popüler Longevity Protokolleri metnini gösterir.
class ServiceDetailScreen extends StatelessWidget {
  final String serviceId;
  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final service = _findService(serviceId);
    final isTr = Localizations.localeOf(context).languageCode == 'tr';

    if (service == null) {
      return BotanicalScaffold(
        appBar: AppBar(
          title: Text(l.services),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              '${l.error}: $serviceId',
              style: const TextStyle(color: AppColors.inkSoft),
            ),
          ),
        ),
      );
    }

    final name = isTr ? service.nameTr : service.nameEn;
    final shortDesc = isTr ? service.descriptionTr : service.descriptionEn;
    final category = isTr ? service.category.trLabel : service.category.enLabel;
    final protocol = service.protocolTr;

    return BotanicalScaffold(
      appBar: AppBar(
        title: Text(name, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          MediaQuery.of(context).padding.top + kToolbarHeight + 8,
          20,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori etiketi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.sage.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.sageDark,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Başlık
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                height: 1.2,
              ),
            ),
            if (shortDesc != null && shortDesc.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                shortDesc,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.inkSoft,
                ),
              ),
            ],
            const SizedBox(height: 20),

            // Protokol
            if (protocol != null && protocol.isNotEmpty)
              _ProtocolCard(text: protocol, heading: l.protocolHeading)
            else
              _NoProtocolCard(text: l.noProtocolYet),

            const SizedBox(height: 20),
            // Bilgi kutusu
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.terracotta.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.terracotta.withValues(alpha: 0.35)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline,
                      size: 18, color: AppColors.terracotta),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l.protocolDisclaimer,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.ink,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
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

class _ProtocolCard extends StatelessWidget {
  final String text;
  final String heading;
  const _ProtocolCard({required this.text, required this.heading});

  @override
  Widget build(BuildContext context) {
    final blocks = text.split('\n\n');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description_outlined,
                    color: AppColors.sageDark, size: 20),
                const SizedBox(width: 8),
                Text(
                  heading,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            for (final block in blocks) _renderBlock(block),
          ],
        ),
      ),
    );
  }

  Widget _renderBlock(String block) {
    final lines = block.split('\n');
    final firstLine = lines.first.trim();

    // Başlık/etiket satırı formatlaması (İçerik:, Uygulama:, Olası faydalar: vb.)
    final labelMatch = RegExp(r'^([A-ZÇĞİÖŞÜa-zçğıöşü ]+):\s*(.*)').firstMatch(firstLine);
    if (labelMatch != null && lines.length == 1 && !firstLine.startsWith('•')) {
      final label = labelMatch.group(1)!;
      final rest = labelMatch.group(2)!;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: AppColors.ink, fontSize: 14, height: 1.45),
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(text: rest),
            ],
          ),
        ),
      );
    }

    // Bullet listesi
    if (lines.any((l) => l.trim().startsWith('•'))) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines.map((line) {
            final trimmed = line.trimLeft();
            if (trimmed.startsWith('•')) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•',
                        style: TextStyle(
                            color: AppColors.sageDark,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trimmed.substring(1).trim(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.ink,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            // Bullet listesinin altındaki bir başlık/açıklama
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                trimmed,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.ink,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    // Düz paragraf
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        block,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.ink,
          height: 1.45,
        ),
      ),
    );
  }
}

class _NoProtocolCard extends StatelessWidget {
  final String text;
  const _NoProtocolCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, color: AppColors.sageDark),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: AppColors.inkSoft, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
