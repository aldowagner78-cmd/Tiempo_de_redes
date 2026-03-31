// ============================================
// NEXUS CONTROL - Parent Remote Control Panel
// ============================================
// Permite al padre enviar comandos al dispositivo del hijo:
// - Bloqueo/desbloqueo de apps
// - Límite de tiempo diario
// - Bloqueo de emergencia
// - Agregar tiempo extra
// - Ver estado en vivo

import React, { useEffect, useState, useCallback } from 'react';
import {
  collection,
  doc,
  addDoc,
  onSnapshot,
  query,
  orderBy,
  limit,
  serverTimestamp,
} from 'firebase/firestore';
import { db, auth } from '@/src/lib/firebase';
import {
  NexusCommand,
  NexusCommandType,
  NexusLiveStatus,
  NexusBlockedApp,
} from '@/src/types';
import {
  Shield,
  ShieldAlert,
  ShieldOff,
  Clock,
  Plus,
  Lock,
  Unlock,
  Smartphone,
  Activity,
  Wifi,
  WifiOff,
  AlertTriangle,
  CheckCircle,
  Timer,
  Ban,
  Eye,
} from 'lucide-react';

// ── Constantes ──────────────────────────────────────────────────
const DEFAULT_APPS: NexusBlockedApp[] = [
  { packageName: 'com.zhiliaoapp.musically', appName: 'TikTok', category: 'social', isBlocked: true },
  { packageName: 'com.ss.android.ugc.trill', appName: 'TikTok Lite', category: 'social', isBlocked: true },
  { packageName: 'com.instagram.android', appName: 'Instagram', category: 'social', isBlocked: true },
  { packageName: 'com.facebook.katana', appName: 'Facebook', category: 'social', isBlocked: true },
  { packageName: 'com.facebook.orca', appName: 'Messenger', category: 'social', isBlocked: true },
  { packageName: 'com.snapchat.android', appName: 'Snapchat', category: 'social', isBlocked: true },
  { packageName: 'com.twitter.android', appName: 'X (Twitter)', category: 'social', isBlocked: true },
  { packageName: 'com.pinterest', appName: 'Pinterest', category: 'social', isBlocked: true },
  { packageName: 'com.reddit.frontpage', appName: 'Reddit', category: 'social', isBlocked: true },
  { packageName: 'com.whatsapp', appName: 'WhatsApp', category: 'social', isBlocked: true },
  { packageName: 'com.google.android.youtube', appName: 'YouTube', category: 'video', isBlocked: true },
  { packageName: 'com.netflix.mediaclient', appName: 'Netflix', category: 'video', isBlocked: true },
  { packageName: 'tv.twitch.android.app', appName: 'Twitch', category: 'video', isBlocked: true },
  { packageName: 'com.amazon.avod.thirdpartyclient', appName: 'Prime Video', category: 'video', isBlocked: true },
  { packageName: 'com.supercell.clashofclans', appName: 'Clash of Clans', category: 'games', isBlocked: true },
  { packageName: 'com.supercell.clashroyale', appName: 'Clash Royale', category: 'games', isBlocked: true },
  { packageName: 'com.mojang.minecraftpe', appName: 'Minecraft', category: 'games', isBlocked: true },
  { packageName: 'com.roblox.client', appName: 'Roblox', category: 'games', isBlocked: true },
  { packageName: 'com.tencent.ig', appName: 'PUBG Mobile', category: 'games', isBlocked: true },
  { packageName: 'com.garena.game.freefire', appName: 'Free Fire', category: 'games', isBlocked: true },
];

const CATEGORY_LABELS: Record<string, string> = {
  social: 'Redes Sociales',
  video: 'Video & Streaming',
  games: 'Juegos',
  other: 'Otras',
};

const CATEGORY_COLORS: Record<string, string> = {
  social: '#FF6B6B',
  video: '#45B7D1',
  games: '#FFEAA7',
  other: '#849495',
};

// ── Helpers ──────────────────────────────────────────────────────
function formatTimeCompact(seconds: number): string {
  if (seconds <= 0) return '0:00';
  const h = Math.floor(seconds / 3600);
  const m = Math.floor((seconds % 3600) / 60);
  const s = seconds % 60;
  if (h > 0) return `${h}:${String(m).padLeft(2, '0')}h`;
  return `${m}:${String(s).padLeft(2, '0')}`;
}

