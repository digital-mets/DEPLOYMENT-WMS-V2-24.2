<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmCheckVoucher.aspx.cs" Inherits="GWL.frmCheckVoucher" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
   <script src="../js/keyboardNavi.js" type="text/javascript"></script>
    <title>Check Voucher</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 1450px; /*Change this whenever needed*/
        }

         .Entry {
         padding: 20px;
         margin: 10px auto;
         background: #FFF;
         }

        .dxeButtonEditSys input,
        .dxeTextBoxSys input{
            /*text-transform:uppercase;*/
        }

        .pnl-content
        {
            text-align: right;
        }
    </style>
    <!--#endregion-->
    <!--#region Region Javascript-->
    <script>
        var isValid = true;
        var counterror = 0;
        var isValid2 = true;
        var newrow;
        var check = true;

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
                    gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("PayeeName").index);
                }
                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else {
                        gv1.batchEditApi.ValidateRow(indicies[i]);
                        gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("PayeeName").index);
                    }
                }
            }

            gv1.batchEditApi.EndEdit();
            gv2.batchEditApi.EndEdit();
            gv3.batchEditApi.EndEdit();

            var btnmode = btn.GetText(); //gets text of button
            if ((isValid2 && isValid && counterror < 1) || btnmode == "Close") { //check if there's no error then proceed to callback
                //Sends request to server side
                if (btnmode == "Add") {
                    autocalculate();
                    cp.PerformCallback("Add");
                }
                else if (btnmode == "Update") {
                    autocalculate();
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
            if (e.requestTriggerID === "cp" || e.requestTriggerID === undefined)//disables confirmation message upon saving.
                e.cancel = true;
        }
        var prof = '';
        var cost = '';
        var payee = '';
        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);

                if (s.cp_forceclose) {
                    delete (s.cp_forceclose);
                    window.close();
                }
            }
            if (s.cp_close) {
                alert(s.cp_valmsg);
                delete (s.cp_valmsg);
                if (glcheck.GetChecked()) {
                    delete (s.cp_close);
                    window.location.reload();
                }
                else {
                    delete (s.cp_close);
                    window.close();//close window if callback successful
                }
            }
            prof = s.cp_prof;
            cost = s.cp_cost;
            payee = s.cp_payee;

            if (s.cp_trans) {
                delete (s.cp_trans);
                if (glTrans.GetValue() != 'Payment' && glTrans.GetValue() != 'Payment-NT') {
                    gv2.CancelEdit();
                    gv3.CancelEdit();
                    autocalculate();
                }
            }
            if (s.cp_supp) {
                delete (s.cp_supp);
                gv2.CancelEdit();
                gv3.CancelEdit();

                var _indices = gv1.batchEditApi.GetRowVisibleIndices();
                var _payeename = SupplierName.GetText();
                for (var i = 0; i < _indices.length; i++) {
                    var key = gv1.GetRowKey(_indices[i]);
                    if (!gv1.batchEditApi.IsDeletedRow(key)) {
                        gv1.batchEditApi.SetCellValue(_indices[i], 'PayeeName', _payeename);
                    }
                }

                autocalculate();
            }
            if (s.cp_generated) {
                delete (s.cp_generated);
                autocalculate();
            }
        }

        var index;
        var accountcode; //variable required for lookup
        var profitcode;
        var costcode;
        var bankact;
        var currentColumn = null;
        var transd;
        var recordid;
        var nope = false;
        var isSetTextRequired = false;
        var subsicode;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            accountcode = s.batchEditApi.GetCellValue(e.visibleIndex, "AccountCode"); //needed var for all lookups; this is where the lookups vary for
            profitcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ProfitCenterCode");
            costcode = s.batchEditApi.GetCellValue(e.visibleIndex, "CostCenterCode");
            bankact = s.batchEditApi.GetCellValue(e.visibleIndex, "BankAccount");
            transd = s.batchEditApi.GetCellValue(e.visibleIndex, "TransDocNumber");
            subsicode = s.batchEditApi.GetCellValue(e.visibleIndex, "SubsidiaryCode");
            recordid = s.batchEditApi.GetCellValue(e.visibleIndex, "RecordId");
            //if (e.focusedColumn.fieldName === "PayeeName") {
            //    s.batchEditApi.SetCellValue(e.visibleIndex, "PayeeName", payee);
            //}
            if (newrow) {
                gv3.batchEditApi.SetCellValue(e.visibleIndex, 'ProfitCenterCode', prof);
                gv3.batchEditApi.SetCellValue(e.visibleIndex, 'CostCenterCode', cost);
                newrow = false;
            }

            if (entry == 'V' || entry == 'D') {
                e.cancel = true;
            }

            if (e.focusedColumn.fieldName === "TransType" || e.focusedColumn.fieldName === "TransDate" ||
                e.focusedColumn.fieldName === "TransDueDate" || e.focusedColumn.fieldName === "TransAmount" ||
                e.focusedColumn.fieldName === "AccountDescription" || e.focusedColumn.fieldName === "SubsidiaryDescription"
                ) {
                e.cancel = true;
            }
            if (e.focusedColumn.fieldName === "ATCCode") {
                if (s.batchEditApi.GetCellValue(e.visibleIndex, "EWT") == false) {
                    e.cancel = true;
                }
            }
            if (e.focusedColumn.fieldName === "BankAccount") {
                gl.GetInputElement().value = cellInfo.value;
                index = e.visibleIndex;
                isSetTextRequired = true;
            }

            if (e.focusedColumn.fieldName === "TransDocNumber") {
                gl2.GetInputElement().value = cellInfo.value;
                index = e.visibleIndex;
                nope = false;
                isSetTextRequired = true;
            }

            if (e.focusedColumn.fieldName === "ProfitCenterCode") {
                gl5.GetInputElement().value = cellInfo.value;
                index = e.visibleIndex;
                isSetTextRequired = true;
            }

            if (e.focusedColumn.fieldName === "CostCenterCode") {
                gl6.GetInputElement().value = cellInfo.value;
                index = e.visibleIndex;
                isSetTextRequired = true;
            }

            if (e.focusedColumn.fieldName === "Bizpartner") {
                glbizpartner.GetInputElement().value = cellInfo.value;
                index = e.visibleIndex;
                isSetTextRequired = true;
            }

            if (e.focusedColumn.fieldName === "AccountCode") {
                gl3.GetInputElement().value = cellInfo.value;
                index = e.visibleIndex;
                isSetTextRequired = true;
            }
            if (e.focusedColumn.fieldName === "SubsidiaryCode") {
                gl4.GetInputElement().value = cellInfo.value;
                index = e.visibleIndex;
                nope = false;
                isSetTextRequired = true;
            }

            keybGrid = s;
            keyboardOnStart(e);
        }

        var endbank;
        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "BankAccount") {
                cellInfo.value = gl.GetValue();
                cellInfo.text = gl.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "TransDocNumber") {
                cellInfo.value = gl2.GetValue();
                cellInfo.text = gl2.GetText().toUpperCase();
            }

            if (currentColumn.fieldName === "ProfitCenterCode") {
                cellInfo.value = gl5.GetValue();
                cellInfo.text = gl5.GetText().toUpperCase();
            }

            if (currentColumn.fieldName === "CostCenterCode") {
                cellInfo.value = gl6.GetValue();
                cellInfo.text = gl6.GetText().toUpperCase();
            }

            if (currentColumn.fieldName === "AccountCode") {
                cellInfo.value = gl3.GetValue();
                cellInfo.text = gl3.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "SubsidiaryCode") {
                cellInfo.value = gl4.GetValue();
                cellInfo.text = gl4.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "Bizpartner") { 
                cellInfo.value = glbizpartner.GetValue();
                cellInfo.text = glbizpartner.GetText().toUpperCase();
            }
            keyboardOnEnd();
        }
        var gridcheck;
        var valchange = false;
        var valchange2 = false;
        var valchange3 = false;
        var valchange4 = false;
        var identifier;
        var loadlook = false;
        var changing = false;
        function GridEnd(s, e) {
            val = s.GetGridView().cp_codes;
            identifier = s.GetGridView().cp_identifier;
            if (val != null) {
                temp = val.split(';');
            }


          
            delete (s.GetGridView().cp_codes);

            if (identifier == 'change') {
                if (s.keyFieldName == 'SubsiCode' && (subsicode == null || subsicode == '')) {
                    s.SetText("");
                }
                delete (s.GetGridView().cp_identifier);
                loader.Hide();
            }


            if (valchange && (val != null && val != 'undefined' && val != '')) {
                valchange = false;
                for (var i = 0; i < gv2.GetColumnsCount() ; i++) {
                    var column = gv2.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    gridcheck = 2;
                    ProcessCells(0, index, column, gv2);
                }
                gv2.batchEditApi.EndEdit();
                autocalculate();
                loader.Hide();

               
            }
            if (valchange2 && (val != null && val != 'undefined' && val != '')) {
                valchange2 = false;
                for (var i = 0; i < gv3.GetColumnsCount() ; i++) {
                    var column = gv3.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    gridcheck = 3;
                    ProcessCells(0, index, column, gv3);
                }
                gv3.batchEditApi.EndEdit();
                loader.Hide();
            }
            if (valchange3 && (val != null && val != 'undefined' && val != '')) {
                valchange3 = false;
                for (var i = 0; i < gv3.GetColumnsCount() ; i++) {
                    var column = gv3.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    gridcheck = 4;
                    ProcessCells(0, index, column, gv3);
                }
                gv3.batchEditApi.EndEdit();
                loader.Hide();
            }
            if (valchange4 && (val != null && val != 'undefined' && val != '')) {
                valchange4 = false;
                var chnum = 0;

                if (s.GetGridView().cp_supp) {
                    payee = s.GetGridView().cp_payee;
                }

                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                var varCheckNum;
                varCheckNum = temp[2];

                if (indicies.length != 0) {
                    if (isNaN(parseInt(varCheckNum))) {
                        
                        var Check;
                        var NewCheck;
                        var FinalValue;
                        var precision;
                        var len = varCheckNum.length;
                        if (len > 0) {
                            for (var i = 1; i < len ; i++) {

                                Check = varCheckNum.slice(len - i, len);
                                if (!isNaN(parseInt(Check))) {
                                    NewCheck = "";
                                    NewCheck = Check;
                                    precision = i * -1;
                                    Check = "";
                                }
                                else {
                                    break;
                                }
                            }

                            var Count = 0;
                            for (var im = 0; im < indicies.length; im++) {
                                var key = gv1.GetRowKey(indicies[im]);
                                if (!gv1.batchEditApi.IsDeletedRow(key)) {
                                    var gridBankAccount = "";
                                    gridBankAccount = gv1.batchEditApi.GetCellValue(indicies[im], "BankAccount");
                                    if (endbank == gridBankAccount) {
                                        Count++;
                                    }
                                }
                            }

                            FinalValue = ((parseInt(NewCheck)) + (Count)).toString();
                            txtChecknum.SetText(varCheckNum.slice(0, precision) + (FinalValue.lpad("0", NewCheck.length)));
                        }
                    }
                    else {
                        //chnum = parseInt(txtChecknum.GetText());

                        var Count_1 = 0;
                        for (var ix = 0; ix < indicies.length; ix++) {
                            var key_2 = gv1.GetRowKey(indicies[ix]);
                            if (!gv1.batchEditApi.IsDeletedRow(key_2)) {
                                var gridBankAcCount_2 = "";
                                gridBankAcCount_2 = gv1.batchEditApi.GetCellValue(indicies[ix], "BankAccount");

                                if (endbank == gridBankAcCount_2) {
                                    Count_1++;
                                }
                            }
                        }

                        chnum = parseInt(varCheckNum);
                        txtChecknum.SetText(chnum + Count_1);
                    }
                }
                else {
                    txtChecknum.SetText(temp[2]);
                    txtprevBank.SetText(endbank);
                }

                //if (endbank == txtprevBank.GetText()) {
                //    console.log('ditey')
                //    if (isNaN(parseInt(txtChecknum.GetText()))) {
                //        console.log('Not A NUMBER')
                //        var Check;
                //        var NewCheck;
                //        var FinalValue;
                //        var precision;
                //        var len = txtChecknum.GetText().length;
                //        //str = str.slice(0, -1);
                //        if (len > 0)
                //        {
                //            for (var i = 1; i < len ; i++) {
                //                //console.log(len + ' ' + (len - i) + ' ' + (txtChecknum.GetText().slice(len - i, len)) + ' result')
                //                Check = txtChecknum.GetText().slice(len - i, len);
                //                if (!isNaN(parseInt(Check))) {
                //                    NewCheck = "";
                //                    NewCheck = Check;
                //                    precision = i * -1;
                //                    Check = "";
                //                }
                //                else
                //                {
                //                    break;
                //                }

                //                //console.log(NewCheck + ' NewCheck ')
                //            }

                //            //console.log(NewCheck.slice(0, precision + 1) + ' getting occurrence of zero')
                //            //console.log(NewCheck.lpad("0", NewCheck.length) + ' padding')
                //            //console.log(txtChecknum.GetText().slice(0, precision) + ' ' + precision + ' precision')
                //            //console.log(NewCheck + ' NewCheck ' + i)
                //            //console.log(txtChecknum.GetText().slice(0, precision) + ((parseInt(NewCheck)) + 1))

                            
                //            FinalValue = ((parseInt(NewCheck)) + 1).toString();
                //            txtChecknum.SetText(txtChecknum.GetText().slice(0, precision) + (FinalValue.lpad("0", NewCheck.length)));
                            
                //        }
                //    }
                //    else
                //    {
                //        chnum = parseInt(txtChecknum.GetText());
                //        txtChecknum.SetText(chnum + 1);
                //    }                    
                //}
                //else {
                //    txtChecknum.SetText(temp[2]);
                //    txtprevBank.SetText(endbank);
                //}

                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    gridcheck = 5;
                    console.log(identifier, "sasds");
                    ProcessCells(0, index, column, gv1);
                    gv1.batchEditApi.EndEdit();
                    gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField("CheckDate").index);
                }
                
              //  gv1.batchEditApi.EndEdit();
                loader.Hide();
            }

            if (s.keyFieldName == 'DocNumber;SupplierCode;DocDate;AccountCode;SubsiCode;ProfitCenter;CostCenter;RecordId' && (transd == null || transd == '') && s.GetGridView().cp_change) {
                s.SetValue(null);
                delete (s.GetGridView().cp_change);
                loader.Hide();
            }
            if (s.keyFieldName == 'DocNumber;SupplierCode;DocDate;AccountCode;SubsiCode;ProfitCenter;CostCenter;RecordId' && s.GetGridView().cp_change) {
                delete (s.GetGridView().cp_change);
                loader.Hide();
            }
        } //end of GridEnd

        String.prototype.lpad = function (padString, length) {
            var str = this;
            while (str.length < length)
                str = padString + str;
            return str;
        }

        function ProcessCells(selectedIndex, e, column, s) {//Auto calculate qty function :D
            if (val == null) {
                val = ";";
                temp = val.split(';');
            }

            if (selectedIndex == 0) {
                if (gridcheck == 2) {
                    if (column.fieldName == "TransDate") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, new Date(temp[1]));
                    }
                    if (column.fieldName == "TransDueDate") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, new Date(temp[2]));
                    }
                    if (column.fieldName == "TransType") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                    }
                    if (column.fieldName == "TransAccountCode") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[3]);
                    }
                    if (column.fieldName == "TransSubsiCode") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[4]);
                    }
                    if (column.fieldName == "TransProfitCenter") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[5]);
                    }
                    if (column.fieldName == "TransCostCenter") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[6]);
                    }
                    if (column.fieldName == "TransBizPartnerCode") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[7]);
                    }
                    if (column.fieldName == "TransAmount") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[8]);
                    }
                    if (column.fieldName == "TransAppliedAmount") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[9]);
                    }
                    if (column.fieldName == "RecordId") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[10]);
                    }

                }
                else if (gridcheck == 3) {
                    if (column.fieldName == "AccountDescription") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                    }
                }
                else if (gridcheck == 4) {
                    if (column.fieldName == "SubsidiaryDescription") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                    }
                }
                else {
                    if (column.fieldName == "Bank") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                    }
                    if (column.fieldName == "Branch") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[1]);
                    }
                    if (column.fieldName == "CheckNumber") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, txtChecknum.GetText());
                    }
                    if (column.fieldName == "PayeeName") {
                        s.batchEditApi.SetCellValue(index, column.fieldName, payee);
                    }
                }
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
            if (keyCode == 13) {
                gv1.batchEditApi.EndEdit();
                gv3.batchEditApi.EndEdit();
            }

            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                if (column.fieldName == "CheckDate") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    CheckDifference();
                    if (!isValid2) {
                        cellValidationInfo.isValid = isValid2;
                        cellValidationInfo.errorText = "Check Date must not be less than the DocDate";
                        isValid = isValid2;
                    }
                }
                if (column.fieldName == "BankAccount" || column.fieldName == "Bank" || column.fieldName == "Branch"
                    || column.fieldName == "PayeeName" || column.fieldName == "CheckNumber" || column.fieldName == "CheckAmount") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
            }
        }

        function Grid_BatchEditRowValidating2(s, e) {
            for (var i = 0; i < gv2.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                if (column.fieldName == "TransDocNumber" || column.fieldName == "TransAppliedAmount") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
            }
        }

        function OnFileUploadComplete(s, e) {//Loads the excel file into the grid
            gv1.PerformCallback();
        }

        function OnCustomClick(s, e) {
            if (e.buttonID == "ChkDelete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate();
            }
            if (e.buttonID == "CVDelete") {
                gv2.DeleteRow(e.visibleIndex);
                autocalculate();
            }
            if (e.buttonID == "AdjDelete") {
                gv3.DeleteRow(e.visibleIndex);
                autocalculate();
            }
        }

        function CloseGridLookup() {
            glInvoice.ConfirmCurrentSelection();
            glInvoice.HideDropDown();
            //glInvoice.Focus();
        }

        function Clear() {
            glInvoice.SetValue(null);
        }

        function autocalculate(s, e) {
            var check = 0.00;
            var applied = 0.00;
            var totalcheck = 0.00;
            var totalapplied = 0.00;

            var arrTrans = [];
            var cntr = 0;
            var holder = 0;
            var txt = "";

            setTimeout(function () { //New Rows
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        check = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "CheckAmount"));

                        totalcheck += check;
                    }
                    else { //Existing Rows
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            check = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "CheckAmount"));

                            totalcheck += check;
                        }
                    }
                }
                txttotalcheck.SetValue(totalcheck.toFixed(2));

                var indicies2 = gv2.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies2.length; i++) {
                    if (gv2.batchEditApi.IsNewRow(indicies2[i])) {
                        applied = parseFloat(gv2.batchEditApi.GetCellValue(indicies2[i], "TransAppliedAmount"));
                        totalapplied += applied;
                    }
                    else { //Existing Rows
                        var key = gv2.GetRowKey(indicies2[i]);
                        if (gv2.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies2[i]);
                        else {
                            applied = parseFloat(gv2.batchEditApi.GetCellValue(indicies2[i], "TransAppliedAmount"));
                            totalapplied += applied;
                        }
                    }
                }
                txttotalapplied.SetValue(totalapplied.toFixed(2));

                //FOR RefTrans
                for (var x = 0; x < indicies2.length; x++) {
                    if (gv2.batchEditApi.IsNewRow(indicies2[x])) {
                        for (var y = 0; y <= indicies2.length; y++) {
                            if (gv2.batchEditApi.GetCellValue(indicies2[x], "RecordId") + '-' + gv2.batchEditApi.GetCellValue(indicies2[x], "TransDocNumber") == arrTrans[y]) {
                                cntr++;
                            }
                        }
                        if (cntr == 0) {
                            holder++;
                            arrTrans[holder] = gv2.batchEditApi.GetCellValue(indicies2[x], "RecordId") + '-' + gv2.batchEditApi.GetCellValue(indicies2[x], "TransDocNumber");
                        }
                        else cntr = 0;
                    }
                    else {
                        var key = gv2.GetRowKey(indicies2[x]);
                        if (gv2.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies2[x]);
                        else {
                            for (var y = 0; y <= indicies2.length; y++) {
                                if (gv2.batchEditApi.GetCellValue(indicies2[x], "RecordId") + '-' + gv2.batchEditApi.GetCellValue(indicies2[x], "TransDocNumber") == arrTrans[y]) {
                                    cntr++;
                                }
                            }
                            if (cntr == 0) {
                                holder++;
                                if (gv2.batchEditApi.GetCellValue(indicies2[x], "RecordId") != null && gv2.batchEditApi.GetCellValue(indicies2[x], "TransDocNumber") != null) {
                                    arrTrans[holder] = gv2.batchEditApi.GetCellValue(indicies2[x], "RecordId") + '-' + gv2.batchEditApi.GetCellValue(indicies2[x], "TransDocNumber");
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
                //end
                aglTransNo.SetText(str);
                autocalculate2();   //TL 2017-01-03
            }, 500);
            // autocalculate2(); //RA 2016-05-30
        }

        function autocalculate2(s, e) {
          //  OnInitTrans();
            var debit = 0.00;
            var credit = 0.00;
            var totaldebit = 0.00;
            var totalcredit = 0.00;
            var total = 0.00;
            var total2 = 0.00;
            var numcheck =  parseFloat(txttotalcheck.GetValue());
            var totalapplied = parseFloat(txttotalapplied.GetValue());
            setTimeout(function () { //New Rows
                if (glTrans.GetValue() == 'Payment' || glTrans.GetValue() == 'Payment-NT') {
                    var indicies = gv3.batchEditApi.GetRowVisibleIndices();
                    for (var i = 0; i < indicies.length; i++) {
                        if (gv3.batchEditApi.IsNewRow(indicies[i])) {
                            debit = parseFloat(gv3.batchEditApi.GetCellValue(indicies[i], "DebitAmount"));
                            credit = parseFloat(gv3.batchEditApi.GetCellValue(indicies[i], "CreditAmount"));

                            totaldebit += debit;
                            totalcredit += credit;
                            //gv3.batchEditApi.SetCellValue(indicies[i], 'TotalAmount', total.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
                        }
                        else { //Existing Rows
                            var key = gv3.GetRowKey(indicies[i]);
                            if (gv3.batchEditApi.IsDeletedRow(key))
                                console.log("deleted row " + indicies[i]);
                            else {
                                debit = parseFloat(gv3.batchEditApi.GetCellValue(indicies[i], "DebitAmount"));
                                credit = parseFloat(gv3.batchEditApi.GetCellValue(indicies[i], "CreditAmount"));

                                totaldebit += debit;
                                totalcredit += credit;
                                //gv3.batchEditApi.SetCellValue(indicies[i], 'TotalAmount', total);
                            }
                        }
                    }
                    total2 = numcheck + totalapplied - totaldebit + totalcredit;
                    txtVar.SetValue(total2.toFixed(2));
                }
                else
                {
                    txtVar.SetText("0.00");
                }
            }, 500);

            gv3.batchEditApi.EndEdit();
        }

        function CheckDifference() {
            if (txtCheckDate.GetText() != "" && txtDocDate.GetText() != "") {
                var startDate = new Date();
                var endDate = new Date();
                var difference = -1;
                startDate = txtDocDate.GetDate();
                if (startDate != null) {
                    endDate = txtCheckDate.GetDate();
                    var startTime = startDate.getTime();
                    var endTime = endDate.getTime();
                    difference = (endTime - startTime) / 86400000;
                }
                if (difference >= 0) {
                    isValid2 = true;
                }
                else {
                    isValid2 = false;
                }
            }
        }

        function OnInitTrans(s, e) {
            AdjustSize();
            OnInit(s);
            autocalculate();
        }

        function OnControlsInitialized(s, e) {
            ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                AdjustSize();
            });
        }

        function AdjustSize() {
            var width = Math.max(0, document.documentElement.clientWidth);
            gv1.SetWidth(width - 120);
            gv2.SetWidth(width - 120);
            gv3.SetWidth(width - 120);
            gvJournal.SetWidth(width - 120);
        }

        function GenerateDetail(s, e) {
            if (aglTransNo.GetText() != null || aglTransNo.GetText() != "") {
                cp.PerformCallback('CallbackTransNo');
            }
            else
            {
                alert("Select reference transaction(s) first!");
            }
        }



    </script>
    <!--#endregion-->
