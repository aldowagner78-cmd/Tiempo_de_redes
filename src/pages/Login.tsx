import React from 'react';
import { motion } from 'motion/react';
import { Shield, Rocket, Sparkles, LogIn } from 'lucide-react';

interface LoginProps {
  onLogin: () => void;
}

export const Login: React.FC<LoginProps> = ({ onLogin }) => {
  return (
    <div className="min-h-screen bg-[#0A0E17] flex flex-col items-center justify-center p-6 relative overflow-hidden">
      {/* Background Decor */}
      <div className="absolute inset-0 pointer-events-none bg-[linear-gradient(to_bottom,transparent_50%,rgba(223,226,239,0.03)_50%)] bg-[length:100%_4px] z-0"></div>
      <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-[#00F5FF]/5 blur-[120px] rounded-full"></div>
      <div className="absolute bottom-[-10%] right-[-10%] w-[50%] h-[50%] bg-[#fe00fe]/5 blur-[150px] rounded-full"></div>

      <motion.div 
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        className="relative z-10 w-full max-w-md bg-[#1c1f29]/80 backdrop-blur-xl p-12 border border-[#00F5FF]/20 shadow-[0_0_50px_rgba(0,245,255,0.1)] flex flex-col items-center text-center"
      >
        {/* Corner Brackets */}
        <div className="absolute top-[-2px] left-[-2px] w-8 h-8 border-t-2 border-l-2 border-[#00F5FF]"></div>
        <div className="absolute top-[-2px] right-[-2px] w-8 h-8 border-t-2 border-r-2 border-[#00F5FF]"></div>
        <div className="absolute bottom-[-2px] left-[-2px] w-8 h-8 border-b-2 border-l-2 border-[#00F5FF]"></div>
        <div className="absolute bottom-[-2px] right-[-2px] w-8 h-8 border-b-2 border-r-2 border-[#00F5FF]"></div>

        <div className="w-20 h-20 rounded-full bg-[#00F5FF]/10 flex items-center justify-center border border-[#00F5FF]/30 mb-8 shadow-[0_0_20px_rgba(0,245,255,0.3)]">
          <Shield className="w-10 h-10 text-[#00F5FF]" />
        </div>

        <h1 className="text-4xl font-headline font-black text-white tracking-widest uppercase mb-2">
          NEXUS CONTROL
        </h1>
        <p className="text-[#849495] font-technical uppercase tracking-widest text-sm mb-12">
          Estableciendo protocolo de enlace neuronal...
        </p>

        <div className="space-y-4 w-full">
          <button 
            onClick={onLogin}
            className="w-full bg-[#00F5FF] text-[#003739] font-headline font-bold py-4 tracking-[0.2em] shadow-[0_0_20px_rgba(0,245,255,0.4)] hover:brightness-110 active:scale-[0.98] transition-all flex items-center justify-center gap-3"
            style={{ clipPath: 'polygon(10% 0, 100% 0, 100% 70%, 90% 100%, 0 100%, 0 30%)' }}
          >
            <LogIn className="w-5 h-5" />
            INICIAR ENLACE (GOOGLE)
          </button>
          
          <div className="flex items-center gap-4 py-4">
            <div className="h-px flex-1 bg-[#3a494a]/30"></div>
            <span className="text-[10px] text-[#849495] font-technical uppercase">Sistemas Activos</span>
            <div className="h-px flex-1 bg-[#3a494a]/30"></div>
          </div>

          <div className="grid grid-cols-3 gap-4">
            {[
              { icon: Rocket, label: 'Misiones' },
              { icon: Sparkles, label: 'IA Nexus' },
              { icon: Shield, label: 'Seguridad' },
            ].map((item, i) => (
              <div key={i} className="flex flex-col items-center gap-2">
                <div className="w-10 h-10 rounded-full bg-[#181b25] border border-[#3a494a]/30 flex items-center justify-center text-[#849495]">
                  <item.icon className="w-5 h-5" />
                </div>
                <span className="text-[8px] text-[#849495] font-technical uppercase tracking-widest">{item.label}</span>
              </div>
            ))}
          </div>
        </div>
      </motion.div>

      <div className="absolute bottom-8 text-[10px] text-[#849495] font-technical uppercase tracking-[0.5em] opacity-30">
        © 2026 NEXUS CONTROL SYSTEMS - ALL RIGHTS RESERVED
      </div>
    </div>
  );
};
