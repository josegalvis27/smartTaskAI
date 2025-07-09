import 'package:flutter/material.dart';
import 'package:smart_task_ai/features/task/model/task_model.dart';
import 'package:smart_task_ai/features/task/presentation/task_detail_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive/hive.dart';
import 'task_form_modal.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  late final Box<TaskModel> _taskBox;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _taskBox = Hive.box<TaskModel>('tasks');
  }

  List<TaskModel> _getTasksForDay(DateTime day) {
    return _taskBox.values
        .where((task) => isSameDay(task.fechaHora, day))
        .toList()
      ..sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
  }

  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      _selectedDay = selected;
      _focusedDay = focused;
    });
  }

  @override
  Widget build(BuildContext context) {
    final events = _selectedDay != null ? _getTasksForDay(_selectedDay!) : [];

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        title: const Text('Tu calendario'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _calendarFormat = _calendarFormat == CalendarFormat.month
                    ? CalendarFormat.week
                    : CalendarFormat.month;
              });
            },
            icon: Icon(
              _calendarFormat == CalendarFormat.month
                  ? Icons.view_week
                  : Icons.calendar_month,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4ADEDE),
        onPressed: () async {
          final creado = await showTaskFormModal(
            context,
            _selectedDay ?? DateTime.now(),
          );
          if (creado == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          TableCalendar<TaskModel>(
            locale: 'es_ES',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            eventLoader: _getTasksForDay,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 133, 174, 174),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color(0xFF4ADEDE),
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
              defaultTextStyle: TextStyle(color: Color(0xFFE5E5E5)),
              weekendTextStyle: TextStyle(color: Colors.white70),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white60),
              weekendStyle: TextStyle(color: Colors.white60),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                final tareas = _getTasksForDay(date);
                final isToday = isSameDay(date, DateTime.now());

                return Container(
                  width: 135,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white12, width: 0.3),
                    color: isToday ? const Color(0xFF213544) : Colors.transparent,
                  ),
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    children: [
                      Text(
                        '${date.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      if (tareas.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '${tareas.length} evento${tareas.length > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFFB0BEC5),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedDay != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 4),
                      child: Text(
                        _formatearFecha(_selectedDay!),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFFE5E5E5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Expanded(
                    child: events.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay eventos para este día',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: events.length,
                            itemBuilder: (_, index) {
                              final task = events[index];
                              final hora = TimeOfDay.fromDateTime(task.fechaHora);
                              final horaFin = TimeOfDay.fromDateTime(task.fechaFin);
                              final icono = _obtenerIconoPorTipo(task.tipo);

                              return MouseRegion(
  cursor: SystemMouseCursors.click,
  child: Tooltip(
    message:
        '${task.titulo}\n${task.detalles}\n${hora.format(context)} - ${horaFin.format(context)}',
    textStyle: const TextStyle(color: Colors.white),
    decoration: BoxDecoration(
      color: const Color(0xFF1B263B),
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.all(10),
    waitDuration: const Duration(milliseconds: 400),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailPage(task: task),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF222C3D),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, color: const Color(0xFF4ADEDE), size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.titulo,
                    style: const TextStyle(
                      color: Color(0xFFE5E5E5),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${hora.format(context)} - ${horaFin.format(context)}',
                    style: const TextStyle(
                      color: Color(0xFFB0BEC5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit,
                      color: Colors.white70, size: 20),
                  onPressed: () async {
                    final actualizado = await showTaskFormModal(
                      context,
                      task.fechaHora,
                      task: task,
                    );
                    if (actualizado == true) setState(() {});
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete,
                      color: Colors.redAccent, size: 20),
                  onPressed: () async {
                    await task.delete();
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime date) {
    return '${_capitalizarDia(date.weekday)}, ${date.day} de ${_nombreMes(date.month)} de ${date.year}';
  }

  String _capitalizarDia(int weekday) {
    const dias = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    return dias[weekday - 1][0].toUpperCase() + dias[weekday - 1].substring(1);
  }

  String _nombreMes(int mes) {
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return meses[mes - 1];
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
