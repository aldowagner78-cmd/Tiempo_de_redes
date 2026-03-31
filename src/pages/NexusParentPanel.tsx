import React, { useEffect, useRef, useState } from 'react';
import {
  collection,
  doc,
  onSnapshot,
  orderBy,
  query,
  limit,
} from 'firebase/firestore';
import { db } from '@/src/lib/firebase';
import { NexusChild, NexusDevice, NexusTransaction } from '@/src/types';
import { Shield, Wifi, WifiOff, ChevronDown, ChevronUp } from 'lucide-react';
import { ParentControlPanel } from './ParentControlPanel';

// ── Constantes ──────────────────────────────────────────────────
const STORAGE_KEY = 'nexus_device_uid';

const SOURCE_COLORS: Record<string, string> = {
  arena: '#FF6B6B',
  biofuel: '#4ECDC4',
  math: '#45B7D1',
  logic: '#96CEB4',
  coding: '#FFEAA7',
  comms: '#DDA0DD',
  neuro: '#98FB98',
  override: '#FFB6C1',
  parent: '#00F5FF',
  system: '#849495',
};

// ── Helpers ──────────────────────────────────────────────────────
function formatTime(seconds: number): string {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}:${String(s).padStart(2, '0')}`;
}

function formatDate(iso: string): string {
  try {
    return new Date(iso).toLocaleString('es', {
      day: '2-digit',
      month: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
    });
  } catch {
    return iso;
  }
}

// ── Pantalla de vinculación ──────────────────────────────────────
interface LinkScreenProps {
  onLink: (uid: string) => void;
}

const LinkScreen: React.FC<LinkScreenProps> = ({ onLink }) => {
  const [input, setInput] = useState('');

  return (
    <div className="min-h-[60vh] flex flex-col items-center justify-center gap-6">
      <Shield className="w-16 h-16 text-[#00F5FF] drop-shadow-[0_0_10px_rgba(0,245,255,0.5)]" />
      <h2 className="font-headline text-2xl text-[#00F5FF] tracking-widest">
        PANEL NEXUS
      </h2>
      <p className="text-[#849495] text-sm text-center max-w-xs leading-relaxed">
        Introduce el <strong className="text-[#dfe2ef]">Device ID</strong> del
        smartphone de tu hijo para vincular y monitorear en tiempo real.
        <br />
        <span className="text-[10px] mt-1 block">
          Encuéntralo en la app Android: Panel Parental → Configuración → Device ID
        </span>
      </p>
      <div className="flex gap-2 w-full max-w-sm">
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && input.trim() && onLink(input.trim())}
          placeholder="Pega el Device ID aquí..."
          className="flex-1 bg-[#1c1f29] border border-[#00F5FF]/30 rounded px-3 py-2 text-[#dfe2ef] font-mono text-sm focus:outline-none focus:border-[#00F5FF] placeholder:text-[#849495]/50"
        />
        <button
          onClick={() => input.trim() && onLink(input.trim())}
          className="bg-[#00F5FF] text-[#0A0E17] px-4 py-2 rounded font-bold text-sm hover:bg-[#00F5FF]/80 transition-all"
        >
          VINCULAR
        </button>
      </div>
    </div>
  );
};

// ── Panel principal ──────────────────────────────────────────────
export const NexusParentPanel: React.FC = () => {
  const [deviceUid, setDeviceUid] = useState<string>(
    () => localStorage.getItem(STORAGE_KEY) ?? '',
  );
  const [device, setDevice] = useState<NexusDevice | null>(null);
  const [children, setChildren] = useState<NexusChild[]>([]);
  const [transactions, setTransactions] = useState<NexusTransaction[]>([]);
  const [isOnline, setIsOnline] = useState(false);
  const [error, setError] = useState('');
  const [showControls, setShowControls] = useState(false);
  const unsubRefs = useRef<Array<() => void>>([]);

  // ── Unsubscribe all listeners ──────────────────────────────────
  const unsubAll = () => {
    unsubRefs.current.forEach((u) => u());
    unsubRefs.current = [];
  };

  // ── Vincular nuevo dispositivo ─────────────────────────────────
  const handleLink = (uid: string) => {
    localStorage.setItem(STORAGE_KEY, uid);
    setDeviceUid(uid);
    setError('');
  };

  const handleUnlink = () => {
    unsubAll();
    localStorage.removeItem(STORAGE_KEY);
    setDeviceUid('');
    setDevice(null);
    setChildren([]);
    setTransactions([]);
    setIsOnline(false);
    setError('');
  };

  // ── Firestore listeners ────────────────────────────────────────
  useEffect(() => {
    if (!deviceUid) return;
    unsubAll();

    // 1. Documento raíz del dispositivo
    const unsub1 = onSnapshot(
      doc(db, 'nexus_devices', deviceUid),
      (snap) => {
        if (snap.exists()) {
          setDevice(snap.data() as NexusDevice);
          setIsOnline(true);
          setError('');
        } else {
          setIsOnline(false);
          setError('Dispositivo no encontrado. Verifica el Device ID e inténtalo de nuevo.');
        }
      },
      (err) => {
        setIsOnline(false);
        setError(`Error de conexión: ${err.message}`);
      },
    );
    unsubRefs.current.push(unsub1);

    // 2. Hijos (subcollección)
    const unsub2 = onSnapshot(
      collection(db, 'nexus_devices', deviceUid, 'children'),
      (snap) => {
        setChildren(snap.docs.map((d) => ({ id: d.id, ...d.data() } as unknown as NexusChild)));
      },
    );
    unsubRefs.current.push(unsub2);

    // 3. Transacciones recientes (subcollección, últimas 30)
    const txQuery = query(
      collection(db, 'nexus_devices', deviceUid, 'transactions'),
      orderBy('createdAt', 'desc'),
      limit(30),
    );
    const unsub3 = onSnapshot(txQuery, (snap) => {
      setTransactions(snap.docs.map((d) => ({ id: d.id, ...d.data() } as unknown as NexusTransaction)));
    });
    unsubRefs.current.push(unsub3);

    return unsubAll;
  }, [deviceUid]);

  // ── Sin dispositivo vinculado ──────────────────────────────────
  if (!deviceUid) {
    return <LinkScreen onLink={handleLink} />;
  }

  // ── Panel principal ────────────────────────────────────────────
  return (
    <div className="space-y-6">
      {/* Cabecera */}
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div className="flex items-center gap-3">
          <Shield className="w-5 h-5 text-[#00F5FF]" />
          <h2 className="font-headline text-xl text-[#00F5FF] tracking-widest">
            PANEL NEXUS
          </h2>
          <span
            className={`flex items-center gap-1 text-[10px] uppercase font-label px-2 py-0.5 rounded-full border ${
              isOnline
                ? 'text-[#00FE87] border-[#00FE87]/30 bg-[#00FE87]/10'
                : 'text-red-400 border-red-500/30 bg-red-500/10'
            }`}
          >
            {isOnline ? (
              <Wifi className="w-3 h-3" />
            ) : (
              <WifiOff className="w-3 h-3" />
            )}
            {isOnline ? 'EN LÍNEA' : 'DESCONECTADO'}
          </span>
        </div>
        <button
          onClick={handleUnlink}
          className="text-[#849495] text-xs hover:text-[#FE00FE] transition-all border border-[#849495]/20 rounded px-3 py-1"
        >
          DESVINCULAR
        </button>
      </div>

      {/* Error */}
      {error && (
        <div className="bg-red-500/10 border border-red-500/30 rounded-lg p-3 text-red-400 text-sm">
          {error}
        </div>
      )}

      {/* Tarjetas de hijos */}
      {children.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {children.map((child) => (
            <div
              key={child.id}
              className="bg-[#1c1f29]/60 border border-[#00F5FF]/20 rounded-xl p-5 space-y-4"
            >
              {/* Nombre + estado del muro */}
              <div className="flex items-center justify-between">
                <span className="font-headline text-lg text-[#dfe2ef]">
                  {child.name}
                </span>
                <span
                  className={`text-[10px] uppercase font-label px-2 py-0.5 rounded-full border ${
                    child.isWallActive
                      ? 'text-red-400 border-red-500/30 bg-red-500/10'
                      : 'text-[#00FE87] border-[#00FE87]/30 bg-[#00FE87]/10'
                  }`}
                >
                  {child.isWallActive ? 'MURO ACTIVO' : 'LIBRE'}
                </span>
              </div>

              {/* Métricas */}
              <div className="grid grid-cols-3 gap-2 text-center">
                <div>
                  <div className="text-[#00F5FF] font-headline text-2xl">
                    {child.bioCoins}
                  </div>
                  <div className="text-[#849495] text-[10px] uppercase tracking-wider">
                    Bio-Coins
                  </div>
                </div>
                <div>
                  <div className="text-[#00FE87] font-headline text-2xl">
                    {formatTime(child.remainingTimeSeconds)}
                  </div>
                  <div className="text-[#849495] text-[10px] uppercase tracking-wider">
                    Tiempo
                  </div>
                </div>
                <div>
                  <div className="text-[#FE00FE] font-headline text-2xl">
                    {child.currentStreak}
                  </div>
                  <div className="text-[#849495] text-[10px] uppercase tracking-wider">
                    Racha
                  </div>
                </div>
              </div>

              {/* Última sync */}
              {child.lastSync && (
                <div className="text-[#849495] text-[10px]">
                  Última sincronización: {formatDate(child.lastSync)}
                </div>
              )}
            </div>
          ))}
        </div>
      ) : isOnline ? (
        <div className="text-center text-[#849495] py-10 border border-[#00F5FF]/10 rounded-xl text-sm">
          No hay perfiles de hijo registrados aún.
          <br />
          Agrega un hijo en el Panel Parental de la app Android.
        </div>
      ) : null}

      {/* Panel de Control Remoto */}
      {isOnline && deviceUid && (
        <div className="space-y-2">
          <button
            onClick={() => setShowControls(!showControls)}
            className="flex items-center gap-2 text-[#FE00FE] text-xs font-label uppercase tracking-widest hover:text-[#FE00FE]/80 transition-all"
          >
            {showControls ? (
              <ChevronUp className="w-3.5 h-3.5" />
            ) : (
              <ChevronDown className="w-3.5 h-3.5" />
            )}
            CONTROL REMOTO
          </button>
          {showControls && <ParentControlPanel deviceUid={deviceUid} />}
        </div>
      )}

      {/* Historial de transacciones */}
      {transactions.length > 0 && (
        <div className="space-y-2">
          <h3 className="font-label text-[#849495] uppercase tracking-widest text-[10px]">
            Historial de actividad
          </h3>
          <div className="space-y-1 max-h-80 overflow-y-auto pr-1 scrollbar-thin scrollbar-thumb-[#00F5FF]/20">
            {transactions.map((tx) => (
              <div
                key={tx.id}
                className="flex items-center gap-3 bg-[#1c1f29]/40 border border-[#00F5FF]/10 rounded-lg px-3 py-2"
              >
                <div
                  className="w-2 h-2 rounded-full shrink-0"
                  style={{
                    backgroundColor: SOURCE_COLORS[tx.source] ?? '#849495',
                  }}
                />
                <div className="flex-1 min-w-0">
                  <div className="text-sm text-[#dfe2ef] truncate">
                    {tx.description || tx.source}
                  </div>
                  <div className="text-[10px] text-[#849495]">
                    {tx.childName} · {formatDate(tx.createdAt)}
                  </div>
                </div>
                <div
                  className={`text-sm font-bold font-mono shrink-0 ${
                    tx.amount >= 0 ? 'text-[#00FE87]' : 'text-red-400'
                  }`}
                >
                  {tx.amount >= 0 ? '+' : ''}
                  {tx.amount}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Device ID vinculado */}
      <div className="border border-[#849495]/20 rounded-xl p-4 bg-[#1c1f29]/30 space-y-1">
        <div className="text-[10px] text-[#849495] uppercase tracking-widest">
          Dispositivo vinculado
        </div>
        <div className="font-mono text-xs text-[#dfe2ef] break-all leading-relaxed">
          {deviceUid}
        </div>
        {device?.lastSync && (
          <div className="text-[10px] text-[#849495]">
            Última sync del dispositivo: {formatDate(device.lastSync)}
          </div>
        )}
      </div>
    </div>
  );
};

export default NexusParentPanel;