function timeAgo(iso: string): string {
  try {
    const diff = Date.now() - new Date(iso).getTime();
    if (diff < 60000) return 'hace unos segundos';
    if (diff < 3600000) return `hace ${Math.floor(diff / 60000)} min`;
    if (diff < 86400000) return `hace ${Math.floor(diff / 3600000)}h`;
    return `hace ${Math.floor(diff / 86400000)}d`;
  } catch {
    return '';
  }
}

// String.padLeft polyfill
declare global {
  interface String {
    padLeft(len: number, fill: string): string;
  }
}
String.prototype.padLeft = function (len: number, fill: string) {
  return this.padStart(len, fill);
};

// ── Props ────────────────────────────────────────────────────────
interface ParentControlPanelProps {
  deviceUid: string;
}

// ── Componente principal ─────────────────────────────────────────
export const ParentControlPanel: React.FC<ParentControlPanelProps> = ({
  deviceUid,
}) => {
  const [liveStatus, setLiveStatus] = useState<NexusLiveStatus | null>(null);
  const [recentCommands, setRecentCommands] = useState<NexusCommand[]>([]);
  const [apps, setApps] = useState<NexusBlockedApp[]>(DEFAULT_APPS);
  const [timeLimit, setTimeLimit] = useState(60);
  const [addMinutes, setAddMinutes] = useState(15);
  const [sending, setSending] = useState(false);
  const [lastAction, setLastAction] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<'live' | 'apps' | 'commands'>(
    'live',
  );

  // ── Firestore listeners ──────────────────────────────────────
  useEffect(() => {
    if (!deviceUid) return;
    const unsubs: Array<() => void> = [];

    // Live status
    const unsub1 = onSnapshot(
      doc(db, 'nexus_devices', deviceUid, 'live_status', 'current'),
      (snap) => {
        if (snap.exists()) {
          setLiveStatus(snap.data() as NexusLiveStatus);
        }
      },
    );
    unsubs.push(unsub1);

    // Recent commands (últimos 20)
    const cmdQuery = query(
      collection(db, 'nexus_devices', deviceUid, 'commands'),
      orderBy('createdAt', 'desc'),
      limit(20),
    );
    const unsub2 = onSnapshot(cmdQuery, (snap) => {
      setRecentCommands(
        snap.docs.map(
          (d) => ({ id: d.id, ...d.data() } as unknown as NexusCommand),
        ),
      );
    });
    unsubs.push(unsub2);

    return () => unsubs.forEach((u) => u());
  }, [deviceUid]);

  // ── Enviar comando ───────────────────────────────────────────
  const sendCommand = useCallback(
    async (type: NexusCommandType, payload: Record<string, unknown>) => {
      if (!deviceUid || !auth.currentUser) return;
      setSending(true);
      try {
        await addDoc(
          collection(db, 'nexus_devices', deviceUid, 'commands'),
          {
            type,
            payload,
            status: 'pending',
            createdAt: new Date().toISOString(),
            createdBy: auth.currentUser.uid,
          },
        );
        setLastAction(`${type} enviado`);
        setTimeout(() => setLastAction(null), 3000);
      } catch (err) {
        console.error('Error enviando comando:', err);
        setLastAction('Error al enviar comando');
        setTimeout(() => setLastAction(null), 3000);
      } finally {
        setSending(false);
      }
    },
    [deviceUid],
  );

  // ── Handlers rápidos ─────────────────────────────────────────
  const handleEmergencyLock = () => sendCommand('EMERGENCY_LOCK', {});
  const handleEmergencyUnlock = () => sendCommand('EMERGENCY_UNLOCK', {});
  const handleSetTimeLimit = () =>
    sendCommand('SET_TIME_LIMIT', { minutes: timeLimit });
  const handleAddTime = () => sendCommand('ADD_TIME', { minutes: addMinutes });

  const handleToggleApp = (app: NexusBlockedApp) => {
    const newApps = apps.map((a) =>
      a.packageName === app.packageName
        ? { ...a, isBlocked: !a.isBlocked }
        : a,
    );
    setApps(newApps);

    if (app.isBlocked) {
      sendCommand('UNBLOCK_APP', { packageName: app.packageName });
    } else {
      sendCommand('BLOCK_APP', { packageName: app.packageName });
    }
  };

  const isLive =
    liveStatus &&
    liveStatus.lastUpdate &&
    Date.now() - new Date(liveStatus.lastUpdate).getTime() < 120000;

  // ── Render ────────────────────────────────────────────────────
  return (
    <div className="space-y-4">
      {/* Tabs */}
      <div className="flex gap-1 bg-[#1c1f29]/60 rounded-lg p-1">
        {[
          { key: 'live' as const, label: 'EN VIVO', icon: Eye },
          { key: 'apps' as const, label: 'APPS', icon: Ban },
          { key: 'commands' as const, label: 'HISTORIAL', icon: Activity },
        ].map(({ key, label, icon: Icon }) => (
          <button
            key={key}
            onClick={() => setActiveTab(key)}
            className={`flex-1 flex items-center justify-center gap-1.5 py-2 rounded text-xs font-label tracking-widest transition-all ${
              activeTab === key
                ? 'bg-[#00F5FF]/20 text-[#00F5FF] border border-[#00F5FF]/30'
                : 'text-[#849495] hover:text-[#dfe2ef]'
            }`}
          >
            <Icon className="w-3.5 h-3.5" />
            {label}
          </button>
        ))}
      </div>

      {/* Notificación de acción */}
      {lastAction && (
        <div className="bg-[#00F5FF]/10 border border-[#00F5FF]/30 rounded-lg p-2 text-[#00F5FF] text-xs text-center flex items-center justify-center gap-2">
          <CheckCircle className="w-4 h-4" />
          {lastAction}
        </div>
      )}

      {/* TAB: EN VIVO */}
      {activeTab === 'live' && (
        <div className="space-y-4">
          {/* Estado en vivo */}
          <div className="bg-[#1c1f29]/60 border border-[#00F5FF]/20 rounded-xl p-5 space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="font-headline text-sm text-[#00F5FF] tracking-widest flex items-center gap-2">
                <Smartphone className="w-4 h-4" />
                ESTADO DEL DISPOSITIVO
              </h3>
              <span
                className={`flex items-center gap-1 text-[10px] uppercase font-label px-2 py-0.5 rounded-full border ${
                  isLive
                    ? 'text-[#00FE87] border-[#00FE87]/30 bg-[#00FE87]/10'
                    : 'text-red-400 border-red-500/30 bg-red-500/10'
                }`}
              >
                {isLive ? (
                  <Wifi className="w-3 h-3" />
                ) : (
                  <WifiOff className="w-3 h-3" />
                )}
                {isLive ? 'EN VIVO' : 'SIN SEÑAL'}
              </span>
            </div>

            {liveStatus ? (
              <div className="grid grid-cols-2 gap-3">
                <div className="bg-[#0A0E17]/40 rounded-lg p-3">
                  <div className="text-[10px] text-[#849495] uppercase tracking-wider mb-1">
                    App Actual
                  </div>
                  <div className="text-sm text-[#dfe2ef] font-mono truncate">
                    {liveStatus.currentAppName || liveStatus.currentApp || '-'}
                  </div>
                  {liveStatus.isBlocked && (
                    <span className="text-[10px] text-red-400 flex items-center gap-1 mt-1">
                      <Ban className="w-3 h-3" /> BLOQUEADA
                    </span>
                  )}
                </div>
                <div className="bg-[#0A0E17]/40 rounded-lg p-3">
                  <div className="text-[10px] text-[#849495] uppercase tracking-wider mb-1">
                    Tiempo Restante
                  </div>
                  <div
                    className={`text-xl font-headline ${
                      liveStatus.remainingSeconds > 300
                        ? 'text-[#00FE87]'
                        : liveStatus.remainingSeconds > 0
                        ? 'text-yellow-400'
                        : 'text-red-400'
                    }`}
                  >
                    {formatTimeCompact(liveStatus.remainingSeconds)}
                  </div>
                </div>
                <div className="bg-[#0A0E17]/40 rounded-lg p-3">
                  <div className="text-[10px] text-[#849495] uppercase tracking-wider mb-1">
                    El Muro
                  </div>
                  <div
                    className={`text-sm font-bold ${
                      liveStatus.isWallActive ? 'text-red-400' : 'text-[#00FE87]'
                    }`}
                  >
                    {liveStatus.isWallActive ? '🔒 ACTIVO' : '✅ INACTIVO'}
                  </div>
                </div>
                <div className="bg-[#0A0E17]/40 rounded-lg p-3">
                  <div className="text-[10px] text-[#849495] uppercase tracking-wider mb-1">
                    Última Señal
                  </div>
                  <div className="text-sm text-[#dfe2ef]">
                    {liveStatus.lastUpdate ? timeAgo(liveStatus.lastUpdate) : '-'}
                  </div>
                </div>
              </div>
            ) : (
              <div className="text-center text-[#849495] py-6 text-sm">
                Esperando primera señal del dispositivo...
              </div>
            )}
          </div>

          {/* Controles de emergencia */}
          <div className="bg-[#1c1f29]/60 border border-red-500/20 rounded-xl p-5 space-y-4">
            <h3 className="font-headline text-sm text-red-400 tracking-widest flex items-center gap-2">
              <AlertTriangle className="w-4 h-4" />
              CONTROLES DE EMERGENCIA
            </h3>
            <div className="grid grid-cols-2 gap-3">
              <button
                onClick={handleEmergencyLock}
                disabled={sending}
                className="flex flex-col items-center gap-2 bg-red-500/10 border border-red-500/30 rounded-lg p-4 hover:bg-red-500/20 transition-all disabled:opacity-50"
              >
                <Lock className="w-6 h-6 text-red-400" />
                <span className="text-xs text-red-400 font-bold tracking-wider">
                  BLOQUEAR TODO
                </span>
                <span className="text-[10px] text-[#849495]">
                  Bloquea el dispositivo inmediatamente
                </span>
              </button>
              <button
                onClick={handleEmergencyUnlock}
                disabled={sending}
                className="flex flex-col items-center gap-2 bg-[#00FE87]/10 border border-[#00FE87]/30 rounded-lg p-4 hover:bg-[#00FE87]/20 transition-all disabled:opacity-50"
              >
                <Unlock className="w-6 h-6 text-[#00FE87]" />
                <span className="text-xs text-[#00FE87] font-bold tracking-wider">
                  DESBLOQUEAR
                </span>
                <span className="text-[10px] text-[#849495]">
                  Restaura el tiempo del día
                </span>
              </button>
            </div>
          </div>

          {/* Control de tiempo */}
          <div className="bg-[#1c1f29]/60 border border-[#00F5FF]/20 rounded-xl p-5 space-y-4">
            <h3 className="font-headline text-sm text-[#00F5FF] tracking-widest flex items-center gap-2">
              <Timer className="w-4 h-4" />
              CONTROL DE TIEMPO
            </h3>

            {/* Límite diario */}
            <div className="space-y-2">
              <label className="text-[10px] text-[#849495] uppercase tracking-wider">
                Límite diario
              </label>
              <div className="flex items-center gap-3">
                <input
                  type="range"
                  min={15}
                  max={240}
                  step={15}
                  value={timeLimit}
                  onChange={(e) => setTimeLimit(Number(e.target.value))}
                  className="flex-1 accent-[#00F5FF]"
                />
                <span className="text-[#00F5FF] font-headline text-lg w-16 text-right">
                  {timeLimit}m
                </span>
                <button
                  onClick={handleSetTimeLimit}
                  disabled={sending}
                  className="bg-[#00F5FF] text-[#0A0E17] px-3 py-1.5 rounded text-xs font-bold hover:bg-[#00F5FF]/80 transition-all disabled:opacity-50"
                >
                  APLICAR
                </button>
              </div>
            </div>

            {/* Agregar tiempo extra */}
            <div className="space-y-2">
              <label className="text-[10px] text-[#849495] uppercase tracking-wider">
                Agregar tiempo extra
              </label>
              <div className="flex items-center gap-2">
                {[5, 15, 30, 60].map((min) => (
                  <button
                    key={min}
                    onClick={() => setAddMinutes(min)}
                    className={`px-3 py-1.5 rounded text-xs font-mono transition-all ${
                      addMinutes === min
                        ? 'bg-[#00F5FF]/20 text-[#00F5FF] border border-[#00F5FF]/30'
                        : 'bg-[#0A0E17]/40 text-[#849495] border border-[#849495]/20 hover:text-[#dfe2ef]'
                    }`}
                  >
                    +{min}m
                  </button>
                ))}
                <button
                  onClick={handleAddTime}
                  disabled={sending}
                  className="bg-[#00FE87] text-[#0A0E17] px-3 py-1.5 rounded text-xs font-bold hover:bg-[#00FE87]/80 transition-all disabled:opacity-50 ml-auto"
                >
                  <Plus className="w-3 h-3 inline mr-1" />
                  AGREGAR
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* TAB: APPS */}
      {activeTab === 'apps' && (
        <div className="space-y-4">
          {Object.entries(CATEGORY_LABELS).map(([cat, label]) => {
            const categoryApps = apps.filter((a) => a.category === cat);
            if (categoryApps.length === 0) return null;
            return (
              <div
                key={cat}
                className="bg-[#1c1f29]/60 border border-[#00F5FF]/20 rounded-xl p-4 space-y-3"
              >
                <h3
                  className="font-label text-xs uppercase tracking-widest flex items-center gap-2"
                  style={{ color: CATEGORY_COLORS[cat] }}
                >
                  <Shield className="w-3.5 h-3.5" />
                  {label}
                </h3>
                <div className="space-y-1">
                  {categoryApps.map((app) => (
                    <div
                      key={app.packageName}
                      className="flex items-center justify-between py-2 px-3 rounded-lg hover:bg-[#0A0E17]/30 transition-all"
                    >
                      <div>
                        <div className="text-sm text-[#dfe2ef]">
                          {app.appName}
                        </div>
                        <div className="text-[10px] text-[#849495] font-mono">
                          {app.packageName}
                        </div>
                      </div>
                      <button
                        onClick={() => handleToggleApp(app)}
                        disabled={sending}
                        className={`flex items-center gap-1.5 px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider transition-all ${
                          app.isBlocked
                            ? 'bg-red-500/20 text-red-400 border border-red-500/30 hover:bg-red-500/30'
                            : 'bg-[#00FE87]/20 text-[#00FE87] border border-[#00FE87]/30 hover:bg-[#00FE87]/30'
                        }`}
                      >
                        {app.isBlocked ? (
                          <>
                            <ShieldAlert className="w-3 h-3" />
                            BLOQUEADA
                          </>
                        ) : (
                          <>
                            <ShieldOff className="w-3 h-3" />
                            PERMITIDA
                          </>
                        )}
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* TAB: HISTORIAL DE COMANDOS */}
      {activeTab === 'commands' && (
        <div className="bg-[#1c1f29]/60 border border-[#00F5FF]/20 rounded-xl p-4 space-y-3">
          <h3 className="font-headline text-sm text-[#00F5FF] tracking-widest flex items-center gap-2">
            <Activity className="w-4 h-4" />
            COMANDOS ENVIADOS
          </h3>
          {recentCommands.length > 0 ? (
            <div className="space-y-1 max-h-96 overflow-y-auto pr-1 scrollbar-thin scrollbar-thumb-[#00F5FF]/20">
              {recentCommands.map((cmd) => (
                <div
                  key={cmd.id}
                  className="flex items-center gap-3 bg-[#0A0E17]/30 rounded-lg px-3 py-2"
                >
                  <div
                    className={`w-2 h-2 rounded-full shrink-0 ${
                      cmd.status === 'executed'
                        ? 'bg-[#00FE87]'
                        : cmd.status === 'failed'
                        ? 'bg-red-400'
                        : 'bg-yellow-400 animate-pulse'
                    }`}
                  />
                  <div className="flex-1 min-w-0">
                    <div className="text-sm text-[#dfe2ef] font-mono">
                      {cmd.type}
                    </div>
                    <div className="text-[10px] text-[#849495]">
                      {cmd.createdAt ? timeAgo(cmd.createdAt) : ''} ·{' '}
                      {cmd.status === 'executed'
                        ? '✅ Ejecutado'
                        : cmd.status === 'failed'
                        ? '❌ Falló'
                        : '⏳ Pendiente'}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <div className="text-center text-[#849495] py-6 text-sm">
              No se han enviado comandos aún.
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default ParentControlPanel;
