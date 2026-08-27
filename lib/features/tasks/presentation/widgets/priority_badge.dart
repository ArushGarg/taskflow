import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/task_entity.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  const PriorityBadge({super.key, required this.priority});

  Color get _color => switch (priority) {
    TaskPriority.low => AppColors.priorityLow,
    TaskPriority.medium => AppColors.priorityMedium,
    TaskPriority.high => AppColors.priorityHigh,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority.label,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}