import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.sage.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.sageDark),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(description,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.inkSoft),
            ],
          ),
        ),
      ),
    );
  }
}
