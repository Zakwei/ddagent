// UI test via CDP for ddagent desktop on remote Windows host.
// Usage: node scripts/desktop-ui-test.mjs <phase>
import { chromium } from 'playwright';
import fs from 'node:fs';

const OUT = '/tmp/ddagent-ui';
fs.mkdirSync(OUT, { recursive: true });
const sleep = (ms) => new Promise(r => setTimeout(r, ms));
// Remote-phase target — point at your server with DDAGENT_TEST_REMOTE_URL.
const REMOTE_URL = process.env.DDAGENT_TEST_REMOTE_URL ?? 'http://127.0.0.1:3001';

async function conn() {
  const b = await chromium.connectOverCDP('http://localhost:9223');
  const pages = b.contexts().flatMap(c => c.pages());
  return { b, pages };
}
const launcherOf = (ps) => ps.find(p => p.url().startsWith('file:///'));
const contentOf = (ps) => ps.find(p => !p.url().startsWith('file:///'));

// WebContentsView targets report a zero-size CDP viewport — page.screenshot and
// locator.click() both fail there. Screenshots go through the
// ddagent-desktop:capture-active-view IPC (webContents.capturePage in main);
// clicks via el.click() inside evaluate.
async function snap(page, name, launcher) {
  if (launcher) {
    const b64 = await launcher.evaluate(() => window.ddagentDesktop.captureActiveView()).catch(() => null);
    if (b64) fs.writeFileSync(`${OUT}/${name}.png`, Buffer.from(b64, 'base64'));
    else console.log('shot: captureActiveView returned null (no active view?)');
  } else {
    await page.screenshot({ path: `${OUT}/${name}.png` }).catch(e => console.log('shot fail', name, e.message));
  }
  const dom = await page.evaluate(() => {
    const els = [...document.querySelectorAll('button, a, input, h1, h2, h3, [role="button"], nav li')]
      .slice(0, 60).map(e => `${e.tagName.toLowerCase()}${e.id ? '#' + e.id : ''}.${[...e.classList].slice(0,3).join('.')} :: "${(e.textContent || '').trim().slice(0, 50)}"`);
    return { title: document.title, url: location.href, count: document.querySelectorAll('*').length, els };
  });
  console.log(`--- ${name}: ${dom.url} "${dom.title}" nodes=${dom.count}`);
  dom.els.forEach(e => console.log('  ', e));
  return dom;
}

const phase = process.argv[2] || 'all';

if (phase === 'inspect' || phase === 'all') {
  const { b, pages } = await conn();
  const content = contentOf(pages);
  if (content) await snap(content, '01-remote-view', launcherOf(pages));
  else console.log('NO content page (launcher only)');
  const launcher = launcherOf(pages);
  if (launcher) await snap(launcher, '02-launcher');
  await b.close();
}

if (phase === 'disconnect' || phase === 'all') {
  const { b, pages } = await conn();
  const launcher = launcherOf(pages);
  // disconnect via desktop API
  const res = await launcher.evaluate(() => window.ddagentDesktop?.disconnect?.().then?.(r => JSON.stringify(r)).catch?.(e => 'ERR:' + e.message) ?? 'no-disconnect');
  console.log('disconnect:', res);
  await sleep(2500);
  const { pages: p2 } = await conn().catch(() => ({ pages }));
  const l2 = launcherOf(p2.length ? p2 : pages);
  const dom = await l2.evaluate(() => document.body.innerText.slice(0, 400));
  console.log('after-disconnect body:', dom.replace(/\n+/g, ' | '));
  await snap(l2, '03-after-disconnect');
  await b.close();
}

if (phase === 'local' || phase === 'all') {
  const { b, pages } = await conn();
  let launcher = launcherOf(pages);
  const r = await launcher.evaluate(() => window.ddagentDesktop.openLocal().then(x => JSON.stringify(x)));
  console.log('openLocal:', r);
  for (let i = 0; i < 40; i++) {
    await sleep(1000);
    const st = await launcher.evaluate(() => window.ddagentDesktop.getState().then(s => `${s.localStatus} ${s.target} ${s.url || ''}`));
    if (i % 5 === 0 || /ready/.test(st)) console.log('state:', st);
    if (/ready/.test(st)) break;
  }
  await sleep(4000);
  const { pages: p3 } = await conn().catch(() => ({ pages }));
  const content = contentOf(p3.length ? p3 : pages);
  if (content) {
    console.log('LOCAL content url:', content.url());
    const health = await content.evaluate(() => fetch('/api/health').then(r => r.status).catch(e => 'ERR:' + e.message));
    console.log('local /api/health:', health);
    await snap(content, '04-local-view', launcherOf(p3.length ? p3 : pages));
  } else console.log('NO local content page');
  await b.close();
}

if (phase === 'remote' || phase === 'all') {
  const { b, pages } = await conn();
  const launcher = launcherOf(pages);
  // get saved servers and reconnect
  const servers = await launcher.evaluate(() => window.ddagentDesktop.getState().then(s => JSON.stringify({ target: s.target, servers: s.servers })));
  console.log('state:', servers);
  const r = await launcher.evaluate((url) => window.ddagentDesktop.openRemote(url).then(x => JSON.stringify(x)).catch(e => 'ERR:' + e.message), REMOTE_URL);
  console.log('openRemote:', r);
  await sleep(5000);
  const { pages: p4 } = await conn().catch(() => ({ pages }));
  const content = contentOf(p4.length ? p4 : pages);
  if (content) await snap(content, '05-remote-reconnect', launcherOf(p4.length ? p4 : pages));
  await b.close();
}
