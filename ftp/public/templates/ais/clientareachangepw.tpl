{if $successful}
    {include file="$template/includes/alert.tpl" type="success" msg=$LANG.changessavedsuccessfully textcenter=true}
{/if}

{if $errormessage}
    {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
{/if}

<div class="form-container_sm mb-3">
    <form class="using-password-strength" method="post" action="clientarea.php?action=changepw" role="form">
        <input type="hidden" name="submit" value="true" />
        <div class="form-group">
            <label for="inputExistingPassword" class="control-label">{$LANG.existingpassword}</label>
            <input type="password" class="form-control" name="existingpw" id="inputExistingPassword" autocomplete="off" />
        </div>
        <div id="newPassword1" class="form-group has-feedback">
            <div class="form-group__pass">
                <label for="inputNewPassword1" class="control-label">{$LANG.newpassword}</label>
                <input type="password" class="form-control" name="newpw" id="inputNewPassword1" autocomplete="off" />
                <span class="validation-text validation-text_relative">
                    <span data-pass="lang">{$LANG.passworderrorlang}</span>
                    <span data-pass="length">{$LANG.passworderrorlength}</span>
                    <span data-pass="num">{$LANG.passworderrornum}</span>
                    <span data-pass="upper">{$LANG.passworderrorupper}</span>
                </span>
            </div>
            <span class="form-control-feedback glyphicon"></span>
            {include file="$template/includes/pwstrength.tpl"}
        </div>
        <div id="newPassword2" class="form-group has-feedback">
            <label for="inputNewPassword2" class="control-label">{$LANG.confirmnewpassword}</label>
            <input type="password" class="form-control" name="confirmpw" id="inputNewPassword2" autocomplete="off" />
            <span class="form-control-feedback glyphicon"></span>
            <div id="inputNewPassword2Msg"></div>
        </div>
        <div class="form-group mb-0">
            <div class="text-center">
                <input class="btn btn-primary" type="submit" value="{$LANG.clientareasavechanges}" />
                <input class="btn btn-default" type="reset" value="{$LANG.cancel}" />
            </div>
        </div>
    </form>
</div>
