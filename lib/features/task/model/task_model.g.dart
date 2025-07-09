// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 1;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      titulo: fields[0] as String,
      tipo: fields[1] as EventType,
      detalles: fields[2] as String,
      fechaHora: fields[3] as DateTime,
      fechaFin: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.titulo)
      ..writeByte(1)
      ..write(obj.tipo)
      ..writeByte(2)
      ..write(obj.detalles)
      ..writeByte(3)
      ..write(obj.fechaHora)
      ..writeByte(4)
      ..write(obj.fechaFin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventTypeAdapter extends TypeAdapter<EventType> {
  @override
  final int typeId = 0;

  @override
  EventType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventType.tarea;
      case 1:
        return EventType.reunion;
      case 2:
        return EventType.viaje;
      case 3:
        return EventType.recordatorio;
      case 4:
        return EventType.estudio;
      default:
        return EventType.tarea;
    }
  }

  @override
  void write(BinaryWriter writer, EventType obj) {
    switch (obj) {
      case EventType.tarea:
        writer.writeByte(0);
        break;
      case EventType.reunion:
        writer.writeByte(1);
        break;
      case EventType.viaje:
        writer.writeByte(2);
        break;
      case EventType.recordatorio:
        writer.writeByte(3);
        break;
      case EventType.estudio:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
