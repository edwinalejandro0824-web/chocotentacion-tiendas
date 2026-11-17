// Service worker: guarda la página para que abra rápido y se pueda instalar.
// Las ventas y los datos SIEMPRE van a la base de datos (no se guardan aquí).
const CACHE = 'choco-v31';
const BASE = ['./', './index.html', './manifest.webmanifest', './icono-192.png', './icono-512.png'];
self.addEventListener('install', e => { e.waitUntil(caches.open(CACHE).then(c => c.addAll(BASE)).then(() => self.skipWaiting())); });
self.addEventListener('activate', e => { e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim())); });
self.addEventListener('fetch', e => {
  const url = new URL(e.request.url);
  if (e.request.method !== 'GET' || url.hostname.endsWith('supabase.co')) return;   // datos: siempre en vivo
  if (e.request.mode === 'navigate' || url.pathname.endsWith('/index.html')) {
    // la página: primero internet (para tener siempre la última versión), si no hay, la guardada
    e.respondWith(fetch(e.request).then(r => { const c = r.clone(); caches.open(CACHE).then(x => x.put('./index.html', c)); return r; })
      .catch(() => caches.match('./index.html')));
    return;
  }
  // librerías, letras e íconos: lo guardado, y se actualiza por detrás
  e.respondWith(caches.match(e.request).then(guardado => {
    const red = fetch(e.request).then(r => { if (r.ok || r.type === 'opaque') { const c = r.clone(); caches.open(CACHE).then(x => x.put(e.request, c)); } return r; }).catch(() => guardado);
    return guardado || red;
  }));
});
