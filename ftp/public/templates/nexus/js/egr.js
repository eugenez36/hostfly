/**
 * Автоматическое заполнение названия компании и данных регистрации из ЕГР по УНП
 * version 1.2.0
 * - Добавлено автоматическое заполнение юридического адреса для организаций
 * - Исправлена очистка ошибок валидации WHMCS (класс 'error' и .js-validation-text)
 * - Централизовано управление состоянием загрузки полей
 */
(function($) {
    'use strict';

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
        const $unpInput = $('#customfield40');
        
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
        const $unpInput = $('#customfield40');
        
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
        const $activeBtn = $('.registrant_type .btn.active input[type="radio"]');
        if ($activeBtn.length > 0) {
            return $activeBtn.val();
        }
        return 'person'; // По умолчанию
    }

    /**
     * Автозаполнение полей при вводе УНП
     */
    function initUNPAutoFill() {
        const $unpInput = $('#customfield40');
        
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
            const $residentCheckbox = $('#customfield\\[39\\]');
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
            const $middleNameInput = $('#customfield42');
            const $lastNameInput = $('#inputLastName');
            
            // Поля регистрационных данных (ЕГР)
            const $egrNumInput = $('#customfield11');      // Номер в ЕГР
            const $egrOrgInput = $('#customfield12');      // Орган регистрации
            const $egrDateInput = $('#customfield13');     // Дата регистрации
            
            // Поля юридического адреса
            const $countryInput = $('#inputCountry');      // Страна
            const $stateInput = $('#stateinput');          // Область/район
            const $cityInput = $('#inputCity');            // Город
            const $address1Input = $('#inputAddress1');    // Улица
            const $houseInput = $('#customfield36');       // Дом
            const $roomInput = $('#customfield37');        // Помещение

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
                                        'Минск': 'Минская',
                                        'Брест': 'Брестская',
                                        'Витебск': 'Витебская',
                                        'Могилёв': 'Могилёвская',
                                        'Гомель': 'Гомельская',
                                        'Гродно': 'Гродненская'
                                    };
                                    regionName = cityToRegion[cityName] || '';
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
            
            // Проверяем, не заполнены ли уже целевые поля компании/ФИО и ЕГР данные
            const egrFieldsFilled = $egrNumInput.length > 0 && 
                                   $egrNumInput.val().trim() !== '' && 
                                   $egrNumInput.val() !== 'Загрузка...';
            
            if (registrantType === 'organization' && 
                $companyNameInput.length > 0 && 
                $companyNameInput.val().trim() !== '' && 
                $companyNameInput.val() !== 'Загрузка...' &&
                egrFieldsFilled) {
                // Все поля уже заполнены
                return;
            }
            
            if (registrantType === 'ip' && 
                $lastNameInput.length > 0 && 
                $lastNameInput.val().trim() !== '' && 
                $lastNameInput.val() !== 'Загрузка...' &&
                egrFieldsFilled) {
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

        // Обработчик смены типа регистранта - делаем запрос, если УНП уже введен
        $('.registrant_type .btn').on('click', function() {
            const unp = $unpInput.val().trim();
            
            if (!/^\d{9}$/.test(unp)) {
                return;
            }

            // Небольшая задержка, чтобы дождаться обновления UI
            setTimeout(function() {
                fetchEGRData(unp);
            }, 100);
        });

        // Обработчик изменения чекбокса "Резидент РБ" (customfield[39])
        $(document).on('change', '#customfield\\[39\\]', function() {
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
