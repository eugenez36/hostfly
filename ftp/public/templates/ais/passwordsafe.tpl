<center><p style="padding:20px;"><b>{$PS_LANG.ClientAlertChangePasswordBody}</b></p>
  {if $incorrect}<div class="alert alert-warning">{$PSerror}</div><br />{/if}</center>
<form method="post">
  <table style="margin: 0 auto;" cellpadding="0" cellspacing="0" border="0" align="center" class="frame">
    <tr>
      <td><table border="0" align="center" cellpadding="6" cellspacing="0">
          <tr>
            <td width="150" align="right" class="fieldarea">{$PS_LANG.NewPassLabel}:</td>
            <td><input type="password" name="ps_password" autocomplete="off" size="40" /></td>
          </tr>
          <tr>
            <td width="150" align="right" class="fieldarea">{$PS_LANG.NewPassConfirmLabel}:</td>
            <td><input type="password" name="ps_cpassword" autocomplete="off" size="40"" /></td>
          </tr>
          <tr>
            <td width="150" align="right" class="fieldarea">&nbsp;</td>
            <td><input class="btn btn-primary" type="submit" name="PS_submit" value="{$PS_LANG.UpdateBTN}" /></td>
          </tr>
        </table></td>
    </tr>
  </table><br />
</form>