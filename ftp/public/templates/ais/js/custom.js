function removeExclamationMark() {
    var accountMenu = $("[menuItemName='Account']").children("a").first(),
    subMenu = accountMenu.html(),
    username = accountMenu.text().trim().replace('!', '');

    accountMenu.html(subMenu.replace(accountMenu.text().trim(), username));
    setTimeout(function(){
        accountMenu.css('visibility', 'visible');
    }, 50);
}

function footerDown() {
    var $header = $('#header');
    var $footer = $('#footer');
    var $menu = $('#main-menu');
    var $body = $('#main-body');

    if ($header.length && $footer.length && $body.length) {
        $body.css({
            'min-height': ''
        });

        var footHeight = $footer.outerHeight(true);
        var navHeight = $header.outerHeight();

        if ($menu.length) {
            navHeight = navHeight + $menu.outerHeight()
        }

        $body.css({
            'min-height': window.innerHeight - (navHeight + footHeight)
        });
    }
}

//--START--Validation
function _validationReg($data, $text, self) {
    if (self.val() !== '') {
        var reg = '';
        var regName = /^[a-zа-яё -]+$/i;
        var regText = /^[0-9a-zа-яё \.,'"“”„«»/-]+$/i; //letters, numbers, ., ', ", /, -
        var regNumbers = /^[0-9]+$/i; //numbers
        var regDate = /^(0[1-9]|[12][0-9]|3[01])[\.](0[1-9]|1[012])[\.](19|20)\d\d+$/i; //00.00.0000
        var regRegion = /^[a-zа-яё \.-]+$/i; //letters, ., -
        var regEmail = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,100})?$/; //email
        var regLetN = /^[\w]+$/i; //letters and numbers
        var regLatN = /^[0-9a-z]+$/i; //latin letters and numbers
        var regLatin = /^[a-z]+$/i;   //latin letters
        var regPhone = /^[0-9 \(\)\-\+]+$/i;   //phone

        if ($data === 'name') {
            reg = regName;
        }
        else if ($data === 'email') {
            reg = regEmail;
        }
        else if ($data === 'text') {
            reg = regText;
        }
        else if ($data === 'numbers') {
            reg = regNumbers;
        }
        else if ($data === 'date') {
            reg = regDate;
        }
        else if ($data === 'region') {
            reg = regRegion;
        }
        else if ($data === 'letnum') {
            reg = regLetN;
        }
        else if ($data === 'latinnum') {
            reg = regLatN;
        }
        else if ($data === 'latin') {
            reg = regLatin;
        }
        else if ($data === 'phone') {
            reg = regPhone;
        }

        if (!reg.test(self.val())) {
            self.addClass('error');
            if ($text.length) {
                $text.show();
            }
        }
        else {
            self.removeClass('error');
            if ($text.length) {
                $text.hide();
            }
        }
    }
}

function _validation(field, textEmpty) {
    var $formGroup = field.parents('.form-group');
    var $text = $formGroup.find('.validation-text');
    var $val = field.val();
    var $data = field.attr('data-valid');

    if (!field.hasClass('disabled') && field.attr('readonly') !== 'readonly') {

        //field required
        if (field.hasClass('required')) {

            if ($val === '') {
                field.addClass('error');
                var $textE = field.parents('.form-group').find('.js-validation-text');
                if ($textE.length) {
                    $textE.remove();
                }
                if (field.parents('.form-group').find('.form-group__pass').length) {
                    field.parents('.form-group__pass').append('<span class="js-validation-text">' + textEmpty + '</span>');
                } else {
                    field.parents('.form-group').append('<span class="js-validation-text">' + textEmpty + '</span>');
                }

                if ($text.length) {
                    $text.hide();
                }
            }
            else {
                field.parents('.form-group').find('.js-validation-text').remove();

                //field has data-valid
                if (typeof $data !== 'undefined' && $data !== false && $data !== null) {
                    _validationReg($data, $text, field);
                }
                else {
                    if (!field.hasClass('error-pass')) {
                        field.removeClass('error');
                    }
                }
            }

        }
        //field not required
        else {
            if (typeof $data !== 'undefined' && $data !== false && $data !== null) {
                _validationReg($data, $text, field);

                if (field.val() === '') {
                    field.removeClass('error');
                    if ($text.length) {
                        $text.hide();
                    }
                }
            }
        }
    }
}

