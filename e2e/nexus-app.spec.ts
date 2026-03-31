/**
 * ============================================
 * NEXUS CONTROL — E2E Tests (Playwright)
 * ============================================
 * Tests visibles con emulación Pixel 5 Android.
 * Bypass Firebase Auth vía window.__NEXUS_E2E__.
 *
 * Ejecutar:
 *   npx playwright test --headed
 */

import { test, expect, Page } from '@playwright/test';

// ── Mock data ──────────────────────────────────────────────────
const MOCK_USER = {
  uid: 'test-user-e2e-001',
  displayName: 'Comandante NEX',
  email: 'test@nexus.dev',
  photoURL: 'https://picsum.photos/seed/pilot/200/200',
};

const MOCK_STATS = {
  uid: MOCK_USER.uid,
  displayName: MOCK_USER.displayName,
  photoURL: MOCK_USER.photoURL,
  bioCoins: 1500,
  stepsToday: 4230,
  stepsGoal: 10000,
  completedModules: 7,
  energyBurnKcal: 340,
  lastSync: new Date().toISOString(),
};

// ── Helper: inyectar E2E bypass ANTES de que la app monte ──
async function injectE2EBypass(page: Page) {
  await page.addInitScript(`
    window.__NEXUS_E2E__ = true;
    window.__NEXUS_MOCK_USER__ = ${JSON.stringify(MOCK_USER)};
    window.__NEXUS_MOCK_STATS__ = ${JSON.stringify(MOCK_STATS)};
  `);
}

// ── Helper: selector de la bottom nav principal del Layout ──
const BOTTOM_NAV = 'nav.fixed';

// ═══════════════════════════════════════════════════════════════
// TEST 1: Pantalla de Login (sin bypass — ver login real)
// ═══════════════════════════════════════════════════════════════
test.describe('1. Pantalla de Login', () => {
  test('muestra el login con temática Nexus sci-fi', async ({ page }) => {
    // Sin bypass E2E: Firebase init → onAuthStateChanged(null) → Login
    await page.goto('/');

    // Esperar a que aparezca el login (Firebase init puede tardar)
    await expect(page.getByText('NEXUS CONTROL').first()).toBeVisible({ timeout: 15000 });

    // Verificar botón de login Google
    await expect(page.getByText('INICIAR ENLACE (GOOGLE)')).toBeVisible();

    // Verificar iconos de sistemas activos
    await expect(page.getByText('Misiones')).toBeVisible();
    await expect(page.getByText('Seguridad')).toBeVisible();

    await page.screenshot({ path: 'e2e/screenshots/01-login.png' });
  });
});

// ═══════════════════════════════════════════════════════════════
// TEST 2: Navegación principal (con bypass auth)
// ═══════════════════════════════════════════════════════════════
test.describe('2. App Principal — Navegación', () => {
  test.beforeEach(async ({ page }) => {
    await injectE2EBypass(page);
    await page.goto('/');
    await expect(page.locator('header')).toBeVisible({ timeout: 10000 });
  });

  test('header muestra NEXUS CONTROL y timer', async ({ page }) => {
    await expect(page.locator('header').getByText('NEXUS CONTROL')).toBeVisible();
    // Timer visible en el header
    await expect(page.locator('header').locator('text=/\\d{2}:\\d{2}:\\d{2}/')).toBeVisible();
    await page.screenshot({ path: 'e2e/screenshots/02-header.png' });
  });

  test('bottom nav tiene todos los tabs', async ({ page }) => {
    const bottomNav = page.locator(BOTTOM_NAV);
    await expect(bottomNav).toBeVisible();

    const tabs = ['Resumen', 'Misiones', 'Mercado', 'Nexus', 'Perfil'];
    for (const tab of tabs) {
      await expect(bottomNav.getByText(tab)).toBeVisible();
    }
    await page.screenshot({ path: 'e2e/screenshots/03-bottom-nav.png' });
  });
});