</head>
<body style="height: 1450px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
<form id="form1" runat="server" class="Entry">
    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Check Voucher" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
        <%--<dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="1450px" ClientInstanceName="cp" OnCallback="cp_Callback">--%>
     <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="1450px" ClientInstanceName="cp" OnCallback="cp_Callback" SettingsLoadingPanel-Enabled="true" SettingsLoadingPanel-Delay="3000" Images-LoadingPanel-Url="..\images\loadinggear.gif" Images-LoadingPanel-Height="30px" Styles-LoadingPanel-BackColor="Transparent" Styles-LoadingPanel-Border-BorderStyle="None" SettingsLoadingPanel-Text="" SettingsLoadingPanel-ShowImage="true" >
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="1450px" Width="850px" style="margin-left: -3px">
                       <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                         <Items>
                          <%--<!--#region Region Header --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="Header" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" ReadOnly="true" AutoCompleteType="Disabled" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Trans Type">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="TransType" runat="server" Width="170px" ClientInstanceName="glTrans" OnLoad="ComboBox_Load">
                                                            <ClientSideEvents Validation="OnValidation" 
                                                            ValueChanged="function() { cp.PerformCallback('Trans'); }"/>
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <Items>
                                                                <dx:ListEditItem Text="Payment (Trade)" Value="Payment" />
                                                                <dx:ListEditItem Text="Payment (Non-Trade)" Value="Payment-NT" />
                                                                <dx:ListEditItem Text="Advances (Trade)" Value="Advances" />
                                                                <dx:ListEditItem Text="Advances (Non-Trade)" Value="Advances-NT" />
                                                                <dx:ListEditItem Text="Payment (Loan)" Value="Payment-LN" />
                                                                <dx:ListEditItem Text="Fund Transfer" Value="Fund Transfer" />
                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="DocDate" runat="server" OnLoad="Date_Load" ClientInstanceName="txtDocDate"  Width="170px">
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function() { cp.PerformCallback('DocDateChange'); }" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Applied Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="TotalAppliedAmount" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="txttotalapplied"
                                                            DisplayFormatString="{0:N}" HorizontalAlign="Right">
                                                        </dx:ASPxTextBox>
                                                        <dx:ASPxTextBox runat="server" ClientInstanceName="txtprevBank" ID="txtprevBank" ClientVisible="false">
                                                        </dx:ASPxTextBox>
                                                        <dx:ASPxTextBox runat="server" ClientInstanceName="txtChecknum" ID="txtChecknum" ClientVisible="false">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Supplier Code" Name="Supplier">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvSupplier" ClientInstanceName="gvSup"  Width="170px" runat="server" DataSourceID="Masterfilebiz" 
                                                            GridViewProperties-SettingsLoadingPanel-Text="" GridViewImages-LoadingPanel-Url="..\images\loadinggear.gif"  GridViewImages-LoadingPanel-Height="30px" GridViewStyles-LoadingPanel-BackColor="Transparent" GridViewProperties-SettingsLoadingPanel-ShowImage="true" GridViewProperties-SettingsLoadingPanel-Delay="3000" GridViewStyles-LoadingPanel-Border-BorderColor="Transparent" 
                                                              KeyFieldName="SupplierCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <Settings ShowFilterRow="true" />
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation" 
                                                                ValueChanged="function() { cp.PerformCallback('Supp'); }" 
                                                                Init="function() {
                                                                    if (check == true) {
                                                                        //cp.PerformCallback('Supp');
                                                                        check = false; 
                                                                    }
                                                                }"/>
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink" >
                                                            </InvalidStyle>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SupplierCode" >
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" >
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns> 
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Check Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="TotalCheckAmount" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="txttotalcheck"
                                                            DisplayFormatString="{0:N}" HorizontalAlign="Right">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Supplier Name">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="SupplierName" runat="server" Width="300px" ReadOnly="true" ClientInstanceName="SupplierName">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>                                            
                                            <dx:LayoutItem Caption="Variance">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtVar" runat="server" Width="170px" ClientInstanceName="txtVar" ReadOnly="true"
                                                            DisplayFormatString="{0:N}" HorizontalAlign="Right">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="txtRemarks" runat="server" Height="71px" OnLoad="MemoLoad" Width="300px">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
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
                                            <dx:LayoutItem Caption="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
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
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Journal Entries">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvJournal" runat="server" AutoGenerateColumns="False" Width="850px" ClientInstanceName="gvJournal"  KeyFieldName="RTransType;TransType"  >
                                                            <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                            <SettingsPager Mode="ShowAllRecords" />  
                                                            <SettingsEditing Mode="Batch"/>
                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Visible" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                            <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
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
                                </Items>
                            </dx:TabbedLayoutGroup>

                            <%-- <!--#endregion --> --%>
                            
                          <%--<!--#region Region Details --> --%>
                            <dx:LayoutGroup Caption="Check Information">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="850"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnInit="gv1_Init" SettingsBehavior-AllowSort="false"
                                                    OnCustomButtonInitialize="gv1_CustomButtonInitialize" OnInitNewRow="gv1_InitNewRow">
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <ClientSideEvents Init="OnInitTrans" />
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false"
                                                            VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="30px" ShowNewButtonInHeader="True">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="ChkDelete">
                                                                <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="70px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BankAccount" VisibleIndex="3" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Width="100px">
                                                            <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glBankAccount" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init3"
                                                                        DataSourceID="Masterfilebank" KeyFieldName="BankAccountCode" ClientInstanceName="gl" TextFormatString="{0}" Width="100px">
                                                                        <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" SettingsPager-PageSize="5">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="BankAccountCode" ReadOnly="True" VisibleIndex="0">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="BankCode" ReadOnly="True" VisibleIndex="0">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents DropDown="lookup" EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                            RowClick="function(s,e) {
                                                                                loader.Show();
                                                                            }" 
                                                                            ValueChanged="function(s,e) {
                                                                                if (bankact != gl.GetValue()) {
                                                                                    gl.GetGridView().PerformCallback('bankacc' + '|' + gl.GetValue());
                                                                                    endbank = gl.GetValue();
                                                                                    e.processOnServer = false;
                                                                                    valchange4 = true;
                                                                                }
                                                                            }"/>
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                         <dx:GridViewDataTextColumn FieldName="Bank" ShowInCustomizationForm="True" VisibleIndex="4" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Branch" ShowInCustomizationForm="True" VisibleIndex="5" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="PayeeName" VisibleIndex="6" PropertiesTextEdit-EncodeHtml="false" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <%--<EditItemTemplate>
                                                                    <dx:ASPxGridLookup Width="80px" ID="glPayee" runat="server" DataSourceID="Masterfilebiz" KeyFieldName="SupplierCode" OnLoad="LookupLoad" TextFormatString="{0}" ClientInstanceName="glPayee">
                                                                        <GridViewProperties>
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        </GridViewProperties>
                                                                        <ClientSideEvents Validation="OnValidation" />
                                                                        <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                            <RequiredField IsRequired="True" />
                                                                        </ValidationSettings>
                                                                        <InvalidStyle BackColor="Pink">
                                                                        </InvalidStyle>
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>--%>
<%--^^^<PropertiesTextEdit EncodeHtml="False"></PropertiesTextEdit>--%>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn FieldName="CheckDate" ShowInCustomizationForm="True" VisibleIndex="7" PropertiesDateEdit-ClientInstanceName="txtCheckDate" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesDateEdit>
                                                                <ClientSideEvents ValueChanged="function(){gv1.batchEditApi.EndEdit();}" />
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="CheckNumber" ShowInCustomizationForm="True" VisibleIndex="8" Width="120px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="CheckAmount" ShowInCustomizationForm="True" VisibleIndex="9" Width="100px" UnboundType="Decimal" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        <PropertiesSpinEdit Increment="0" MinValue="0" MaxValue="999999999" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}"
                                                                 SpinButtons-ShowIncrementButtons="false">
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataCheckColumn Caption="Crossed Check" FieldName="IsCross" ShowInCustomizationForm="True" VisibleIndex="10" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesCheckEdit>
                                                            <ClientSideEvents CheckedChanged="function(){gv1.batchEditApi.EndEdit();}"/>
                                                            </PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>
                                                         <dx:GridViewDataDateColumn FieldName="ReleasedDate" ShowInCustomizationForm="True" VisibleIndex="10" ReadOnly="true" PropertiesDateEdit-ClientInstanceName="txtReleasedDate" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataDateColumn>
                                                         <dx:GridViewDataDateColumn FieldName="ClearedDate" ShowInCustomizationForm="True" VisibleIndex="11" ReadOnly="true" PropertiesDateEdit-ClientInstanceName="txtClearedDate" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" VisibleIndex="11" Caption="Field1" Name="Field1" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Caption="Field2"  Name="Field2" ShowInCustomizationForm="True" VisibleIndex="12" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Caption="Field3"  Name="Field3" ShowInCustomizationForm="True" VisibleIndex="13" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Caption="Field4"  Name="Field4" ShowInCustomizationForm="True" VisibleIndex="14" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Caption="Field5"  Name="Field5" ShowInCustomizationForm="True" VisibleIndex="15" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Caption="Field6"  Name="Field6" ShowInCustomizationForm="True" VisibleIndex="16" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Caption="Field7"  Name="Field7" ShowInCustomizationForm="True" VisibleIndex="17" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8"  Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="18" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9"  Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="19" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                    <SettingsPager Mode="ShowAllRecords"/> 
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Visible" VerticalScrollableHeight="200"
                                                        ColumnMinWidth="120" ShowStatusBar="Hidden" /> 
                                                    <SettingsEditing Mode="Batch" />
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>

                            <dx:LayoutGroup Caption="Tagging of Documents">
                               <Items>
                                    <dx:LayoutItem Caption="Transaction No" Name="TransactionNo">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <table>
                                                    <tr>
                                                        <td>  
                                                            <dx:ASPxGridLookup ID="aglTransNo" runat="server" DataSourceID="sdsRefTrans" SelectionMode="Multiple" Width="1000px"
                                                                KeyFieldName="RecordId" OnLoad="LookupLoad" TextFormatString="{0}-{2}" OnInit="aglTransNo_Init" ClientInstanceName="aglTransNo" >
                                                                <ClientSideEvents Init="OnInitTrans" />
                                                                <GridViewProperties>
                                                                    <SettingsBehavior AllowFocusedRow="True" />
                                                                    <Settings ShowFilterRow="True" />
                                                                </GridViewProperties>
                                                                <Columns>
                                                                    <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" SelectAllCheckboxMode="AllPages" VisibleIndex="0" Width="30px">
                                                                    </dx:GridViewCommandColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="RecordId" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="TransType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataDateColumn FieldName="DocDate" ShowInCustomizationForm="True" VisibleIndex="3" Width="100px" ReadOnly ="true">
                                                                        <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                        <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                        </PropertiesDateEdit>
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataDateColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="SubsiCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="ProfitCenter" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CostCenter" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="Amount" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9">
                                                                        <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CounterReceiptNo" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="10">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="Reference" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="11">
                                                                        <Settings AutoFilterCondition="Contains" />
                                                                    </dx:GridViewDataTextColumn>
                                                                </Columns>                                                              
                                                            </dx:ASPxGridLookup>
                                                        </td>
                                                        <td>
		                                                    <dx:ASPxLabel ID="lblSpace" runat="server" Width="10px" Enabled="false">
		                                                    </dx:ASPxLabel>
                                                        </td>
                                                        <td>
		                                                    <dx:ASPxButton ID="btnGenerate" runat="server" AutoPostBack="False" Width="130px" Theme="MetropolisBlue" Text="Populate Detail" OnLoad="Button_Load" UseSubmitBehavior="false">
                                                                <ClientSideEvents Click="GenerateDetail" />
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
                                                <dx:ASPxGridView ID="gv2" runat="server" AutoGenerateColumns="False" Width="960" KeyFieldName="RecordId"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv2"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv2_BatchUpdate" OnInit="gv1_Init" SettingsBehavior-AllowSort="false"
                                                    OnCustomButtonInitialize="gv1_CustomButtonInitialize">
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <ClientSideEvents Init="OnInitTrans" CustomButtonClick="OnCustomClick"/>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="70px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                         <dx:GridViewDataTextColumn FieldName="RecordId" VisibleIndex="3" Visible="true" Width="0px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="30px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="CVDelete">
                                                                <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransDocNumber" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransType" VisibleIndex="4" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn FieldName="TransDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn FieldName="TransDueDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataDateColumn>
                                                         <dx:GridViewDataSpinEditColumn FieldName="TransAmount" ShowInCustomizationForm="True" VisibleIndex="7" Width="120px" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}" >
                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="TransAppliedAmount" ShowInCustomizationForm="True" VisibleIndex="8" Width="120px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}" >
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransAccountCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                              <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransSubsiCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="10" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                              <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransProfitCenter" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="11" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                              <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransCostCenter" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="12" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                              <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransBizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="13" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                              <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" VisibleIndex="14" Caption="Field1" Name="Field1" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Caption="Field2"  Name="Field2" ShowInCustomizationForm="True" VisibleIndex="15" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Caption="Field3"  Name="Field3" ShowInCustomizationForm="True" VisibleIndex="16" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Caption="Field4"  Name="Field4" ShowInCustomizationForm="True" VisibleIndex="17" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Caption="Field5"  Name="Field5" ShowInCustomizationForm="True" VisibleIndex="18" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Caption="Field6"  Name="Field6" ShowInCustomizationForm="True" VisibleIndex="19" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Caption="Field7"  Name="Field7" ShowInCustomizationForm="True" VisibleIndex="20" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8"  Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="21" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9"  Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="22" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Version"  Caption="Version" Name="Version" ShowInCustomizationForm="True" VisibleIndex="23" UnboundType="Bound" Width="0">
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                    <SettingsPager Mode="ShowAllRecords"/> 
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" VerticalScrollableHeight="300"
                                                        ColumnMinWidth="120" ShowStatusBar="Hidden" /> 
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating2"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <SettingsEditing Mode="Batch" />
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <%--<dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv2" runat="server" AutoGenerateColumns="False" Width="960" KeyFieldName="DocNumber;LineNumber"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv2"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnInit="gv1_Init" SettingsBehavior-AllowSort="false"
                                                    OnCustomButtonInitialize="gv1_CustomButtonInitialize">
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <ClientSideEvents Init="OnInitTrans" />
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="50px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                         <dx:GridViewDataTextColumn FieldName="RecordId" VisibleIndex="3" Visible="true" Width="0px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="30px">
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransDocNumber" ShowInCustomizationForm="True" VisibleIndex="3">
                                                        <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glTransDoc" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init4"
                                                                        DataSourceID="TransDocs" KeyFieldName="DocNumber;SupplierCode;DocDate;AccountCode;SubsiCode;ProfitCenter;CostCenter;RecordId" ClientInstanceName="gl2" TextFormatString="{0}" Width="80px">
                                                                        <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="OnClick" SettingsPager-PageSize="5">
                                                                            <SettingsBehavior AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" AllowFocusedRow="true"/>
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" VisibleIndex="0">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" VisibleIndex="1">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="DocDate" ReadOnly="True" VisibleIndex="2" PropertiesTextEdit-DisplayFormatString="{0:MM/dd/yyyy}">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="3">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="SubsiCode" ReadOnly="True" VisibleIndex="4">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="ProfitCenter" ReadOnly="True" VisibleIndex="5">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="CostCenter" ReadOnly="True" VisibleIndex="6">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Amount" Caption="Balance" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Applied" Visible="false" ReadOnly="True" VisibleIndex="8">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="RecordId" ReadOnly="True" VisibleIndex="9">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                             <dx:GridViewDataTextColumn FieldName="Reference" ReadOnly="True" VisibleIndex="9">
                                                                           <Settings AutoFilterCondition="Contains" />
                                                                                  </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents 
                                                                         QueryCloseUp="function(s,e){
                                                                            var g = gl2.GetGridView();
                                                                            var a = g.GetRowKey(g.GetFocusedRowIndex());
                                                                            var b = a.split('|');
                                                                            if(b[0] == transd){
                                                                            gv2.batchEditApi.EndEdit();
                                                                            }
                                                                            else{
                                                                            loader.Show();
                                                                            loader.SetText('Loading...');
                                                                            }
                                                                         }"
                                                                         GotFocus="function(s,e){
                                                                         var g = gl2.GetGridView();
                                                                         console.log('test');
                                                                         if(nope==false){
                                                                         nope = true;
                                                                         loader.Show();
                                                                         loader.SetText('Loading lookup...');
                                                                         g.PerformCallback('trans2doc' + '|' + gvSup.GetText() + '|' + s.GetInputElement().value + '|' + RecordId);
                                                                         e.processOnServer = true;
                                                                         }
                                                                         }"
                                                                         ValueChanged="function(s,e){
                                                                         //if(transd!=gl2.GetValue()&&gl2.GetValue()!=null){
                                                                            var g = gl2.GetGridView();
                                                                            g.PerformCallback(g.GetRowKey(g.GetFocusedRowIndex()));
                                                                            console.log(g.GetRowKey(g.GetFocusedRowIndex()));
                                                                            valchange = true;  
                                                                         //}
                                                                         }"
                                                                         EndCallback="GridEnd"
                                                                         KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransType" VisibleIndex="4" ReadOnly="true">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup runat="server" OnInit="lookup_Init" ClientInstanceName="gltrans">
                                                                    <ClientSideEvents EndCallback="GridEnd" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn FieldName="TransDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn FieldName="TransDueDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
                                                        </dx:GridViewDataDateColumn>
                                                         <dx:GridViewDataSpinEditColumn FieldName="TransAmount" ShowInCustomizationForm="True" VisibleIndex="7" Width="120px" ReadOnly="true">
                                                        <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}" >
                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="TransAppliedAmount" ShowInCustomizationForm="True" VisibleIndex="8" Width="120px">
                                                        <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}" >
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransAccountCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9">
                                                              <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransSubsiCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="10">
                                                              <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransProfitCenter" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="11">
                                                              <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransCostCenter" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="12">
                                                              <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransBizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="13">
                                                              <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" VisibleIndex="14" Caption="Field1" Name="Field1">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Caption="Field2"  Name="Field2" ShowInCustomizationForm="True" VisibleIndex="15" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Caption="Field3"  Name="Field3" ShowInCustomizationForm="True" VisibleIndex="16" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Caption="Field4"  Name="Field4" ShowInCustomizationForm="True" VisibleIndex="17" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Caption="Field5"  Name="Field5" ShowInCustomizationForm="True" VisibleIndex="18" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Caption="Field6"  Name="Field6" ShowInCustomizationForm="True" VisibleIndex="19" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Caption="Field7"  Name="Field7" ShowInCustomizationForm="True" VisibleIndex="20" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8"  Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="21" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9"  Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="22" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                    <SettingsPager Mode="ShowAllRecords"/> 
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating2"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                            <SettingsEditing Mode="Batch" />
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>--%>
                                </Items>
                            </dx:LayoutGroup>
                            <dx:LayoutGroup Caption="Adjusment Entry">
                               <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv3" runat="server" AutoGenerateColumns="False" Width="960" KeyFieldName="DocNumber;LineNumber"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv3"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnInit="gv1_Init" SettingsBehavior-AllowSort="false"
                                                    OnCustomButtonInitialize="gv1_CustomButtonInitialize" OnInitNewRow="gv3_InitNewRow">
                                                    <ClientSideEvents Init="OnInitTrans" />
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false"
                                                            VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="40px" Name="NewButtonCol">
                                                            <HeaderCaptionTemplate>
                                                                <dx:ASPxButton Width="10" ID="btnNew" runat="server" HoverStyle-BackColor="Transparent" Border-BorderColor="Transparent" Image-IconID="actions_addfile_16x16"
                                                                    AutoPostBack="false" UseSubmitBehavior="false" OnLoad="Button_Load">
                                                                    <ClientSideEvents Click="function (s, e) { 
                                                                        newrow = true;
                                                                        gv3.AddNewRow(); 
                                                                        }" />
                                                                </dx:ASPxButton>
                                                            </HeaderCaptionTemplate>
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="AdjDelete">
                                                                <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="70px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" VisibleIndex="3" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glAccountCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                        DataSourceID="COA" KeyFieldName="AccountCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="100px">
                                                                        <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" SettingsPager-PageSize="5">
                                                                            <SettingsBehavior AllowSelectByRowClick="True" AllowSelectSingleRowOnly="true"
                                                                                AllowFocusedRow="true" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="0">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                             LostFocus="function(s,e){
                                                                             if(accountcode!=gl3.GetValue()&&gl3.GetValue()!=null){
                                                                             loader.Show();
                                                                             loader.SetText('Setting Description...');
                                                                             glaccountdes.GetGridView().PerformCallback('accountcode' + '|' + gl3.GetValue());
                                                                             e.processOnServer = false;
                                                                             valchange2 = true;
                                                                             changing = true;
                                                                             gv3.batchEditApi.SetCellValue(index, 'SubsidiaryCode', null);
                                                                             gv3.batchEditApi.SetCellValue(index, 'SubsidiaryDescription', null);
                                                                                }
                                                                            }"
                                                                             ValueChanged="function(s,e){
                                                                             if(accountcode!=gl3.GetValue()&&gl3.GetValue()!=null){
                                                                             loader.Show();
                                                                             loader.SetText('Setting Description...');
                                                                             glaccountdes.GetGridView().PerformCallback('accountcode' + '|' + gl3.GetValue());
                                                                             e.processOnServer = false;
                                                                             valchange2 = true;
                                                                             changing = true;
                                                                             gv3.batchEditApi.SetCellValue(index, 'SubsidiaryCode', null);
                                                                             gv3.batchEditApi.SetCellValue(index, 'SubsidiaryDescription', null);
                                                                                }
                                                                             }"/>
                                                                    </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="AccountDescription" VisibleIndex="4" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" >
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup runat="server" OnInit="lookup_Init" ClientInstanceName="glaccountdes">
                                                                    <ClientSideEvents EndCallback="GridEnd" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubsidiaryCode" VisibleIndex="5" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Width="100px">
                                                        <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSubsidiaryCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init" 
                                                                        DataSourceID="Subsi" KeyFieldName="SubsiCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="100px">
                                                                        <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" SettingsPager-PageSize="5">
                                                                            <SettingsBehavior AllowSelectByRowClick="True" AllowFocusedRow="true"
                                                                                AllowSelectSingleRowOnly="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="SubsiCode" ReadOnly="True" VisibleIndex="0">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="1">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="2">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents
                                                                            EndCallback="GridEnd"
                                                                            GotFocus="function dropdown(s, e){
                                                                            if(nope==false){
                                                                            nope = true;
                                                                            loader.Show();
                                                                            loader.SetText('Loading lookup...');
                                                                                gl4.GetGridView().PerformCallback('SubsiGetCode' + 
                                                                            '|' + accountcode + '|' + s.GetInputElement().value);
                                                                                }
                                                                            }"
                                                                         KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" ValueChanged="function(s,e){
                                                                         if(subsicode!=gl4.GetValue()&&gl4.GetValue()!=null){ 
                                                                         loader.Show();
                                                                         loader.SetText('Setting Description...');
                                                                         glaccountdes.GetGridView().PerformCallback('subsicode' + '|' + gl4.GetValue() + '|' +  accountcode);
                                                                         e.processOnServer = false;
                                                                         valchange3 = true;
                                                                            }
                                                                        }" />
                                                                    </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubsidiaryDescription" ShowInCustomizationForm="True" VisibleIndex="6" UnboundType="Bound" ReadOnly="True" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" ShowInCustomizationForm="True" VisibleIndex="7" UnboundType="Bound" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False"> 
                                                        <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glProfitCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                        DataSourceID="Profitsql" KeyFieldName="ProfitCenterCode" ClientInstanceName="gl5" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
                                                                        <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" SettingsPager-PageSize="5">
                                                                            <SettingsBehavior AllowSelectByRowClick="True" AllowSelectSingleRowOnly="true"
                                                                                AllowFocusedRow="true" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" ReadOnly="True" VisibleIndex="0">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  ValueChanged="function(){ 
                                                                             if(profitcode!=gl5.GetValue()&&gl5.GetValue()!=null){ 
                                                                             gv3.batchEditApi.SetCellValue(index, 'CostCenterCode', null);
                                                                             gv3.batchEditApi.EndEdit();
                                                                             }}"/>
                                                                    </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" ShowInCustomizationForm="True" VisibleIndex="8" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glCostcode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init2" 
                                                                        DataSourceID="Costsql" KeyFieldName="CostCenterCode" ClientInstanceName="gl6" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
                                                                        <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" SettingsPager-PageSize="5">
                                                                            <SettingsBehavior AllowSelectByRowClick="True" AllowFocusedRow="true"
                                                                                AllowSelectSingleRowOnly="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="CostCenterCode" ReadOnly="True" VisibleIndex="0">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="2">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents DropDown="lookup"
                                                                         KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" ValueChanged="function(){
                                                                             if(costcode!=gl6.GetValue()&&gl6.GetValue()!=null){ 
                                                                             gv3.batchEditApi.EndEdit();
                                                                             }}"/>
                                                                    </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn> 
                                                        <dx:GridViewDataTextColumn FieldName="Bizpartner" ShowInCustomizationForm="True" VisibleIndex="9" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glCostcode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                        DataSourceID="sdsBizPartner" KeyFieldName="BizPartnerCode" ClientInstanceName="glbizpartner" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
                                                                        <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" SettingsPager-PageSize="5">
                                                                            <SettingsBehavior AllowSelectByRowClick="True" AllowFocusedRow="true"
                                                                                AllowSelectSingleRowOnly="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="0">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="2">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" CloseUp="gridLookup_CloseUp" ValueChanged="function(s,e){
                                                                            gv3.batchEditApi.EndEdit(); }" />
                                                                    </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="DebitAmount" ShowInCustomizationForm="True" VisibleIndex="9" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}" MinValue="0"
                                                                SpinButtons-ShowIncrementButtons="false">
                                                                <ClientSideEvents ValueChanged="autocalculate2" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="CreditAmount" ShowInCustomizationForm="True" VisibleIndex="10" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}" MinValue="0"
                                                                SpinButtons-ShowIncrementButtons="false">
                                                                <ClientSideEvents ValueChanged="autocalculate2" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="TotalAmount" ShowInCustomizationForm="True" VisibleIndex="11" Width="0px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}" MinValue="0"
                                                                SpinButtons-ShowIncrementButtons="false">
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" ShowInCustomizationForm="True" Name="Field1" Caption="Field1" VisibleIndex="11" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" ShowInCustomizationForm="True" Name="Field2" Caption="Field2" VisibleIndex="12" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Caption="Field3"  Name="Field3" ShowInCustomizationForm="True" VisibleIndex="13" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Caption="Field4"  Name="Field4" ShowInCustomizationForm="True" VisibleIndex="14" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Caption="Field5"  Name="Field5" ShowInCustomizationForm="True" VisibleIndex="15" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Caption="Field6"  Name="Field6" ShowInCustomizationForm="True" VisibleIndex="16" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Caption="Field7"  Name="Field7" ShowInCustomizationForm="True" VisibleIndex="17" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8"  Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="18" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9"  Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="19" UnboundType="Bound" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                    <SettingsPager Mode="ShowAllRecords"/> 
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Visible" VerticalScrollableHeight="300"
                                                        ColumnMinWidth="120" ShowStatusBar="Hidden"/> 
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <SettingsEditing Mode="Batch" />
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
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
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
      <%--  <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Loading..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="gv1">
             <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>--%>


    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server"  Text=""   Image-Url="..\images\loadinggear.gif" Image-Height="30px" Image-Width="30px" Height="30px" Width="30px" Enabled="true" ShowImage="true" BackColor="Transparent" Border-BorderStyle="None" 
            ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
        <LoadingDivStyle Opacity="0"></LoadingDivStyle>
   </dx:ASPxLoadingPanel>

    </form>
    <!--#region Region Datasource-->
    <%-- put all datasource codeblock here --%>
    <asp:ObjectDataSource ID="PO" runat="server" DataObjectTypeName="Entity.PurchaseOrder" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.PurchaseOrder" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.CheckVoucher+CheckVoucherDetail" SelectMethod="getdetail" UpdateMethod="UpdateCheckVoucherDetail" TypeName="Entity.CheckVoucher+CheckVoucherDetail" DeleteMethod="DeleteCheckVoucherDetail" InsertMethod="AddCheckVoucherDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail2" runat="server" DataObjectTypeName="Entity.CheckVoucher+CheckVoucherTagging" SelectMethod="getdetail" UpdateMethod="UpdateCheckVoucherTagging" TypeName="Entity.CheckVoucher+CheckVoucherTagging" DeleteMethod="DeleteCheckVoucherTagging" InsertMethod="AddCheckVoucherTagging">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail3" runat="server" DataObjectTypeName="Entity.CheckVoucher+CheckVoucherAdjEntry" SelectMethod="getdetail" UpdateMethod="UpdateCheckVoucherAdjEntry" TypeName="Entity.CheckVoucher+CheckVoucherAdjEntry" DeleteMethod="DeleteCheckVoucherAdjEntry" InsertMethod="AddCheckVoucherAdjEntry">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT SupplierCode, Name FROM Masterfile.[BPSupplierInfo] WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Profitsql" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select ProfitCenterCode,Description,CostCenterCode from Accounting.ProfitCenter" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Costsql" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select Description,CostCenterCode from Accounting.CostCenter" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebank" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BankAccountCode,BankCode,Description FROM Masterfile.[BankAccount] where isnull(isinactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="TransDocs" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="select distinct ROW_NUMBER() OVER (Order by Docnumber) as Row,RecordId, DocNumber, DocDate, AccountCode, SubsiCode, ProfitCenter, CostCenter, BizPartnerCode as SupplierCode, ISNULL(Amount,0)-ISNULL(Applied,0) as Amount, ISNULL(Amount,0)-ISNULL(Applied,0) as Applied,Reference from Accounting.SubsiLedgerNonInv
    WHERE applied != amount" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SalesInvoice" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DocNumber,DocDate from sales.Invoice" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SalesInvoicedet" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DocNumber,'' as LineNumber,'SLSINV' as Transtype,DocNumber as TransDocNumber,DocDate as TransDate,TotalAmountDue as TransAPAmount, VATAmount as TransVatAmount,0 as EWT,'' ATCcode,Field1,Field2,Field3,Field4,Field5,Field6,Field7,Field8,Field9 from sales.Invoice" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  accounting.CheckVoucherDetail where DocNumber is null " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="SELECT * FROM Accounting.CheckVoucherTagging WHERE DocNumber IS NULL" 
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail3" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="SELECT * FROM Accounting.CheckVoucherAdjEntry WHERE DocNumber IS NULL" 
        OnInit="Connection_Init"></asp:SqlDataSource>
    
    <asp:SqlDataSource ID="sdsBizPartner" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BizPartner WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="COA" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select AccountCode,Description from Accounting.ChartOfAccount where ISNULL(AllowJV,0) = 1 AND ISNULL(IsInActive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Subsi" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select SubsiCode,AccountCode,Description from Accounting.GLSubsiCode where isnull(isinactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsRefTrans" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT RecordId, TransType, DocNumber, DocDate, AccountCode, SubsiCode, ProfitCenter, CostCenter, BizPartnerCode, ISNULL(Amount,0) - ISNULL(Applied,0) AS Amount, CounterDocNumber AS CounterReceiptNo, ISNULL(Reference,'') AS Reference FROM Accounting.SubsiLedgerNonInv WHERE TransType IN ('NONE') AND ISNULL(Applied,0) <> ISNULL(Amount,0)"  OnInit ="Connection_Init"></asp:SqlDataSource>	
	<asp:SqlDataSource ID="sdsTransDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="SELECT RIGHT('00000'+ CAST(ROW_NUMBER() OVER (ORDER BY DocNumber) AS VARCHAR(5)),5) AS LineNumber, TransType,
               DocNumber AS TransDocNumber, DocDate AS TransDate, AccountCode AS TransAccountCode, SubsiCode AS TransSubsiCode, 
               ProfitCenter AS TransProfitCenter, CostCenter AS TransCostCenter, BizPartnerCode AS TransBizPartnerCode, 
               Amount AS TransAmount, Amount AS TransAppliedAmount, DueDate AS TransDueDate, '2' AS Version, RecordId 
          FROM Accounting.SubsiLedgerNonInv 
         WHERE TransType IN ('NONE') AND ISNULL(Applied,0) <> ISNULL(Amount,0)" 
        OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.CheckVoucher+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource> 
    
    <!--#endregion-->
</body>
</html>


