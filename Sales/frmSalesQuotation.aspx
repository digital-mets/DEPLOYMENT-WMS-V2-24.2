<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmSalesQuotation.aspx.cs" Inherits="GWL.frmSalesQuotation" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
<title>Sales Quotation</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /> 
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script> 
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>  
     
    <style type="text/css"> 
        #form1 {
            height: 800px; 
        } 

        .Entry {
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
        } 

        .pnl-content {
            text-align: right;
        }
    </style>
    <script>

    var isValid = true;
    var counterror = 0;

    function getParameterByName(name) {
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
        return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    }
         
    var module = getParameterByName("transtype");
    var id = getParameterByName("docnumber");
    var entry = getParameterByName("entry");

    $(document).ready(function () {
        PerfStart(module, entry, id);
    });

    function OnValidation(s, e) {
        if (s.GetText() == "" || e.value == "" || e.value == null) {
            counterror++;
            isValid = false
        }
        else {
            isValid = true;
        }
    }

    function OnUpdateClick(s, e) {
        if (btnmode == "Delete") {
            cp.PerformCallback("Delete");
        }
        else {
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                    gv1.batchEditApi.ValidateRow(indicies[i]);
                    gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("ItemCode").index);
                }
                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else {
                        gv1.batchEditApi.ValidateRow(indicies[i]);
                        gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("ItemCode").index);
                    }
                }
            }

            gv1.batchEditApi.EndEdit();

            var btnmode = btn.GetText();
            if (isValid && counterror < 1 || btnmode == "Close") {
                if (btnmode == "Add") {
                    gv1.PerformCallback("Add");
                }
                else if (btnmode == "Update") {
                    gv1.PerformCallback("Update");
                }
                else if (btnmode == "Close") {
                    cp.PerformCallback("Close");
                }
            }
            else {
                counterror = 0;
                alert('Please check all the fields!');
            }
        }
    }
         
    function OnConfirm(s, e) { 
        if (e.requestTriggerID === "gv1") 
            e.cancel = true;
    }

    var initgv = 'true';
    var vatrate =0;
    var vatdetail1 = 0;
    function gridView_EndCallback(s, e) { 

    if (s.cp_success) {
        alert(s.cp_message);
        delete (s.cp_success); 
        delete (s.cp_message);
    }

    if (s.cp_close) {
        if (s.cp_message != null) {
            alert(s.cp_message);
            delete (s.cp_message);
        }
        if (s.cp_valmsg != null) {
            alert(s.cp_valmsg);
            delete (s.cp_valmsg);
        }
        if (glcheck.GetChecked()) {
            delete (cp_close);
            window.location.reload();
        }
        else {
            delete (cp_close);
            window.close(); 
        }
    }

    if (s.cp_delete) {
        delete (cp_delete);
        DeleteControl.Show();
    }

    if (s.cp_forceclose) { 
        delete (s.cp_forceclose);
        window.close();
    }
}

    var index;
    var closing;
    var valchange;
    var valchange2;
    var loading = false;
    var nope = false;
    var nope2 = false;
    var tc;
    var itemc;  
    var currentColumn = null;
    var isSetTextRequired = false;
    var linecount = 1;

    function OnStartEditing(s, e) { 
        currentColumn = e.focusedColumn;
        var cellInfo = e.rowValues[e.focusedColumn.index];
        itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
        tc = s.batchEditApi.GetCellValue(e.visibleIndex, "TaxCode");
        index = e.visibleIndex;
        var entry = getParameterByName('entry');
        if (entry == "V" || entry == "D") {
            e.cancel = true;
        }

        gvRef.cancel = true;

        var cb = gv1.batchEditApi.GetCellValue(e.visibleIndex, "IsVat");

        if (e.focusedColumn.fieldName === "StatusCode") {
            e.cancel = true;
        }

        if (cb == false) {
            if (e.focusedColumn.fieldName === "TaxCode")
                e.cancel = true;
        }
               
        if (entry != 'V' && entry != 'D') {
            if (e.focusedColumn.fieldName === "ItemCode") { 
                gl.GetInputElement().value = cellInfo.value; 
                isSetTextRequired = true;
                nope = false;
                closing = true;
            }
            if (e.focusedColumn.fieldName === "ColorCode") {
                gl2.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "ClassCode") {
                gl3.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "SizeCode") {
                gl4.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "Unit") {
                gl5.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "BulkUnit") {
                glBulkUnit.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "UnitPrice") {
                glUnitPrice.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "TaxCode") {
                if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsVat") == false) {
                    e.cancel = true;
                }
                else {
                    glVatCode.GetInputElement().value = cellInfo.value; 
                    isSetTextRequired = true;
                    nope2 = false;
                    closing = true;
                }
            }
        }
    }

    function OnEndEditing(s, e) {
        var cellInfo = e.rowValues[currentColumn.index]; 
        if (currentColumn.fieldName === "ItemCode") {
            cellInfo.value = gl.GetValue();
            cellInfo.text = gl.GetText(); 
        }
        if (currentColumn.fieldName === "ColorCode") {
            cellInfo.value = gl2.GetValue();
            cellInfo.text = gl2.GetText();
        }
        if (currentColumn.fieldName === "ClassCode") {
            cellInfo.value = gl3.GetValue();
            cellInfo.text = gl3.GetText();
        }
        if (currentColumn.fieldName === "SizeCode") { 
            cellInfo.value = gl4.GetValue();
            cellInfo.text = gl4.GetText();
        }
        if (currentColumn.fieldName === "Unit") {
            cellInfo.value = gl5.GetValue();
            cellInfo.text = gl5.GetText();
        }
        if (currentColumn.fieldName === "BulkUnit") {
            cellInfo.value = glBulkUnit.GetValue();
            cellInfo.text = glBulkUnit.GetText();
        }
        if (currentColumn.fieldName === "TaxCode") {
            cellInfo.value = glVatCode.GetValue();
            cellInfo.text = glVatCode.GetText();
        }
        if (currentColumn.fieldName === "UnitPrice") {
            cellInfo.value = glUnitPrice.GetValue();
            cellInfo.text = glUnitPrice.GetText();
        }
        if (currentColumn.fieldName === "vatrate") {
            cellInfo.value = txtvatrate.GetValue();
            cellInfo.text = txtvatrate.GetText();
        }
        if (currentColumn.fieldName === "StatusCode") {
            cellInfo.value = glpStatusCode.GetValue();
        } 
        if (currentColumn.fieldName === "IsVat") {
            cellInfo.value = chckIsVat.GetValue();
        } 
    }

    var val;
    var temp;
    var clo = false;
    var changing = false;
    var identifier;

    function GridEnd(s, e) {
        identifier = s.GetGridView().cp_identifier;
        val = s.GetGridView().cp_codes;
           
        if (val != null) {
            temp = val.split(';');
            delete (s.GetGridView().cp_codes);
        }
        else {
            val = "";
            delete (s.GetGridView().cp_codes);
        }

        if (identifier == 'sku') {
            if (s.keyFieldName == 'ItemCode' && (itemc == null || itemc == '')) {
                s.SetText('');
                clo = true;
            }
            if (s.keyFieldName == 'TaxCode' && (tc == null || tc == '')) {
                s.SetText('');
                clo = true;
            }
            delete (s.GetGridView().cp_identifier);
        }
          
        if (valchange && (val != null && val != 'undefined' && val != '')) {
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                valchange = false;
                var column = gv1.GetColumn(i);
                if (column.visible == false || column.fieldName == undefined)
                    continue;
                ProcessCells(0, index, column, gv1);
                gv1.batchEditApi.EndEdit();
            }
            changing = false;
            loader.Hide();
        }

        if (valchange2 && (val != null && val != 'undefined' && val != '')) {
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = gv1.GetColumn(i);
                if (column.visible == false || column.fieldName == undefined)
                    continue;
                ProcessCells(0, index, column, gv1);
                gv1.batchEditApi.EndEdit();
            }
            changing = false;
            loader.Hide();
        }

        console.log('TERRRRRRRRRRR   ',valchange2, valchange,val)

        if (clo == true && !changing) {
            clo = false;
            console.log('here');
        }
        else if (clo == false && !changing) {
            loading = false;
            loader.Hide();
            console.log('here2');
        }
        loader.Hide();
        autocalculate();
    }

    var Nanprocessor1 = function (entry) {
        if (isNaN(entry) == true)
            return 0;
        else
            return entry;
    }
    function ProcessCells(selectedIndex, e, column, s) {
        if (val == null) {
            val = ";;;;";
            temp = val.split(';');
        }
        if (temp[0] == null) {
            temp[0] = "";
        }
        if (temp[1] == null) {
            temp[1] = "";
        }
        if (temp[2] == null) {
            temp[2] = "";
        }
        if (temp[3] == null) {
            temp[3] = "";
        }
        if (temp[4] == null) {
            temp[4] = "";
        }
        if (temp[5] == null) {
            temp[5] = "";
        }
        if (temp[6] == null) {
            temp[6] = "";
        }
        if (selectedIndex == 0) { 
            if (identifier == "ItmCde") {
                if (column.fieldName == "ColorCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                }
                if (column.fieldName == "ClassCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[1]);
                }
                if (column.fieldName == "SizeCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[2]);
                }
                if (column.fieldName == "Unit") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[3]);
                }
                if (column.fieldName == "StatusCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[4]);
                } 
                if (column.fieldName == "UnitPrice") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, Nanprocessor1(temp[5]));
                }
                if (column.fieldName == "vatrate") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[6]);
                }
            }
            else if (identifier == "VAT") {
                s.batchEditApi.SetCellValue(index, "vatrate", temp[0]);
                autocalculate();
            }
            valchange2 = false;
            valchange = false;
        }
    }
       
    function lookup(s, e) {
        if (isSetTextRequired) {//Sets the text during lookup for item code
            s.SetText(s.GetInputElement().value);
            isSetTextRequired = false;
        }
    }

    //var preventEndEditOnLostFocus = false;
    function gridLookup_KeyDown(s, e) { //Allows tabbing between gridlookup on details
        isSetTextRequired = false;
        var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
        if (keyCode !== 9) return;
        var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
        if (gv1.batchEditApi[moveActionName]()) {
            ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }
    }

    function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
        var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
        if (keyCode == 13)
            gv1.batchEditApi.EndEdit();
        //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    }

    function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
        gv1.batchEditApi.EndEdit();
    }

      
    Number.prototype.format = function (d, w, s, c) {
        var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
            num = this.toFixed(Math.max(0, ~~d));

        return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
    };

    function autocalculate(s, e) {
        var initial1totalamount = 0.00;
        var amountdiscounted = 0.00;
        var pesoamount = 0.00;
        var pesoamountvat = 0.00;
        var foreignamount = 0.00;
        var grossvatableamount = 0.00;
        var nonvatableamount = 0.00;
        var vatamount = 0.00;
        var unitfreight = 0.00;
        var gvtble = 0.00;
        var vrplsone = 0.00;

        var vat = 0.00;
        var orderedqty = 0.0000;
        var freight = 0.00;
        var exchangerate = 1.00;
        var y = 0.00;
        var unitprice = 0.00;
        var qty = 0.00;

        //if (txtFreight.GetText() == null || txtFreight.GetText() == "")
        //    freight = 0;
        //else
        //    freight = Number(txtFreight.GetText()); //tlav 1/9/16
        if (txtExchangeRate.GetText() == null || txtExchangeRate.GetText() == 0.00)
        {
            exchangerate = 1.00;
            txtExchangeRate.SetText(exchangerate);
        }
        else
            exchangerate = txtExchangeRate.GetText();

        setTimeout(function ()
        {
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            var temp1 = indicies.length;
            var vatamount1 = 0.00;
            var totvat = 0.00;
            var arrunit = [];
            var arrqty = [];
            var cntr = 0;
            var holder = 0;
            var txt1 = "";
            var c = 0;

            var Nanprocessor = function (entry) {
                if (isNaN(entry) == true)
                    return 0;
                else
                    return entry;
            }

            //computation for totalqty
            for (var b = 0; b <= temp1; b++)
            {
                if (gv1.batchEditApi.IsNewRow(indicies[b]))
                {
                    for (var a = 0; a <= temp1; a++) {
                        if (gv1.batchEditApi.GetCellValue(indicies[b], "Unit") == arrunit[a] ) {
                            var ter = gv1.batchEditApi.GetCellValue(indicies[b], "Qty");
                            arrqty[a] += +ter; //adds qty with same unit
                            cntr++; //increment if found an existing unit
                        }
                    }
                    if (cntr == 0 ) {
                        holder++;
                        arrunit[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "Unit"); //add new unit
                        arrqty[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "Qty"); //along with qty
                    }
                    else cntr = 0;
                }
                else
                {
                    var key = gv1.GetRowKey(indicies[b]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[b]);
                    else
                    {
                        for (var a = 0; a <= temp1; a++) {
                            if (gv1.batchEditApi.GetCellValue(indicies[b], "Unit") == arrunit[a] ) {
                                var ter = gv1.batchEditApi.GetCellValue(indicies[b], "Qty");
                                arrqty[a] += +ter; //adds qty with same unit
                                cntr++; //increment if found an existing unit
                            }
                        }
                        if (cntr == 0 ) {
                            holder++;
                            arrunit[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "Unit"); //add new unit
                            arrqty[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "Qty"); //along with qty
                        }
                        else cntr = 0;
                    }
                }
            }
               
            for (c; c <= holder; c++) {
                if (c == 0 && isNaN(arrqty[0]) == true && c == null)
                    console.log('skip');
                else
                {
                    if (arrunit[c] != 0 && arrunit[c] != null)
                    { txt1 += "(" + arrunit[c] + "|" + arrqty[c].format(4, 5, ',', '.') + ") "; }
                }
            }
            txtTotalQty.SetText(txt1);
               
            //computation for others
            for (var i = 0; i < indicies.length; i++)
            {
                if (gv1.batchEditApi.IsNewRow(indicies[i]))
                {
                    unitprice = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
                    qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                    y = gv1.batchEditApi.GetCellValue(indicies[i], "DiscountRate");
                    var discountrate = +y;
                    discountrate /= 100;
                    orderedqty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                    initial1totalamount += unitprice * qty;
                    amountdiscounted += (unitprice * discountrate) * qty;
                    vatamount += orderedqty * unitprice * vat;
                    pesoamount += orderedqty * unitprice;
                    chckvat = gv1.batchEditApi.GetCellValue(indicies[i], "IsVat");
                    vatrate = gv1.batchEditApi.GetCellValue(indicies[i], "vatrate");
                    var addtnl = 1.00 + parseFloat(vatrate);
                    gvtble = unitprice * orderedqty;
                    addtnl = +addtnl + parseFloat(vatrate);
                    vatamount1 = ((((gvtble - (gvtble * discountrate)) / addtnl) * Nanprocessor(vatrate)));
                    console.log('(((' + gvtble + '-(' + gvtble + '*' + discountrate + '))/(' + parseFloat(addtnl).toFixed(2) + '*' + vatrate + '))=' + vatamount1 + '    FORMULALAAAALALALA');

                    if (y != null) {
                        pesoamount -= (orderedqty * unitprice * discountrate);
                        foreignamount = pesoamount / exchangerate;
                    }
                    else { foreignamount += ((orderedqty * unitprice) / exchangerate); }

                    //grossvat and nonvat
                    pesoamountvat = orderedqty * unitprice;
                    if (y != null) {
                        pesoamountvat -= (orderedqty * unitprice * discountrate);
                    }

                    if (chckvat == true && (gv1.batchEditApi.GetCellValue(indicies[i], "TaxCode") != "NONV")) {
                        grossvatableamount += pesoamountvat; //added January 23 this line only
                    }
                    else{
                        nonvatableamount += pesoamountvat
                    }
                }
                else
                {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else
                    {
                        unitprice = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
                        qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                        y = gv1.batchEditApi.GetCellValue(indicies[i], "DiscountRate");
                        var discountrate = +y;
                        discountrate /= 100;
                        orderedqty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                        initial1totalamount += unitprice * qty;
                        amountdiscounted += (unitprice * discountrate) * qty;
                        vatamount += orderedqty * unitprice * vat;
                        pesoamount += orderedqty * unitprice;
                        chckvat = gv1.batchEditApi.GetCellValue(indicies[i], "IsVat");
                        vatrate = gv1.batchEditApi.GetCellValue(indicies[i], "vatrate");
                        var addtnl = 1.00 + parseFloat(vatrate);
                        gvtble = unitprice * orderedqty;
                        addtnl = +addtnl + parseFloat(vatrate);
                        vatamount1 = ((((gvtble - (gvtble * discountrate)) / addtnl) * Nanprocessor(vatrate)));
                        console.log('(((' + gvtble + '-(' + gvtble + '*' + discountrate + '))/(' + parseFloat(addtnl).toFixed(2) + '*' + vatrate + '))=' + vatamount1 + '    FORMULALAAAALALALA');
                        if (y != null) {
                            pesoamount -= (orderedqty * unitprice * discountrate);
                            foreignamount = pesoamount / exchangerate;
                        }
                        else { foreignamount += ((orderedqty * unitprice) / exchangerate); }

                        //grossvat and nonvat
                        pesoamountvat = orderedqty * unitprice;
                        if (y != null) {
                            pesoamountvat -= (orderedqty * unitprice * discountrate);
                        }

                        if (chckvat == true && (gv1.batchEditApi.GetCellValue(indicies[i], "TaxCode") != "NONV")) {
                            grossvatableamount += pesoamountvat; //added January 23 this line only
                        }
                        else {
                            nonvatableamount += pesoamountvat
                        }
                    }
                }
                totvat += Nanprocessor(+vatamount1);
            }

            txtGrossVATableAmount.SetText(grossvatableamount.format(2, 3, ',', '.'));
            txtNonVATableAmount.SetText(nonvatableamount.format(2, 3, ',', '.'));
            txtInitialTotalAmount.SetText(initial1totalamount.format(2, 3, ',', '.')); 
            txtPesoAmount.SetText(pesoamount.format(2, 3, ',', '.'));
            txtAmountDiscounted.SetText(amountdiscounted.format(2, 3, ',', '.'));
            txtForeignAmount.SetText(foreignamount.format(2, 3, ',', '.'));
            console.log(totvat);
            txtVATAmount.SetText(Nanprocessor(totvat).toFixed(2));
        }, 300);
        //detailautocalculate(s, e);
    }

    //unitfreight computation on detail
    function detailautocalculate(s, e) {
        //var unitfreight = 0.00;
        //var totalquantity = 0.00;
        //var totalfreight = 0.00;
        //var Nanprocessor = function (entry) {
        //    if (isNaN(entry) == true)
        //        return 0;
        //    else
        //        return entry;
        //}
        //if (txtFreight.GetText() == null || txtFreight.GetText() == "") totalfreight = 0;
        //else totalfreight = txtFreight.GetText();
           
        //setTimeout(function ()
        //{   
        //    var indicies = gv1.batchEditApi.GetRowVisibleIndices();
        //    for (var i = 0; i < indicies.length; i++) {
        //        if (gv1.batchEditApi.IsNewRow(indicies[i])) {
        //            totalquantity += gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
        //        }
        //        else {
        //            var key = gv1.GetRowKey(indicies[i]);
        //            if (gv1.batchEditApi.IsDeletedRow(key))
        //                console.log("deleted row " + indicies[i]);
        //            else {
        //                totalquantity += gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
        //            }
        //        }
        //    }
        //    unitfreight = totalfreight / totalquantity;
        //    for (var i = 0; i < indicies.length; i++) {
        //        if (gv1.batchEditApi.IsNewRow(indicies[i])) {
        //            gv1.batchEditApi.SetCellValue(indicies[i], "UnitFreight", Nanprocessor(unitfreight).toFixed(2));
        //        }
        //        else {
        //            var key = gv1.GetRowKey(indicies[i]);
        //            if (gv1.batchEditApi.IsDeletedRow(key))
        //                console.log("deleted row " + indicies[i]);
        //            else {
        //                gv1.batchEditApi.SetCellValue(indicies[i], "UnitFreight", Nanprocessor(unitfreight).toFixed(2));
        //            }
        //        }
        //    }
        //}, 500); //tlav 1/9/16 and removed fields
    }

    function OnCustomClick(s, e)
    {

        if (e.buttonID == "Details") {
            var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
            var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
            var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
            var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
            var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
            var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
            var Warehouse = "";
        
            factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
            + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&Warehouse=' + Warehouse);

            


        }
        if (e.buttonID == "Delete")
        {
            gv1.DeleteRow(e.visibleIndex);
            autocalculate(s, e);
            //detailautocalculate(s, e);
            console.log('testing');
        }
        if (e.buttonID == "ViewTransaction") {
            var transtype = s.batchEditApi.GetCellValue(e.visibleIndex, "TransType");
            var docnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "DocNumber");
            var commandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "CommandString");

            window.open(commandtring + '?entry=V&transtype=' + transtype + '&parameters=&iswithdetail=true&docnumber=' + docnumber, '_blank', "", false);
            console.log('ViewTransaction')
        }
        if (e.buttonID == "ViewReferenceTransaction") {

            var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
            var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
            var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
            window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
            console.log('ViewTransaction')
        }
    }
    function OnInitTrans(s, e) {

        var BizPartnerCode = aglCustomerCode.GetText();
       

        factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);

        AdjustSize();
    }

    function OnControlsInitialized(s, e) {
        ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
            AdjustSize();
        });
    }

    function AdjustSize() {
        var width = Math.max(0, document.documentElement.clientWidth);
        gv1.SetWidth(width - 60);
        gvRef.SetWidth(width - 120);
    }

    //validation
    function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
           
        for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
            var column = s.GetColumn(i);
            var chckd;
            var chckd2;
            if (column.fieldName == "IsVat") {
                //console.log(value + " <--first if ");
                //console.log(ASPxClientUtils.Trim(value) + " <--first if ");
                var cellValidationInfo = e.validationInfo[column.index];
                if (!cellValidationInfo) continue;
                var value = cellValidationInfo.value;
                console.log( value + " <--first if ");
                if (ASPxClientUtils.Trim(value) == true) {
                    chckd2 = true;
                }
            }
            if (column.fieldName == "TaxCode") {
                var cellValidationInfo = e.validationInfo[column.index];
                if (!cellValidationInfo) continue;
                var value = cellValidationInfo.value;
                console.log(value + ' val----' + chckd2 + ' check');
                if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") && chckd2 == true) {
                    cellValidationInfo.isValid = false;
                    cellValidationInfo.errorText = column.fieldName + " is required";
                    isValid = false;
                }
                if ((ASPxClientUtils.Trim(value) == "NONV") && chckd2 == true) {
                    cellValidationInfo.isValid = false;
                    cellValidationInfo.errorText = column.fieldName + " mustn't be \"NONV\" when isVat is checked!";
                    isValid = false;
                    console.log('isvalid: ' + isValid);
                }
            }
        } 
    }

    var transtype = getParameterByName('transtype');
    function onload() {
        fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + txtDocnumber.GetText() + '&transtype=' + transtype);
    } 
