/// ============================================
/// NEXUS CONTROL - App Strings (Español)
/// ============================================
/// Todas las cadenas de texto de la aplicación

class AppStrings {
  AppStrings._();

  // ========== GENERAL ==========
  static const String appName = 'Nexus Control';
  static const String appTagline = 'Tu nave, tus reglas';
  
  // ========== ROLES ==========
  static const String roleParent = 'Comandante';
  static const String roleChild = 'Piloto';
  
  // ========== AUTENTICACIÓN ==========
  static const String pinTitle = 'Ingresa tu código de acceso';
  static const String pinHint = 'PIN de 4 dígitos';
  static const String pinError = 'PIN incorrecto';
  static const String pinCreate = 'Crea tu código de Comandante';
  static const String pinConfirm = 'Confirma tu código';
  
  // ========== HUD PRINCIPAL ==========
  static const String hudTimeRemaining = 'Tiempo de Misión';
  static const String hudBioCoins = 'Bio-Coins';
  static const String hudWelcome = '¡Bienvenido a bordo, Piloto!';
  static const String hudMissions = 'Misiones Disponibles';
  static const String hudNoTime = 'Sin tiempo de red';
  static const String hudEarnMore = 'Completa misiones para ganar tiempo';
  
  // ========== MÓDULOS ==========
  static const String moduleArena = 'ENTRENAMIENTO';
  static const String moduleArenaDesc = 'Ejercicio Físico';
  static const String moduleBiofuel = 'ALIMENTACIÓN';
  static const String moduleBiofuelDesc = 'Nutrición';
  static const String moduleComms = 'BIBLIOTECA';
  static const String moduleCommsDesc = 'Lectura';
  static const String moduleLogic = 'INGENIO';
  static const String moduleLogicDesc = 'Puzzles e Ingenio';
  static const String moduleMath = 'CÁLCULO';
  static const String moduleMathDesc = 'Cálculo Mental';
  static const String moduleCoding = 'PROGRAMACIÓN';
  static const String moduleCodingDesc = 'Programación Básica';
  static const String moduleNeuro = 'MENTE';
  static const String moduleNeuroDesc = 'Juegos Cognitivos';
  static const String moduleOverride = 'DESAFÍOS';
  static const String moduleOverrideDesc = 'Misiones Especiales';
  
  // ========== ENTRENAMIENTO (EJERCICIO) ==========
  static const String arenaTitle = 'ENTRENAMIENTO';
  static const String arenaSteps = 'Pasos';
  static const String arenaCalories = 'Calorías';
  static const String arenaDistance = 'Distancia';
  static const String arenaGoal = 'Meta';
  static const String arenaComplete = '¡Entrenamiento Completado!';
  static const String arenaReward = 'Has ganado';
  
  // ========== ALIMENTACIÓN (NUTRICIÓN) ==========
  static const String biofuelTitle = 'ALIMENTACIÓN';
  static const String biofuelScan = 'Fotografiar Alimento';
  static const String biofuelAnalyzing = 'Analizando...';
  static const String biofuelHealthy = '¡Alimento Saludable!';
  static const String biofuelUnhealthy = 'Alimento poco saludable';
  static const String biofuelTip = 'Tip nutricional';
  
  // ========== BIBLIOTECA (LECTURA) ==========
  static const String commsTitle = 'BIBLIOTECA';
  static const String commsScan = 'Escanear Texto';
  static const String commsReading = 'Modo Lectura';
  static const String commsQuiz = 'Evaluación';
  static const String commsQuestion = 'Pregunta';
  static const String commsCorrect = '¡Respuesta Correcta!';
  static const String commsIncorrect = 'Respuesta Incorrecta';
  
  // ========== INGENIO (PUZZLES) ==========
  static const String logicTitle = 'INGENIO';
  static const String logicPuzzle = 'Puzzle';
  static const String logicSolved = '¡Puzzle Resuelto!';
  static const String logicHint = 'Pista';
  
  // ========== CÁLCULO (MATEMÁTICAS) ==========
  static const String mathTitle = 'CÁLCULO';
  static const String mathProblem = 'Problema';
  static const String mathSolve = 'Resolver';
  static const String mathCorrect = '¡Cálculo Correcto!';
  static const String mathStreak = 'Racha';
  
  // ========== PROGRAMACIÓN ==========
  static const String codingTitle = 'PROGRAMACIÓN';
  static const String codingChallenge = 'Desafío';
  static const String codingRun = 'Ejecutar';
  static const String codingSuccess = '¡Código Exitoso!';
  static const String codingError = 'Error de Sintaxis';
  
  // ========== BLOQUEO (WALL) ==========
  static const String wallTitle = 'ACCESO DENEGADO';
  static const String wallMessage = 'Sin tiempo de red disponible';
  static const String wallAction = 'Ir a La Mina';
  static const String wallEmergency = 'Emergencia (Requiere PIN)';
  
  // ========== PANEL DE PADRE ==========
  static const String parentTitle = 'Panel de Comandante';
  static const String parentApps = 'Apps Controladas';
  static const String parentTime = 'Tiempo Otorgado';
  static const String parentTasks = 'Tareas Configuradas';
  static const String parentRewards = 'Recompensas';
  static const String parentStats = 'Estadísticas';
  static const String parentBlacklist = 'Lista de Bloqueo';
  static const String parentAddApp = 'Agregar App';
  static const String parentRemoveApp = 'Quitar App';
  
  // ========== MONEDAS Y TIEMPO ==========
  static const String coinSingular = 'Bio-Coin';
  static const String coinPlural = 'Bio-Coins';
  static const String minuteSingular = 'minuto';
  static const String minutePlural = 'minutos';
  static const String hourSingular = 'hora';
  static const String hourPlural = 'horas';
  
  // ========== MENSAJES DE SISTEMA ==========
  static const String permissionRequired = 'Permiso requerido';
  static const String permissionUsageStats = 'Necesitamos acceso a estadísticas de uso';
  static const String permissionOverlay = 'Necesitamos permiso de superposición';
  static const String permissionHealth = 'Conecta con Health Connect';
  static const String permissionCamera = 'Acceso a cámara requerido';
  static const String permissionLocation = 'Acceso a ubicación requerido';
  
  // ========== ERRORES ==========
  static const String errorGeneric = 'Algo salió mal';
  static const String errorConnection = 'Sin conexión';
  static const String errorCamera = 'Error de cámara';
  static const String errorAnalysis = 'Error en análisis';
  
  // ========== BOTONES ==========
  static const String buttonContinue = 'Continuar';
  static const String buttonCancel = 'Cancelar';
  static const String buttonConfirm = 'Confirmar';
  static const String buttonSave = 'Guardar';
  static const String buttonStart = 'Iniciar';
  static const String buttonFinish = 'Finalizar';
  static const String buttonRetry = 'Reintentar';
  static const String buttonGrant = 'Otorgar Permiso';
}
