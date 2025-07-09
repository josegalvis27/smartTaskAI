# 🧠 SmartTask AI

Una aplicación de escritorio para macOS creada con Flutter, que combina un **calendario interactivo**, **asistente de IA con Gemini** y **notificaciones locales** para ayudarte a gestionar tus tareas, reuniones y eventos de forma inteligente.

---

## 🚀 Características

- 📆 **Calendario visual moderno**  
  Vista mensual/semanal con diseño tipo cuadrícula y separadores. Cada día muestra cuántos eventos contiene.

- 🤖 **Asistente de Inteligencia Artificial (Gemini)**  
  Cada tarea recibe ayuda personalizada de la IA según su tipo, descripción y horario.

- ⏰ **Recordatorios automáticos con notificaciones**  
  Las notificaciones se programan automáticamente 5 minutos antes del evento.

- 🖱️ **Hover preview en eventos (macOS)**  
  Al pasar el cursor por encima de un evento, se muestra una vista previa con detalles.

- 🧩 UI/UX profesional  
  Paleta de colores moderna (`#0D1B2A`, `#4ADEDE`) y componentes refinados.

---

## 🖼️ Capturas

> *(Agrega aquí imágenes o gifs si lo deseas)*

---

## 🛠️ Tecnologías usadas

- `Flutter 3.x`
- `Hive` – base de datos local
- `table_calendar` – para el calendario visual
- `flutter_local_notifications` – para recordatorios locales
- `flutter_markdown` – para renderizar respuestas IA
- `Google Gemini API` – integración IA

---

## 📦 Instalación (para desarrollo)

```bash
git clone https://github.com/tuusuario/smart-task-ai.git
cd smart-task-ai
flutter pub get
flutter run -d macos
