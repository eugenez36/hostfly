<h2 class="h2">{$LANG.domaincontactinfo}</h2>
{include file="$template/includes/alert.tpl" type="info" msg=$LANG.whoisContactWarning}

{if $successful}
    {include file="$template/includes/alert.tpl" type="success" msg=$LANG.changessavedsuccessfully textcenter=true}
{/if}

{if $pending}
    {include file="$template/includes/alert.tpl" type="info" msg=$pendingMessage textcenter=true}
{/if}

{if $domainInformation && !$pending && $domainInformation->getIsIrtpEnabled() && $domainInformation->isContactChangePending()}
    {if $domainInformation->getPendingSuspension()}
        {include file="$template/includes/alert.tpl" type="warning" msg="<strong>{$LANG.domains.verificationRequired}</strong><br>{$LANG.domains.newRegistration}" textcenter=true}
    {else}
        {include file="$template/includes/alert.tpl" type="info" msg="<strong>{$LANG.domains.contactChangePending}</strong><br>{$LANG.domains.contactsChanged}" textcenter=true}
    {/if}
{/if}

{if $error}
    {include file="$template/includes/alert.tpl" type="error" msg=$error textcenter=true}
{/if}

<p class="well well-lg">{$LANG.xrrp.domainEditContactIntro} "{$LANG.xrrp.domainEditContactUpdate}"</p>
<h3 class="h3"> {$LANG.xrrp.domainEditContactCurrent}:</h3>

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

