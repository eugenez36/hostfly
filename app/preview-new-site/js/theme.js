/* ==========================================================================
   Hostfly — интерактив компонентов: аккордеон, табы, слайдер, корзина доменов
   ========================================================================== */
(function () {
  /* --- Аккордеон (FAQ) --------------------------------------------------- */
  document.querySelectorAll('.acc__btn').forEach(function (btn) {
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

  /* --- Сегментированные табы и табы-подчёркивания ------------------------
     Переключение панелей по data-tab / data-panel в общем родителе.        */
  function bindTabs(root, itemSel) {
    root.querySelectorAll(itemSel).forEach(function (item) {
      item.addEventListener('click', function () {
        root.querySelectorAll(itemSel).forEach(function (i) { i.classList.remove('is-active'); });
        item.classList.add('is-active');
        var name = item.getAttribute('data-tab');
        if (!name) return;
        var scope = root.closest('[data-tabs-scope]') || root.parentElement;
        scope.querySelectorAll('[data-panel]').forEach(function (p) {
          p.hidden = p.getAttribute('data-panel') !== name;
        });
      });
    });
  }
  document.querySelectorAll('.tabs').forEach(function (r) { bindTabs(r, '.tabs__item'); });
  document.querySelectorAll('.tabs-line').forEach(function (r) { bindTabs(r, '.tabs-line__item'); });

  /* --- Пересчёт цен по выбранному периоду оплаты ------------------------- */
  document.querySelectorAll('[data-price-tabs]').forEach(function (root) {
    root.querySelectorAll('.tabs__item').forEach(function (item) {
      item.addEventListener('click', function () {
        var k = parseFloat(item.getAttribute('data-factor') || '1');
        document.querySelectorAll('[data-base-price]').forEach(function (el) {
          var base = parseFloat(el.getAttribute('data-base-price'));
          el.textContent = (base * k).toFixed(2).replace('.', ',');
        });
      });
    });
  });

  /* --- Слайдер (отзывы, скриншоты панели) ------------------------------- */
  document.querySelectorAll('[data-slider]').forEach(function (slider) {
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

  /* --- Корзина в поиске доменов ----------------------------------------- */
  var order = document.querySelector('[data-order]');
  if (order) {
    var itemsBox = order.querySelector('[data-order-items]');
    var totalBox = order.querySelector('[data-order-total]');
    var items = [];

    function redraw() {
      itemsBox.innerHTML = items.length
        ? items.map(function (it) {
            return '<div class="order-box__item"><span>' + it.name + '</span>' +
                   '<span>' + it.price.toFixed(2).replace('.', ',') + ' BYN</span></div>';
          }).join('')
        : '<div class="order-box__item"><span>Домены не выбраны</span></div>';
      var sum = items.reduce(function (s, it) { return s + it.price; }, 0);
      totalBox.textContent = sum.toFixed(2).replace('.', ',');
    }

    document.querySelectorAll('[data-add-domain]').forEach(function (btn) {
      btn.addEventListener('click', function () {
        var name = btn.getAttribute('data-add-domain');
        var price = parseFloat(btn.getAttribute('data-price') || '0');
        if (items.some(function (it) { return it.name === name; })) return;
        items.push({ name: name, price: price });
        btn.classList.add('is-added');
        btn.innerHTML = '<svg width="20" height="20" viewBox="0 0 20 20" fill="none">' +
          '<path d="M4 10.5l4 4 8-9" stroke="currentColor" stroke-width="1.8" ' +
          'stroke-linecap="round" stroke-linejoin="round"/></svg>';
        redraw();
      });
    });
    redraw();
  }

  /* --- Переключатель «показывать занятые» -------------------------------- */
  document.querySelectorAll('[data-toggle-taken]').forEach(function (sw) {
    var input = sw.querySelector('input');
    var list = document.querySelector('[data-domain-list]');
    if (!input || !list) return;
    function apply() {
      list.querySelectorAll('.domain-row.is-taken').forEach(function (row) {
        row.style.display = input.checked ? '' : 'none';
      });
    }
    input.addEventListener('change', apply);
    apply();
  });
})();
