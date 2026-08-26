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
    

    switcher.on('change', function () {
        $('[data-type]').hide();
        $("[data-req*='type']").attr('required', false).removeClass('required');
        var ch = $(this).prop('checked') ? $(this).val() : null;
        switch (ch) {
        case 'person':
            type = 'person';
            $("[data-type*='person']").show();
            resident ? req('type20', true) : req('type20', false);
            req('type22', true);// always required for 'person' type
            // resident ? req('#customfield31', true) : req('#customfield31', false);
            break;
        case 'organization':
            type = 'organization';
            $("[data-type*='org']").show();
            // $("#have-ba").attr('checked', true).change();
            resident ? req('type3', true) : req('type3', false);
            req('type5', true);// always required for 'organization' type
            req('#customfield31', false);
            resident ? req('type21', true) : req('type21', false);
            break;
        case 'ip':
            type = 'ip';
            $("[data-type*='ip']").show();
            resident ? req('type20', true) : req('type20', false);
            req('type22', true);// always required for 'person' type
            resident ? req('type21', true) : req('type21', false);
            resident ? req('type6', true) : req('type6', false);
            break;
        }
        nonResident(resident, type, 'person', 'organization', 'ip');

        var $field = $('.form-control');
        $field.each(function () {
            var self = $(this);
            _validationNotEmpty(self);
        });

        hBankBtn.trigger('change');
    });

    setTimeout(function(){
        $("input[name='customfield[33]']:radio#" + type).change();
    }, 1);
    
    //residency check, change require on fields depending on it
    residency.on('change', function() {
        this.checked ? resident = true : resident = false;
        $("input[name='customfield[33]']:radio#" + type).change();
        nonResident(resident, type, 'person', 'organization', 'ip');
    });


    function _sameasabove(stField, bField, aField, zField, cField, sField, coField, addressField) {
        var st = '{$LANG.orderForm.mailingAddressSt} ' + stField.val();
        var b = bField.val();
        b ? b = ', ' + b : '';

        var a = aField.val();
        a ? a = '-' + a : '';

        var z = zField.val();
        z ? z = ', ' + z : '';

        var c = cField.val();
        c ? c = ', {$LANG.orderForm.mailingAddressCity} ' + c : '';

        var s = sField.val();
        s ? s = ', ' + s : '';

        var co = coField.val();
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