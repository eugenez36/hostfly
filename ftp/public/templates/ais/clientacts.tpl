{include file="$template/includes/tablelist.tpl" tableName="ActsList" noSortColumns="0" noSearch=true noInfo=true}
<script type="text/javascript">
    jQuery(document).ready( function ()
    {
        var table = jQuery('#tableActsList').removeClass('hidden').DataTable();
        table.column(1).visible(false);
        table.column(2).visible(false);
        table.order([1, 'desc'], [2, 'desc']).draw();
        jQuery('#tableLoading').addClass('hidden');
    });
</script>
<ul class="nav nav-tabs">
    {foreach from=$years item=year}
        <li role="presentation" {if $year==$currYear}class="active"{/if}><a href="?y={$year}">{$year}</a></li>
    {/foreach}
</ul>
<div class="table-container clearfix">
    <table id="tableActsList" class="table table-list hidden">
        <thead>
            <tr>
                <th>Акт</th>
                <th>Дата</th>
                <th>Номер</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$listActs item=act}
                <tr onclick="window.location='clientacts.php?y={$act.year}&n={$act.number}'">
                    <td>№ {$act.number} от {$act.day}.{$act.month}.{$act.year}</td>
                    <td>{$act.year}-{$act.month}-{$act.day}</td>
                    <td>{$act.number}</td>
                </tr>
            {/foreach}
        </tbody>
    </table>
    <div class="text-center" id="tableLoading">
        <p><i class="fas fa-spinner fa-spin"></i> {$LANG.loading}</p>
    </div>
</div>

