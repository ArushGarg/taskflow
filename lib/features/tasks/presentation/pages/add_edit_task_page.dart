import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';

class AddEditTaskPage extends StatefulWidget {
  final TaskEntity? task;
  const AddEditTaskPage({super.key, this.task});

  bool get isEditing => task != null;

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _dueDate;
  late TaskPriority _priority;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController =
        TextEditingController(text: task?.description ?? '');
    _dueDate = task?.dueDate ?? DateTime.now();
    _priority = task?.priority ?? TaskPriority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppColors.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final user = context.read<AuthBloc>().state.user;
    if (user == null) return;

    if (widget.isEditing) {
      final updated = widget.task!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
      );
      context.read<TaskBloc>().add(TaskUpdated(updated));
    } else {
      final newTask = TaskEntity(
        id: const Uuid().v4(),
        userId: user.uid,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
        isCompleted: false,
        createdAt: DateTime.now(),
      );
      context.read<TaskBloc>().add(TaskAdded(newTask));
    }
    Navigator.of(context).pop();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('"${widget.task!.title}" will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(TaskDeleted(widget.task!.id));
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit task' : 'New task'),
        actions: [
          if (widget.isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Label('TITLE'),
                TextFormField(
                  controller: _titleController,
                  validator: (v) => Validators.required(v, field: 'Title'),
                  decoration: const InputDecoration(hintText: 'e.g. Deliver package'),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 18),
                const _Label('DESCRIPTION'),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Add any extra details (optional)',
                  ),
                ),
                const SizedBox(height: 18),
                const _Label('DUE DATE'),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat('EEEE, d MMMM yyyy').format(_dueDate),
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const _Label('PRIORITY'),
                Row(
                  children: TaskPriority.values.map((priority) {
                    final selected = _priority == priority;
                    final color = switch (priority) {
                      TaskPriority.low => AppColors.priorityLow,
                      TaskPriority.medium => AppColors.priorityMedium,
                      TaskPriority.high => AppColors.priorityHigh,
                    };
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: priority != TaskPriority.high ? 10 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() => _priority = priority),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected ? color.withOpacity(0.14) : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected ? color : AppColors.divider,
                                width: selected ? 1.6 : 1,
                              ),
                            ),
                            child: Text(
                              priority.label,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: selected ? color : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: widget.isEditing ? 'Save changes' : 'Add task',
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}