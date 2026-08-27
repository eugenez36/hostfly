/* ==========================================================================
   Hostfly — поведение компонентов UI-кита: аккордеон, табы, слайдер
   ==========================================================================

   Перенесено из ui-kit/theme.js.

   ОТЛИЧИЕ ОТ ИСТОЧНИКА: в превью обработчики навешивались на весь документ
   (document.querySelectorAll). Здесь поиск идёт только внутри контейнеров
   .hf-kit — так же, как изолирован CSS кита, чтобы скрипт не мог задеть
   существующую разметку кабинета.

   Не переносилось (это логика конкретных страниц, а не кита): пересчёт цен
   по периоду оплаты, корзина в поиске доменов и переключатель «показывать
   занятые». В WHMCS эти сценарии ведёт сама платформа.

   Подключается из includes/head.tpl вместе с css/hf-kit.css.
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

/* ==========================================================================
   Страховка после подмены шрифта (HOS-6)
   --------------------------------------------------------------------------
   Стоковый js/whmcs.js зовёт autoCollapse('#nav', 30) на document.ready и на
   resize: пока высота меню не меньше 30px, последние пункты уезжают в «Ещё».
   Inter подключён с font-display: swap, и хотя он преднагружается из head.tpl,
   на холодном кеше и медленной сети подмена может прийти уже после ready —
   меню окажется померенным по метрикам Open Sans без пересчёта.
   Дёргаем штатный resize-обработчик темы, когда шрифты действительно готовы.
   В сам whmcs.js не лезем: это стоковый файл.
   ========================================================================== */
(function () {
  if (!document.fonts || !document.fonts.ready) return;
  document.fonts.ready.then(function () {
    window.dispatchEvent(new Event('resize'));
  });
})();

/* ==========================================================================
   Знак белорусского рубля (HOS-9)
   --------------------------------------------------------------------------
   Суммы приходят из WHMCS готовой строкой: обозначение валюты приклеено
   к числу внутри одного текстового узла («320.97руб.», «0.00 руб.»), а часто
   ещё и стоит посреди фразы — «на общую сумму 320.97руб. Оплатите их…».
   Отдельного элемента вокруг обозначения нет нигде, поэтому одним CSS
   не обойтись: находим токен в текстовых узлах и оборачиваем сами.

   Оборачиваем ТОЛЬКО когда перед обозначением стоит цифра. Так исключаются
   ложные срабатывания вроде кнопки выбора локали в футере («Русский / BYN»),
   где речь о коде валюты, а не о сумме.

   Внутрь обёртки всегда кладём латинское «BYN»: именно это сочетание шрифт
   Нацбанка превращает в знак лигатурой. Побочный эффект — при копировании
   суммы получится «320.97 BYN» даже там, где на странице было «руб.».

   Шрифт включается только после подтверждения загрузки (класс hf-nbrb),
   поэтому при недоступном файле в вёрстке остаётся читаемый текст.
   ========================================================================== */
(function () {
  'use strict';

  var TOKEN = /(\d)[\s\u00a0]*(BYN|руб\.)/g;
  var SKIP = {
    SCRIPT: 1, STYLE: 1, TEXTAREA: 1, INPUT: 1, SELECT: 1, OPTION: 1,
    CODE: 1, PRE: 1, NOSCRIPT: 1, TITLE: 1, HEAD: 1
  };

  function skip(node) {
    for (var el = node.parentNode; el && el.nodeType === 1; el = el.parentNode) {
      if (SKIP[el.nodeName]) return true;
      if (el.classList && el.classList.contains('hf-byn')) return true;
      if (el.isContentEditable) return true;
    }
    return false;
  }

  /* Текстовый узел -> фрагмент, где каждое обозначение обёрнуто в span.
     Между числом и знаком ставим неразрывный пробел, чтобы сумма не
     разрывалась переносом строки. */
  function wrap(node) {
    var text = node.nodeValue;
    TOKEN.lastIndex = 0;
    if (!TOKEN.test(text)) return false;
    TOKEN.lastIndex = 0;

    var frag = document.createDocumentFragment();
    var last = 0;
    var m;
    while ((m = TOKEN.exec(text)) !== null) {
      var head = text.slice(last, m.index) + m[1] + '\u00a0';
      frag.appendChild(document.createTextNode(head));
      var span = document.createElement('span');
      span.className = 'hf-byn';
      span.textContent = 'BYN';
      frag.appendChild(span);
      last = m.index + m[0].length;
    }
    frag.appendChild(document.createTextNode(text.slice(last)));
    node.parentNode.replaceChild(frag, node);
    return true;
  }

  function walk(root) {
    if (!root || (root.nodeType !== 1 && root.nodeType !== 11)) return;
    var it = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, null, false);
    var nodes = [];
    var n;
    /* Сначала собираем узлы, потом правим: замена узла на лету сбивает обход. */
    while ((n = it.nextNode())) {
      if (!n.nodeValue) continue;
      TOKEN.lastIndex = 0;
      if (TOKEN.test(n.nodeValue) && !skip(n)) nodes.push(n);
    }
    for (var i = 0; i < nodes.length; i++) wrap(nodes[i]);
  }

  function run() {
    if (observer) observer.disconnect();
    walk(document.body);
    if (observer) observer.observe(document.body, { childList: true, subtree: true, characterData: true });
  }

  /* Суммы дорисовываются после загрузки: корзина пересчитывается ajax-ом
     в пустые #recurringMonthly .cost, поиск доменов заполняет span.price,
     таблицы счетов и услуг перерисовывает DataTables. Без наблюдателя
     эти места остались бы со старым обозначением. */
  var timer = null;
  var observer = null;
  if (window.MutationObserver) {
    observer = new MutationObserver(function () {
      clearTimeout(timer);
      timer = setTimeout(run, 120);
    });
  }

  run();

  /* Шрифт включаем, только если он реально загрузился. Второй аргумент
     check() обязателен: unicode-range сужен до знака и букв B, Y, N,
     а проверочная строка браузера по умолчанию в этот диапазон не попадает. */
  if (document.fonts && document.fonts.load) {
    document.fonts.load('1em "nbrb"', 'BYN').then(function () {
      if (document.fonts.check('1em "nbrb"', 'BYN')) {
        document.documentElement.classList.add('hf-nbrb');
      }
    })['catch'](function () { /* шрифт недоступен — остаётся текст BYN */ });
  }
})();