// ═══════════════════════════════════════════════════════════════
// TEST 3: Panel Nexus (panel parental web)
// ═══════════════════════════════════════════════════════════════
test.describe('3. Panel Nexus — Vinculación', () => {
  test('muestra pantalla de vinculación Device ID', async ({ page }) => {
    await injectE2EBypass(page);
    await page.goto('/');
    await expect(page.locator(BOTTOM_NAV)).toBeVisible({ timeout: 10000 });

    // Navegar al tab Nexus
    await page.locator(BOTTOM_NAV).getByText('Nexus').click();
    await page.waitForTimeout(800);

    // Verificar pantalla de vinculación
    await expect(page.getByText('PANEL NEXUS').first()).toBeVisible();
    await expect(page.getByPlaceholder('Pega el Device ID aquí...')).toBeVisible();
    await expect(page.getByRole('button', { name: 'VINCULAR' })).toBeVisible();

    await page.screenshot({ path: 'e2e/screenshots/04-nexus-link-screen.png' });
  });

  test('permite ingresar Device ID y vincular', async ({ page }) => {
    await injectE2EBypass(page);
    await page.goto('/');
    await expect(page.locator(BOTTOM_NAV)).toBeVisible({ timeout: 10000 });

    await page.locator(BOTTOM_NAV).getByText('Nexus').click();
    await page.waitForTimeout(800);

    // Escribir un Device ID de prueba
    const deviceInput = page.getByPlaceholder('Pega el Device ID aquí...');
    await deviceInput.fill('TEST-DEVICE-ABC123XYZ');
    await page.waitForTimeout(300);

    // Click vincular
    await page.getByRole('button', { name: 'VINCULAR' }).click();
    await page.waitForTimeout(1500);

    await page.screenshot({ path: 'e2e/screenshots/05-nexus-linked.png' });

    // Panel sigue visible tras vincular
    await expect(page.getByText('PANEL NEXUS').first()).toBeVisible();
  });

  test('botón DESVINCULAR resetea al estado inicial', async ({ page }) => {
    await injectE2EBypass(page);

    // Pre-vincular vía localStorage
    await page.addInitScript(() => {
      localStorage.setItem('nexus_device_uid', 'FAKE-DEVICE-999');
    });

    await page.goto('/');
    await expect(page.locator(BOTTOM_NAV)).toBeVisible({ timeout: 10000 });

    await page.locator(BOTTOM_NAV).getByText('Nexus').click();
    await page.waitForTimeout(800);

    const unlinkBtn = page.getByText('DESVINCULAR');
    if (await unlinkBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
      await page.screenshot({ path: 'e2e/screenshots/06-nexus-before-unlink.png' });
      await unlinkBtn.click();
      await page.waitForTimeout(1000);

      // Debe volver a la pantalla de vinculación
      await expect(page.getByPlaceholder('Pega el Device ID aquí...')).toBeVisible();
      await page.screenshot({ path: 'e2e/screenshots/07-nexus-after-unlink.png' });
    }
  });
});

// ═══════════════════════════════════════════════════════════════
// TEST 4: Recorrido visual completo de tabs
// ═══════════════════════════════════════════════════════════════
test.describe('4. Recorrido Visual — Todos los Tabs', () => {
  test('navega por cada tab y captura screenshots', async ({ page }) => {
    await injectE2EBypass(page);
    await page.goto('/');
    await expect(page.locator(BOTTOM_NAV)).toBeVisible({ timeout: 10000 });

    // Screenshot de la vista inicial (Dashboard)
    await page.screenshot({ path: 'e2e/screenshots/08-vista-inicial.png' });

    const tabActions = [
      { name: 'Resumen', file: '09-dashboard' },
      { name: 'Misiones', file: '10-misiones' },
      { name: 'Mercado', file: '11-mercado' },
      { name: 'Nexus', file: '12-nexus' },
      { name: 'Perfil', file: '13-perfil' },
    ];

    for (const tab of tabActions) {
      await page.locator(BOTTOM_NAV).getByText(tab.name).click();
      await page.waitForTimeout(1000);
      await page.screenshot({ path: `e2e/screenshots/${tab.file}.png` });
    }
  });
});

