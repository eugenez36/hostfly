<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="{$charset}" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$companyname} - {$pagetitle}</title>

    <link href="{$WEB_ROOT}/templates/{$template}/css/all.min.css" rel="stylesheet">
    <link href="{$WEB_ROOT}/templates/{$template}/css/invoice.css" rel="stylesheet">

</head>
<body>
    {assign var=cf value=array_column($clientsdetails.customfields, 'value', 'id')}
    {* $cf|print_r *}

    <div class="container-fluid invoice-container">

        {if $invalidInvoiceIdRequested}
            {include file="$template/includes/panel.tpl" type="danger" headerTitle=$LANG.error bodyContent=$LANG.invoiceserror bodyTextCenter=true}
        {else}
            <div class="invoice-header">
                <p class="mb-6">
                    <img src="{$WEB_ROOT}/templates/{$template}/img/logo_dark.svg" title="{$companyname}" />
                </p>

                <div class="invoice-row">
                    <div class="invoice-col invoice-col_auto">
                        <h3>{$pagetitle}</h3>

                        <div class="invoice-status">
                            {if $status eq "Draft"}
                                <span class="draft">{$LANG.invoicesdraft}</span>
                            {elseif $status eq "Unpaid"}
                                <span class="unpaid">{$LANG.invoicesunpaid}</span>
                            {elseif $status eq "Paid"}
                                <span class="paid">{$LANG.invoicespaid}</span>
                            {elseif $status eq "Refunded"}
                                <span class="refunded">{$LANG.invoicesrefunded}</span>
                            {elseif $status eq "Cancelled"}
                                <span class="cancelled">{$LANG.invoicescancelled}</span>
                            {elseif $status eq "Collections"}
                                <span class="collections">{$LANG.invoicescollections}</span>
                            {elseif $status eq "Payment Pending"}
                                <span class="paid">{$LANG.invoicesPaymentPending}</span>
                            {/if}
                        </div>

                        {if $status eq "Unpaid" || $status eq "Draft"}
                            <div class="text-danger small-text">
                                {$LANG.invoicesdatedue}: {$datedue}
                            </div>
                        {/if}
                    </div>
                    <div class="invoice-col invoice-col_auto">
                        <p>
                            <strong>{$LANG.invoicesdatecreated}</strong><br>
                            <span class="small-text">
                                {$date}
                            </span>
                        </p>
                    </div>
                </div>
            </div>

            <hr>

            {if $paymentSuccessAwaitingNotification}
                {include file="$template/includes/panel.tpl" type="success" headerTitle=$LANG.success bodyContent=$LANG.invoicePaymentSuccessAwaitingNotify bodyTextCenter=true}
            {elseif $paymentSuccess}
                {include file="$template/includes/panel.tpl" type="success" headerTitle=$LANG.success bodyContent=$LANG.invoicepaymentsuccessconfirmation bodyTextCenter=true}
            {elseif $pendingReview}
                {include file="$template/includes/panel.tpl" type="info" headerTitle=$LANG.success bodyContent=$LANG.invoicepaymentpendingreview bodyTextCenter=true}
            {elseif $paymentFailed}
                {include file="$template/includes/panel.tpl" type="danger" headerTitle=$LANG.error bodyContent=$LANG.invoicepaymentfailedconfirmation bodyTextCenter=true}
            {elseif $offlineReview}
                {include file="$template/includes/panel.tpl" type="info" headerTitle=$LANG.success bodyContent=$LANG.invoiceofflinepaid bodyTextCenter=true}
            {/if}

            <div class="row">
                <div class="invoice-col right">
                    <p><strong>{$LANG.invoicespayto}</strong></p>
                    <address class="small-text">
                        {$payto}
                    </address>
                    {if $status eq "Unpaid" || $status eq "Draft"}
                        <div class="payment-btn-container hidden-print">
                            {$paymentbutton}
                        </div>
                    {/if}
                </div>
                <div class="invoice-col">
                    <p><strong>{$LANG.invoicesinvoicedto}</strong></p>
                    
                    {* $cf comes from ClientAreaPageViewInvoice hook (xrrp) -> works only for direct login and view*}
                    {* if viewed as client by admin $cf will not be available, so we take it from native data, see $cf array_column above *} 
                    <address class="small-text">
                        {if $clientsdetails.companyname}{$clientsdetails.companyname}<br>{/if}
                        {if $cf.40}{$LANG.xrrp.r_unp}: {$cf.40}<br>{/if}
                        {if $clientsdetails.firstname} {$clientsdetails.firstname} {$clientsdetails.lastname}<br>{/if}
                        {$clientsdetails.address1} {if $cf.36}{$cf.36},{/if} {if $cf.37}{$cf.37}<br>{/if}
                        {if $clientsdetails.address2} {$clientsdetails.address2}<br>{/if}
                        {$clientsdetails.city}, {$clientsdetails.state}, {$clientsdetails.postcode}<br>
                        {$clientsdetails.country}
                    </address>
                </div>
            </div>

            <br />

            {if $manualapplycredit}
                <div class="panel panel-success">
                    <div class="panel-heading">
                        <h3 class="panel-title"><strong>{$LANG.invoiceaddcreditapply}</strong></h3>
                    </div>
                    <div class="panel-body">
                        <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}">
                            <input type="hidden" name="applycredit" value="true" />
                            {$LANG.invoiceaddcreditdesc1} <strong>{$totalcredit}</strong>. {$LANG.invoiceaddcreditdesc2}. {$LANG.invoiceaddcreditamount}:
                            <div class="row mt-1">
                                <div class="col-xs-8 col-xs-offset-2 col-sm-4 col-sm-offset-4">
                                    <div class="input-group">
                                        <input type="text" name="creditamount" value="{$creditamount}" class="form-control" />
                                        <span class="input-group-btn">
                                            <input type="submit" value="{$LANG.invoiceaddcreditapply}" class="btn btn-success" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            {/if}


            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><strong>{$LANG.invoicelineitems}</strong></h3>
                </div>
                <div class="panel-body">
                    <div class="table-responsive">
                        <table class="table table-condensed">
                            <thead>
                                <tr>
                                    <td><strong>{$LANG.invoicesdescription}</strong></td>
                                    <td width="20%" class="text-center"><strong>{$LANG.invoicesamount}</strong></td>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$invoiceitems item=item}
                                    <tr>
                                        <td>{$item.description}{if $item.taxed eq "true"} *{/if}</td>
                                        <td class="text-center">{$item.amount}</td>
                                    </tr>
                                {/foreach}
                                <tr>
                                    <td class="total-row text-right"><strong>{$LANG.invoicesprepaid}</strong></td>
                                    <td class="total-row text-center">{$credit}</td>
                                </tr>
                                <tr>
                                    <td class="total-row text-right"><strong>{$LANG.invoicessubtotal}</strong></td>
                                    <td class="total-row text-center">{$total}</td>
                                </tr>
                                {if $taxrate}
                                    <tr>
                                        <td class="total-row text-right"><strong>{$taxname} {$taxrate}%</strong></td>
                                        <td class="total-row text-center">{$tax}</td>
                                    </tr>
                                {/if}
                                {if $taxrate2}
                                    <tr>
                                        <td class="total-row text-right"><strong>{$taxrate2}% {$taxname2}</strong></td>
                                        <td class="total-row text-center">{$tax2}</td>
                                    </tr>
                                {/if}

                                <tr>
                                    <td class="total-row text-right"><strong>{$LANG.invoicestotal}</strong></td>
                                    <td class="total-row text-center">{$total}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            {if $taxrate}
                <p>* {$LANG.invoicestaxindicator}</p>
            {/if}

            <div class="invoice-nav mt-3 mb-6">
                <div class="invoice-col">
                    <p class="mb-1"><strong>{$LANG.paymentmethod}</strong></p>
                    <span class="small-text">
                        {if $status eq "Unpaid" && $allowchangegateway}
                            <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}" class="form-inline">
                                {$gatewaydropdown}
                            </form>
                        {else}
                            <span class="invoice-btn-text">{$paymentmethod}</span>
                        {/if}
                    </span>
                </div>
                <div class="invoice-col">
                    <p class="mb-1"><strong>{$LANG.invoicepaytext}</strong></p>
                    <div class="invoice-nav">
                        <div class="invoice-col"><span onclick="printPDF()" class="btn btn-default"><i class="fas fa-print"></i> {$LANG.invoiceprint}</span></div>
                        <div class="invoice-col"><a href="dl.php?type=i&amp;id={$invoiceid}" class="btn btn-default"><i class="fas fa-download"></i> {$LANG.invoicesdownload}</a></div>
                    </div>
                    <script>
                        function printPDF() {
                            const xhr = new XMLHttpRequest();
                            xhr.open("GET", "dl.php?type=i&id={$invoiceid}", true);
                            xhr.responseType = 'blob';
                            xhr.onload = function (event) {
                                let blob = xhr.response;
                                window.open(window.URL.createObjectURL(blob)).print()
                            };
                            xhr.send();
                        }
                    </script>
                </div>
            </div>

            <div class="transactions-container small-text">
                <div class="table-responsive">
                    <table class="table table-condensed">
                        <thead>
                            <tr>
                                <td class="text-center"><strong>{$LANG.invoicestransdate}</strong></td>
                                <td class="text-center"><strong>{$LANG.invoicestransgateway}</strong></td>
                                <td class="text-center"><strong>{$LANG.invoicestransid}</strong></td>
                                <td class="text-center"><strong>{$LANG.invoicestransamount}</strong></td>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$transactions item=transaction}
                                <tr>
                                    <td class="text-center">{$transaction.date}</td>
                                    <td class="text-center">{$transaction.gateway}</td>
                                    <td class="text-center">{$transaction.transid}</td>
                                    <td class="text-center">{$transaction.amount}</td>
                                </tr>
                            {foreachelse}
                                <tr>
                                    <td class="text-center" colspan="4">{$LANG.invoicestransnonefound}</td>
                                </tr>
                            {/foreach}

                        </tbody>
                    </table>
                </div>
            </div>

        {/if}

        <p class="text-center hidden-print mt-3"><a class="btn btn-default" href="clientarea.php">{$LANG.invoicesbacktoclientarea}</a></p>

    </div>

</body>
</html>
