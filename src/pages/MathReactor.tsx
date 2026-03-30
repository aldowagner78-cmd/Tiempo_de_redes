import React from 'react';
import { motion } from 'motion/react';
import { 
  Coins, 
  Bolt, 
  Database, 
  Delete, 
  CheckCircle2,
  ArrowLeft
} from 'lucide-react';
import { cn } from '@/src/lib/utils';

import { auth, db, handleFirestoreError, OperationType } from '@/src/lib/firebase';
import { collection, addDoc } from 'firebase/firestore';

interface MathReactorProps {
  onBack: () => void;
  onSuccess: (reward: number) => void;
}

export const MathReactor: React.FC<MathReactorProps> = ({ onBack, onSuccess }) => {
  const [input, setInput] = React.useState('');
  const [problem, setProblem] = React.useState({ a: 42, b: 15, op: '×', result: 630 });
  const [status, setStatus] = React.useState<'idle' | 'correct' | 'wrong'>('idle');

  const handleKey = (key: string) => {
    if (key === 'backspace') {
      setInput(prev => prev.slice(0, -1));
    } else if (key === '.') {
      if (!input.includes('.')) setInput(prev => prev + '.');
    } else {
      setInput(prev => prev + key);
    }
  };

  const logActivity = async (reward: number) => {
    if (!auth.currentUser) return;
    try {
      await addDoc(collection(db, 'logs'), {
        uid: auth.currentUser.uid,
        timestamp: new Date().toISOString(),
        message: `Módulo Math Reactor completado`,
        type: 'success',
        reward
      });
    } catch (error) {
      handleFirestoreError(error, OperationType.WRITE, 'logs');
    }
  };

  const validate = async () => {
    if (parseInt(input) === problem.result) {
      setStatus('correct');
      const reward = 10;
      await logActivity(reward);
      setTimeout(() => {
        onSuccess(reward);
        generateProblem();
        setInput('');
        setStatus('idle');
      }, 1000);
    } else {
      setStatus('wrong');
      setTimeout(() => setStatus('idle'), 1000);
    }
  };

  const generateProblem = () => {
    const a = Math.floor(Math.random() * 50) + 10;
    const b = Math.floor(Math.random() * 20) + 2;
    setProblem({ a, b, op: '×', result: a * b });
  };

  return (
    <div className="relative z-10 max-w-lg mx-auto flex flex-col min-h-[calc(100vh-12rem)]">
      <button 
        onClick={onBack}
        className="self-start flex items-center gap-2 text-[#849495] hover:text-[#00F5FF] transition-colors mb-6 font-technical uppercase text-xs tracking-widest"
      >
        <ArrowLeft className="w-4 h-4" />
        Volver a Módulos
      </button>

      <div className="mb-8 flex flex-col items-center">
        <h1 className="font-headline text-2xl font-black text-[#00F5FF] tracking-[0.2em] uppercase text-center mb-1">
          REACTOR MATEMÁTICO
        </h1>
        <div className="flex items-center gap-2 bg-[#262a34] px-4 py-1 rounded-full border border-[#00fe87]/30">
          <Coins className="w-4 h-4 text-[#00fe87]" />
          <span className="font-label text-[10px] uppercase font-bold tracking-widest text-[#00fe87]">10 Bio-Coins per problem</span>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-4 mb-6">
        <div className="bg-[#1c1f29]/60 backdrop-blur-md p-3 border-l-2 border-[#00F5FF]">
          <div className="flex justify-between items-end mb-1">
            <span className="font-label text-[10px] text-[#849495] uppercase tracking-tighter">Status Misión</span>
            <span className="font-headline text-xs text-[#00F5FF]">4 / 10</span>
          </div>
          <div className="h-1 bg-[#31353f] w-full overflow-hidden">
            <div className="h-full bg-[#00F5FF] w-[40%] shadow-[0_0_10px_rgba(0,245,255,0.5)]"></div>
          </div>
        </div>
        <div className="bg-[#1c1f29]/60 backdrop-blur-md p-3 border-r-2 border-[#fe00fe]">
          <div className="flex justify-between items-end mb-1">
            <span className="font-label text-[10px] text-[#849495] uppercase tracking-tighter">Sincronización</span>
            <span className="font-headline text-xs text-[#fe00fe] animate-pulse">88%</span>
          </div>
          <div className="h-1 bg-[#31353f] w-full overflow-hidden">
            <div className="h-full bg-[#fe00fe] w-[88%] shadow-[0_0_10px_rgba(254,0,254,0.5)]"></div>
          </div>
        </div>
      </div>

      <div className="flex-grow flex flex-col justify-center items-center relative mb-8">
        <div className="absolute top-0 left-0 w-8 h-8 border-t-2 border-l-2 border-[#00F5FF]/40"></div>
        <div className="absolute top-0 right-0 w-8 h-8 border-t-2 border-r-2 border-[#00F5FF]/40"></div>
        <div className="absolute bottom-0 left-0 w-8 h-8 border-b-2 border-l-2 border-[#00F5FF]/40"></div>
        <div className="absolute bottom-0 right-0 w-8 h-8 border-b-2 border-r-2 border-[#00F5FF]/40"></div>
        
        <div className="bg-[#262a34]/40 w-full py-12 flex flex-col items-center justify-center rounded-sm">
          <div className="font-headline text-5xl md:text-6xl text-white tracking-tighter mb-4 flex items-center gap-4">
            <span>{problem.a}</span>
            <span className="text-[#00F5FF]/60">{problem.op}</span>
            <span>{problem.b}</span>
            <span className="text-[#00F5FF]/60">=</span>
            <span className={cn(
              "text-[#00F5FF] border-b-4 border-[#00F5FF] min-w-[80px] text-center",
              status === 'idle' && "animate-pulse",
              status === 'correct' && "text-[#00fe87] border-[#00fe87]",
              status === 'wrong' && "text-[#ffb4ab] border-[#ffb4ab]"
            )}>
              {input || '?'}
            </span>
          </div>
          <div className="flex items-center gap-2 opacity-60">
            <Database className="w-3 h-3 text-[#849495]" />
            <span className="font-label text-[10px] text-[#849495] uppercase tracking-widest">Protocolo de Energía: Delta-9</span>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-3 gap-2 mb-8">
        {[1, 2, 3, 4, 5, 6, 7, 8, 9].map(num => (
          <button 
            key={num}
            onClick={() => handleKey(num.toString())}
            className="bg-[#262a34] py-4 rounded border border-[#3a494a]/30 font-headline text-xl text-white hover:bg-[#00F5FF] hover:text-[#003739] transition-all active:scale-95"
          >
            {num}
          </button>
        ))}
        <button 
          onClick={() => handleKey('backspace')}
          className="bg-[#262a34] py-4 rounded border border-[#3a494a]/30 font-headline text-xl text-[#fe00fe] hover:bg-[#fe00fe] hover:text-white transition-all active:scale-95 flex items-center justify-center"
        >
          <Delete className="w-6 h-6" />
        </button>
        <button 
          onClick={() => handleKey('0')}
          className="bg-[#262a34] py-4 rounded border border-[#3a494a]/30 font-headline text-xl text-white hover:bg-[#00F5FF] hover:text-[#003739] transition-all active:scale-95"
        >
          0
        </button>
        <button 
          onClick={() => handleKey('.')}
          className="bg-[#262a34] py-4 rounded border border-[#3a494a]/30 font-headline text-xl text-[#00fe87] hover:bg-[#00fe87] hover:text-white transition-all active:scale-95"
        >
          .
        </button>
      </div>

      <button 
        onClick={validate}
        className="w-full bg-[#00F5FF] text-[#003739] font-headline font-bold py-5 tracking-[0.2em] shadow-[0_0_20px_rgba(0,245,255,0.4)] hover:brightness-110 active:scale-[0.98] transition-all flex items-center justify-center gap-3"
        style={{ clipPath: 'polygon(10% 0, 100% 0, 100% 70%, 90% 100%, 0 100%, 0 30%)' }}
      >
        <Bolt className="w-5 h-5" />
        VALIDAR RESPUESTA
      </button>
    </div>
  );
};
