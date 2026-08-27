/**
 * HOS-14 — переключатель типа регистрации и видимость полей по типу.
 *
 * Что делает:
 *   1. Прячет стоковый <select> «Тип регистрации» и показывает вместо него
 *      табы из UI-кита. Селект остаётся в форме и отправляется как прежде —
 *      табы лишь меняют его значение. Набор отправляемых полей не меняется.
 *   2. Показывает и прячет блоки по атрибуту data-type, который проставлен
 *      в clientregister.tpl (HOS-13): "person", "org", "ip" через запятую.
 *   3. Очищает поля скрытого блока, чтобы от другого типа регистрации
 *      не оставалось введённых значений.
 *
 * Чего НЕ делает: не трогает data-req. Обязательность полей по типу и
 * паспортная логика по наличию домена в заказе — это HOS-16.
 *
 * Прогрессивное улучшение: без JS виден рабочий селект, а табы скрыты
 * классом hf-hidden прямо в разметке. Скрипт меняет их местами.
 */
(function () {
    'use strict';

    var SELECT_NAME = 'customfield[33]';
    var HIDDEN = 'hf-hidden';

    /** Значения типов, на которые размечены блоки формы. */
    var TYPE_ALIASES = { organization: 'org' };

    function alias(value) {
        return TYPE_ALIASES[value] || value;
    }

    /**
     * Очистка полей внутри скрытого блока.
     * Radio и checkbox не трогаем: переключатель типа и «резидент РБ»
     * лежат вне data-type-блоков, а внутри них чекбоксов нет — но если
     * появятся, снимать их молча было бы неожиданно.
     */
    function clearBlock(block) {
        block.querySelectorAll('input, textarea, select').forEach(function (el) {
            if (el.type === 'hidden' || el.type === 'radio' || el.type === 'checkbox') return;
            if (el.tagName === 'SELECT') {
                el.selectedIndex = 0;
            } else {
                el.value = '';
            }
            el.classList.remove('is-invalid');
        });
        // Сообщения об ошибке, которые вставляет автозаполнение по УНП
        block.querySelectorAll('.egr-error-message').forEach(function (n) {
            n.parentNode.removeChild(n);
        });
    }

    /**
     * @param {string} type   значение селекта: person | organization | ip
     * @param {boolean} clear очищать ли поля скрываемых блоков.
     *                        На первой отрисовке — нет: сервер мог вернуть
     *                        форму с уже введёнными значениями после ошибки
     *                        валидации, и стирать их нельзя.
     */
    function applyType(type, clear) {
        var current = alias(type);
        document.querySelectorAll('[data-type]').forEach(function (block) {
            var allowed = block.getAttribute('data-type').split(',').map(function (t) {
                return t.trim();
            });
            var show = allowed.indexOf(current) !== -1;
            var wasVisible = !block.classList.contains(HIDDEN);
            block.classList.toggle(HIDDEN, !show);
            if (!show && clear && wasVisible) clearBlock(block);
        });
    }

    function syncTabs(tabs, type) {
        tabs.forEach(function (tab) {
            var active = tab.getAttribute('data-registrant') === type;
            tab.classList.toggle('is-active', active);
            tab.setAttribute('aria-selected', active ? 'true' : 'false');
        });
    }

    function init() {
        var select = document.querySelector('[name="' + SELECT_NAME + '"]');
        var group = document.querySelector('[data-registrant-switch]');
        if (!select || !group) return;

        var tabs = Array.prototype.slice.call(group.querySelectorAll('[data-registrant]'));
        var options = Array.prototype.slice.call(select.options).map(function (o) {
            return o.value;
        }).filter(Boolean);

        // Табы описаны в шаблоне, а варианты — в настройках поля WHMCS.
        // Если их перенастроят в админке, показываем селект и уходим:
        // лучше стоковый контрол, чем табы, которые не покрывают все варианты.
        var covered = tabs.every(function (t) {
            return options.indexOf(t.getAttribute('data-registrant')) !== -1;
        });
        if (!covered || options.length !== tabs.length) return;

        select.classList.add(HIDDEN);
        group.classList.remove(HIDDEN);

        function setType(value, fromUser) {
            if (select.value !== value) {
                select.value = value;
                // Нативное событие ловят и делегированные обработчики jQuery,
                // на них держится автозаполнение по УНП (js/egr.js).
                select.dispatchEvent(new Event('change', { bubbles: true }));
            }
            syncTabs(tabs, value);
            applyType(value, fromUser === true);
        }

        tabs.forEach(function (tab) {
            tab.addEventListener('click', function () {
                setType(tab.getAttribute('data-registrant'), true);
            });
        });

        // Значение могли поменять и мимо табов — например, из другого скрипта.
        select.addEventListener('change', function () {
            syncTabs(tabs, select.value);
            applyType(select.value, true);
        });

        setType(select.value || options[0], false);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
}());
