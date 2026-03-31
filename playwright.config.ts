import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: false,
  retries: 0,
  workers: 1,
  timeout: 60_000,

  reporter: [['list']],

  use: {
    baseURL: 'http://localhost:3000',
    // Emular Pixel 5 Android
    ...devices['Pixel 5'],
    // Modo headed visible + slow-mo para supervisión
    headless: false,
    launchOptions: {
      slowMo: 600,
    },
    // Screenshots y video para replay
    screenshot: 'on',
    video: 'on',
    trace: 'on',
  },

  projects: [
    {
      name: 'Nexus Mobile (Pixel 5)',
      use: {
        ...devices['Pixel 5'],
      },
    },
  ],

  // Levantar dev server automáticamente
  webServer: {
    command: 'npx vite --port=3000 --host=0.0.0.0',
    port: 3000,
    timeout: 30_000,
    reuseExistingServer: true,
  },
});