{assign var=countries value=[
    'AF' => 'Afghanistan',
    'AX' => 'Aland Islands',
    'AL' => 'Albania',
    'DZ' => 'Algeria',
    'AS' => 'American Samoa',
    'AD' => 'Andorra',
    'AO' => 'Angola',
    'AI' => 'Anguilla',
    'AQ' => 'Antarctica',
    'AG' => 'Antigua And Barbuda',
    'AR' => 'Argentina',
    'AM' => 'Armenia',
    'AW' => 'Aruba',
    'AU' => 'Australia',
    'AT' => 'Austria',
    'AZ' => 'Azerbaijan',
    'BS' => 'Bahamas',
    'BH' => 'Bahrain',
    'BD' => 'Bangladesh',
    'BB' => 'Barbados',
    'BY' => 'Belarus',
    'BE' => 'Belgium',
    'BZ' => 'Belize',
    'BJ' => 'Benin',
    'BM' => 'Bermuda',
    'BT' => 'Bhutan',
    'BO' => 'Bolivia',
    'BA' => 'Bosnia And Herzegovina',
    'BW' => 'Botswana',
    'BV' => 'Bouvet Island',
    'BR' => 'Brazil',
    'IO' => 'British Indian Ocean Territory',
    'BN' => 'Brunei Darussalam',
    'BG' => 'Bulgaria',
    'BF' => 'Burkina Faso',
    'BI' => 'Burundi',
    'KH' => 'Cambodia',
    'CM' => 'Cameroon',
    'CA' => 'Canada',
    'CV' => 'Cape Verde',
    'KY' => 'Cayman Islands',
    'CF' => 'Central African Republic',
    'TD' => 'Chad',
    'CL' => 'Chile',
    'CN' => 'China',
    'CX' => 'Christmas Island',
    'CC' => 'Cocos (Keeling) Islands',
    'CO' => 'Colombia',
    'KM' => 'Comoros',
    'CG' => 'Congo',
    'CD' => 'Congo, Democratic Republic',
    'CK' => 'Cook Islands',
    'CR' => 'Costa Rica',
    'CI' => 'Cote D\'Ivoire',
    'HR' => 'Croatia',
    'CU' => 'Cuba',
    'CW' => 'Curacao',
    'CY' => 'Cyprus',
    'CZ' => 'Czech Republic',
    'DK' => 'Denmark',
    'DJ' => 'Djibouti',
    'DM' => 'Dominica',
    'DO' => 'Dominican Republic',
    'EC' => 'Ecuador',
    'EG' => 'Egypt',
    'SV' => 'El Salvador',
    'GQ' => 'Equatorial Guinea',
    'ER' => 'Eritrea',
    'EE' => 'Estonia',
    'ET' => 'Ethiopia',
    'FK' => 'Falkland Islands (Malvinas)',
    'FO' => 'Faroe Islands',
    'FJ' => 'Fiji',
    'FI' => 'Finland',
    'FR' => 'France',
    'GF' => 'French Guiana',
    'PF' => 'French Polynesia',
    'TF' => 'French Southern Territories',
    'GA' => 'Gabon',
    'GM' => 'Gambia',
    'GE' => 'Georgia',
    'DE' => 'Germany',
    'GH' => 'Ghana',
    'GI' => 'Gibraltar',
    'GR' => 'Greece',
    'GL' => 'Greenland',
    'GD' => 'Grenada',
    'GP' => 'Guadeloupe',
    'GU' => 'Guam',
    'GT' => 'Guatemala',
    'GG' => 'Guernsey',
    'GN' => 'Guinea',
    'GW' => 'Guinea-Bissau',
    'GY' => 'Guyana',
    'HT' => 'Haiti',
    'HM' => 'Heard Island &amp; Mcdonald Islands',
    'VA' => 'Holy See (Vatican City State)',
    'HN' => 'Honduras',
    'HK' => 'Hong Kong',
    'HU' => 'Hungary',
    'IS' => 'Iceland',
    'IN' => 'India',
    'ID' => 'Indonesia',
    'IR' => 'Iran, Islamic Republic Of',
    'IQ' => 'Iraq',
    'IE' => 'Ireland',
    'IM' => 'Isle Of Man',
    'IL' => 'Israel',
    'IT' => 'Italy',
    'JM' => 'Jamaica',
    'JP' => 'Japan',
    'JE' => 'Jersey',
    'JO' => 'Jordan',
    'KZ' => 'Kazakhstan',
    'KE' => 'Kenya',
    'KI' => 'Kiribati',
    'KR' => 'Korea',
    'KW' => 'Kuwait',
    'KG' => 'Kyrgyzstan',
    'LA' => 'Lao People\'s Democratic Republic',
    'LV' => 'Latvia',
    'LB' => 'Lebanon',
    'LS' => 'Lesotho',
    'LR' => 'Liberia',
    'LY' => 'Libyan Arab Jamahiriya',
    'LI' => 'Liechtenstein',
    'LT' => 'Lithuania',
    'LU' => 'Luxembourg',
    'MO' => 'Macao',
    'MK' => 'Macedonia',
    'MG' => 'Madagascar',
    'MW' => 'Malawi',
    'MY' => 'Malaysia',
    'MV' => 'Maldives',
    'ML' => 'Mali',
    'MT' => 'Malta',
    'MH' => 'Marshall Islands',
    'MQ' => 'Martinique',
    'MR' => 'Mauritania',
    'MU' => 'Mauritius',
    'YT' => 'Mayotte',
    'MX' => 'Mexico',
    'FM' => 'Micronesia, Federated States Of',
    'MD' => 'Moldova',
    'MC' => 'Monaco',
    'MN' => 'Mongolia',
    'ME' => 'Montenegro',
    'MS' => 'Montserrat',
    'MA' => 'Morocco',
    'MZ' => 'Mozambique',
    'MM' => 'Myanmar',
    'NA' => 'Namibia',
    'NR' => 'Nauru',
    'NP' => 'Nepal',
    'NL' => 'Netherlands',
    'AN' => 'Netherlands Antilles',
    'NC' => 'New Caledonia',
    'NZ' => 'New Zealand',
    'NI' => 'Nicaragua',
    'NE' => 'Niger',
    'NG' => 'Nigeria',
    'NU' => 'Niue',
    'NF' => 'Norfolk Island',
    'MP' => 'Northern Mariana Islands',
    'NO' => 'Norway',
    'OM' => 'Oman',
    'PK' => 'Pakistan',
    'PW' => 'Palau',
    'PS' => 'Palestine, State of',
    'PA' => 'Panama',
    'PG' => 'Papua New Guinea',
    'PY' => 'Paraguay',
    'PE' => 'Peru',
    'PH' => 'Philippines',
    'PN' => 'Pitcairn',
    'PL' => 'Poland',
    'PT' => 'Portugal',
    'PR' => 'Puerto Rico',
    'QA' => 'Qatar',
    'RE' => 'Reunion',
    'RO' => 'Romania',
    'RU' => 'Russian Federation',
    'RW' => 'Rwanda',
    'BL' => 'Saint Barthelemy',
    'SH' => 'Saint Helena',
    'KN' => 'Saint Kitts And Nevis',
    'LC' => 'Saint Lucia',
    'MF' => 'Saint Martin',
    'PM' => 'Saint Pierre And Miquelon',
    'VC' => 'Saint Vincent And Grenadines',
    'WS' => 'Samoa',
    'SM' => 'San Marino',
    'ST' => 'Sao Tome And Principe',
    'SA' => 'Saudi Arabia',
    'SN' => 'Senegal',
    'RS' => 'Serbia',
    'SC' => 'Seychelles',
    'SL' => 'Sierra Leone',
    'SG' => 'Singapore',
    'SK' => 'Slovakia',
    'SI' => 'Slovenia',
    'SB' => 'Solomon Islands',
    'SO' => 'Somalia',
    'ZA' => 'South Africa',
    'GS' => 'South Georgia And Sandwich Isl.',
    'ES' => 'Spain',
    'LK' => 'Sri Lanka',
    'SD' => 'Sudan',
    'SR' => 'Suriname',
    'SJ' => 'Svalbard And Jan Mayen',
    'SZ' => 'Swaziland',
    'SE' => 'Sweden',
    'CH' => 'Switzerland',
    'SY' => 'Syrian Arab Republic',
    'TW' => 'Taiwan',
    'TJ' => 'Tajikistan',
    'TZ' => 'Tanzania',
    'TH' => 'Thailand',
    'TL' => 'Timor-Leste',
    'TG' => 'Togo',
    'TK' => 'Tokelau',
    'TO' => 'Tonga',
    'TT' => 'Trinidad And Tobago',
    'TN' => 'Tunisia',
    'TR' => 'Turkey',
    'TM' => 'Turkmenistan',
    'TC' => 'Turks And Caicos Islands',
    'TV' => 'Tuvalu',
    'UG' => 'Uganda',
    'UA' => 'Ukraine',
    'AE' => 'United Arab Emirates',
    'GB' => 'United Kingdom',
    'US' => 'United States',
    'UM' => 'United States Outlying Islands',
    'UY' => 'Uruguay',
    'UZ' => 'Uzbekistan',
    'VU' => 'Vanuatu',
    'VE' => 'Venezuela',
    'VN' => 'Viet Nam',
    'VG' => 'Virgin Islands, British',
    'VI' => 'Virgin Islands, U.S.',
    'WF' => 'Wallis And Futuna',
    'EH' => 'Western Sahara',
    'YE' => 'Yemen',
    'ZM' => 'Zambia',
    'ZW' => 'Zimbabwe'
]}

