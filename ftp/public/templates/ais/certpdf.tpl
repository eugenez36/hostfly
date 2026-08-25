<?php
// color set
$clRed = [219, 46, 106];
$clBlue = [31, 18, 80];
$clWhite = [255, 255, 255];
$clPink = [244, 237, 243];

$bgPage = [246, 253, 255];
$bgHeader = $tplNo == 1 ? $bgPage : $clBlue;
$clHeader = $tplNo == 1 ? $clBlue : $clWhite;
$bgRow1 = $clPink;
$bgRow2 = $clWhite;
$bgDate1 = $tplNo == 1 ? $clWhite : $clRed;
$clDate1 = $tplNo == 1 ? $clRed : $clWhite;
$bgDate2 = $clWhite;
$clDate2 = $clRed;
$bgInfoTitle = $tplNo == 1 ? $clWhite : $clRed;
$clInfoTitle = $tplNo == 1 ? $clRed : $clWhite;

$imgLogo = $tplNo == 1 ? 'logo1.png' : 'logo2.png';

$pdf->AddPage();

$pdf->Rect(0, 0, $pdf->getPageWidth(), $pdf->getPageHeight(), 'F', "", $bgPage);
$pdf->Rect(0, 0, $pdf->getPageWidth(), 40, 'F', "", $bgHeader);
$pdf->Image(ROOTDIR . '/assets/img/cert/bee.png', 15, 41, 180, '', '', '', '', false, 300);

$pdf->Image(ROOTDIR . "/assets/img/cert/{$imgLogo}", 15, 15, 60);

$pdf->SetFont('freesans','',7);
$pdf->setTextColorArray($clHeader);
$headerHtml = '<table width="100%" cellspacing="1" cellpadding="2" border="0">
    <tr>
        <td width="45%" style="text-align:left;"></td>
        <td width="17%" style="text-align:left;"><strong>ООО "Суппорт чейн"<br>УНП 190625072</strong></td>
        <td width="23%" align="left"><strong>Юридический адрес:</strong><br>220062, г. Минск, проспект<br>Победителей д.106, офис 12</td>
        <td width="15%" style="text-align:left;"><strong>+375 17 3367373<br>info@hostfly.by<br>hostfly.by</strong></td>
    </tr>
</table>';
$pdf->writeHTML($headerHtml, true, false, false, false, '');

$pdf->setTextColorArray($clBlue);

$pdf->ln(31); $pdf->SetFont('freesans','B',32);
$pdf->Cell(0,0,'Свидетельство',0,1,'C');

$pdf->SetFont('freesans','',18);
$pdf->Cell(0,0,'о регистрации доменного имени',0,1,'C');

$pdf->ln(8); $pdf->SetFont('freesans','I',13);
$pdf->Cell(0,0,'Настоящим подтверждается регистрация доменного имени',0,1,'C');

$pdf->ln(3); $pdf->SetFont('freesans','BI',24);
$pdf->Cell(0,0,$crtDomain,0,1,'C');

$pdf->ln(3); $pdf->SetFont('freesans','I',13);
$pdf->Cell(0,0,'через аккредитованного регистратора национальных',0,1,'C');
$pdf->Cell(0,0,'доменов BY/БЕЛ ООО “Суппорт чейн”.',0,1,'C');

$pdf->ln(16); $pdf->SetFont('freesans','B',16); $pdf->setTextColorArray($clRed);
$pdf->Cell(0,0,'Информация о доменном имени:',0,1,'L');

$pdf->ln(4); $pdf->SetFont('','B',14);
$pdf->SetLineStyle(['width' => 0.75, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => $clRed]);

$pdf->setFillColorArray($bgDate1); $pdf->setTextColorArray($clDate1);
//$pdf->Cell(90, 15, "Дата регистрации: ".$crtRegDate, 1, 0, 'C', true);

$pdf->setFillColorArray($bgDate2); $pdf->setTextColorArray($clDate2);
$pdf->Cell(90, 15, "Зарегистрирован до: ".$crtExpiryDate, 1, 0, 'C', true);

