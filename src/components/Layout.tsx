import React from 'react';
import { motion } from 'motion/react';
import { 
  LayoutDashboard, 
  Rocket, 
  Wallet, 
  User, 
  Shield, 
  Clock, 
  Terminal,
  Menu,
  X,
  Plus
} from 'lucide-react';
import { cn } from '@/src/lib/utils';

interface LayoutProps {
  children: React.ReactNode;
  activeTab: string;
  setActiveTab: (tab: string) => void;
  userPhoto?: string;
  userName?: string;
}

export const Layout: React.FC<LayoutProps> = ({ children, activeTab, setActiveTab, userPhoto, userName }) => {
  const [isMenuOpen, setIsMenuOpen] = React.useState(false);

  const navItems = [
    { id: 'dashboard', label: 'Resumen', icon: LayoutDashboard },
    { id: 'missions', label: 'Misiones', icon: Rocket },
    { id: 'vault', label: 'Mercado', icon: Wallet },
    { id: 'profile', label: 'Perfil', icon: User },
  ];

  return (
    <div className="bg-[#0A0E17] text-[#dfe2ef] min-h-screen font-body selection:bg-[#00F5FF]/30 selection:text-[#00F5FF] overflow-x-hidden">
      {/* Scanline Texture Overlay */}
      <div className="fixed inset-0 pointer-events-none bg-[linear-gradient(to_bottom,transparent_50%,rgba(223,226,239,0.03)_50%)] bg-[length:100%_4px] z-[100]"></div>

      {/* Top Navigation Bar */}
      <header className="fixed top-0 w-full z-50 flex justify-between items-center px-6 h-16 bg-[#0A0E17]/70 backdrop-blur-xl border-b border-[#00F5FF]/10 shadow-[0_0_20px_rgba(0,245,255,0.15)]">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-full bg-[#00F5FF]/10 flex items-center justify-center overflow-hidden border border-[#00F5FF]/30">
            {userPhoto ? (
              <img src={userPhoto} alt="Pilot" className="w-full h-full object-cover" />
            ) : (
              <User className="text-[#00F5FF] w-5 h-5" />
            )}
          </div>
          <span className="text-[#00F5FF] font-headline font-black tracking-widest text-xl drop-shadow-[0_0_8px_rgba(0,245,255,0.8)]">
            NEXUS CONTROL
          </span>
        </div>
        <div className="flex items-center gap-4">
          <div className="hidden md:flex items-center gap-6 px-4">
            <button onClick={() => setActiveTab('dashboard')} className={cn("font-label tracking-[0.1em] uppercase text-sm transition-all", activeTab === 'dashboard' ? "text-[#00F5FF] drop-shadow-[0_0_5px_rgba(0,245,255,1)]" : "text-[#849495] hover:text-[#FE00FE]")}>Comando</button>
            <button onClick={() => setActiveTab('missions')} className={cn("font-label tracking-[0.1em] uppercase text-sm transition-all", activeTab === 'missions' ? "text-[#00F5FF] drop-shadow-[0_0_5px_rgba(0,245,255,1)]" : "text-[#849495] hover:text-[#FE00FE]")}>Flota</button>
            <button onClick={() => setActiveTab('vault')} className={cn("font-label tracking-[0.1em] uppercase text-sm transition-all", activeTab === 'vault' ? "text-[#00F5FF] drop-shadow-[0_0_5px_rgba(0,245,255,1)]" : "text-[#849495] hover:text-[#FE00FE]")}>Sistemas</button>
          </div>
          <div className="bg-[#1c1f29]/50 px-3 py-1 rounded-sm border border-[#e9feff]/10">
            <span className="text-[#00F5FF] font-label tracking-[0.1em] uppercase text-sm font-bold">00:42:15</span>
          </div>
        </div>
      </header>

      {/* Main Content Area */}
      <main className="pt-24 pb-32 px-4 md:px-8 max-w-7xl mx-auto">
        <motion.div
          key={activeTab}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.3 }}
        >
          {children}
        </motion.div>
      </main>

      {/* Bottom Navigation Bar */}
      <nav className="fixed bottom-0 left-0 w-full z-50 flex justify-around items-center h-20 px-4 pb-safe bg-[#0A0E17]/80 backdrop-blur-md border-t border-[#00F5FF]/20 shadow-[0_-10px_30px_rgba(0,245,255,0.1)]">
        {navItems.map((item) => (
          <button
            key={item.id}
            onClick={() => setActiveTab(item.id)}
            className={cn(
              "flex flex-col items-center justify-center transition-all",
              activeTab === item.id 
                ? "text-[#00F5FF] scale-110 drop-shadow-[0_0_10px_rgba(0,245,255,0.7)]" 
                : "text-[#849495] opacity-50 hover:opacity-100 hover:text-[#00FE87]"
            )}
          >
            <item.icon className="w-6 h-6" />
            <span className="font-label text-[10px] uppercase font-bold tracking-tighter mt-1">{item.label}</span>
          </button>
        ))}
      </nav>

      {/* Contextual FAB for Quick Commands */}
      <button className="fixed bottom-24 right-6 w-14 h-14 bg-[#fe00fe] rounded-full flex items-center justify-center shadow-[0_0_20px_rgba(254,0,254,0.5)] z-40 hover:scale-110 active:scale-95 transition-all text-white">
        <Plus className="w-8 h-8" />
      </button>
    </div>
  );
};
