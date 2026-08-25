/* ==========================================================================
   Hostfly — единый источник шапки, футера и превью-навигации.
   Страницы подключают этот файл и содержат пустые контейнеры:
     <div data-layout="preview"></div>
     <header data-layout="header"></header>
     <footer data-layout="footer"></footer>
   Относительный корень берётся из <body data-root="../">.
   Разметка партиалов дублируется в includes/header.html и includes/footer.html
   как справочный HTML для переноса в WHMCS-шаблоны.
   ========================================================================== */
(function () {
  var ROOT = document.body.getAttribute('data-root') || '';
  var PAGE = document.body.getAttribute('data-page') || '';

  function url(path) { return ROOT + path; }

  /* --- Иконки ---------------------------------------------------------- */
  var ico = {
    down: '<svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">' +
          '<path d="M8 3v10M8 13l4-4M8 13L4 9" stroke="currentColor" stroke-width="1.4" ' +
          'stroke-linecap="round" stroke-linejoin="round"/></svg>',
    burger: '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" aria-hidden="true">' +
            '<path d="M4 7h16M4 12h16M4 17h16" stroke="currentColor" stroke-width="1.6" ' +
            'stroke-linecap="round"/></svg>'
  };

  /* --- Структура меню -------------------------------------------------- */
  var MENU = [
    { label: 'Хостинг', href: 'store/hosting.html', items: [
      ['Хостинг сайтов', 'store/hosting.html'],
      ['WordPress-хостинг', 'store/hosting.html'],
      ['Битрикс-хостинг', 'store/hosting.html'],
      ['Unix/Linux хостинг', 'store/hosting.html'],
      ['Drupal хостинг', 'store/hosting.html'],
      ['Хостинг для Opencart', 'store/hosting.html']
    ] },
    { label: 'Защищенный хостинг', href: 'store/hosting.html' },
    { label: 'Домены', href: 'domains/register.html', items: [
      ['Регистрация доменов', 'domains/register.html'],
      ['Результаты поиска', 'domains/search-results.html'],
      ['Перенос домена', 'domains/transfer.html'],
      ['Продление домена', 'domains/transfer.html'],
      ['Аукцион доменов .BY', 'domains/transfer.html']
    ] },
    { label: 'SSL-сертификаты', href: 'store/ssl.html' },
    { label: 'Конструктор сайтов', href: 'store/ssl.html' },
    { label: 'О компании', href: 'info/contacts.html', items: [
      ['Кто мы', 'info/contacts.html'],
      ['Контакты', 'info/contacts.html'],
      ['Документы', 'info/contacts.html'],
      ['Партнерская программа', 'affiliates/index.html']
    ] }
  ];

  /* --- Шапка ------------------------------------------------------------ */
  function header() {
    var nav = MENU.map(function (m) {
      var drop = '';
      var caret = '';
      if (m.items) {
        caret = ico.down;
        drop = '<div class="nav__drop">' + m.items.map(function (i) {
          return '<a href="' + url(i[1]) + '">' + i[0] + '</a>';
        }).join('') + '</div>';
      }
      return '<div class="nav__item">' +
             '<a class="nav__link" href="' + url(m.href) + '">' + m.label + caret + '</a>' +
             drop + '</div>';
    }).join('');

    return '' +
      '<div class="container-wide">' +
        '<div class="header__top">' +
          '<a class="logo" href="' + url('index.html') + '">hostfl<span class="logo__accent">y.</span></a>' +
          '<nav class="header__nav-secondary">' +
            '<a href="' + url('info/news.html') + '">Новости и акции</a>' +
            '<a href="' + url('info/news.html') + '">Вопросы и ответы</a>' +
            '<a href="' + url('info/contacts.html') + '">Документы</a>' +
            '<a href="' + url('info/contacts.html') + '">Контакты</a>' +
          '</nav>' +
          '<div class="header__contacts">' +
            '<span class="label">Круглосуточная техподдержка:</span>' +
            '<a href="tel:+375173367373">+375 17 336 73 73</a>' +
            '<a href="mailto:support@hostfly.by">support@hostfly.by</a>' +
          '</div>' +
          '<button class="header__burger" type="button" aria-label="Меню">' + ico.burger + '</button>' +
        '</div>' +
        '<div class="header__bottom">' +
          '<nav class="nav">' + nav + '</nav>' +
          '<div class="header__actions">' +
            '<a class="btn btn--secondary btn--xs" href="#">Стать клиентом</a>' +
            '<a class="btn btn--xs" href="#">Войти</a>' +
          '</div>' +
        '</div>' +
      '</div>';
  }

  /* --- Футер ------------------------------------------------------------ */
  var FOOT_COLS = [
    ['О компании', [
      ['Кто мы', 'info/contacts.html'],
      ['Контакты', 'info/contacts.html'],
      ['Документы', 'info/contacts.html']
    ]],
    ['Важное', [
      ['Аукцион доменов', 'domains/transfer.html'],
      ['Хостинг сайтов', 'store/hosting.html'],
      ['Регистрация доменов', 'domains/register.html'],
      ['Wordpress хостинг', 'store/hosting.html'],
      ['Виртуальные серверы', 'store/hosting.html'],
      ['Выделенные серверы', 'store/hosting.html']
    ]],
    ['Полезное', [
      ['Новости и акции', 'info/news.html'],
      ['Блог', 'info/news.html'],
      ['SSL сертификаты', 'store/ssl.html'],
      ['Конструктор сайтов', 'store/ssl.html'],
      ['Вопросы и ответы', 'info/news.html'],
      ['Владельцам хостинг компаний', 'affiliates/index.html']
    ]]
  ];

  var PHONES = [
    ['+375 17 336 73 73', ''],
    ['+375 29 336 73 73', 'A1'],
    ['+375 29 865 73 73', 'МТС'],
    ['+375 25 730 73 73', 'Life']
  ];

  var PAY = ['VISA', 'bePaid', 'Samsung Pay', 'ЕРИП', 'Mastercard', 'Белкарт ИП',
             'Белкарт', 'G Pay', 'VISA Secure', 'ID Check'];

  var LEGAL = ['Политика конфиденциальности', 'Правила использования', 'Правовая информация',
               'Политика в отношении обработки файлов cookie', 'Пользовательское соглашение'];

  function footer() {
    var cols = FOOT_COLS.map(function (c) {
      return '<div><div class="footer__col-title">' + c[0] + '</div>' +
             '<div class="footer__links">' + c[1].map(function (l) {
               return '<a href="' + url(l[1]) + '">' + l[0] + '</a>';
             }).join('') + '</div></div>';
    }).join('');

    var phones = PHONES.map(function (p) {
      return '<a class="footer__phone" href="tel:' + p[0].replace(/[^+\d]/g, '') + '">' +
             p[0] + (p[1] ? ' <span>(' + p[1] + ')</span>' : '') + '</a>';
    }).join('');

    return '' +
      '<div class="container-wide">' +
        '<div class="footer__cols">' + cols +
          '<div><div class="footer__col-title">Круглосуточно</div>' +
          '<div class="footer__phones">' + phones + '</div></div>' +
        '</div>' +
        '<div class="footer__pay"><div class="logo-wall logo-wall--pay">' +
          PAY.map(function (p) { return '<div class="logo-wall__item">' + p + '</div>'; }).join('') +
        '</div></div>' +
        '<div class="footer__legal">' +
          LEGAL.map(function (l) { return '<a href="#">' + l + '</a>'; }).join('') +
        '</div>' +
        '<div class="footer__bottom">' +
          '<div>© 2024 ООО «Суппорт чейн». Провайдер облачного хостинга и регистратор ' +
          'доменных имен в Беларуси.<br>проспект Победителей, дом 106, офис 14 г. Минск, ' +
          '220062, Республика Беларусь info@hostfly.by +375 29 336-73-73</div>' +
          '<a href="#">Dev &amp; Design Whale Studio</a>' +
        '</div>' +
      '</div>';
  }

  /* --- Превью-навигация (только для показа макета) --------------------- */
  var PAGES = [
    ['Главная', 'index.html', 'home'],
    ['Хостинг', 'store/hosting.html', 'hosting'],
    ['SSL', 'store/ssl.html', 'ssl'],
    ['Домены', 'domains/register.html', 'domains'],
    ['Поиск домена', 'domains/search-results.html', 'domain-search'],
    ['Перенос', 'domains/transfer.html', 'transfer'],
    ['Новости', 'info/news.html', 'news'],
    ['Контакты', 'info/contacts.html', 'contacts'],
    ['Партнёрам', 'affiliates/index.html', 'affiliates'],
    ['404', 'error/404.html', '404'],
    ['UI-кит', 'ui-kit.html', 'ui-kit']
  ];

  function preview() {
    return '<div class="preview-bar__inner">' +
      '<span class="preview-bar__label">Превью нового дизайна</span>' +
      PAGES.map(function (p) {
        return '<a href="' + url(p[1]) + '"' + (p[2] === PAGE ? ' class="is-current"' : '') + '>' +
               p[0] + '</a>';
      }).join('') +
    '</div>';
  }

  /* --- Монтирование ----------------------------------------------------- */
  function mount(sel, html, cls) {
    var el = document.querySelector('[data-layout="' + sel + '"]');
    if (!el) return null;
    el.innerHTML = html;
    if (cls) el.classList.add(cls);
    return el;
  }

  mount('preview', preview(), 'preview-bar');
  var head = mount('header', header(), 'header');
  mount('footer', footer(), 'footer');

  /* --- Поведение шапки -------------------------------------------------- */
  if (head) {
    head.querySelectorAll('.nav__item').forEach(function (item) {
      if (!item.querySelector('.nav__drop')) return;
      var link = item.querySelector('.nav__link');
      link.addEventListener('click', function (e) {
        e.preventDefault();
        var open = item.classList.contains('is-open');
        head.querySelectorAll('.nav__item').forEach(function (i) { i.classList.remove('is-open'); });
        if (!open) item.classList.add('is-open');
      });
    });
    var burger = head.querySelector('.header__burger');
    if (burger) {
      burger.addEventListener('click', function () { head.classList.toggle('is-open'); });
    }
    document.addEventListener('click', function (e) {
      if (!head.contains(e.target)) {
        head.querySelectorAll('.nav__item').forEach(function (i) { i.classList.remove('is-open'); });
      }
    });
  }
})();