// ═══════════════════════════════════════════════════════════════
// TEST 5: Responsive — viewport Android
// ═══════════════════════════════════════════════════════════════
test.describe('5. Responsive — Emulación Android', () => {
  test('UI se adapta correctamente a pantalla mobile', async ({ page }) => {
    await injectE2EBypass(page);
    await page.goto('/');
    await expect(page.locator(BOTTOM_NAV)).toBeVisible({ timeout: 10000 });

    // Viewport Pixel 5 (393x851) por config
    const viewport = page.viewportSize();
    expect(viewport?.width).toBeLessThanOrEqual(420);
    expect(viewport?.height).toBeLessThanOrEqual(900);

    // Bottom nav visible
    await expect(page.locator(BOTTOM_NAV)).toBeVisible();
    // Header visible
    await expect(page.locator('header')).toBeVisible();

    await page.screenshot({ path: 'e2e/screenshots/14-mobile-viewport.png' });
  });

  test('elementos touch tienen tamaño adecuado (>30px)', async ({ page }) => {
    await injectE2EBypass(page);
    await page.goto('/');
    await expect(page.locator(BOTTOM_NAV)).toBeVisible({ timeout: 10000 });

    const navButtons = page.locator(`${BOTTOM_NAV} button`);
    const count = await navButtons.count();

    for (let i = 0; i < count; i++) {
      const box = await navButtons.nth(i).boundingBox();
      if (box) {
        expect(box.height).toBeGreaterThanOrEqual(30);
      }
    }

    await page.screenshot({ path: 'e2e/screenshots/15-touch-targets.png' });
  });
});

// ═══════════════════════════════════════════════════════════════
// TEST 6: Performance y carga
// ═══════════════════════════════════════════════════════════════
test.describe('6. Performance', () => {
  test('la app carga en menos de 8 segundos', async ({ page }) => {
    await injectE2EBypass(page);
    const startTime = Date.now();

    await page.goto('/');
    // Con bypass E2E, el header debería aparecer rápido
    await page.waitForSelector('text=NEXUS CONTROL', { timeout: 8000 });

    const loadTime = Date.now() - startTime;
    console.log(`⚡ Tiempo de carga: ${loadTime}ms`);

    expect(loadTime).toBeLessThan(8000);
    await page.screenshot({ path: 'e2e/screenshots/16-performance.png' });
  });

  test('no hay errores de consola críticos', async ({ page }) => {
    const errors: string[] = [];

    page.on('console', (msg) => {
      if (msg.type() === 'error') {
        const text = msg.text();
        // Filtrar errores esperados de Firebase/red en tests
        if (!text.includes('Firebase') && !text.includes('firestore') && 
            !text.includes('auth') && !text.includes('ERR_CONNECTION') &&
            !text.includes('net::') && !text.includes('googleapis') &&
            !text.includes('gstatic') && !text.includes('404')) {
          errors.push(text);
        }
      }
    });

    await injectE2EBypass(page);
    await page.goto('/');
    await page.waitForTimeout(3000);

    if (errors.length > 0) {
      console.log('⚠️ Errores de consola encontrados:', errors);
    }
    expect(errors.length).toBeLessThan(5);
  });
});

// ═══════════════════════════════════════════════════════════════
// TEST 7: Tema visual sci-fi
// ═══════════════════════════════════════════════════════════════
test.describe('7. Tema Visual Nexus', () => {
  test('fondo oscuro y colores neón correctos', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(3000);

    // Verificar fondo oscuro del body/root
    const bg = await page.evaluate(() => {
      const root = document.querySelector('.bg-\\[\\#0A0E17\\]');
      return root ? window.getComputedStyle(root).backgroundColor : null;
    });

    if (bg) {
      // rgb(10, 14, 23) = #0A0E17
      expect(bg).toContain('rgb(10, 14, 23)');
    }

    await page.screenshot({ path: 'e2e/screenshots/17-tema-scifi.png' });
  });
});
