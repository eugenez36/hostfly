{* DEMO STYLE ONLY! *}
<style>
.prepend-icon, .prepend-icon .form-control {
    -webkit-appearance: none;
}
.field-icon i {
    color: #bbb;
}
</style>

{assign var=cf value=array_column($customfields, null, 'name')}
{* {$cf|print_r} *}

{* {$clientsdetails|@print_r} *}
{function name=getRegType}
    {if $rType eq "person"}
        {$LANG.xrrp.person}
    {elseif $rType eq "organization"}
        {$LANG.xrrp.organization}
    {elseif $rType eq "ip"}
        {$LANG.xrrp.ip}
    {else}
        undefined
    {/if}
{/function}

{function name=yesNo}
    {if $val eq "on"}
        {$LANG.orderForm.yes}
    {else}
        {$LANG.orderForm.no}
    {/if}
{/function}

{* DEMO SCRIPT FOR TOGGLE AND SORTING *}
<script>
// required rules
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
        //type22 = person+ip - all

//ALLOW rules
/*
Физлицо ALLOW:
phone, Адрес, Почтовый адрес

Юрлицо ALLOW:
phone, Адрес, Почтовый адрес, Банковские реквизиты
ФИО руководителя
Уполномоченное лицо на заключение договора


ИП ALLOW:
phone, Адрес, Почтовый адрес, Банковские реквизиты
*/
$(document).ready(function () {
    validationForms('{$LANG.validationRequiredField}');

    var type = '{$cf.registrant_type.value}';
    var resident = '';
    var rb_resident = '{$cf.rb_resident.value}';

    rb_resident == 'on' ? resident = true : resident = false;

    $('[data-type]').hide();
    $("[data-req*='type']").attr('required', false).removeClass('required');
    $('.js-bank').hide();
    $('#country').attr('data-req', 'all');
    req("[data-req='all']", true);
    dis("[data-dis='1']", true);

    $("#have-ba").change(function() {
        this.checked ? $('.js-bank').show() : $('.js-bank').hide();
    });

    function checkType(user) {
        switch (user) {
        case 'person':
            $("[data-type*='person']").show();
            resident ? req('type20', true) : req('type20', false);
            req('type22', true);
            break;
        case 'organization':
            $("[data-type*='org']").show();
            $("#have-ba").attr('checked', true).change();
            resident ? req('type3', true) : req('type3', false);
            req('type5', true);
            resident ? req('type21', true) : req('type21', false);
            break;
        case 'ip':
            $("[data-type*='ip']").show();
            resident ? req('type20', true) : req('type20', false);
            req('type22', true);
            resident ? req('type21', true) : req('type21', false);
            break;
        }
    }

    checkType(type);

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

    function dis(target, val = null) {
        val ? $(target).attr('readonly', true).addClass('disabled') : $(target).attr('readonly', false).removeClass('disabled');
        return;
    }

    var nresident = $('.field-resident');
    if (nresident.length && !resident) {
      nresident.each(function () {
        $(this).hide();
      });
    }

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
    var sField = $('#state');          //state
    var coField = $('#country');       //country
    var addressField = $('#customfield27'); //full address
    var sameasabove = $("#sameasabove");
    var arrAddress = [stField, bField, aField, zField, cField, sField];

    sameasabove.change(function() {
        if(this.checked) {
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
});
</script>
{if $successful}
    {include file="$template/includes/alert.tpl" type="success" msg=$LANG.changessavedsuccessfully textcenter=true}
{/if}

{if $errormessage}
    {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
{/if}

{* {$clientemail|print_r} *}
{* {$clientsdetails.email|print_r} *}

<script type="text/javascript" src="{$BASE_PATH_JS}/StatesDropdown.js"></script>

<div class="mb-3">
    <form class="validation-form" method="post" action="?action=details" role="form">
        <input type="hidden" name="customfield[33]" id="customfield33" value="{$cf.registrant_type.value}" />
        <input type="hidden" name="customfield[39]" id="customfield39" value="{$cf.rb_resident.value}" />
        <input type="hidden" name="customfield[41]" id="customfield41" value="{$cf.reseller.value}" />

        {*is Resident and Type*}

        <div class="row">
            <div class="col-sm-3">
                <p class="form-group"><b class="mr-1">{$LANG.orderForm.isRBresident}</b> <span class="label label-primary">{yesNo val=$cf.rb_resident.value}</span></p>
            </div>
            {if $cf.reseller.value eq "on"}
                <div class="col-sm-6">
                    <p class="form-group"><b class="mr-1">{$LANG.xrrp.r_type}</b> <span class="label label-primary">{getRegType rType=$cf.registrant_type.value}</span></p>
                </div>
                <div class="col-sm-3">
                    <p class="form-group"><b class="mr-1">{$LANG.orderForm.reseller}</b> <span class="label label-primary">{$LANG.orderForm.yes}</span></p>
                </div>
            {else}
                <div class="col-sm-9">
                    <p class="form-group"><b class="mr-1">{$LANG.xrrp.r_type}</b> <span class="label label-primary">{getRegType rType=$cf.registrant_type.value}</span></p>
                </div>
            {/if}
        </div>

        <div class="row">
            <div class="col-sm-6">
                <div class="form-group mb-0">
                    <label for="inputPaymentMethod" class="control-label">{$LANG.paymentmethod}</label>
                    <select name="paymentmethod" id="inputPaymentMethod" class="form-control">
                        <option value="none">{$LANG.paymentmethoddefault}</option>
                        {foreach from=$paymentmethods item=method}
                            <option value="{$method.sysname}"{if $method.sysname eq $defaultpaymentmethod} selected="selected"{/if}>{$method.name}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
        </div>

        <hr>

        {*Company name*}

        <div class="sub-heading" data-type="org">
            <span>{$LANG.orderForm.companyName}</span>
        </div>

        <div class="row">
            <div class="col-sm-6 mb-3" data-type="org">
                <div class="form-group prepend-icon">
                    <label for="inputCompanyName" class="field-icon">
                        <i class="fas fa-building"></i>
                    </label>
                    <input type="text" name="companyname" id="inputCompanyName" class="form-control" data-valid="text" placeholder="{$LANG.orderForm.companyName}" value="{$clientcompanyname}" data-req="type5"  data-dis="1">
                    <span class="validation-text">{$LANG.orderForm.validationCompany}</span>
                </div>
            </div>
        </div>

        {*Pesonal/Registration information*}

        <div class="sub-heading mt-0">
            <span data-type="person,ip">{$LANG.orderForm.personalInformation}</span>
            <span data-type="org">{$LANG.orderForm.registrationInformation}</span>
        </div>

        <div class="row">
            <div class="col-sm-4" data-type="person,ip">
                <div class="form-group prepend-icon">
                    <label for="inputFirstName" class="field-icon">
                        <i class="fas fa-user"></i>
                    </label>
                    <input type="text" name="firstname" id="inputFirstName" class="form-control" data-valid="name" placeholder="{$LANG.orderForm.firstName}" value="{$clientfirstname}" data-req="type20" data-dis="1">
                    <span class="validation-text">{$LANG.orderForm.validationName}</span>
                </div>
            </div>
            <div class="col-sm-4" data-type="person,ip">
                <div class="form-group prepend-icon">
                    <label for="customfield42" class="field-icon">
                        <i class="fas fa-user"></i>
                    </label>
                    <input type="text" name="customfield[42]" id="customfield42" class="form-control" data-valid="name" placeholder="{$LANG.orderForm.middleName}" value="{$cf.mname.value}" data-req="type20" data-dis="1">
                    <span class="validation-text">{$LANG.orderForm.validationName}</span>
                </div>
            </div>
            <div class="col-sm-4" data-type="person,ip">
                <div class="form-group prepend-icon">
                    <label for="inputLastName" class="field-icon">
                        <i class="fas fa-user"></i>
                    </label>
                    <input type="text" name="lastname" id="inputLastName" class="form-control" data-valid="name" placeholder="{$LANG.orderForm.lastName}" value="{$clientlastname}" data-req="type20" data-dis="1">
                    <span class="validation-text">{$LANG.orderForm.validationName}</span>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="form-group prepend-icon">
                    <label for="inputEmail" class="field-icon">
                        <i class="fas fa-envelope"></i>
                    </label>
                    <input type="email" name="email" id="inputEmail" class="form-control" data-valid="email" placeholder="{$LANG.orderForm.emailAddress}" value="{$clientsdetails.email}" data-req="all" data-dis="1">
                    <span class="validation-text">{$LANG.orderForm.validationEmail}</span>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="form-group prepend-icon mask-phone">
                    <label for="inputPhone" class="field-icon">
                        <i class="fas fa-phone"></i>
                    </label>
                    <input type="tel" name="phonenumber" id="inputPhone" class="form-control" data-valid="phone" placeholder="{$LANG.orderForm.phoneNumber}" value="{$clientphonenumber}" data-req="all">
                    <span class="validation-text">{$LANG.orderForm.validationText}</span>
                </div>
            </div>
            {if $cf.r_chief}
                <div class="col-sm-6" data-type="org">
                    <div class="form-group prepend-icon">
                        <label for="customfield[35]" class="field-icon">
                            <i class="fas fa-user"></i>
                        </label>
                        <input type="text" name="customfield[35]" id="customfield35" class="form-control" data-valid="name" placeholder="{$LANG.xrrp.r_chief}" value="{$cf.r_chief.value}" data-req="type5">
                        <span class="validation-text">{$LANG.orderForm.validationName}</span>
                    </div>
                </div>
            {/if}
            {if $cf.org_position}
                <div class="col-sm-6" data-type="org">
                    <div class="form-group prepend-icon">
                        <label for="customfield[8]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[8]" id="customfield8" class="form-control" data-valid="name" placeholder="{$LANG.orderForm.org.position}" value="{$cf.org_position.value}" data-req="type5">
                        <span class="validation-text">{$LANG.orderForm.validationName}</span>
                    </div>
                </div>
            {/if}
            {if $cf.org_doc}
                <div class="col-sm-6" data-type="org">
                    <div class="form-group prepend-icon">
                        <label for="customfield[9]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[9]" id="customfield9" class="form-control" data-valid="text" placeholder="{$LANG.orderForm.org.doc}" value="{$cf.org_doc.value}" data-req="type5">
                        <span class="validation-text">{$LANG.orderForm.validationCompany}</span>
                    </div>
                </div>
            {/if}
        </div>

        {*Registration address/Legal address*}

        <div class="sub-heading">
            <span data-type="person">{$LANG.orderForm.regAddress}</span>
            <span data-type="org,ip">{$LANG.orderForm.legalAddress}</span>
        </div>

        {* {if in_array('phonenumber',$uneditablefields)} disabled=""{/if} *}
        <div class="row">
            <div class="col-sm-5">
                <div class="form-group prepend-icon js-inputCountry">
                    <label for="country" class="field-icon" id="inputCountryIcon">
                        <i class="fas fa-globe"></i>
                    </label>
                    {$clientcountriesdropdown}
                </div>
            </div>

            <div class="col-sm-4">
                <div class="form-group prepend-icon">
                    <label for="state" class="field-icon" id="inputStateIcon">
                        <i class="fas fa-map-signs"></i>
                    </label>
                    <input type="text" name="state" id="state" class="form-control" data-valid="region" placeholder="{$LANG.orderForm.state}" value="{$clientstate}" data-req="all">
                    <span class="validation-text">{$LANG.orderForm.validationRegion}</span>
                </div>
            </div>

            <div class="col-sm-3">
                <div class="form-group prepend-icon">
                    <label for="inputPostcode" class="field-icon">
                        <i class="fas fa-certificate"></i>
                    </label>
                    <input type="text" name="postcode" id="inputPostcode" class="form-control" data-valid="letnum" maxlength="6" placeholder="{$LANG.orderForm.postcode}" value="{$clientpostcode}" data-req="all">
                    <span class="validation-text">{$LANG.orderForm.validationPostcode}</span>
                </div>
            </div>

            <div class="col-sm-3">
                <div class="form-group prepend-icon">
                    <label for="inputCity" class="field-icon">
                        <i class="far fa-building"></i>
                    </label>
                    <input type="text" name="city" id="inputCity" class="form-control" data-valid="text" placeholder="{$LANG.orderForm.city}" value="{$clientcity}" data-req="all">
                    <span class="validation-text">{$LANG.orderForm.validationCity}</span>
                </div>
            </div>

            <div class="col-sm-4">
                <div class="form-group prepend-icon">
                    <label for="inputAddress1" class="field-icon">
                        <i class="far fa-building"></i>
                    </label>
                    <input type="text" name="address1" id="inputAddress1" class="form-control" data-valid="text" placeholder="{$LANG.orderForm.streetAddress}" value="{$clientaddress1}" data-req="all">
		    <input name="address2" id="inputAddress2" class="form-control" data-valid="text" placeholder="" value="-" type="hidden">
	            <span class="validation-text">{$LANG.orderForm.validationStreet}</span>
                </div>
            </div>

            {if $cf.building}
                <div class="col-sm-3">
                    <div class="form-group prepend-icon">
                        <label for="customfield[36]" class="field-icon">
                            <i class="fas fa-road"></i>
                        </label>
                        <input type="text" name="customfield[36]" id="customfield36" class="form-control" data-valid="text" placeholder="{$LANG.orderForm.building}" value="{$cf.building.value}" data-req="all">
                        <span class="validation-text">{$LANG.orderForm.validationHome}</span>
                    </div>
                </div>
            {/if}

            {if $cf.office}
                <div class="col-sm-2">
                    <div class="form-group prepend-icon">
                        <label for="customfield[37]" class="field-icon">
                            <i class="fas fa-qrcode"></i>
                        </label>
                        <input type="text" name="customfield[37]" id="customfield37" class="form-control" data-valid="text" placeholder="{$LANG.orderForm.office}" value="{$cf.office.value}" data-req="all">
                        <span class="validation-text">{$LANG.orderForm.validationOffice}</span>
                    </div>
                </div>
            {/if}

            {if $cf.landline}
                <div class="col-sm-6" data-type="org,ip">
                    <div class="form-group prepend-icon">
                        <label for="customfield[25]" class="field-icon">
                            <i class="fas fa-phone"></i>
                        </label>
                        <input type="text" name="customfield[25]" id="customfield25" class="form-control" data-valid="phone" placeholder="{$LANG.orderForm.landline}" value="{$cf.landline.value}">
                        <span class="validation-text">{$LANG.orderForm.validationText}</span>
                    </div>
                </div>
            {/if}

            {if $cf.fax}
                <div class="col-sm-6" data-type="org,ip">
                    <div class="form-group prepend-icon">
                        <label for="customfield[26]" class="field-icon">
                            <i class="fas fa-qrcode"></i>
                        </label>
                        <input type="text" name="customfield[26]" id="customfield26" class="form-control" data-valid="phone" placeholder="{$LANG.orderForm.fax}" value="{$cf.fax.value}">
                        <span class="validation-text">{$LANG.orderForm.validationText}</span>
                    </div>
                </div>
            {/if}
        </div>

        {*Mailling address*}

        <div class="sub-heading">
            <span>{$LANG.orderForm.mailingAddress}</span>
        </div>

        <div class="row">
            <div class="col-sm-12">
                <div class="form-group">
                    <div class="onoffswitch">
                        <input class="onoffswitch-checkbox" type="checkbox" name="sameasabove" id="sameasabove" checked>
                        <label for="sameasabove" class="onoffswitch-label">
                            <span class="onoffswitch-inner"></span>
                        </label>
                        <span class="onoffswitch-label-off">{$LANG.orderForm.mailingAddressSame}</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            {if $cf.mail_address}
                <div class="col-sm-12">
                    <div class="form-group prepend-icon">
                        <label for="customfield[27]" class="field-icon">
                            <i class="fas fa-map"></i>
                        </label>
                        <input type="text" name="customfield[27]" id="customfield27" class="form-control" data-valid="text" placeholder="{$LANG.orderForm.mailingAddressPlaceholder}" value="{$cf.mail_address.value}" data-req="all">
                        <span class="validation-text">{$LANG.orderForm.validationText}</span>
                    </div>
                </div>
            {/if}
        </div>

        {*Уполномоченное лицо на заключение договора*}

        {*<div class="sub-heading" data-type="org">
            <span>{$LANG.orderForm.org.org}</span>
        </div>*}

        <div class="row" data-type="org">
            {*if $cf.org_firstname}
                <div class="col-sm-4">
                    <div class="form-group prepend-icon">
                        <label for="customfield[4]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[4]" id="customfield4" class="form-control" placeholder="{$LANG.orderForm.org.firstname}" value="{$cf.org_firstname.value}" data-req="type5">
                    </div>
                </div>
            {/if*}
            {*if $cf.org_middlename}
                <div class="col-sm-4">
                    <div class="form-group prepend-icon">
                        <label for="customfield[5]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[5]" id="customfield5" class="form-control" placeholder="{$LANG.orderForm.org.middlename}" value="{$cf.org_middlename.value}" data-req="type5">
                    </div>
                </div>
            {/if*}
            {*if $cf.org_lastname}
                <div class="col-sm-4">
                    <div class="form-group prepend-icon">
                        <label for="customfield[6]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[6]" id="customfield6" class="field form-control" placeholder="{$LANG.orderForm.org.lastname}" value="{$cf.org_lastname.value}" data-req="type5">
                    </div>
                </div>
            {/if*}
        </div>

        {*Certificate of registration jur. persons (USR)*}

        <div class="sub-heading field-resident" data-type="org,ip">
            <span>{$LANG.xrrp.egr.egr}</span>
        </div>

        <div class="row field-resident" data-type="org,ip">
            {if $cf.r_unp}
                <div class="col-sm-6">
                    <div class="form-group prepend-icon">
                        <label for="customfield[40]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[40]" id="customfield40" class="form-control" data-valid="numbers" maxlength="9" placeholder="{$LANG.orderForm.unp}" value="{$cf.r_unp.value}" data-req="type21" data-dis="1">
                        <span class="validation-text">{$LANG.orderForm.validationUNP}</span>
                    </div>
                </div>
            {/if}
            {if $cf.egr_num}
                <div class="col-sm-6">
                    <div class="form-group prepend-icon">
                        <label for="customfield[11]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[11]" id="customfield11" class="form-control" data-valid="numbers" placeholder="{$LANG.xrrp.egr.num}" value="{$cf.egr_num.value}" data-req="type21" data-dis="1">
                        <span class="validation-text">{$LANG.orderForm.validationNumbers}</span>
                    </div>
                </div>
            {/if}
            {if $cf.egr_org}
                <div class="col-sm-6">
                    <div class="form-group prepend-icon">
                        <label for="customfield[12]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[12]" id="customfield12" class="form-control" data-valid="text" placeholder="{$LANG.xrrp.egr.org}" value="{$cf.egr_org.value}" data-req="type21" data-dis="1">
                        <span class="validation-text">{$LANG.orderForm.validationOrg}</span>
                    </div>
                </div>
            {/if}
            {*if $cf.egr_resh}
                <div class="col-sm-6">
                    <div class="form-group prepend-icon">
                        <label for="customfield[10]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[10]" id="customfield10" class="form-control" placeholder="{$LANG.xrrp.egr.resh}" value="{$cf.egr_resh.value}" data-dis="1">
                    </div>
                </div>
            {/if*}
            {if $cf.egr_date}
                <div class="col-sm-6">
                    <div class="form-group prepend-icon">
                        <label for="customfield[13]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[13]" id="customfield13" class="form-control" data-valid="date" placeholder="{$LANG.xrrp.egr.date}" value="{$cf.egr_date.value}" data-req="type21" data-dis="1">
                        <span class="validation-text">{$LANG.orderForm.validationDate}</span>
                    </div>
                </div>
            {/if}
        </div>

        {*Banking information*}

        <div class="sub-heading" data-type="org,ip">
            <span>{$LANG.orderForm.bank.header}</span>
        </div>

        <div class="row" data-type="org,ip">
            <div class="col-sm-12">
                <div class="form-group">
                    <div class="onoffswitch">
                        <input class="onoffswitch-checkbox" type="checkbox" name="have-ba" id="have-ba">
                        <label for="have-ba" class="onoffswitch-label">
                            <span class="onoffswitch-inner"></span>
                        </label>
                        <span class="onoffswitch-label-off">{$LANG.orderForm.bank.haveAccount}</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            {if $cf.bank_name}
                <div class="col-sm-6 clearfix js-bank">
                    <div class="form-group prepend-icon">
                        <label for="customfield[14]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[14]" id="customfield14" class="form-control" data-valid="text" placeholder="{$LANG.orderForm.bank.name}" value="{$cf.bank_name.value}" data-req="type3">
                        <span class="validation-text">{$LANG.orderForm.validationBank}</span>
                    </div>
                </div>
            {/if}
        </div>
        <div class="row">
            {if $cf.bank_acc}
                <div class="col-sm-6 js-bank">
                    <div class="form-group prepend-icon">
                        <label for="customfield[16]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[16]" id="customfield16" class="form-control" data-valid="latinnum" placeholder="{$LANG.orderForm.bank.acc}" value="{$cf.bank_acc.value}" data-req="type3">
                        <span class="validation-text">{$LANG.orderForm.validationBankNum}</span>
                    </div>
                </div>
            {/if}
            {if $cf.bank_bik}
                <div class="col-sm-6 js-bank">
                    <div class="form-group prepend-icon">
                        <label for="customfield[17]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[17]" id="customfield17" class="form-control" data-valid="latinnum" placeholder="{$LANG.orderForm.bank.bic}" value="{$cf.bank_bik.value}" data-req="type3">
                        <span class="validation-text">{$LANG.orderForm.validationBankBIC}</span>
                    </div>
                </div>
            {/if}
        </div>

        {*Passport details*}

        <div class="sub-heading" data-type="person,ip">
            <span>{$LANG.xrrp.passport.passport}</span>
        </div>

        <div class="row" data-type="person,ip">
            {if $cf.passport_ser}
                <div class="col-sm-6">
                    <div class="form-group prepend-icon">
                        <label for="customfield[29]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[29]" id="customfield29" class="form-control" data-valid="latin" maxlength="2" placeholder="{$LANG.xrrp.passport.ser}" value="{$cf.passport_ser.value}" data-req="type22" data-dis="1">
                        <span class="validation-text">{$LANG.orderForm.validationPassportSer}</span>
                    </div>
                </div>
            {/if}
            {if $cf.passport_nmbr}
                <div class="col-sm-6">
                    <div class="form-group prepend-icon">
                        <label for="customfield[38]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[38]" id="customfield38" class="form-control" data-valid="nambers" placeholder="{$LANG.xrrp.passport.nmbr}" value="{$cf.passport_nmbr.value}" data-req="type22" data-dis="1">
                        <span class="validation-text">{$LANG.orderForm.validationPassportNmbr}</span>
                    </div>
                </div>
            {/if}
            {if $cf.passport_org}
                <div class="col-sm-9">
                    <div class="form-group prepend-icon">
                        <label for="customfield[30]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[30]" id="customfield30" class="form-control" data-valid="text" placeholder="{$LANG.xrrp.passport.org}" value="{$cf.passport_org.value}" data-req="type20" data-dis="1">
                        <span class="validation-text">{$LANG.orderForm.validationPassportOrg}</span>
                    </div>
                </div>
            {/if}
            {if $cf.passport_date}
                <div class="col-sm-3">
                    <div class="form-group prepend-icon">
                        <label for="customfield[32]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[32]" id="customfield32" class="form-control" data-valid="date" placeholder="{$LANG.xrrp.passport.date}" value="{$cf.passport_date.value}" data-req="type20" data-dis="1">
                        <span class="validation-text">{$LANG.orderForm.validationPassportDate}</span>
                    </div>
                </div>
            {/if}
            {if $cf.passport_personalnmbr}
                <div class="col-sm-6 field-resident">
                    <div class="form-group prepend-icon">
                        <label for="customfield[31]" class="field-icon">
                            <i class="fas fa-pencil"></i>
                        </label>
                        <input type="text" name="customfield[31]" id="customfield31" class="form-control" data-valid="latinnum" placeholder="{$LANG.xrrp.passport.personalnmbr}" value="{$cf.passport_personalnmbr.value}" data-dis="1" data-req="type20">
                        <span class="validation-text">{$LANG.orderForm.validationPersonalNmbr}</span>
                    </div>
                </div>
            {/if}
            {if $cf.birthday}
                <div class="col-sm-6 field-resident">
                    <div class="form-group prepend-icon">
                        <label for="customfield[28]" class="field-icon">
                            <i class="fas fa-calendar"></i>
                        </label>
                        <input type="text" name="customfield[28]" id="customfield28" class="form-control" data-valid="date" placeholder="{$LANG.xrrp.birthday}" value="{$cf.birthday.value}" data-dis="1">
                        <span class="validation-text">{$LANG.orderForm.validationBirth}</span>
                    </div>
                </div>
            {/if}
        </div>

        {if $showMarketingEmailOptIn}
            <div class="label-form mt-2">
                <h4>{lang key='emailMarketing.joinOurMailingList'}</h4>
                <p>{lang key='emailMarketing.joinOurMailMessage'}</p>
                <input type="checkbox" name="marketingoptin" value="1"{if $marketingEmailOptIn} checked{/if} class="no-icheck toggle-switch-success" data-size="small" data-on-text="{lang key='yes'}" data-off-text="{lang key='no'}">
            </div>
        {/if}

        <div class="form-group text-center mb-0">
            <div class="validation-submit__wrap">
                <input class="btn btn-primary validation-submit" type="submit" name="save" value="{$LANG.clientareasavechanges}" />
                <div class="btn btn-primary validation-submit_click">{$LANG.clientareasavechanges}</div>
            </div>
            <input class="btn btn-default" type="reset" value="{$LANG.cancel}" />
        </div>

    </form>
</div>


