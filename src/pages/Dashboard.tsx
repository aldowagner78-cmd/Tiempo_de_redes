import React from 'react';
import { motion } from 'motion/react';
import { 
  Clock, 
  Coins, 
  Layers, 
  Activity, 
  ShieldCheck, 
  Terminal,
  ChevronDown,
  Lock,
  Globe,
  MessageSquare,
  Play
} from 'lucide-react';
import { StatCard } from '@/src/components/StatCard';
import { Chart } from '@/src/components/Chart';
import { cn } from '@/src/lib/utils';
import { collection, query, where, orderBy, limit, onSnapshot } from 'firebase/firestore';
import { db, handleFirestoreError, OperationType } from '@/src/lib/firebase';
import { UserStats, LogEntry } from '@/src/types';

const weeklyData = [
  { name: 'LUN', value: 160 },
  { name: 'MAR', value: 140 },
  { name: 'MIE', value: 110 },
  { name: 'JUE', value: 130 },
  { name: 'VIE', value: 80 },
  { name: 'SAB', value: 140 },
  { name: 'DOM', value: 100 },
];

interface DashboardProps {
  stats: UserStats;
}

export const Dashboard: React.FC<DashboardProps> = ({ stats }) => {
  const [logs, setLogs] = React.useState<LogEntry[]>([]);

  React.useEffect(() => {
    const logsRef = collection(db, 'logs');
    const q = query(
      logsRef, 
      where('uid', '==', stats.uid),
      orderBy('timestamp', 'desc'),
      limit(5)
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
    <div className="space-y-8">
      {/* Dashboard Header & Profile Selector */}
      <section className="flex flex-col md:flex-row justify-between items-start md:items-end gap-6">
        <div className="space-y-1">
          <div className="flex items-center gap-2 text-[#00fe87]">
            <ShieldCheck className="w-4 h-4" />
            <span className="font-technical uppercase tracking-tighter text-xs font-bold">Acceso Nivel 5: Comandante</span>
          </div>
          <h1 className="text-4xl md:text-5xl font-headline font-black text-white tracking-tight uppercase">Centro de Comando</h1>
        </div>
        
        {/* Profile Selector Box */}
        <div className="relative group cursor-pointer bg-[#1c1f29] p-4 min-w-[240px] border border-[#3a494a]/30 hover:border-[#00F5FF]/50 transition-colors">
          {/* Corner Brackets */}
          <div className="absolute top-[-2px] left-[-2px] w-2.5 h-2.5 border-t-2 border-l-2 border-[#00F5FF]"></div>
          <div className="absolute top-[-2px] right-[-2px] w-2.5 h-2.5 border-t-2 border-r-2 border-[#00F5FF]"></div>
          <div className="absolute bottom-[-2px] left-[-2px] w-2.5 h-2.5 border-b-2 border-l-2 border-[#00F5FF]"></div>
          <div className="absolute bottom-[-2px] right-[-2px] w-2.5 h-2.5 border-b-2 border-r-2 border-[#00F5FF]"></div>
          
          <div className="flex justify-between items-center">
            <div className="flex flex-col">
              <span className="font-label text-[10px] text-[#849495] uppercase tracking-widest">Sujeto Actual</span>
              <span className="font-headline text-[#00F5FF] text-lg tracking-wider">{stats.displayName}</span>
            </div>
            <ChevronDown className="text-[#00F5FF] w-5 h-5" />
          </div>
        </div>
      </section>

      {/* Navigation Tabs */}
      <nav className="flex overflow-x-auto gap-1 border-b border-[#3a494a]/20 scrollbar-hide">
        {['Resumen', 'Hijos', 'Apps', 'Tareas', 'Estadísticas'].map((tab, i) => (
          <button 
            key={tab}
            className={cn(
              "px-6 py-3 border-b-2 font-technical uppercase font-bold tracking-widest transition-all",
              i === 0 
                ? "border-[#00F5FF] text-[#00F5FF] bg-[#00F5FF]/5" 
                : "border-transparent text-[#849495] hover:text-white hover:bg-[#1c1f29]"
            )}
          >
            {tab}
          </button>
        ))}
      </nav>

      {/* Bento Grid Layout for Summary Content */}
      <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-4">
        {/* Stat Card: Total Time */}
        <div className="col-span-1 md:col-span-2 bg-[#1c1f29] p-6 relative overflow-hidden group border border-[#3a494a]/10">
          <div className="absolute top-0 right-0 w-24 h-24 bg-[#00F5FF]/5 rounded-full -mr-12 -mt-12 blur-3xl"></div>
          <div className="flex justify-between items-start mb-6">
            <div>
              <p className="font-label text-xs text-[#849495] uppercase tracking-widest mb-1">Tiempo de Enlace Hoy</p>
              <h3 className="text-3xl font-headline text-white">03:45:12</h3>
            </div>
            <div className="bg-[#00F5FF]/10 p-2 rounded-sm text-[#00F5FF]">
              <Clock className="w-5 h-5" />
            </div>
          </div>
          
          {/* Visual Graph Placeholder */}
          <div className="h-32 flex items-end gap-1 px-2">
            {[30, 45, 60, 20, 90, 40, 55].map((h, i) => (
              <motion.div 
                key={i}
                initial={{ height: 0 }}
                animate={{ height: `${h}%` }}
                className={cn(
                  "flex-1 transition-all rounded-t-sm",
                  i === 4 ? "bg-[#00F5FF] shadow-[0_0_15px_rgba(0,245,255,0.4)]" : "bg-[#3a494a]/20 hover:bg-[#00F5FF]/40"
                )}
              />
            ))}
          </div>
          <div className="mt-4 flex justify-between text-[10px] font-technical text-[#849495] uppercase">
            <span>0800 HRS</span>
            <span>1400 HRS</span>
            <span>2000 HRS</span>
          </div>
        </div>

        {/* Stat Card: Bio-Coins */}
        <StatCard 
          title="Bio-Coins"
          value={stats.bioCoins.toLocaleString()}
          icon={Coins}
          subtitle="Saldo Actual"
          trend={{ value: 12, isUp: true }}
          color="tertiary"
        />

        {/* Stat Card: Modules */}
        <StatCard 
          title="Módulos Completos"
          value={stats.completedModules.toString().padStart(2, '0')}
          icon={Layers}
          subtitle="Progreso de Objetivos"
          progress={(stats.completedModules / 10) * 100}
          color="secondary"
        />

        {/* Weekly Usage Chart Card */}
        <div className="col-span-1 md:col-span-3 bg-[#1c1f29] p-8 relative border border-[#3a494a]/10">
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
            <div>
              <h4 className="font-headline text-xl text-white tracking-wide uppercase">Análisis de Enlace Semanal</h4>
              <p className="text-sm text-[#849495] font-body">Registro de actividad de los últimos 7 ciclos solares.</p>
            </div>
            <div className="flex gap-2">
              <div className="flex items-center gap-2 px-3 py-1.5 bg-[#0A0E17] border border-[#3a494a]/50">
                <div className="w-2 h-2 rounded-full bg-[#00F5FF] animate-pulse"></div>
                <span className="text-[10px] font-technical text-white uppercase">Real</span>
              </div>
              <div className="flex items-center gap-2 px-3 py-1.5 bg-[#0A0E17] border border-[#3a494a]/50">
                <div className="w-2 h-2 rounded-full bg-[#fe00fe]"></div>
                <span className="text-[10px] font-technical text-white uppercase">Límite</span>
              </div>
            </div>
          </div>
          
          <Chart data={weeklyData} color="#00F5FF" />
        </div>

        {/* Side Module: Active Restrictions */}
        <div className="col-span-1 bg-[#262a34] border border-[#3a494a]/30 flex flex-col p-6">
          <h4 className="font-headline text-sm mb-6 uppercase tracking-widest text-white">Restricciones de Red</h4>
          <div className="space-y-4 flex-1">
            {[
              { label: 'Acceso Global', icon: Globe, active: true, color: 'text-[#00F5FF]' },
              { label: 'Social Hub', icon: MessageSquare, active: false, color: 'text-[#fe00fe]' },
              { label: 'Streaming', icon: Play, active: true, color: 'text-[#00F5FF]' },
            ].map((item, i) => (
              <div key={i} className="flex items-center justify-between p-3 bg-[#0A0E17]">
                <div className="flex items-center gap-3">
                  <item.icon className={cn("w-4 h-4", item.color)} />
                  <span className="text-xs font-technical uppercase">{item.label}</span>
                </div>
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
          <button className="mt-6 w-full bg-[#00F5FF] text-[#003739] font-headline text-xs py-3 uppercase tracking-tighter hover:brightness-110 transition-all flex items-center justify-center gap-2">
            <Lock className="w-3 h-3" />
            Modificar Protocolos
          </button>
        </div>
      </div>

      {/* Recent Logs Section */}
      <section className="bg-[#1c1f29] p-6 border border-[#3a494a]/10">
        <h4 className="font-headline text-sm mb-6 uppercase tracking-widest text-[#00F5FF] flex items-center gap-2">
          <Terminal className="w-4 h-4" />
          Registros de Telemetría Recientes
        </h4>
        <div className="space-y-px overflow-hidden rounded-sm border border-[#3a494a]/20">
          {logs.length > 0 ? logs.map((log) => (
            <div key={log.id} className="bg-[#0A0E17]/50 p-3 flex justify-between items-center text-xs font-technical border-b border-[#3a494a]/10 last:border-0">
              <span className="text-[#849495] font-mono">[{new Date(log.timestamp).toLocaleTimeString()}]</span>
              <span className="text-white uppercase tracking-wide flex-1 px-4">{log.message}</span>
              <span className={cn(
                "uppercase font-bold", 
                log.type === 'success' ? 'text-[#00fe87]' : 
                log.type === 'error' ? 'text-[#ffb4ab]' : 
                log.type === 'warning' ? 'text-[#fe00fe]' : 'text-[#00F5FF]'
              )}>
                {log.reward ? `+${log.reward} BC` : log.type.toUpperCase()}
              </span>
            </div>
          )) : (
            <div className="bg-[#0A0E17]/50 p-6 text-center text-[#849495] font-technical uppercase text-xs">
              Sin registros de actividad recientes
            </div>
          )}
        </div>
      </section>
    </div>
  );
};
