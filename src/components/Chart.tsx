import React from 'react';
import { 
  AreaChart, 
  Area, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  LineChart,
  Line
} from 'recharts';

interface ChartProps {
  data: any[];
  type?: 'area' | 'line';
  color?: string;
  height?: number;
}

export const Chart: React.FC<ChartProps> = ({ data, type = 'area', color = '#00F5FF', height = 250 }) => {
  return (
    <div style={{ width: '100%', height }}>
      <ResponsiveContainer>
        {type === 'area' ? (
          <AreaChart data={data}>
            <defs>
              <linearGradient id="colorUv" x1="0" y1="0" x2="0" y2="1">
                <stop offset="5%" stopColor={color} stopOpacity={0.3}/>
                <stop offset="95%" stopColor={color} stopOpacity={0}/>
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" stroke="#ffffff10" vertical={false} />
            <XAxis 
              dataKey="name" 
              stroke="#849495" 
              fontSize={10} 
              tickLine={false} 
              axisLine={false}
              tick={{ fill: '#849495' }}
            />
            <Tooltip 
              contentStyle={{ 
                backgroundColor: '#1c1f29', 
                border: '1px solid #00F5FF30',
                borderRadius: '4px',
                fontSize: '12px'
              }}
              itemStyle={{ color: '#00F5FF' }}
            />
            <Area 
              type="monotone" 
              dataKey="value" 
              stroke={color} 
              fillOpacity={1} 
              fill="url(#colorUv)" 
              strokeWidth={3}
            />
          </AreaChart>
        ) : (
          <LineChart data={data}>
            <CartesianGrid strokeDasharray="3 3" stroke="#ffffff10" vertical={false} />
            <XAxis 
              dataKey="name" 
              stroke="#849495" 
              fontSize={10} 
              tickLine={false} 
              axisLine={false}
            />
            <Tooltip 
              contentStyle={{ 
                backgroundColor: '#1c1f29', 
                border: '1px solid #00F5FF30',
                borderRadius: '4px'
              }}
            />
            <Line 
              type="monotone" 
              dataKey="value" 
              stroke={color} 
              strokeWidth={3} 
              dot={{ r: 4, fill: color, strokeWidth: 0 }}
              activeDot={{ r: 6, strokeWidth: 0 }}
            />
          </LineChart>
        )}
      </ResponsiveContainer>
    </div>
  );
};
