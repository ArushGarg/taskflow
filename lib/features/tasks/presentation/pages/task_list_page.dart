import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../widgets/empty_tasks_view.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter_bar.dart';
import 'add_edit_task_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.user;
    if (user != null) {
      context.read<TaskBloc>().add(TasksSubscriptionRequested(user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = context.watch<AuthBloc>().state.user?.email ?? '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(userEmail: userEmail),
            const SizedBox(height: 16),
            BlocConsumer<TaskBloc, TaskState>(
              listenWhen: (previous, current) =>
              previous.actionError != current.actionError &&
                  current.actionError != null,
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.actionError!),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
              buildWhen: (previous, current) =>
              previous.filter != current.filter,
              builder: (context, state) {
                return TaskFilterBar(
                  filter: state.filter,
                  onPriorityChanged: (priority) => context
                      .read<TaskBloc>()
                      .add(TaskPriorityFilterChanged(priority)),
                  onStatusChanged: (status) => context
                      .read<TaskBloc>()
                      .add(TaskStatusFilterChanged(status)),
                );
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state.status == TaskLoadStatus.loading ||
                      state.status == TaskLoadStatus.initial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == TaskLoadStatus.failure) {
                    return EmptyTasksView(
                      message: state.errorMessage ?? 'Something went wrong.',
                    );
                  }
                  final tasks = state.visibleTasks;
                  if (tasks.isEmpty) {
                    return const EmptyTasksView(
                      message: 'No tasks match this filter.\nTap + to add one.',
                    );
                  }
                  final sections = _groupByDueDate(tasks);
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      final section = sections[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 4),
                            child: Text(
                              section.label,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          ...section.tasks.map(
                                (task) => TaskCard(
                              task: task,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AddEditTaskPage(task: task),
                                ),
                              ),
                              onToggleComplete: (isCompleted) => context
                                  .read<TaskBloc>()
                                  .add(TaskCompletionToggled(
                                taskId: task.id,
                                isCompleted: isCompleted,
                              )),
                              onDelete: () => context
                                  .read<TaskBloc>()
                                  .add(TaskDeleted(task.id)),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddEditTaskPage()),
        ),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  /// Buckets tasks into Overdue / Today / Tomorrow / This Week / Later —
  /// same grouping idea as the reference "Today / Tomorrow / This week"
  /// mock, extended slightly to also surface overdue items up top.
  List<_Section> _groupByDueDate(List<TaskEntity> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final weekEnd = today.add(const Duration(days: 7));

    final overdue = <TaskEntity>[];
    final todayTasks = <TaskEntity>[];
    final tomorrowTasks = <TaskEntity>[];
    final thisWeek = <TaskEntity>[];
    final later = <TaskEntity>[];

    for (final task in tasks) {
      final due = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      if (due.isBefore(today) && !task.isCompleted) {
        overdue.add(task);
      } else if (due == today) {
        todayTasks.add(task);
      } else if (due == tomorrow) {
        tomorrowTasks.add(task);
      } else if (due.isBefore(weekEnd)) {
        thisWeek.add(task);
      } else {
        later.add(task);
      }
    }

    final sections = <_Section>[];
    if (overdue.isNotEmpty) sections.add(_Section('Overdue', overdue));
    if (todayTasks.isNotEmpty) sections.add(_Section('Today', todayTasks));
    if (tomorrowTasks.isNotEmpty) {
      sections.add(_Section('Tomorrow', tomorrowTasks));
    }
    if (thisWeek.isNotEmpty) sections.add(_Section('This week', thisWeek));
    if (later.isNotEmpty) sections.add(_Section('Later', later));
    return sections;
  }
}

class _Section {
  final String label;
  final List<TaskEntity> tasks;
  _Section(this.label, this.tasks);
}

class _Header extends StatelessWidget {
  final String userEmail;
  const _Header({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, d MMM').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'My tasks',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(Icons.more_horiz_rounded,
                  color: AppColors.textSecondary),
            ),
            onSelected: (value) {
              if (value == 'signout') {
                context.read<AuthBloc>().add(const AuthSignOutRequested());
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Text(
                  userEmail,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'signout',
                child: Text('Log out'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}