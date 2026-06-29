import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.doctorHomeTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.questionsQueue,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: Center(child: Text(l.noQuestionsYet)),
            ),
          ],
        ),
      ),
    );
  }
}
