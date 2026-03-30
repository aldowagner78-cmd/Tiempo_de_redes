import React from 'react';
import { motion } from 'motion/react';
import { 
  Dumbbell, 
  Utensils, 
  BookOpen, 
  Calculator, 
  Puzzle, 
  Code,
  Coins,
  ChevronRight
} from 'lucide-react';
import { cn } from '@/src/lib/utils';

const modules = [
  { 
    id: 'arena', 
    title: 'ARENA', 
    description: 'Kinetic endurance training. Synchronize physical movements with the Nexus Core.', 
    icon: Dumbbell, 
    reward: 250, 
    progress: 66,
    color: 'text-[#00F5FF]',
    borderColor: 'border-[#00F5FF]/20'
  },
  { 
    id: 'bio-fuel', 
    title: 'BIO-FUEL', 
    description: 'Log nutritional intake. Ensure biological hardware is optimized for deep space travel.', 
    icon: Utensils, 
    reward: 150, 
    progress: 25,
    color: 'text-[#00fe87]',
    borderColor: 'border-[#00fe87]/20'
  },
  { 
    id: 'comms', 
    title: 'COMMS', 
    description: 'Decipher ancient logs and interstellar scripts. Literacy level optimization protocol.', 
    icon: BookOpen, 
    reward: 300, 
    progress: 80,
    color: 'text-[#fe00fe]',
    borderColor: 'border-[#fe00fe]/20'
  },
  { 
    id: 'math', 
    title: 'MATH', 
    description: 'Calculate orbital trajectories and quantum physics equations. Accuracy is critical.', 
    icon: Calculator, 
    reward: 400, 
    progress: 50,
    color: 'text-[#00F5FF]',
    borderColor: 'border-[#00F5FF]/20'
  },
  { 
    id: 'logic', 
    title: 'LOGIC', 
    description: 'Resolve structural paradoxes in the system. Neural pathway reconstruction.', 
    icon: Puzzle, 
    reward: 200, 
    progress: 75,
    color: 'text-[#00fe87]',
    borderColor: 'border-[#00fe87]/20'
  },
  { 
    id: 'coding', 
    title: 'CODING', 
    description: 'Override Nexus protocols. Rewrite core functions using advanced logic strings.', 
    icon: Code, 
    reward: 500, 
    progress: 15,
    color: 'text-[#fe00fe]',
    borderColor: 'border-[#fe00fe]/20'
  },
];

interface ModulesProps {
  onSelectModule: (id: string) => void;
}

export const Modules: React.FC<ModulesProps> = ({ onSelectModule }) => {
  return (
    <div className="space-y-8">
      <div className="mb-8 flex justify-between items-end">
        <div className="relative px-4 py-2">
          <div className="absolute top-[-2px] left-[-2px] w-3 h-3 border-t-2 border-l-2 border-[#00F5FF]"></div>
          <h1 className="font-headline text-2xl font-black tracking-widest text-white uppercase">COMMAND_CENTER</h1>
          <p className="font-technical text-sm text-[#849495] uppercase tracking-widest">Select training module for extraction</p>
        </div>
        <button className="bg-[#00F5FF] text-[#003739] px-6 py-2 font-headline text-xs font-bold tracking-widest hover:brightness-110 transition-all flex items-center gap-2 shadow-[0_0_15px_rgba(0,245,255,0.3)]">
          <Coins className="w-4 h-4" />
          CANJEAR TIEMPO
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {modules.map((module) => (
          <motion.div
            key={module.id}
            whileHover={{ scale: 1.02 }}
            onClick={() => onSelectModule(module.id)}
            className={cn(
              "bg-[#1c1f29]/70 backdrop-blur-xl group relative p-6 border hover:border-[#00F5FF]/60 transition-all cursor-pointer overflow-hidden",
              module.borderColor
            )}
          >
            <div className="absolute top-2 right-2 w-1 h-1 bg-[#00fe87]"></div>
            <div className="flex gap-6 items-start">
              <div className="p-4 bg-[#262a34] border border-[#00F5FF]/30 group-hover:scale-110 transition-transform">
                <module.icon className={cn("w-8 h-8", module.color)} />
              </div>
              <div className="flex-1">
                <div className="flex justify-between items-center mb-1">
                  <h3 className="font-headline text-lg font-bold text-white tracking-tighter">{module.title}</h3>
                  <div className="flex items-center gap-1">
                    <Coins className="w-3 h-3 text-[#00fe87]" />
                    <span className="font-technical text-xs font-bold text-[#00fe87]">+{module.reward}</span>
                  </div>
                </div>
                <p className="font-technical text-[#b9caca] text-sm leading-tight uppercase tracking-tight">{module.description}</p>
                <div className="mt-4 h-1 w-full bg-[#181b25] overflow-hidden">
                  <motion.div 
                    initial={{ width: 0 }}
                    animate={{ width: `${module.progress}%` }}
                    className="h-full bg-[#00F5FF] shadow-[0_0_8px_rgba(0,245,255,1)]"
                  />
                </div>
              </div>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
};
