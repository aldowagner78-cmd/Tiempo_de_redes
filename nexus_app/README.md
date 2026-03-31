# 🎮 Nexus Control

**Control Parental Gamificado** - Una aplicación Flutter que transforma el tiempo frente a la pantalla en una experiencia educativa y gratificante.

---

## 📋 Descripción

Nexus Control es una aplicación de control parental innovadora que utiliza gamificación para motivar a los niños a realizar actividades saludables y educativas a cambio de tiempo de pantalla. La aplicación presenta una estética cyberpunk/espacial donde el niño es un "Piloto" y el padre es el "Comandante".

### 🎯 Concepto Principal

- **Los niños ganan Bio-Coins** completando actividades en diferentes módulos
- **Bio-Coins se convierten en tiempo de pantalla** para apps de entretenimiento
- **Los padres tienen control total** sobre todas las configuraciones
- **Completamente GRATIS** - sin compras in-app

---

## ✨ Características

### Para Niños (Pilotos)

| Módulo | Descripción | Recompensa |
|--------|-------------|------------|
| 🏃 **Arena** | Ejercicio físico con detección de movimiento | 15 coins/1000 pasos |
| 🥗 **Bio-Fuel** | Análisis nutricional de comidas con cámara | 20-25 coins/comida saludable |
| 📚 **Comms** | Lectura con OCR y quizzes de comprensión | 25 coins/quiz |
| 🧩 **Logic** | Puzzles de patrón, memoria y números | 15 coins/puzzle |
| ➗ **Math** | Problemas matemáticos adaptativos | 10 coins/problema |
| 💻 **Coding** | Programación básica con bloques | 30+ coins/nivel |

### Para Padres (Comandantes)

- ⏱️ **Control de tiempo diario** por hijo
- 📱 **Gestión de apps** (bloquear, limitar tiempo, permitir)
- 📋 **Creación de tareas** personalizadas
- 💰 **Configuración de recompensas** por actividad
- 🔒 **Acceso protegido por PIN**
- 📊 **Estadísticas de uso** en tiempo real

---

## 🏗️ Arquitectura

```
lib/
├── core/
│   ├── constants/     # Colores, strings, valores
│   ├── theme/         # Tema cyberpunk
│   ├── services/      # Isar, servicios core
│   └── utils/         # Helpers, platform channels
├── features/
│   ├── auth/          # Autenticación, PIN, roles
│   ├── hud/           # Pantalla principal del niño
│   ├── parent/        # Dashboard del padre
│   ├── arena/         # Módulo de ejercicio
│   ├── biofuel/       # Módulo de nutrición
│   ├── comms/         # Módulo de lectura
│   ├── logic/         # Módulo de puzzles
│   ├── math/          # Módulo de matemáticas
│   ├── coding/        # Módulo de programación
│   ├── monitor/       # Entidades de monitoreo
│   └── biocoins/      # Entidades de economía
└── shared/
    ├── providers/     # Riverpod providers globales
    └── widgets/       # Widgets reutilizables
```

---

## 🛠️ Tecnologías

### Flutter/Dart
- **flutter_riverpod** - State management
- **isar** - Base de datos local NoSQL
- **flutter_animate** - Animaciones fluidas
- **google_fonts** - Tipografía Orbitron

### Nativos Android (Kotlin)
- **UsageStatsManager** - Monitoreo de uso de apps
- **WindowManager** - Overlay de bloqueo
- **ForegroundService** - Servicio persistente
- **DeviceAdmin** - Control parental avanzado

### ML/AI
- **google_mlkit_text_recognition** - OCR para lectura
- **sensors_plus** - Detección de movimiento
- **camera** - Análisis de comidas

---

## 📱 Permisos Requeridos

| Permiso | Uso |
|---------|-----|
| `PACKAGE_USAGE_STATS` | Monitorear apps en uso |
| `SYSTEM_ALERT_WINDOW` | Mostrar pantalla de bloqueo |
| `FOREGROUND_SERVICE` | Servicio de monitoreo |
| `CAMERA` | Análisis de comidas |
| `BODY_SENSORS` | Detección de ejercicio |
| `ACCESS_FINE_LOCATION` | Tracking de actividad |

### Modo Device Owner (Opcional)

Para control parental avanzado, ejecutar via ADB:

```bash
adb shell dpm set-device-owner com.saludable.nexus_control/.receivers.DeviceAdminReceiver
```

---

## 🚀 Instalación

### Prerrequisitos
- Flutter SDK >= 3.2.0
- Android SDK
- Dispositivo Android 7.0+ (API 24+)

### Pasos

```bash
# Clonar repositorio
git clone <repository>
cd nexus_control

# Obtener dependencias
flutter pub get

# Generar código (Isar)
dart run build_runner build

# Ejecutar
flutter run
```

---

## 🎨 Diseño

### Paleta de Colores
- **Fondo:** #0A0E17 (Oscuro espacial)
- **Cyan Neón:** #00F5FF (Principal)
- **Magenta Neón:** #FF00FF (Padre)
- **Amarillo Neón:** #FFE500 (Bio-Coins)
- **Verde Neón:** #00FF88 (Éxito)
- **Rojo Neón:** #FF3366 (Bloqueo)

### Tipografía
- **Orbitron** - Fuente futurista para headers
- **Roboto** - Texto de cuerpo

---

## 📂 Archivos Clave

| Archivo | Descripción |
|---------|-------------|
| `main.dart` | Punto de entrada y rutas |
| `isar_service.dart` | Servicio de base de datos |
| `platform_channel.dart` | Comunicación Flutter-Kotlin |
| `global_providers.dart` | Providers de Riverpod |
| `hud_main_screen.dart` | Pantalla HUD del niño |
| `parent_dashboard_screen.dart` | Panel del padre |
| `AppMonitorService.kt` | Servicio nativo de monitoreo |
| `OverlayService.kt` | Servicio de overlay de bloqueo |

---

## 🔮 Próximos Pasos

- [ ] Integrar Health Connect API
- [ ] Añadir más juegos educativos
- [ ] Sistema de logros y badges
- [ ] Estadísticas detalladas para padres
- [ ] Soporte multi-idioma
- [ ] Tests unitarios y de integración

---

## 📄 Licencia

Este proyecto es **GRATUITO** para uso personal y educativo.

---

## 👤 Autor

Desarrollado con ❤️ para familias que buscan equilibrar el tiempo de pantalla con actividades saludables.
