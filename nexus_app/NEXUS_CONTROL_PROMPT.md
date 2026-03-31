# 🎮 Prompt de Desarrollo: Nexus Control

## 📋 Descripción del Proyecto

Crear una **aplicación móvil de control parental gamificada** llamada **Nexus Control** usando **Flutter** con una estética **cyberpunk/espacial**. La app transforma el tiempo frente a la pantalla en una experiencia educativa donde los niños ganan tiempo de uso completando actividades saludables y educativas.

---

## 🎯 Concepto y Narrativa

### Roles
- **Niño = "Piloto"**: Usuario que gana recompensas
- **Padre = "Comandante"**: Administrador que controla todo el sistema

### Mecánica Central
1. **Bio-Coins** son la moneda del sistema (color verde neón #00FF88)
2. Los niños ganan Bio-Coins completando misiones en diferentes módulos
3. Los Bio-Coins se pueden canjear por **tiempo de pantalla** para apps de entretenimiento
4. Los padres configuran todo: límites de tiempo, apps permitidas, recompensas por actividad
5. La app es **completamente gratuita** sin compras in-app

### Estética Visual
- **Tema oscuro** con estética cyberpunk/HUD espacial
- **Colores neón**: Cyan (#00F5FF), Magenta (#FF00FF), Verde (#00FF88), Amarillo (#FFE600), Rojo (#FF3366)
- **Tipografía**: Orbitron (títulos, números, headers) + Rajdhani (cuerpo de texto)
- **Fondo**: Negro azulado (#0A0E17)
- **Superficies**: Azul oscuro (#141B2D)
- **Efectos**: Glows neón, animaciones fluidas, gradientes, scanlines sutiles

---

## 🏗️ Arquitectura y Estructura

### Stack Tecnológico
```yaml
# State Management
flutter_riverpod: ^2.5.1

# Base de Datos Local
isar: ^3.1.0+1
isar_flutter_libs: ^3.1.0+1
path_provider: ^2.1.2

# Cámara y Sensores
camera: ^0.11.0+1
sensors_plus: ^4.0.2
geolocator: ^11.0.0
permission_handler: ^11.3.0

# ML/AI Local (gratuito)
google_mlkit_text_recognition: ^0.12.0

# Health Data
health: ^10.2.0

# Audio
audioplayers: ^6.0.0

# Overlay para bloqueo
flutter_overlay_window: ^0.4.4

# UI
flutter_animate: ^4.5.0
google_fonts: ^6.2.1
shimmer: ^3.0.0
fl_chart: ^0.67.0

# Utils
uuid: ^4.3.3
intl: ^0.19.0
shared_preferences: ^2.2.2
crypto: ^3.0.3
flutter_svg: ^2.0.10+1
```

### Estructura de Carpetas
```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # Paleta cyberpunk
│   │   └── app_strings.dart         # Textos en español
│   ├── theme/
│   │   └── cyberpunk_theme.dart     # ThemeData completo
│   ├── services/
│   │   └── isar_service.dart        # Inicialización de BD
│   └── utils/
│       └── platform_channel.dart    # Comunicación Android nativo
├── features/
│   ├── auth/                         # Autenticación y roles
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           ├── role_selection_screen.dart
│   │           └── pin_screen.dart
│   ├── hud/                          # Pantalla principal del niño
│   │   └── presentation/
│   │       └── screens/
│   │           └── hud_main_screen.dart
│   ├── parent/                       # Dashboard del padre
│   │   └── presentation/
│   │       └── screens/
│   │           └── parent_dashboard_screen.dart
│   ├── arena/                        # Módulo de ejercicio
│   ├── biofuel/                      # Módulo de nutrición
│   ├── comms/                        # Módulo de lectura
│   ├── logic/                        # Módulo de puzzles
│   ├── math/                         # Módulo de matemáticas
│   ├── coding/                       # Módulo de programación
│   ├── biocoins/                     # Sistema de monedas
│   │   ├── data/
│   │   └── domain/
│   └── monitor/                      # Sistema de monitoreo de apps
│       ├── data/
│       └── domain/
└── shared/
    ├── providers/
    │   └── global_providers.dart
    └── widgets/
        └── [widgets reutilizables]
```

---

## ✨ Módulos Principales (LA MINA)

Cada módulo sigue arquitectura clean (data/domain/presentation) con Riverpod.

### 1. 🏃 ARENA - Centro de Entrenamiento
**Objetivo**: Ejercicio físico con detección de movimiento

**Funcionalidades**:
- Contador de pasos usando `sensors_plus`
- Integración con Health Connect/Google Fit
- Detección de movimiento activo (saltos, sentadillas)
- Cálculo de calorías quemadas
- Meta diaria de pasos configurable por el padre

**Recompensas**:
- Base: 15 Bio-Coins por cada 1000 pasos
- Bonus: +5 coins por completar meta diaria
- Ajustable por el padre

**UI**:
- Animación de avatar moviéndose
- Gráfica de progreso circular con glow naranja (#FF6B35)
- Contador animado de pasos
- Efecto de partículas al ganar coins

---

### 2. 🥗 BIO-FUEL - Estación Nutricional
**Objetivo**: Análisis nutricional de comidas con cámara

**Funcionalidades**:
- Tomar foto de la comida
- Análisis básico de categorías (verduras, proteína, carbohidratos, chatarra)
- Quiz rápido: "¿Qué comiste?" con opciones
- Base de datos local de alimentos comunes
- Registro de comidas del día

**Recompensas**:
- Comida balanceada: 25 coins
- Comida saludable: 20 coins
- Comida regular: 10 coins
- Chatarra: 0 coins
- Bonus: +10 coins por 3 comidas saludables al día

**UI**:
- Viewfinder con overlay de scanner
- Animación de análisis (scanlines)
- Tarjeta de resultado con categorización
- Glow verde (#00FF88) para comidas aprobadas

---

### 3. 📚 COMMS - Centro de Comunicaciones
**Objetivo**: Lectura con OCR y comprensión

**Funcionalidades**:
- Tomar foto de página de libro
- OCR con `google_mlkit_text_recognition`
- Contar palabras leídas
- Quiz automático de comprensión (3 preguntas simples generadas a partir del texto)
- Historial de lecturas

**Recompensas**:
- Base: 25 coins por quiz completado
- Bonus por respuestas correctas: +5 coins por cada una
- Bonus por racha de lectura diaria

**UI**:
- Scanner de texto con marco azul (#4D9FFF)
- Texto extraído mostrado en pantalla
- Quiz con opciones de respuesta
- Contador de palabras con animación

---

### 4. 🧩 LOGIC - Laboratorio de Ingenio
**Objetivo**: Puzzles de lógica y memoria

**Tipos de Puzzles**:
- **Secuencias de patrones**: Completar serie (formas, colores)
- **Memoria**: Juego de pares con cartas
- **Sudoku simple**: 4x4 para niños
- **Asociaciones**: Relacionar conceptos

**Dificultad**:
- 3 niveles: Fácil, Medio, Difícil
- Progresión automática según edad del niño

**Recompensas**:
- Fácil: 10 coins
- Medio: 15 coins
- Difícil: 25 coins
- Bonus por tiempo récord

**UI**:
- Tablero con animaciones suaves
- Efecto de partículas púrpura (#B24BF3) al resolver
- Timer opcional
- Celebración con confetti neón

---

### 5. ➗ MATH - Reactor Matemático
**Objetivo**: Problemas matemáticos adaptativos

**Tipos de Ejercicios**:
- Suma y resta (nivel 1-3)
- Multiplicación y división (nivel 4-6)
- Fracciones básicas (nivel 7+)
- Problemas de palabra

**Adaptativo**:
- El sistema ajusta dificultad según respuestas correctas/incorrectas
- 10 problemas por sesión
- Feedback inmediato

**Recompensas**:
- 10 coins por problema correcto
- Bonus: +20 coins por sesión perfecta (10/10)
- Penalización: -5 coins por respuesta incorrecta (no negativo)

**UI**:
- Problema mostrado con tipografía grande
- Teclado numérico neón
- Barra de progreso (10 problemas)
- Animación de ecuación resuelta con glow cyan

---

### 6. 💻 CODING - Terminal de Programación
**Objetivo**: Programación básica con bloques visuales

**Concepto**:
- Programación por bloques estilo Scratch
- Mover un robot/avatar en cuadrícula
- Lógica básica: secuencias, loops, condicionales

**Niveles**:
- 1-5: Secuencias simples (mover, girar)
- 6-10: Loops básicos (repetir 3 veces)
- 11-15: Condicionales (si hay obstáculo, girar)
- 16+: Funciones simples

**Recompensas**:
- Base: 30 coins por nivel completado
- Bonus: +10 coins por solución óptima (menos bloques)
- Bonus: +15 coins por nivel sin errores

**UI**:
- Paleta de bloques de código
- Vista de cuadrícula con avatar
- Botón "Ejecutar" con animación
- Efecto matrix verde (#39FF14) en fondo

---

## 👨‍👩‍👧‍👦 Panel de Padres

### Funcionalidades Principales

#### 1. Dashboard Principal
- **Vista general del día**:
  - Tiempo restante de cada hijo
  - Bio-Coins ganados hoy
  - Actividades completadas
  - Gráfica de uso semanal

#### 2. Gestión de Hijos
- Agregar/editar perfil de hijo
- Avatar personalizado
- Edad (para ajustar dificultad)
- PIN propio (opcional)

#### 3. Control de Tiempo
- **Tiempo diario total**: Límite de pantalla por día
- **Tiempo por app**: Límite específico (ej: YouTube 1h, juegos 30min)
- **Horarios permitidos**: Bloques horarios (ej: 4pm - 8pm)
- **Días de escuela vs fin de semana**: Configuración diferente

#### 4. Gestión de Apps
- Lista de apps instaladas en el dispositivo
- Clasificación:
  - **Educativas**: Sin límite de tiempo
  - **Entretenimiento**: Requiere Bio-Coins
  - **Bloqueadas**: Nunca permitidas
- Asignar costo en Bio-Coins por minuto: Configurable (default: 5 coins = 1 minuto)

#### 5. Tareas Personalizadas
- Crear tareas manuales (ej: "Ordenar cuarto")
- Asignar recompensa en Bio-Coins
- Marcar como completada
- Foto de verificación (opcional)

#### 6. Configuración de Recompensas
- Ajustar coins ganados por cada actividad
- Ajustar ratio Bio-Coins a minutos de pantalla
- Habilitar/deshabilitar módulos

#### 7. Estadísticas
- Historial de actividades
- Gráficas de uso
- Reportes semanales/mensuales
- Exportar datos

#### 8. Seguridad
- PIN de acceso al panel (obligatorio)
- Opción de ocultar icono de app
- Solicitar PIN para desinstalar

---

## 🔒 Sistema de Autenticación y Roles

### Flujo de Inicio
1. **Primera vez**:
   - Pantalla de bienvenida
   - Crear perfil de Comandante (padre) con PIN
   - Crear perfil de Piloto (hijo) 
   - Tutorial rápido

2. **Usos posteriores**:
   - Pantalla de selección de rol: "¿Quién eres?"
   - **Piloto**: Acceso directo a HUD
   - **Comandante**: Solicitar PIN → Dashboard

### Cambio de Roles
- Icono discreto en esquina superior para cambiar de rol
- Requiere PIN para acceder como Comandante
- Logout de sesión de Piloto

---

## 📱 Sistema de Monitoreo y Bloqueo (Android)

### Componentes Nativos (Kotlin)

#### 1. MonitorService (Foreground Service)
```kotlin
// Servicio persistente que corre en background
- Monitorea app en primer plano cada segundo
- Verifica tiempo restante del usuario
- Verifica si la app está permitida
- Actualiza contador de tiempo usado
- Dispara bloqueo si se excede límite
```

#### 2. BlockOverlayActivity
```kotlin
// Pantalla de bloqueo no-dismissible
- Overlay de pantalla completa
- Muestra mensaje: "Tiempo agotado. Gana más Bio-Coins."
- Botón "Ver Misiones" → Abre HUD
- Botón "Pedir más tiempo" → Notifica al padre
- No se puede cerrar con back button
- Uso de SYSTEM_ALERT_WINDOW permission
```

#### 3. UsageStatsManager Integration
```kotlin
// Obtener estadísticas reales de uso
- Query de uso por app en tiempo real
- Historial de uso
- Permisos: PACKAGE_USAGE_STATS
```

#### 4. AppListHelper
```kotlin
// Obtener apps instaladas
- Lista de apps del sistema
- Filtrar apps del sistema
- Obtener nombres e iconos
```

### Permisos Requeridos (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" />
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />
```

---

## 💾 Modelos de Datos (Isar)

### User (Piloto/Comandante)
```dart
@collection
class User {
  Id id = Isar.autoIncrement;
  
  String name;
  String role; // "pilot" | "commander"
  String? avatarPath;
  int? age; // Solo para pilotos
  
  // Seguridad
  String? pinHash; // Hash SHA-256 del PIN
  
  // Bio-Coins (solo pilotos)
  int bioCoins;
  
  // Tiempo
  int dailyTimeLimit; // Minutos permitidos por día
  int timeRemaining; // Minutos restantes hoy
  DateTime lastReset; // Para resetear diariamente
  
  // Configuración
  bool isCurrent; // Usuario activo
  DateTime createdAt;
}
```

### Activity (Registro de actividades)
```dart
@collection
class Activity {
  Id id = Isar.autoIncrement;
  
  int userId; // Relación con User
  String type; // "arena" | "biofuel" | "comms" | etc.
  String description; // Ej: "1500 pasos"
  int coinsEarned;
  DateTime completedAt;
  
  // Metadata opcional
  Map<String, dynamic>? metadata; // JSON con detalles extras
}
```

### AppUsage (Monitoreo de apps)
```dart
@collection
class AppUsage {
  Id id = Isar.autoIncrement;
  
  int userId;
  String packageName;
  String appName;
  int timeUsedToday; // Milisegundos
  DateTime lastUsed;
}
```

### AppConfig (Configuración de apps)
```dart
@collection
class AppConfig {
  Id id = Isar.autoIncrement;
  
  String packageName;
  String appName;
  String category; // "educational" | "entertainment" | "blocked"
  int dailyLimit; // Minutos permitidos (-1 = sin límite)
  int costPerMinute; // Bio-Coins requeridos por minuto
  bool requiresCoins; // Si requiere canjear coins
}
```

### CustomTask (Tareas manuales del padre)
```dart
@collection
class CustomTask {
  Id id = Isar.autoIncrement;
  
  int userId; // Piloto asignado
  String title;
  String? description;
  int reward; // Bio-Coins a ganar
  bool isCompleted;
  String? verificationPhotoPath;
  DateTime createdAt;
  DateTime? completedAt;
}
```

---

## 🎨 Componentes de UI Reutilizables

### 1. NexusButton
- Botón con efecto glow neón
- Variantes: primary, secondary, danger
- Animación al presionar
- Opcional: gradiente, icono

### 2. BioCoinCounter
- Widget animado de Bio-Coins
- Icono de moneda con glow verde
- Contador con tipografía Orbitron
- Animación al incrementar/decrementar

### 3. TimeRemainingWidget
- Reloj cuenta regresiva
- Progreso circular
- Cambio de color según tiempo (verde → amarillo → rojo)
- Animación de pulso cuando tiempo bajo

### 4. ModuleCard
- Tarjeta de módulo/misión
- Icono del módulo con glow
- Título con Orbitron
- Descripción con Rajdhani
- Indicador de recompensa
- Estado: disponible, completado, bloqueado

### 5. NeonBorder
- Container con borde neón animado
- Efecto de scanline
- Variantes de color

### 6. StatCard
- Tarjeta de estadística individual
- Icono + valor + label
- Glow opcional
- Animación de entrada

### 7. HudAppBar
- AppBar personalizado estilo HUD
- Título con letras espaciadas
- Botón de regreso con estilo neón
- Icono de ayuda

---

## 🎮 Pantallas Principales

### 1. RoleSelectionScreen
- Dos cards grandes: "PILOTO" y "COMANDANTE"
- Animación de entrada (fade + slide)
- Ilustraciones de avatar según rol
- Efectos hover

### 2. PinScreen
- Input de PIN con 4 círculos
- Teclado numérico personalizado con estilo neón
- Animación de error (shake)
- Mensaje de error con glow rojo

### 3. HudMainScreen (Pantalla del Niño)
**Header**:
- Avatar del piloto
- Nombre con glow
- Bio-Coins contador animado
- Tiempo restante

**Body**:
- Grid de módulos (2 columnas)
- Cada módulo es un ModuleCard
- Indicador de "nuevos coins disponibles"

**Footer**:
- Botón "Canjear Tiempo"
- Botón de configuración (cambiar avatar)

### 4. ParentDashboardScreen
**Tabs**:
1. **Resumen**: Dashboard general
2. **Hijos**: Lista y gestión de perfiles
3. **Apps**: Control de aplicaciones
4. **Tareas**: Crear tareas manuales
5. **Estadísticas**: Gráficas y reportes
6. **Configuración**: Settings generales

**Header**:
- Título "Centro de Comando"
- Selector de hijo activo
- Botón de logout

### 5. Pantallas de Módulos
Cada módulo tiene estructura similar:
- **Header**: Título del módulo, tiempo estimado, recompensa
- **Body**: Interfaz específica del módulo
- **Footer**: Botón "Completar Misión" / "Validar"

---

## 🔧 Configuración y Setup Inicial

### main.dart - Inicialización
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Orientación portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // UI del sistema
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Inicializar Isar
  await IsarService.initialize();
  
  // Iniciar servicio de monitoreo (Android)
  if (Platform.isAndroid) {
    await PlatformChannel.startMonitorService();
  }
  
  runApp(const ProviderScope(child: NexusControlApp()));
}
```

### Rutas
```dart
routes: {
  '/role-selection': (context) => const RoleSelectionScreen(),
  '/pin': (context) => const PinScreen(),
  '/hud': (context) => const HudMainScreen(),
  '/parent': (context) => const ParentDashboardScreen(),
  '/arena': (context) => const ArenaScreen(),
  '/biofuel': (context) => const BioFuelScreen(),
  '/comms': (context) => const CommsScreen(),
  '/logic': (context) => const LogicScreen(),
  '/math': (context) => const MathScreen(),
  '/coding': (context) => const CodingScreen(),
}
```

---

## 📐 Especificaciones de Diseño

### Spacing System
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- xxl: 48px

### Border Radius
- sm: 8px
- md: 16px
- lg: 24px
- full: 9999px (circular)

### Shadows & Glows
```dart
// Glow neón para elementos destacados
BoxShadow(
  color: AppColors.neonCyan.withOpacity(0.5),
  blurRadius: 20,
  spreadRadius: 2,
)

// Elevación sutil para cards
BoxShadow(
  color: Colors.black.withOpacity(0.3),
  blurRadius: 10,
  offset: Offset(0, 5),
)
```

### Animaciones
- Duración por defecto: 300ms
- Curva: Curves.easeInOut
- Transiciones de páginas: Slide + Fade
- Efectos de hover: Scale 1.05
- Botones: Scale down on tap

---

## 🎯 Flujos de Usuario Completos

### Flujo 1: Primer Uso
1. Splash screen (logo Nexus con glow)
2. Bienvenida: "¡Bienvenido a Nexus Control!"
3. Crear perfil de Comandante:
   - Nombre
   - PIN de 4 dígitos
   - Confirmar PIN
4. Crear perfil de Piloto:
   - Nombre
   - Edad
   - Seleccionar avatar
5. Configuración inicial:
   - Tiempo diario permitido
   - Ratio Bio-Coins a minutos (default: 5:1)
6. Solicitar permisos:
   - Uso de apps
   - Overlay
   - Cámara
   - Sensores
7. Tutorial interactivo:
   - "Así ganas Bio-Coins"
   - "Así canjeas tiempo"
   - "Tu padre controla todo"
8. → Ir a HUD

### Flujo 2: Niño Completa Misión (Arena)
1. HUD → Tap en card "Arena"
2. ArenaScreen carga
3. Pedir permiso de sensores
4. Iniciar contador de pasos
5. Mostrar progreso en tiempo real
6. Niño camina/corre
7. Al llegar a 1000 pasos:
   - Animación de celebración
   - "+15 Bio-Coins" con efecto
   - Actualizar contador global
   - Guardar Activity en Isar
8. Botón "Continuar" → Regresa a HUD
9. HUD actualizado con nuevos coins

### Flujo 3: Niño Canjea Tiempo
1. HUD → Tap en "Canjear Tiempo"
2. Modal con:
   - Coins disponibles
   - Ratio actual (ej: 5 coins = 1 min)
   - Input: ¿Cuántos minutos quieres?
   - Cálculo automático de costo
3. Tap "Confirmar"
4. Validar si tiene suficientes coins
5. Si sí:
   - Restar coins
   - Sumar minutos a timeRemaining
   - Animación de éxito
   - "¡Ganaste 30 minutos!"
6. Si no:
   - Mensaje: "No tienes suficientes coins"
   - Mostrar cuántos faltan
   - Botón "Ver Misiones"

### Flujo 4: Padre Agrega App Bloqueada
1. Login como Comandante con PIN
2. Tab "Apps"
3. Ver lista de apps instaladas
4. Tap en "YouTube Kids"
5. Modal de configuración:
   - Selector de categoría: Educativa | Entretenimiento | Bloqueada
   - Input: Límite diario (minutos)
   - Input: Costo por minuto (coins)
   - Toggle: ¿Requiere canjear coins?
6. Seleccionar "Entretenimiento"
7. Límite: 60 minutos
8. Costo: 5 coins/minuto
9. Requiere coins: ON
10. Guardar
11. AppConfig guardado en Isar
12. Toast de confirmación

### Flujo 5: Sistema Detecta Uso No Permitido
1. MonitorService detecta YouTube abierto
2. Verificar AppConfig:
   - requiresCoins = true
   - costPerMinute = 5
3. Calcular si el niño tiene Bio-Coins suficientes
4. Si NO:
   - Disparar BlockOverlayActivity
   - Mostrar: "YouTube requiere Bio-Coins. Gana más completando misiones."
   - Botones: "Ver Misiones" | "Cerrar YouTube"
5. Si SÍ:
   - Permitir uso
   - Iniciar timer
   - Cada minuto: restar 5 coins
   - Si coins llegan a 0 → Bloquear

---

## 🧪 Testing y Validación

### Tests Unitarios
- Modelos de Isar
- Lógica de cálculo de coins
- Validación de PIN
- Conversión coins ↔ tiempo

### Tests de Widget
- Cada módulo screen
- Componentes reutilizables
- Forms de configuración

### Tests de Integración
- Flujo completo: Actividad → Coins → Canjear tiempo
- Monitoreo de apps
- Bloqueo de apps

---

## 🚀 Entregables

### Funcionalidades Mínimas (MVP)
- ✅ Autenticación con roles (Piloto/Comandante)
- ✅ Sistema de Bio-Coins
- ✅ 2 módulos funcionando: Arena + Math
- ✅ Dashboard de padres básico
- ✅ Monitoreo de apps (Android)
- ✅ Bloqueo de apps cuando se acaba el tiempo
- ✅ Canjear coins por tiempo

### Funcionalidades Completas (v1.0)
- ✅ Los 6 módulos completos
- ✅ ML/OCR en Bio-Fuel y Comms
- ✅ Dashboard de padres con todas las opciones
- ✅ Estadísticas y reportes
- ✅ Tareas personalizadas
- ✅ Sistema de notificaciones
- ✅ Multi-usuario (varios hijos)

---

## 📝 Notas de Implementación

### Prioridades de Desarrollo
1. Core: Auth, DB, State Management
2. HUD del niño + Bio-Coins
3. Módulo Arena (el más simple)
4. Dashboard de padres básico
5. Monitoreo y bloqueo de apps
6. Resto de módulos
7. Pulido y animaciones

### Consideraciones Técnicas
- **Offline-first**: Toda la data en Isar local
- **Privacidad**: No enviar datos a servidores externos
- **Performance**: Optimizar animaciones (60 FPS)
- **Accesibilidad**: Tamaños de fuente configurables
- **Idioma**: Español (opcionalmente multilenguaje)

### Optimizaciones
- Lazy loading de módulos
- Caché de imágenes
- Throttling de sensores
- Debouncing en búsquedas

---

## 🎨 Assets Necesarios

### Iconos
- Logo Nexus (SVG)
- Iconos de cada módulo (Arena, Bio-Fuel, etc.)
- Icono de Bio-Coin
- Avatares para Piloto/Comandante

### Imágenes
- Fondos de cada módulo (opcional)
- Ilustraciones de celebración
- Gráficos de estado vacío

### Sonidos
- Coin ganado (ding)
- Misión completada (fanfare)
- Error (buzz)
- Bloqueo de app (alerta)

### Fuentes
- Orbitron (Google Fonts)
- Rajdhani (Google Fonts)

---

## 🔐 Seguridad

### Protección del Panel de Padres
- PIN obligatorio (mínimo 4 dígitos)
- Hash con SHA-256 antes de guardar
- Máximo 3 intentos fallidos → Lockout temporal

### Prevenir Desinstalación
- Solicitar Device Admin permission
- Al intentar desinstalar → Pedir PIN de Comandante

### Prevenir Bypass del Sistema
- Servicio de monitoreo persistente
- Reiniciar servicio si se detiene
- Verificación cada segundo de app en foreground

---

## 📱 Compatibilidad

### Android
- Mínimo: Android 7.0 (API 24)
- Target: Android 14 (API 34)
- Permisos especiales: Usage Stats, Overlay, Device Admin

### iOS (Opcional - Limitado)
- Screen Time API (limitado)
- No permite bloqueo completo de apps
- Alternativa: Modo "honor system" solo con tracking

---

## ✅ Checklist de Implementación

### Paso 1: Configuración Inicial
- [ ] Crear proyecto Flutter
- [ ] Agregar dependencias del pubspec.yaml
- [ ] Configurar Isar
- [ ] Crear estructura de carpetas
- [ ] Configurar AndroidManifest con permisos

### Paso 2: Theme y Constantes
- [ ] app_colors.dart completo
- [ ] app_strings.dart completo
- [ ] cyberpunk_theme.dart completo
- [ ] Widgets base (NexusButton, etc.)

### Paso 3: Modelos de Datos
- [ ] User model con Isar
- [ ] Activity model
- [ ] AppConfig model
- [ ] AppUsage model
- [ ] CustomTask model
- [ ] Generar archivos con build_runner

### Paso 4: Autenticación
- [ ] RoleSelectionScreen
- [ ] PinScreen
- [ ] Providers de auth (Riverpod)
- [ ] Lógica de validación de PIN

### Paso 5: HUD del Niño
- [ ] HudMainScreen
- [ ] BioCoinCounter widget
- [ ] TimeRemainingWidget
- [ ] ModuleCard widget
- [ ] Navegación a módulos

### Paso 6: Módulo Arena
- [ ] ArenaScreen
- [ ] Integración con sensors_plus
- [ ] Contador de pasos
- [ ] Lógica de recompensa
- [ ] Guardar Activity

### Paso 7: Dashboard de Padres
- [ ] ParentDashboardScreen
- [ ] Tab de Resumen
- [ ] Tab de Hijos
- [ ] Tab de Apps
- [ ] Configuración de límites

### Paso 8: Sistema de Monitoreo (Android Native)
- [ ] MonitorService en Kotlin
- [ ] UsageStatsManager integration
- [ ] Method channel Flutter ↔ Android
- [ ] BlockOverlayActivity
- [ ] Lógica de bloqueo

### Paso 9: Resto de Módulos
- [ ] BioFuelScreen
- [ ] CommsScreen (OCR)
- [ ] LogicScreen
- [ ] MathScreen
- [ ] CodingScreen

### Paso 10: Pulido
- [ ] Animaciones con flutter_animate
- [ ] Transiciones de página
- [ ] Glows y efectos neón
- [ ] Sonidos
- [ ] Testing

---

## 🎓 Contexto Educativo

### Valores que Promueve
- **Autorregulación**: El niño aprende a controlar su tiempo
- **Responsabilidad**: Cumplir tareas para ganar recompensas
- **Hábitos saludables**: Ejercicio, lectura, alimentación
- **Aprendizaje**: Matemáticas, lógica, programación
- **Transparencia**: El niño entiende las reglas del juego

### Diferenciadores vs Otras Apps
- ✅ Gamificación real (no solo bloqueo)
- ✅ Gratis (sin modelo freemium)
- ✅ Estética atractiva para niños
- ✅ Educativo + Saludable
- ✅ Control parental sin ser invasivo

---

## 🎯 Resultado Esperado

Una aplicación móvil Flutter funcional con:
- Interfaz fluida y atractiva con tema cyberpunk
- Sistema de recompensas Bio-Coins completo
- 6 módulos de actividades diferentes
- Dashboard de padres con control total
- Monitoreo real de apps en Android
- Sistema de bloqueo efectivo
- Experiencia educativa y motivadora para niños
- Herramienta de control parental moderna y ética

---

**Nota Final**: Este proyecto combina educación, gamificación y control parental de manera innovadora. La clave está en mantener la experiencia FUN para el niño mientras da control total a los padres. El tema cyberpunk hace que todo se sienta como un juego de misiones espaciales en vez de una app de "vigilancia".

¡Buena suerte con la implementación! 🚀
