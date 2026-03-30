import React from 'react';
import { motion } from 'motion/react';
import { LucideIcon } from 'lucide-react';
import { cn } from '@/src/lib/utils';

interface StatCardProps {
  title: string;
  value: string | number;
  icon: LucideIcon;
  subtitle?: string;
  trend?: {
    value: number;
    isUp: boolean;
  };
  progress?: number;
  color?: 'primary' | 'secondary' | 'tertiary';
  className?: string;
}

export const StatCard: React.FC<StatCardProps> = ({ 
  title, 
  value, 
  icon: Icon, 
  subtitle, 
  trend, 
  progress, 
  color = 'primary',
  className 
}) => {
  const colors = {
    primary: 'border-[#00F5FF] text-[#00F5FF] bg-[#00F5FF]/5',
    secondary: 'border-[#fe00fe] text-[#fe00fe] bg-[#fe00fe]/5',
    tertiary: 'border-[#00fe87] text-[#00fe87] bg-[#00fe87]/5',
  };

  return (
    <div className={cn(
      "bg-[#1c1f29] p-6 flex flex-col justify-between border-l-4 shadow-xl relative overflow-hidden group transition-all hover:translate-y-[-4px]",
      colors[color],
      className
    )}>
      <div className="absolute top-0 right-0 w-24 h-24 bg-current opacity-5 rounded-full -mr-12 -mt-12 blur-3xl group-hover:opacity-10 transition-opacity"></div>
      
      <div>
        <div className="flex items-center gap-2 mb-2 opacity-80">
          <Icon className="w-4 h-4" />
          <p className="font-label text-xs uppercase tracking-widest">{title}</p>
        </div>
        <h3 className="text-3xl md:text-4xl font-headline font-black tracking-tight">{value}</h3>
      </div>

      {(subtitle || trend || progress !== undefined) && (
        <div className="pt-4 border-t border-white/5 mt-4">
          {subtitle && <p className="text-[10px] opacity-50 uppercase font-technical">{subtitle}</p>}
          
          {trend && (
            <p className="text-sm font-bold mt-1">
              {trend.isUp ? '▲' : '▼'} {trend.value}%
            </p>
          )}

          {progress !== undefined && (
            <div className="w-full bg-white/5 h-1.5 mt-2 rounded-full overflow-hidden">
              <motion.div 
                initial={{ width: 0 }}
                animate={{ width: `${progress}%` }}
                className={cn("h-full bg-current shadow-[0_0_10px_rgba(0,0,0,0.5)]")}
              />
            </div>
          )}
        </div>
      )}
    </div>
  );
};
