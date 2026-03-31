/// ============================================
/// NEXUS CONTROL - Parent Dashboard Screen
/// ============================================
/// Panel de control completo para el padre (Comandante)
/// Control total de parametrización

import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/biocoin_service.dart';
import '../../../../core/services/isar_service.dart';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../biocoins/domain/entities/biocoin_entity.dart';
import '../../../monitor/domain/entities/blacklist_entity.dart';
import '../../../monitor/domain/entities/task_entity.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ParentDashboardScreen extends ConsumerStatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  ConsumerState<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends ConsumerState<ParentDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.neonMagenta),
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                color: AppColors.neonMagenta,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Panel de Comandante',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.neonMagenta,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
            onPressed: _logout,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.neonMagenta,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.neonMagenta,
          tabs: const [
            Tab(icon: Icon(Icons.child_care), text: 'Pilotos'),
            Tab(icon: Icon(Icons.apps), text: 'Apps'),
            Tab(icon: Icon(Icons.assignment), text: 'Tareas'),
            Tab(icon: Icon(Icons.settings), text: 'Config'),
            Tab(icon: Icon(Icons.history), text: 'Historial'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChildrenTab(),
          _buildAppsTab(),
          _buildTasksTab(),
          _buildSettingsTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }
  
  /// ========== TAB: PILOTOS (HIJOS) ==========
  Widget _buildChildrenTab() {
    return FutureBuilder<List<UserEntity>>(
      future: _getChildren(),
      builder: (context, snapshot) {
        final children = snapshot.data ?? [];
        
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Botón agregar hijo
            NeonButton(
              text: 'Agregar Piloto',
              icon: Icons.person_add,
              color: AppColors.neonCyan,
              onPressed: () => _showAddChildDialog(),
            ),
            
            const SizedBox(height: 24),
            
            // Lista de hijos
            ...children.map((child) => _buildChildCard(child)),
            
            if (children.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_off,
                        size: 64,
                        color: AppColors.textDisabled,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No hay pilotos registrados',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
  
  Widget _buildChildCard(UserEntity child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: HudPanel(
        borderColor: AppColors.neonCyan,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con nombre
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neonCyan.withOpacity(0.1),
                    border: Border.all(color: AppColors.neonCyan),
                  ),
                  child: const Icon(
                    Icons.rocket_launch,
                    color: AppColors.neonCyan,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Bio-Coins: ${child.bioCoins}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.neonYellow,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.textSecondary),
                  onPressed: () => _editChild(child),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),
            
            // Configuración de tiempo
            Row(
              children: [
                Expanded(
                  child: _buildConfigItem(
                    label: 'Tiempo diario',
                    value: '${child.dailyTimeAllowedMinutes} min',
                    icon: Icons.timer,
                    onTap: () => _editDailyTime(child),
                  ),
                ),
                Expanded(
                  child: _buildConfigItem(
                    label: 'Tiempo usado',
                    value: '${child.timeUsedTodayMinutes} min',
                    icon: Icons.hourglass_bottom,
                    color: AppColors.neonOrange,
                  ),
                ),
                Expanded(
                  child: _buildConfigItem(
                    label: 'Restante',
                    value: '${child.timeRemainingMinutes} min',
                    icon: Icons.hourglass_top,
                    color: child.timeRemainingMinutes > 0 
                        ? AppColors.neonGreen 
                        : AppColors.neonRed,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Acciones rápidas
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Dar tiempo'),
                    onPressed: () => _giveExtraTime(child),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.neonGreen,
                      side: const BorderSide(color: AppColors.neonGreen),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.monetization_on),
                    label: const Text('Dar coins'),
                    onPressed: () => _giveBioCoins(child),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.neonYellow,
                      side: const BorderSide(color: AppColors.neonYellow),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: -0.1);
  }
  
  Widget _buildConfigItem({
    required String label,
    required String value,
    required IconData icon,
    Color color = AppColors.neonCyan,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  /// ========== TAB: APPS ==========
  Widget _buildAppsTab() {
    return FutureBuilder<List<BlacklistApp>>(
      future: _getBlacklist(),
      builder: (context, snapshot) {
        final apps = snapshot.data ?? [];
        
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Agregar app desde instaladas
            NeonButton(
              text: 'Agregar App a Control',
              icon: Icons.add_circle,
              color: AppColors.neonCyan,
              onPressed: () => _showAddAppDialog(),
            ),
            
            const SizedBox(height: 16),
            
            // Añadir categorías predefinidas
            HudPanel(
              borderColor: AppColors.neonMagenta,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categorías Rápidas',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonMagenta,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCategoryChip('Redes Sociales', Icons.people, AppColors.neonMagenta),
                      _buildCategoryChip('Juegos', Icons.sports_esports, AppColors.neonOrange),
                      _buildCategoryChip('Streaming', Icons.play_circle, AppColors.moduleComms),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Lista de apps controladas
            const Text(
              'APPS CONTROLADAS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            
            ...apps.map((app) => _buildAppCard(app)),
            
            if (apps.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.apps,
                        size: 64,
                        color: AppColors.textDisabled,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No hay apps controladas',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
  
  Widget _buildCategoryChip(String label, IconData icon, Color color) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label),
      labelStyle: TextStyle(color: color, fontSize: 12),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
      onPressed: () => _addCategoryApps(label),
    );
  }
  
  Widget _buildAppCard(BlacklistApp app) {
    final Color statusColor;
    final String statusText;
    
    switch (app.controlType) {
      case AppControlType.blocked:
        statusColor = AppColors.neonRed;
        statusText = 'Bloqueada';
        break;
      case AppControlType.timeLimited:
        statusColor = AppColors.neonYellow;
        statusText = 'Límite: ${app.dailyLimitMinutes}min';
        break;
      case AppControlType.allowed:
        statusColor = AppColors.neonGreen;
        statusText = 'Permitida';
        break;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Ícono de app
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.background,
            ),
            child: const Icon(
              Icons.android,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          
          // Info de app
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.appName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Controles
          PopupMenuButton<AppControlType>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            color: AppColors.surfaceElevated,
            onSelected: (type) => _updateAppControl(app, type),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AppControlType.blocked,
                child: Text('Bloquear'),
              ),
              const PopupMenuItem(
                value: AppControlType.timeLimited,
                child: Text('Limitar tiempo'),
              ),
              const PopupMenuItem(
                value: AppControlType.allowed,
                child: Text('Permitir'),
              ),
            ],
          ),
          
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.neonRed),
            onPressed: () => _removeApp(app),
          ),
        ],
      ),
    );
  }
  
  /// ========== TAB: TAREAS ==========
  Widget _buildTasksTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Crear tarea personalizada
        NeonButton(
          text: 'Crear Tarea Personalizada',
          icon: Icons.add_task,
          color: AppColors.neonGreen,
          onPressed: () => _showCreateTaskDialog(),
        ),
        
        const SizedBox(height: 24),
        
        // Configuración de recompensas por módulo
        const Text(
          'RECOMPENSAS POR MÓDULO',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        
        _buildRewardConfig('Arena (Ejercicio)', 'Por 1000 pasos', 15, AppColors.moduleArena),
        _buildRewardConfig('Bio-Fuel (Nutrición)', 'Por comida saludable', 20, AppColors.moduleBiofuel),
        _buildRewardConfig('Comms (Lectura)', 'Por quiz completado', 25, AppColors.moduleComms),
        _buildRewardConfig('Logic (Ingenio)', 'Por puzzle resuelto', 15, AppColors.moduleLogic),
        _buildRewardConfig('Math (Matemáticas)', 'Por problema correcto', 10, AppColors.moduleMath),
        _buildRewardConfig('Coding (Programación)', 'Por ejercicio completado', 30, AppColors.moduleCoding),
        
        const SizedBox(height: 24),
        
        // Conversión Bio-Coins a tiempo
        HudPanel(
          borderColor: AppColors.neonYellow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.swap_horiz, color: AppColors.neonYellow),
                  SizedBox(width: 8),
                  Text(
                    'Conversión Coins → Tiempo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonYellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '10',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonYellow,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Bio-Coins',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.arrow_forward, color: AppColors.textSecondary),
                  const SizedBox(width: 16),
                  const Text(
                    '1',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonCyan,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'minuto',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton(
                  child: const Text('Modificar tasa'),
                  onPressed: () => _editConversionRate(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildRewardConfig(String title, String description, int coins, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              border: Border.all(color: color),
            ),
            child: Center(
              child: Text(
                '$coins',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
  
  /// ========== TAB: HISTORIAL BIO-COINS ==========
  Widget _buildHistoryTab() {
    return FutureBuilder<List<UserEntity>>(
      future: _getChildren(),
      builder: (context, snap) {
        final children = snap.data ?? [];
        if (children.isEmpty) {
          return const Center(
            child: Text(
              'Sin pilotos registrados',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }
        return DefaultTabController(
          length: children.length,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                labelColor: AppColors.neonYellow,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.neonYellow,
                tabs: children
                    .map((c) => Tab(text: c.name))
                    .toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: children
                      .map((c) => _ChildHistoryView(child: c))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ========== TAB: CONFIGURACIÓN ==========
  Widget _buildSettingsTab() {
    final permissions = ref.watch(permissionsStateProvider);
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Estado de permisos
        HudPanel(
          borderColor: AppColors.neonCyan,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.security, color: AppColors.neonCyan),
                  SizedBox(width: 8),
                  Text(
                    'Permisos del Sistema',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonCyan,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildPermissionRow(
                'Estadísticas de Uso',
                'Monitorear apps en tiempo real',
                permissions.hasUsageStats,
                () => ref.read(permissionsStateProvider.notifier).requestUsageStats(),
              ),
              _buildPermissionRow(
                'Superposición',
                'Mostrar pantalla de bloqueo',
                permissions.hasOverlay,
                () => ref.read(permissionsStateProvider.notifier).requestOverlay(),
              ),
              _buildPermissionRow(
                'Device Owner',
                'Control total (via ADB)',
                permissions.isDeviceOwner,
                null,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Control de servicio
        HudPanel(
          borderColor: AppColors.neonGreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.play_circle, color: AppColors.neonGreen),
                  SizedBox(width: 8),
                  Text(
                    'Servicio de Monitoreo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: NeonButton(
                      text: 'Iniciar',
                      icon: Icons.play_arrow,
                      color: AppColors.neonGreen,
                      onPressed: _startMonitorService,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NeonButton(
                      text: 'Detener',
                      icon: Icons.stop,
                      color: AppColors.neonRed,
                      onPressed: _stopMonitorService,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Información de Device Owner
        HudPanel(
          borderColor: AppColors.neonYellow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.neonYellow),
                  SizedBox(width: 8),
                  Text(
                    'Modo Device Owner',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonYellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Para control parental avanzado, ejecuta este comando via ADB:',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: const SelectableText(
                  'adb shell dpm set-device-owner com.saludable.nexus_control/.receivers.DeviceAdminReceiver',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'monospace',
                    color: AppColors.neonGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Cambiar PIN
        NeonButton(
          text: 'Cambiar PIN de Comandante',
          icon: Icons.lock,
          color: AppColors.neonMagenta,
          onPressed: () => _changePin(),
        ),
        
        const SizedBox(height: 100),
      ],
    );
  }
  
  Widget _buildPermissionRow(String title, String description, bool granted, VoidCallback? onRequest) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            granted ? Icons.check_circle : Icons.cancel,
            color: granted ? AppColors.neonGreen : AppColors.neonRed,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (!granted && onRequest != null)
            TextButton(
              onPressed: onRequest,
              child: const Text('Otorgar'),
            ),
        ],
      ),
    );
  }
  
  // ========== MÉTODOS DE DATOS ==========
  
  Future<List<UserEntity>> _getChildren() async {
    final isar = IsarService.instance;
    final all = await isar.userEntitys.where().findAll();
    return all.where((u) => u.role == UserRole.child).toList();
  }
  
  Future<List<BlacklistApp>> _getBlacklist() async {
    final isar = IsarService.instance;
    return await isar.blacklistApps.where().findAll();
  }
  
  // ========== ACCIONES ==========
  
  void _logout() {
    ref.read(currentUserProvider.notifier).clearUser();
    Navigator.of(context).pushReplacementNamed('/pin');
  }
  
  void _showAddChildDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddChildDialog(
        onAdd: (name, dailyMinutes) async {
          final child = UserEntity.child(
            name: name,
            dailyTimeMinutes: dailyMinutes,
          );
          await IsarService.instance.writeTxn(() async {
            await IsarService.instance.userEntitys.put(child);
          });
          setState(() {});
        },
      ),
    );
  }
  
  void _editChild(UserEntity child) {
    showDialog(
      context: context,
      builder: (context) => _AddChildDialog(
        title: 'Editar Piloto',
        initialName: child.name,
        initialMinutes: child.dailyTimeAllowedMinutes,
        onAdd: (name, dailyMinutes) async {
          child.name = name;
          child.dailyTimeAllowedMinutes = dailyMinutes;
          await IsarService.instance.writeTxn(() async {
            await IsarService.instance.userEntitys.put(child);
          });
          setState(() {});
        },
      ),
    );
  }
  
  void _editDailyTime(UserEntity child) {
    showDialog(
      context: context,
      builder: (context) => _TimePickerDialog(
        currentMinutes: child.dailyTimeAllowedMinutes,
        onConfirm: (minutes) async {
          child.dailyTimeAllowedMinutes = minutes;
          await IsarService.instance.writeTxn(() async {
            await IsarService.instance.userEntitys.put(child);
          });
          setState(() {});
        },
      ),
    );
  }
  
  void _giveExtraTime(UserEntity child) {
    showDialog(
      context: context,
      builder: (context) => _TimePickerDialog(
        title: 'Otorgar tiempo extra',
        currentMinutes: 30,
        onConfirm: (minutes) async {
          child.dailyTimeAllowedMinutes += minutes;
          await IsarService.instance.writeTxn(() async {
            await IsarService.instance.userEntitys.put(child);
          });
          setState(() {});
        },
      ),
    );
  }
  
  void _giveBioCoins(UserEntity child) {
    showDialog(
      context: context,
      builder: (context) => _CoinsPickerDialog(
        onConfirm: (coins) async {
          await ref.read(bioCoinServiceProvider).parentBonus(
            userId: child.id,
            coins: coins,
            reason: 'Bonus otorgado por Comandante',
          );
          setState(() {});
        },
      ),
    );
  }
  
  void _showAddAppDialog() async {
    final platformService = ref.read(platformServiceProvider);
    final installedApps = await platformService.getInstalledApps();
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => _AppPickerDialog(
        apps: installedApps,
        onSelect: (packageName, appName) async {
          final blacklistApp = BlacklistApp.blocked(
            packageName: packageName,
            appName: appName,
          );
          await IsarService.instance.writeTxn(() async {
            await IsarService.instance.blacklistApps.put(blacklistApp);
          });
          
          // Actualizar blacklist en servicio nativo
          final blacklist = await _getBlacklist();
          await platformService.updateBlacklist(
            blacklist.map((a) => a.packageName).toList(),
          );
          
          setState(() {});
        },
      ),
    );
  }
  
  void _addCategoryApps(String category) async {
    List<Map<String, dynamic>> apps;
    
    switch (category) {
      case 'Redes Sociales':
        apps = PredefinedCategories.socialMedia;
        break;
      case 'Juegos':
        apps = PredefinedCategories.games;
        break;
      case 'Streaming':
        apps = PredefinedCategories.streaming;
        break;
      default:
        return;
    }
    
    for (final app in apps) {
      final blacklistApp = BlacklistApp.blocked(
        packageName: app['package'],
        appName: app['name'],
      );
      await IsarService.instance.writeTxn(() async {
        await IsarService.instance.blacklistApps.put(blacklistApp);
      });
    }
    
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Agregadas ${apps.length} apps de $category'),
      ),
    );
  }
  
  void _updateAppControl(BlacklistApp app, AppControlType type) async {
    app.controlType = type;
    app.updatedAt = DateTime.now();
    
    if (type == AppControlType.timeLimited) {
      // Mostrar diálogo para configurar tiempo
      showDialog(
        context: context,
        builder: (context) => _TimePickerDialog(
          title: 'Límite diario para ${app.appName}',
          currentMinutes: app.dailyLimitMinutes,
          onConfirm: (minutes) async {
            app.dailyLimitMinutes = minutes;
            await IsarService.instance.writeTxn(() async {
              await IsarService.instance.blacklistApps.put(app);
            });
            setState(() {});
          },
        ),
      );
    } else {
      await IsarService.instance.writeTxn(() async {
        await IsarService.instance.blacklistApps.put(app);
      });
      setState(() {});
    }
  }
  
  void _removeApp(BlacklistApp app) async {
    await IsarService.instance.writeTxn(() async {
      await IsarService.instance.blacklistApps.delete(app.id);
    });
    setState(() {});
  }
  
  void _showCreateTaskDialog() async {
    final children = await _getChildren();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => _CreateTaskDialog(
        children: children,
        onCreate: (task) async {
          await IsarService.instance.writeTxn(() async {
            await IsarService.instance.taskEntitys.put(task);
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('¡Tarea "${task.title}" creada (+${task.rewardCoins} ◈)'),
                backgroundColor: AppColors.neonGreen,
              ),
            );
          }
        },
      ),
    );
  }
  
  void _editConversionRate() async {
    final config = await IsarService.getConfig();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => _ConversionRateDialog(
        config: config,
        onSave: (updated) async {
          await IsarService.instance.writeTxn(() async {
            await IsarService.instance.bioCoinConfigs.put(updated);
          });
          ref.invalidate(bioCoinConfigProvider);
        },
      ),
    );
  }
  
  Future<void> _startMonitorService() async {
    final platform = ref.read(platformServiceProvider);
    final success = await platform.startMonitorService();
    
    if (success) {
      ref.read(monitoringActiveProvider.notifier).state = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Servicio de monitoreo iniciado')),
      );
    }
  }
  
  Future<void> _stopMonitorService() async {
    final platform = ref.read(platformServiceProvider);
    final success = await platform.stopMonitorService();
    
    if (success) {
      ref.read(monitoringActiveProvider.notifier).state = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Servicio de monitoreo detenido')),
      );
    }
  }
  
  void _changePin() {
    Navigator.of(context).pushNamed(
      '/pin',
      arguments: {'isSetup': true, 'isParent': true},
    );
  }
}

// ========== DIÁLOGOS AUXILIARES ==========

class _AddChildDialog extends StatefulWidget {
  final String title;
  final String initialName;
  final int initialMinutes;
  final Function(String name, int dailyMinutes) onAdd;

  const _AddChildDialog({
    this.title = 'Agregar Piloto',
    this.initialName = '',
    this.initialMinutes = 60,
    required this.onAdd,
  });

  @override
  State<_AddChildDialog> createState() => _AddChildDialogState();
}

class _AddChildDialogState extends State<_AddChildDialog> {
  late final TextEditingController _nameController;
  late int _dailyMinutes;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _dailyMinutes = widget.initialMinutes;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceElevated,
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              hintText: 'Nombre del niño',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Tiempo diario: '),
              Expanded(
                child: Slider(
                  value: _dailyMinutes.toDouble(),
                  min: 15,
                  max: 180,
                  divisions: 11,
                  label: '$_dailyMinutes min',
                  onChanged: (v) => setState(() => _dailyMinutes = v.toInt()),
                ),
              ),
              Text('$_dailyMinutes min'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onAdd(_nameController.text, _dailyMinutes);
              Navigator.pop(context);
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

class _TimePickerDialog extends StatefulWidget {
  final String title;
  final int currentMinutes;
  final Function(int minutes) onConfirm;
  
  const _TimePickerDialog({
    this.title = 'Configurar tiempo',
    required this.currentMinutes,
    required this.onConfirm,
  });
  
  @override
  State<_TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<_TimePickerDialog> {
  late int _minutes;
  
  @override
  void initState() {
    super.initState();
    _minutes = widget.currentMinutes;
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceElevated,
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$_minutes minutos',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.neonCyan,
            ),
          ),
          Slider(
            value: _minutes.toDouble(),
            min: 15,
            max: 240,
            divisions: 15,
            label: '$_minutes min',
            onChanged: (v) => setState(() => _minutes = v.toInt()),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfirm(_minutes);
            Navigator.pop(context);
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}

class _CoinsPickerDialog extends StatefulWidget {
  final Function(int coins) onConfirm;
  
  const _CoinsPickerDialog({required this.onConfirm});
  
  @override
  State<_CoinsPickerDialog> createState() => _CoinsPickerDialogState();
}

class _CoinsPickerDialogState extends State<_CoinsPickerDialog> {
  int _coins = 50;
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceElevated,
      title: const Text('Otorgar Bio-Coins'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$_coins Bio-Coins',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.neonYellow,
            ),
          ),
          Slider(
            value: _coins.toDouble(),
            min: 10,
            max: 200,
            divisions: 19,
            label: '$_coins',
            activeColor: AppColors.neonYellow,
            onChanged: (v) => setState(() => _coins = v.toInt()),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfirm(_coins);
            Navigator.pop(context);
          },
          child: const Text('Otorgar'),
        ),
      ],
    );
  }
}

class _AppPickerDialog extends StatelessWidget {
  final List<Map<String, String>> apps;
  final Function(String packageName, String appName) onSelect;
  
  const _AppPickerDialog({
    required this.apps,
    required this.onSelect,
  });
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceElevated,
      title: const Text('Seleccionar App'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            return ListTile(
              leading: const Icon(Icons.android, color: AppColors.neonCyan),
              title: Text(app['name'] ?? ''),
              subtitle: Text(
                app['package'] ?? '',
                style: const TextStyle(fontSize: 10),
              ),
              onTap: () {
                onSelect(app['package'] ?? '', app['name'] ?? '');
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}

// ========== VISTA HISTORIAL POR HIJO ==========

class _ChildHistoryView extends ConsumerWidget {
  final UserEntity child;
  const _ChildHistoryView({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final histAsync = ref.watch(bioCoinHistoryProvider(child.id));

    return histAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (txs) {
        if (txs.isEmpty) {
          return const Center(
            child: Text(
              'Sin transacciones aún',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }
        final earned = txs
            .where((t) => t.amount > 0)
            .fold(0, (a, t) => a + t.amount);
        final spent = txs
            .where((t) => t.amount < 0)
            .fold(0, (a, t) => a + t.amount.abs());
        return Column(
          children: [
            // Resumen
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _statChip('Ganados', '+$earned ◈',
                      AppColors.neonGreen),
                  const SizedBox(width: 8),
                  _statChip('Gastados', '-$spent ◈',
                      AppColors.neonOrange),
                  const SizedBox(width: 8),
                  _statChip('Balance',
                      '${child.bioCoins} ◈', AppColors.neonYellow),
                ],
              ),
            ),
            // Lista
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: txs.length,
                itemBuilder: (context, i) {
                  final tx = txs[i];
                  final isPositive = tx.amount > 0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isPositive
                            ? AppColors.neonGreen.withOpacity(0.2)
                            : AppColors.neonOrange.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isPositive
                              ? Icons.add_circle_outline
                              : Icons.remove_circle_outline,
                          color: isPositive
                              ? AppColors.neonGreen
                              : AppColors.neonOrange,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.description,
                                style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _fmt(tx.createdAt),
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${isPositive ? '+' : ''}${tx.amount} ◈',
                          style: TextStyle(
                            color: isPositive
                                ? AppColors.neonGreen
                                : AppColors.neonOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _statChip(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10)),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime dt) {
    return '${dt.day}/${dt.month} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ========== DIÁLOGO CREAR TAREA ==========

class _CreateTaskDialog extends StatefulWidget {
  final List<UserEntity> children;
  final Function(TaskEntity task) onCreate;
  const _CreateTaskDialog(
      {required this.children, required this.onCreate});

  @override
  State<_CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<_CreateTaskDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  int _coins = 20;
  int _selectedChildIdx = 0;
  TaskFrequency _freq = TaskFrequency.daily;
  bool _requiresVerification = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceElevated,
      title: const Text('Crear Tarea'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ej: Hacer 30 minutos de lectura',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            if (widget.children.isNotEmpty) ...[
              const Text('Piloto:',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13)),
              DropdownButton<int>(
                value: _selectedChildIdx,
                isExpanded: true,
                dropdownColor: AppColors.surfaceElevated,
                items: List.generate(
                  widget.children.length,
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text(widget.children[i].name),
                  ),
                ),
                onChanged: (v) =>
                    setState(() => _selectedChildIdx = v ?? 0),
              ),
              const SizedBox(height: 8),
            ],
            const Text('Frecuencia:',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
            DropdownButton<TaskFrequency>(
              value: _freq,
              isExpanded: true,
              dropdownColor: AppColors.surfaceElevated,
              items: const [
                DropdownMenuItem(
                    value: TaskFrequency.daily,
                    child: Text('Diaria')),
                DropdownMenuItem(
                    value: TaskFrequency.weekly,
                    child: Text('Semanal')),
                DropdownMenuItem(
                    value: TaskFrequency.once,
                    child: Text('Una sola vez')),
              ],
              onChanged: (v) => setState(() => _freq = v ?? _freq),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(
                    child: Text('Recompensa (coins):',
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13))),
                Text('$_coins ◈',
                    style: const TextStyle(
                        color: AppColors.neonYellow,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: _coins.toDouble(),
              min: 5,
              max: 100,
              divisions: 19,
              activeColor: AppColors.neonYellow,
              label: '$_coins',
              onChanged: (v) => setState(() => _coins = v.toInt()),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Requiere verificación del padre',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13)),
              value: _requiresVerification,
              activeColor: AppColors.neonMagenta,
              onChanged: (v) =>
                  setState(() => _requiresVerification = v ?? false),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleCtrl.text.trim().isEmpty) return;
            final childId = widget.children.isNotEmpty
                ? widget.children[_selectedChildIdx].id
                : 0;
            final task = TaskEntity()
              ..title = _titleCtrl.text.trim()
              ..description = _descCtrl.text.trim().isEmpty
                  ? null
                  : _descCtrl.text.trim()
              ..module = TaskModule.custom
              ..childUserId = childId
              ..rewardCoins = _coins
              ..frequency = _freq
              ..status = TaskStatus.available
              ..requiresVerification = _requiresVerification;
            widget.onCreate(task);
            Navigator.pop(context);
          },
          child: const Text('Crear'),
        ),
      ],
    );
  }
}

// ========== DIÁLOGO TASA DE CONVERSIÓN ==========

class _ConversionRateDialog extends StatefulWidget {
  final BioCoinConfig config;
  final Function(BioCoinConfig) onSave;
  const _ConversionRateDialog(
      {required this.config, required this.onSave});

  @override
  State<_ConversionRateDialog> createState() =>
      _ConversionRateDialogState();
}

class _ConversionRateDialogState
    extends State<_ConversionRateDialog> {
  late int _coinsPerMinute;
  late int _arena;
  late int _biofuel;
  late int _comms;
  late int _logic;
  late int _math;
  late int _coding;

  @override
  void initState() {
    super.initState();
    _coinsPerMinute = widget.config.coinsPerMinute;
    _arena = widget.config.coinsPerThousandSteps;
    _biofuel = widget.config.coinsPerHealthyMeal;
    _comms = widget.config.coinsPerReadingQuiz;
    _logic = widget.config.coinsPerPuzzle;
    _math = widget.config.coinsPerMathProblem;
    _coding = widget.config.coinsPerCodingExercise;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceElevated,
      title: const Text('Tasas de Conversión'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _rateRow('Coins → 1 minuto',
                _coinsPerMinute, AppColors.neonCyan, 1, 30,
                (v) => setState(() => _coinsPerMinute = v)),
            const Divider(color: AppColors.border),
            _rateRow('Arena (1000 pasos)', _arena,
                AppColors.moduleArena, 5, 50,
                (v) => setState(() => _arena = v)),
            _rateRow('Nutrición (comida sana)', _biofuel,
                AppColors.moduleBiofuel, 5, 50,
                (v) => setState(() => _biofuel = v)),
            _rateRow('Comms (quiz lectura)', _comms,
                AppColors.moduleComms, 5, 50,
                (v) => setState(() => _comms = v)),
            _rateRow('Logic (puzzle)', _logic,
                AppColors.moduleLogic, 5, 50,
                (v) => setState(() => _logic = v)),
            _rateRow('Math (problema)', _math,
                AppColors.moduleMath, 5, 50,
                (v) => setState(() => _math = v)),
            _rateRow('Coding (ejercicio)', _coding,
                AppColors.moduleCoding, 5, 50,
                (v) => setState(() => _coding = v)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final updated = widget.config
              ..coinsPerMinute = _coinsPerMinute
              ..coinsPerThousandSteps = _arena
              ..coinsPerHealthyMeal = _biofuel
              ..coinsPerReadingQuiz = _comms
              ..coinsPerPuzzle = _logic
              ..coinsPerMathProblem = _math
              ..coinsPerCodingExercise = _coding;
            widget.onSave(updated);
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Widget _rateRow(String label, int value, Color color, int min, int max,
      ValueChanged<int> onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
            Text('$value ◈',
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: (max - min),
          activeColor: color,
          label: '$value',
          onChanged: (v) => onChange(v.toInt()),
        ),
      ],
    );
  }
}
