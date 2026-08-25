{foreach $sidebar as $item}

    {* remove add contacts item *}
    {if $item->getName() == 'Client Contacts'}
        {continue}
    {/if}

    <div menuItemName="{$item->getName()}" class="panel panel-sidebar {if $item->getClass()}{$item->getClass()}{else}panel-sidebar{/if}{if $item->getExtra('mobileSelect') and $item->hasChildren()} hidden-sm hidden-xs{/if}"{if $item->getAttribute('id')} id="{$item->getAttribute('id')}"{/if}>
        <div class="panel-heading">
            <h3 class="panel-title">
                <div class="panel-title__wrap">
                    {if $item->hasIcon()}<i class="{$item->getIcon()}"></i>{/if}
                    {$item->getLabel()}
                    {if $item->hasBadge()}<span class="badge">{$item->getBadge()}</span>{/if}
                </div>
                <i class="fas fa-chevron-up panel-minimise"></i>
            </h3>
        </div>
        {if $item->hasBodyHtml()}
            <div class="panel-body">
                {$item->getBodyHtml()}
            </div>
        {/if}
        {if $item->hasChildren()}
            <div class="list-group{if $item->getChildrenAttribute('class')} {$item->getChildrenAttribute('class')}{/if}">
                {foreach $item->getChildren() as $childItem}

                {* remove add contacts item *}
                {if $childItem->getName() == 'Contacts/Sub-Accounts'}
                    {continue}
                {/if}

                {* remove renew if under 180 days and is xrrp domain *}
                {if $childItem->getName() == 'Renew Domain'}
                    {if $xrrp}
                            {if !$can_renew_xrrp}
                            {continue}
                            {/if}
                    {/if}
                {/if}

                {* allow 'transfer button' to render *}
                {if preg_match('/\&a=transfer_in$/m', $childItem->getUri())}
                    <a menuItemName="{$childItem->getName()}" href="index.php?m=xrrpadmin&did={$domainid}&a=tr_req" class="bg-color-gold list-group-item text-uppercase" id="cti">                        
                        <i class="fas fa-exchange"></i>
                        {$childItem->getLabel()}
                    </a> 
                    {continue}
                {/if}
                
                    {if $childItem->getUri()}
                            <a menuItemName="{$childItem->getName()}"
                               href="{$childItem->getUri()}"
                               class="list-group-item list-group-item-action{if $childItem->isDisabled()} disabled{/if}{if $childItem->getClass()} {$childItem->getClass()}{/if}{if $childItem->isCurrent()} active{/if}"
                               {if $childItem->getAttribute('dataToggleTab')}
                                   data-toggle="tab" role="tab"
                               {/if}
                               {if $childItem->getAttribute('dataCustomAction')}
                                   {assign "customActionData" $childItem->getAttribute('dataCustomAction')}
                                   data-active="{$customActionData['active']}"
                                   data-identifier="{$customActionData['identifier']}"
                                   data-serviceid="{$customActionData['serviceid']}"
                               {/if}
                               {if $childItem->getAttribute('target')}
                                   target="{$childItem->getAttribute('target')}"
                               {/if}
                               id="{$childItem->getId()}"
                            >
                                {if isset($customActionData)}<span class="loading hidden w-hidden" style="display: none;"><i class="fas fa-spinner fa-spin"></i></span>{/if}
                            {if $childItem->hasBadge()}<span class="badge">{$childItem->getBadge()}</span>{/if}
                            {if $childItem->hasIcon()}<i class="{$childItem->getIcon()}"></i>{/if}
                            {$childItem->getLabel()}
                        </a>
                    {else}
                        <div menuItemName="{$childItem->getName()}" class="list-group-item{if $childItem->getClass()} {$childItem->getClass()}{/if}" id="{$childItem->getId()}">
                            {if $childItem->hasBadge()}<span class="badge">{$childItem->getBadge()}</span>{/if}
                            {if $childItem->hasIcon()}<i class="{$childItem->getIcon()}"></i>{/if}
                            {$childItem->getLabel()}
                        </div>
                    {/if}
                {/foreach}
            </div>
        {/if}
        {if $item->hasFooterHtml()}
            <div class="panel-footer clearfix">
                {$item->getFooterHtml()}
            </div>
        {/if}
    </div>
    {if $item->getExtra('mobileSelect') and $item->hasChildren()}
        {* Mobile Select only supports dropdown menus *}
        <div class="panel hidden-lg hidden-md {if $item->getClass()}{$item->getClass()}{else}panel-default{/if}"{if $item->getAttribute('id')} id="{$item->getAttribute('id')}"{/if}>
            <div class="panel-heading">
                <h3 class="panel-title">
                    {if $item->hasIcon()}<i class="{$item->getIcon()}"></i>&nbsp;{/if}
                    {$item->getLabel()}
                    {if $item->hasBadge()}&nbsp;<span class="badge">{$item->getBadge()}</span>{/if}
                </h3>
            </div>
            <div class="panel-body">
                <form role="form">
                    <select class="form-control" onchange="selectChangeNavigate(this)">
                        {foreach $item->getChildren() as $childItem}
                            <option menuItemName="{$childItem->getName()}" value="{$childItem->getUri()}" class="list-group-item" {if $childItem->isCurrent()}selected="selected"{/if}>
                                {$childItem->getLabel()}
                                {if $childItem->hasBadge()}({$childItem->getBadge()}){/if}
                            </option>
                        {/foreach}
                    </select>
                </form>
            </div>
            {if $item->hasFooterHtml()}
                <div class="panel-footer">
                    {$item->getFooterHtml()}
                </div>
            {/if}
        </div>
    {/if}
{/foreach}
