# Что НЕ покрыто новым дизайном Figma

> **Актуальность.** Документ сравнивает Figma-дизайн со **сток-темой `nexus`**.
> Работа кабинета ведётся на теме **`ais`**, а `nexus` в проекте не используется — она
> взята только как нейтральная точка отсчёта. Выводы про непокрытые дизайном разделы
> остаются в силе, но сопоставления «дизайн ↔ шаблон» к рабочей теме напрямую
> не применяются. См. [`CLAUDE.md`](../CLAUDE.md).

Сравнение: `app/new-design/` (выгрузка Figma: 7 листов final-theme + 14 листов ui-kit)
против `ftp/public/templates/nexus/` (шаблон WHMCS, **171 .tpl**).

Дата: 05.08.2026

---

## 0. Главный вывод

**Это два разных продукта, между которыми нет пересечения.**

| | Что это | Покрытие дизайном |
|---|---|---|
| `app/new-design/` | Редизайн **маркетингового сайта** `hostfly.by` — лендинги услуг, домены, блог, инфо-страницы | ~35 страниц (desktop + mobile) |
| `ftp/public/templates/nexus/` | **Сток-тема WHMCS 9.0 «Nexus»** для личного кабинета `my.hostfly.by` — англоязычная, немодифицированная | **0 %** |

Ни одного экрана кабинета в Figma нет. Ни одного маркетингового лендинга в шаблоне нет.
Единственная точка стыка — хедер/футер и поиск домена, и именно там расхождение видно сильнее всего.

Проверено: шаблон — стоковый (`theme.yaml`: `author: WHMCS Limited`, `description: The Default Theme for WHMCS 9.0`), лого/цвета/тексты не тронуты, все строки через англоязычные `{lang key=...}`.

---

## 1. Личный кабинет WHMCS — 0 % покрытия (171 шаблон)

Самый крупный пробел. Ни один из блоков ниже не имеет дизайна.

### 1.1 Аутентификация и доступ — 17 шаблонов
`login.tpl` · `clientregister.tpl` · `password-reset-container / -email-prompt / -security-prompt / -change-prompt` · `two-factor-challenge.tpl` · `two-factor-new-backup-code.tpl` · `user-invite-accept.tpl` · `user-verify-email.tpl` · `user-switch-account.tpl` · `user-switch-account-forced.tpl` · `banned.tpl` · `access-denied.tpl` · `oauth/login.tpl` · `oauth/authorize.tpl` · `oauth/login-twofactorauth.tpl` · `oauth/error.tpl`

> На сайте есть кнопки **«ВОЙТИ»** и **«СТАТЬ КЛИЕНТОМ»** — но экранов, куда они ведут, в макете нет.

### 1.2 Дашборд кабинета — 2
`clientareahome.tpl` (сводка: услуги, домены, счета, тикеты, алерты) · `homepage.tpl`

### 1.3 Услуги и тарифы — 10
`clientareaproducts.tpl` · `clientareaproductdetails.tpl` (533 строки — самый большой файл темы: вкладки, ресурсы, действия, модули) · `clientareaproductusagebilling.tpl` · `usagebillingpricing.tpl` · `upgrade.tpl` · `upgrade-configure.tpl` · `upgradesummary.tpl` · `subscription-manage.tpl` · `clientareacancelrequest.tpl` · `includes/active-products-services-item.tpl`

### 1.4 Домены в кабинете — 11
`clientareadomains.tpl` · `clientareadomaindetails.tpl` (468 строк) · `clientareadomaindns.tpl` · `clientareadomainemailforwarding.tpl` · `clientareadomaingetepp.tpl` · `clientareadomainregisterns.tpl` · `clientareadomaincontactinfo.tpl` · `clientareadomainaddons.tpl` · `bulkdomainmanagement.tpl` (250 строк) · `domain-pricing.tpl` · `forwardpage.tpl`

> В Figma домены покрыты **только как витрина** (поиск, зоны, перенос, продление, аукцион). Управление уже купленным доменом — DNS, NS, EPP, whois-контакты, массовые операции — не покрыто.

