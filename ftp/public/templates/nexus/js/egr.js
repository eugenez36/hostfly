/**
 * Автоматическое заполнение названия компании и данных регистрации из ЕГР по УНП
 * version 2.0.0 — адаптация под тему nexus (HOS-15)
 *
 * Что изменилось против 1.2.0, написанной под тему ais:
 * - поля ищутся по ИМЕНИ (customfield[NN]), а не по id и не по обёрткам. В ais у
 *   чекбокса резидентства id был буквально "customfield[39]", в nexus — "customfield39";
 *   привязка по имени работает в обеих темах и переживёт перевёрстку формы в HOS-12;
 * - тип регистранта в ais выбирался радио-кнопками в .registrant_type, в nexus это
 *   обычный select — читаем оба варианта;
 * - поле области: ядро WHMCS (assets/js/StatesDropdown.js) переименовывает
 *   input[name=state] в #stateinput уже после загрузки. Для Беларуси списка областей
 *   в ядре нет, поэтому поле остаётся текстовым и селект #stateselect не создаётся —
 *   пишем в #stateinput с фолбэком на #state;
 * - #sameasabove в nexus отсутствует: ветка сборки почтового адреса просто не сработает,
 *   проверка по length уже была в коде;
 * - ИСПРАВЛЕН дефект: в обработчике blur использовались переменные, объявленные через
 *   const внутри fetchEGRData, из-за чего на каждом blur по заполненному УНП вылетал
 *   ReferenceError и проверка «уже заполнено» не работала;
 * - ИСПРАВЛЕН фолбэк региона: город Минск подставлялся как «Минская область», хотя
 *   город республиканского подчинения в неё не входит.
 *
 * Серверная часть — /egr-proxy.php (в репозитории ftp/public/egr-proxy.php).
 */
