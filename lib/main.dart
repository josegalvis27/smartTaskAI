// main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_task_ai/features/Notifications/data/notifications_service.dart';
import 'package:smart_task_ai/features/task/presentation/welcome_page.dart';
import 'features/task/model/task_model.dart';
import 'features/task/presentation/calendar_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(EventTypeAdapter());
  Hive.registerAdapter(TaskModelAdapter());

  await Hive.openBox<TaskModel>('tasks');
  await NotificationService.init();


  runApp(const SmartTaskApp());
}
void limpiarHive() async {
  final box = await Hive.openBox<TaskModel>('tasks');
  await box.clear(); // ⚠️ Esto elimina todos los eventos guardados
  print('Hive limpiado correctamente');
}
class SmartTaskApp extends StatelessWidget {
  const SmartTaskApp({super.key});
  

  @override
  Widget build(BuildContext context) {
 return MaterialApp(
  title: 'SmartTask AI',
  theme: ThemeData.dark(useMaterial3: true),
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('es', 'ES'), // 👈 Español de España
  ],
  locale: Locale('es', 'ES'),
  debugShowCheckedModeBanner: false,
home: const WelcomePage(),

);
  }
}