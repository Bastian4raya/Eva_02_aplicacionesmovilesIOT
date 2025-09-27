import 'package:app_tareas/models/task.dart';
import 'package:flutter/material.dart';

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.color,
  });

  final TaskFilter value;
  final ValueChanged<TaskFilter> onChanged;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final active = color ?? Theme.of(context).colorScheme.primary;

    ChoiceChip chip(String label, TaskFilter f) => ChoiceChip(
      label: Text(
        label,
        style: TextStyle(color: value == f ? Colors.white : Colors.black),
      ),
      selected: value == f,
      selectedColor: active,
      onSelected: (_) => onChanged(f),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Wrap(
        spacing: 0,
        children: [
          chip("Todas", TaskFilter.all),
          chip("Pendientes", TaskFilter.pending),
          chip("Completas", TaskFilter.done)          
        ],
      ),
      );
  }
}
