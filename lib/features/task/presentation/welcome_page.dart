import 'package:flutter/material.dart';
import 'calendar_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO
            Image.asset(
              'assets/logo.png',
              height: 160,
            ),
            const SizedBox(height: 40),
            // TÍTULO
            const Text(
              "Cambia tu forma de organizarte",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // DESCRIPCIÓN
            const Text(
              '📅 Organiza tus tareas con IA\n'
              '🤖 Recibe ayuda inteligente para tus eventos\n'
              '⏰ Recordatorios justo a tiempo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFADB5BD),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),

            // BOTÓN DE COMENZAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CalendarPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B4D8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Comenzar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}