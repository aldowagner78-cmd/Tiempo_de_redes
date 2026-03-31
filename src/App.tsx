import React, { useEffect, useState } from 'react';
import { Layout } from '@/src/components/Layout';
import { Dashboard } from '@/src/pages/Dashboard';
import { Modules } from '@/src/pages/Modules';
import { MathReactor } from '@/src/pages/MathReactor';
import { Arena } from '@/src/pages/Arena';
import { Chat } from '@/src/pages/Chat';
import { Profile } from '@/src/pages/Profile';
import { Login } from '@/src/pages/Login';
import { NexusParentPanel } from '@/src/pages/NexusParentPanel';
import { UserStats } from '@/src/types';
import { auth, db, googleProvider, handleFirestoreError, OperationType } from '@/src/lib/firebase';
import { onAuthStateChanged, signInWithPopup, signOut } from 'firebase/auth';
import { doc, onSnapshot, setDoc } from 'firebase/firestore';

export default function App() {
  const [activeTab, setActiveTab] = useState('dashboard');
  const [activeModule, setActiveModule] = useState<string | null>(null);
  const [user, setUser] = useState<any>(null);
  const [isAuthReady, setIsAuthReady] = useState(false);
  const [stats, setStats] = useState<UserStats | null>(null);

  useEffect(() => {
    // E2E testing bypass — skip Firebase auth entirely
    if ((window as any).__NEXUS_E2E__) {
      setUser((window as any).__NEXUS_MOCK_USER__ ?? null);
      setStats((window as any).__NEXUS_MOCK_STATS__ ?? null);
      setIsAuthReady(true);
      return;
    }
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);
      setIsAuthReady(true);
    });
    return () => unsubscribe();
  }, []);

  useEffect(() => {
    if ((window as any).__NEXUS_E2E__) return;
    if (!user) {
      setStats(null);
      return;
    }

    const statsRef = doc(db, 'users', user.uid);
    const unsubscribe = onSnapshot(statsRef, (snapshot) => {
      if (snapshot.exists()) {
        setStats(snapshot.data() as UserStats);
      } else {
        // Initialize stats for new user
        const initialStats: UserStats = {
          uid: user.uid,
          displayName: user.displayName || 'Comandante NEX',
          photoURL: user.photoURL || 'https://picsum.photos/seed/pilot/200/200',
          bioCoins: 1000,
          stepsToday: 0,
          stepsGoal: 10000,
          completedModules: 0,
          energyBurnKcal: 0,
          lastSync: new Date().toISOString()
        };
        setDoc(statsRef, initialStats).catch(err => handleFirestoreError(err, OperationType.WRITE, `users/${user.uid}`));
      }
    }, (error) => {
      handleFirestoreError(error, OperationType.GET, `users/${user.uid}`);
    });

    return () => unsubscribe();
  }, [user]);

  const handleLogin = async () => {
    try {
      await signInWithPopup(auth, googleProvider);
    } catch (error) {
      console.error('Login error:', error);
    }
  };

  const handleLogout = async () => {
    try {
      await signOut(auth);
      setActiveTab('dashboard');
      setActiveModule(null);
    } catch (error) {
      console.error('Logout error:', error);
    }
  };

  const handleModuleSuccess = async (reward: number) => {
    if (!user || !stats) return;

    const statsRef = doc(db, 'users', user.uid);
    try {
      await setDoc(statsRef, {
        ...stats,
        bioCoins: stats.bioCoins + reward,
        completedModules: stats.completedModules + 1,
        lastSync: new Date().toISOString()
      });
    } catch (error) {
      handleFirestoreError(error, OperationType.WRITE, `users/${user.uid}`);
    }
  };

  if (!isAuthReady) {
    return (
      <div className="min-h-screen bg-[#0A0E17] flex items-center justify-center">
        <div className="text-[#00F5FF] font-mono animate-pulse">INICIALIZANDO NEXUS...</div>
      </div>
    );
  }

  if (!user) {
    return <Login onLogin={handleLogin} />;
  }

  if (!stats) {
    return (
      <div className="min-h-screen bg-[#0A0E17] flex items-center justify-center">
        <div className="text-[#00F5FF] font-mono animate-pulse">CARGANDO BIOMETRÍA...</div>
      </div>
    );
  }

  const renderContent = () => {
    if (activeModule === 'math') {
      return <MathReactor onBack={() => setActiveModule(null)} onSuccess={handleModuleSuccess} />;
    }
    if (activeModule === 'arena') {
      return <Arena onBack={() => setActiveModule(null)} onSuccess={handleModuleSuccess} />;
    }

    switch (activeTab) {
      case 'dashboard':
        return <Dashboard stats={stats} />;
      case 'missions':
        return <Modules onSelectModule={setActiveModule} />;
      case 'vault':
        return <Chat />;
      case 'nexus':
        return <NexusParentPanel />;
      case 'profile':
        return <Profile user={user} stats={stats} onLogout={handleLogout} />;
      default:
        return <Dashboard stats={stats} />;
    }
  };

  return (
    <Layout 
      activeTab={activeTab} 
      setActiveTab={setActiveTab}
      userPhoto={user.photoURL}
      userName={user.displayName}
    >
      {renderContent()}
    </Layout>
  );
}
