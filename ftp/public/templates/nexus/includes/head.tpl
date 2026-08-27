<!-- Styling -->
{\WHMCS\View\Asset::fontCssInclude('open-sans-family.css')}
<link href="{assetPath file='all.min.css'}?v={$versionHash}" rel="stylesheet">
<link href="{assetPath file='theme.min.css'}?v={$versionHash}" rel="stylesheet">
<link href="{$WEB_ROOT}/assets/fonts/css/fontawesome.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-solid.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-regular.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-light.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-brands.min.css" rel="stylesheet">
<link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-duotone.min.css" rel="stylesheet">
{assetExists file="custom.css"}
<link href="{$__assetPath__}" rel="stylesheet">
{/assetExists}

{* Брендовый слой Hostfly. Подключается после стока и custom.css.
   hf-kit.css  — UI-кит нового дизайна, изолирован под .hf-kit
   hf-theme.css — шрифты, размеры контролов, сетка, оверрайды компонентов
   Собираются из nexus/_dev: npm run build *}
{assetExists file="hf-kit.css"}
<link href="{$__assetPath__}?v={$versionHash}" rel="stylesheet">
{/assetExists}
{assetExists file="hf-theme.css"}
<link href="{$__assetPath__}?v={$versionHash}" rel="stylesheet">
{/assetExists}
<script src="{assetPath file='hf-kit.js'}?v={$versionHash}" defer></script>

<script>
    var csrfToken = '{$token}',
        markdownGuide = '{lang|addslashes key="markdown.title"}',
        locale = '{if !empty($mdeLocale)}{$mdeLocale}{else}en{/if}',
        saved = '{lang|addslashes key="markdown.saved"}',
        saving = '{lang|addslashes key="markdown.saving"}',
        whmcsBaseUrl = "{\WHMCS\Utility\Environment\WebHelper::getBaseUrl()}";
    {if $captcha}{$captcha->getPageJs()}{/if}
</script>
<script src="{assetPath file='scripts.min.js'}?v={$versionHash}"></script>

{if $templatefile == "viewticket" && !$loggedin}
  <meta name="robots" content="noindex" />
{/if}
