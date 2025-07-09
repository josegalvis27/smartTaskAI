// 📄 features/task/model/task_model.dart
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
enum EventType {
  @HiveField(0)
  tarea,
  @HiveField(1)
  reunion,
  @HiveField(2)
  viaje,
  @HiveField(3)
  recordatorio,
  @HiveField(4)
  estudio,
}

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  String titulo;

  @HiveField(1)
  EventType tipo;

  @HiveField(2)
  String detalles;

  @HiveField(3)
  DateTime fechaHora; // Hora de inicio

  @HiveField(4)
  DateTime fechaFin;  // Hora de finalización

  @HiveField(5)
  String? respuestaIA;

  TaskModel({
    required this.titulo,
    required this.tipo,
    required this.detalles,
    required this.fechaHora,
    required this.fechaFin,
    this.respuestaIA,
  });

  String getPromptParaGemini() {
    switch (tipo) {
      case EventType.tarea:
        return 'Ayúdame a completar esta tarea: $detalles';
      case EventType.reunion:
        return 'Dame consejos o recordatorios para esta reunión: $detalles';
      case EventType.viaje:
        return 'Prepárame para este viaje: $detalles';
      case EventType.recordatorio:
        return 'Recuérdame hacer esto: $detalles';
      case EventType.estudio:
        return 'Ayúdame a estudiar esto: $detalles';
    }
  }
}