function _validationNotEmpty(field) {
    var $formGroup = field.parents('.form-group');
    var $text = $formGroup.find('.validation-text');
    var $val = field.val();
    var $data = field.attr('data-valid');

    if (!field.hasClass('disabled')) {
        //field required
        if (field.hasClass('required')) {

            if ($val !== '') {
                field.parents('.form-group').find('.js-validation-text').remove();

                //field has data-valid
                if (typeof $data !== 'undefined' && $data !== false && $data !== null) {
                    _validationReg($data, $text, field);
                }
                else {
                    field.removeClass('error');
                }
            }
        }
        //field not required
        else {
            if (typeof $data !== 'undefined' && $data !== false && $data !== null) {
                _validationReg($data, $text, field);

                if (field.val() === '') {
                    field.removeClass('error');
                    if ($text.length) {
                        $text.hide();
                        $formGroup.find('.js-validation-text').hide();
                    }
                }
            }
        }
    }
}

function validationForms(textEmpty) {
    var $form = $('.validation-form');
    if ($form.length) {
        $form.each(function () {
            var selfForm = $(this);
            var $submitWrap = selfForm.find('.validation-submit__wrap');
            var $field = selfForm.find('.form-control');

            if ($field.length) {
                $submitWrap.each(function () {
                    var $submit = $(this).find('.validation-submit');
                    var $submitValid = $(this).find('.validation-submit_click');
                    //click submit
                    if ($submitValid.length) {
                        $submitValid.on('click.valid', function () {
                            $field.each(function () {
                                var self = $(this);
                                _validation(self, textEmpty);
                            });

                            var fieldsError = $('.form-control.required.error').not('.ignore');
                            var fieldsErrorPass = $('.form-control.error-password');

                            if (!fieldsError.length && !fieldsErrorPass.length) {
                                //remove mask phone
                                var maskGroup = $('.mask-phone');
                                if (maskGroup.length) {
                                    maskGroup.each(function () {
                                        var $maskInput = $(this).find('[type="tel"]');
                                        var $maskInputVal = $maskInput.val();

                                        $maskInput.val($maskInputVal.replace(/[^0-9.]/g,''));
                                    });
                                }

                                $submit.trigger('click');

                            }
                            else {
                                var fieldFTop = $('.form-control.required.error, .form-control.error-password').first().offset().top;
                                $('html, body').animate({ scrollTop: fieldFTop - 50 }, 500);
                            }
                        });
                    }
                });

                //keyup/focusout fields
                $field.each(function () {
                    $(this).on('focusout.valid keyup.valid', function () {
                        var self = $(this);
                        _validation(self, textEmpty);
                    });
                });
            }


            //same address
            var $sameasabove = $('#sameasabove');
            var $sameasaboveField = $('#customfield27');
            if ($sameasabove.length && $sameasaboveField.length && $sameasaboveField.hasClass('required')) {
                $sameasabove.on('change.valid', function () {
                    _validation($sameasaboveField, textEmpty);
                });
            }


            //have bank
            var $haveBa = $('#have-ba');
            var $haveBaField = $('.js-bank').find('.form-control');
            if ($haveBa.length && $haveBaField.length) {
                $haveBa.on('change.valid', function () {
                    if ($(this).is(':checked')) {
                        _validationNotEmpty($haveBaField);
                    }
                    // else {
                        // $haveBaField.each(function () {
                            // $(this).removeClass('error');
                            // $(this).parents('.form-group').find('.js-validation-text').remove();
                        // });
                    // }
                });
            }
        });
    }
}
//--END--Validation

