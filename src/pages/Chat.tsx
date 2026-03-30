import React from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  Send, 
  Bot, 
  User, 
  Terminal, 
  Sparkles, 
  Image as ImageIcon, 
  Mic,
  Loader2,
  XCircle as X
} from 'lucide-react';
import ReactMarkdown from 'react-markdown';
import { generateChatResponse, analyzeImage } from '@/src/lib/gemini';
import { cn } from '@/src/lib/utils';

interface Message {
  role: 'user' | 'model';
  text: string;
  image?: string;
}

export const Chat: React.FC = () => {
  const [messages, setMessages] = React.useState<Message[]>([]);
  const [input, setInput] = React.useState('');
  const [isLoading, setIsLoading] = React.useState(false);
  const [selectedImage, setSelectedImage] = React.useState<string | null>(null);
  const scrollRef = React.useRef<HTMLDivElement>(null);

  React.useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [messages]);

  const handleSend = async () => {
    if (!input.trim() && !selectedImage) return;

    const userMessage: Message = { 
      role: 'user', 
      text: input, 
      image: selectedImage || undefined 
    };
    
    setMessages(prev => [...prev, userMessage]);
    setInput('');
    setIsLoading(true);

    try {
      let responseText = '';
      if (selectedImage) {
        const base64 = selectedImage.split(',')[1];
        responseText = await analyzeImage(base64, input || "Analiza esta imagen");
      } else {
        const history = messages.map(m => ({
          role: m.role,
          parts: [{ text: m.text }]
        }));
        responseText = await generateChatResponse(history, input);
      }

      setMessages(prev => [...prev, { role: 'model', text: responseText }]);
    } catch (error) {
      console.error(error);
      setMessages(prev => [...prev, { role: 'model', text: "Error en la conexión con NEXUS. Reintentando..." }]);
    } finally {
      setIsLoading(false);
      setSelectedImage(null);
    }
  };

  const handleImageUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setSelectedImage(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  return (
    <div className="max-w-4xl mx-auto h-[calc(100vh-12rem)] flex flex-col bg-[#1c1f29]/50 border border-[#3a494a]/20 rounded-sm overflow-hidden">
      {/* Chat Header */}
      <div className="p-4 border-b border-[#3a494a]/20 bg-[#0A0E17]/50 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-[#00F5FF]/10 flex items-center justify-center border border-[#00F5FF]/30">
            <Bot className="text-[#00F5FF] w-6 h-6" />
          </div>
          <div>
            <h3 className="font-headline text-sm font-bold text-white tracking-widest uppercase">NEXUS AI</h3>
            <div className="flex items-center gap-1.5">
              <div className="w-1.5 h-1.5 rounded-full bg-[#00fe87] animate-pulse"></div>
              <span className="text-[10px] text-[#00fe87] font-technical uppercase">Online</span>
            </div>
          </div>
        </div>
        <Terminal className="text-[#849495] w-5 h-5" />
      </div>

      {/* Messages Area */}
      <div 
        ref={scrollRef}
        className="flex-1 overflow-y-auto p-6 space-y-6 scrollbar-thin scrollbar-thumb-[#3a494a] scrollbar-track-transparent"
      >
        {messages.length === 0 && (
          <div className="h-full flex flex-col items-center justify-center text-center space-y-4 opacity-50">
            <Sparkles className="w-12 h-12 text-[#00F5FF]" />
            <p className="font-technical text-sm uppercase tracking-widest max-w-xs">
              Estableciendo enlace neuronal... Esperando instrucciones del comandante.
            </p>
          </div>
        )}
        
        <AnimatePresence>
          {messages.map((msg, i) => (
            <motion.div
              key={i}
              initial={{ opacity: 0, x: msg.role === 'user' ? 20 : -20 }}
              animate={{ opacity: 1, x: 0 }}
              className={cn(
                "flex gap-4",
                msg.role === 'user' ? "flex-row-reverse" : "flex-row"
              )}
            >
              <div className={cn(
                "w-8 h-8 rounded-full flex items-center justify-center border shrink-0",
                msg.role === 'user' ? "bg-[#fe00fe]/10 border-[#fe00fe]/30" : "bg-[#00F5FF]/10 border-[#00F5FF]/30"
              )}>
                {msg.role === 'user' ? <User className="w-4 h-4 text-[#fe00fe]" /> : <Bot className="w-4 h-4 text-[#00F5FF]" />}
              </div>
              <div className={cn(
                "max-w-[80%] space-y-2",
                msg.role === 'user' ? "items-end" : "items-start"
              )}>
                {msg.image && (
                  <img src={msg.image} alt="Upload" className="max-w-full rounded-sm border border-white/10" />
                )}
                <div className={cn(
                  "p-4 rounded-sm text-sm font-body leading-relaxed",
                  msg.role === 'user' ? "bg-[#fe00fe]/10 border border-[#fe00fe]/20 text-white" : "bg-[#181b25] border border-[#00F5FF]/20 text-[#dfe2ef]"
                )}>
                  <div className="markdown-body prose prose-invert prose-sm max-w-none">
                    <ReactMarkdown>{msg.text}</ReactMarkdown>
                  </div>
                </div>
              </div>
            </motion.div>
          ))}
        </AnimatePresence>
        
        {isLoading && (
          <div className="flex gap-4">
            <div className="w-8 h-8 rounded-full bg-[#00F5FF]/10 border border-[#00F5FF]/30 flex items-center justify-center">
              <Loader2 className="w-4 h-4 text-[#00F5FF] animate-spin" />
            </div>
            <div className="bg-[#181b25] border border-[#00F5FF]/20 p-4 rounded-sm">
              <div className="flex gap-1">
                <motion.div animate={{ opacity: [0, 1, 0] }} transition={{ repeat: Infinity, duration: 1 }} className="w-1.5 h-1.5 bg-[#00F5FF] rounded-full" />
                <motion.div animate={{ opacity: [0, 1, 0] }} transition={{ repeat: Infinity, duration: 1, delay: 0.2 }} className="w-1.5 h-1.5 bg-[#00F5FF] rounded-full" />
                <motion.div animate={{ opacity: [0, 1, 0] }} transition={{ repeat: Infinity, duration: 1, delay: 0.4 }} className="w-1.5 h-1.5 bg-[#00F5FF] rounded-full" />
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Input Area */}
      <div className="p-4 bg-[#0A0E17]/80 border-t border-[#3a494a]/20">
        {selectedImage && (
          <div className="mb-4 relative inline-block">
            <img src={selectedImage} alt="Preview" className="h-20 w-20 object-cover rounded-sm border border-[#00F5FF]" />
            <button 
              onClick={() => setSelectedImage(null)}
              className="absolute -top-2 -right-2 bg-red-500 rounded-full p-1 text-white"
            >
              <X className="w-3 h-3" />
            </button>
          </div>
        )}
        <div className="flex gap-2">
          <label className="p-3 bg-[#1c1f29] border border-[#3a494a]/30 text-[#849495] hover:text-[#00F5FF] hover:border-[#00F5FF]/50 transition-all cursor-pointer">
            <ImageIcon className="w-5 h-5" />
            <input type="file" accept="image/*" className="hidden" onChange={handleImageUpload} />
          </label>
          <button className="p-3 bg-[#1c1f29] border border-[#3a494a]/30 text-[#849495] hover:text-[#00fe87] hover:border-[#00fe87]/50 transition-all">
            <Mic className="w-5 h-5" />
          </button>
          <input 
            type="text" 
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleSend()}
            placeholder="Ingrese comando..."
            className="flex-1 bg-[#0A0E17] border border-[#3a494a]/30 px-4 py-2 text-sm font-technical uppercase tracking-widest focus:outline-none focus:border-[#00F5FF]/50 text-white"
          />
          <button 
            onClick={handleSend}
            disabled={isLoading}
            className="bg-[#00F5FF] text-[#003739] px-6 py-2 font-headline text-xs font-bold tracking-widest hover:brightness-110 transition-all disabled:opacity-50"
          >
            <Send className="w-4 h-4" />
          </button>
        </div>
      </div>
    </div>
  );
};
