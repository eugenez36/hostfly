{include file="$template/includes/tablelist.tpl" tableName="ActsList" filterColumn="0"}
<script type="text/javascript">
    jQuery(document).ready( function ()
    {
        var table = jQuery('#tableActsList').removeClass('hidden').DataTable();
        {if $orderby == 'did' || $orderby == 'dept'}
            table.order(0, '{$sort}');
        {elseif $orderby == 'subject' || $orderby == 'title'}
            table.order(1, '{$sort}');
        {elseif $orderby == 'status'}
            table.order(2, '{$sort}');
        {elseif $orderby == 'lastreply'}
            table.order(3, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').addClass('hidden');
    });
</script>
<div class="table-container clearfix">
    <table id="tableActsList" class="table table-list hidden">
        <thead>
            <tr>
                <th>Акт</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$listActs item=act}
                <tr onclick="window.location='clientacts.php?n={$act.number}'">
                    <td>№ {$act.number} от {$act.day}.{$act.month}.{$act.year}</td>
                </tr>
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading">
        <p><i class="fas fa-spinner fa-spin"></i> {$LANG.loading}</p>
    </div>
</div>