// Check if passwords match
function _samepassword(pass1, pass2, $text) {
    var v = pass2.val();
    if (v !== '') {
        if (v !== pass1.val()) {
            pass2.addClass('error error-pass');
            if ($text.length) {
                $text.show();
            }
        }
        else {
            pass2.removeClass('error error-pass');
            if ($text.length) {
                $text.hide();
            }
        }
    }
    else {
        pass2.removeClass('error-pass');
    }
}
function samepassword(pass1, pass2) {
    if (pass1.length && pass2.length) {
        var $text = pass2.parents('.form-group').find('.validation-text');

        pass2.on('keyup.pass', function () {
            if ($(this).val() !== '') {
                _samepassword(pass1, $(this), $text)
            }
        });

        pass1.on('keyup.pass', function () {
            if ($(this).val() !== '') {
                _samepassword($(this), pass2, $text)
            }
        });
    }
}

function autocompliteField(field1, field2) {
    if (field1.length && field2.length) {
        field1.on('keyup.autocomplite', function () {
            if (!field2.hasClass('js-autocomplite-off')) {
                field2.val($(this).val());
            }
        });
        field2.on('keyup.autocomplite', function () {
            if (!field1.hasClass('js-autocomplite-off')) {
                field1.val($(this).val());
            }
        });
        field1.on('focusout.autocomplite', function () {
            if (field1.val() !== '') {
                $(this).addClass('js-autocomplite-off');
            }
        });
        field2.on('focusout.autocomplite', function () {
            if (field2.val() !== '') {
                $(this).addClass('js-autocomplite-off');
            }
        });
    }
}

//hide fields for non-residents
//type1 - resident pesonal + ip
//type2 - resident org + ip
function nonResident(resident, typeUser, namePerson, nameOrg, nameIP) {
    var res = $('[data-res]');
    if (res.length) {
        res.each(function () {
            var self = $(this);
            var selfAttr = self.attr('data-res');
            if (selfAttr === 'type1') {
                if (resident && (typeUser === namePerson || typeUser === nameIP)) {
                    self.show();
                } else {
                    self.hide();
                }
            }
            else if (selfAttr === 'type2') {
                if (resident && (typeUser === nameOrg || typeUser === nameIP)) {
                    self.show();
                } else {
                    self.hide();
                }
            }
        });
    }
}

//min-width progressbar
function progressbar() {
    var $inputPass1 = $("#inputNewPassword1");
    var $bar = $("#passwordStrengthMeterBar");
    if ($inputPass1.length && $bar.length) {
        $inputPass1.on('keyup.pass', function () {
            if ($(this).val() === '') {
                $bar.removeClass('progress-bar-notempty');
            } else {
                $bar.addClass('progress-bar-notempty');
            }
        });
    }
}

//--START-mask for belorussian phones
function _maskPhone($phoneCode, $maskInput) {
    setTimeout(function () {
        if ($phoneCode.val() === '375') {
            $maskInput.prop('placeholder', '(00) 000-00-00').mask('(99) 999-99-99',{autoclear: false});
        } else {
            $maskInput.prop('placeholder', 'Телефон').unmask();
            if ($maskInput.val() === '(__) ___-__-__') {
                $maskInput.val('');
            }
        }
    }, 100);
}

function maskPhone() {
    var maskGroup = $('.mask-phone');
    if (maskGroup.length) {
        maskGroup.each(function () {
            var $phoneCode = $(this).find('[name="country-calling-code-phonenumber"]');
            var $maskInput = $(this).find('[type="tel"]');

            _maskPhone($phoneCode, $maskInput);

            var $phoneCountry = $(this).find('.country');
            $phoneCountry.each(function () {
                $(this).on('click.mask', function () {
                    _maskPhone($phoneCode, $maskInput);
                });
            });
        });
    }
}

function changeCountry() {
    var $input = $('.js-inputCountry select');
    if ($input.length) {
        $input.on('change.custom', function () {
            var maskGroup = $('.mask-phone');
            if (maskGroup.length) {
                maskGroup.each(function () {
                    var $phoneCode = $(this).find('[name="country-calling-code-phonenumber"]');
                    var $maskInput = $(this).find('[type="tel"]');
                    _maskPhone($phoneCode, $maskInput);
                });
            }
        });
    }
}
//--END--mask

$(function () {
	removeExclamationMark();
    footerDown();
    progressbar();
    maskPhone();
    changeCountry();
});
$(window).load(function () {
    footerDown();
});
