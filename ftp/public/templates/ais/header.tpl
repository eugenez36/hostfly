<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="{$charset}" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Вход в личный кабинет хостинг-провайдера Hostfly.by. Регистрация и авторизация в личном кабинете клиента."/>
    <title>{if $kbarticle.title}{$kbarticle.title} - {/if}Личный кабинет | {$companyname}</title>
 
    {include file="$template/includes/head.tpl"}

    {$headoutput}

</head>
<body data-phone-cc-input="{$phoneNumberInputStyle}">
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id={$gtm_key}" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>

{$headeroutput}

<section id="header">
    <div class="container">
        <div class="header__row">
            <div class="header__col">
                <a href="http://www.hostfly.by/" class="logo"><img src="\templates\ais\img\logo.svg" alt="{$companyname}"></a>
                {*{if $assetLogoPath}*}
                    {*<a href="{$WEB_ROOT}/index.php" class="logo"><img src="{$assetLogoPath}" alt="{$companyname}"></a>*}
                {*{else}*}
                    {*<a href="{$WEB_ROOT}/index.php" class="logo logo-text">{$companyname}</a>*}
                {*{/if}*}
            </div>
            <div class="header__col">
                <div class="header-panel">
                    <div class="header-panel__wrap">
                        <div class="header-panel__item">
                            <p class="text-small text-uppercase text-success header-panel__el">{$LANG.clientssupport}</p>
                            <div class="header-panel__el dropdown">
                                <a id="supportContacts" href="tel:+375171234567" class="header-panel__link" data-toggle="dropdown">
                                    <span class="small">+375 17</span> 336-73-73
                                </a>
                                <div class="dropdown-menu menu-drop" aria-labelledby="supportContacts">
                                    <div class="menu-drop__el">
                                        <p class="menu-drop__subtitle">Круглосуточная теподдержка</p>
                                        <a class="menu-drop__title" href="tel:+375173367373">+375 17 336-73-73</a>
                                    </div>
                                    <div class="menu-drop__el">
                                        <p class="menu-drop__subtitle">Отдел продаж</p>
                                        <a class="menu-drop__title" href="tel:+375173367373">+375 17 336-73-73</a>
                                        <ul class="menu-drop-list">
                                            <li>
                                                <a href="tel:+375293367373">+375 29 336-73-73</a>
                                                <span class="subtext">Velcom</span>
                                            </li>
                                            <li>
                                                <a href="tel:+375298657373">+375 29 865-73-73</a>
                                                <span class="subtext">МТС</span>
                                            </li>
                                            <li>
                                                <a href="tel:+375257307373">+375 25 730-73-73</a>
                                                <span class="subtext">Life</span>
                                            </li>
                                            <li>
                                                <a href="tel:+375173367373">+375 17 336-73-73</a>
                                                <span class="subtext">Факс</span>
                                            </li>
                                            <li>
                                                <a href="mailto:sales@hostfly.by">sales@hostfly.by</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {if $loggedin}
                            <div class="header-panel__item">
                                <a href="{$WEB_ROOT}/logout.php" class="header-panel__btn btn btn-primary btn-invert">
                                    <i class="fas fa-sign-out-alt hidden-lg"></i>
                                    <span>{$LANG.clientareanavlogout}</span>
                                </a>
                                <a href="{$WEB_ROOT}/cart.php?a=view" class="header-panel__btn btn btn-default">
                                    <i class="svg svg_shopping-cart"></i>
                                    <span>{$LANG.carttitle}</span>
                                </a>
                            </div>
                        {else}
                            <div class="header-panel__item">
                                {if $condlinks.allowClientRegistration}
                                    <a href="{$WEB_ROOT}/register.php" class="header-panel__btn btn btn-primary btn-invert">
                                        <i class="fas fa-user-plus hidden-lg"></i>
                                        <span>{$LANG.register}</span>
                                    </a>
                                {/if}
                                <a href="{$WEB_ROOT}/clientarea.php" class="header-panel__btn btn btn-primary btn-invert">
                                    <i class="fas fa-sign-in-alt hidden-lg"></i>
                                    <span>{$LANG.login}</span>
                                </a>
                                <a href="{$WEB_ROOT}/cart.php?a=view" class="header-panel__btn btn btn-default">
                                    <i class="svg svg_shopping-cart"></i>
                                    <span>{$LANG.carttitle}</span>
                                </a>
                            </div>
                        {/if}
                    </div>
                </div>
                <ul class="top-nav">
                    {if $languagechangeenabled && count($locales) > 1}
                        <li>
                            <a href="#" class="choose-language" data-toggle="popover" id="languageChooser">
                                {$activeLocale.localisedName}
                                <b class="caret"></b>
                            </a>
                            <div id="languageChooserContent" class="hidden">
                                <ul>
                                    {foreach $locales as $locale}
                                        <li>
                                            <a href="{$currentpagelinkback}language={$locale.language}">{$locale.localisedName}</a>
                                        </li>
                                    {/foreach}
                                </ul>
                            </div>
                        </li>
                    {/if}
                    {if $loggedin}
                        <li>
                            <a href="#" data-toggle="popover" id="accountNotifications" data-placement="bottom">
                                {$LANG.notifications}
                                {if count($clientAlerts) > 0}
                                    <span class="label label-info">{lang key='notificationsnew'}</span>
                                {/if}
                                <b class="caret"></b>
                            </a>
                            <div id="accountNotificationsContent" class="hidden">
                                <ul class="client-alerts">
                                    {foreach $clientAlerts as $alert}
                                        <li>
                                            <a href="{$alert->getLink()}">
                                                <i class="fas fa-fw fa-{if $alert->getSeverity() == 'danger'}exclamation-circle{elseif $alert->getSeverity() == 'warning'}exclamation-triangle{elseif $alert->getSeverity() == 'info'}info-circle{else}check-circle{/if}"></i>
                                                <div class="message">{$alert->getMessage()}</div>
                                            </a>
                                        </li>
                                        {foreachelse}
                                        <li class="none">
                                            {$LANG.notificationsnone}
                                        </li>
                                    {/foreach}
                                </ul>
                            </div>
                        </li>
                        {*<li class="primary-action">*}
                            {*<a href="{$WEB_ROOT}/logout.php" class="btn">*}
                                {*{$LANG.clientareanavlogout}*}
                            {*</a>*}
                        {*</li>*}
                    {else}
                        {*<li>*}
                            {*<a href="{$WEB_ROOT}/clientarea.php">{$LANG.login}</a>*}
                        {*</li>*}
                        {if $condlinks.allowClientRegistration}
                            {*<li>*}
                                {*<a href="{$WEB_ROOT}/register.php">{$LANG.register}</a>*}
                            {*</li>*}
                        {/if}
                        {*<li class="primary-action">*}
                            {*<a href="{$WEB_ROOT}/cart.php?a=view" class="btn">*}
                                {*{$LANG.viewcart}*}
                            {*</a>*}
                        {*</li>*}
                    {/if}
                    {include file="$template/includes/navbar.tpl" navbar=$secondaryNavbar}
                    {if $adminMasqueradingAsClient || $adminLoggedIn}
                        <li>
                            <a href="{$WEB_ROOT}/logout.php?returntoadmin=1" class="btn btn-logged-in-admin" data-toggle="tooltip" data-placement="bottom" title="{if $adminMasqueradingAsClient}{$LANG.adminmasqueradingasclient} {$LANG.logoutandreturntoadminarea}{else}{$LANG.adminloggedin} {$LANG.returntoadminarea}{/if}">
                                <i class="fas fa-sign-out-alt"></i>
                            </a>
                        </li>
                    {/if}
                </ul>
            </div>
        </div>
    </div>