### 1.5 Биллинг и платежи — 20
`clientareainvoices.tpl` · `viewinvoice.tpl` (319 строк) · `invoicepdf.tpl` · `invoice-payment.tpl` · `masspay.tpl` · `clientareaaddfunds.tpl` · `clientareaquotes.tpl` · `viewquote.tpl` · `quotepdf.tpl` · `viewbillingnote.tpl` · `account-paymentmethods.tpl` · `account-paymentmethods-manage.tpl` (480 строк) · `account-paymentmethods-billing-contacts.tpl` · `3dsecure.tpl` · `payment/card/{inputs,select,validate}.tpl` · `payment/bank/{inputs,select,validate}.tpl` · `payment/billing-address.tpl` · `payment/invoice-summary.tpl`

### 1.6 Поддержка — 10
`supportticketslist.tpl` · `viewticket.tpl` · `supportticketsubmit-stepone / -steptwo / -customfields / -kbsuggestions / -confirm` · `ticketfeedback.tpl` · `serverstatus.tpl` · `downloads.tpl` / `downloadscat.tpl` / `downloaddenied.tpl`

### 1.7 Профиль и безопасность — 11
`clientareadetails.tpl` · `clientareaemails.tpl` · `viewemail.tpl` · `clientareasecurity.tpl` · `user-profile.tpl` · `user-password.tpl` · `user-security.tpl` · `account-contacts-manage.tpl` · `account-contacts-new.tpl` · `account-user-management.tpl` · `account-user-permissions.tpl`

### 1.8 SSL в кабинете — 4
`configuressl-stepone.tpl` · `configuressl-steptwo.tpl` · `configuressl-complete.tpl` · `managessl.tpl`

> В Figma SSL покрыт как каталог + квиз-подбор. Мастер конфигурации сертификата (CSR, валидация, approver email) и управление выпущенным сертификатом — не покрыты.

### 1.9 Партнёрка в кабинете — 2
`affiliates.tpl` (139 строк: баланс, выплаты, рефералы, ссылки) · `affiliatessignup.tpl`

> В Figma есть лендинг «Партнёрская программа» и «Купи свою хостинг-компанию». Личного кабинета партнёра нет.

### 1.10 Магазин / MarketConnect — 44 шаблона
`store/ssl/*` (dv, ov, ev, wildcard, competitive-upgrade + 6 shared) · `store/sitebuilder/*` · `store/weebly/*` · `store/sitelock/*` · `store/sitelockvpn/*` · `store/spamexperts/*` · `store/marketgoo/*` · `store/nordvpn/*` · `store/ox/*` · `store/codeguard/*` · `store/socialbee/*` · `store/xovinow/*` · `store/threesixtymonitoring/*` · `store/promos/upsell.tpl` · `store/order.tpl` · `store/dynamic/*` (5 партиалов) · `store/config-fields/*` (4) · `store/addon/wp-toolkit-{cpanel,plesk}.tpl` · `store/not-found.tpl`

### 1.11 Служебные страницы ошибок — 4
`error/page-not-found.tpl` (404) · `error/internal-error.tpl` (500) · `error/rate-limit-exceeded.tpl` (429) · `error/unknown-routepath.tpl`

> Лист «Служебные страницы» в Figma — это **не** страницы ошибок, а «Кто мы / Контакты / Документы / Договор / Дата-центр / Защита от DDoS / Бонус Google Ads». Дизайна 404 и 500 нет нигде.

### 1.12 Общие блоки шаблона — 21 include
`navbar.tpl` · `sidebar.tpl` (105 строк) · `breadcrumb.tpl` · `alert.tpl` · `modal.tpl` · `panel.tpl` · `tablelist.tpl` (119 строк, DataTables) · `domain-search.tpl` · `captcha.tpl` · `generate-password.tpl` · `pwstrength.tpl` (99 строк) · `linkedaccounts.tpl` · `social-accounts.tpl` · `flashmessage.tpl` · `network-issues-notifications.tpl` · `validateuser.tpl` · `verifyemail.tpl` · `confirmation.tpl` · `head.tpl` · `sitejet/homepagepanel.tpl`

