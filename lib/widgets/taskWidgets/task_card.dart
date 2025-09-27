import 'package:app_tareas/models/task.dart';
import 'package:app_tareas/widgets/taskWidgets/swipe_bg.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDismissed,
    required this.swipeColor,
    this.dateText,
    this.itemKey,
  });

  final Task task;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDismissed;
  final Color swipeColor;
  final String? dateText;
  final Object? itemKey;

  // Lógica para el Estado Derivado "Vencida" (RF7)
  bool get _isExpired {
    final dueDate = task.due;
    // 1. Debe tener fecha.
    // 2. NO debe estar completada.
    if (dueDate == null || task.done) {
      return false;
    }

    // 3. La fecha de vencimiento es anterior al inicio de HOY.
    final nowDayStart = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final dueDateDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
    
    // Si la fecha de vencimiento ya pasó, está vencida.
    return dueDateDay.isBefore(nowDayStart);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Determinar Estados
    final isExpired = _isExpired;
    final isDone = task.done;

    // 2. Determinar Estilos Derivados (RF7)
    // Rojo si vencida, Gris si completada, Negro/Oscuro si pendiente/normal
    final color = isExpired 
        ? Colors.red 
        : (isDone ? Colors.grey : Colors.black87);
    
    // Tachado si completada
    final decoration = isDone ? TextDecoration.lineThrough : null;
    
    // Negrita si vencida
    final fontWeight = isExpired ? FontWeight.bold : FontWeight.normal;

    final k = itemKey ?? '${task.title}-${task.hashCode}';
    
    return Dismissible(
      key: ValueKey(k),
      // Se permite deslizar en ambas direcciones
      background: SwipeBg(alineacion: Alignment.centerLeft, color: swipeColor),
      secondaryBackground: SwipeBg(
        alineacion: Alignment.centerRight,
        color: swipeColor,
      ),
      onDismissed: (_) => onDismissed(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: CheckboxListTile(
          value: task.done,
          onChanged: (v) => onToggle(v ?? false),
          
          // Título de la tarea
          title: Text(
            task.title,
            style: TextStyle(
              color: color,
              decoration: decoration,
              fontWeight: fontWeight,
            ),
          ),
          
          // Subtítulo (Nota + Fecha + Indicador de Vencida)
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nota (si existe)
              if (task.note != null && task.note!.isNotEmpty) 
                Text(
                  task.note!,
                  style: TextStyle(color: color, decoration: decoration),
                ),
                
              // Fecha de Vencimiento (si existe)
              if (dateText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.event, size: 16, color: color),
                      const SizedBox(width: 6),
                      Text(
                        dateText!,
                        style: TextStyle(
                          color: color,
                          decoration: decoration,
                          fontWeight: fontWeight,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

              // Indicador de "Vencida" (Adicional y en color rojo)
              if (isExpired)
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    '¡VENCIDA!',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          
          // Posicionamiento de Checkbox y Handle de Arrastre
          controlAffinity: ListTileControlAffinity.leading,
          secondary: const Icon(Icons.drag_handle),
        ),
      ),
    );
  }
}