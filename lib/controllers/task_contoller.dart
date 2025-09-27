// Importa utilidades de Flutter (como ChangeNotifier)
import 'package:flutter/foundation.dart';
// Importa el modelo de datos de tareas
import '../models/task.dart';

// Controlador que maneja la lista de tareas y la lógica
class TaskController extends ChangeNotifier {
  // Lista privada de tareas iniciales (6 de ejemplo: 2 completadas, 2 pendientes con fecha, 2 sin fecha)
  final List<Task> _tasks = [
    Task(
      title: 'Revisar enunciado de evaluación',
      note: 'Sección B',
      due: DateTime.now().add(const Duration(days: 1)), // Vence mañana
    ),
    Task(
      title: 'Subir rúbrica a Aula',
      done: true, // Tarea ya completada
    ),
    Task(
      title: 'Responder correos de alumnos',
      due: DateTime.now().subtract(const Duration(days: 3)), // Vencida (hace 3 días)
    ),
    Task(
      title: 'Preparar clase de Flutter',
      note: 'Widgets y estado',
      due: DateTime.now().add(const Duration(days: 7)), // Vence en una semana
    ),
    Task(
      title: 'Publicar notas en Aula',
      done: true, // Tarea ya completada
    ),
    Task(
      title: 'Revisar proyecto final de curso', // Sin fecha de vencimiento
    ),
  ];

  // Texto para búsqueda
  String _query = '';
  // Filtro actual (todas, pendientes o completadas)
  TaskFilter _filter = TaskFilter.all;

  // ----- Lecturas (getters) -----

  // Devuelve la lista de tareas, pero como lista de solo lectura
  List<Task> get tasks => List.unmodifiable(_tasks);

  // Devuelve el texto de búsqueda actual
  String get query => _query;

  // Devuelve el filtro actual
  TaskFilter get filter => _filter;

  // Devuelve la lista de tareas filtradas y ordenadas
  List<Task> get filtered {
    final q = _query.trim().toLowerCase(); // texto de búsqueda en minúsculas

    // 1. Filtrar por estado y búsqueda
    List<Task> result = _tasks.where((t) {
      // Filtra por estado (RF9)
      final byFilter = switch (_filter) {
        TaskFilter.all => true,    // todas
        TaskFilter.pending => !t.done, // solo no completadas
        TaskFilter.done => t.done,     // solo completadas
      };
      // Filtra por coincidencia con el texto (RF8)
      final byQuery = q.isEmpty ||
          t.title.toLowerCase().contains(q) ||
          (t.note?.toLowerCase().contains(q) ?? false);

      // La tarea pasa si cumple ambos filtros
      return byFilter && byQuery;
    }).toList(); // Convierte a lista mutable para poder ordenar

    // 2. Ordenar por fecha ascendente (RF13: sugerido por defecto)
    result.sort((a, b) {
      // Las tareas sin fecha de vencimiento (null) van al final.
      if (a.due == null && b.due == null) return 0;
      if (a.due == null) return 1; 
      if (b.due == null) return -1;
      
      // Orden ascendente por fecha (la más cercana primero)
      return a.due!.compareTo(b.due!); 
    });

    return result;
  }

  // ----- Mutaciones (acciones que cambian datos) -----

  // Cambia el texto de búsqueda
  void setQuery(String value) {
    _query = value;
    notifyListeners(); // avisa a la interfaz de usuario (UI) que hubo un cambio, para que se vuelva a redibujar.
  }

  // Cambia el filtro de tareas
  void setFilter(TaskFilter f) {
    _filter = f;
    notifyListeners();
  }

  // Marca o desmarca una tarea como completada
  void toggle(Task t, bool v) {
    t.done = v;
    notifyListeners();
  }

  // Agrega una nueva tarea al inicio de la lista
  void add(String title, {String? note, DateTime? due}) {
    _tasks.insert(0, Task(title: title, note: note, due: due));
    notifyListeners();
  }

  // Elimina una tarea de la lista
  void remove(Task t) {
    _tasks.remove(t);
    notifyListeners();
  }
}