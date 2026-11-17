// NAVBAR: sombra al hacer scroll, botón "subir" y sección activa
window.addEventListener('scroll', () => {
  document.getElementById('nav').classList.toggle('stuck', window.scrollY > 40);
  document.getElementById('upBtn').classList.toggle('show', window.scrollY > 400);
  marcarSeccionActiva();
});

function marcarSeccionActiva() {
  // Solo aplica en la página de inicio (la única que tiene la sección #inicio)
  if (!document.getElementById('inicio')) return;

  let current = '';
  document.querySelectorAll('section, footer').forEach(sec => {
    if (window.scrollY >= sec.offsetTop - 180) {
      current = sec.getAttribute('id');
    }
  });
  if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 50) {
    current = 'contacto';
  }

  document.querySelectorAll('.links > a').forEach(link => {
    link.classList.remove('nav-active');
    if (current && link.getAttribute('href').endsWith('#' + current)) {
      link.classList.add('nav-active');
    }
  });
}

window.dispatchEvent(new Event('scroll'));

// MENÚ EN CELULAR
function toggleNav() {
  document.getElementById('links').classList.toggle('open');
  document.querySelector('.hbg').classList.toggle('active');
}

// ASISTENTE MOTOSPORT
function toggleAI() {
  document.getElementById('aiModal').classList.toggle('open');
}

function appendUserMsg(text) {
  const body = document.getElementById('aiChatBody');
  const msg = document.createElement('div');
  msg.className = 'msg user-msg';
  const bubble = document.createElement('div');
  bubble.className = 'msg-bubble';
  bubble.textContent = text;
  msg.appendChild(bubble);
  body.appendChild(msg);
  body.scrollTop = body.scrollHeight;
}

function appendBotMsg(text) {
  const body = document.getElementById('aiChatBody');
  const msg = document.createElement('div');
  msg.className = 'msg bot-msg';
  msg.innerHTML = '<div class="msg-avatar"></div><div class="msg-bubble"><p></p></div>';
  msg.querySelector('p').textContent = text;
  body.appendChild(msg);
  body.scrollTop = body.scrollHeight;
}

function handleAIEnter(e) {
  if (e.key === 'Enter') sendUserMsg();
}

function sendUserMsg() {
  const input = document.getElementById('aiInput');
  const text = input.value.trim();
  if (!text) return;
  appendUserMsg(text);
  input.value = '';
  setTimeout(() => {
    appendBotMsg('En este momento estoy aprendiendo a responder a tus consultas personalizadas. Por ahora, ¿puedo ayudarte con alguna de las opciones disponibles?');
  }, 1000);
}

function sendQuickReply(text, sectionId) {
  appendUserMsg(text);
  document.querySelectorAll('.quick-replies').forEach(qr => qr.style.display = 'none');

  setTimeout(() => {
    appendBotMsg('¡Claro! Te llevaré a esa sección ahora mismo.');
    setTimeout(() => {
      toggleAI();
      const el = document.querySelector(sectionId);
      if (el) {
        window.scrollTo({ top: el.offsetTop - 70, behavior: 'smooth' });
      } else {
        // Si estamos en una página del CRUD, vamos al inicio en esa sección
        window.location.href = '/' + sectionId;
      }
    }, 1500);
  }, 600);
}