(function($) {
    'use strict';

    /**
     * Поиск поля кастомного поля WHMCS по НОМЕРУ.
     * Сначала по имени (одинаково во всех темах и не зависит от вёрстки),
     * затем фолбэк на id — на случай, если разметку соберут иначе.
     * @param {number|string} n - номер кастомного поля
     */
    function cf(n) {
        var $byName = $('[name="customfield[' + n + ']"]');
        return $byName.length ? $byName : $('#customfield' + n);
    }

    /**
     * Поле области. Ядро переименовывает input[name=state] в #stateinput на ready,
     * поэтому проверяем оба варианта.
     */
    function stateField() {
        var $s = $('#stateinput');
        return $s.length ? $s : $('#state');
    }

    /**
     * Получение данных из API ЕГР по УНП
     * Использует локальный PHP-прокси для обхода CORS
     * @param {string} unp - Учётный номер плательщика (9 цифр)
     * @param {string} type - Тип регистранта ('org', 'ip' или 'reginfo')
     * @returns {Promise} Promise с данными о юридическом лице или ИП
     */
    function getEGRDataByUNP(unp, type) {
        // Валидация УНП (должен быть 9 цифр)
        if (!unp || !/^\d{9}$/.test(unp)) {
            return $.Deferred().reject('Некорректный УНП').promise();
        }

        // Используем локальный PHP-прокси
        return $.ajax({
            url: 'egr-proxy.php',
            method: 'GET',
            dataType: 'json',
            timeout: 20000,
            data: {
                unp: unp,
                type: type || 'org'
            }
        }).then(function(response) {
            if (response && response.result === 'success' && response.data) {
                return response;
            }
            return $.Deferred().reject(response).promise();
        });
    }

    /**
     * Парсинг ФИО из строки формата "Фамилия Имя Отчество"
     * @param {string} fullName - Полное ФИО
     * @returns {Object} Объект с полями lastname, firstname, middlename
     */
    function parseFIO(fullName) {
        if (!fullName) {
            return { lastname: '', firstname: '', middlename: '' };
        }

        const parts = fullName.trim().split(/\s+/);
        
        return {
            lastname: parts[0] || '',      // Фамилия
            firstname: parts[1] || '',     // Имя
            middlename: parts[2] || ''     // Отчество
        };
    }

    /**
     * Показать сообщение об ошибке под полем УНП
     * @param {string} message - Текст сообщения
     */
    function showUNPError(message) {
        const $unpInput = cf(40);
        
        // Удаляем предыдущее сообщение, если есть
        $unpInput.siblings('.egr-error-message').remove();
        
        // Добавляем новое сообщение
        $unpInput.after('<div class="egr-error-message text-danger" style="margin-top: 5px; font-size: 0.9em;">' + message + '</div>');
        
        // Подсвечиваем поле красным
        $unpInput.addClass('is-invalid');
    }

    /**
     * Убрать сообщение об ошибке под полем УНП
     */
    function hideUNPError() {
        const $unpInput = cf(40);
        
        // Удаляем сообщение
        $unpInput.siblings('.egr-error-message').remove();
        
        // Убираем подсветку
        $unpInput.removeClass('is-invalid');
    }

    /**
     * Очистка ошибок валидации WHMCS для конкретного поля
     * @param {jQuery} $field - jQuery объект input поля
     */
    function clearValidationError($field) {
        if (!$field || $field.length === 0) {
            return;
        }

        // Убираем класс ошибки с поля (используется в WHMCS validation)
        $field.removeClass('error is-invalid has-error');
        
        // Удаляем сообщения об ошибках, добавленные WHMCS валидацией
        const $formGroup = $field.closest('.form-group');
        if ($formGroup.length > 0) {
            $formGroup.find('.js-validation-text').remove();
            $formGroup.find('.field-error-msg, .invalid-feedback, .text-danger').remove();
            $formGroup.removeClass('has-error');
        }
    }

    /**
     * Установка состояния загрузки для списка полей
     * @param {Array<jQuery>} fields - Массив jQuery объектов полей
     * @param {boolean} loading - true для включения загрузки, false для выключения
     */
    function setFieldsLoadingState(fields, loading) {
        fields.forEach(function($field) {
            if (!$field || $field.length === 0) {
                return;
            }
            
            if (loading) {
                // Сохраняем текущее значение поля в data-атрибут
                const currentValue = $field.val();
                if (currentValue !== 'Загрузка из ЕГР...') {
                    $field.data('original-value', currentValue);
                }
                $field.prop('disabled', true).val('Загрузка из ЕГР...');
            } else {
                // Восстанавливаем значение поля
                if ($field.val() === 'Загрузка из ЕГР...') {
                    const originalValue = $field.data('original-value') || '';
                    $field.val(originalValue);
                    $field.removeData('original-value');
                }
                $field.prop('disabled', false);
            }
        });
    }

    /**
     * Определение текущего типа регистранта
     * @returns {string} 'person', 'org' или 'ip'
     */
    function getCurrentRegistrantType() {
        // ais: радио-кнопки в .registrant_type
        const $activeBtn = $('.registrant_type .btn.active input[type="radio"]');
        if ($activeBtn.length > 0) {
            return $activeBtn.val();
        }
        // nexus: обычный select с теми же значениями person / organization / ip
        const $typeField = cf(33);
        if ($typeField.length > 0) {
            const value = ($typeField.filter(':checked').length
                ? $typeField.filter(':checked').val()
                : $typeField.val()) || '';
            if (value) {
                return value;
            }
        }
        return 'person'; // По умолчанию
    }

    /**
     * Автозаполнение полей при вводе УНП
     */
    function initUNPAutoFill() {
        const $unpInput = cf(40);
        
        if ($unpInput.length === 0) {
            return;
        }

        let requestTimer = null;

        // Функция выполнения запроса к ЕГР (теперь один запрос возвращает все данные)
        function fetchEGRData(unp) {
            const registrantType = getCurrentRegistrantType();
            
            // Определяем, какие поля заполнять
            const isOrganization = registrantType === 'organization';
            const isIP = registrantType === 'ip';
            
            if (!isOrganization && !isIP) {
                // Для физ.лиц не делаем запрос
                return;
            }

            // Проверяем, включен ли чекбокс "Резидент РБ" (customfield[39])
            const $residentCheckbox = cf(39);
            if ($residentCheckbox.length === 0 || !$residentCheckbox.is(':checked')) {
                // Чекбокс не включен - не делаем автозагрузку из ЕГР
                return;
            }

            // Убираем предыдущие ошибки
            hideUNPError();

            // Определяем тип запроса
            const requestType = isIP ? 'ip' : 'org';

            // Получаем элементы полей непосредственно перед использованием
            // (они могут быть скрыты при инициализации и появляться динамически)
            const $companyNameInput = $('#inputCompanyName');
            const $firstNameInput = $('#inputFirstName');
            const $middleNameInput = cf(42);
            const $lastNameInput = $('#inputLastName');
            
            // Поля регистрационных данных (ЕГР)
            const $egrNumInput = cf(11);                   // Номер в ЕГР
            const $egrOrgInput = cf(12);                   // Орган регистрации
            const $egrDateInput = cf(13);                  // Дата регистрации
            
            // Поля юридического адреса
            const $countryInput = $('#inputCountry');      // Страна
            const $stateInput = stateField();              // Область/район
            const $cityInput = $('#inputCity');            // Город
            const $address1Input = $('#inputAddress1');    // Улица
            const $houseInput = cf(36);                    // Дом
            const $roomInput = cf(37);                     // Помещение

            // Собираем все поля, которые будут блокироваться
            const fieldsToBlock = [];
            
            // Поля для организаций
            if (isOrganization && $companyNameInput.length > 0) {
                fieldsToBlock.push($companyNameInput);
            }
            
            // Поля для ИП
            if (isIP) {
                if ($firstNameInput.length > 0) fieldsToBlock.push($firstNameInput);
                if ($middleNameInput.length > 0) fieldsToBlock.push($middleNameInput);
                if ($lastNameInput.length > 0) fieldsToBlock.push($lastNameInput);
            }
            
            // Поля регистрационных данных (для всех типов)
            if ($egrNumInput.length > 0) fieldsToBlock.push($egrNumInput);
            if ($egrOrgInput.length > 0) fieldsToBlock.push($egrOrgInput);
            if ($egrDateInput.length > 0) fieldsToBlock.push($egrDateInput);
            
            // Поля адреса (только для организаций)
            if (isOrganization) {
                if ($countryInput.length > 0) fieldsToBlock.push($countryInput);
                if ($stateInput.length > 0) fieldsToBlock.push($stateInput);
                if ($cityInput.length > 0) fieldsToBlock.push($cityInput);
                if ($address1Input.length > 0) fieldsToBlock.push($address1Input);
                if ($houseInput.length > 0) fieldsToBlock.push($houseInput);
                if ($roomInput.length > 0) fieldsToBlock.push($roomInput);
            }

            // Включаем состояние загрузки
            setFieldsLoadingState(fieldsToBlock, true);

            // Делаем единственный запрос, который вернет все данные
            getEGRDataByUNP(unp, requestType)
                .done(function(response) {
                    if (response.type === 'org') {
                        // Заполняем название компании
                        const companyName = response.data.vn || response.data.vnaim || '';
                        if (companyName && $companyNameInput.length > 0) {
                            $companyNameInput.val(companyName);
                            clearValidationError($companyNameInput);
                        }
                        
                        // Заполняем юридический адрес (только если страна = Республика Беларусь)
                        if (response.data.vnstranp === 'Республика Беларусь') {
                            // Страна
                            if ($countryInput.length > 0) {
                                $countryInput.val('BY');
                                clearValidationError($countryInput);
                                // Триггерим change для обновления списка областей
                                $countryInput.trigger('change');
                            }
                            
                            // Область + район
                            if ($stateInput.length > 0) {
                                let stateValue = '';
                                let regionName = response.data.vregion;
                                
                                // Если регион пуст, пытаемся определить по городу
                                if (!regionName && response.data.vnp) {
                                    const cityName = response.data.vnp;
                                    const cityToRegion = {
                                        'Брест': 'Брестская',
                                        'Витебск': 'Витебская',
                                        'Могилёв': 'Могилёвская',
                                        'Гомель': 'Гомельская',
                                        'Гродно': 'Гродненская'
                                    };
                                    // Минск — город республиканского подчинения и
                                    // в Минскую область не входит, поэтому отдельно.
                                    if (cityName === 'Минск') {
                                        stateValue = 'г. Минск';
                                    } else {
                                        regionName = cityToRegion[cityName] || '';
                                    }
                                }
                                
                                if (regionName) {
                                    stateValue = regionName + ' область';
                                }
                                if (response.data.vdistrict) {
                                    stateValue += (stateValue ? ' ' : '') + response.data.vdistrict + ' район';
                                }
                                if (stateValue) {
                                    $stateInput.val(stateValue.trim());
                                    clearValidationError($stateInput);
                                }
                            }
                            
                            // Город (тип нас. пункта + название)
                            if ($cityInput.length > 0) {
                                let cityValue = '';
                                if (response.data.vntnpk && response.data.vnp) {
                                    cityValue = response.data.vntnpk + ' ' + response.data.vnp;
                                } else if (response.data.vnp) {
                                    cityValue = response.data.vnp;
                                }
                                if (cityValue) {
                                    $cityInput.val(cityValue.trim());
                                    clearValidationError($cityInput);
                                }
                            }
                            
                            // Улица (тип улицы + название)
                            if ($address1Input.length > 0) {
                                let address1Value = '';
                                if (response.data.vntulk && response.data.vulitsa) {
                                    address1Value = response.data.vntulk + ' ' + response.data.vulitsa;
                                } else if (response.data.vulitsa) {
                                    address1Value = response.data.vulitsa;
                                }
                                if (address1Value) {
                                    $address1Input.val(address1Value.trim());
                                    clearValidationError($address1Input);
                                }
                            }
                            
                            // Дом
                            if ($houseInput.length > 0 && response.data.vdom) {
                                $houseInput.val(response.data.vdom);
                                clearValidationError($houseInput);
                            }
                            
                            // Помещение (тип помещения + номер)
                            if ($roomInput.length > 0) {
                                let roomValue = '';
                                if (response.data.vntpomk && response.data.vpom) {
                                    roomValue = response.data.vntpomk + ' ' + response.data.vpom;
                                } else if (response.data.vpom) {
                                    roomValue = response.data.vpom;
                                }
                                if (roomValue) {
                                    $roomInput.val(roomValue.trim());
                                    clearValidationError($roomInput);
                                }
                            }
                            
                            // Триггерим обновление почтового адреса (customfield27)
                            // после заполнения всех полей юр. адреса
                            setTimeout(function() {
                                const sameasabove = $('#sameasabove');
                                if (sameasabove.length > 0 && sameasabove.is(':checked')) {
                                    sameasabove.trigger('change');
                                }
                            }, 100);
                        }
                    } else if (response.type === 'ip') {
                        // Парсим и заполняем ФИО
                        const fio = parseFIO(response.data.vfio);
                        if ($lastNameInput.length > 0) {
                            $lastNameInput.val(fio.lastname);
                            clearValidationError($lastNameInput);
                        }
                        if ($firstNameInput.length > 0) {
                            $firstNameInput.val(fio.firstname);
                            clearValidationError($firstNameInput);
                        }
                        if ($middleNameInput.length > 0) {
                            $middleNameInput.val(fio.middlename);
                            clearValidationError($middleNameInput);
                        }
                    }
                    
                    // Заполняем регистрационные данные (доступны для обоих типов)
                    if (response.data) {
                        // Заполняем номер в ЕГР
                        if ($egrNumInput.length > 0 && response.data.ngrn) {
                            $egrNumInput.val(response.data.ngrn);
                            clearValidationError($egrNumInput);
                        }
                        // Заполняем орган регистрации
                        if ($egrOrgInput.length > 0 && response.data.vnuzp) {
                            $egrOrgInput.val(response.data.vnuzp);
                            clearValidationError($egrOrgInput);
                        }
                        // Заполняем дату регистрации
                        if ($egrDateInput.length > 0 && response.data.dfrom) {
                            $egrDateInput.val(response.data.dfrom);
                            clearValidationError($egrDateInput);
                        }
                    }
                })
                .fail(function(errorData) {
                    console.warn('Ошибка получения данных из ЕГР:', errorData);
                    
                    // Проверяем, это объект ошибки от нашего then() обработчика
                    if (errorData && typeof errorData === 'object' && errorData.result === 'error') {
                        const errorType = errorData.errorType;
                        const errorMessage = errorData.message;
                        
                        // Показываем специфичное сообщение об ошибке
                        if (errorType === 'not_found') {
                            showUNPError('Такой УНП отсутствует в ЕГР');
                        } else if (errorType === 'inactive') {
                            showUNPError('Лицо с таким УНП не является действующим');
                        } else if (errorMessage) {
                            // Общая ошибка с сервера
                            showUNPError(errorMessage);
                        }
                    }
                    // Или это реальная AJAX ошибка с responseJSON
                    else if (errorData && errorData.responseJSON && errorData.responseJSON.result === 'error') {
                        const errorType = errorData.responseJSON.errorType;
                        const errorMessage = errorData.responseJSON.message;
                        
                        if (errorType === 'not_found') {
                            showUNPError('Такой УНП отсутствует в ЕГР');
                        } else if (errorType === 'inactive') {
                            showUNPError('Лицо с таким УНП не является действующим');
                        } else if (errorMessage) {
                            showUNPError(errorMessage);
                        }
                    }
                })
                .always(function() {
                    // Выключаем состояние загрузки для всех полей
                    setFieldsLoadingState(fieldsToBlock, false);
                });
        }

        // Обработчик ввода УНП с задержкой
        $unpInput.on('input', function() {
            const unp = $(this).val().trim();
            
            // Убираем предыдущие ошибки при каждом изменении
            hideUNPError();
            
            // Очищаем предыдущий таймер
            if (requestTimer) {
                clearTimeout(requestTimer);
            }

            // Проверяем, введено ли 9 цифр
            if (!/^\d{9}$/.test(unp)) {
                return;
            }

            // Небольшая задержка перед запросом (500ms после окончания ввода)
            requestTimer = setTimeout(function() {
                fetchEGRData(unp);
            }, 500);
        });

        // Обработчик потери фокуса - запрос сразу
        $unpInput.on('blur', function() {
            const unp = $(this).val().trim();
            
            if (!/^\d{9}$/.test(unp)) {
                return;
            }

            const registrantType = getCurrentRegistrantType();

            // Поля резолвим здесь же. В версии 1.2.0 тут использовались переменные
            // из области видимости fetchEGRData — на каждом blur был ReferenceError,
            // и проверка «уже заполнено» никогда не срабатывала.
            const $egrNum = cf(11);
            const $companyName = $('#inputCompanyName');
            const $lastName = $('#inputLastName');

            function filled($f) {
                return $f.length > 0 &&
                       $f.val().trim() !== '' &&
                       $f.val().indexOf('Загрузка') !== 0;
            }

            const egrFieldsFilled = filled($egrNum);

            if (registrantType === 'organization' && filled($companyName) && egrFieldsFilled) {
                // Все поля уже заполнены
                return;
            }

            if (registrantType === 'ip' && filled($lastName) && egrFieldsFilled) {
                // Все поля уже заполнены
                return;
            }

            // Очищаем таймер и делаем запрос сразу
            if (requestTimer) {
                clearTimeout(requestTimer);
                requestTimer = null;
            }

            fetchEGRData(unp);
        });

        // Смена типа регистранта: в ais это клик по радио-кнопке в .registrant_type,
        // в nexus — change на select. Делегируем на document, чтобы пережить
        // перерисовку формы.
        $(document).on('click', '.registrant_type .btn', function() {
            retryAfterChange();
        });
        $(document).on('change', '[name="customfield[33]"]', function() {
            retryAfterChange();
        });

        function retryAfterChange() {
            const unp = $unpInput.val().trim();

            if (!/^\d{9}$/.test(unp)) {
                return;
            }

            // Небольшая задержка, чтобы дождаться обновления UI
            setTimeout(function() {
                fetchEGRData(unp);
            }, 100);
        }

        // Обработчик изменения чекбокса "Резидент РБ" (customfield[39])
        $(document).on('change', '[name="customfield[39]"]', function() {
            const unp = $unpInput.val().trim();
            
            if (!/^\d{9}$/.test(unp)) {
                return;
            }

            // Если чекбокс включен и УНП введен - делаем запрос к ЕГР
            if ($(this).is(':checked')) {
                setTimeout(function() {
                    fetchEGRData(unp);
                }, 100);
            }
        });
    }

    // Инициализация при загрузке DOM
    $(document).ready(function() {
        initUNPAutoFill();
    });

})(jQuery);
