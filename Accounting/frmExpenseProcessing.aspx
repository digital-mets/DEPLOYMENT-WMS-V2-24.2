<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmExpenseProcessing.aspx.cs" Inherits="GWL.frmExpenseProcessing" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Expense Processing</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
        height: 680px; /*Change this whenever needed*/
        }

        .Entry {
        padding: 20px;
        margin: 10px auto;
        background: #FFF;
        }

        /*.dxeButtonEditSys input,
        .dxeTextBoxSys input{
            text-transform:uppercase;
        }*/

         .pnl-content
        {
            text-align: right;
        }

        .statusBar a:first-child
        {
            display: none;
        }
    </style>
    <!--#endregion-->
    
    <!--#region Region Javascript-->
    <script>
        var isValid = true;
        var counterror = 0;
        var clicked;

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

        function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)
            if (s.GetText() == "" || e.value == "" || e.value == null) {
                counterror++;
                isValid = false
            }
            else {
                isValid = true;
            }
        }

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                    gv1.batchEditApi.ValidateRow(indicies[i]);
                    gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("ExpenseCode").index);
                }
                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else {
                        gv1.batchEditApi.ValidateRow(indicies[i]);
                        gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("ExpenseCode").index);
                    }
                }
            }

            gv1.batchEditApi.EndEdit();

            var btnmode = btn.GetText(); //gets text of button
            if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
                //Sends request to server side
                if (btnmode == "Add") {
                    cp.PerformCallback("Add");
                }
                else if (btnmode == "Update") {
                    cp.PerformCallback("Update");
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

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === undefined || e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                if (s.cp_valmsg != null) {
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                }
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);
                if (s.cp_forceclose) {
                    delete (s.cp_forceclose);
                    window.close();
                }
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

            if (s.cp_terms) {
                delete (s.cp_terms);
                cp.PerformCallback('Terms');
            }

            if (s.cp_calculate) {
                delete (s.cp_calculate);
                autocalculate();
            }

            if (s.cp_nodetail != null) {
                alert(s.cp_nodetail);
                delete (s.cp_nodetail);

            }
        }
        var index;
        var itemc;
        var vatc;
        var supc;
        var exp;//variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var valchange = false;
        var valchange2 = false;
        var entry = getParameterByName('entry');
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            exp = s.batchEditApi.GetCellValue(e.visibleIndex, "ExpenseCode");
            vatc = s.batchEditApi.GetCellValue(e.visibleIndex, "VATCode");
            supc = s.batchEditApi.GetCellValue(e.visibleIndex, "SupplierCode");
            index = e.visibleIndex;

            if (entry == "V" || entry == "D") {
                e.cancel = true; //this will made the gridview readonly
            }

            if (entry != "V" && entry != "D") {                
                if (e.focusedColumn.fieldName === "ExpenseCode") {
                    gl.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;

                    if (chkPORef.GetChecked())
                    {
                        e.cancel = true;
                    }
                    else
                    {
                        e.cancel = false;
                    }
                }
                if (e.focusedColumn.fieldName === "SubsiCode") { //Check the column name
                    glSubsiCode.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "ProfitCenterCode") { //Check the column name
                    glProfitCenter.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "CostCenterCode") { //Check the column name
                    glCostCenter.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "SupplierCode") { //Check the column name
                    glSupplier.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;

                    if (chkPORef.GetChecked()) {
                        e.cancel = true;
                    }
                    else {
                        e.cancel = false;
                    }
                }
                if (e.focusedColumn.fieldName === "VATCode") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsVatable") == false) {
                        e.cancel = true;
                    }
                    else {
                        gl3.GetInputElement().value = cellInfo.value; //Gets the column value
                        isSetTextRequired = true;
                    }
                }
                if (e.focusedColumn.fieldName === "IsEWT") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsVatable") == false) {
                        e.cancel = true;
                    }
                    else {
                        e.cancel = false;
                    }
                }
                if (e.focusedColumn.fieldName === "ATCCode") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsEWT") == false) {
                        e.cancel = true;
                    }
                    else {
                        gl2.GetInputElement().value = cellInfo.value; //Gets the column value
                        isSetTextRequired = true;
                    }
                }
            }
            else {
                e.cancel = true;
            }

        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "ExpenseCode") {
                cellInfo.value = gl.GetValue();
                cellInfo.text = gl.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "SubsiCode") {
                cellInfo.value = glSubsiCode.GetValue();
                cellInfo.text = glSubsiCode.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "ProfitCenterCode") {
                cellInfo.value = glProfitCenter.GetValue();
                cellInfo.text = glProfitCenter.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "CostCenterCode") {
                cellInfo.value = glCostCenter.GetValue();
                cellInfo.text = glCostCenter.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "SupplierCode") {
                cellInfo.value = glSupplier.GetValue();
                cellInfo.text = glSupplier.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "VATCode") {
                cellInfo.value = gl3.GetValue();
                cellInfo.text = gl3.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "ATCCode") {
                cellInfo.value = gl2.GetValue();
                cellInfo.text = gl2.GetText().toUpperCase();
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

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                var chckd;
                var chckd2;

                //else 
                if (column.fieldName == "Amount") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                    else if (ASPxClientUtils.Trim(value) < 0) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " must not be negative";
                        isValid = false;
                    }
                }
                //}
                if (column.fieldName == "IsVatable") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (ASPxClientUtils.Trim(value) == true) {
                        chckd2 = true;
                    }
                }
                if (column.fieldName == "VATCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") && chckd2 == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
                if (column.fieldName == "IsEWT") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (ASPxClientUtils.Trim(value) == true) {
                        chckd = true;
                    }
                }
                if (column.fieldName == "ATCCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") && chckd == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
            }
        }

        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
            }

            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate();
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

        function CloseGridLookup() {
            glInvoice.ConfirmCurrentSelection();
            glInvoice.HideDropDown();
        }

        function Clear() {
            glInvoice.SetValue(null);
        }

        var identifier;
        function GridEnd(s, e) {
            //console.log('gridend');
            identifier = s.GetGridView().cp_identifier;
            val = s.GetGridView().cp_codes;
            if (val != null) {
                temp = val.split(';');
            }
            delete (s.GetGridView().cp_identifier);
            delete (s.GetGridView().cp_codes);

            if (valchange && (val != null && val != 'undefined' && val != '')) {
                valchange = false;
                var column = gv1.GetColumn(6);
                ProcessCells2(0, index, column, gv1);
                gv1.batchEditApi.EndEdit();
            }
            
            autocalculate();
        }

        function ProcessCells2(selectedIndex, focused, column, s) {//Auto calculate qty function :D
            if (val == null) {
                val = ";;;;;;;;;";
                temp = val.split(';');
            }

            if (temp[0] == null) {
                temp[0] = 0;
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
            if (temp[7] == null) {
                temp[7] = "";
            }
            if (temp[8] == null) {
                temp[8] = "";
            }
            if (temp[9] == null) {
                temp[9] = "";
            }

            console.log('iden:' + identifier);
            if (selectedIndex == 0) {
                if (identifier == "VAT") {
                    s.batchEditApi.SetCellValue(focused, "VATRate", temp[0]);
                }
                else if (identifier == "ATC") {
                    s.batchEditApi.SetCellValue(focused, "ATCRate", temp[0]);
                }
                else if (identifier == "SupplierCN") {
                    s.batchEditApi.SetCellValue(focused, "SupplierName", temp[0]);
                }
                else {
                    console.log('here');
                    s.batchEditApi.SetCellValue(focused, "ExpenseDescription", temp[0]);
                    s.batchEditApi.SetCellValue(focused, "GLAccountCode", temp[1]);
                    s.batchEditApi.SetCellValue(focused, "SubsiCode", temp[2]);
                    if (temp[3] == "True") {
                        s.batchEditApi.SetCellValue(focused, "IsVatable", gIsVatable.SetChecked = true);
                    }
                    else {
                        s.batchEditApi.SetCellValue(focused, "IsVatable", gIsVatable.SetChecked = false);
                    }

                    s.batchEditApi.SetCellValue(focused, "VATCode", temp[4]);
                    s.batchEditApi.SetCellValue(focused, "VATRate", temp[5]);
                    s.batchEditApi.SetCellValue(focused, "ProfitCenterCode", temp[6]);
                    s.batchEditApi.SetCellValue(focused, "CostCenterCode", temp[7]);
                    s.batchEditApi.SetCellValue(focused, "SupplierCode", temp[8]);
                    s.batchEditApi.SetCellValue(focused, "SupplierName", temp[9]);
                }
            }
        }

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
                num = this.toFixed(Math.max(0, ~~d));
            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };


        function OnInitTrans(s, e) {
            var BizPartnerCode = clBizPartnerCode.GetText(); //here
            factbox.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
            AdjustSize();
        }

        function OnControlsInitialized(s, e) {
            ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                AdjustSize();
            });
        }

        function AdjustSize() {
            var width = Math.max(0, document.documentElement.clientWidth);
            gv1.SetWidth(width - 120);
            gvJournal.SetWidth(width - 120);
        }

        function IsVatableChanged(s, e) {
            if (gv1.batchEditApi.GetCellValue(index, "IsVatable") == false) {
                gv1.batchEditApi.SetCellValue(index, "VATRate", "0.00");
                gv1.batchEditApi.SetCellValue(index, "VATCode", "");
            }
        }

        function autocalculate(s, e) {
            var amount = 0.00;
            var VATRate = 0.00;
            var ATCRate = 0.00;
            var grossvatable = 0.00;
            var grossnonvatable = 0.00;
            var vatamount = 0.00;
            var whtaxamount = 0.00;
            var totalamountdue = 0.00;

            var arrTrans = [];
            var cntr = 0;
            var holder = 0;
            var txt = "";

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        amount = gv1.batchEditApi.GetCellValue(indicies[i], "Amount");
                        ATCRate = gv1.batchEditApi.GetCellValue(indicies[i], "ATCRate");
                        VATRate = gv1.batchEditApi.GetCellValue(indicies[i], "VATRate");

                        gv1.batchEditApi.SetCellValue(indicies[i], "VATAmount", (amount * VATRate).toFixed(2));

                        if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                            vatamount += amount * VATRate;
                            grossvatable += amount;
                        }
                        else {
                            grossnonvatable += amount;
                        }

                        if (gv1.batchEditApi.GetCellValue(indicies[i], "IsEWT") == true) {
                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                                ATCRate = gv1.batchEditApi.GetCellValue(indicies[i], "ATCRate");
                                whtaxamount += amount * ATCRate;
                            }
                        }
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            amount = gv1.batchEditApi.GetCellValue(indicies[i], "Amount");
                            ATCRate = gv1.batchEditApi.GetCellValue(indicies[i], "ATCRate");
                            VATRate = gv1.batchEditApi.GetCellValue(indicies[i], "VATRate");

                            gv1.batchEditApi.SetCellValue(indicies[i], "VATAmount", (amount * VATRate).toFixed(2));

                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                                vatamount += amount * VATRate;
                                grossvatable += amount;
                            }
                            else {
                                grossnonvatable += amount;
                            }

                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsEWT") == true) {
                                if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                                    ATCRate = gv1.batchEditApi.GetCellValue(indicies[i], "ATCRate");
                                    whtaxamount += amount * ATCRate;
                                }
                            }
                        }
                    }
                }

                //FOR RefTrans
                for (var x = 0; x <= indicies.length; x++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[x])) {
                        for (var y = 0; y <= indicies.length; y++) {
                            if (gv1.batchEditApi.GetCellValue(indicies[x], "RecordID") + '-' + gv1.batchEditApi.GetCellValue(indicies[x], "PONumber") == arrTrans[y]) {
                                cntr++;
                            }
                        }
                        if (cntr == 0) {
                            holder++;
                            arrTrans[holder] = gv1.batchEditApi.GetCellValue(indicies[x], "RecordID") + '-' + gv1.batchEditApi.GetCellValue(indicies[x], "PONumber");
                        }
                        else cntr = 0;
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[x]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[x]);
                        else {
                            for (var y = 0; y <= indicies.length; y++) {
                                if (gv1.batchEditApi.GetCellValue(indicies[x], "RecordID") + '-' + gv1.batchEditApi.GetCellValue(indicies[x], "PONumber") == arrTrans[y]) {
                                    cntr++;
                                }
                            }
                            if (cntr == 0) {
                                holder++;
                                if (gv1.batchEditApi.GetCellValue(indicies[x], "RecordID") != null && gv1.batchEditApi.GetCellValue(indicies[x], "PONumber") != null) {
                                    arrTrans[holder] = gv1.batchEditApi.GetCellValue(indicies[x], "RecordID") + '-' + gv1.batchEditApi.GetCellValue(indicies[x], "PONumber");
                                }
                            }
                            else cntr = 0;
                        }
                    }
                }

                for (var z = 0; z <= holder; z++) {
                    if (z == 0 && z == null && z == "undefined")
                        console.log('skip');
                    else {
                        if (arrTrans[z] != 0 && arrTrans[z] != null && z != "undefined")
                        { txt += arrTrans[z] + ";"; }
                    }
                }

                var str = txt;
                str = str.slice(0, -1);
                //END RefTrans

                totalamountdue = (grossvatable + grossnonvatable + vatamount) - whtaxamount;
                //txtvatamount.SetText(vatamount.format(2, 3, ',', '.'));
                //txtgrossvatable.SetText(grossvatable.format(2, 3, ',', '.'));
                //txtgrossnonvatable.SetText(grossnonvatable.format(2, 3, ',', '.'));
                //txtwhvatamount.SetText(whtaxamount.format(2, 3, ',', '.'));
                //txtamountdue.SetText(totalamountdue.format(2, 3, ',', '.'));

                txtvatamount.SetValue(vatamount);
                txtgrossvatable.SetValue(grossvatable);
                txtgrossnonvatable.SetValue(grossnonvatable);
                txtwhvatamount.SetValue(whtaxamount);
                txtamountdue.SetValue(totalamountdue);

                if (chkPORef.GetChecked()) {
                    aglPORef.SetText(str);
                }else
                {
                    aglPORef.SetText("");
                }
            }, 500);
        }

        function OnCancelClick(s, e) {
            gv1.CancelEdit();
            autocalculate();
        }
    </script>
    <!--#endregion-->
