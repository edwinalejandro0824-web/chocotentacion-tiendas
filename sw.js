// Service worker: guarda la página para que abra rápido y se pueda instalar.
// Las ventas y los datos SIEMPRE van a la base de datos (no se guardan aquí).
const CACHE = 'choco-v87';
const BASE = ['./', './index.html', './admin.html', './manifest.webmanifest', './manifest-admin.webmanifest', './icono-caja-192.png', './icono-caja-512.png', './icono-admin-192.png', './icono-admin-512.png'];
self.addEventListener('install', e => { e.waitUntil(caches.open(CACHE).then(c => c.addAll(BASE)).then(() => self.skipWaiting())); });
self.addEventListener('activate', e => { e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim())); });
self.addEventListener('fetch', e => {
  const url = new URL(e.request.url);
  if (e.request.method !== 'GET' || url.hostname.endsWith('supabase.co')) return;   // datos: siempre en vivo
  if (e.request.mode === 'navigate' && !/\/(index\.html|admin\.html)?$/.test(url.pathname)) return;   // otras páginas (empleo.html, instalar.html): directo de internet
  if (e.request.mode === 'navigate' || /\/(index|admin)\.html$/.test(url.pathname)) {
    // la página (Caja o Administración): primero internet (siempre la última versión), si no hay, la guardada
    const pag = url.pathname.endsWith('/admin.html') ? './admin.html' : './index.html';
    e.respondWith(fetch(e.request).then(r => { const c = r.clone(); caches.open(CACHE).then(x => x.put(pag, c)); return r; })
      .catch(() => caches.match(pag)));
    return;
  }
  // librerías, letras e íconos: lo guardado, y se actualiza por detrás
  e.respondWith(caches.match(e.request).then(guardado => {
    const red = fetch(e.request).then(r => { if (r.ok || r.type === 'opaque') { const c = r.clone(); caches.open(CACHE).then(x => x.put(e.request, c)); } return r; }).catch(() => guardado);
    return guardado || red;
  }));
});