</section>

<section id="main-menu">

    <nav id="nav" class="navbar navbar-default navbar-main" role="navigation">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#primary-nav">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="primary-nav">

                <ul class="nav navbar-nav">

                    {include file="$template/includes/navbar.tpl" navbar=$primaryNavbar}

                </ul>

            </div><!-- /.navbar-collapse -->
        </div>
    </nav>

</section>

{if $templatefile == 'homepage'}
    <section id="home-banner">
        <div class="container text-center">
            {if $registerdomainenabled || $transferdomainenabled}
                <h2>{$LANG.homebegin}</h2>
                <form method="post" action="domainchecker.php">
                    <div class="row">
                        <div class="col-md-8 col-md-offset-2 col-sm-10 col-sm-offset-1">
                            <div class="input-group input-group-lg">
                                <input type="text" class="form-control" name="domain" placeholder="{$LANG.exampledomain}" autocapitalize="none" />
                                <span class="input-group-btn">
                                    {if $registerdomainenabled}
                                        <input type="submit" class="btn search" value="{$LANG.search}" />
                                    {/if}
                                    {if $transferdomainenabled}
                                        <input type="submit" name="transfer" class="btn transfer" value="{$LANG.domainstransfer}" />
                                    {/if}
                                </span>
                            </div>
                        </div>
                    </div>

                    {include file="$template/includes/captcha.tpl"}
                </form>
            {else}
                <h2>{$LANG.doToday}</h2>
            {/if}
        </div>
    </section>
    <div class="home-shortcuts">
        <div class="container">
            <div class="row">
                <div class="col-md-4 hidden-sm hidden-xs text-center">
                    <p class="lead">
                        {$LANG.howcanwehelp}
                    </p>
                </div>
                <div class="col-sm-12 col-md-8">
                    <ul>
                        {if $registerdomainenabled || $transferdomainenabled}
                            <li>
                                <a id="btnBuyADomain" href="domainchecker.php">
                                    <i class="fas fa-globe"></i>
                                    <p>
                                        {$LANG.buyadomain} <span>&raquo;</span>
                                    </p>
                                </a>
                            </li>
                        {/if}
                        <li>
                            <a id="btnOrderHosting" href="cart.php">
                                <i class="far fa-hdd"></i>
                                <p>
                                    {$LANG.orderhosting} <span>&raquo;</span>
                                </p>
                            </a>
                        </li>
                        <li>
                            <a id="btnMakePayment" href="clientarea.php">
                                <i class="fas fa-credit-card"></i>
                                <p>
                                    {$LANG.makepayment} <span>&raquo;</span>
                                </p>
                            </a>
                        </li>
                        <li>
                            <a id="btnGetSupport" href="submitticket.php">
                                <i class="far fa-envelope"></i>
                                <p>
                                    {$LANG.getsupport} <span>&raquo;</span>
                                </p>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
{/if}

{include file="$template/includes/verifyemail.tpl"}

<section id="main-body">
    <div class="container{if $skipMainBodyContainer}-fluid without-padding{/if}">
        <div class="row">

        {if !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())}
            {if $primarySidebar->hasChildren() && !$skipMainBodyContainer}
                <div class="col-md-9 pull-md-right main-content__right">
                    {include file="$template/includes/pageheader.tpl" title=$displayTitle desc=$tagline showbreadcrumb=true}
                </div>
            {/if}
            <div class="col-md-3 pull-md-left sidebar">
                {include file="$template/includes/sidebar.tpl" sidebar=$primarySidebar}
            </div>
        {/if}
        <!-- Container for main page display content -->
        <div class="{if !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())}col-md-9 pull-md-right{else}col-xs-12{/if} main-content__right">
            {if !$primarySidebar->hasChildren() && !$showingLoginPage && !$inShoppingCart && $templatefile != 'homepage' && !$skipMainBodyContainer}
                {include file="$template/includes/pageheader.tpl" title=$displayTitle desc=$tagline showbreadcrumb=true}
            {/if}
