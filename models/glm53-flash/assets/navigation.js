/* Track section position without changing hash history during normal scrolling. */
(() => {
  // Cross-page links do not participate in section tracking.
  const links = [...document.querySelectorAll('.side-nav a[href^="#"]')];
  const targets = links.map(link => document.getElementById(decodeURIComponent(link.getAttribute('href').slice(1))));
  let scheduled = false;
  function update() {
    scheduled = false;
    const offset = innerWidth <= 1000 ? 125 : 80;
    let active = 0;
    targets.forEach((target, index) => {
      if (target && target.getBoundingClientRect().top <= offset) active = index;
    });
    // Mobile hides the nested links; keep their visible parent highlighted.
    if (innerWidth <= 1000 && links[active].classList.contains('subnav')) active = 1;
    links.forEach((link, index) => {
      if (index === active) link.setAttribute('aria-current', 'location');
      else link.removeAttribute('aria-current');
    });
  }
  function schedule() {
    if (!scheduled) { scheduled = true; requestAnimationFrame(update); }
  }
  addEventListener('scroll', schedule, { passive: true });
  addEventListener('resize', schedule);
  update();
})();
