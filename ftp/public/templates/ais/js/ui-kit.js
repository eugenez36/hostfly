/* ==========================================================================
   Hostfly — поведение компонентов UI-кита: аккордеон, табы, слайдер
   ==========================================================================

   Перенесено из app/preview-new-site/js/theme.js.

   ОТЛИЧИЕ ОТ ИСТОЧНИКА: в превью обработчики навешивались на весь документ
   (document.querySelectorAll). Здесь поиск идёт только внутри контейнеров
   .hf-kit — так же, как изолирован CSS кита, чтобы скрипт не мог задеть
   существующую разметку кабинета.

   Не переносилось (это логика конкретных страниц, а не кита): пересчёт цен
   по периоду оплаты, корзина в поиске доменов и переключатель «показывать
   занятые». В WHMCS эти сценарии ведёт сама платформа.

   Подключение: <script src="{$WEB_ROOT}/templates/ais/js/ui-kit.js"></script>
   ========================================================================== */
(function () {
  var roots = document.querySelectorAll('.hf-kit');
  if (!roots.length) return;

  Array.prototype.forEach.call(roots, function (root) {

    /* --- Аккордеон (FAQ) ------------------------------------------------- */
    root.querySelectorAll('.acc__btn').forEach(function (btn) {
      btn.addEventListener('click', function () {
        var acc = btn.closest('.acc');
        var open = acc.classList.contains('is-open');
        if (acc.dataset.single !== 'false') {
          acc.closest('.accordion').querySelectorAll('.acc').forEach(function (a) {
            a.classList.remove('is-open');
          });
        }
        acc.classList.toggle('is-open', !open);
        btn.setAttribute('aria-expanded', String(!open));
      });
    });

    /* --- Сегментированные табы и табы-подчёркивания -----------------------
       Переключение панелей по data-tab / data-panel в общем родителе.      */
    function bindTabs(tabsRoot, itemSel) {
      tabsRoot.querySelectorAll(itemSel).forEach(function (item) {
        item.addEventListener('click', function () {
          tabsRoot.querySelectorAll(itemSel).forEach(function (i) {
            i.classList.remove('is-active');
          });
          item.classList.add('is-active');
          var name = item.getAttribute('data-tab');
          if (!name) return;
          var scope = tabsRoot.closest('[data-tabs-scope]') || tabsRoot.parentElement;
          scope.querySelectorAll('[data-panel]').forEach(function (p) {
            p.hidden = p.getAttribute('data-panel') !== name;
          });
        });
      });
    }
    root.querySelectorAll('.tabs').forEach(function (r) { bindTabs(r, '.tabs__item'); });
    root.querySelectorAll('.tabs-line').forEach(function (r) { bindTabs(r, '.tabs-line__item'); });

    /* --- Слайдер (отзывы, скриншоты панели) ------------------------------ */
    root.querySelectorAll('[data-slider]').forEach(function (slider) {
      var track = slider.querySelector('.slider__track');
      var slides = track ? track.children : [];
      var prev = slider.querySelector('[data-slider-prev]');
      var next = slider.querySelector('[data-slider-next]');
      var dots = slider.querySelectorAll('.slider__dot');
      var i = 0;

      function step() {
        if (!slides.length) return 0;
        var gap = parseFloat(getComputedStyle(track).columnGap || '24') || 24;
        return slides[0].getBoundingClientRect().width + gap;
      }
      function perView() {
        if (!slides.length) return 1;
        return Math.max(1, Math.round(slider.querySelector('.slider__viewport')
          .getBoundingClientRect().width / step()));
      }
      function max() { return Math.max(0, slides.length - perView()); }
      function render() {
        i = Math.min(Math.max(i, 0), max());
        track.style.transform = 'translateX(' + (-i * step()) + 'px)';
        dots.forEach(function (d, n) { d.classList.toggle('is-active', n === i); });
        if (prev) prev.disabled = i === 0;
        if (next) next.disabled = i >= max();
      }
      if (prev) prev.addEventListener('click', function () { i--; render(); });
      if (next) next.addEventListener('click', function () { i++; render(); });
      dots.forEach(function (d, n) { d.addEventListener('click', function () { i = n; render(); }); });
      window.addEventListener('resize', render);
      render();
    });

  });
})();
