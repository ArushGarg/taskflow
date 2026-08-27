import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_filter.dart';

class TaskFilterBar extends StatelessWidget {
  final TaskFilter filter;
  final ValueChanged<TaskPriority?> onPriorityChanged;
  final ValueChanged<StatusFilter> onStatusChanged;

  const TaskFilterBar({
    super.key,
    required this.filter,
    required this.onPriorityChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _Chip(
            label: 'All',
            selected: filter.status == StatusFilter.all,
            onTap: () => onStatusChanged(StatusFilter.all),
          ),
          _Chip(
            label: 'Incomplete',
            selected: filter.status == StatusFilter.incomplete,
            onTap: () => onStatusChanged(StatusFilter.incomplete),
          ),
          _Chip(
            label: 'Completed',
            selected: filter.status == StatusFilter.completed,
            onTap: () => onStatusChanged(StatusFilter.completed),
          ),
          Container(
            height: 20,
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: AppColors.divider,
          ),
          _Chip(
            label: 'Low',
            selected: filter.priority == TaskPriority.low,
            color: AppColors.priorityLow,
            onTap: () => onPriorityChanged(
              filter.priority == TaskPriority.low ? null : TaskPriority.low,
            ),
          ),
          _Chip(
            label: 'Medium',
            selected: filter.priority == TaskPriority.medium,
            color: AppColors.priorityMedium,
            onTap: () => onPriorityChanged(
              filter.priority == TaskPriority.medium ? null : TaskPriority.medium,
            ),
          ),
          _Chip(
            label: 'High',
            selected: filter.priority == TaskPriority.high,
            color: AppColors.priorityHigh,
            onTap: () => onPriorityChanged(
              filter.priority == TaskPriority.high ? null : TaskPriority.high,
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? activeColor : AppColors.divider,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}