### 1.13 Корзина и оформление заказа — шаблонов вообще нет в синке
WHMCS держит корзину в отдельном наборе `templates/orderforms/*` — по FTP он **не выгружен** (в `ftp/public/templates/` только `nexus`). При этом в теме есть `sass/_cart.scss`, а в макете домен-поиска нарисован мини-виджет **«Ваш заказ → Перейти в заказ»**.

**То есть кнопка в макете есть, а экран, куда она ведёт, не спроектирован и его шаблонов нет локально.** Это разрыв прямо в основной воронке продаж.

---

## 2. Хедер и футер авторизованного пользователя

В Figma нарисован хедер **гостя**: логотип, утилитарная строка, телефоны, мега-меню, «СТАТЬ КЛИЕНТОМ» / «ВОЙТИ».

В `header.tpl` при `{if $loggedin}` появляется целый **topbar**, которого в дизайне нет:
- кнопка уведомлений с попапом `clientAlerts` (счётчик + список алертов по severity);
- блок «Вошли как: <Компания/ФИО>» со ссылкой в профиль;
- переключатель аккаунтов (`user-accounts`);
- «Вернуться в админку» при масквераде;
- иконка корзины со счётчиком `cartItemCount`;
- поиск по базе знаний в хедере (desktop + mobile-вариант);
- вторичная навигация (`secondaryNavbar`) справа;
- блок `network-issues-notifications` (аварии) под хедером;
- баннеры `validateuser` / `verifyemail`;
- мастер-breadcrumb.

---

## 3. UI-kit — чего нет в наборе компонентов

Что **есть** (14 листов): Colors · Typography · Logo · Icons · Buttons · Links · Input · Radio • Checkbox · Tabs · Chips · Badges · Pagination · Tooltip · Все страницы.

Чего **нет**, но требуется темой (в скобках — сколько раз класс встречается в `.tpl`):

| Компонент | Использований | Комментарий |
|---|---|---|
| **Таблицы** | `table` ×42, `table-list` ×9, `table-striped` ×14, `table-responsive` ×6 | DataTables: сортировка, поиск, per-page, пустое состояние, чекбоксы строк, массовые действия. В ките таблиц нет вообще |
| **Карточки / панели** | `card` ×171, `card-header` ×67, `card-footer` ×15 | Основной контейнер всего кабинета — не описан |
| **Alerts / уведомления** | `alert-danger` ×15, `alert-warning` ×14, `alert-success` ×13, `alert-info` ×8 | 4 семантических состояния — не описаны |
| **Модальные окна** | `modal` ×23 (header/body/footer/loader/close) | В макетах есть только маркетинговая квиз-модалка (SSL, Хостинг). Системной модалки нет |
| **Select / dropdown** | `custom-select` ×22, `dropdown-menu` ×8, `dropdown-item` ×11 | В листе Input есть только text/textarea/tel/search. Селекта нет |
| **Загрузка файлов** | `custom-file` ×12 | Вложения в тикетах, аватары |
| **List group** | `list-group` ×14, `list-group-item` ×20 | Фильтры-«радио» в списках, боковые меню |
| **Button group / split** | `btn-group` ×18, `btn-group-sm` ×10 | Групповые действия в таблицах |
| **Progress bar** | ×27 | Диск/трафик/память в деталях услуги |
| **Spinner / loader** | ×28 | Асинхронная подгрузка (DataTables, модалки, поиск домена) |
| **Sidebar (вертикальное меню)** | `includes/sidebar.tpl` | Основная навигация кабинета — нет ни в ките, ни в макетах |
| **Breadcrumb** | `includes/breadcrumb.tpl` | Визуально в макетах присутствует, но как компонент не описан |
| **Accordion** | `collapse` ×63 | В макетах есть FAQ-аккордеон, но в кит не вынесен |
| **Stepper / wizard** | SSL ×3 шага, тикет ×2, upgrade ×3 | Индикатора шагов нет |
| **Индикатор надёжности пароля** | `pwstrength.tpl` | Нет |
| **Captcha** | `captcha.tpl`, `_captcha.scss` | Нет |
| **Поля банковской карты / счёта** | `payment/card/*`, `payment/bank/*` | Нет |
| **Ввод 2FA-кода** | `two-factor-challenge.tpl` | Нет |
| **Пустые состояния** | нет услуг / доменов / тикетов / счетов | Нет ни одного |
| **Toast / flash-сообщения** | `flashmessage.tpl` | Нет |
| **Вёрстка счёта / PDF** | `invoice.css`, `invoicepdf.tpl`, `quotepdf.tpl` | Печатная форма счёта и КП — нет |
| **Markdown-контент** | `_markdown.scss`, `markdown-guide.tpl` | Стилей текста в тикетах/статьях нет |
| **Popover** | ×3 | Есть Tooltip, но не popover с контентом |

