/* ==========================================================================
   Dev-скрипт: рендерит шапку и футер из js/layout.js в includes/header.html
   и includes/footer.html — чтобы справочные партиалы не разъезжались
   с реальной разметкой превью.

   Запуск из каталога app/preview-new-site:
     node js/build-includes.js
   ========================================================================== */
const fs = require('fs');
const path = require('path');
const vm = require('vm');

const root = path.resolve(__dirname, '..');
const captured = {};

/* Минимальный DOM-шим: layout.js только пишет innerHTML и навешивает обработчики */
function fakeEl(name) {
  return {
    innerHTML: '',
    classList: { add() {}, remove() {}, toggle() {}, contains: () => false },
    setAttribute() {},
    getAttribute: () => null,
    addEventListener() {},
    contains: () => false,
    querySelector: () => null,
    querySelectorAll: () => [],
    _name: name
  };
}

const slots = {
  preview: fakeEl('preview'),
  header: fakeEl('header'),
  footer: fakeEl('footer')
};

const document = {
  body: { getAttribute: (a) => (a === 'data-root' ? '' : '') },
  addEventListener() {},
  querySelector(sel) {
    const m = /^\[data-layout="(.+)"\]$/.exec(sel);
    return m ? slots[m[1]] || null : null;
  },
  querySelectorAll: () => []
};

const code = fs.readFileSync(path.join(root, 'js', 'layout.js'), 'utf8');
vm.createContext(globalThis);
vm.runInThisContext(`(function(document){${code}\n})`)(document);

captured.header = slots.header.innerHTML;
captured.footer = slots.footer.innerHTML;

/* Форматирование: разбиваем на строки по закрывающим тегам блоков */
function pretty(html) {
  return html
    .replace(/></g, '>\n<')
    .split('\n')
    .reduce((acc, line) => {
      const open = /^<(div|nav|header|footer)\b[^/]*>$/.test(line);
      const close = /^<\/(div|nav|header|footer)>$/.test(line);
      if (close) acc.depth = Math.max(0, acc.depth - 1);
      acc.out.push('  '.repeat(acc.depth) + line);
      if (open) acc.depth += 1;
      return acc;
    }, { out: [], depth: 0 }).out.join('\n');
}

const note = (name, what) => `<!--
  ${name} — ${what}

  Сгенерировано из js/layout.js: node js/build-includes.js
  Правьте layout.js, а не этот файл.

  Ссылки собраны относительно корня превью (data-root=""). При переносе
  в WHMCS-шаблон замените их на {$WEB_ROOT}/… и routePath().
-->
`;

fs.writeFileSync(
  path.join(root, 'includes', 'header.html'),
  note('header.html', 'шапка сайта: логотип, два уровня навигации, контакты, кнопки входа') +
  '<header class="header">\n' + pretty(captured.header) + '\n</header>\n'
);
fs.writeFileSync(
  path.join(root, 'includes', 'footer.html'),
  note('footer.html', 'футер: колонки ссылок, телефоны, платёжные системы, правовые ссылки') +
  '<footer class="footer">\n' + pretty(captured.footer) + '\n</footer>\n'
);

console.log('includes/header.html и includes/footer.html обновлены');
