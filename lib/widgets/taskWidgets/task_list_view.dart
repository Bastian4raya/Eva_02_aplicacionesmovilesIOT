import 'package:app_tareas/models/task.dart';
import 'package:app_tareas/widgets/taskWidgets/task_card.dart';
import 'package:flutter/material.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({
    super.key,
    required this.items,
    required this.onToggle,
    required this.onDelete,
    required this.dateFormatter,
    required this.swipeColor,
    this.empty,
    this.itemKeyOf,
  });

  final List<Task> items;
  final void Function(Task task, bool done) onToggle;
  final void Function(Task task) onDelete;
  final String Function(DateTime) dateFormatter;
  final Color swipeColor;

  final Widget? empty;

  final Object? Function(Task task)? itemKeyOf;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return empty ?? const SizedBox.shrink();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 96),
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final task = items[i];
        return TaskCard(
          task: task,
          itemKey: itemKeyOf?.call(task),
          dateText: task.due != null ? dateFormatter(task.due!) : null,
          onToggle: (v) => onToggle(task, v),
          onDismissed: () => onDelete(task),
          swipeColor: swipeColor,
        );
      },
    );
  }
}