</head>
<body style="height: 910px">
<form id="form1" runat="server" class="Entry">
     <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="BizPartner info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="50"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Expense Processing" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="565px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="1050px" style="margin-left: -3px" SettingsAdaptivity-AdaptivityMode="SingleColumnWindowLimit" SettingsAdaptivity-SwitchToSingleColumnAtWindowInnerWidth="600">
<SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600"></SettingsAdaptivity>
                        <Items>
                          <%--<!--#region Region Header --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Document Number">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" AutoCompleteType="Disabled" Enabled="False" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="DocDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Payable To">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglPayables" runat="server" AutoGenerateColumns="False" ClientInstanceName="clBizPartnerCode" DataSourceID="sdsBizPartner" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="False" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Address" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(){cp.PerformCallback('CallbackPayables');}" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Due Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="DueDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Name">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtName" runat="server" ReadOnly="True" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Terms">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="Terms" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="AP Voucher No.">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtAPVoucher" runat="server" ReadOnly="True" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="With PO Reference">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkPORef" runat="server" CheckState="Unchecked" ClientInstanceName="chkPORef" OnLoad="CheckBoxLoad">
                                                                    <ClientSideEvents CheckedChanged="function(s,e){cp.PerformCallback('CallbackCheck');}" />
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="150px" OnLoad="MemoLoad" Width="490px">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Amounts" ColCount="2">
                                                <Items>
                                                    <%--<dx:LayoutItem Caption="Total Gross Vatable Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="TotalGross" runat="server" ClientInstanceName="txtgrossvatable" Number="0" ReadOnly="True" SpinButtons-ShowIncrementButtons="false" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                    <dx:LayoutItem Caption="Total Gross Vatable Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="TotalGross" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="txtgrossvatable" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%--<dx:LayoutItem Caption="Total Gross Non-Vatable Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="TotalGrossNon" runat="server" ClientInstanceName="txtgrossnonvatable" Number="0" ReadOnly="True" SpinButtons-ShowIncrementButtons="false" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                    <dx:LayoutItem Caption="Total Gross Non-Vatable Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="TotalGrossNon" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="txtgrossnonvatable" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%--<dx:LayoutItem Caption="Total VAT Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="TotalVat" runat="server" ClientInstanceName="txtvatamount" Number="0" ReadOnly="True" SpinButtons-ShowIncrementButtons="false" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                    <dx:LayoutItem Caption="Total VAT Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="TotalVat" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="txtvatamount" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                   <%-- <dx:LayoutItem Caption="Total Withholding Tax Amount ">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="TotalWithholding" runat="server" ClientInstanceName="txtwhvatamount" Number="0" ReadOnly="True" SpinButtons-ShowIncrementButtons="false" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                    <dx:LayoutItem Caption="Total Withholding Tax Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="TotalWithholding" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="txtwhvatamount" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%--<dx:LayoutItem Caption="Total Amount Due">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="TotalAmount" runat="server" ClientInstanceName="txtamountdue" Number="0" ReadOnly="True" SpinButtons-ShowIncrementButtons="false" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                    <dx:LayoutItem Caption="Total Amount Due">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="TotalAmount" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="txtamountdue" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Journal Entries">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvJournal" runat="server" AutoGenerateColumns="False" Width="850px" ClientInstanceName="gvJournal"  KeyFieldName="RTransType;TransType"  >
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                            <SettingsPager Mode="ShowAllRecords" />  
                                                            <SettingsEditing Mode="Batch"/>
                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                            <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                                               <ClientSideEvents Init="OnInitTrans" />
                                                              <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="AccountCode" Name="jAccountCode" ShowInCustomizationForm="True" VisibleIndex="0" Width ="120px" Caption="Account Code" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="AccountDescription" Name="jAccountDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width ="150px" Caption="Account Description" >
                                                                </dx:GridViewDataTextColumn>
																<dx:GridViewDataTextColumn FieldName="SubsidiaryCode" Name="jSubsidiaryCode" ShowInCustomizationForm="True" VisibleIndex="2" Width ="120px" Caption="Subsidiary Code" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="SubsidiaryDescription" Name="jSubsidiaryDescription" ShowInCustomizationForm="True" VisibleIndex="3" Width ="150px" Caption="Subsidiary Description" >
                                                                </dx:GridViewDataTextColumn>																
																<dx:GridViewDataTextColumn FieldName="ProfitCenter" Name="jProfitCenter" ShowInCustomizationForm="True" VisibleIndex="4" Width ="120px" Caption="Profit Center" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="CostCenter" Name="jCostCenter" ShowInCustomizationForm="True" VisibleIndex="5" Width ="120px" Caption="Cost Center" >
                                                                </dx:GridViewDataTextColumn>
																<dx:GridViewDataTextColumn FieldName="Debit" Name="jDebit" ShowInCustomizationForm="True" VisibleIndex="6" Width ="120px" Caption="Debit  Amount" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Credit" Name="jCredit" ShowInCustomizationForm="True" VisibleIndex="7" Width ="120px" Caption="Credit Amount" >
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Audit Trail" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Approved By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHApprovedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Approved Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHApprovedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Posted By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPostedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Posted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPostedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px"  KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Settings-ShowStatusBar="Hidden">
                                                        <Settings ShowStatusBar="Hidden"></Settings>
                                                        <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="NextColumn" />
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />
                                                        <SettingsPager PageSize="5">
                                                        </SettingsPager>
                                                        <SettingsEditing Mode="Batch">
                                                        </SettingsEditing>
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
                                                            <Styles>
                                                                <StatusBar CssClass="statusBar">
                                                                </StatusBar>
                                                            </Styles>
                                                            <Columns>
                                                                <dx:GridViewCommandColumn ButtonType="Image"  ShowInCustomizationForm="True" VisibleIndex="0" Width="90px" >            
                                                                    <CustomButtons>
                                                                        <dx:GridViewCommandColumnCustomButton ID="ViewReferenceTransaction">
                                                                        <Image IconID="functionlibrary_lookupreference_16x16"></Image>
                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                        <dx:GridViewCommandColumnCustomButton ID="ViewTransaction">
                                                                        <Image IconID="find_find_16x16"></Image>
                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                    </CustomButtons>
                                                                </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn FieldName="RTransType" Caption="Reference TransType" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly="True"  Name="RTransType" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="REFDocNumber" Caption="Reference DocNumber" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="True" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4" ReadOnly="True" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Caption="DocNumber"  ReadOnly="True" Width="150px">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6"   ReadOnly="True">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>   
                                </Items>
                            </dx:TabbedLayoutGroup>

                            <%-- <!--#endregion --> --%>
                            
                          <%--<!--#region Region Details --> --%>
                            <dx:LayoutGroup Caption="Expense Processing Details">
                                <Items>
                                    <dx:LayoutItem Caption="Reference">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <table>
                                                    <tr>
                                                        <td>  
                                                            <dx:ASPxGridLookup ID="aglPORef" runat="server" DataSourceID="sdsPOReference" SelectionMode="Multiple" Width="1000px"
                                                                KeyFieldName="RecordID" OnLoad="LookupLoad_PORef" TextFormatString="{0}-{1}" OnInit="aglPORef_Init" ClientInstanceName="aglPORef">
                                                                <GridViewProperties>
                                                                    <SettingsBehavior AllowFocusedRow="True"/>
                                                                    <Settings ShowFilterRow="True"/>
                                                                </GridViewProperties>
                                                                <Columns>
                                                                    <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                                    </dx:GridViewCommandColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="RecordID" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="PONumber" Caption="PO Number" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataDateColumn FieldName="PODate" Caption="PO Date" ShowInCustomizationForm="True" VisibleIndex="2" Width="100px" ReadOnly ="true">
                                                                        <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                        <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                        </PropertiesDateEdit>
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataDateColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="SupplierCode" Caption="Supplier Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="Name" Caption="Supplier Name" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataDateColumn FieldName="TargetDeliveryDate" Caption="Target Delivery" ShowInCustomizationForm="True" VisibleIndex="5" Width="100px" ReadOnly ="true">
                                                                        <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                        <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                        </PropertiesDateEdit>
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataDateColumn>
                                                                    <dx:GridViewDataDateColumn FieldName="CommitmentDate" Caption="Commitment Date" ShowInCustomizationForm="True" VisibleIndex="6" Width="100px" ReadOnly ="true">
                                                                        <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                        <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                        </PropertiesDateEdit>
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataDateColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="PRNumber" Caption="PR Number" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="ServiceCode" Caption="Service Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="ServDesc" Caption="Service Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="ServiceQty" Caption="Service Qty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="10">
                                                                        <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="Unit" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="11">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="UnitCost" Caption="Unit Cost" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="12">
                                                                        <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="TotalCost" Caption="Total Cost" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="13">
                                                                        <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataCheckColumn FieldName="AllowProgress" Caption="Allow Progress Billing" ShowInCustomizationForm="True" VisibleIndex="14" Name="gIsVatable" Width="80px">
                                                                        <Settings AllowAutoFilter="True" AutoFilterCondition="Contains"/>
                                                                    </dx:GridViewDataCheckColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="GrossNonVat" Caption="Gross Non Vatable" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="15">
                                                                        <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="GrossVat" Caption="Gross Vatable" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="16">
                                                                        <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="EPNumber" Caption="EP Number" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="17">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                </Columns>                                                                  
                                                            </dx:ASPxGridLookup>
                                                        </td>
                                                        <td>
                                                            <dx:ASPxLabel ID="lblSpace" runat="server" Width="10" Enabled="false">
                                                            </dx:ASPxLabel>
                                                        </td>
                                                        <td>
		                                                    <dx:ASPxButton ID="btnGenerate" runat="server" AutoPostBack="False" Width="120px" Theme="MetropolisBlue" Text="Populate Detail" OnLoad="Button_Load">
                                                                <ClientSideEvents Click="function(s, e) { cp.PerformCallback('CallbackRefPO') }" />
                                                            </dx:ASPxButton>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="" ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">   
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="985px" OnCommandButtonInitialize="gv_CommandButtonInitialize" 
                                                    OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" OnBatchUpdate="gv1_BatchUpdate" 
                                                    KeyFieldName="DocNumber;LineNumber" >
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing"/>                                             
                                                <%--<dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="1000" KeyFieldName="DocNumber;LineNumber;RecordID"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" SettingsBehavior-AllowSort="false"
                                                    OnCustomButtonInitialize="gv1_CustomButtonInitialize" OnInitNewRow="gv1_InitNewRow">--%>
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
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
                                                    <%--<ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick"/>--%>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false"
                                                            VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="False" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="30px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                    <Image IconID="actions_cancel_16x16"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="80px" PropertiesTextEdit-ConvertEmptyStringToNull="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ExpenseCode" VisibleIndex="3" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glExpenseCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    DataSourceID="sdsExpense" KeyFieldName="ServiceCode" ClientInstanceName="gl" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ServiceCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd" DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  
                                                                        ValueChanged="function(s,e){
                                                                        if(exp != gl.GetValue()){
                                                                            gl3.GetGridView().PerformCallback('Expense' + '|' + gl.GetValue());
                                                                            e.processOnServer = false;
                                                                            valchange = true;
                                                                            loader.SetText('Loading...');
                                                                            loader.Show();
                                                                            setTimeout(function(){ 
                                                                            gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField('Amount').index);
                                                                            loader.Hide(); 
                                                                        },500);
                                                                            }
                                                                        }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ExpenseDescription" VisibleIndex="4" ReadOnly="true" Width="200px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="GLAccountCode" VisibleIndex="5" ReadOnly="true" Width="105px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Subsidiary Code" FieldName="SubsiCode" Name="ySubsidiaryCode" ShowInCustomizationForm="True" VisibleIndex="6" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSubsiCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" AutoCallBack="false" ClientInstanceName="glSubsiCode" 
                                                                    DataSourceID="sdsSubsi" KeyFieldName="SubsiCode"  OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{1}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubsiCode" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>       
                                                                    <ClientSideEvents DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Profit Center" FieldName="ProfitCenterCode" Name="yProfitCenter" ShowInCustomizationForm="True" VisibleIndex="7" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glProfitCenter" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glProfitCenter" 
                                                                    DataSourceID="sdsProfitCenter" KeyFieldName="ProfitCenter"  OnLoad="gvLookupLoad" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenter" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>                          
                                                                    <ClientSideEvents DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" ValueChanged="function(s,e){
                                                                                gv1.batchEditApi.EndEdit();
                                                                        }" />                                                 
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Cost Center" FieldName="CostCenterCode" Name="yCostCenter" ShowInCustomizationForm="True" VisibleIndex="8" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glCostCenter" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glCostCenter" 
                                                                    DataSourceID="sdsCostCenter" KeyFieldName="CostCenter"  OnLoad="gvLookupLoad" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenter" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>                       
                                                                    <ClientSideEvents DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  />                                                     
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>                                          
                                                        <dx:GridViewDataSpinEditColumn FieldName="Amount" Name="gAmount" ShowInCustomizationForm="True" VisibleIndex="9" Width="100px">
                                                            <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                    SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged ="autocalculate" />
                                                            </PropertiesSpinEdit>                                                          
                                                        </dx:GridViewDataSpinEditColumn>                                                      
                                                        <dx:GridViewDataTextColumn Caption="Supplier Code" FieldName="SupplierCode" Name="ySupplier" ShowInCustomizationForm="True" VisibleIndex="10" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSupplier" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glSupplier" 
                                                                    DataSourceID="sdsSupplier" KeyFieldName="Supplier"  OnLoad="gvLookupLoad" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Supplier" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents RowClick="function(){clicked = true;}" EndCallback="GridEnd" DropDown="lookup" KeyPress="gridLookup_KeyPress" 
                                                                        KeyDown="gridLookup_KeyDown"  ValueChanged="function(s,e){
                                                                            if(clicked == true){
                                                                                gv1.batchEditApi.EndEdit();
                                                                                gl.GetGridView().PerformCallback('Supplier' + '|' + glSupplier.GetValue());
                                                                                e.processOnServer = false;
                                                                                valchange = true;
                                                                                loader.SetText('Loading...');
                                                                                loader.Show();
                                                                                setTimeout(function(){ 
                                                                                loader.Hide(); 
                                                                            },500);
                                                                                }
                                                                            clicked = false;
                                                                        }"/>                                                                      
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SupplierName" VisibleIndex="11" ReadOnly="true" Width="200px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsVatable" ShowInCustomizationForm="True" VisibleIndex="12" Name="gIsVatable" Width="80px">
                                                            <PropertiesCheckEdit ClientInstanceName ="gIsVatable">
                                                                <ClientSideEvents CheckedChanged ="function(s, e){gv1.batchEditApi.EndEdit(); IsVatableChanged(); autocalculate();}" />
                                                            </PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataTextColumn FieldName="VATCode" VisibleIndex="13" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glVATCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"  OnInit="lookup_Init"
                                                                    DataSourceID="sdsTax" KeyFieldName="TCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
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
                                                                    <ClientSideEvents RowClick="function(){clicked = true;}" EndCallback="GridEnd" DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  ValueChanged="function(s,e){
                                                                            if(clicked == true){
                                                                            if(vatc != gl3.GetValue()){                                                                             
                                                                                gl.GetGridView().PerformCallback('VATCode' + '|' + gl3.GetValue());
                                                                                e.processOnServer = false;
                                                                                valchange = true;
                                                                                loader.SetText('Loading...');
                                                                                loader.Show();
                                                                                setTimeout(function(){ 
                                                                                autocalculate();
                                                                                loader.Hide(); 
                                                                            },500);}
                                                                                }
                                                                            clicked = false;
                                                                        }"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="VATRate" VisibleIndex="13" Width="0px">
                                                            <PropertiesTextEdit ClientInstanceName="txtVATRate"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>                                                                                            
                                                        <dx:GridViewDataSpinEditColumn FieldName="VATAmount" Name="gVATAmount" Caption="VAT Amount" ShowInCustomizationForm="True" VisibleIndex="14" Width="100px" ReadOnly="true">
                                                            <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                    SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsEWT" Caption="EWT" ShowInCustomizationForm="True" VisibleIndex="15" Name="gIsEWT">
                                                            <PropertiesCheckEdit ClientInstanceName ="gIsEWT">
                                                                <ClientSideEvents CheckedChanged ="function(s, e){gv1.batchEditApi.EndEdit(); autocalculate();}" />
                                                            </PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>                                                        
                                                        <dx:GridViewDataTextColumn FieldName="ATCCode" ShowInCustomizationForm="True" VisibleIndex="16" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glATCCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"  
                                                                    DataSourceID="sdsATC" KeyFieldName="ATCCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad"
                                                                        >
                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="OnClick">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ATCCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Rate" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents RowClick="function(){clicked = true;}" EndCallback="GridEnd" DropDown="lookup" KeyPress="gridLookup_KeyPress" 
                                                                        KeyDown="gridLookup_KeyDown"  ValueChanged="function(s,e){
                                                                            if(clicked == true){
                                                                                gv1.batchEditApi.EndEdit();
                                                                                gl.GetGridView().PerformCallback('ATCCode' + '|' + gl2.GetValue());
                                                                                e.processOnServer = false;
                                                                                valchange = true;
                                                                                loader.SetText('Loading...');
                                                                                loader.Show();
                                                                                setTimeout(function(){ 
                                                                                autocalculate();
                                                                                loader.Hide(); 
                                                                            },500);
                                                                                }
                                                                            clicked = false;
                                                                        }"/>       
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ATCRate" VisibleIndex="17" Width="0px">
                                                            <PropertiesTextEdit ClientInstanceName="txtATCRate"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <%-- <dx:GridViewDataTextColumn FieldName="Remarks"  Caption="Remarks" ShowInCustomizationForm="True" VisibleIndex="10" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>--%>
                                                        <dx:GridViewDataTextColumn FieldName="Field1"  Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="20" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Caption="Field2"  Name="Field2" ShowInCustomizationForm="True" VisibleIndex="21" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Caption="Field3"  Name="Field3" ShowInCustomizationForm="True" VisibleIndex="22" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Caption="Field4"  Name="Field4" ShowInCustomizationForm="True" VisibleIndex="23" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Caption="Field5"  Name="Field5" ShowInCustomizationForm="True" VisibleIndex="24" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Caption="Field6"  Name="Field6" ShowInCustomizationForm="True" VisibleIndex="25" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Caption="Field7"  Name="Field7" ShowInCustomizationForm="True" VisibleIndex="26" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8"  Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="27" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9"  Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>  
                                                        <dx:GridViewDataTextColumn FieldName="RecordID" VisibleIndex="30" ReadOnly="true" Width="0">
                                                        </dx:GridViewDataTextColumn>     
                                                        <dx:GridViewDataTextColumn FieldName="Version" VisibleIndex="29" ReadOnly="true" Width="0">
                                                        </dx:GridViewDataTextColumn>   
                                                        <dx:GridViewDataTextColumn FieldName="PONumber" VisibleIndex="30" ReadOnly="true" Width="0">
                                                        </dx:GridViewDataTextColumn>                                                  
                                                    </Columns>
                                                </dx:ASPxGridView>
                                                    <%--<dx:ASPxButton style="margin-left: 896px;" ID="btnCancel" runat="server" Text="Cancel Changes" ClientInstanceName="btnCancel" CausesValidation="false" AutoPostBack="false" UseSubmitBehavior="false">
                                                        <ClientSideEvents Click="OnCancelClick" />
                                                    </dx:ASPxButton>--%>
                                                    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Calculating..."
                                                        ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
                                                        <LoadingDivStyle Opacity="0"></LoadingDivStyle>
                                                    </dx:ASPxLoadingPanel>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                            <%-- <!--#endregion --> --%>
                        </Items>
                    </dx:ASPxFormLayout>
                    <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                <dx:ASPxButton ID="updateBtn" runat="server" Text="Add" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                                    UseSubmitBehavior="false" CausesValidation="true">
                                    <ClientSideEvents Click="OnUpdateClick" />
                                </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
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
                                    <td>
                                        <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false">
                                        <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                        </dx:ASPxButton>
                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false">
                                        <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </form>
    <!--#region Region Datasource-->
    <%-- put all datasource codeblock here --%>
  
