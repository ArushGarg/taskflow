import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/task_entity.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final ValueChanged<bool> onToggleComplete;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onTap,
    required this.onDelete,
  });

  bool get _isOverdue =>
      !task.isCompleted && task.dueDate.isBefore(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete task?'),
            content: Text('"${task.title}" will be permanently removed.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Delete',
                    style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ) ??
            false;
      },
      onDismissed: (_) => onDelete(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Material(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => onToggleComplete(!task.isCompleted),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2, right: 12),
                      child: Icon(
                        task.isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: task.isCompleted
                            ? AppColors.success
                            : AppColors.textSecondary,
                        size: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: task.isCompleted
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            PriorityBadge(priority: task.priority),
                          ],
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 12,
                              color: _isOverdue
                                  ? AppColors.error
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('d MMM').format(task.dueDate),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight:
                                _isOverdue ? FontWeight.w600 : FontWeight.normal,
                                color: _isOverdue
                                    ? AppColors.error
                                    : AppColors.textSecondary,
                              ),
                            ),
                            if (_isOverdue) ...[
                              const SizedBox(width: 6),
                              const Text(
                                'Overdue',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}