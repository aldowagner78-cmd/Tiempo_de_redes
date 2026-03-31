export interface UserStats {
  uid: string;
  displayName: string;
  photoURL: string;
  bioCoins: number;
  stepsToday: number;
  stepsGoal: number;
  completedModules: number;
  energyBurnKcal: number;
  lastSync: string;
}

export interface Module {
  id: string;
  title: string;
  description: string;
  icon: string;
  reward: number;
  progress: number;
  category: 'physical' | 'cognitive' | 'technical';
}

export interface LogEntry {
  id: string;
  timestamp: string;
  message: string;
  type: 'info' | 'warning' | 'error' | 'success';
  reward?: number;
}

// ──────────────────────────────────────────────────────
// Nexus — estructuras del panel de control parental
// ──────────────────────────────────────────────────────

/** Perfil de un hijo sincronizado desde el dispositivo Android. */
export interface NexusChild {
  id: number;
  name: string;
  bioCoins: number;
  currentStreak: number;
  isWallActive: boolean;
  /** Segundos de tiempo libre restantes en el dispositivo. */
  remainingTimeSeconds: number;
  lastSync: string;
}

/** Metadatos del dispositivo Android vinculado. */
export interface NexusDevice {
  deviceId: string;
  /** Código de 8 chars que el padre introduce para vincular. */
  linkCode: string;
  lastSync: string;
}

/** Registro de una transacción Bio-Coin del dispositivo hijo. */
export interface NexusTransaction {
  id: string;
  childId: number;
  childName: string;
  amount: number;
  source: string;
  description: string;
  createdAt: string;
  balanceAfter: number;
}

// ──────────────────────────────────────────────────────
// Nexus — sistema de comandos padre → hijo
// ──────────────────────────────────────────────────────

/** Tipos de comando que el padre puede enviar al dispositivo hijo. */
export type NexusCommandType =
  | 'SET_TIME_LIMIT'
  | 'UPDATE_BLACKLIST'
  | 'EMERGENCY_LOCK'
  | 'EMERGENCY_UNLOCK'
  | 'ADD_TIME'
  | 'BLOCK_APP'
  | 'UNBLOCK_APP';

/** Estado del comando en su ciclo de vida. */
export type NexusCommandStatus = 'pending' | 'executed' | 'failed';

/** Comando enviado por el padre al dispositivo hijo vía Firestore. */
export interface NexusCommand {
  id: string;
  type: NexusCommandType;
  /** Payload según tipo: { minutes?: number, packages?: string[], packageName?: string } */
  payload: Record<string, unknown>;
  status: NexusCommandStatus;
  createdAt: string;
  createdBy: string;
  executedAt?: string;
}

/** Estado en vivo reportado por el dispositivo hijo. */
export interface NexusLiveStatus {
  currentApp: string | null;
  currentAppName: string | null;
  isBlocked: boolean;
  remainingSeconds: number;
  isWallActive: boolean;
  batteryLevel: number;
  lastUpdate: string;
}

/** App instalada en el dispositivo del hijo con estado de bloqueo. */
export interface NexusBlockedApp {
  packageName: string;
  appName: string;
  category: 'social' | 'video' | 'games' | 'other';
  isBlocked: boolean;
}
