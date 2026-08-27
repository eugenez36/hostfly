{if in_array('state', $optionalFields)}
    <script>
        var statesTab = 10,
            stateNotRequired = true;
    </script>
{/if}

<script src="{$BASE_PATH_JS}/StatesDropdown.js"></script>
<script src="{$BASE_PATH_JS}/PasswordStrength.js"></script>

{* Автозаполнение реквизитов по УНП из ЕГР (HOS-15).
   Скрипт лежит в теме, а не в /assets/js, чтобы версионироваться вместе с ней.
   Серверная часть — /egr-proxy.php в вебруте: она обходит CORS и скрывает
   от браузера обращения к egr.gov.by.
   Грузим после StatesDropdown.js: тот на ready переименовывает input[name=state]
   в #stateinput, и автозаполнение области опирается на этот id. *}
<script src="{assetPath file='egr.js'}?v={$versionHash}" defer></script>

{* Переключатель типа регистрации табами и показ полей по типу (HOS-14).
   Грузится после egr.js: тот вешает делегированный обработчик на
   customfield[33], и порядок подписки не важен, но так очевиднее. *}
<script src="{assetPath file='hf-register.js'}?v={$versionHash}" defer></script>
<script>
    window.langPasswordStrength = "{lang key='pwstrength'}";
    window.langPasswordWeak = "{lang key='pwstrengthweak'}";
    window.langPasswordModerate = "{lang key='pwstrengthmoderate'}";
    window.langPasswordStrong = "{lang key='pwstrengthstrong'}";
    jQuery(document).ready(function() {
        jQuery("#inputNewPassword1").keyup(registerFormPasswordStrengthFeedback);
    });
</script>
{if $registrationDisabled}
    {include file="$template/includes/alert.tpl" type="error" msg="{lang key='registerCreateAccount'}"|cat:' <strong><a href="'|cat:"$WEB_ROOT"|cat:'/cart.php" class="alert-link">'|cat:"{lang key='registerCreateAccountOrder'}"|cat:'</a></strong>'}
{/if}

{if $errormessage}
    {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
{/if}

{* ============================================================================
   HOS-13. Форма регистрации собрана явно, а не слепым циклом по $customfields.

   Зачем: подписи кастомных полей приходят из админки машинными именами
   (r_unp, rb_resident, passport_ser), и стоковый цикл печатал их как есть.
   Порядок, группировку и подписи задаём здесь; сами контролы по-прежнему
   отдаёт ядро — {$f.input}, — поэтому name/id/value/тип остаются его заботой
   и не разъедутся с настройками поля.

   Атрибуты data-type / data-req на обёртках сейчас НЕ обрабатываются ничем.
   Это заготовка под HOS-14 (табы по типу регистрации) и HOS-16 (паспортный
   блок по наличию домена) — расшифровка типов там же, в этих задачах.
   ============================================================================ *}

{* Подписи. Тексты сняты с эталонной формы прода my.hostfly.by/register.php. *}
{assign var=LBL value=[
    'registrant_type'       => 'Тип регистрации',
    'type_person'           => 'Физ. лицо',
    'type_organization'     => 'Юр. лицо',
    'type_ip'               => 'ИП',
    'rb_resident'           => 'Резидент Республики Беларусь',
    'companyname'           => 'Название организации',
    'r_chief'               => 'ФИО руководителя',
    'org_position'          => 'Должность',
    'org_doc'               => 'Устав / доверенность',
    'lastname'              => 'Фамилия',
    'firstname'             => 'Имя',
    'mname'                 => 'Отчество',
    'email'                 => 'Email-адрес',
    'phonenumber'           => 'Телефон',
    'country'               => 'Страна',
    'state'                 => 'Область',
    'city'                  => 'Город',
    'postcode'              => 'Индекс',
    'address1'              => 'Улица',
    'address2'              => 'Адрес, строка 2',
    'building'              => '№ дома, корп.',
    'office'                => '№ кв. / оф.',
    'mail_address'          => 'Почтовый адрес',
    'landline'              => 'Стационарный телефон',
    'fax'                   => 'Факс',
    'r_unp'                 => 'Учётный номер плательщика (УНП)',
    'egr_num'               => 'Регистрационный номер в ЕГР',
    'egr_org'               => 'Орган регистрации',
    'egr_date'              => 'Дата решения о госрегистрации',
    'bank_name'             => 'Название банка',
    'bank_acc'              => 'Расчётный счёт (IBAN)',
    'bank_bik'              => 'БИК',
    'passport_ser'          => 'Серия документа',
    'passport_nmbr'         => 'Номер документа',
    'passport_org'          => 'Кем выдан',
    'passport_date'         => 'Дата выдачи',
    'passport_personalnmbr' => 'Идентификационный номер',
    'birthday'              => 'Дата рождения',
    'section_org'           => 'Данные организации',
    'section_egr'           => 'Государственная регистрация',
    'section_bank'          => 'Банковские реквизиты',
    'section_passport'      => 'Документ, удостоверяющий личность',
    'hint_date'             => 'дд.мм.гггг',
    'hint_mail_address'     => 'ул. Минская, 12-121, 220000, г. Минск'
]}

{* Кастомные поля, выведенные ниже поимённо. *}
{assign var=hfKnown value=[
    'registrant_type','rb_resident','r_chief','org_position','org_doc','mname',
    'building','office','mail_address','landline','fax',
    'r_unp','egr_num','egr_org','egr_date',
    'bank_name','bank_acc','bank_bik',
    'passport_ser','passport_nmbr','passport_org','passport_date',
    'passport_personalnmbr','birthday'
]}

{* Не выводим: на эталонной форме прода этих полей нет.
   reseller — служебный флаг, ему не место на публичной регистрации;
   org_firstname/middlename/lastname дублируют r_chief «ФИО руководителя»;
   egr_resh — устаревшее поле решения о регистрации. *}
{assign var=hfHidden value=['reseller','org_firstname','org_middlename','org_lastname','egr_resh']}

{* Кастомные поля — доступ по имени вместо порядкового номера. *}
{assign var=cf value=[]}
{foreach $customfields as $f}
    {$cf[$f.name] = $f}
{/foreach}

{* Одна обёртка поля: подпись сверху по листу Input из UI-кита, контрол от ядра. *}
{function name="hfField" f=null label='' type='' req='' hint='' wide=false third=false quarter=false passport=false}
    {if $f}
        <div class="{if $wide}col-12{elseif $third}col-12 col-md-4{elseif $quarter}col-6 col-md-3{else}col-12 col-md-6{/if}"{if $type} data-type="{$type}"{/if}{if $req} data-req="{$req}"{/if}{if $passport} data-passport{/if}>
            <div class="form-group hf-field">
                <label class="hf-field__label" for="customfield{$f.id}">{$label}{if $f.required}<span class="hf-req">*</span>{/if}</label>
                {$f.input}
                {* Описание поля из админки не выводим: оно дублирует подпись
                   («Факс» / «Факс»), а местами содержит опечатки. Смысл несёт
                   подпись, формат — подсказка ниже. *}
                {if $hint}<span class="hf-field__hint">{$hint}</span>{/if}
            </div>
        </div>
    {/if}
{/function}

{if !$registrationDisabled}
    <div id="registration">
        <form method="post" class="using-password-strength" action="{$smarty.server.PHP_SELF}" role="form" name="orderfrm" id="frmCheckout">
            <input type="hidden" name="register" value="true"/>

            <div id="containerNewUserSignup">

                {include file="$template/includes/linkedaccounts.tpl" linkContext="registration"}

                {* --- Тип регистрации и валюта ------------------------------------ *}
                <div class="card mb-4">
                    <div class="card-body p-4" id="registrantType">
                        <h3 class="card-title">{$LBL.registrant_type}</h3>
                        <div class="row">
                            {* HOS-14. Табы вместо дропдауна.

                               Селект ядра остаётся в форме и отправляется как раньше —
                               табы только переключают его значение. Поэтому набор полей
                               и серверная обработка не меняются, а HOS-13 продолжает
                               получать контрол из {$f.input}, а не из нашей разметки.

                               Разметка табов — из UI-кита (лист Tabs, «Additional 74»),
                               поэтому обёрнута в .hf-kit: кит изолирован под этим классом.

                               Без JS показывается сам селект, а табы скрыты: их раскрывает
                               js/hf-register.js, он же прячет селект. *}
                            {if $cf.registrant_type}
                                <div class="col-12">
                                    <div class="form-group hf-field">
                                        <label class="hf-field__label" id="registrantTypeLabel" for="customfield{$cf.registrant_type.id}">{$LBL.registrant_type}{if $cf.registrant_type.required}<span class="hf-req">*</span>{/if}</label>
                                        <div class="hf-kit hf-registrant hf-hidden" data-registrant-switch>
                                            <div class="tabs tabs--solid" role="tablist" aria-labelledby="registrantTypeLabel">
                                                <button type="button" class="tabs__item" role="tab" data-registrant="person">{$LBL.type_person}</button>
                                                <button type="button" class="tabs__item" role="tab" data-registrant="organization">{$LBL.type_organization}</button>
                                                <button type="button" class="tabs__item" role="tab" data-registrant="ip">{$LBL.type_ip}</button>
                                            </div>
                                        </div>
                                        {$cf.registrant_type.input}
                                    </div>
                                </div>
                            {/if}
                            {hfField f=$cf.rb_resident label=$LBL.rb_resident}
                            {if $currencies}
                                <div class="col-12 col-md-6">
                                    <div class="form-group hf-field">
                                        <label class="hf-field__label" for="inputCurrency">{lang key='currency'}</label>
                                        <select id="inputCurrency" name="currency" class="field form-control custom-select">
                                            {foreach $currencies as $curr}
                                                <option value="{$curr.id}"{if !$smarty.post.currency && $curr.default || $smarty.post.currency eq $curr.id } selected{/if}>{$curr.code}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>

                {* --- Организация. Скрыта для физлица (data-type подхватит HOS-14) -- *}
                <div class="card mb-4" data-type="org">
                    <div class="card-body p-4" id="organizationInformation">
                        <h3 class="card-title">{$LBL.section_org}</h3>
                        <div class="row">
                            <div class="col-12" data-type="org" data-req="type5">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="inputCompanyName">{$LBL.companyname}</label>
                                    <input type="text" name="companyname" id="inputCompanyName" class="field form-control" value="{$clientcompanyname}">
                                </div>
                            </div>
                            {hfField f=$cf.r_chief      label=$LBL.r_chief      type='org' req='type5'}
                            {hfField f=$cf.org_position label=$LBL.org_position type='org' req='type5'}
                            {hfField f=$cf.org_doc      label=$LBL.org_doc      type='org' req='type5'}
                        </div>
                    </div>
                </div>

                {* --- Личные данные ------------------------------------------------ *}
                <div class="card mb-4">
                    <div class="card-body p-4" id="personalInformation">
                        <h3 class="card-title">{lang key='orderForm.personalInformation'}</h3>
                        <div class="row">
                            <div class="col-12 col-md-4" data-type="person,ip" data-req="type20">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="inputLastName">{$LBL.lastname}{if !in_array('lastname', $optionalFields)}<span class="hf-req">*</span>{/if}</label>
                                    <input type="text" name="lastname" id="inputLastName" class="field form-control" value="{$clientlastname}" {if !in_array('lastname', $optionalFields)}required{/if}>
                                </div>
                            </div>
                            <div class="col-12 col-md-4" data-type="person,ip" data-req="type20">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="inputFirstName">{$LBL.firstname}{if !in_array('firstname', $optionalFields)}<span class="hf-req">*</span>{/if}</label>
                                    <input type="text" name="firstname" id="inputFirstName" class="field form-control" value="{$clientfirstname}" {if !in_array('firstname', $optionalFields)}required{/if} autofocus>
                                </div>
                            </div>
                            {hfField f=$cf.mname label=$LBL.mname type='person,ip' req='type20' third=true}
                            <div class="col-12 col-md-6" data-req="all">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="inputEmail">{$LBL.email}</label>
                                    <input type="email" name="email" id="inputEmail" class="field form-control" value="{$clientemail}">
                                </div>
                            </div>
                            <div class="col-12 col-md-6" data-req="all">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="inputPhone">{$LBL.phonenumber}</label>
                                    <input type="tel" name="phonenumber" id="inputPhone" class="field form-control" value="{$clientphonenumber}">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {* --- Адрес -------------------------------------------------------- *}
                <div class="card mb-4">
                    <div class="card-body p-4" id="billingAddress">
                        <h3 class="card-title">{lang key='orderForm.billingAddress'}</h3>
                        <div class="row">
                            <div class="col-12 col-md-6" data-req="all">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="inputCountry">{$LBL.country}</label>
                                    <select name="country" id="inputCountry" class="field form-control custom-select">
                                        {foreach $clientcountries as $countryCode => $countryName}
                                            <option value="{$countryCode}"{if (!$clientcountry && $countryCode eq $defaultCountry) || ($countryCode eq $clientcountry)} selected="selected"{/if}>{$countryName}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                            <div class="col-12 col-md-6">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="state">{$LBL.state}{if !in_array('state', $optionalFields)}<span class="hf-req">*</span>{/if}</label>
                                    <input type="text" name="state" id="state" class="field form-control" value="{$clientstate}" {if !in_array('state', $optionalFields)}required{/if}>
                                </div>
                            </div>
                            <div class="col-12 col-md-8" data-req="all">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="inputCity">{$LBL.city}{if !in_array('city', $optionalFields)}<span class="hf-req">*</span>{/if}</label>
                                    <input type="text" name="city" id="inputCity" class="field form-control" value="{$clientcity}" {if !in_array('city', $optionalFields)}required{/if}>
                                </div>
                            </div>
                            <div class="col-12 col-md-4" data-req="all">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="inputPostcode">{$LBL.postcode}{if !in_array('postcode', $optionalFields)}<span class="hf-req">*</span>{/if}</label>
                                    <input type="text" name="postcode" id="inputPostcode" class="field form-control" value="{$clientpostcode}" {if !in_array('postcode', $optionalFields)}required{/if}>
                                </div>
                            </div>
                            <div class="col-12 col-md-6" data-req="all">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="inputAddress1">{$LBL.address1}{if !in_array('address1', $optionalFields)}<span class="hf-req">*</span>{/if}</label>
                                    <input type="text" name="address1" id="inputAddress1" class="field form-control" value="{$clientaddress1}" {if !in_array('address1', $optionalFields)}required{/if}>
                                </div>
                            </div>
                            {hfField f=$cf.building label=$LBL.building req='all' quarter=true}
                            {hfField f=$cf.office   label=$LBL.office   req='all' quarter=true}
                            <div class="col-12">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="inputAddress2">{$LBL.address2}</label>
                                    <input type="text" name="address2" id="inputAddress2" class="field form-control" value="{$clientaddress2}">
                                </div>
                            </div>
                            {hfField f=$cf.mail_address label=$LBL.mail_address req='all' hint=$LBL.hint_mail_address wide=true}
                            {hfField f=$cf.landline label=$LBL.landline type='org,ip'}
                            {hfField f=$cf.fax      label=$LBL.fax      type='org,ip'}
                            {if $showTaxIdField}
                                <div class="col-12 col-md-6">
                                    <div class="form-group hf-field">
                                        <label class="hf-field__label" for="inputTaxId">{$taxLabel}</label>
                                        <input type="text" name="tax_id" id="inputTaxId" class="field form-control" value="{$clientTaxId}">
                                    </div>
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>

                {* --- Государственная регистрация ---------------------------------- *}
                <div class="card mb-4" data-type="org,ip">
                    <div class="card-body p-4" id="stateRegistration">
                        <h3 class="card-title">{$LBL.section_egr}</h3>
                        <div class="row">
                            {hfField f=$cf.r_unp    label=$LBL.r_unp    type='org,ip' req='type21'}
                            {hfField f=$cf.egr_num  label=$LBL.egr_num  type='org,ip' req='type21'}
                            {hfField f=$cf.egr_org  label=$LBL.egr_org  type='org,ip' req='type21'}
                            {hfField f=$cf.egr_date label=$LBL.egr_date type='org,ip' req='type21' hint=$LBL.hint_date}
                        </div>
                    </div>
                </div>

                {* --- Банковские реквизиты ----------------------------------------- *}
                <div class="card mb-4" data-type="org,ip">
                    <div class="card-body p-4" id="bankDetails">
                        <h3 class="card-title">{$LBL.section_bank}</h3>
                        <div class="row">
                            {hfField f=$cf.bank_name label=$LBL.bank_name type='org,ip' req='type32' wide=true}
                            {hfField f=$cf.bank_acc  label=$LBL.bank_acc  type='org,ip' req='type32'}
                            {hfField f=$cf.bank_bik  label=$LBL.bank_bik  type='org,ip' req='type32'}
                        </div>
                    </div>
                </div>

                {* --- Документ, удостоверяющий личность ---------------------------- *}
                <div class="card mb-4" data-type="person,ip" data-passport>
                    <div class="card-body p-4" id="passportDetails">
                        <h3 class="card-title">{$LBL.section_passport}</h3>
                        <div class="row">
                            {hfField f=$cf.passport_ser  label=$LBL.passport_ser  type='person,ip' req='type22' passport=true quarter=true}
                            {hfField f=$cf.passport_nmbr label=$LBL.passport_nmbr type='person,ip' req='type22' passport=true quarter=true}
                            {hfField f=$cf.passport_org  label=$LBL.passport_org  type='person,ip' req='type22' passport=true wide=true}
                            {hfField f=$cf.passport_date label=$LBL.passport_date type='person,ip' req='type22' passport=true hint=$LBL.hint_date}
                            {hfField f=$cf.passport_personalnmbr label=$LBL.passport_personalnmbr type='person,ip' req='type20' passport=true}
                            {hfField f=$cf.birthday label=$LBL.birthday type='person,ip' req='type20' passport=true hint=$LBL.hint_date}
                        </div>
                    </div>
                </div>

                {* --- Страховка: поля, добавленные в админке после этой вёрстки.
                       Без этого блока новое кастомное поле молча исчезло бы с формы. *}
                {assign var=hfRest value=[]}
                {foreach $customfields as $f}
                    {if !in_array($f.name, $hfKnown) && !in_array($f.name, $hfHidden)}{append var=hfRest value=$f}{/if}
                {/foreach}
                {if $hfRest}
                    <div class="card mb-4">
                        <div class="card-body p-4">
                            <h3 class="card-title">{lang key='orderadditionalrequiredinfo'}</h3>
                            <div class="row">
                                {foreach $hfRest as $f}
                                    {hfField f=$f label=$f.name}
                                {/foreach}
                            </div>
                        </div>
                    </div>
                {/if}

                {if isset($accountDetailsExtraFields) && !empty($accountDetailsExtraFields)}
                    <div class="card mb-4">
                        <div class="card-body p-4">
                            <h3 class="card-title">{lang key='orderForm.additionalInformation'}</h3>
                            <div class="row">
                                {foreach $accountDetailsExtraFields as $field}
                                    <div class="col-12 col-md-6">
                                        <div class="form-group hf-field">
                                            {$field.input}
                                        </div>
                                    </div>
                                {/foreach}
                            </div>
                        </div>
                    </div>
                {/if}
            </div>

            <div id="containerNewUserSecurity" {if $remote_auth_prelinked && !$securityquestions } class="w-hidden"{/if}>

                <div class="card mb-4">
                    <div class="card-body p-4">
                        <h3 class="card-title">{lang key='orderForm.accountSecurity'}</h3>

                        <div id="containerPassword" class="row{if $remote_auth_prelinked && $securityquestions} hidden{/if}">
                            <div id="passwdFeedback" class="alert alert-info text-center col-12 w-hidden"></div>
                            <div class="col-12 col-md-6">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="inputNewPassword1">{lang key='clientareapassword'}<span class="hf-req">*</span></label>
                                    <input type="password" name="password" id="inputNewPassword1" data-error-threshold="{$pwStrengthErrorThreshold}" data-warning-threshold="{$pwStrengthWarningThreshold}" class="field form-control" autocomplete="off"{if $remote_auth_prelinked} value="{$password}"{/if}>
                                </div>
                            </div>
                            <div class="col-12 col-md-6">
                                <div class="form-group hf-field">
                                    <label class="hf-field__label" for="inputNewPassword2">{lang key='clientareaconfirmpassword'}<span class="hf-req">*</span></label>
                                    <input type="password" name="password2" id="inputNewPassword2" class="field form-control" autocomplete="off"{if $remote_auth_prelinked} value="{$password}"{/if}>
                                </div>
                            </div>
                            <div class="col-12 col-md-6">
                                <div class="password-strength-meter">
                                    <div class="progress">
                                        <div class="progress-bar bg-success bg-striped" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" id="passwordStrengthMeterBar">
                                        </div>
                                    </div>
                                    <p class="small text-muted" id="passwordStrengthTextLabel">{lang key='pwstrength'}: {lang key='pwstrengthenter'}</p>
                                </div>
                            </div>
                            <div class="col-12 col-md-6">
                                <div class="form-group">
                                    <button type="button" class="btn btn-default btn-sm generate-password" data-targetfields="inputNewPassword1,inputNewPassword2">
                                        {lang key='generatePassword.btnLabel'}
                                    </button>
                                </div>
                            </div>
                        </div>
                        {if $securityquestions}
                            <div class="row">
                                <div class="col-12 col-md-6">
                                    <div class="form-group hf-field">
                                        <label class="hf-field__label" for="inputSecurityQId">{lang key='clientareasecurityquestion'}</label>
                                        <select name="securityqid" id="inputSecurityQId" class="field form-control custom-select">
                                            <option value="">{lang key='clientareasecurityquestion'}</option>
                                            {foreach $securityquestions as $question}
                                                <option value="{$question.id}"{if $question.id eq $securityqid} selected{/if}>
                                                    {$question.question}
                                                </option>
                                            {/foreach}
                                        </select>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6">
                                    <div class="form-group hf-field">
                                        <label class="hf-field__label" for="inputSecurityQAns">{lang key='clientareasecurityanswer'}</label>
                                        <input type="password" name="securityqans" id="inputSecurityQAns" class="field form-control" autocomplete="off">
                                    </div>
                                </div>
                            </div>
                        {/if}
                    </div>

                </div>
            </div>

            {if $showMarketingEmailOptIn}
                <div class="card mb-4">
                    <div class="card-body p-4">
                        <h3 class="card-title">{lang key='emailMarketing.joinOurMailingList'}</h3>
                        <p>{$marketingEmailOptInMessage}</p>
                        <label class="hf-check">
                            <input type="checkbox" name="marketingoptin" value="1"{if $marketingEmailOptIn} checked{/if} class="no-icheck toggle-switch-success" data-size="small" data-on-text="{lang key='yes'}" data-off-text="{lang key='no'}">
                            <span>{lang key='emailMarketing.joinOurMailingList'}</span>
                        </label>
                    </div>
                </div>
            {/if}

            {include file="$template/includes/captcha.tpl"}

            {if $accepttos}
                <p class="text-center">
                    <label class="form-check hf-check">
                        <input type="checkbox" name="accepttos" class="form-check-input accepttos">
                        <span>{lang key='ordertosagreement'} <a href="{$tosurl}" target="_blank">{lang key='ordertos'}</a></span>
                    </label>
                </p>
            {/if}

            <p class="text-center">
                <input class="btn btn-lg btn-primary{$captcha->getButtonClass($captchaForm)}" type="submit" value="{lang key='clientregistertitle'}"/>
            </p>
        </form>
    </div>
{/if}
