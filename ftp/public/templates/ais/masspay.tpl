<form method="post" action="clientarea.php?action=masspay">
    <input type="hidden" name="geninvoice" value="true" />

    <table class="table">
        <thead>
            <tr>
                <th>{$LANG.invoicesdescription}</th>
                <th>{$LANG.invoicesamount}</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$invoiceitems key=invid item=invoiceitem}
                <tr>
                    <td colspan="2" class="bg-info">
                        <strong>{$LANG.invoicenumber} {$invid}</strong>
                        <input type="hidden" name="invoiceids[]" value="{$invid}" />
                    </td>
                </tr>
                {foreach from=$invoiceitem item=item}
                    <tr class="masspay-invoice-detail">
                        <td>{$item.description}</td>
                        <td>{$item.amount}</td>
                    </tr>
                {/foreach}
            {foreachelse}
                <tr>
                    <td colspan="6" align="center">{$LANG.norecordsfound}</td>
                </tr>
            {/foreach}
            <tr class="masspay-total">
                <td class="text-right">{$LANG.invoicessubtotal}:</td>
                <td>{$subtotal}</td>
            </tr>
            {if $tax}
                <tr class="masspay-total">
                    <td class="text-right">{$taxrate1}% {$taxname1}:</td>
                    <td>{$tax}</td>
                </tr>
            {/if}
            {if $tax2}
                <tr class="masspay-total">
                    <td class="text-right">{$taxrate2}% {$taxname2}:</td>
                    <td>{$tax2}</td>
                </tr>
            {/if}
            {if $credit}
                <tr class="masspay-total">
                    <td class="text-right">{$LANG.invoicescredit}:</td>
                    <td>{$credit}</td>
                </tr>
            {/if}
            {if $partialpayments}
                <tr class="masspay-total">
                    <td class="text-right">{$LANG.invoicespartialpayments}:</td>
                    <td>{$partialpayments}</td>
                </tr>
            {/if}
            <tr class="masspay-total">
                <td class="text-right">{$LANG.invoicestotaldue}:</td>
                <td>{$total}</td>
            </tr>
        </tbody>
    </table>

    <div class="row">
        <div class="col-sm-6 col-sm-offset-3">
            <div class="form-container form-container_sm mb-3">
                <div class="form-container__inner">
                    <h3 class="h2 mt-0 text-center">{$LANG.masspaymentselectgateway}</h3>
                    <fieldset>
                        <div class="col-md-12">
                            <div class="form-group">
                                <label for="paymentmethod" class="control-label">{$LANG.orderpaymentmethod}:</label><br/>
                                <select name="paymentmethod" id="paymentmethod" class="form-control">
                                    {foreach from=$gateways item=gateway}
                                        <option value="{$gateway.sysname}">{$gateway.name}</option>
                                    {/foreach}
                                </select>
                            </div>
                            <div class="form-group mb-0">
                                <input type="submit" value="{$LANG.masspaymakepayment}" class="btn btn-default" />
                            </div>
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>
    </div>

</form>