<script>

$(document).ready(function () {
    $("input[type='text']").attr('readonly', 'readonly');

    var is_reseller = {if $contactdetails.registrar.reseller}true{else}false{/if};
    lock_form(true);
    $('#enable_reg').on('change', function(){
        //only reseller may toggle registrant profile fields edit
        if (!is_reseller) {
            return;
        }
        this.checked ? lock_form(false) : lock_form(true);
    }).change();

    function lock_form(val = null) {
        if (val) {
            $("#frmDomainContactModification input[name^='contactdetails[R]']").attr('readonly', true);
            $('#inputCountry')
            .attr("style", "pointer-events: none;")
            .attr("readonly", true);

        } else {
            $("#frmDomainContactModification input[name^='contactdetails[R]']").attr('readonly', false);
            $('#inputCountry')
            .attr("style", "")
            .attr("readonly", false);
        }
    };

  var nresident = $('.field-resident');
  if (nresident.length && !resident) {
    nresident.each(function () {
      $(this).hide();
    });
  }
});
</script>
{* {$contactdetails|print_r} *}
{* {debug|print_r} *}
<div class="mb-4">
    <form method="post" action="{$smarty.server.PHP_SELF}?action=domaincontacts" id="frmDomainContactModification">

        <input type="hidden" name="sub" value="save" />
        <input type="hidden" name="domainid" value="{$domainid}" />
        <input type="hidden" name="contactdetails[R][registrant_type]" value="{$contactdetails.R.registrant_type}" />
        <input type="hidden" name="contactdetails[W][w_protected]" value="{$contactdetails.W.w_protected}" />


        <input type="hidden" name="wc[R]" id="R2" value="custom" />
        <input type="hidden" name="wc[RS]" id="RS2" value="custom" />


        {if $contactdetails.registrar.hostfly}

            <div class="row">
                <div class="col-sm-6 form-group">
                    <p><b class="mr-1">{$LANG.xrrp.r_type}</b> <span class="label label-primary">{getRegType rType=$contactdetails.R.registrant_type}</span></p>
                </div>
                {if $contactdetails.registrar.reseller}
                    <div class="col-sm-6">
                        <p><b class="mr-1">{$LANG.orderForm.reseller}</b> <span class="label label-primary">{$LANG.orderForm.yes}</span></p>
                    </div>
                {/if}
            </div>

            {if $contactdetails.registrar.reseller}
                <div class="row">
                    <div class="col-sm-12">
                        <div class="alert alert-warning">
                            {$LANG.orderForm.resellerEditRegistrantNote}
                        </div>
                        <div class="checkbox">
                            <label for="enable_reg">
                                <input type="checkbox" id="enable_reg">
                                {$LANG.orderForm.resellerEditRegistrant}
                            </label>
                        </div>
                    </div>
                </div>
            {/if}

            <div class="sub-heading mt-0">
                {if $contactdetails.R.registrant_type == 'person'}
                    <span>{$LANG.orderForm.personalInformation}</span>
                {/if}
                {if $contactdetails.R.registrant_type != 'person'}
                    <span>{$LANG.orderForm.registrationInformation}</span>
                {/if}
            </div>

            <div class="row">
                <div class="col-sm-6 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.r_name}</label>
                    <input type="text" name="contactdetails[R][r_name]" value="{$contactdetails.R.r_name}" data-original-value="{$contactdetails.R.r_name}" class="form-control" />
                </div>
            </div>
            {if $contactdetails.R.registrant_type == 'organization'}
                <div class="row">
                    <div class="col-sm-12 form-group">
                        <label class="field-name_sm">{$LANG.xrrp.r_chief}</label>
                        <input type="text" name="contactdetails[R][r_chief]" value="{$contactdetails.R.r_chief}" class="form-control" />
                    </div>
                </div>
            {/if}
            <div class="row">
                <div class="col-sm-6 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.r_email}</label>
                    <input type="text" name="contactdetails[R][r_email]" value="{$contactdetails.R.r_email}" class="form-control" />
                </div>
                <div class="col-sm-6 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.r_phone}</label>
                    <input type="text" name="contactdetails[R][r_phone]" value="{$contactdetails.R.r_phone}" class="form-control" />
                </div>
            </div>

            <div class="sub-heading">
                <span>{$LANG.orderForm.regAddress}</span>
            </div>

            <div class="row">
                <div class="col-sm-5 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.country}</label>
                    {* <input type="text" id="inputCountry" name="contactdetails[R][country]" value="{$contactdetails.R.country}" class="form-control" /> *}
                    <select name="contactdetails[R][country]" id="inputCountry" class="form-control">
                        {foreach $countries as $key => $val}
                            <option value="{$key}"{if $key eq $contactdetails.R.country} selected{/if}>{$val}</option>
                        {/foreach}
                    </select>
                </div>
                <div class="col-sm-4 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.region}</label>
                    <input type="text" name="contactdetails[R][region]" value="{$contactdetails.R.region}" class="form-control" />
                </div>
                <div class="col-sm-3 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.index}</label>
                    <input type="text" name="contactdetails[R][index]" value="{$contactdetails.R.index}" class="form-control" />
                </div>
                <div class="col-sm-3 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.city}</label>
                    <input type="text" name="contactdetails[R][city]" value="{$contactdetails.R.city}" class="form-control" />
                </div>
                <div class="col-sm-4 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.street}</label>
                    <input type="text" name="contactdetails[R][street]" value="{$contactdetails.R.street}" class="form-control" />
                </div>
                <div class="col-sm-3 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.building}</label>
                    <input type="text" name="contactdetails[R][building]" value="{$contactdetails.R.building}" class="form-control" />
                </div>
                <div class="col-sm-2 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.office}</label>
                    <input type="text" name="contactdetails[R][office]" value="{$contactdetails.R.office}" class="form-control" />
                </div>
            </div>

            {if $contactdetails.R.registrant_type != 'person'}
                <div class="sub-heading">
                    <span>{$LANG.xrrp.egr.egr}</span>
                </div>
                <div class="row">
                    <div class="col-sm-6 form-group">
                        <label class="field-name_sm">{$LANG.xrrp.egr.num}</label>
                        <input type="text" name="contactdetails[R][egr_num]" value="{$contactdetails.R.egr_num}" class="form-control" />
                    </div>
                    <div class="col-sm-6 form-group">
                        <label class="field-name_sm">{$LANG.xrrp.egr.org}</label>
                        <input type="text" name="contactdetails[R][egr_org]" value="{$contactdetails.R.egr_org}" class="form-control" />
                    </div>
                    <div class="col-sm-9 form-group">
                        <label class="field-name_sm">{$LANG.xrrp.egr.resh}</label>
                        <input type="text" name="contactdetails[R][egr_resh]" value="{$contactdetails.R.egr_resh}" class="form-control" />
                    </div>
                    <div class="col-sm-3 form-group">
                        <label class="field-name_sm">{$LANG.xrrp.egr.date}</label>
                        <input type="text" name="contactdetails[R][egr_date]" value="{$contactdetails.R.egr_date}" class="form-control" />
                    </div>
                    <div class="col-sm-12 form-group">
                        <label class="field-name_sm">{$LANG.orderForm.unp}</label>
                        <input type="text" name="contactdetails[R][r_unp]" value="{$contactdetails.R.r_unp}" class="form-control" />
                    </div>
                </div>
            {/if}

            {if $contactdetails.R.registrant_type != 'organization'}
                <div class="sub-heading">
                    <span>{$LANG.xrrp.passport.passport}</span>
                </div>
                <div class="row">
                    <div class="col-sm-6 form-group">
                        <label class="field-name_sm">{$LANG.xrrp.passport.ser}</label>
                        <input type="text" name="contactdetails[R][passport_ser]" value="{$contactdetails.R.passport_ser}" class="form-control" />
                    </div>
                    <div class="col-sm-6 form-group">
                        <label class="field-name_sm">{$LANG.xrrp.passport.nmbr}</label>
                        <input type="text" name="contactdetails[R][passport_nmbr]" value="{$contactdetails.R.passport_nmbr}" class="form-control" />
                    </div>
                    <div class="col-sm-9 form-group">
                        <label class="field-name_sm">{$LANG.xrrp.passport.org}</label>
                        <input type="text" name="contactdetails[R][passport_org]" value="{$contactdetails.R.passport_org}" class="form-control" />
                    </div>
                    <div class="col-sm-3 form-group">
                        <label class="field-name_sm">{$LANG.xrrp.passport.date}</label>
                        <input type="text" name="contactdetails[R][passport_date]" value="{$contactdetails.R.passport_date}" class="form-control" />
                    </div>
                    <div class="col-sm-6 form-group">
                        <label class="field-name_sm">{$LANG.xrrp.passport.personalnmbr}</label>
                        <input type="text" name="contactdetails[R][passport_personalnmbr]" value="{$contactdetails.R.passport_personalnmbr}" class="form-control" />
                    </div>
                    <div class="col-sm-6 form-group">
                        <label class="field-name_sm">{$LANG.xrrp.birthday}</label>
                        <input type="text" name="contactdetails[R][birthday]" value="{$contactdetails.R.birthday}" class="form-control" />
                    </div>
                </div>
            {/if}


            {if $contactdetails.registrar.reseller}
                <hr>
                <h4>{$LANG.xrrp.resellerInfo}</h4>
                <div class="row">
                    <div class="col-sm-6 form-group">
                        <p><b>{$LANG.xrrp.resellerType}</b>: <span class="label label-primary">{getRegType rType=$contactdetails.RS.registrant_type}</span></p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 form-group">
                        <label>{$LANG.xrrp.r_name}</label>
                        <input type="text" name="contactdetails[RS][r_name]" value="{$contactdetails.RS.r_name}" class="form-control" />
                    </div>
                </div>
                {if $contactdetails.RS.registrant_type == 'organization'}
                    <div class="row">
                        <div class="col-sm-12 form-group">
                            <label>{$LANG.xrrp.r_chief}</label>
                            <input type="text" name="contactdetails[RS][r_chief]" value="{$contactdetails.RS.r_chief}" class="form-control" />
                        </div>
                    </div>
                {/if}
                <div class="row">
                    <div class="col-sm-12 form-group">
                        <label>{$LANG.xrrp.r_email}</label>
                        <input type="text" name="contactdetails[RS][r_email]" value="{$contactdetails.RS.r_email}" class="form-control" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 form-group">
                        <label>{$LANG.xrrp.r_phone}</label>
                        <input type="text" name="contactdetails[RS][r_phone]" value="{$contactdetails.RS.r_phone}" class="form-control" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 form-group">
                        <label>{$LANG.xrrp.street}</label>
                        <input type="text" name="contactdetails[RS][street]" value="{$contactdetails.RS.street}" class="form-control" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 form-group">
                        <label>{$LANG.xrrp.building}</label>
                        <input type="text" name="contactdetails[RS][building]" value="{$contactdetails.RS.building}" class="form-control" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 form-group">
                        <label>{$LANG.xrrp.office}</label>
                        <input type="text" name="contactdetails[RS][office]" value="{$contactdetails.RS.office}" class="form-control" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 form-group">
                        <label>{$LANG.xrrp.city}</label>
                        <input type="text" name="contactdetails[RS][city]" value="{$contactdetails.RS.city}" class="form-control" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 form-group">
                        <label>{$LANG.xrrp.region}</label>
                        <input type="text" name="contactdetails[RS][region]" value="{$contactdetails.RS.region}" class="form-control" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 form-group">
                        <label>{$LANG.xrrp.index}</label>
                        <input type="text" name="contactdetails[RS][index]" value="{$contactdetails.RS.index}" class="form-control" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 form-group">
                        <label>{$LANG.xrrp.country}</label>
                        <input type="text" name="contactdetails[RS][country]" value="{$contactdetails.RS.country}" class="form-control" />
                    </div>
                </div>
            {/if}

            <hr>
            <h4>{$LANG.xrrp.whoisInformation}</h4>
            <div class="row">
                <div class="col-sm-6 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.r_name}</label>
                    <input type="text" disabled name="contactdetails[W][w_registrant]" value="{$contactdetails.W.w_registrant}" class="form-control" />
                </div>
                <div class="col-sm-6 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.w_address}</label>
                    <input type="text" disabled name="contactdetails[W][w_address]" value="{$contactdetails.W.w_address}" class="form-control" />
                </div>
                <div class="col-sm-6 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.country}</label>
                    <input type="text" disabled name="contactdetails[W][w_country]" value="{$contactdetails.W.w_country}" class="form-control" />
                </div>
                <div class="col-sm-6 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.city}</label>
                    <input type="text" disabled name="contactdetails[W][w_city]" value="{$contactdetails.W.w_city}" class="form-control" />
                </div>
                <div class="col-sm-6 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.r_phone}</label>
                    <input type="text" disabled name="contactdetails[W][w_phone]" value="{$contactdetails.W.w_phone}" class="form-control" />
                </div>
                <div class="col-sm-6 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.r_email}</label>
                    <input type="text" disabled name="contactdetails[W][w_email]" value="{$contactdetails.W.w_email}" class="form-control" />
                </div>
                <div class="col-sm-6 form-group">
                    <label class="field-name_sm">{$LANG.xrrp.r_type}</label>
                    <input type="text" disabled name="contactdetails[W][w_type]" value="{$contactdetails.W.w_type}" class="form-control" />
                </div>
            </div>
            {if $contactdetails.W.w_type == 'person'}
                <div class="row">
                    <div class="col-sm-12">
                        {if $contactdetails.W.w_protected}
                            <b>{$LANG.xrrp.whoisCurrently} {$LANG.xrrp.whoisProtected}</b>
                        {else}
                            <b>{$LANG.xrrp.whoisCurrently} {$LANG.xrrp.whoisUnrotected}</b>
                        {/if}
                    </div>
                </div>
            {/if}


        {else}

            <div class="row">
                {foreach from=$contactdetails name=contactdetails key=contactdetail item=values}
                    <div class="col-md-6">
                        <h4>{$contactdetail} {$LANG.supportticketscontact}</h4>
                        <div class="radio">
                            <label>
                                <input type="radio" name="wc[{$contactdetail}]" id="{$contactdetail}1" value="contact" onclick="useDefaultWhois(this.id)" />
                                {$LANG.domaincontactusexisting}
                            </label>
                        </div>
                        <div class="row">
                            <div class="col-xs-offset-1 col-xs-10">
                                <div class="form-group">
                                    <label for="{$contactdetail}3">{$LANG.domaincontactchoose}</label>
                                    <input type="hidden" name="sel[{$contactdetail}]" value="">
                                    <select id="{$contactdetail}3" class="form-control {$contactdetail}defaultwhois" name="sel[{$contactdetail}]" disabled>
                                        <option value="u{$clientsdetails.userid}">{$LANG.domaincontactprimary}</option>
                                        {foreach key=num item=contact from=$contacts}
                                            <option value="c{$contact.id}">{$contact.name}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="wc[{$contactdetail}]" id="{$contactdetail}2" value="custom" onclick="useCustomWhois(this.id)" checked />
                                {$LANG.domaincontactusecustom}
                            </label>
                        </div>
                        {foreach key=name item=value from=$values}
                            <div class="form-group">
                                <label>{$name}</label>
                                <input type="text" name="contactdetails[{$contactdetail}][{$name}]" value="{$value}" data-original-value="{$value}" class="form-control {$contactdetail}customwhois{if array_key_exists($contactdetail, $irtpFields) && in_array($name, $irtpFields[$contactdetail])} irtp-field{/if}" />
                            </div>
                        {/foreach}
                    </div>
                {/foreach}
            </div>

        {/if}

        <br />

        <p class="text-center">
            {if $domainInformation && $irtpFields}
                <input id="irtpOptOut" type="hidden" name="irtpOptOut" value="0">
                <input id="irtpOptOutReason" type="hidden" name="irtpOptOutReason" value="">
            {/if}
            <input type="submit" value="{$LANG.xrrp.domainEditContactUpdate}" class="btn btn-primary" />
            <input type="reset" value="{$LANG.clientareacancel}" class="btn btn-default" />
        </p>

    </form>
