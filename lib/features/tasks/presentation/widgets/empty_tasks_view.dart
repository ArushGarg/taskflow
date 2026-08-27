import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class EmptyTasksView extends StatelessWidget {
  final String message;
  const EmptyTasksView({super.key, this.message = 'No tasks yet'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 88,
              width: 88,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.task_alt_rounded,
                  size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}