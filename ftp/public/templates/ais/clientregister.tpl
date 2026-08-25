{if in_array('state', $optionalFields)}
    <script>
        var statesTab = 10;
        var stateNotRequired = true;
    </script>
{/if}

<script type="text/javascript" src="{$BASE_PATH_JS}/StatesDropdownHF.js"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/PasswordStrength.js"></script>
<script>
    window.langPasswordStrength = "{$LANG.pwstrength}";
    window.langPasswordWeak = "{$LANG.pwstrengthweak}";
    window.langPasswordModerate = "{$LANG.pwstrengthmoderate}";
    window.langPasswordStrong = "{$LANG.pwstrengthstrong}";
    jQuery(document).ready(function()
    {
        jQuery("#inputNewPassword1").keyup(registerFormPasswordStrengthFeedback);
    });
</script>
{if $registrationDisabled}
    {include file="$template/includes/alert.tpl" type="error" msg=$LANG.registerCreateAccount|cat:' <strong><a href="cart.php" class="alert-link">'|cat:$LANG.registerCreateAccountOrder|cat:'</a></strong>'}
{/if}

{if $errormessage}
    {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
{/if}

{if !$registrationDisabled}

{* // turn custom fields into associated array: *}
{assign var=cf value=array_column($customfields, null, 'name')}


{include file="$template/includes/_clientregister.tpl"}

<div id="registration">
    <form method="post" class="using-password-strength validation-form" action="{$smarty.server.PHP_SELF}" role="form" name="orderfrm" id="frmCheckout">
        <input type="hidden" name="register" value="true"/>

        <div id="containerNewUserSignup">

            {include file="$template/includes/linkedaccounts.tpl" linkContext="registration"}

            <div class="row">
                <div class="col-sm-12">
                    {if $cf.registrant_type}
                        <div class="btn-group form-group registrant_type" data-toggle="buttons">
                            <label class="btn registrant_btn {if $cf.registrant_type.value eq 'person' || !$cf.registrant_type.value}active{/if}">
                                <span class="registrant_btn-wrap">
                                    <input
                                        type="radio"
                                        name="customfield[33]"
                                        value="person"
                                        id="person"
                                        autocomplete="off"
                                        {if $cf.registrant_type.value eq 'person' || !$cf.registrant_type.value} checked{/if}> {$LANG.xrrp.person}
                                </span>
                            </label>
                            <label class="btn registrant_btn {if $cf.registrant_type.value eq 'organization'}active{/if}">
                                <span class="registrant_btn-wrap">
                                    <input
                                        type="radio"
                                        name="customfield[33]"
                                        value="organization"
                                        id="organization"
                                        autocomplete="off"
                                        {if $cf.registrant_type.value eq 'organization'} checked{/if}> {$LANG.xrrp.organization}
                                </span>
                            </label>
                            <label class="btn registrant_btn {if $cf.registrant_type.value eq 'ip'}active{/if}">
                                <span class="registrant_btn-wrap">
                                    <input
                                        type="radio"
                                        name="customfield[33]"
                                        value="ip"
                                        id="ip"
                                        autocomplete="off"
                                        {if $cf.registrant_type.value eq 'ip'} checked{/if}> {$LANG.xrrp.ip}
                                </span>
                            </label>
                        </div>
                    {/if}
                </div>
            </div>

            {*is Resident*}

            {if $cf.rb_resident}
                <div class="sub-heading">
                    <span>{$LANG.orderForm.isRBresident}</span>
                </div>

                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-group">
                            <div class="onoffswitch">
                                <span class="onoffswitch-label-on">{$LANG.orderForm.no}</span>
                                <input class="onoffswitch-checkbox" type="checkbox" name="customfield[39]" id="customfield[39]">
                                <label for="customfield[39]" class="onoffswitch-label">
                                    <span class="onoffswitch-inner"></span>
                                </label>
                                <span class="onoffswitch-label-off">{$LANG.orderForm.yes}</span>
                            </div>
                        </div>
                    </div>
                </div>
            {/if}

            {*Company name*}

            <div class="sub-heading" data-type="org">
                <span>{$LANG.orderForm.companyName}</span>
            </div>

            <div class="row">
                <div class="col-sm-6" data-type="org">
                    <div class="form-group prepend-icon">
                        <label for="inputCompanyName" class="field-icon">
                            <i class="fas fa-building"></i>
                        </label>
                        <input type="text" name="companyname" id="inputCompanyName" class="form-control" data-valid="text" placeholder="{$LANG.orderForm.companyName}" value="{$clientcompanyname}" data-req="type5">
                        <span class="validation-text">{$LANG.orderForm.validationCompany}</span>
                    </div>
                </div>
            </div>

            {*Pesonal/Registration information*}

            <div class="sub-heading">
                <span data-type="person,ip">{$LANG.orderForm.personalInformation}</span>
                <span data-type="org">{$LANG.orderForm.registrationInformation}</span>
            </div>

            <div class="row">
                <div class="col-sm-4" data-type="person,ip">
                    <div class="form-group prepend-icon">
                        <label for="inputFirstName" class="field-icon">
                            <i class="fas fa-user"></i>
                        </label>
                        <input type="text" name="firstname" id="inputFirstName" class="form-control" data-valid="name" placeholder="{$LANG.orderForm.firstName}" value="{$clientfirstname}" data-req="type20" autofocus>
                        <span class="validation-text">{$LANG.orderForm.validationName}</span>
                    </div>
                </div>
                <div class="col-sm-4" data-type="person,ip">
                    <div class="form-group prepend-icon">
                        <label for="customfield42" class="field-icon">
                            <i class="fas fa-user"></i>
                        </label>
                        <input type="text" name="customfield[42]" id="customfield42" class="form-control" data-valid="name" placeholder="{$LANG.orderForm.middleName}" value="{$cf.mname.value}" data-req="type20">
                        <span class="validation-text">{$LANG.orderForm.validationName}</span>
                    </div>
                </div>
                <div class="col-sm-4" data-type="person,ip">
                    <div class="form-group prepend-icon">
                        <label for="inputLastName" class="field-icon">
                            <i class="fas fa-user"></i>
                        </label>
                        <input type="text" name="lastname" id="inputLastName" class="form-control" data-valid="name" placeholder="{$LANG.orderForm.lastName}" value="{$clientlastname}" data-req="type20">
                        <span class="validation-text">{$LANG.orderForm.validationName}</span>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group prepend-icon">
                        <label for="inputEmail" class="field-icon">
                            <i class="fas fa-envelope"></i>
                        </label>
                        <input type="email" name="email" id="inputEmail" class="form-control" data-valid="email" placeholder="{$LANG.orderForm.emailAddress}" value="{$clientemail}" data-req="all">
                        <span class="validation-text">{$LANG.orderForm.validationEmail}</span>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group mask-phone prepend-icon">
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

            <div class="row">
                <div class="col-sm-5">
                    <div class="form-group prepend-icon js-inputCountry">
                        <label for="inputCountry" class="field-icon" id="inputCountryIcon">
                            <i class="fas fa-globe"></i>
                        </label>
                        <select name="country" id="inputCountry" class="form-control" data-req="all">
                            {foreach $clientcountries as $countryCode => $countryName}
                                <option value="{$countryCode}"{if (!$clientcountry && $countryCode eq $defaultCountry) || ($countryCode eq $clientcountry)} selected="selected"{/if}>
                                    {$countryName}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="form-group prepend-icon">
                        <label for="state" class="field-icon" id="inputStateIcon">
                            <i class="fas fa-map-signs"></i>
                        </label>
                        <input type="text" name="state" id="state" class="form-control required" data-valid="region" placeholder="{$LANG.orderForm.state}" value="{$clientstate}">
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

            {*<div class="row" data-type="org">
                {if $cf.org_firstname}
                    <div class="col-sm-4">
                        <div class="form-group prepend-icon">
                            <label for="customfield[4]" class="field-icon">
                                <i class="fas fa-pencil"></i>
                            </label>
                            <input type="text" name="customfield[4]" id="customfield4" class="field form-control" placeholder="{$LANG.orderForm.org.firstname}" value="{$cf.org_firstname.value}" data-req="type5">
                        </div>
                    </div>
                {/if}
                {if $cf.org_middlename}
                    <div class="col-sm-4">
                        <div class="form-group prepend-icon">
                            <label for="customfield[5]" class="field-icon">
                                <i class="fas fa-pencil"></i>
                            </label>
                            <input type="text" name="customfield[5]" id="customfield5" class="form-control" placeholder="{$LANG.orderForm.org.middlename}" value="{$cf.org_middlename.value}" data-req="type5">
                        </div>
                    </div>
                {/if}
                {if $cf.org_lastname}
                    <div class="col-sm-4">
                        <div class="form-group prepend-icon">
                            <label for="customfield[6]" class="field-icon">
                                <i class="fas fa-pencil"></i>
                            </label>
                            <input type="text" name="customfield[6]" id="customfield6" class="form-control" placeholder="{$LANG.orderForm.org.lastname}" value="{$cf.org_lastname.value}" data-req="type5">
                        </div>
                    </div>
                {/if}
            </div>*}

            {*Certificate of registration jur. persons (USR)*}

            <div class="sub-heading" data-type="org,ip" data-res="type2">
                <span>{$LANG.xrrp.egr.egr}</span>
            </div>

            <div class="row" data-type="org,ip" data-res="type2">
                {if $cf.r_unp}
                    <div class="col-sm-6">
                        <div class="form-group prepend-icon">
                            <label for="customfield[40]" class="field-icon">
                                <i class="fas fa-pencil"></i>
                            </label>
                            <input type="text" name="customfield[40]" id="customfield40" class="form-control" data-valid="numbers" maxlength="9" placeholder="{$LANG.orderForm.unp}" value="{$cf.r_unp.value}" data-req="type21">
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
                            <input type="text" name="customfield[11]" id="customfield11" class="form-control" data-valid="numbers" placeholder="{$LANG.xrrp.egr.num}" value="{$cf.egr_num.value}" data-req="type21">
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
                            <input type="text" name="customfield[12]" id="customfield12" class="form-control" data-valid="text" placeholder="{$LANG.xrrp.egr.org}" value="{$cf.egr_org.value}" data-req="type21">
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
                            <input type="text" name="customfield[10]" id="customfield10" class="form-control" placeholder="{$LANG.xrrp.egr.resh}" value="{$cf.egr_resh.value}">
                        </div>
                    </div>
                {/if*}
                {if $cf.egr_date}
                    <div class="col-sm-6">
                        <div class="form-group prepend-icon">
                            <label for="customfield[13]" class="field-icon">
                                <i class="fas fa-pencil"></i>
                            </label>
                            <input type="text" name="customfield[13]" id="customfield13" class="form-control" data-valid="date" placeholder="{$LANG.xrrp.egr.date}" value="{$cf.egr_date.value}" data-req="type21">
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
                            <input class="onoffswitch-checkbox" type="checkbox" name="have-ba" id="have-ba" checked>
                            <label for="have-ba" class="onoffswitch-label">
                                <span class="onoffswitch-inner"></span>
                            </label>
                            <span class="onoffswitch-label-off">{$LANG.orderForm.bank.haveAccount}</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" data-type="org,ip">
                {if $cf.bank_name}
                    <div class="col-sm-6 js-bank">
                        <div class="form-group prepend-icon">
                            <label for="customfield[14]" class="field-icon">
                                <i class="fas fa-pencil"></i>
                            </label>
                            <input type="text" name="customfield[14]" id="customfield14" class="form-control" data-valid="text" placeholder="{$LANG.orderForm.bank.name}" value="{$cf.bank_name.value}" data-req="type32">
                            <span class="validation-text">{$LANG.orderForm.validationBank}</span>
                        </div>
                    </div>
                {/if}
            </div>
            <div class="row" data-type="org,ip">
                {if $cf.bank_acc}
                    <div class="col-sm-6 js-bank">
                        <div class="form-group prepend-icon">
                            <label for="customfield[16]" class="field-icon">
                                <i class="fas fa-pencil"></i>
                            </label>
                            <input type="text" name="customfield[16]" id="customfield16" class="form-control" data-valid="latinnum" placeholder="{$LANG.orderForm.bank.acc}" value="{$cf.bank_acc.value}" data-req="type32">
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
                            <input type="text" name="customfield[17]" id="customfield17" class="form-control" data-valid="latinnum" placeholder="{$LANG.orderForm.bank.bic}" value="{$cf.bank_bik.value}" data-req="type32">
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
                            <input type="text" name="customfield[29]" id="customfield29" class="form-control" data-valid="latin" maxlength="2" placeholder="{$LANG.xrrp.passport.ser}" value="{$cf.passport_ser.value}" data-req="type22">
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
                            <input type="text" name="customfield[38]" id="customfield38" class="form-control" data-valid="numbers" placeholder="{$LANG.xrrp.passport.nmbr}" value="{$cf.passport_nmbr.value}" data-req="type22">
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
                            <input type="text" name="customfield[30]" id="customfield30" class="form-control" data-valid="text" placeholder="{$LANG.xrrp.passport.org}" value="{$cf.passport_org.value}" data-req="type22">
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
                            <input type="text" name="customfield[32]" id="customfield32" class="form-control" data-valid="date" placeholder="{$LANG.xrrp.passport.date}" value="{$cf.passport_date.value}" data-req="type22">
                            <span class="validation-text">{$LANG.orderForm.validationPassportDate}</span>
                        </div>
                    </div>
                {/if}
                {if $cf.passport_personalnmbr}
                    <div class="col-sm-6" data-res="type1">
                        <div class="form-group prepend-icon">
                            <label for="customfield[31]" class="field-icon">
                                <i class="fas fa-pencil"></i>
                            </label>
                            <input type="text" name="customfield[31]" id="customfield31" class="form-control" data-valid="latinnum" placeholder="{$LANG.xrrp.passport.personalnmbr}" value="{$cf.passport_personalnmbr.value}" data-req="type20">
                            <span class="validation-text">{$LANG.orderForm.validationPersonalNmbr}</span>
                        </div>
                    </div>
                {/if}
                {if $cf.birthday}
                    <div class="col-sm-6">
                        <div class="form-group prepend-icon">
                            <label for="customfield[28]" class="field-icon">
                                <i class="fas fa-calendar"></i>
                            </label>
                            <input type="text" name="customfield[28]" id="customfield28" class="form-control" data-valid="date" placeholder="{$LANG.xrrp.birthday}" value="{$cf.birthday.value}" data-req="type20">
                            <span class="validation-text">{$LANG.orderForm.validationBirth}</span>
                        </div>
                    </div>
                {/if}
            </div>

            {if $currencies}
                <div class="row">
                    {if $currencies}
                        <div class="col-sm-6">
                            <div class="form-group prepend-icon">
                                <label for="inputCurrency" class="field-icon">
                                    <i class="far fa-money-bill-alt"></i>
                                </label>
                                <select id="inputCurrency" name="currency" class="form-control">
                                    {foreach from=$currencies item=curr}
                                        <option value="{$curr.id}"{if !$smarty.post.currency && $curr.default || $smarty.post.currency eq $curr.id } selected{/if}>{$curr.code}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                    {/if}
                </div>
            {/if}
        </div>
        <div id="containerNewUserSecurity" {if $remote_auth_prelinked && !$securityquestions } class="hidden"{/if}>

            <div class="sub-heading">
                <span>{$LANG.orderForm.accountSecurity}</span>
            </div>
            <div id="containerPassword" class="row{if $remote_auth_prelinked && $securityquestions} hidden{/if}">
                <div id="passwdFeedback" style="display: none;" class="alert alert-info text-center col-sm-12"></div>
                <div class="col-sm-6">
                    <div class="form-group prepend-icon">
                        <div class="form-group__pass">
                            <label for="inputNewPassword1" class="field-icon">
                                <i class="fas fa-lock"></i>
                            </label>
                            <input type="password" name="password" id="inputNewPassword1" class="form-control" data-req="all" data-error-threshold="{$pwStrengthErrorThreshold}" data-warning-threshold="{$pwStrengthWarningThreshold}" placeholder="{$LANG.clientareapassword}" autocomplete="off"{if $remote_auth_prelinked} value="{$password}"{/if}>
                            <span class="validation-text validation-text_relative">
                                <span data-pass="lang">{$LANG.passworderrorlang}</span>
                                <span data-pass="length">{$LANG.passworderrorlength}</span>
                                <span data-pass="num">{$LANG.passworderrornum}</span>
                                <span data-pass="upper">{$LANG.passworderrorupper}</span>
                            </span>
                        </div>
                        {include file="$template/includes/pwstrength.tpl"}
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group prepend-icon">
                        <label for="inputNewPassword2" class="field-icon">
                            <i class="fas fa-lock"></i>
                        </label>
                        <input type="password" name="password2" id="inputNewPassword2" class="form-control" data-req="all" placeholder="{$LANG.clientareaconfirmpassword}" autocomplete="off"{if $remote_auth_prelinked} value="{$password}"{/if}>
                        <span class="validation-text">{$LANG.orderForm.validationPassword}</span>
                    </div>
                </div>
                {*<div class="col-sm-6">
                    <div class="progress">
                        <div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" id="passwordStrengthMeterBar">
                        </div>
                    </div>
                </div>
                <div class="col-sm-6">
                    <p class="small text-muted" id="passwordStrengthTextLabel">{$LANG.pwstrength}: {$LANG.pwstrengthenter}</p>
                </div>*}
            </div>
            {if $securityquestions}
                <div class="row">
                    <div class="form-group col-sm-12">
                        <select name="securityqid" id="inputSecurityQId" class="form-control">
                            <option value="">{$LANG.clientareasecurityquestion}</option>
                            {foreach $securityquestions as $question}
                                <option value="{$question.id}"{if $question.id eq $securityqid} selected{/if}>
                                    {$question.question}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-sm-6">
                        <div class="form-group prepend-icon">
                            <label for="inputSecurityQAns" class="field-icon">
                                <i class="fas fa-lock"></i>
                            </label>
                            <input type="password" name="securityqans" id="inputSecurityQAns" class="form-control" placeholder="{$LANG.clientareasecurityanswer}" autocomplete="off">
                        </div>
                    </div>
                </div>
            {/if}
        </div>

        {if $showMarketingEmailOptIn}
            <div class="label-form mt-2">
                <h4>{lang key='emailMarketing.joinOurMailingList'}</h4>
                <p>{lang key='emailMarketing.joinOurMailMessage'}</p>
                <input type="checkbox" name="marketingoptin" value="1"{if $marketingEmailOptIn} checked{/if} class="no-icheck toggle-switch-success" data-on-text="{lang key='yes'}" data-off-text="{lang key='no'}">
            </div>
        {/if}

        {include file="$template/includes/captcha.tpl"}

        <br/>
        {if $accepttos}
            <div class="row">
                <div class="col-md-12">
                    <div class="label-form">
                        <h4><span class="fas fa-exclamation-triangle tosicon"></span>&emsp;{$LANG.ordertostitle}</h4>
                        <div class="onoffswitch">
                            <input class="onoffswitch-checkbox" type="checkbox" name="accepttos" id="accepttos">
                            <label for="accepttos" class="onoffswitch-label">
                                <span class="onoffswitch-inner"></span>
                            </label>
                            <span class="onoffswitch-label-off">{$LANG.ordertosagreement} <a href="https://www.hostfly.by/contracts/" class="link-text" target="_blank">{$LANG.ordertos}</a> {$LANG.ordertosand} <a href="https://www.hostfly.by/contracts/#privacy-policy" class="link-text" target="_blank">{$LANG.ordertosconfidentiality}</a></span>
                        </div>
                    </div>
                </div>
            </div>
        {/if}
        <div class="form-group form-group_submit text-center mb-0">
            <div class="validation-submit__wrap">
                <input class="btn btn-default validation-submit" type="submit" onclick="typeof ym !== 'undefined' && ym(52756549, 'reachGoal', 'register'); return true;" value="{$LANG.clientregistertitle}"/>
                <div class="validation-submit_click btn btn-default">{$LANG.clientregistertitle}</div>
            </div>
        </div>
    </form>
</div>
{/if}