<form id="form2" runat="server" visible="false">
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.ExpenseProcessing+ExpenseProcessingDetail" SelectMethod="getdetail" UpdateMethod="UpdateExpenseProcessingDetail" TypeName="Entity.ExpenseProcessing+ExpenseProcessingDetail" DeleteMethod="DeleteExpenseProcessingDetail" InsertMethod="AddExpenseProcessingDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>	
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.ExpenseProcessing+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>    
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.ExpenseProcessing+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsBizPartner" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT SupplierCode AS BizPartnerCode, RTRIM(LTRIM(Name)) AS Name, Address FROM Masterfile.BPSupplierInfo WHERE ISNULL(IsInactive,0) = 0" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Accounting.ExpenseProcessingDetail WHERE DocNumber IS NULL" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsExpense" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ServiceCode, Description,Type FROM Masterfile.[Service] WHERE Type = 'EXPENSE' and ISNULL(IsInactive,0) = 0" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTax" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TCode, Description, Rate FROM Masterfile.[Tax]" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsATC" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ATCCode, Description, Rate FROM Masterfile.[ATC]" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsProfitCenter" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProfitCenterCode AS ProfitCenter, Description FROM Accounting.ProfitCenter WHERE ISNULL(IsInactive,0) = 0" ></asp:SqlDataSource>  
    <asp:SqlDataSource ID="sdsCostCenter" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT CostCenterCode AS CostCenter, Description FROM Accounting.CostCenter WHERE ISNULL(IsInactive,0) = 0" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSubsi" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AccountCode, SubsiCode, Description FROM Accounting.GLSubsiCode WHERE ISNULL(IsInactive,0) = 0" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSupplier" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT SupplierCode AS Supplier, Name AS Name FROM Masterfile.BPSupplierInfo WHERE ISNULL(IsInactive,0) = 0" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsPOReference" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.DocNumber AS PONumber, B.DocDate AS PODate, B.SupplierCode, C.Name, B.TargetDeliveryDate, B.CommitmentDate, A.PRNumber, A.ServiceType AS ServiceCode, A.Description AS ServDesc, 
        A.ServiceQty, A.Unit, A.UnitCost, A.TotalCost, ISNULL(A.IsAllowProgressBilling,0) AS AllowProgress, CASE WHEN ISNULL(A.IsVat,0) = 0 THEN A.ServiceQty * A.UnitCost * ISNULL(A.VATRate,0) ELSE 0 END AS GrossNonVat,
        CASE WHEN ISNULL(A.IsVat,0) = 1 THEN A.ServiceQty * A.UnitCost * ISNULL(A.VATRate,0) ELSE 0 END AS GrossVat, A.EPNumber, A.RecordID FROM Procurement.PurchaseOrderService A
        INNER JOIN Procurement.PurchaseOrder B ON A.DocNumber = B.DocNumber LEFT JOIN Masterfile.BPSupplierInfo C ON B.SupplierCode = C.SupplierCode WHERE 
        ISNULL(B.SubmittedBy,'') != '' AND ISNULL(B.CancelledBy,'') = '' AND B.Status IN ('N','P') AND ISNULL(A.IsClosed,0) = 0 AND 1=0" ></asp:SqlDataSource>	
    <asp:SqlDataSource ID="sdsTransDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT '' AS DocNumber, RIGHT('00000'+ CAST(ROW_NUMBER() OVER (ORDER BY A.DocNumber, A.LineNumber) AS VARCHAR(5)),5) AS LineNumber, A.DocNumber AS PONumber,
        A.ServiceType AS ExpenseCode, A.Description AS ExpenseDescription, ISNULL(B.AccountCode,'N/A') AS GLAccountCode, ISNULL(B.SubsiCode,'N/A') AS SubsiCode, '' AS ProfitCenterCode, '' AS CostCenterCode, ISNULL(A.TotalCost,0) AS Amount, '' AS SupplierCode, '' AS SupplierName,
        ISNULL(A.IsVat,0) AS IsVatable, ISNULL(A.VATCode,'') AS VATCode, ISNULL(A.TotalCost,0) * ISNULL(A.VATRate,0) AS VATAmount, ISNULL(A.VATRate,0) AS VATRate, CONVERT(bit,'FALSE')  AS IsEWT, '' AS ATCCode, 0.00 AS ATCRate, CONVERT(varchar(MAX),'') AS Remarks,
        A.Field1, A.Field2, A.Field3, A.Field4, A.Field5, A.Field6, A.Field7, A.Field8, A.Field9, '2' AS Version, A.RecordID FROM Procurement.PurchaseOrderService A INNER JOIN Masterfile.Service B ON A.ServiceType = B.ServiceCode WHERE 1=0" ></asp:SqlDataSource>
    <!--#endregion-->
    </form> 
</body>
</html>


