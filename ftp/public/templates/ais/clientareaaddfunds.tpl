{if $addfundsdisabled}
    {include file="$template/includes/alert.tpl" type="error" msg=$LANG.clientareaaddfundsdisabled textcenter=true}
{elseif $notallowed}
    {include file="$template/includes/alert.tpl" type="error" msg=$LANG.clientareaaddfundsnotallowed textcenter=true}
{elseif $errormessage}
    {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage textcenter=true}
{/if}

{if !$addfundsdisabled}

    <div class="row">
        <div class="col-sm-6 col-sm-offset-3">
            <div class="form-container form-container_sm mb-3">
                <div class="form-container__inner">
                    <form method="post" action="{$smarty.server.PHP_SELF}?action=addfunds">
                        <fieldset>
                            <div class="form-group">
                                <label for="amount" class="control-label">{$LANG.addfundsamount}:</label>
                                <input type="text" name="amount" id="amount"
                                       value="{$amount}" class="form-control" required />
                            </div>
                            <div class="form-group">
                                <label for="paymentmethod" class="control-label">{$LANG.orderpaymentmethod}:</label><br/>
                                <select name="paymentmethod" id="paymentmethod" class="form-control">
                                    {foreach from=$gateways item=gateway}
                                        <option value="{$gateway.sysname}">{$gateway.name}</option>
                                    {/foreach}
                                </select>
                            </div>
                            <div class="form-group text-center">
                                <input type="submit" value="{$LANG.addfunds}" class="btn btn-default" />
                            </div>
                        </fieldset>
                    </form>
                    <p class="mb-0 text-center">
                        {$LANG.addfundsnonrefundable}
                    </p>
                </div>
            </div>
        </div>
    </div>

{/if}