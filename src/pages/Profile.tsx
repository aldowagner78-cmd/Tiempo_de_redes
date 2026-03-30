import React from 'react';
import { motion } from 'motion/react';
import { 
  User, 
  Mail, 
  Shield, 
  LogOut, 
  Coins, 
  History, 
  Settings,
  Camera,
  Edit3
} from 'lucide-react';
import { cn } from '@/src/lib/utils';

import { collection, query, where, orderBy, limit, onSnapshot } from 'firebase/firestore';
import { db, handleFirestoreError, OperationType } from '@/src/lib/firebase';
import { UserStats, LogEntry } from '@/src/types';

interface ProfileProps {
  user: any;
  stats: UserStats;
  onLogout: () => void;
}

export const Profile: React.FC<ProfileProps> = ({ user, stats, onLogout }) => {
  const [logs, setLogs] = React.useState<LogEntry[]>([]);

  React.useEffect(() => {
    const logsRef = collection(db, 'logs');
    const q = query(
      logsRef, 
      where('uid', '==', stats.uid),
      orderBy('timestamp', 'desc'),
      limit(3)
    );

    const unsubscribe = onSnapshot(q, (snapshot) => {
      const newLogs = snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      })) as LogEntry[];
      setLogs(newLogs);
    }, (error) => {
      handleFirestoreError(error, OperationType.GET, 'logs');
    });

    return () => unsubscribe();
  }, [stats.uid]);

  return (
    <div className="max-w-4xl mx-auto space-y-8">
      {/* Profile Header */}
      <section className="bg-[#1c1f29] p-8 border border-[#3a494a]/20 relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-64 bg-[#00F5FF]/5 rounded-full -mr-32 -mt-32 blur-3xl"></div>
        
        <div className="flex flex-col md:flex-row items-center gap-8 relative z-10">
          <div className="relative group">
            <div className="w-32 h-32 rounded-full border-4 border-[#00F5FF]/30 overflow-hidden bg-[#0A0E17] shadow-[0_0_20px_rgba(0,245,255,0.2)]">
              {user?.photoURL ? (
                <img src={user.photoURL} alt="Avatar" className="w-full h-full object-cover" />
              ) : (
                <User className="w-16 h-16 text-[#00F5FF] m-auto mt-6" />
              )}
            </div>
            <button className="absolute bottom-0 right-0 bg-[#00F5FF] p-2 rounded-full text-[#003739] hover:scale-110 transition-all shadow-lg">
              <Camera className="w-4 h-4" />
            </button>
          </div>

          <div className="flex-1 text-center md:text-left space-y-2">
            <div className="flex items-center justify-center md:justify-start gap-3">
              <h2 className="text-3xl font-headline font-black text-white tracking-tight uppercase">
                {user?.displayName || 'Comandante NEX'}
              </h2>
              <div className="bg-[#00fe87]/10 px-2 py-0.5 rounded border border-[#00fe87]/30">
                <span className="text-[10px] text-[#00fe87] font-technical font-bold uppercase tracking-widest">Nivel 5</span>
              </div>
            </div>
            <p className="text-[#849495] font-technical uppercase tracking-widest flex items-center justify-center md:justify-start gap-2">
              <Mail className="w-3 h-3" />
              {user?.email || 'nexus.pilot@control.io'}
            </p>
            <div className="flex flex-wrap justify-center md:justify-start gap-4 mt-4">
              <div className="flex items-center gap-2 px-4 py-2 bg-[#0A0E17] border border-[#00F5FF]/20 rounded-sm">
                <Coins className="w-4 h-4 text-[#00F5FF]" />
                <span className="font-headline text-lg text-white">{stats.bioCoins.toLocaleString()}</span>
                <span className="text-[10px] text-[#849495] font-technical uppercase">BC</span>
              </div>
              <button className="px-4 py-2 bg-[#181b25] border border-[#3a494a]/30 text-[#849495] hover:text-white hover:border-white/30 transition-all flex items-center gap-2 rounded-sm">
                <Edit3 className="w-4 h-4" />
                <span className="text-[10px] font-technical uppercase font-bold tracking-widest">Editar Perfil</span>
              </button>
            </div>
          </div>
        </div>
      </section>

      {/* Profile Details Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Account Settings */}
        <section className="bg-[#1c1f29] p-6 border border-[#3a494a]/20 space-y-6">
          <h3 className="font-headline text-sm text-[#00F5FF] uppercase tracking-widest flex items-center gap-2">
            <Settings className="w-4 h-4" />
            Configuración de Enlace
          </h3>
          <div className="space-y-3">
            {[
              { label: 'Seguridad Biométrica', active: true },
              { label: 'Notificaciones de Telemetría', active: true },
              { label: 'Modo de Bajo Consumo', active: false },
              { label: 'Sincronización Automática', active: true },
            ].map((item, i) => (
              <div key={i} className="flex items-center justify-between p-3 bg-[#0A0E17]">
                <span className="text-xs font-technical uppercase text-[#849495]">{item.label}</span>
                <div className={cn(
                  "w-8 h-4 rounded-full relative p-0.5 border transition-all",
                  item.active ? "bg-[#00fe87]/20 border-[#00fe87]/30" : "bg-[#3a494a]/20 border-[#3a494a]/30"
                )}>
                  <div className={cn(
                    "w-3 h-3 rounded-full transition-all",
                    item.active ? "bg-[#00fe87] ml-auto" : "bg-[#849495]"
                  )} />
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Recent Activity */}
        <section className="bg-[#1c1f29] p-6 border border-[#3a494a]/20 space-y-6">
          <h3 className="font-headline text-sm text-[#fe00fe] uppercase tracking-widest flex items-center gap-2">
            <History className="w-4 h-4" />
            Historial de Misiones
          </h3>
          <div className="space-y-3">
            {logs.length > 0 ? logs.map((log) => (
              <div key={log.id} className="flex items-center justify-between p-3 bg-[#0A0E17] border-l-2 border-[#fe00fe]">
                <div>
                  <p className="text-xs font-technical uppercase text-white">{log.message}</p>
                  <p className="text-[10px] text-[#849495] font-technical uppercase">{new Date(log.timestamp).toLocaleDateString()}</p>
                </div>
                <span className="text-xs font-headline text-[#00fe87]">{log.reward ? `+${log.reward} BC` : log.type.toUpperCase()}</span>
              </div>
            )) : (
              <div className="p-6 text-center text-[#849495] font-technical uppercase text-xs bg-[#0A0E17]">
                Sin misiones recientes
              </div>
            )}
          </div>
        </section>
      </div>

      {/* Logout Button */}
      <button 
        onClick={onLogout}
        className="w-full bg-[#ffb4ab]/10 border border-[#ffb4ab]/30 text-[#ffb4ab] py-4 font-headline text-sm uppercase tracking-widest hover:bg-[#ffb4ab]/20 transition-all flex items-center justify-center gap-3"
      >
        <LogOut className="w-5 h-5" />
        Desconectar Enlace Neuronal
      </button>
    </div>
  );
};
