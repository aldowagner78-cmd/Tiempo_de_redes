import React from 'react';
import { AlertTriangle, RefreshCw } from 'lucide-react';

interface ErrorBoundaryProps {
  children: React.ReactNode;
}

interface ErrorBoundaryState {
  hasError: boolean;
  error: any;
}

export class ErrorBoundary extends React.Component<ErrorBoundaryProps, ErrorBoundaryState> {
  constructor(props: ErrorBoundaryProps) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: any) {
    return { hasError: true, error };
  }

  componentDidCatch(error: any, errorInfo: any) {
    console.error("ErrorBoundary caught an error", error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      let errorMessage = "Ha ocurrido un error inesperado en el sistema NEXUS.";
      
      try {
        const parsedError = JSON.parse(this.state.error.message);
        if (parsedError.error && parsedError.error.includes("insufficient permissions")) {
          errorMessage = "Error de seguridad: Permisos insuficientes para realizar esta operación. Contacte al administrador.";
        }
      } catch (e) {
        // Not a JSON error
      }

      return (
        <div className="min-h-screen bg-[#0A0E17] flex flex-col items-center justify-center p-6 text-center">
          <div className="w-20 h-20 rounded-full bg-[#ffb4ab]/10 flex items-center justify-center border border-[#ffb4ab]/30 mb-6">
            <AlertTriangle className="w-10 h-10 text-[#ffb4ab]" />
          </div>
          <h2 className="text-2xl font-headline font-black text-white uppercase mb-4 tracking-widest">Fallo Crítico del Sistema</h2>
          <p className="text-[#849495] font-technical uppercase tracking-widest max-w-md mb-8">
            {errorMessage}
          </p>
          <button 
            onClick={() => window.location.reload()}
            className="bg-[#00F5FF] text-[#003739] px-8 py-3 font-headline font-bold tracking-widest hover:brightness-110 transition-all flex items-center gap-2"
            style={{ clipPath: 'polygon(10% 0, 100% 0, 100% 70%, 90% 100%, 0 100%, 0 30%)' }}
          >
            <RefreshCw className="w-4 h-4" />
            REINICIAR ENLACE
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}