### 3.1 Кнопки — нет семантических вариантов
В ките: `primary` (чёрная), `outline`, `accent` (синяя «Заказать»), icon-кнопки, бургер. Размеры L/M/S/XS, состояния default/hover/active/disabled.

Не описаны: **danger** (`btn-danger` ×20 — отмена услуги, удаление, terminate), **success** (`btn-success` ×34), **warning** (`btn-warning` ×6), **loading**-состояние, split-кнопка с выпадающим списком, `btn-link` (×40).

### 3.2 Badges — нет статусов
Лист «Badges» содержит **один** маркетинговый бейдж «РЕКОМЕНДУЕМ» в 7 оттенках.

Тема требует **~30 семантических статусов** (`sass/_colors.scss`):
`pending` · `pending-transfer` · `pending-registration` · `active` · `open` · `completed` · `suspended` · `terminated` · `cancelled` · `expired` · `transferred-away` · `redemption` · `grace` · `fraud` · `customer-reply` · `answered` · `onhold` · `inprogress` · `closed` · `paid` · `unpaid` · `refunded` · `collections` · `payment-pending` · `delivered` · `accepted` · `lost` · `dead`
плюс типы пользователей: `operator` · `owner` · `authorizeduser` · `registereduser` · `subaccount` · `guest`.

**Ни один статус не имеет дизайн-токена.** Это критично: статусы — основной носитель смысла во всех списках кабинета.

### 3.3 Иконки — набор на порядок меньше нужного
В ките ~30 иконок, все маркетинговые: поиск, галочка, люди, рукопожатие, документ, почта, видео, календарь, курсор, часы, стрелки, корзина, PDF, кавычки, скрепка, крестик + соцсети/мессенджеры (VK, FB, Instagram, OK, X, YouTube, Viber, Telegram, WhatsApp, Threads) + флаг Беларуси.

Тема Nexus использует **FontAwesome 5.10 Pro** в четырёх начертаниях (`fal` / `far` / `fas` / `fad`) — это сотни глифов. Отсутствуют иконки предметной области кабинета: сервер, домен, DNS, счёт, тикет, банковская карта, база данных, почтовый ящик, щит/SSL, шестерёнка, колокольчик, ключ, корзина-удалить, копировать, скачать, фильтр, сортировка, чек-круг / warning-круг / info-круг.

**Решение по иконкам не принято**: либо расширять кит, либо оставлять FontAwesome (тогда стилистика кабинета не совпадёт с сайтом).

---

## 4. Публичный сайт — что не покрыто по собственному чек-листу дизайнера

Лист `ui-kit/Все страницы.png` — карта сайта от дизайнера. 🟢 есть · 🟡 пока нет · 🔴 удалена.

