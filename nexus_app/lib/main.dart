/// ============================================
/// NEXUS CONTROL - Main Entry Point
/// ============================================
/// Punto de entrada principal de la aplicación

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/cyberpunk_theme.dart';
import 'core/services/isar_service.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_colors.dart';

// Screens
import 'features/hud/presentation/screens/hud_main_screen.dart';
import 'features/auth/presentation/screens/role_selection_screen.dart';
import 'features/auth/presentation/screens/pin_screen.dart';
import 'features/parent/presentation/screens/parent_dashboard_screen.dart';
import 'features/arena/presentation/screens/arena_screen.dart';
import 'features/biofuel/presentation/screens/biofuel_screen.dart';
import 'features/comms/presentation/screens/comms_screen.dart';
import 'features/logic/presentation/screens/logic_screen.dart';
import 'features/math/presentation/screens/math_screen.dart';
import 'features/coding/presentation/screens/coding_screen.dart';
import 'features/neuro/presentation/screens/neuro_screen.dart';
import 'features/override/presentation/screens/override_screen.dart';
import 'features/wall/presentation/screens/wall_screen.dart';

// Providers
import 'shared/providers/global_providers.dart';

void main() async {
  // Asegurar inicialización de Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar orientación y UI del sistema
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Configurar barra de estado transparente con íconos claros
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  // Inicializar Isar (base de datos local)
  await IsarService.initialize();
  
  // Ejecutar la aplicación
  runApp(
    const ProviderScope(
      child: NexusControlApp(),
    ),
  );
}

/// Aplicación principal
class NexusControlApp extends ConsumerWidget {
  const NexusControlApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      
      // Tema cyberpunk personalizado
      theme: CyberpunkTheme.darkTheme,
      darkTheme: CyberpunkTheme.darkTheme,
      themeMode: ThemeMode.dark,
      
      // Ruta inicial
      home: const AppStartupScreen(),
      
      // Rutas nombradas
      routes: {
        '/role-selection': (context) => const RoleSelectionScreen(),
        '/pin': (context) => const PinScreen(),
        '/hud': (context) => const HudMainScreen(),
        '/parent': (context) => const ParentDashboardScreen(),
        // Módulos "La Mina"
        '/arena': (context) => const ArenaScreen(),
        '/biofuel': (context) => const BioFuelScreen(),
        '/comms': (context) => const CommsScreen(),
        '/logic': (context) => const LogicScreen(),
        '/math': (context) => const MathScreen(),
        '/coding': (context) => const CodingScreen(),
        '/neuro': (context) => const NeuroScreen(),
        '/override': (context) => const OverrideScreen(),
        '/wall': (context) => const WallScreen(),
      },
    );
  }
}

/// Pantalla de inicio que determina el flujo inicial
class AppStartupScreen extends ConsumerStatefulWidget {
  const AppStartupScreen({super.key});

  @override
  ConsumerState<AppStartupScreen> createState() => _AppStartupScreenState();
}

class _AppStartupScreenState extends ConsumerState<AppStartupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
    
    _initializeApp();
  }
  
  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
  
  Future<void> _initializeApp() async {
    // Verificar permisos
    await ref.read(permissionsStateProvider.notifier).checkAll();
    
    // Verificar si hay usuarios registrados
    final usersCount = await IsarService.users.count();
    
    await Future.delayed(const Duration(milliseconds: 2500));
    
    if (!mounted) return;
    
    if (usersCount == 0) {
      // Primera vez: ir a selección de rol
      Navigator.of(context).pushReplacementNamed('/role-selection');
    } else {
      // Ya hay usuarios: ir a PIN
      Navigator.of(context).pushReplacementNamed('/pin');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Opacity(
              opacity: _animController.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo animado
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonCyan.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shield,
                      size: 60,
                      color: AppColors.background,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Nombre de la app
                  const Text(
                    'NEXUS CONTROL',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonCyan,
                      letterSpacing: 4,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Control Parental Gamificado',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      letterSpacing: 2,
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Indicador de carga
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.neonCyan.withOpacity(0.7),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Inicializando sistemas...',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