</script> 
</head>
<body style="height: 910px" onload="onload()">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry" >
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Sales Quotation" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="50"
        ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl> 
        <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
            EnableViewState="False" HeaderText="Notes" Height="370px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="471"
            ShowCloseButton="False" Collapsed="true" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" />
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ID="popup2" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox2" CloseAction="None" 
        EnableViewState="False" HeaderText="BizPartner info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="260"
        ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1200px" Height="370px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback" Init="function(){ if(initgv == 'true'){ cp.PerformCallback('Vat'); initgv = 'false';}}"/>  <%--Init="function(){ if(initgv == 'true'){ cp.PerformCallback('Vat'); initgv = 'false';}}" --%>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="1280px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items> 
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" OnLoad="LookupLoad" ClientInstanceName="txtDocnumber">
                                                        <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <dx:LayoutItem Caption="Document Date:" Name="DocDate" RequiredMarkDisplayMode="Required" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                        <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('Validity');  e.processOnServer = false;}"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <dx:LayoutItem Caption="Customer Code" Name="CustomerCode" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glCustomerCode" runat="server" ClientInstanceName="aglCustomerCode" DataSourceID="sdsCustomer" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('CustomerCodeCase');  e.processOnServer = false; }" />
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns> 
                                                                <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" /> 
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <dx:LayoutItem Caption="Status:" Name="Status" ColSpan="2" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxTextBox ID="txtStatus" runat="server" Width="170px" ReadOnly ="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <dx:LayoutItem Caption="Validity:" Name="Validity" RequiredMarkDisplayMode="Required" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpValidity" runat="server" OnLoad="Date_Load" Width="170px">
                                                        <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <dx:LayoutItem Caption="Target Delivery Date:" Name="TargetDeliveryDate" RequiredMarkDisplayMode="Required" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpTargetDeliveryDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                        <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <%--<dx:LayoutItem Caption="Total Qty:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTotalQty" runat="server" Width="170px" ClientInstanceName="txtTotalQty" ReadOnly ="true">
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> --%>
                                            <%--<dx:LayoutItem Caption="Remarks:" Name="Remarks" ColSpan="2" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxTextBox ID="txtRemarks" runat="server" OnLoad="TextboxLoad" Width="170px" ReadOnly ="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> --%>  
                                            <dx:LayoutItem Caption="Total Qty:" Name="TotalQty:"> 
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="memTotalQty" runat="server" Height="71px" Width="170px" ReadOnly="true" ClientInstanceName="txtTotalQty">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Remarks:" Name="Remarks:"> 
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" Width="170px" OnLoad="Memo_Load">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                           
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field 1:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>

                                    <dx:LayoutGroup Caption="Audit Trail" ColSpan="2" ColCount="2">
                                        <Items>
                                          <dx:LayoutItem Caption="Added By" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                          </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Added Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                          </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Last Edited By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                          </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Last Edited Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                            <ClientSideEvents Validation="function(){isValid = true;}" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                          </dx:LayoutItem>  
                                          <dx:LayoutItem Caption="Approved By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                          </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Approved Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                          </dx:LayoutItem> 
                                          <dx:LayoutItem Caption="Manual Closed By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                          </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Manual Closed Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                          </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                     
                                    <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction">
                                        <Items>
                                            <dx:LayoutGroup Caption="Reference Detail">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Width="860px" ClientInstanceName="gvRef" OnCellEditorInitialize="gv1_CellEditorInitialize" OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  Init="OnInitTrans" />
                                                                    
                                                                    <SettingsPager PageSize="5">
                                                                    </SettingsPager>
                                                                    <SettingsEditing Mode="Batch">
                                                                    </SettingsEditing>
                                                                    <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Reference TransType" FieldName="RTransType" Name="RTransType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="90px" ShowUpdateButton="True" ShowCancelButton="False">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="ViewReferenceTransaction">
                                                                                    <Image IconID="functionlibrary_lookupreference_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                <dx:GridViewCommandColumnCustomButton ID="ViewTransaction">
                                                                                    <Image IconID="find_find_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Reference DocNumber" FieldName="REFDocNumber" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>  
                                </Items>
                            </dx:TabbedLayoutGroup>
                            
			                <dx:LayoutGroup Caption="Amount" ColCount="2">
                                <Items>
                                    <dx:LayoutItem Caption="Initial Total Amount:" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtInitialTotalAmount" runat="server" Width="170px" ClientInstanceName="txtInitialTotalAmount" DisplayFormatString="{0:N}" ReadOnly ="true">
                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem> 
                                    <dx:LayoutItem Caption="Amount Discounted:" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtAmountDiscounted" runat="server" Width="170px" ClientInstanceName="txtAmountDiscounted" DisplayFormatString="{0:N}" ReadOnly ="true" >
                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem> 
                                    <dx:LayoutItem Caption="Peso Amount:" Name="PesoAmount" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtPesoAmount" runat="server" Width="170px" ClientInstanceName="txtPesoAmount" DisplayFormatString="{0:N}" ReadOnly ="true">
                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem> 
                                    <dx:LayoutItem Caption="Foreign Amount:" Name="ForeignAmount" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtForeignAmount" runat="server" Width="170px" ClientInstanceName="txtForeignAmount" DisplayFormatString="{0:N}" ReadOnly ="true">
                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem> 
                                    <dx:LayoutItem Caption="Gross VATable Amount:" Name="GrossVATableAmount" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtGrossVATableAmount" runat="server" Width="170px" ClientInstanceName="txtGrossVATableAmount"  DisplayFormatString="{0:N}" ReadOnly ="true">
                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem> 
                                    <dx:LayoutItem Caption="Non VATable Amount:" Name="NonVATableAmount" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtNonVATableAmount" runat="server" Width="170px" ClientInstanceName="txtNonVATableAmount" DisplayFormatString="{0:N}" ReadOnly ="true">
                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem> 
                                    <dx:LayoutItem Caption="VAT Amount:" Name="VATAmount" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtVATAmount" runat="server" Width="170px" ClientInstanceName="txtVATAmount" DisplayFormatString="{0:N}" ReadOnly ="true">
                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem> 
                                    <dx:LayoutItem Caption="Currency:"  Name="Currency" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtCurrency" runat="server" OnLoad="TextboxLoad" ReadOnly="True" Width="170px">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem> 
                                    <dx:LayoutItem Caption="Terms:" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speTerms" runat="server" Width="170px" ClientInstanceName="txtTerms" OnLoad="SpinEdit_Load" MaxValue="2147483647" Increment="0" SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:N}">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <%--<dx:LayoutItem Caption="Terms">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtTerms" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem> --%>
                                    <%--<dx:LayoutItem Caption="Exchange Rate:" Name="ExchangeRate" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtExchangeRate" runat="server" Width="170px" ClientInstanceName="txtExchangeRate" OnLoad="TextboxLoad">
                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>--%> 
                                    <dx:LayoutItem Caption="Exchange Rate:" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxSpinEdit ID="speExchangeRate" runat="server" Width="170px" ClientInstanceName="txtExchangeRate" OnLoad="SpinEdit_Load" MaxValue="2147483647" Increment="0" SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:N}">
                                                </dx:ASPxSpinEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup> 
                        </Items>
                    </dx:ASPxFormLayout>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>

        <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="1050px" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomCallback="gv1_CustomCallback"
        OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" 
        OnCustomButtonInitialize="gv1_CustomButtonInitialize" OnInitNewRow="gv1_InitNewRow" KeyFieldName="DocNumber;LineNumber">
            <ClientSideEvents Init="OnInitTrans" EndCallback="gridView_EndCallback"></ClientSideEvents>
            <Columns>
                <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False" VisibleIndex="0" />
                <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="false" VisibleIndex="2" Caption="Line" ReadOnly="True" Width="50px" />
                <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="5" Width="100px" Name="glItemCode">
                    <EditItemTemplate>
                        <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" Width="100px" OnInit="itemcode_Init"  
                            DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" OnLoad="gvLookupLoad">
                            <GridViewProperties Settings-ShowFilterRow="true">
                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                            </GridViewProperties>
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                            </Columns>
                            <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  
                                GotFocus="function(s,e){
                                if(nope==false){
                                    nope = true;
                                    loader.Show();
                                    loader.SetText('Loading...');
                                    loading = true;
                                    gl.GetGridView().PerformCallback(); e.processOnServer = false;
                                }
                                }"
                                RowClick="function(s,e){
                                loader.Show();
                                    loader.SetText('Loading...');
                                    changing = true;
                                }"
                                ValueChanged="function(s,e){  
                                if(itemc != gl.GetValue()&&gl.GetValue()!=null){
                                console.log('valchange');
                                gl2.GetGridView().PerformCallback('ItemCode' + '|' + gl.GetValue() + '|' + 'code');
                                console.log('zzzzzzzzzzzz');
                                e.processOnServer = false; valchange2 = true;}
                                }" />
                        </dx:ASPxGridLookup>
                    </EditItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="6" Width="100px" Caption="Color">   
                        <EditItemTemplate>
                        <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ReadOnly ="false"
                            KeyFieldName="ColorCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="100px" OnInit="lookup_Init">
                            <GridViewProperties Settings-ShowFilterRow="true">
                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                            </GridViewProperties>
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                            <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                DropDown="function dropdown(s, e){
                                gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                e.processOnServer = false;
                                }" CloseUp="gridLookup_CloseUp"/>
                        </dx:ASPxGridLookup>
                    </EditItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="8" Width="100px" Name="glClassCode" Caption="Class">
                        <EditItemTemplate>
                        <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init" ReadOnly ="false"
                        KeyFieldName="ClassCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="100px" >
                            <GridViewProperties Settings-ShowFilterRow="true">
                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                    AllowSelectSingleRowOnly="True" />
                            </GridViewProperties>
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" />
                            </Columns>
                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                DropDown="function dropdown(s, e){
                                gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                }" CloseUp="gridLookup_CloseUp"/>
                        </dx:ASPxGridLookup>
                    </EditItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="7" Width="100px" Name ="glSizeCode" Caption="Size">
                    <EditItemTemplate>
                        <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init" ReadOnly ="false"
                        KeyFieldName="SizeCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="100px" >
                            <GridViewProperties Settings-ShowFilterRow="true">
                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                    AllowSelectSingleRowOnly="True" />
                            </GridViewProperties>
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                            </Columns>
                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                DropDown="function dropdown(s, e){
                                gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                }" CloseUp="gridLookup_CloseUp"/>
                        </dx:ASPxGridLookup>
                    </EditItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="Unit" VisibleIndex="11" Width="100px" Caption="Unit" >   
                        <EditItemTemplate>
                        <dx:ASPxGridLookup ID="glUnit" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ReadOnly ="false"
                            KeyFieldName="Unit" DataSourceID="Unitlookup" ClientInstanceName="gl5" TextFormatString="{0}" Width="100px" >
                            <GridViewProperties Settings-ShowFilterRow="true">
                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                            </GridViewProperties>
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="Unit" ReadOnly="True" VisibleIndex="0">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                            <ClientSideEvents ValueChanged="autocalculate" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                DropDown="function dropdown(s, e){
                                gl5.GetGridView().PerformCallback('Unit' + '|' + itemc + '|' + s.GetInputElement().value);
                                }" CloseUp="gridLookup_CloseUp"/>
                        </dx:ASPxGridLookup>
                    </EditItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataCheckColumn FieldName="IsVat" Name="IsVat" ShowInCustomizationForm="True" VisibleIndex="13" Caption="Vatable">
                    <PropertiesCheckEdit ClientInstanceName="chckIsVat" >
                        <ClientSideEvents CheckedChanged="function(s,e){autocalculate(); gv1.batchEditApi.EndEdit();
                        if(s.GetChecked() == false){
                        gv1.batchEditApi.SetCellValue(index, 'TaxCode', 'NONV');
                        gv1.batchEditApi.SetCellValue(index, 'vatrate', '0');} }"/>
                    </PropertiesCheckEdit>
                </dx:GridViewDataCheckColumn>
                <dx:GridViewDataTextColumn FieldName="TaxCode" VisibleIndex="14" Width="100px" >
                    <EditItemTemplate>
                        <dx:ASPxGridLookup ID="glVatCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="itemcode_Init"
                            DataSourceID="MasterfileTax" KeyFieldName="TCode" ClientInstanceName="glVatCode" TextFormatString="{0}" Width="100px"
                                >
                            <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="OnClick">
                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                    AllowSelectSingleRowOnly="True" />
                            </GridViewProperties>
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="TCode" ReadOnly="True" VisibleIndex="0" >
                                    <Settings AutoFilterCondition="Contains" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                    <Settings AutoFilterCondition="Contains" />
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Rate" ReadOnly="True" VisibleIndex="1" >
                                    <Settings AutoFilterCondition="Contains" />
                                </dx:GridViewDataTextColumn>
                            </Columns> 
                            <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  
                                GotFocus="function(s,e){
                                if(nope == false){
                                    nope = true;
                                    loader.Show();
                                    loader.SetText('Loading...');
                                    loading = true;
                                    glVatCode.GetGridView().PerformCallback(); e.processOnServer = false;
                                }
                                }"
                                RowClick="function(s,e){
                                loader.Show();
                                    loader.SetText('Loading...');
                                    changing = true;
                                }"
                                DropDown="lookup"
                                    ValueChanged="function(s,e){
                                if(tc!=glVatCode.GetValue()&&glVatCode.GetValue()!=null){
                                console.log('valchange');
                                gl2.GetGridView().PerformCallback('VatCode' + '|' + glVatCode.GetValue() + '|' + 'code' );
                                valchange2 = true;}}" />
                        </dx:ASPxGridLookup>
                    </EditItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="BulkUnit" Name="BulkUnit" ShowInCustomizationForm="True" VisibleIndex="12" Width="100px" >
                    <EditItemTemplate>
                        <dx:ASPxGridLookup ID="glBulkUnit" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                            DataSourceID="sdsBulkUnit" KeyFieldName="UnitCode" ClientInstanceName="glBulkUnit" TextFormatString="{0}" Width="100px"  >
                            <GridViewProperties Settings-ShowFilterRow="true">
                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                    AllowSelectSingleRowOnly="True" />
                            </GridViewProperties>
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" />
                            </Columns>
                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                        </dx:ASPxGridLookup>
                    </EditItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataSpinEditColumn FieldName="DeliveredQty" VisibleIndex="15" Width="100px" Caption="DeliveredQty" ReadOnly="true">   
                        <PropertiesSpinEdit Increment="0" ClientInstanceName="DeliveredQty" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" AllowMouseWheel="false">
                        <ClientSideEvents ValueChanged="autocalculate" />
                        <SpinButtons ShowIncrementButtons="false"></SpinButtons>
                    </PropertiesSpinEdit>
                </dx:GridViewDataSpinEditColumn>
                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True"  VisibleIndex="1" Width="60px">
                <CustomButtons>
                    <dx:GridViewCommandColumnCustomButton ID="Details">
                        <Image IconID="support_info_16x16"></Image>
                    </dx:GridViewCommandColumnCustomButton>
                    <dx:GridViewCommandColumnCustomButton ID="Delete">
                        <Image IconID="actions_cancel_16x16"></Image>
                    </dx:GridViewCommandColumnCustomButton>
                </CustomButtons>
                </dx:GridViewCommandColumn>
                <dx:GridViewDataSpinEditColumn FieldName="Qty" Name="Qty" ShowInCustomizationForm="True" VisibleIndex="8"  >
                    <PropertiesSpinEdit Increment="0" ClientInstanceName="Qty" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" MaxValue="2147483647" AllowMouseWheel="false">
                        <ClientSideEvents ValueChanged="autocalculate" />
                        <SpinButtons ShowIncrementButtons="false"></SpinButtons>
                    </PropertiesSpinEdit>
                </dx:GridViewDataSpinEditColumn>
                <dx:GridViewDataSpinEditColumn FieldName="UnitPrice" Name="UnitPrice" ShowInCustomizationForm="True" VisibleIndex="9"  >
                    <PropertiesSpinEdit Increment="0" ClientInstanceName="glUnitPrice" DisplayFormatString="{0:N}" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" MaxValue="2147483647" AllowMouseWheel="false">
                        <ClientSideEvents ValueChanged="autocalculate" />
                        <SpinButtons ShowIncrementButtons="false"></SpinButtons>
                    </PropertiesSpinEdit>
                </dx:GridViewDataSpinEditColumn>
                <dx:GridViewDataSpinEditColumn FieldName="DiscountRate" Name="DiscountRate" VisibleIndex="8" >
                    <PropertiesSpinEdit Increment="0" ClientInstanceName="DiscountRate" DisplayFormatString="{0:N}" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" MaxValue="2147483647" AllowMouseWheel="false">
                        <ClientSideEvents ValueChanged="autocalculate" />
                        <SpinButtons ShowIncrementButtons="false"></SpinButtons>
                    </PropertiesSpinEdit>
                </dx:GridViewDataSpinEditColumn>
                <dx:GridViewDataSpinEditColumn FieldName="BulkQty" VisibleIndex="11" Width="80px" Caption="BulkQty">
                    <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}" AllowMouseWheel="false" MaxValue="2147483647">
                     <SpinButtons ShowIncrementButtons="false" ></SpinButtons></PropertiesSpinEdit>
                </dx:GridViewDataSpinEditColumn>            
                <dx:GridViewDataTextColumn FieldName="vatrate" VisibleIndex="30" Width="0px" Caption="vatrate">
                    <PropertiesTextEdit ClientInstanceName="txtvatrate">
                    </PropertiesTextEdit>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataSpinEditColumn FieldName="OrderedQty" VisibleIndex="16" Width="100px" Caption="OrderedQty" ReadOnly ="true">
                    <PropertiesSpinEdit Increment="0" ClientInstanceName="OrderedQty" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" AllowMouseWheel="false" >
                        <ClientSideEvents ValueChanged="autocalculate" />
                        <SpinButtons ShowIncrementButtons="false"></SpinButtons>
                    </PropertiesSpinEdit>
                </dx:GridViewDataSpinEditColumn> 
                <dx:GridViewDataSpinEditColumn FieldName="BaseQty" Name="glpBaseQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="17" Width="0px">
                    <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                    <SpinButtons ShowIncrementButtons="False" Enabled="False" ></SpinButtons>
                    </PropertiesSpinEdit>
                </dx:GridViewDataSpinEditColumn>
                <dx:GridViewDataTextColumn FieldName="StatusCode" Name="glpStatusCode" ShowInCustomizationForm="True" VisibleIndex="18" ReadOnly="True" PropertiesTextEdit-ClientInstanceName="glpStatusCode">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="BarcodeNo" Name="glpBarcodeNo" ShowInCustomizationForm="True" VisibleIndex="19" ReadOnly="True" Width="0px">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataSpinEditColumn FieldName="UnitFactor" Name="glpUnitFactor" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="20" Width="0px">
                    <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                    <SpinButtons ShowIncrementButtons="False" Enabled="False"></SpinButtons>
                    </PropertiesSpinEdit>
                </dx:GridViewDataSpinEditColumn>
                <dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" Width="100px" VisibleIndex="21" FieldName="Field1" UnboundType="String">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" Width="100px" VisibleIndex="22" FieldName="Field2" UnboundType="String">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" Width="100px" VisibleIndex="23" FieldName="Field3" UnboundType="String">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" Width="100px" VisibleIndex="24" FieldName="Field4" UnboundType="String">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" Width="100px" VisibleIndex="25" FieldName="Field5" UnboundType="String">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" Width="100px" VisibleIndex="26" FieldName="Field6" UnboundType="String">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" Width="100px" VisibleIndex="27" FieldName="Field7" UnboundType="String">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" Width="100px" VisibleIndex="28" FieldName="Field8" UnboundType="String" >
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" Width="100px" VisibleIndex="29" FieldName="Field9" UnboundType="String">
                </dx:GridViewDataTextColumn>
            </Columns>
            <ClientSideEvents CustomButtonClick="OnCustomClick" />
            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300" ShowFooter="True"  /> 
            <ClientSideEvents Init="autocalculate" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                    <SettingsEditing Mode="Batch" />
            <SettingsCommandButton>
                <NewButton>
                    <Image IconID="actions_addfile_16x16"></Image>
                </NewButton>
                <EditButton>
                    <Image IconID="actions_addfile_16x16"></Image>
                </EditButton>
                <DeleteButton>
                    <Image IconID="actions_cancel_16x16"></Image>
                </DeleteButton>
            </SettingsCommandButton>
        </dx:ASPxGridView>
        <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <div class="pnl-content">
                    <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" 
                    TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                        <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn" 
                            ClientInstanceName="btn" UseSubmitBehavior="false" CausesValidation="true">
                            <ClientSideEvents Click="OnUpdateClick" />
                        </dx:ASPxButton>
                    </div>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Cloning..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="gv1">
             <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
        <dx:ASPxPopupControl ID="DeleteControl" runat="server" Width="250px" Height="100px" HeaderText="Warning!"
        CloseAction="CloseButton" CloseOnEscape="True" Modal="True" ClientInstanceName="DeleteControl"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Are you sure you want to delete this specific document?" />
                    <table>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                         <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                             <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                             </dx:ASPxButton>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                             <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                             </dx:ASPxButton> 
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
    </form>

    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.S_Quotation" DataObjectTypeName="Entity.S_Quotation" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.S_Quotation+QuotationDetail" DataObjectTypeName="Entity.S_Quotation+QuotationDetail" DeleteMethod="DeleteQuotationDetail" InsertMethod="AddQuotationDetail" UpdateMethod="UpdateQuotationDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.S_Quotation+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource> 

    <asp:SqlDataSource ID="sdsBulkUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select UnitCode from Masterfile.Unit where ISNULL(IsInactive,0) = 0" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Unitlookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select UnitCode AS Unit from Masterfile.Unit where ISNULL(IsInactive,0) = 0" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="MasterfileTax" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TCode, Description, Rate FROM Masterfile.[Tax]  where ISNULL(IsInactive,0) = 0" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT A.BizPartnerCode, A.Name FROM Masterfile.BPCustomerInfo A INNER JOIN Masterfile.BizPartner B ON A.BizPartnerCode = B.BizPartnerCode where ISNULL(A.IsInactive,0) != 1 AND ISNULL(B.IsInactive,0) != 1" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Sales.QuotationDetail where DocNumber is null " OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] where isnull(IsInactive,'')=0" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
</body>
</html>