### 🟡 Запланированы, но не нарисованы — 8 страниц
- **Хостинг:** Linux-хостинг · Перенос сайта · Продление хостинга
- **Серверы и обл. решения:** Администрируемый облачный хостинг (на базе «Облачного хостинга») · Битрикс в облаке (на базе «1С в облаке») · Объектное хранилище (S3)
- **Доп. услуги:** Панель управления cPanel · Администрирование серверов

### Не отражено в карте сайта вообще
Разделов **«Авторизация»**, **«Корзина / оформление заказа»**, **«Личный кабинет»**, **«Страницы ошибок»** в карте нет — они не попали даже в план.

### ⚠️ Расхождение между картой сайта и макетами
Помечены 🔴 «удалена», но **дизайн для них существует** в `final-theme/`:
- Дата-центр, Защита от DDoS, Бонус 300$ на рекламу → нарисованы в `Служебные страницы.png`
- Конструктор интернет-магазина, Конструктор сайтов-визиток, Конструктор одностраничных лендингов → нарисованы в `Конструкторы.png` (4 макета)

Нужно уточнить у дизайнера: карта устарела или макеты делались «в стол».

---

## 5. Технические пробелы

1. **Шрифты.** Дизайн построен на **NT Somic** (заголовки) и **Unbounded** (акценты) + Inter. Оба не системные и не бесплатные для веба. Для темы WHMCS нужны self-hosted файлы и лицензия — вопрос не решён.
2. **Стек.** Nexus = Bootstrap 4.5.3 + jQuery 1.12.4 + DataTables. Макет нарисован без привязки к сетке Bootstrap (контейнер 1710 при 1920). Прямая замена CSS не сработает — нужен либо кастомный слой поверх BS4, либо переверстка.
3. **Локализация.** Тема стоковая, все строки — англоязычные `{lang key=...}`; русского языкового пакета в синке нет. Макет полностью на русском.
4. **Мобильная версия кабинета.** Для сайта mobile-макеты есть для каждой страницы. Для кабинета — ни одного.
5. **Состояния фокуса / доступность.** В ките есть default/hover/active/disabled/error, но нет `:focus-visible` — для форм кабинета (оплата, 2FA) это обязательно.
6. **Тёмная тема** не предусмотрена нигде — если не нужна, это стоит зафиксировать явно.

---

## 6. Приоритеты

| # | Что | Почему первым |
|---|---|---|
| 1 | **Корзина и оформление заказа** | Кнопка «Перейти в заказ» в макете уже есть, экрана нет. Разрыв прямо в воронке. Плюс шаблонов `orderforms/` нет даже локально — надо выгрузить по FTP |
| 2 | **Вход / регистрация / восстановление пароля** | Кнопки «ВОЙТИ» и «СТАТЬ КЛИЕНТОМ» ведут в стоковый англоязычный WHMCS — самый заметный разрыв для пользователя |
| 3 | **Статус-бейджи (~30) + таблицы + alerts + карточки** | Базовый слой, без которого нельзя начать ни один экран кабинета |
| 4 | **Хедер/футер авторизованного состояния** | Единый каркас сайт ↔ кабинет; после него остальные экраны верстаются внутри готовой рамки |
| 5 | **Дашборд + услуги + домены + счета + тикеты** | Ядро кабинета по частоте использования |
| 6 | **404 / 500** | Дёшево, а сейчас показывают стоковый WHMCS |
| 7 | 🟡 8 недостающих лендингов сайта | По плану самого дизайнера |
| 8 | Решение по иконкам (расширять кит vs. оставить FontAwesome) | Блокирует консистентность всего кабинета |

---

## Приложение: методика

- Карта сайта и все 14 листов ui-kit прочитаны в полном разрешении.
- 7 листов `final-theme/*.png` (до 32768×25863 px) прочитаны как уменьшенные обзоры + точечные кропы в полном масштабе. Состав страниц определён надёжно; отдельные мелкие компоненты внутри фреймов могли не попасть в обзор — если нужна поэкранная детализация по конкретному листу, её стоит сделать отдельным проходом.
- Инвентаризация темы — по факту файлов и по частоте CSS-классов в 171 `.tpl`.
