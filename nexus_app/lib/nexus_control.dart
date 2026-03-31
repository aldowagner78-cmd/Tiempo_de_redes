/// Nexus Control App - Feature Exports
/// 
/// Este archivo centraliza las exportaciones de todas las features

// Auth
export 'features/auth/presentation/screens/role_selection_screen.dart';
export 'features/auth/presentation/screens/pin_screen.dart';
export 'features/auth/domain/entities/user_entity.dart';

// HUD
export 'features/hud/presentation/screens/hud_main_screen.dart';

// Parent
export 'features/parent/presentation/screens/parent_dashboard_screen.dart';

// Modules - "La Mina"
export 'features/arena/presentation/screens/arena_screen.dart';
export 'features/biofuel/presentation/screens/biofuel_screen.dart';
export 'features/comms/presentation/screens/comms_screen.dart';
export 'features/logic/presentation/screens/logic_screen.dart';
export 'features/math/presentation/screens/math_screen.dart';
export 'features/coding/presentation/screens/coding_screen.dart';

// Entities
export 'features/biocoins/domain/entities/biocoin_entity.dart';
export 'features/monitor/domain/entities/blacklist_entity.dart';
export 'features/monitor/domain/entities/task_entity.dart';

// Services
export 'core/services/isar_service.dart';
export 'core/utils/platform_channel.dart';

// Providers
export 'shared/providers/global_providers.dart';

// Widgets
export 'shared/widgets/shared_widgets.dart';

// Theme
export 'core/theme/cyberpunk_theme.dart';
export 'core/constants/app_colors.dart';
export 'core/constants/app_strings.dart';