$pdf->ln(20); $pdf->SetFont('freesans','B',10); $pdf->setTextColorArray($clInfoTitle); //31, 18, 80
$pdf->RoundedRect(20, 175.5, 80, 10, 2.5, '0110', 'DF', ['width' => 0.5, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => $clRed], $bgInfoTitle);
$pdf->ln(1);
$pdf->Cell(5, 0, ""); $pdf->Cell(80, 10, "Информация о владельце домена:", 0, 1, 'C');
$pdf->ln(4);
$pdf->setTextColorArray($clBlue);

if ($crtRegType == 'person') {
    $pdf->setFillColorArray($bgRow1);
    $pdf->Cell(5, 6, "", 0, 0, '', true);
    $pdf->Cell(50, 6, "Фамилия:", 0, 0, '', true);
    $pdf->Cell(125, 6, $crtLastName, 0, 1, '', true);

    $pdf->setFillColorArray($bgRow2);
    $pdf->Cell(5, 6, "", 0, 0, '', true);
    $pdf->Cell(50, 6, "Имя:", 0, 0, '', true);
    $pdf->Cell(125, 6, $crtFirstName, 0, 1, '', true);
    
    $pdf->setFillColorArray($bgRow1);
    $pdf->Cell(5, 6, "", 0, 0, '', true);
    $pdf->Cell(50, 6, "Отчество:", 0, 0, '', true);
    $pdf->Cell(125, 6, $crtMidName, 0, 1, '', true);
} else {
    $pdf->Rect(15, 189, 180, 30, 'F', "", $bgRow1);

    $pdf->setFillColorArray($bgRow1);
    $pdf->Cell(5, 6, "", 0, 0, '', true);
    $pdf->Cell(50, 6, "Название организации:", 0, 0, '', true);
    $pdf->MultiCell(125, 6, $crtCompanyName, 0, 'L', true, 1, '', '', false);
    
    $pdf->setFillColorArray($bgRow2);
    $pdf->Cell(5, 6, "", 0, 0, '', true);
    $pdf->Cell(50, 6, "УНП:", 0, 0, '', true);
    $pdf->Cell(125, 6, $crtUnp, 0, 1, '', true);
    
    $pdf->setFillColorArray($bgRow1);
    $pdf->Cell(5, 6, "", 0, 0, '', true);
    $pdf->Cell(50, 6, "Юридический адрес:", 0, 0, '', true);
    $pdf->MultiCell(125, 6, $crtAddress, 0, 'L', true, 1, '', '', false);
    
    $pdf->setFillColorArray($bgRow2);
    $pdf->Cell(5, 6, "", 0, 0, '', true);
    $pdf->Cell(50, 6, "E-mail:", 0, 0, '', true);
    $pdf->Cell(125, 6, $crtEmail, 0, 1, '', true);
    
    $pdf->setFillColorArray($bgRow1);
    $pdf->Cell(5, 6, "", 0, 0, '', true);
    $pdf->Cell(50, 6, "Телефон:", 0, 0, '', true);
    $pdf->Cell(125, 6, $crtPhone, 0, 1, '', true);
}

$pdf->RoundedRect(15, 175.5, 180, 58, 2.5, '1111', '');

if ($crtRegType == 'person') {
    $pdf->ln(15);
}
$pdf->ln(30); $pdf->SetFont('freesans','B',11);
$footerHtml = '<table width="100%" cellspacing="1" cellpadding="2" border="0">
    <tr>
        <td width="16%">'.$crtToday.'</td>
        <td width="39%">Директор ООО "Суппорт чейн"</td>
        <td width="27%"></td>
        <td width="18%">Воронин П.С.</td>
    </tr>
</table>';
$pdf->writeHTML($footerHtml, true, false, false, false, '');

$pdf->Image(ROOTDIR . '/assets/img/cert/stmp.png', 115, 240, 30);
$pdf->Image(ROOTDIR . '/assets/img/cert/sig.png', 115, 250, 50);