</div>

{if $domainInformation && $irtpFields}
    <script type="text/javascript">
        var allowSubmit = 0;
    </script>
    <div class="modal fade" id="modalIRTPConfirmation" role="dialog" aria-labelledby="IRTPConfirmationLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content panel panel-primary">
                <div id="modalIRTPConfirmationHeading" class="modal-header panel-heading">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                        <span class="sr-only">{lang key='orderForm.close'}</span>
                    </button>
                    <h4 class="modal-title" id="IRTPConfirmationLabel">{lang key='domains.importantReminder'}</h4>
                </div>
                <div id="modalIRTPConfirmationBody" class="modal-body panel-body text-center">
                    <div class="row">
                        <div class="col-sm-10 col-sm-offset-1">
                            {lang key='domains.irtpNotice'}
                        </div>
                        <div class="col-sm-12">
                            <div class="checkbox-inline">
                                <label for="modalIrtpOptOut">
                                    <input id="modalIrtpOptOut" class="checkbox" type="checkbox" value="1">
                                    {lang key='domains.optOut'}
                                </label>
                            </div>
                        </div>
                        <div class="col-sm-12">
                            <div class="row">
                                <div class="col-sm-12 text-left">
                                    <label for="modalReason">{lang key='domains.optOutReason'}</label>:
                                </div>
                                <div class="col-sm-12">
                                    <input id="modalReason" type="text" class="form-control input-600" autocomplete="off">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="modalIRTPConfirmationFooter" class="modal-footer panel-footer">
                    <button type="button" id="IRTPConfirmation-Submit" class="btn btn-primary" onclick="irtpSubmit();return false;">
                        {lang key='supportticketsticketsubmit'}
                    </button>
                    <button type="button" id="IRTPConfirmation-Cancel" class="btn btn-default" data-dismiss="modal">
                        {lang key='cancel'}
                    </button>
                </div>
            </div>
        </div>
    </div>
{/if}

