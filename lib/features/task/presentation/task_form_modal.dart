// 📄 features/task/presentation/task_form_modal.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smart_task_ai/features/Notifications/data/notifications_service.dart';
import 'package:smart_task_ai/features/task/model/task_model.dart';


Future<bool?> showTaskFormModal(BuildContext context, DateTime selectedDate, {TaskModel? task}) async {
  final _titleController = TextEditingController(text: task?.titulo ?? '');
  final _detailsController = TextEditingController(text: task?.detalles ?? '');
  EventType? selectedType = task?.tipo;

  TimeOfDay selectedTime = task != null
      ? TimeOfDay.fromDateTime(task.fechaHora)
      : TimeOfDay.now();

  final now = DateTime.now();
  final startDateTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
  final endDateTime = task?.fechaFin ?? startDateTime.add(const Duration(minutes: 30));
  TimeOfDay selectedEndTime = TimeOfDay.fromDateTime(endDateTime);

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(task == null ? 'Nuevo evento' : 'Editar evento'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<EventType>(
                decoration: const InputDecoration(labelText: 'Tipo de evento'),
                value: selectedType,
                onChanged: (value) {
                  selectedType = value;
                },
                items: EventType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _detailsController,
                decoration: const InputDecoration(labelText: 'Detalles'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    selectedTime = picked;
                  }
                },
                child: const Text('Seleccionar hora de inicio'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: selectedEndTime,
                  );
                  if (picked != null) {
                    selectedEndTime = picked;
                  }
                },
                child: const Text('Seleccionar hora de fin'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () async {
              final fechaInicio = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );
              final fechaFin = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedEndTime.hour,
                selectedEndTime.minute,
              );

              if (task != null) {
                task.titulo = _titleController.text;
                task.tipo = selectedType!;
                task.detalles = _detailsController.text;
                task.fechaHora = fechaInicio;
                task.fechaFin = fechaFin;
                task.save();
              } else {
                final nueva = TaskModel(
                  titulo: _titleController.text,
                  tipo: selectedType!,
                  detalles: _detailsController.text,
                  fechaHora: fechaInicio,
                  fechaFin: fechaFin,
                );
                Hive.box<TaskModel>('tasks').add(nueva);
              }
              await NotificationService.programarNotificacion(
  id: DateTime.now().millisecondsSinceEpoch % 100000,
  titulo: task != null ? task.titulo : _titleController.text,
  mensaje: 'Tu evento está por comenzar',

  fechaHora: fechaInicio,
);
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}
