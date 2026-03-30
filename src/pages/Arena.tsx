import React from 'react';
import { motion } from 'motion/react';
import { 
  Dumbbell, 
  Coins, 
  Heart, 
  Droplets, 
  Activity, 
  MapPin, 
  ArrowLeft,
  CheckCircle2,
  Thermometer,
  Wind
} from 'lucide-react';
import { cn } from '@/src/lib/utils';

import { auth, db, handleFirestoreError, OperationType } from '@/src/lib/firebase';
import { collection, addDoc } from 'firebase/firestore';

interface ArenaProps {
  onBack: () => void;
  onSuccess: (reward: number) => void;
}

export const Arena: React.FC<ArenaProps> = ({ onBack, onSuccess }) => {
  const [steps, setSteps] = React.useState(8420);
  const goal = 10000;
  const progress = (steps / goal) * 100;

  const logActivity = async (reward: number) => {
    if (!auth.currentUser) return;
    try {
      await addDoc(collection(db, 'logs'), {
        uid: auth.currentUser.uid,
        timestamp: new Date().toISOString(),
        message: `Módulo Arena completado: ${steps} pasos`,
        type: 'success',
        reward
      });
    } catch (error) {
      handleFirestoreError(error, OperationType.WRITE, 'logs');
    }
  };

  const handleComplete = async () => {
    const reward = 150;
    await logActivity(reward);
    onSuccess(reward);
    onBack();
  };

  return (
    <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-6">
      {/* Left Panel: Tactical Telemetry */}
      <aside className="lg:col-span-3 space-y-6 order-2 lg:order-1">
        <button 
          onClick={onBack}
          className="flex items-center gap-2 text-[#849495] hover:text-[#00F5FF] transition-colors mb-6 font-technical uppercase text-xs tracking-widest"
        >
          <ArrowLeft className="w-4 h-4" />
          Volver a Módulos
        </button>

        <div className="bg-[#1c1f29]/70 backdrop-blur-xl p-4 border-l-2 border-[#00F5FF] shadow-[0_0_15px_rgba(0,245,255,0.1)]">
          <h3 className="font-headline text-xs tracking-[0.2em] text-[#849495] mb-4 uppercase">MISSION PARAMETERS</h3>
          <div className="space-y-4">
            <div className="flex flex-col gap-1">
              <span className="text-[10px] text-[#b9caca] uppercase font-bold">Location</span>
              <span className="font-technical text-lg font-bold text-white">SECTOR-7 NEON WASTES</span>
            </div>
            <div className="flex flex-col gap-1">
              <span className="text-[10px] text-[#b9caca] uppercase font-bold">Reward Multiplier</span>
              <span className="font-technical text-lg font-bold text-[#00fe87]">1.5x ACTIVE</span>
            </div>
            <div className="flex flex-col gap-1">
              <span className="text-[10px] text-[#b9caca] uppercase font-bold">Gravity Level</span>
              <span className="font-technical text-lg font-bold text-white">0.86 G</span>
            </div>
          </div>
        </div>

        <div className="bg-[#181b25]/50 p-4 border-t border-[#3a494a]/30">
          <h3 className="font-headline text-xs tracking-[0.2em] text-[#849495] mb-4 uppercase">BIOMETRIC LOG</h3>
          <div className="space-y-2 font-mono text-[10px] text-[#00fe87]/70">
            <p>&gt; INITIATING SCAN...</p>
            <p>&gt; HEART_RATE: 112 BPM</p>
            <p>&gt; HYDRATION: 88%</p>
            <p>&gt; SYNC_STABILITY: NOMINAL</p>
          </div>
        </div>
      </aside>

      {/* Center Panel: The Kinetic Core */}
      <section className="lg:col-span-6 flex flex-col items-center justify-center space-y-8 order-1 lg:order-2">
        <div className="text-center space-y-2">
          <h1 className="font-headline text-2xl md:text-4xl font-black tracking-tighter text-white uppercase">MÓDULO: ARENA</h1>
          <div className="inline-flex items-center gap-2 px-4 py-1 bg-[#00F5FF]/10 border border-[#00F5FF]/20">
            <Coins className="w-4 h-4 text-[#00F5FF]" />
            <span className="font-technical text-sm font-bold text-[#00F5FF] tracking-widest uppercase">15 Bio-Coins per 1000 steps</span>
          </div>
        </div>

        {/* Kinetic HUD Element */}
        <div className="relative w-72 h-72 md:w-96 md:h-96 flex items-center justify-center">
          {/* Circular Progress Background */}
          <svg className="absolute inset-0 w-full h-full -rotate-90" viewBox="0 0 100 100">
            <circle 
              className="text-[#31353f]" 
              cx="50" cy="50" r="45" 
              fill="none" stroke="currentColor" strokeWidth="2" 
            />
            <motion.circle 
              initial={{ strokeDashoffset: 282.7 }}
              animate={{ strokeDashoffset: 282.7 - (282.7 * progress) / 100 }}
              className="drop-shadow-[0_0_8px_rgba(255,107,53,0.6)]" 
              cx="50" cy="50" r="45" 
              fill="none" stroke="#FF6B35" strokeDasharray="282.7" strokeLinecap="round" strokeWidth="3" 
            />
          </svg>

          {/* Animated Walking Avatar Container */}
          <div className="z-10 w-48 h-48 md:w-64 md:h-64 rounded-full bg-gradient-to-b from-[#1c1f29] to-[#0a0e17] border border-[#3a494a]/30 flex items-center justify-center overflow-hidden relative group">
            <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-[#00F5FF]/5 via-transparent to-transparent"></div>
            <img 
              src="https://picsum.photos/seed/robot-walk/400/400" 
              alt="Avatar" 
              className="w-3/4 h-3/4 object-contain opacity-90 grayscale brightness-150" 
            />
            {/* Scanning Line Animation */}
            <motion.div 
              animate={{ y: [0, 256, 0] }}
              transition={{ duration: 3, repeat: Infinity, ease: "linear" }}
              className="absolute top-0 left-0 w-full h-[2px] bg-[#00F5FF]/40 shadow-[0_0_10px_#00F5FF]"
            />
          </div>

          {/* Floating Data Points */}
          <div className="absolute -top-4 -right-4 bg-[#262a34]/90 backdrop-blur-md p-3 border border-[#3a494a]/30 flex flex-col items-end">
            <span className="text-[10px] text-[#849495] uppercase font-bold tracking-tighter">Energy Burn</span>
            <span className="font-headline text-lg font-bold text-[#FF6B35]">442 KCAL</span>
          </div>
        </div>

        {/* Step Counter */}
        <div className="w-full max-w-md bg-[#1c1f29]/40 backdrop-blur-sm p-6 border-b-2 border-[#00F5FF]/30 relative">
          <div className="absolute top-0 left-0 w-4 h-4 border-t-2 border-l-2 border-[#00F5FF]"></div>
          <div className="absolute top-0 right-0 w-4 h-4 border-t-2 border-r-2 border-[#00F5FF]"></div>
          <div className="flex flex-col items-center gap-1">
            <span className="font-headline text-xs tracking-[0.3em] text-[#849495] uppercase">Tactical Progress</span>
            <span className="font-headline text-3xl md:text-4xl font-black text-white tracking-widest">
              {steps.toLocaleString()} / {goal.toLocaleString()}
            </span>
            <span className="font-technical text-sm text-[#00F5FF] font-bold tracking-[0.4em] mt-1 uppercase">Pasos</span>
          </div>
        </div>

        {/* Action Button */}
        <button 
          onClick={handleComplete}
          className="group relative px-12 py-4 overflow-hidden transition-all active:scale-95"
          style={{ clipPath: 'polygon(10% 0, 100% 0, 100% 70%, 90% 100%, 0 100%, 0 30%)' }}
        >
          <div className="absolute inset-0 bg-[#00fe87] opacity-20 group-hover:opacity-30 transition-opacity"></div>
          <div className="absolute inset-0 border-2 border-[#00fe87]/50 shadow-[0_0_15px_rgba(0,254,135,0.3)] group-hover:shadow-[0_0_25px_rgba(0,254,135,0.5)]"></div>
          <span className="relative z-10 font-headline font-black text-[#00fe87] tracking-widest flex items-center gap-3">
            <CheckCircle2 className="w-5 h-5" />
            VALIDAR MISIÓN
          </span>
        </button>
      </section>

      {/* Right Panel: Environment Data */}
      <aside className="lg:col-span-3 space-y-6 order-3">
        <div className="bg-[#1c1f29]/70 backdrop-blur-xl p-4 border-r-2 border-[#fe00fe] shadow-[0_0_15px_rgba(254,0,254,0.1)]">
          <h3 className="font-headline text-xs tracking-[0.2em] text-[#849495] mb-4 uppercase">ARENA CONDITIONS</h3>
          <div className="space-y-4">
            <div className="p-3 bg-[#0a0e17] border border-[#3a494a]/20">
              <div className="flex justify-between items-center mb-2">
                <div className="flex items-center gap-2">
                  <Wind className="w-3 h-3 text-[#00fe87]" />
                  <span className="text-[10px] text-[#849495] font-bold uppercase">Atmosphere</span>
                </div>
                <span className="text-[10px] text-[#00fe87]">O2 OPTIMAL</span>
              </div>
              <div className="w-full bg-[#262a34] h-1">
                <div className="bg-[#00fe87] h-full w-[92%]"></div>
              </div>
            </div>
            <div className="p-3 bg-[#0a0e17] border border-[#3a494a]/20">
              <div className="flex justify-between items-center mb-2">
                <div className="flex items-center gap-2">
                  <Thermometer className="w-3 h-3 text-[#fe00fe]" />
                  <span className="text-[10px] text-[#849495] font-bold uppercase">Temp</span>
                </div>
                <span className="text-[10px] text-[#fe00fe]">22.4 °C</span>
              </div>
              <div className="w-full bg-[#262a34] h-1">
                <div className="bg-[#fe00fe] h-full w-[45%]"></div>
              </div>
            </div>
          </div>
        </div>

        <div className="relative group cursor-crosshair overflow-hidden border border-[#3a494a]/30">
          <div className="absolute inset-0 bg-[#00F5FF]/5 group-hover:bg-[#00F5FF]/10 transition-colors z-10"></div>
          <img 
            src="https://picsum.photos/seed/map/600/400" 
            alt="Tactical Map" 
            className="w-full h-48 object-cover grayscale brightness-50 contrast-125" 
          />
          <div className="absolute inset-0 flex flex-col items-center justify-center p-4 z-20">
            <MapPin className="text-[#00F5FF] mb-2 w-8 h-8 animate-bounce" />
            <span className="font-technical text-xs font-bold text-white uppercase tracking-widest text-center">Patrol Area Syncing...</span>
          </div>
        </div>
      </aside>
    </div>
  );
};
