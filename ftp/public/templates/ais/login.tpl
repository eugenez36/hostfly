<div class="logincontainer{if $linkableProviders} with-social{/if}">

    {include file="$template/includes/pageheader.tpl" title=$LANG.login desc="{$LANG.restrictedpage}"}
    {include file="$template/includes/flashmessage.tpl"}

    {if $incorrect}
        {include file="$template/includes/alert.tpl" type="error" msg=$LANG.loginincorrect textcenter=true}
    {elseif $verificationId && empty($transientDataName)}
        {include file="$template/includes/alert.tpl" type="error" msg=$LANG.verificationKeyExpired textcenter=true}
    {elseif $ssoredirect}
        {include file="$template/includes/alert.tpl" type="info" msg=$LANG.sso.redirectafterlogin textcenter=true}
    {/if}
	<div style="display:none">1 {$incorrect} {$verificationId} {$ssoredirect}  {$transientDataName}</div>
    <div class="providerLinkingFeedback"></div>

    <div class="row">
        <div class="col-sm-{if $linkableProviders}7{else}12{/if}">

            <div class="form-container">
                <div class="form-container__inner">
                    <form method="post" action="{$systemurl}dologin.php" class="login-form" role="form">
                        <div class="form-group">
                            <label class="field-icon" for="inputEmail">
                                <span class="hidden">{$LANG.clientareaemail}</span>
                                <i class="fas fa-user"></i>
                            </label>
                            <input type="email" name="username" class="form-control" id="inputEmail" placeholder="{$LANG.enteremail}" autofocus>
                        </div>

                        <div class="form-group">
                            <label class="field-icon" for="inputPassword">
                                <span class="hidden">{$LANG.clientareapassword}</span>
                                <i class="fas fa-lock"></i>
                            </label>
                            <input type="password" name="password" class="form-control" id="inputPassword" placeholder="{$LANG.clientareapassword}" autocomplete="off" >
                            <a href="pwreset.php" class="form-link">{$LANG.forgotpw}</a>
                        </div>

                        <div class="form-group">
                            <div class="checkbox">
                                <label>
                                    <input class="check-cust" type="checkbox" name="rememberme" />
                                    <span class="check-cust_i"></span>
                                    {$LANG.loginrememberme}
                                </label>
                            </div>
                        </div>

                        <div class="form-group form-group_submit text-center mb-0">
                            <input id="login" type="submit" onclick="typeof ym !== 'undefined' && ym(52756549, 'reachGoal', 'vhod'); return true;" class="btn btn-default" value="{$LANG.loginbutton}" />
                        </div>
                    </form>
                </div>
            </div>

        </div>
        <div class="col-sm-5{if !$linkableProviders} hidden{/if}">
            {include file="$template/includes/linkedaccounts.tpl" linkContext="login" customFeedback=true}
        </div>
    </div>
</div>
