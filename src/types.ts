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
