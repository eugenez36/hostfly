{* Inter — гарнитура текста из UI-кита, лежит в теме (fonts/, лицензия OFL).
   Преднагружаем два субсета, которые в русскоязычном кабинете нужны всегда:
   латиница и кириллица. Остальные субсеты браузер возьмёт сам по unicode-range.
   Preload идёт до стилей осознанно: шрифт должен приехать раньше, чем сработает
   autoCollapse('#nav', 30) в js/whmcs.js — тот меряет высоту меню один раз на
   document.ready и после подмены шрифта пересчёта не делает.
   crossorigin обязателен даже для своего домена: шрифты грузятся в CORS-режиме,
   без атрибута preload не засчитается и файл скачается дважды. *}
<link rel="preload" href="{$WEB_ROOT}/templates/{$template}/fonts/inter-latin-wght-normal.woff2" as="font" type="font/woff2" crossorigin>
<link rel="preload" href="{$WEB_ROOT}/templates/{$template}/fonts/inter-cyrillic-wght-normal.woff2" as="font" type="font/woff2" crossorigin>

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
