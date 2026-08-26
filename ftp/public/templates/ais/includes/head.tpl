<link rel="apple-touch-icon" sizes="180x180" href="{$WEB_ROOT}/templates/{$template}/favicon/apple-touch-icon.png">
<link rel="icon" type="image/png" sizes="32x32" href="{$WEB_ROOT}/templates/{$template}/favicon/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="{$WEB_ROOT}/templates/{$template}/favicon/favicon-16x16.png">
<link rel="manifest" href="{$WEB_ROOT}/templates/{$template}/favicon/site.webmanifest">
<link rel="mask-icon" href="{$WEB_ROOT}/templates/{$template}/favicon/safari-pinned-tab.svg" color="#5bbad5">
<meta name="msapplication-TileColor" content="#1f1250">
<meta name="theme-color" content="#ffffff">

<meta property="og:type" content="website"/>
<meta property="og:site_name" content="HostFly"/>
<meta property="og:url" content="https://hostfly.by/"/>
<meta property="og:image" content="https://www.hostfly.by/local/assets/images/bg/hf.png"/>

<!-- Styling -->
{*<link href="//fonts.googleapis.com/css?family=Open+Sans:300,400,600|Raleway:400,700" rel="stylesheet">*}
<link href="https://fonts.googleapis.com/css?family=Fira+Sans:300,400,500,600&amp;subset=cyrillic-ext" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/css/all.min.css?v={$versionHash}" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/css/custom.css" rel="stylesheet">
<link href="{$WEB_ROOT}/templates/{$template}/css/overrides.css" rel="stylesheet">

<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
  <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->

<style type="text/css">
{literal}
  #Secondary_Navbar-Account>a:first-child {visibility:hidden;}
{/literal}
</style>

<script type="text/javascript">
    var csrfToken = '{$token}',
        markdownGuide = '{lang key="markdown.title"}',
        locale = '{if !empty($mdeLocale)}{$mdeLocale}{else}en{/if}',
        saved = '{lang key="markdown.saved"}',
        saving = '{lang key="markdown.saving"}',
        whmcsBaseUrl = "{\WHMCS\Utility\Environment\WebHelper::getBaseUrl()}",
        recaptchaSiteKey = "{$recaptchaSiteKey}";
</script>
<script src="{$WEB_ROOT}/templates/{$template}/js/scripts.js?v={$versionHash}"></script>
<script src="{$WEB_ROOT}/templates/{$template}/js/custom.js?v={$versionHash}"></script>

{if $templatefile == "viewticket" && !$loggedin}
  <meta name="robots" content="noindex" />
{/if}

<script src="{$WEB_ROOT}/templates/{$template}/js/jquery.maskedinput.min.js"></script>

<!-- GTM -->
<script>
var gtm_key = '{$gtm_key}';
{literal}
(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})
(window,document,'script','dataLayer',gtm_key);
{/literal}
</script>
