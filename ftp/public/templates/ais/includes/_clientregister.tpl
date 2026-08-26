<style>
.required {
    border-color: red!important;
}
</style>

<script>
// required rules:
        //all = required for all types
        //type1 = resident
        //type2 = nonresident
        //type3 = organization - resident
        //type4 = organization - non-resident
        //type5 = organization - both resident and non-resident
        //type6 = ip - resident
        //type7 = ip - non-resident
        //type8 = ip - both resident and non-resident
        //type9  = person - resident
        //type10 = person - non-resident
        //type11 = person - both resident and non-resident

        //type20 = person+ip - resident
        //type21 = org+ip - resident
        //type22 = person+ip - resident and non-resident
        //type32 = org+ip - resident and non-resident

$(document).ready(function () {
    validationForms('{$LANG.validationRequiredField}');

    // var type = 'person'; //default
    var old_type = "{$cf['registrant_type']['value']}";
    var type = old_type ? old_type : 'person'; //default
    // 234234234E
    var resident = true; //default
    var switcher = $("input[name='customfield[33]']:radio");
    var residency = $("input[name='customfield[39]");
    var hBankBtn = $("#have-ba");
    var hBank = $('.js-bank');
    
    // Функция очистки полей в скрытых секциях
    function clearHiddenFields(selector) {
        $(selector).find('input').not('[type=radio], [type=checkbox], [type=hidden]').val('');
        $(selector).find('select').each(function() {
            // Сбрасываем select на первый option
            $(this).prop('selectedIndex', 0);
        });
    }

    // Функция снятия обязательности и очистки ошибок валидации
    function clearFieldsValidation(selector) {
        $(selector).find('input, select, textarea').each(function() {
            var $field = $(this);
            // Снимаем required
            $field.attr('required', false).removeClass('required');
            // Убираем классы ошибок
            $field.removeClass('error is-invalid has-error');
            // Удаляем сообщения об ошибках
            var $formGroup = $field.closest('.form-group');
            if ($formGroup.length > 0) {
                $formGroup.find('.validation-text, .field-error-msg, .invalid-feedback, .text-danger').hide();
                $formGroup.removeClass('has-error');
            }
        });
    }

    switcher.on('change', function () {
        $('[data-type]').hide();
        $("[data-req*='type']").attr('required', false).removeClass('required');
        var ch = $(this).prop('checked') ? $(this).val() : null;
        switch (ch) {
            case 'person':
                type = 'person';
                $("[data-type*='person']").show();
                // Скрываем паспортные данные и адрес для регистрации без заказа
                $('[data-passport]').hide();
                $('[data-person-address]').hide();
                // Снимаем обязательность со всех полей в скрытых секциях
                clearFieldsValidation('[data-passport]');
                clearFieldsValidation('[data-person-address]');
                // Очищаем скрытые поля
                clearHiddenFields('[data-passport]');
                clearHiddenFields('[data-person-address]');
                break;
            case 'organization':
                type = 'organization';
                $("[data-type*='org']").show();
                $('[data-person-address]').show();
                resident ? req('type3', true) : req('type3', false);
                req('type5', true);
                req('#customfield31', false);
                resident ? req('type21', true) : req('type21', false);
                break;
            case 'ip':
                type = 'ip';
                $("[data-type*='ip']").show();
                $('[data-person-address]').show();
                // Скрываем паспортные данные для регистрации без заказа
                $('[data-passport]').hide();
                // Снимаем обязательность со всех полей паспорта
                clearFieldsValidation('[data-passport]');
                // Очищаем скрытые поля паспорта
                clearHiddenFields('[data-passport]');
                resident ? req('type21', true) : req('type21', false);
                break;
        }
        
        nonResident(resident, type, 'person', 'organization', 'ip');

        var $field = $('.form-control');
        $field.each(function () {
            _validationNotEmpty($(this));
        });

        hBankBtn.trigger('change');
    });

    setTimeout(function(){
        var checkedRadio = $("input[name='customfield[33]']:radio:checked");
        if (checkedRadio.length > 0) {
            type = checkedRadio.val();
        }
        $("input[name='customfield[33]']:radio#" + type).change();
    }, 1);
    
    //residency check, change require on fields depending on it
    residency.on('change', function() {
        this.checked ? resident = true : resident = false;
        $("input[name='customfield[33]']:radio#" + type).change();
        nonResident(resident, type, 'person', 'organization', 'ip');
    });


    function _sameasabove(stField, bField, aField, zField, cField, sField, coField, addressField) {
        var st = stField.val();
        st ? st = st : '';

        var b = bField.val();
        b ? b = ', ' + b : '';

        var a = aField.val();
        a ? a = '-' + a : '';

        var z = zField.val();
        z ? z = ', ' + z : '';

        var c = cField.val();
        c ? c = ', ' + c : '';

        var s = sField.val();
        s ? s = ', ' + s : '';

        var co = coField.find('option:selected').text().trim();
        co ? co = ', ' + co : '';

        addressField.val(st + b + a + z + c + s + co);
    }

    var stField = $('#inputAddress1');      //street
    var bField = $('#customfield36');       //building
    var aField = $('#customfield37');       //apartment
    var zField = $('#inputPostcode');       //postcode
    var cField = $('#inputCity');           //city
    var sField = $('#stateinput');          //state
    var coField = $('#inputCountry');       //country
    var addressField = $('#customfield27'); //full address
    var sameasabove = $("#sameasabove");
    var arrAddress = [stField, bField, aField, zField, cField, sField];

    sameasabove.on('change', function () {
        if($(this).is(':checked')) {
            _sameasabove(stField, bField, aField, zField, cField, sField, coField, addressField);
        } else {
            addressField.val(null);
        }
    });
    $.each(arrAddress, function (index, value) {
        value.on('keyup.autocomplite', function () {
            if (sameasabove.is(':checked')) {
                _sameasabove(stField, bField, aField, zField, cField, sField, coField, addressField);
            }
        });
    });

    coField.on('change', function () {
        if (sameasabove.is(':checked')) {
            _sameasabove(stField, bField, aField, zField, cField, sField, coField, addressField);
        }
    });
    
    function hideShowBank() {
        if (hBankBtn.length && hBank.length) {
            hBankBtn.off('change.bank').on('change.bank', function () {
                if (this.checked) {
                    hBank.show();
                    if (type == 'organization' || type == 'ip') {
                        req('type32', true);
                    }
                }
                else {
                    hBank.hide();
                    req('type32', false);
                }
            });
        }
    }
    hideShowBank();

    residency.prop('checked', true).change();
    

    $("[data-type]:not([data-type*='person'])").hide();
    req("[data-req='all']", true);

    function req(target, val = null) {
        var el;
        if (target.match("^type")) {
            el = $('[data-req=' + target +']');
        } else {
            el = $(target);
        }
        val ? el.attr('required', true).addClass('required') : el.attr('required', false).removeClass('required');
        return;
    }

    var fieldUNP1 = $('#customfield40');
    var fieldUNP2 = $('#customfield11');
    autocompliteField(fieldUNP1, fieldUNP2);

    samepassword($('#inputNewPassword1'), $('#inputNewPassword2'));
});
</script>