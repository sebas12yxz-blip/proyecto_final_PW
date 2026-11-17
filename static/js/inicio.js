// Animaciones al hacer scroll
AOS.init({ duration: 650, once: true, offset: 50 });

// VIDEO DEL HERO
const slides = document.querySelectorAll('.v-slide');
let cur = 0;
let busy = false;

function nextVideo() {
  if (busy || slides.length === 0) return;
  busy = true;
  const outgoing = slides[cur];
  cur = (cur + 1) % slides.length;
  const incoming = slides[cur];
  incoming.play().catch(() => { });
  incoming.classList.add('v-entering');
  setTimeout(() => {
    outgoing.classList.remove('v-active');
    outgoing.pause();
    outgoing.currentTime = 0;
    incoming.classList.remove('v-entering');
    incoming.classList.add('v-active');
    busy = false;
  }, 2400);
}
setInterval(nextVideo, 10000);

// CARRUSEL DE MOTOS
let isMoving = false;
let autoPlayInterval;
const motoTrack = document.getElementById('motoTrack');

function startAutoPlay() {
  stopAutoPlay();
  autoPlayInterval = setInterval(() => {
    if (!isMoving) moveMoto(1);
  }, 2500);
}

function stopAutoPlay() {
  if (autoPlayInterval) clearInterval(autoPlayInterval);
}

function moveMoto(dir, manual = false) {
  if (isMoving || !motoTrack) return;
  isMoving = true;
  if (manual) startAutoPlay();

  const slideWidth = window.innerWidth >= 768 ? 48 : 100;
  const offset = (100 - slideWidth) / 2;

  if (dir === 1) {
    motoTrack.style.transition = 'transform 0.5s cubic-bezier(0.25, 1, 0.5, 1)';
    motoTrack.style.transform = `translateX(${offset - (slideWidth * 2)}%)`;
    const items = Array.from(motoTrack.children);
    items[1].classList.remove('active');
    items[2].classList.add('active');
    setTimeout(() => {
      motoTrack.style.transition = 'none';
      motoTrack.appendChild(motoTrack.firstElementChild);
      motoTrack.style.transform = `translateX(${offset - slideWidth}%)`;
      setTimeout(() => { isMoving = false; }, 50);
    }, 500);
  } else {
    motoTrack.style.transition = 'none';
    motoTrack.prepend(motoTrack.lastElementChild);
    motoTrack.style.transform = `translateX(${offset - (slideWidth * 2)}%)`;
    void motoTrack.offsetWidth;
    motoTrack.style.transition = 'transform 0.5s cubic-bezier(0.25, 1, 0.5, 1)';
    motoTrack.style.transform = `translateX(${offset - slideWidth}%)`;
    const items = Array.from(motoTrack.children);
    items[2].classList.remove('active');
    items[1].classList.add('active');
    setTimeout(() => { isMoving = false; }, 500);
  }
}

function initMotoCarousel() {
  if (!motoTrack) return;
  const slideWidth = window.innerWidth >= 768 ? 48 : 100;
  const offset = (100 - slideWidth) / 2;
  if (!motoTrack.hasAttribute('data-initialized')) {
    motoTrack.prepend(motoTrack.lastElementChild);
    motoTrack.setAttribute('data-initialized', 'true');
    startAutoPlay();
  }
  motoTrack.style.transition = 'none';
  motoTrack.style.transform = `translateX(${offset - slideWidth}%)`;
  Array.from(motoTrack.children).forEach((s, i) => {
    s.classList.toggle('active', i === 1);
  });
}

initMotoCarousel();
window.addEventListener('resize', () => {
  if (!isMoving) initMotoCarousel();
});

// MAPA DE SEDES
const locations = {
  'NeivaPrincipal': 'Calle 4 #6-44, Neiva, Huila, Colombia',
  'NeivaVenta': 'Carrera 5 #13-90, Neiva, Huila, Colombia',
  'LaPlata': 'Calle 5A #1-09, La Plata, Huila, Colombia',
  'Campoalegre': 'Carrera 9 #20-50, Campoalegre, Huila, Colombia'
};

function changeMap(sedeKey, btnElement) {
  document.querySelectorAll('.map-btn').forEach(b => b.classList.remove('active'));
  btnElement.classList.add('active');
  const query = encodeURIComponent(locations[sedeKey]);
  document.getElementById('mapFrame').src = `https://maps.google.com/maps?q=${query}&z=16&output=embed`;
}