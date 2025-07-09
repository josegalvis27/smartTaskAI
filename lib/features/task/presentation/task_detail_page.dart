import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:smart_task_ai/features/task/data/task_service.dart';
import 'package:smart_task_ai/features/task/model/task_model.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskModel task;

  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  String? respuestaIA;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarAyudaIA();
  }

  Future<void> _cargarAyudaIA() async {
    final prompt = widget.task.getPromptParaGemini();
    try {
      if (widget.task.respuestaIA != null) {
        setState(() {
          respuestaIA = widget.task.respuestaIA;
          cargando = false;
        });
        return;
      }
      final respuesta = await GeminiService.enviarPrompt(prompt);
      setState(() {
        respuestaIA = respuesta;
        widget.task.respuestaIA = respuesta;
        widget.task.save();
        cargando = false;
      });
    } catch (e) {
      setState(() {
        respuestaIA = 'Error al obtener ayuda: $e';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final horaInicio = TimeOfDay.fromDateTime(task.fechaHora);
    final horaFin = TimeOfDay.fromDateTime(task.fechaFin);
    final icono = _obtenerIconoPorTipo(task.tipo);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        title: const Text('Detalle del evento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta con info del evento
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icono, color: const Color(0xFF00B4D8), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tipo: ${task.tipo.name.toUpperCase()}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fecha: ${task.fechaHora.day}/${task.fechaHora.month}/${task.fechaHora.year}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Horario: ${horaInicio.format(context)} - ${horaFin.format(context)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task.detalles,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Título asistente IA
            const Text(
              'Asistente IA:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // Contenedor respuesta IA
            cargando
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B263B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: respuestaIA != null
                        ? MarkdownBody(
                            data: respuestaIA!,
                            styleSheet: MarkdownStyleSheet(
                              p: const TextStyle(color: Colors.white),
                              h1: const TextStyle(
                                  color: Colors.white, fontSize: 22),
                              h2: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                              code: const TextStyle(color: Colors.greenAccent),
                            ),
                          )
                        : const Text(
                            'Sin respuesta de IA',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
          ],
        ),
      ),
    );
  }

  IconData _obtenerIconoPorTipo(EventType tipo) {
    switch (tipo) {
      case EventType.tarea:
        return Icons.task;
      case EventType.reunion:
        return Icons.group;
      case EventType.viaje:
        return Icons.flight;
      case EventType.recordatorio:
        return Icons.notifications;
      case EventType.estudio:
        return Icons.menu_book;
      default:
        return Icons.event_note;
    }
  }
}
