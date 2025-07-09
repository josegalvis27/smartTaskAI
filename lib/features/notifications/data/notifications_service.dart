import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const settings = InitializationSettings(
      macOS: DarwinInitializationSettings(),
    );

    await _notifications.initialize(settings);
    tz.initializeTimeZones();
  }

static Future<void> programarNotificacion({
  required int id,
  required String titulo,
  required String mensaje,
  required DateTime fechaHora,
}) async {
  final ahora = tz.TZDateTime.now(tz.local);
  final cincoMinAntes = tz.TZDateTime.from(
    fechaHora.subtract(const Duration(minutes: 5)),
    tz.local,
  );

  // 👇 Usamos la más reciente entre ahora + 5s y fecha - 5min
  final programado = ahora.add(const Duration(seconds: 0)).isAfter(cincoMinAntes)
      ? ahora.add(const Duration(seconds: 5))
      : cincoMinAntes;

  await _notifications.zonedSchedule(
    id,
    titulo,
    mensaje,
    programado,
    const NotificationDetails(
      macOS: DarwinNotificationDetails(
        attachments: [

        ],
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

  static Future<void> cancelarNotificacion(int id) async {
    await _notifications.cancel(id);
  }
}
