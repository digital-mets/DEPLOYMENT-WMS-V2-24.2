<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmItemMasterfile.aspx.cs" Inherits="GWL.frmItemMasterfile" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Item Masterfile</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
    <%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
    <%--NEWADD--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 525px; /*Change this whenever needed*/
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
    <!--#endregion-->
    <!--#region Region Javascript-->
    <script>
        var isValid = true;
        var counterror = 0;

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var param = getParameterByName("parameters");

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
                //console.log('invalid');
                //counterror++;
                isValid = false
                e.isValid = false
            }
        }

        function OnValidationProd(s, e) { //Validation function for header controls (Set this for each header controls)
            if (txtHavProdSub.GetText() == "True" && (txtprodsubcat.GetText() == null || txtprodsubcat.GetText() == '')) {
                e.isValid = false
                isValid = false;
            }
            //else {
            //    e.isValid = true;
            //    console.log('true');
            //}
        }

        function Validation() {
            if (txtitemcode.GetIsValid() && txtitemcat.GetIsValid() && txtprodcategory.GetIsValid() && txtunitbulk.GetIsValid()
                && txtbaseunit.GetIsValid() && txtprodsubcat.GetIsValid() && txtitemcustomer.GetIsValid()) {
                return true;
            }
            else {
                return false;
            }
        }

        function checkPercentage() {
            var perc = 0.00;
            var totalperc = 0.00;
            var indicies = gvFabric.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indicies.length; i++) {
                if (gvFabric.batchEditApi.IsNewRow(indicies[i])) {
                    perc = parseFloat(gvFabric.batchEditApi.GetCellValue(indicies[i], "Percentage"));
                    gvFabric.batchEditApi.ValidateRow(indicies[i]);
                    gvFabric.batchEditApi.StartEdit(indicies[i], gvFabric.GetColumnByField("Percentage").index);
                    gvFabric.batchEditApi.EndEdit();
                    totalperc += perc;
                }
                else {
                    var key = gvFabric.GetRowKey(indicies[i]);
                    //if (gvFabric.batchEditApi.IsDeletedRow(key))
                        //console.log("deleted row " + indicies[i]);
                    //else {
                        perc = parseFloat(gvFabric.batchEditApi.GetCellValue(indicies[i], "Percentage"));
                        gvFabric.batchEditApi.ValidateRow(indicies[i]);
                        gvFabric.batchEditApi.StartEdit(indicies[i], gvFabric.GetColumnByField("Percentage").index);
                        gvFabric.batchEditApi.EndEdit();
                        totalperc += perc;
                    //}
                }
            }

        }

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            var btnmode = btn.GetText(); //gets text of button

            if (Validation() || btnmode == "Close") { //check if there's no error then proceed to callback
                //Sends request to server side
                //console.log(param, checkPercentage())
                if (!checkPercentage() && param == "2") {
                    alert('Total Percentage is not equal to 100%!');
                    return;
                }

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

            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }
        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);
                if (s.cp_duplicate) {//NEWADD
                    delete (s.cp_duplicate);
                    window.location.reload();
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
                    window.close();//close window if callback successful
                }
            }

            if (s.cp_delete) {
                delete (cp_delete);
                DeleteControl.Show();
            }
        }

        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var index1;

        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for

            index1 = e.visibleIndex;
            s.batchEditApi.SetCellValue(e.visibleIndex, "BaseUnit", txtbaseunit.GetText());

            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}

            //if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
            //    gl.GetInputElement().value = cellInfo.value; //Gets the column value
            //    isSetTextRequired = true;
            //}
            if (e.focusedColumn.fieldName === "ColorCode") {
                gl2.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "ClassCode") {
                gl3.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "SizeCode") {
                gl4.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "Description") {
                fabtype.GetInputElement().value = cellInfo.value;
            }

            if (e.focusedColumn.fieldName === "ColorCode" || e.focusedColumn.fieldName === "ClassCode" ||
                e.focusedColumn.fieldName === "SizeCode" || e.focusedColumn.fieldName === "Barcode") {
                if (s.batchEditApi.GetCellValue(e.visibleIndex, "OnHand") != 0 && s.batchEditApi.GetCellValue(e.visibleIndex, "OnHand") != null)
                    e.cancel = true;
            }
            //if (e.focusedColumn.fieldName === "BulkUnit") {
            //    glBulkUnit.GetInputElement().value = cellInfo.value;
            //}
            //if (e.focusedColumn.fieldName === "Unit") {
            //    glUnit.GetInputElement().value = cellInfo.value;
            //}
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            //if (currentColumn.fieldName === "ItemCode") {
            //    cellInfo.value = gl.GetValue();
            //    cellInfo.text = gl.GetText();
            //}
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
            if (currentColumn.fieldName === "Description") {
                cellInfo.value = fabtype.GetValue();
                cellInfo.text = fabtype.GetText();
            }
            //if (currentColumn.fieldName === "BulkUnit") {
            //    cellInfo.value = glBulkUnit.GetValue();
            //    cellInfo.text = glBulkUnit.GetText();
            //}
            //if (currentColumn.fieldName === "Unit") {
            //    cellInfo.value = glUnit.GetValue();
            //    cellInfo.text = glUnit.GetText();
            //}
        }

        function OnStartEditing2(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            //s.batchEditApi.SetCellValue(e.visibleIndex, "BaseUnit", txtbaseunit.GetText());
            if (e.focusedColumn.fieldName === "ItemCode") {
                glItem.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "ColorCode") {
                glColor.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "ClassCode") {
                glClass.GetInputElement().value = cellInfo.value;
            }
            if (e.focusedColumn.fieldName === "SizeCode") {
                glSize.GetInputElement().value = cellInfo.value;
            }
            //if (e.focusedColumn.fieldName === "SubstitutedColor") {
            //    glColor2.GetInputElement().value = cellInfo.value;
            //}
            //if (e.focusedColumn.fieldName === "SubstitutedClass") {
            //    glClass2.GetInputElement().value = cellInfo.value;
            //}
            //if (e.focusedColumn.fieldName === "SubstitutedSize") {
            //    glSize2.GetInputElement().value = cellInfo.value;
            //}
            if (e.focusedColumn.fieldName === "Customer") {
                gvCustomer.GetInputElement().value = cellInfo.value;
            }
        }

        function OnEndEditing2(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            //if (currentColumn.fieldName === "ItemCode") {
            //    cellInfo.value = gl.GetValue();
            //    cellInfo.text = gl.GetText();
            //}
            //if (currentColumn.fieldName === "SubstitutedItem") {
            //    cellInfo.value = glItem.GetValue();
            //    cellInfo.text = glItem.GetText();
            //}
            if (currentColumn.fieldName === "ColorCode") {
                cellInfo.value = glColor.GetValue();
                cellInfo.text = glColor.GetText();
            }
            if (currentColumn.fieldName === "ClassCode") {
                cellInfo.value = glClass.GetValue();
                cellInfo.text = glClass.GetText();
            }
            if (currentColumn.fieldName === "SizeCode") {
                cellInfo.value = glSize.GetValue();
                cellInfo.text = glSize.GetText();
            }
            //if (currentColumn.fieldName === "SubstitutedColor") {
            //    cellInfo.value = glColor2.GetValue();
            //    cellInfo.text = glColor2.GetText();
            //}
            //if (currentColumn.fieldName === "SubstitutedClass") {
            //    cellInfo.value = glClass2.GetValue();
            //    cellInfo.text = glClass2.GetText();
            //}
            //if (currentColumn.fieldName === "SubstitutedSize") {
            //    cellInfo.value = glSize2.GetValue();
            //    cellInfo.text = glSize2.GetText();
            //}
            if (currentColumn.fieldName === "Customer") {
                cellInfo.value = gvCustomer.GetValue();
                cellInfo.text = gvCustomer.GetText();
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
            }
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
            gv2.batchEditApi.EndEdit();
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                var column = s.GetColumn(i);
                if (column != s.GetColumn(3) && column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(5) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                    else {
                        isValid = true;
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
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                    + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode);
            }
        }

        function OnInitTrans(s, e) {
            isValid = true;
            OnBlastCheckBoxChanged(chkBlast, null);
            OnScannableCheckBoxChanged(chkScannable, null);
            OnKittingCheckBoxChanged(chkKitting, null);

            frmlayout1.GetItemByName("itemAffixLayout").SetVisible(ChkDelimiter.GetChecked() && chkScannable.GetChecked());
            frmlayout1.GetItemByName("quantityAffixLayout").SetVisible(ChkDelimiter.GetChecked() && chkScannable.GetChecked());
            frmlayout1.GetItemByName("weightAffixLayout").SetVisible(ChkDelimiter.GetChecked() && chkScannable.GetChecked());
            frmlayout1.GetItemByName("batchAffixLayout").SetVisible(ChkDelimiter.GetChecked() && chkScannable.GetChecked());
            frmlayout1.GetItemByName("lotAffixLayout").SetVisible(ChkDelimiter.GetChecked() && chkScannable.GetChecked());
            frmlayout1.GetItemByName("expDateAffixLayout").SetVisible(ChkDelimiter.GetChecked() && chkScannable.GetChecked());
            frmlayout1.GetItemByName("mfgDateAffixLayout").SetVisible(ChkDelimiter.GetChecked() && chkScannable.GetChecked());
        }

        function UpdateDescUnit(values) {
            txtSecondary.SetValue(values[0]);
            txtSecondaryDesc.SetValue(values[1]);
            txtSecondaryUOM.SetValue(values[2]);

            loader.Hide();
        }

        function UpdateDescUnit01(values) {
            txttertiary.SetValue(values[0]);
            txttertiaryDesc.SetValue(values[1]);
            txttertiaryUOM.SetValue(values[2]);

            loader.Hide();
        }

        function UpdateDesc(values) {
            gv1.batchEditApi.SetCellValue(index1, "ItemCode", values[0]);
            gv1.batchEditApi.SetCellValue(index1, "ItemDesc", values[1]);
            gv1.batchEditApi.SetCellValue(index1, "Units", values[2]);

            loader.Hide();
        }

        function OnBlastCheckBoxChanged(s, e) {
            if (s.GetChecked()) {
                txtSecondary.SetEnabled(true);
                txttertiary.SetEnabled(true);
            } else {
                txtSecondary.SetEnabled(false);
                txttertiary.SetEnabled(false);
                txtSecondary.SetValue(null);
                txtSecondaryDesc.SetValue(null);
                txtSecondaryUOM.SetValue(null);
                txttertiary.SetValue(null);
                txttertiaryDesc.SetValue(null);
                txttertiaryUOM.SetValue(null);
            }
        }

        function OnScannableCheckBoxChanged(s, e) {
            if (s.GetChecked()) {
                ChkDelimiter.SetEnabled(true);
                txtDelVal.SetEnabled(true);
                ItemCnt.SetEnabled(true);
                WeightCnt.SetEnabled(true);
                MfgkDataCnt.SetEnabled(true);
                MfgkDataCnt.SetEnabled(true);
                ExpDateCnt.SetEnabled(true);
                BatchCnt.SetEnabled(true);
                LotIDCnt.SetEnabled(true);
            } else {
                ChkDelimiter.SetEnabled(false);
                txtDelVal.SetEnabled(false);
                ItemCnt.SetEnabled(false);
                WeightCnt.SetEnabled(false);
                MfgkDataCnt.SetEnabled(false);
                MfgkDataCnt.SetEnabled(false);
                ExpDateCnt.SetEnabled(false);
                BatchCnt.SetEnabled(false);
                LotIDCnt.SetEnabled(false);
                ChkDelimiter.SetValue(null);
                txtDelVal.SetValue(null);
                ItemCnt.SetValue(null);
                WeightCnt.SetValue(null);
                MfgkDataCnt.SetValue(null);
                MfgkDataCnt.SetValue(null);
                ExpDateCnt.SetValue(null);
                BatchCnt.SetValue(null);
                LotIDCnt.SetValue(null);
                textQuantityPosition.SetValue(null);
            }

            gridLookupDateFormat.SetEnabled(s.GetChecked());
            textQuantityPosition.SetEnabled(s.GetChecked());
            textLotIDLength.SetEnabled(s.GetChecked() && !ChkDelimiter.GetChecked());
            textBatchLength.SetEnabled(s.GetChecked() && !ChkDelimiter.GetChecked());
            textWeightLength.SetEnabled(s.GetChecked() && !ChkDelimiter.GetChecked());
            textQuantityLength.SetEnabled(s.GetChecked() && !ChkDelimiter.GetChecked())
            textItemAffix.SetEnabled(s.GetChecked() && ChkDelimiter.GetChecked());
            textQuantityAffix.SetEnabled(s.GetChecked() && ChkDelimiter.GetChecked());
            textWeightAffix.SetEnabled(s.GetChecked() && ChkDelimiter.GetChecked());
            textBatchAffix.SetEnabled(s.GetChecked() && ChkDelimiter.GetChecked());
            textLotAffix.SetEnabled(s.GetChecked() && ChkDelimiter.GetChecked());
            textMfgDateAffix.SetEnabled(s.GetChecked() && ChkDelimiter.GetChecked());
            textExpDateAffix.SetEnabled(s.GetChecked() && ChkDelimiter.GetChecked());
        }

        function OnKittingCheckBoxChanged(s, e) {
            if (s.GetChecked()) {
                gv1.SetEnabled(true);
            } else {
                gv1.SetEnabled(false);
            }
        }

        function isDelimitedCheckChanged() {
            textLotIDLength.SetEnabled(!ChkDelimiter.GetChecked());
            textBatchLength.SetEnabled(!ChkDelimiter.GetChecked());
            textWeightLength.SetEnabled(!ChkDelimiter.GetChecked());
            textQuantityLength.SetEnabled(!ChkDelimiter.GetChecked());
            textLotIDLength.SetValue(!ChkDelimiter.GetChecked() ? 1 : null);
            textBatchLength.SetValue(!ChkDelimiter.GetChecked() ? 1 : null);
            textWeightLength.SetValue(!ChkDelimiter.GetChecked() ? 1 : null);
            textQuantityLength.SetValue(!ChkDelimiter.GetChecked() ? 1 : null);
            textItemAffix.SetEnabled(ChkDelimiter.GetChecked());
            textItemAffix.SetValue('');
            textQuantityAffix.SetEnabled(ChkDelimiter.GetChecked());
            textQuantityAffix.SetValue('');
            textWeightAffix.SetEnabled(ChkDelimiter.GetChecked());
            textWeightAffix.SetValue('');
            textBatchAffix.SetEnabled(ChkDelimiter.GetChecked());
            textBatchAffix.SetValue('');
            textLotAffix.SetEnabled(ChkDelimiter.GetChecked());
            textLotAffix.SetValue('');
            textMfgDateAffix.SetEnabled(ChkDelimiter.GetChecked());
            textMfgDateAffix.SetValue('');
            textExpDateAffix.SetEnabled(ChkDelimiter.GetChecked());
            textExpDateAffix.SetValue('');
            frmlayout1.GetItemByName("itemAffixLayout").SetVisible(ChkDelimiter.GetChecked());
            frmlayout1.GetItemByName("quantityAffixLayout").SetVisible(ChkDelimiter.GetChecked());
            frmlayout1.GetItemByName("weightAffixLayout").SetVisible(ChkDelimiter.GetChecked());
            frmlayout1.GetItemByName("batchAffixLayout").SetVisible(ChkDelimiter.GetChecked());
            frmlayout1.GetItemByName("lotAffixLayout").SetVisible(ChkDelimiter.GetChecked());
            frmlayout1.GetItemByName("expDateAffixLayout").SetVisible(ChkDelimiter.GetChecked());
            frmlayout1.GetItemByName("mfgDateAffixLayout").SetVisible(ChkDelimiter.GetChecked());
        }

        function onStandardWgtCheckBoxChanged() {
            //chkCatchWeight.SetValue(!chkStandWeight.GetChecked());
            //txtTolerance.GetInputElement().readOnly = chkStandWeight.GetChecked();
            //txtCatchWeightVal.GetInputElement().readOnly = chkStandWeight.GetChecked();
            //txtMinWeight.GetInputElement().readOnly = chkStandWeight.GetChecked();
            //txtMaxWeight.GetInputElement().readOnly = chkStandWeight.GetChecked();
            //txtstandardqty.GetInputElement().readOnly = !chkStandWeight.GetChecked();

            chkCatchWeight.SetValue(false);
            txtTolerance.SetEnabled(false);
            txtCatchWeightVal.SetEnabled(false);
            txtMinWeight.SetEnabled(false);
            txtMaxWeight.SetEnabled(false);
            txtstandardqty.SetEnabled(true);

            resetWeight();
        }

        function onCatchWgtCheckBoxChanged() {
            //chkStandWeight.SetValue(!chkCatchWeight.GetChecked());
            //txtstandardqty.GetInputElement().readOnly = chkCatchWeight.GetChecked();
            //txtTolerance.GetInputElement().readOnly = !chkCatchWeight.GetChecked();
            //txtCatchWeightVal.GetInputElement().readOnly = !chkCatchWeight.GetChecked();
            //txtMinWeight.GetInputElement().readOnly = !chkCatchWeight.GetChecked();
            //txtMaxWeight.GetInputElement().readOnly = !chkCatchWeight.GetChecked();

            chkStandWeight.SetValue(false);
            txtstandardqty.SetEnabled(false);
            txtTolerance.SetEnabled(true);
            txtCatchWeightVal.SetEnabled(true);
            txtMinWeight.SetEnabled(true);
            txtMaxWeight.SetEnabled(true);

            resetWeight();
        }

        function resetWeight() {
            txtstandardqty.SetValue('0');
            txtTolerance.SetValue('0');
            txtCatchWeightVal.SetValue('0');
            txtMinWeight.SetValue('0');
            txtMaxWeight.SetValue('0');
        }

        function setCatchWeightOnChange(s, e) {
            const tolerance = isNaN(parseFloat(txtTolerance.GetValue())) ? 0 : parseFloat(txtTolerance.GetValue());
            const weight = isNaN(parseFloat(txtCatchWeightVal.GetValue())) ? 0 : parseFloat(txtCatchWeightVal.GetValue());
            const min = isNaN(parseFloat(txtMinWeight.GetValue())) ? 0 : parseFloat(txtMinWeight.GetValue());
            const max = isNaN(parseFloat(txtMaxWeight.GetValue())) ? 0 : parseFloat(txtMaxWeight.GetValue());

            if ((weight > 0 && tolerance > 0) || (weight > 0 && (min <= 0 || max <= 0))) {
                const catchWeight = calculateWeightFromTolerance();
                setCatchWeightFields(catchWeight);
                return;
            }

            if (min > 0 && max > 0) {
                const catchWeight = calculateWeightFromMinMax();
                setCatchWeightFields(catchWeight);
                return;
            }
        }

        function onDecimalInputKeyUp(s, e) {
            let inputVal = s.GetValue();
            if (inputVal === null) return;

            let decimalFound = false;
            inputVal = inputVal.replace(/\./g, (match) => {
                if (decimalFound) {
                    return '';
                } else {
                    decimalFound = true;
                    return match;
                }
            });
            inputVal = inputVal.replace(/([^.\d-]|(?!^)-)/g, '');
            s.SetValue(inputVal);
        }

        function setCatchWeightOnKeyUp(s, e) {
            onDecimalInputKeyUp(s, e);
            const value = s.GetValue() !== null ? s.GetValue().trim() : null;
            if (value === null || value === '') {
                s.SetValue(value);
                return;
            }

            const catchWeight = s.globalName === 'txtTolerance' || s.globalName === 'txtCatchWeightVal' ? calculateWeightFromTolerance() : calculateWeightFromMinMax();
            setCatchWeightFields(catchWeight);
            s.SetValue(value);
        }

        function setCatchWeightFields(catchWeight) {
            txtMinWeight.SetValue(catchWeight['min'].toString());
            txtMaxWeight.SetValue(catchWeight['max'].toString());
            txtTolerance.SetValue(catchWeight['tolerance'].toString());
            txtCatchWeightVal.SetValue(catchWeight['weight'].toString());
        }

        function calculateWeightFromTolerance() {
            const tolerance = isNaN(parseFloat(txtTolerance.GetValue())) ? 0 : parseFloat(txtTolerance.GetValue());
            const weight = isNaN(parseFloat(txtCatchWeightVal.GetValue())) ? 0 : parseFloat(txtCatchWeightVal.GetValue());
            const computedTolerance = weight * (tolerance / 100);

            return {
                'weight': weight,
                'tolerance': tolerance,
                'min': (weight - computedTolerance) < 0 ? 0 : weight - computedTolerance,
                'max': (weight + computedTolerance)
            };
        }

        function calculateWeightFromMinMax() {
            const min = isNaN(parseFloat(txtMinWeight.GetValue())) ? 0 : parseFloat(txtMinWeight.GetValue());
            const max = isNaN(parseFloat(txtMaxWeight.GetValue())) ? 0 : parseFloat(txtMaxWeight.GetValue());

            if (min > 0 && max < min) {
                return {
                    'weight': 0,
                    'tolerance': 0,
                    'min': min,
                    'max': max
                };
            }

            const tolerance = (100 * (max - min)) / (min + max);
            const weight = max / (1 + (tolerance / 100));

            return {
                'weight': isNaN(weight) ? 0 : weight,
                'tolerance': isNaN(tolerance) ? 0 : tolerance,
                'min': min,
                'max': max
            };
        }

        window.addEventListener("load", (event) => {
            
        });
    </script>
    <!--#endregion-->
</head>
<body>
    <dx:ASPxGlobalEvents ID="ge" runat="server">
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <%-- <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None"
            EnableViewState="False" HeaderText="Item info" Height="207px" PopupHorizontalOffset="1085" PopupVerticalOffset="0"
            ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True" Collapsed="true">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>--%>
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel ID="FormLabel" runat="server" Text="Item Masterfile" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" Width="100%" runat="server" Style="margin-left: -3px" ClientInstanceName="frmlayout1">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="Generic Tab" ColSpan="2">
                                        <Items>
                                            <dx:LayoutGroup Caption="General" ColCount="2" Width="50%">
                                                <Items>
                                                    <dx:LayoutItem Caption="Item Code:" Name="txtitemCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtItemCode" runat="server" OnTextChanged="txtDocnumber_TextChanged" ReadOnly="False" OnLoad="TextboxLoad"
                                                                    MaxLength="50" ClientInstanceName="txtitemcode">
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <ErrorImage ToolTip="Supplier is required">
                                                                        </ErrorImage>
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Item Description" Name="txtitedesc">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtitemdesc" runat="server" OnLoad="TextboxLoad">
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <ErrorImage ToolTip="Item Description is required">
                                                                        </ErrorImage>
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Short Description" Name="txtdesc">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtshortdesc" runat="server" OnLoad="TextboxLoad">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Item Category:" Name="txtitemcategory">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtitemcat" ClientInstanceName="txtitemcat" runat="server" AutoGenerateColumns="False" DataSourceID="ItemCategory" KeyFieldName="ItemCategoryCode" OnLoad="LookupLoad" OnTextChanged="glWarehouseCOde_TextChanged" TextFormatString="{0}">
                                                                    <ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('itemcat'); e.processOnServer = false; txtprodsubcat.SetText(null);}" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCategoryCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <ErrorImage ToolTip="ItemCategory is required">
                                                                        </ErrorImage>
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Item Customer:" Name="txtitemcustomer">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtitemcustomer" ClientInstanceName="txtitemcustomer" runat="server" AutoGenerateColumns="False" DataSourceID="customer" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" OnTextChanged="glWarehouseCOde_TextChanged" TextFormatString="{0}">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <ErrorImage ToolTip="ItemCategory is required">
                                                                        </ErrorImage>
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Product Category:" Name="txtProdCat">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtprodcategory" runat="server" AutoGenerateColumns="False" DataSourceID="ProdCat" KeyFieldName="ProductCategoryCode"
                                                                    OnLoad="LookupLoad" OnTextChanged="glWarehouseCOde_TextChanged" TextFormatString="{0}" ClientInstanceName="txtprodcategory">
                                                                    <ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('prodcat'); e.processOnServer = false; }" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ProductCategoryCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <ErrorImage ToolTip="Supplier is required">
                                                                        </ErrorImage>
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                                <dx:ASPxTextBox runat="server" ClientInstanceName="txtHavProdSub" ID="txtHavProdSub" ClientVisible="false">
                                                                    <%--<ClientSideEvents TextChanged="function(){ console.log('here')}" />--%>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Product Sub Category:" Name="txtProdsubcat">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtprodsubcat" runat="server" AutoGenerateColumns="False" DataSourceID="ProdSubCat" ClientInstanceName="txtprodsubcat"
                                                                    KeyFieldName="ProductSubCatCode" OnLoad="LookupLoad" OnTextChanged="glWarehouseCOde_TextChanged" TextFormatString="{0}">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ProductSubCatCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidationProd" />
                                                                    <ValidationSettings ErrorText="Product sub category is required">
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Unit Bulk" Name="txtunitbulk">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtunitbulk" ClientInstanceName="txtunitbulk" runat="server" AutoGenerateColumns="False" DataSourceID="unit" KeyFieldName="UnitCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <ErrorImage ToolTip="Unit for Bulk is required">
                                                                        </ErrorImage>
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Base Unit" Name="txtbaseunit">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtbaseunit" runat="server" AutoGenerateColumns="False" DataSourceID="unit"
                                                                    KeyFieldName="UnitCode" OnLoad="LookupLoad" TextFormatString="{0}" ClientInstanceName="txtbaseunit">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <ErrorImage ToolTip="Base Qty Unit is required">
                                                                        </ErrorImage>
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Strategies" ColCount="2" Width="35%">
                                                <Items>
                                                    <dx:LayoutItem Caption="Allocation Strategies">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtAllocationStrategies" DataSourceID="AllocationStrategies" runat="server" OnLoad="LookupLoad" KeyFieldName="AllocationStrategies"
                                                                    TextFormatString="{0}" MultiTextSeparator=", " SelectionMode="Multiple" ClientInstanceName="AllocationStrategies">
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" />
                                                                        <dx:GridViewDataColumn FieldName="AllocationStrategiesCode" />
                                                                        <dx:GridViewDataColumn FieldName="AllocationStrategies" />
                                                                    </Columns>
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" />
                                                                        <Settings ShowFilterRow="True"></Settings>
                                                                    </GridViewProperties>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Picking Strategy:" Name="txtpickingStrategy">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox ID="txtstrategy" runat="server" ValueType="System.String" OnLoad="Comboboxload">
                                                                    <Items>
                                                                        <dx:ListEditItem Text="FIFO" Value="FIFO" />
                                                                        <dx:ListEditItem Text="FEFO" Value="FEFO" />
                                                                        <dx:ListEditItem Text="LIFO" Value="LIFO" />
                                                                    </Items>
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Room">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtLocationCode" runat="server" DataSourceID="LocationCode" OnLoad="LookupLoad" KeyFieldName="RoomCode" TextFormatString="{0}">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                                                        <Settings ShowFilterRow="True"></Settings>
                                                                    </GridViewProperties>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Putaway Strategies">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtPutawayStrategies" DataSourceID="PutawayStrategies" runat="server" OnLoad="LookupLoad" KeyFieldName="PutawayStrategies"
                                                                    TextFormatString="{0}" MultiTextSeparator=", " SelectionMode="Multiple" ClientInstanceName="PutawayStrategies">
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" />
                                                                        <dx:GridViewDataColumn FieldName="PutawayStrategiesCode" />
                                                                        <dx:GridViewDataColumn FieldName="PutawayStrategies" />
                                                                    </Columns>
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" />
                                                                        <Settings ShowFilterRow="True"></Settings>
                                                                    </GridViewProperties>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>



                                                    <dx:LayoutItem Caption="ABC">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtABC" runat="server" DataSourceID="ABCSpeed" OnLoad="LookupLoad" KeyFieldName="ABC">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True"></Settings>
                                                                    </GridViewProperties>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                </Items>


                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Name="FabricInfo" Paddings-Padding="0px" Caption="Fabric Information Tab" ColCount="2" ClientVisible="false">
                                        <Paddings Padding="0px"></Paddings>
                                        <Items>
                                            <dx:LayoutGroup Paddings-Padding="0px" ShowCaption="False" GroupBoxStyle-Border-BorderStyle="None">
                                                <Border BorderStyle="None" />
                                                <Paddings Padding="0px"></Paddings>
                                                <GroupBoxStyle>
                                                    <border borderstyle="None"></border>
                                                </GroupBoxStyle>
                                                <Items>
                                                    <dx:LayoutItem Paddings-Padding="0px" Caption="Retail Fabric Code">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtRetailFabCode" runat="server">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>

                                                        <Paddings Padding="0px"></Paddings>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Fabric Group">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox runat="server" ID="txtFabGroup" DataSourceID="FabricGroup"
                                                                    TextField="Description" ValueField="Code" ValueType="System.String" IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                                    <ClientSideEvents ValueChanged="function(){cp.PerformCallback('fabgroup');}" />
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Fabric Design Category">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox runat="server" ID="txtFabDesCat" DataSourceID="FabDesign"
                                                                    TextField="Description" ValueField="FabricDesignCode" ValueType="System.String" IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Dyeing">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox runat="server" ID="txtDye" DataSourceID="Dye"
                                                                    TextField="Description" ValueField="DyeingCode" ValueType="System.String" IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Weave Type" Name="WeaveType">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox runat="server" ID="txtWeave" DataSourceID="Weave"
                                                                    TextField="Description" ValueField="Code" ValueType="System.String" IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Finishing">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox runat="server" ID="txtFinishing" DataSourceID="Finishing"
                                                                    TextField="Description" ValueField="FinishingCode" ValueType="System.String" IncrementalFilteringMode="StartsWith" EnableIncrementalFiltering="True">
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView Caption="COMPOSITION" ID="gvFab" runat="server" AutoGenerateColumns="False" Width="295px" KeyFieldName="FabricCode;Type"
                                                                    OnCommandButtonInitialize="gvitem_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gvFabric"
                                                                    OnBatchUpdate="gv1_BatchUpdate">
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsBehavior AllowSort="false" />
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="30px">
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="Percentage" VisibleIndex="1" Width="80px" UnboundType="Decimal" PropertiesSpinEdit-AllowMouseWheel="false">
                                                                            <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                MinValue="0">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" Caption="Type" VisibleIndex="2" Name="Description" ReadOnly="true">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup runat="server" DataSourceID="CompType" TextFormatString="{0}" AutoPostBack="false" AutoGenerateColumns="true"
                                                                                    ClientInstanceName="fabtype" KeyFieldName="Description">
                                                                                    <ClientSideEvents DropDown="lookup" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                                        ValueChanged="function(){gvFabric.batchEditApi.EndEdit();}" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Visible" VerticalScrollableHeight="100" />
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                                    <SettingsEditing Mode="Batch" />
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Paddings-Padding="0px" ShowCaption="False" Height="110px" GroupBoxStyle-Border-BorderStyle="None">
                                                <Paddings Padding="0px"></Paddings>

                                                <GroupBoxStyle>
                                                    <border borderstyle="None"></border>
                                                </GroupBoxStyle>
                                                <Items>
                                                    <dx:LayoutItem Paddings-Padding="0px" ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td></td>
                                                                        <td style="padding-left: 8px">
                                                                            <dx:ASPxLabel runat="server" Text="Cuttable">
                                                                            </dx:ASPxLabel>
                                                                        </td>
                                                                        <td></td>
                                                                        <td style="padding-left: 15px">
                                                                            <dx:ASPxLabel runat="server" Text="Gross">
                                                                            </dx:ASPxLabel>
                                                                        </td>
                                                                        <td></td>
                                                                        <td>
                                                                            <dx:ASPxLabel runat="server" Text="(For Knits Only)">
                                                                            </dx:ASPxLabel>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 77px">
                                                                            <dx:ASPxLabel runat="server" Text="Width: "></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox runat="server" ID="txtCuttableWidth" Width="60px"></dx:ASPxTextBox>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel runat="server" Font-Size="Smaller" Text="inches"></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtGrossWidth" runat="server" Width="60px"></dx:ASPxTextBox>
                                                                        </td>
                                                                        <td style="width: 30px">
                                                                            <dx:ASPxLabel runat="server" Font-Size="Smaller" Text="inches"></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxComboBox runat="server" ID="cbforknits" Width="80px">
                                                                                <Items>
                                                                                    <dx:ListEditItem Text="OPEN" Value="OPEN" />
                                                                                    <dx:ListEditItem Text="TUBE" Value="TUBE" />
                                                                                </Items>
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 5px"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 77px">
                                                                            <dx:ASPxLabel runat="server" Text="Weight BW: "></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtCuttableWeightBW" runat="server" Width="60px"></dx:ASPxTextBox>
                                                                        </td>
                                                                        <td></td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtGrossWeightBW" runat="server" Width="60px"></dx:ASPxTextBox>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel runat="server" Text="Yield: "></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtYield" runat="server" Width="45px"></dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="height: 5px"></td>
                                                                    </tr>
                                                                </table>
                                                                <table>
                                                                    <tr>
                                                                        <td style="width: 77px">
                                                                            <dx:ASPxLabel runat="server" Text="Fabric Stretch: "></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxTextBox ID="txtFabricStretch" runat="server" Width="60px"></dx:ASPxTextBox>
                                                                        </td>
                                                                        <td style="width: 27.83px; padding-left: 2px">
                                                                            <dx:ASPxLabel runat="server" Text="%"></dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel runat="server" Text="Use Pull-test w/ Rinse Wash"></dx:ASPxLabel>
                                                                        </td>
                                                                        <td></td>
                                                                    </tr>
                                                                </table>
                                                                &nbsp;
                                                                &nbsp;
                                                                &nbsp;
                                                                &nbsp;
                                                        <table>
                                                            <tr>
                                                                <td></td>
                                                                <td style="text-align: center">
                                                                    <dx:ASPxLabel runat="server" Text="Warp">
                                                                    </dx:ASPxLabel>
                                                                </td>
                                                                <td></td>
                                                                <td style="text-align: center">
                                                                    <dx:ASPxLabel runat="server" Text="Weft">
                                                                    </dx:ASPxLabel>
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 77px">
                                                                    <dx:ASPxLabel runat="server" Text="Construction: "></dx:ASPxLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtWarpConstruction" runat="server" Width="100px"></dx:ASPxTextBox>
                                                                </td>
                                                                <td style="width: 40px; text-align: center">
                                                                    <dx:ASPxLabel runat="server" Text="x"></dx:ASPxLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtWeftConstruction" runat="server" Width="100px"></dx:ASPxTextBox>
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="height: 5px"></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 77px">
                                                                    <dx:ASPxLabel runat="server" Text="Density: "></dx:ASPxLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtWarpDensity" runat="server" Width="100px"></dx:ASPxTextBox>
                                                                </td>
                                                                <td style="width: 40px; text-align: center">
                                                                    <dx:ASPxLabel runat="server" Text="x"></dx:ASPxLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtWeftDensity" runat="server" Width="100px"></dx:ASPxTextBox>
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 77px">
                                                                    <dx:ASPxLabel runat="server" Text="Shrinkage (Rinse Watch): "></dx:ASPxLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtWarpShrinkage" runat="server" Width="100px"></dx:ASPxTextBox>
                                                                </td>
                                                                <td style="width: 40px; text-align: left; padding-left: 2px">
                                                                    <dx:ASPxLabel runat="server" Text="%&nbsp;&nbsp;x"></dx:ASPxLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtWeftShrinkage" runat="server" Width="100px"></dx:ASPxTextBox>
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td colspan="3">
                                                                    <dx:ASPxLabel runat="server" Text="Use 24&quot; x 24&quot; Method, 50 cm X 50 cm Marking"></dx:ASPxLabel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <Paddings Padding="0px"></Paddings>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Stock Master Info Tab" Name="WMSInfo" ClientVisible="false">
                                        <Items>
                                            <dx:TabbedLayoutGroup>
                                                <SettingsTabPages EnableClientSideAPI="True">
                                                </SettingsTabPages>
                                                <Items>
                                                    <dx:LayoutGroup Caption="Stock Info" ColCount="2">
                                                        <Items>
                                                            <dx:LayoutItem Caption="Brand">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E1" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Product Group">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E2" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Delivery Date">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Collection Abbreviation">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E3" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="PIS Number">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E12" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Fit Code">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E13" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Color">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E7" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Product Design Category">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E14" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Color Name">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E9" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Retail Fabric Code">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E4" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Wash Code">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E15" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Tint Code">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E16" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Product Class">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E19" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Imported Item">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="frmlayout1_E17" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Product Sub-Class">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E20" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Product Alignment">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E21" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Season">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E22" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Reco Allocation">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="frmlayout1_E23" runat="server">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="SRP" ColSpan="2">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxSpinEdit ID="frmlayout1_E24" runat="server" Number="0">
                                                                        </dx:ASPxSpinEdit>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem ColSpan="2" ShowCaption="False">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridView ID="ASPxGridView1" runat="server" AutoGenerateColumns="False" Caption="Price History" ClientInstanceName="gvPriceHistory" KeyFieldName="FabricCode;Type" OnBatchUpdate="gv1_BatchUpdate" OnCellEditorInitialize="gv1_CellEditorInitialize" OnCommandButtonInitialize="gvitem_CommandButtonInitialize" Width="295px">
                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" BatchEditStartEditing="OnStartEditing" />
                                                                            <SettingsPager Mode="ShowAllRecords">
                                                                            </SettingsPager>
                                                                            <SettingsEditing Mode="Batch">
                                                                            </SettingsEditing>
                                                                            <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="100" VerticalScrollBarMode="Visible" />
                                                                            <SettingsBehavior AllowSort="False" />
                                                                            <Columns>
                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="30px">
                                                                                </dx:GridViewCommandColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Status" FieldName="Status" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Price" FieldName="Price" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataDateColumn FieldName="EffectivityDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                                </dx:GridViewDataDateColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridView>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutGroup>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutGroup>
                                                    </dx:LayoutGroup>
                                                </Items>
                                            </dx:TabbedLayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Running Inventory Information" Name="RII">
                                        <Items>
                                            <dx:LayoutGroup Caption="Lines">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="agvRunningInv" runat="server" AutoGenerateColumns="False" ClientInstanceName="gv4" OnCellEditorInitialize="gv1_CellEditorInitialize" OnCommandButtonInitialize="gv_CommandButtonInitialize" Width="747px">
                                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsBehavior AllowSort="false" />
                                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px" ShowDeleteButton="false">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="RunningINVInfo">
                                                                                    <Image IconID="support_info_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumber" Name="LineNumber" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="2" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ItemCode" FieldName="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="3" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ColorCode" FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="4" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="SizeCode" FieldName="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="5" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ClassCode" FieldName="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="6" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Qty" FieldName="Qty" Name="Qty" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="BulkQty" FieldName="BulkQty" Name="BulkQty" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="8" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="BaseUnit" FieldName="BaseUnit" Name="BaseUnit" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="9" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="WarehouseCode" FieldName="WarehouseCode" Name="WarehouseCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="10" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="StatusCode" FieldName="StatusCode" Name="StatusCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="11" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LastMovementDate" FieldName="LastMovementDate" Name="LastMovementDate" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="12" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="FirstIn" FieldName="FirstIn" Name="FirstIn" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LastIn" FieldName="LastIn" Name="LastIn" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="13" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="FirstOut" FieldName="FirstOut" Name="FirstOut" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="14" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LastOut" FieldName="LastOut" Name="LastOut" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="15" ReadOnly="true">
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
                                    <dx:LayoutGroup Caption="Item Price History" Name="IPH">
                                        <Items>
                                            <dx:LayoutGroup Caption="Lines" Width="650px">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="agvItemCustomer" runat="server" AutoGenerateColumns="False" ClientInstanceName="gv2" OnBatchUpdate="gv1_BatchUpdate" OnCellEditorInitialize="gv1_CellEditorInitialize" OnCommandButtonInitialize="gvitem_CommandButtonInitialize" Width="650px"
                                                                    KeyFieldName="ItemCode;ColorCode;ClassCode;SizeCode;Customer" OnInitNewRow="gv1_InitNewRow">
                                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating" CustomButtonClick="OnCustomClick"
                                                                        BatchEditStartEditing="OnStartEditing2" BatchEditEndEditing="OnEndEditing2" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsBehavior AllowSort="false" />
                                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" />
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px" ShowDeleteButton="true">
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ItemCode" FieldName="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" Width="0px" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="2" Width="150px" Name="ColorCode">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="ColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    DataSourceID="Color" KeyFieldName="ColorCode" ClientInstanceName="glColor" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="3" Width="150px" Name="SizeCode">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="SizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    DataSourceID="size" KeyFieldName="SizeCode" ClientInstanceName="glSize" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="4" Width="150px" Name="ClassCode">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="ClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    DataSourceID="class" KeyFieldName="ClassCode" ClientInstanceName="glClass" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Customer" FieldName="Customer" Width="150px" Name="Customer" ShowInCustomizationForm="True" VisibleIndex="9">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="gvCustomer" runat="server" Width="150px" AutoGenerateColumns="False" DataSourceID="sdsBizPartner" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}"
                                                                                    ClientInstanceName="gvCustomer">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                        <Settings ShowFilterRow="True"></Settings>
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="gridLookup_CloseUp" />
                                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                        <RequiredField IsRequired="True" />
                                                                                    </ValidationSettings>
                                                                                    <InvalidStyle BackColor="Pink">
                                                                                    </InvalidStyle>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="Price" ShowInCustomizationForm="True" VisibleIndex="10">
                                                                            <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubstitutedItem" VisibleIndex="5" Width="150px" Name="glItemCode">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubstitutedColor" VisibleIndex="6" Width="150px" Name="ColorCode">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubstitutedSize" VisibleIndex="7" Width="150px" Name="SizeCode">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubstitutedClass" VisibleIndex="8" Width="150px" Name="ClassCode">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="11" Width="0px" FieldName="PrevColorCode" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" VisibleIndex="12" Width="0px" FieldName="PrevSizeCode" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" VisibleIndex="13" Width="0px" FieldName="PrevClassCode" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <SettingsEditing Mode="Batch" />
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>

                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Item Cost History" Name="ICH">
                                        <Items>
                                            <dx:LayoutGroup Caption="Lines">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="agvItemSupplier" runat="server" AutoGenerateColumns="False" Width="747px"
                                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv3">
                                                                    <ClientSideEvents Init="OnInitTrans" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsBehavior AllowSort="false" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" Visible="False"
                                                                            VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Itemcosthisto">
                                                                                    <Image IconID="support_info_16x16"></Image>
                                                                                </dx:GridViewCommandColumnCustomButton>

                                                                            </CustomButtons>

                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LineNumber" Name="LineNumber" ShowInCustomizationForm="True" VisibleIndex="2" FieldName="LineNumber" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" VisibleIndex="3" FieldName="ItemCode" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="4" FieldName="ColorCode" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" VisibleIndex="5" FieldName="SizeCode" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" VisibleIndex="6" FieldName="ClassCode" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Supplier" Name="Supplier" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="Supplier" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Unit" Name="Unit" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="Unit" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Price" Name="Price" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="Price" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="PriceCurrency" Name="PriceCurrency" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="PriceCurrency" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="SupplierItemCode" Name="SupplierItemCode" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="SupplierItemCode" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LastPrice" Name="LastPrice" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="LastPrice" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LastUnit" Name="LastUnit" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="LastUnit" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="LastUpdate" Name="LastUpdate" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="LastUpdate" UnboundType="String" ReadOnly="true"
                                                                            PropertiesTextEdit-DisplayFormatString="{0:M/d/yyyy}">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:M/d/yyyy}"></PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="QuotePrice" Name="QuotePrice" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="QuotePrice" UnboundType="String" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130" />
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Configuration" ColCount="2">
                                        <Items>
                                            <dx:LayoutGroup Caption="" ColCount="1">
                                                <Items>
                                                    <dx:LayoutGroup Caption="Item Configuration" ColCount="2" Width="100%">
                                                        <Items>
                                                            <dx:LayoutItem Caption="Storage Type 1:" Name="txtstoragetype">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="txtstoragetype" runat="server" AutoGenerateColumns="False" DataSourceID="StorageType" KeyFieldName="StorageType" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="StorageType" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="StorageDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                            <ClientSideEvents Validation="OnValidation" />
                                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                <ErrorImage ToolTip="Base Qty Unit is required">
                                                                                </ErrorImage>
                                                                                <RequiredField IsRequired="True" />
                                                                            </ValidationSettings>
                                                                            <InvalidStyle BackColor="Pink">
                                                                            </InvalidStyle>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Storage Type 2:" Name="txtstoragetype">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="aglStorageType2" runat="server" AutoGenerateColumns="False" DataSourceID="StorageType" KeyFieldName="StorageType" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="StorageType" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="StorageDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Storage Type 3:" Name="txtstoragetype">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="aglStorageType3" runat="server" AutoGenerateColumns="False" DataSourceID="StorageType" KeyFieldName="StorageType" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="StorageType" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="StorageDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Storage Type 4:" Name="txtstoragetype">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="aglStorageType4" runat="server" AutoGenerateColumns="False" DataSourceID="StorageType" KeyFieldName="StorageType" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="StorageType" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="StorageDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Storage Type 5:" Name="txtstoragetype">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="aglStorageType5" runat="server" AutoGenerateColumns="False" DataSourceID="StorageType" KeyFieldName="StorageType" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="StorageType" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="StorageDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Tolerance %" Name="txtTolerance">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtTolerance" ClientInstanceName="txtTolerance" runat="server">
                                                                            <%--<ClientSideEvents ValueChanged="function(s,e){cp.PerformCallback('Tolerance'); e.processOnServer = false;}" />--%>
                                                                            <ClientSideEvents KeyUp="setCatchWeightOnKeyUp" LostFocus="setCatchWeightOnChange"/>
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Catch Weight">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxCheckBox runat="server" CheckState="Unchecked" ID="chkCatchWeight" ClientInstanceName="chkCatchWeight" OnLoad="Check_Load" 
                                                                            ClientSideEvents-CheckedChanged="function(s, e) {
                                                                                onCatchWgtCheckBoxChanged();
                                                                            }"></dx:ASPxCheckBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Standard Weight">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxCheckBox runat="server" CheckState="Unchecked" ID="chkStandWeight" ClientInstanceName="chkStandWeight" OnLoad="Check_Load" 
                                                                            ClientSideEvents-CheckedChanged="function(s, e) {
                                                                                onStandardWgtCheckBoxChanged();
                                                                            }"></dx:ASPxCheckBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Catch Weight Value:" Name="txtstandardqty">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtCatchWeightVal" ClientInstanceName="txtCatchWeightVal" runat="server">
                                                                            <%--<ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('Tolerance'); e.processOnServer = false;}" />--%>
                                                                            <ClientSideEvents KeyUp="setCatchWeightOnKeyUp" LostFocus="setCatchWeightOnChange"/>
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Standard Weight Value:" Name="txtstandardqty">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtstandardqty" ClientInstanceName="txtstandardqty" runat="server">
                                                                            <%--<ClientSideEvents ValueChanged="function(s,e){ cp.PerformCallback('Tolerance'); e.processOnServer = false;}" />--%>
                                                                            <ClientSideEvents KeyUp="onDecimalInputKeyUp"/>
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Min Weight Value:" Name="txtMinWeight">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtMinWeight" ClientInstanceName="txtMinWeight" runat="server">
                                                                            <ClientSideEvents KeyUp="setCatchWeightOnKeyUp" LostFocus="setCatchWeightOnChange"/>
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Max Weight Value:" Name="txtMaxWeight">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtMaxWeight" ClientInstanceName="txtMaxWeight" runat="server">
                                                                            <ClientSideEvents KeyUp="setCatchWeightOnKeyUp" LostFocus="setCatchWeightOnChange"/>
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Kitting">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxCheckBox
                                                                            runat="server"
                                                                            CheckState="Unchecked"
                                                                            ID="chkKitting"
                                                                            ClientInstanceName="chkKitting"
                                                                            ClientSideEvents-CheckedChanged="function(s, e) {
                                                                                OnKittingCheckBoxChanged(s, e);
                                                                            }">
                                                                        </dx:ASPxCheckBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Blast">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxCheckBox
                                                                            runat="server"
                                                                            CheckState="Unchecked"
                                                                            ID="chkBlast"
                                                                            ClientInstanceName="chkBlast"
                                                                            OnLoad="Check_Load"
                                                                            ClientSideEvents-CheckedChanged="function(s, e) {
                                                                                OnBlastCheckBoxChanged(s, e);
                                                                            }">
                                                                        </dx:ASPxCheckBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Scannable">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxCheckBox
                                                                            runat="server"
                                                                            CheckState="Unchecked"
                                                                            ID="chkScannable"
                                                                            OnLoad="Check_Load"
                                                                            ClientInstanceName="chkScannable"
                                                                            ClientSideEvents-CheckedChanged="function(s, e) {
                                                                                OnScannableCheckBoxChanged(s, e);
                                                                            }">
                                                                        </dx:ASPxCheckBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutGroup Caption="Blast Item Conversion" ColCount="2" Width="100%">
                                                        <Items>
                                                            <dx:LayoutItem Caption="After Blast Item 1:">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="txtSecondary" runat="server" AutoGenerateColumns="False" ClientInstanceName="txtSecondary" DataSourceID="BlastItem" KeyFieldName="ItemCode" OnLoad="LookupLoad" TextFormatString="{0}" ClientEnabled="false">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="ItemCode" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="FullDesc" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Unit" Width="200px" ReadOnly="True" VisibleIndex="1">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                            <ClientSideEvents DropDown="function (s,e){txtSecondary.GetGridView(); e.processOnServer = false;                            }"
                                                                                ValueChanged="function(s,e){
                                                                                   loader.SetText('Loading...');
                                                                                   loader.Show();
                                                                                   var g = txtSecondary.GetGridView();
                                                                                g.GetRowValues(g.GetFocusedRowIndex(), 'ItemCode;FullDesc;Unit', UpdateDescUnit); 
                                                                            }" />
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="After Blast Item 2:">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="txttertiary" runat="server" AutoGenerateColumns="False" ClientInstanceName="txttertiary" DataSourceID="BlastItem" KeyFieldName="ItemCode" OnLoad="LookupLoad" TextFormatString="{0}" ClientEnabled="false">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="ItemCode" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="FullDesc" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Unit" Width="200px" ReadOnly="True" VisibleIndex="1">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                            <ClientSideEvents DropDown="function (s,e){txttertiary.GetGridView(); e.processOnServer = false;                            }"
                                                                                ValueChanged="function(s,e){
                                                                                   loader.SetText('Loading...');
                                                                                   loader.Show();
                                                                                   var g = txttertiary.GetGridView();
                                                                                   g.GetRowValues(g.GetFocusedRowIndex(), 'ItemCode;FullDesc;Unit', UpdateDescUnit01); 
                                                                                }" />
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Item Desc 1:" Name="txtstoragetype">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtSecondaryDesc" runat="server" ClientInstanceName="txtSecondaryDesc" OnLoad="TextboxLoad" ClientEnabled="false">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Item Desc 2:" Name="txtstoragetype">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txttertiaryDesc" runat="server" ClientInstanceName="txttertiaryDesc" OnLoad="TextboxLoad" ClientEnabled="false">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Item UOM 1:" Name="txtstoragetype">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtSecondaryUOM" runat="server" ClientInstanceName="txtSecondaryUOM" OnLoad="TextboxLoad" ClientEnabled="false">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Item UOM 2" Name="txtTolerance">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txttertiaryUOM" runat="server" ClientInstanceName="txttertiaryUOM" OnLoad="TextboxLoad" ClientEnabled="false">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutGroup Caption="Scan Configuration" ColCount="2" Width="100%">
                                                        <Items>
                                                            <dx:LayoutItem Caption="Delimiter">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxCheckBox runat="server" CheckState="Unchecked" ID="ChkDelimiter" OnLoad="Check_Load" ClientEnabled="false" ClientInstanceName="ChkDelimiter">
                                                                            <ClientSideEvents CheckedChanged="isDelimitedCheckChanged"/>
                                                                        </dx:ASPxCheckBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Delimiter Value">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtDelVal" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="txtDelVal">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="DateFormat:">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridLookup ID="gridLookupDateFormat" ClientInstanceName="gridLookupDateFormat" runat="server" AutoGenerateColumns="False" DataSourceID="DateFormats" KeyFieldName="Format" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="Format" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Example" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridLookup>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Item Count">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="ItemCnt" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="ItemCnt">
                                                                            <ClientSideEvents KeyPress="function(s, e) {
                                                                                if (!(/[0-9]/.test(String.fromCharCode(e.htmlEvent.keyCode))))
                                                                                    e.htmlEvent.preventDefault();
                                                                            }" />
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Quantity Count">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="textQuantityPosition" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="textQuantityPosition">
                                                                            <ClientSideEvents KeyPress="function(s, e) {
                                                                                if (!(/[0-9]/.test(String.fromCharCode(e.htmlEvent.keyCode))))
                                                                                    e.htmlEvent.preventDefault();
                                                                            }" />
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Quantity Length" Name="quantityLengthLayout">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="textQuantityLength" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="textQuantityLength">
                                                                            <ClientSideEvents KeyPress="function(s, e) {
                                                                                if (!(/[0-9]/.test(String.fromCharCode(e.htmlEvent.keyCode))))
                                                                                    e.htmlEvent.preventDefault();
                                                                            }" />
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Weight Count">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="WeightCnt" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="WeightCnt">
                                                                            <ClientSideEvents KeyPress="function(s, e) {
                                                                                if (!(/[0-9]/.test(String.fromCharCode(e.htmlEvent.keyCode))))
                                                                                    e.htmlEvent.preventDefault();
                                                                            }" />
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Weight Length" Name="weightLengthLayout">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="textWeightLength" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="textWeightLength">
                                                                            <ClientSideEvents KeyPress="function(s, e) {
                                                                                if (!(/[0-9]/.test(String.fromCharCode(e.htmlEvent.keyCode))))
                                                                                    e.htmlEvent.preventDefault();
                                                                            }" />
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Batch Count">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="BatchCnt" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="BatchCnt">
                                                                            <ClientSideEvents KeyPress="function(s, e) {
                                                                                if (!(/[0-9]/.test(String.fromCharCode(e.htmlEvent.keyCode))))
                                                                                    e.htmlEvent.preventDefault();
                                                                            }" />
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Batch Length" Name="batchLengthLayout">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="textBatchLength" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="textBatchLength">
                                                                            <ClientSideEvents KeyPress="function(s, e) {
                                                                                if (!(/[0-9]/.test(String.fromCharCode(e.htmlEvent.keyCode))))
                                                                                    e.htmlEvent.preventDefault();
                                                                            }" />
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="LotID Count">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="LotIDCnt" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="LotIDCnt">
                                                                            <ClientSideEvents KeyPress="function(s, e) {
                                                                                if (!(/[0-9]/.test(String.fromCharCode(e.htmlEvent.keyCode))))
                                                                                    e.htmlEvent.preventDefault();
                                                                            }" />
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="LotID Length" Name="lotIDLengthLayout">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="textLotIDLength" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="textLotIDLength">
                                                                            <ClientSideEvents KeyPress="function(s, e) {
                                                                                if (!(/[0-9]/.test(String.fromCharCode(e.htmlEvent.keyCode))))
                                                                                    e.htmlEvent.preventDefault();
                                                                            }" />
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Manufacturing Date Count">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="MfgkDataCnt" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="MfgkDataCnt">
                                                                            <ClientSideEvents KeyPress="function(s, e) {
                                                                                if (!(/[0-9]/.test(String.fromCharCode(e.htmlEvent.keyCode))))
                                                                                    e.htmlEvent.preventDefault();
                                                                            }" />
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Expiry Date Count">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="ExpDateCnt" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="ExpDateCnt">
                                                                            <ClientSideEvents KeyPress="function(s, e) {
                                                                                if (!(/[0-9]/.test(String.fromCharCode(e.htmlEvent.keyCode))))
                                                                                    e.htmlEvent.preventDefault();
                                                                            }" />
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Item Affix" Name="itemAffixLayout">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="textItemAffix" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="textItemAffix">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Quantity Affix" Name="quantityAffixLayout">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="textQuantityAffix" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="textQuantityAffix">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Weight Affix" Name="weightAffixLayout">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="textWeightAffix" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="textWeightAffix">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Batch Affix" Name="batchAffixLayout">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="textBatchAffix" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="textBatchAffix">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="LotID Affix" Name="lotAffixLayout">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="textLotAffix" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="textLotAffix">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Manufacturing Date Affix" Name="mfgDateAffixLayout">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="textMfgDateAffix" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="textMfgDateAffix">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Expiry Date Affix" Name="expDateAffixLayout" ClientVisible="false">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="textExpDateAffix" runat="server" OnLoad="TextboxLoad" ClientEnabled="false" ClientInstanceName="textExpDateAffix">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Kitting Component" Width="45%">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView
                                                                    ID="gv1"
                                                                    runat="server"
                                                                    AutoGenerateColumns="False"
                                                                    OnCellEditorInitialize="gv1_CellEditorInitialize"
                                                                    ClientInstanceName="gv1"
                                                                    KeyFieldName="RecordID;ItemCode"
                                                                    OnBatchUpdate="gv1_BatchUpdate"
                                                                    SettingsBehavior-AllowSort="false">
                                                                    <StylesEditors Native="True"></StylesEditors>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="50px">
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="RecordID" Caption="RecordID" VisibleIndex="1" Width="0px" PropertiesTextEdit-Native="true" ReadOnly="true">
                                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="2" Width="150px" Name="ItemCode" PropertiesTextEdit-Native="true">
                                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="KittingItem" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                                    DataSourceID="KittingItemList" KeyFieldName="ItemCode" ClientInstanceName="KittingItem" TextFormatString="{0}" Width="100px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="350" Settings-VerticalScrollBarMode="Visible">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True" AllowDragDrop="False" EnableRowHotTrack="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" Width="100px" ReadOnly="True" VisibleIndex="0">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" Width="200px" ReadOnly="True" VisibleIndex="1">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="StandardQty" Caption="Unit Count" Width="0px" ReadOnly="True" VisibleIndex="2">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents
                                                                                        KeyPress="gridLookup_KeyPress"
                                                                                        KeyDown="gridLookup_KeyDown"
                                                                                        DropDown="function (s,e){KittingItem.GetGridView(); e.processOnServer = false; }"
                                                                                        CloseUp="gridLookup_CloseUp"
                                                                                        ValueChanged="function(s,e){
                                                                                           loader.SetText('Loading...');
                                                                                           loader.Show();
                                                                                           var g = KittingItem.GetGridView();
                                                                                           g.GetRowValues(g.GetFocusedRowIndex(), 'ItemCode;FullDesc;StandardQty', UpdateDesc);
                                                                                        }" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemDesc" Caption="ItemDesc" VisibleIndex="3" Width="350px" PropertiesTextEdit-Native="true" ReadOnly="true">
                                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="Units" Caption="Qty" VisibleIndex="4" Width="80px">
                                                                            <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0}"
                                                                                SpinButtons-ShowIncrementButtons="false" ClientInstanceName="Units">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <%--<dx:GridViewDataTextColumn Name="Remarks" ShowInCustomizationForm="True" VisibleIndex="4" FieldName="Remarks" Caption="Remarks" Width="150px" PropertiesTextEdit-Native="true" ReadOnly="true">
                                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>--%>
                                                                    </Columns>
                                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                                    <SettingsCommandButton>
                                                                        <NewButton>
                                                                            <Image IconID="actions_addfile_16x16"></Image>
                                                                        </NewButton>
                                                                        <DeleteButton>
                                                                            <Image IconID="actions_cancel_16x16"></Image>
                                                                        </DeleteButton>
                                                                    </SettingsCommandButton>
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <SettingsBehavior AllowSort="false" />
                                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="500" VerticalScrollableHeight="400" />
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
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="User Defined Tab" ColCount="2">
                                        <Items>
                                            <dx:LayoutGroup Caption="" ColCount="2" Width="50%">
                                                <Items>
                                                    <dx:LayoutItem Caption="Suffix">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad">
                                                                    <ClientSideEvents Validation="function(){isValid=true;}" />
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="UOM">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Exclude in Blasting:">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
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
                                                    <dx:LayoutItem Caption="Field10" Name="txth10">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txth10" runat="server" OnLoad="TextboxLoad">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Audit Trail Tab" ColCount="2">
                                        <Items>
                                            <dx:LayoutGroup Caption="" ColCount="2" Width="50%">
                                                <Items>
                                                    <dx:LayoutItem Caption="Added By:" Name="txtAddedBy">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtAddedBy" runat="server" ColCount="1" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Added Date:" Name="txtAddedDate">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtAddedDate" runat="server" ColCount="1" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Last Edited By" Name="txtLastEditedBy">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtLastEditedBy" runat="server" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Last Edited Date" Name="txtLastEditedDate">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtLastEditedDate" runat="server" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Activated By:" Name="txtActivatedBy">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtActivatedBy" runat="server" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Activated Date:" Name="txtActivatedDate">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtActivatedDate" runat="server" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Deactivated By:" Name="txtDeactivatedBy">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDeactivatedBy" runat="server" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Deactivated Date:" Name="txtDeactivatedDate">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDeactivatedDate" runat="server" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Pallet" ColCount="2">
                                        <Items>
                                            <dx:LayoutGroup Caption="" ColCount="2" Width="50%">
                                                <Items>
                                                    <dx:LayoutItem Caption="Case Tier">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="txtCaseTier" runat="server" OnLoad="SpinEdit_Load" Number="0">
                                                                    <SpinButtons ShowIncrementButtons="false" />
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Tier Pallet">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="txtTierPallet" runat="server" OnLoad="SpinEdit_Load" Number="0">
                                                                    <SpinButtons ShowIncrementButtons="false" />
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Packaging">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtPackaging" runat="server" DataSourceID="Packaging" OnLoad="LookupLoad" KeyFieldName="Packaging">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True"></Settings>
                                                                    </GridViewProperties>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Width">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="txtWidth" runat="server" OnLoad="SpinEdit_Load" Number="0">
                                                                    <SpinButtons ShowIncrementButtons="false" />
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Length">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="txtLength" runat="server" OnLoad="SpinEdit_Load" Number="0">
                                                                    <SpinButtons ShowIncrementButtons="false" />
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Height">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="txtHeight" runat="server" OnLoad="SpinEdit_Load" Number="0">
                                                                    <SpinButtons ShowIncrementButtons="false" />
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Unit Weight">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="txtUnitWeight" runat="server" OnLoad="SpinEdit_Load" Number="0">
                                                                    <SpinButtons ShowIncrementButtons="false" />
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Pallet Type">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtPalletType" runat="server" AutoCompleteType="Disabled" OnLoad="TextboxLoad">
                                                                    <%--<ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>--%>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>
                        </Items>
                    </dx:ASPxFormLayout>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
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
                                <td>
                                    <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false">
                                        <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                    </dx:ASPxButton>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Cloning..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="gv1">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
        <%--<SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />--%>
        <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <div class="pnl-content">
                        <dx:ASPxCheckBox Style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                        <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                            UseSubmitBehavior="false" CausesValidation="true">
                            <ClientSideEvents Click="OnUpdateClick" />
                        </dx:ASPxButton>
                    </div>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>

        <!--#region Region Datasource-->

        <%--<!--#region Region Header --> --%>
        <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.ItemMasterfile" DataObjectTypeName="Entity.ItemMasterfile" DeleteMethod="DeleteData" InsertMethod="InsertData" UpdateMethod="UpdateData">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="" Name="ItemCode" QueryStringField="docnumber" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="ODSKittingComponent" runat="server" SelectMethod="getdata" TypeName="Entity.ItemMasterfile+KittingComponent" DataObjectTypeName="Entity.ItemMasterfile+KittingComponent" DeleteMethod="DeleteKittingData" InsertMethod="InsertKittingData" UpdateMethod="UpdateKittingData"><SelectParameters>
                <asp:Parameter DefaultValue="" Name="MotherItemCode" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ItemMasterfile+ItemMasterDetail" DataObjectTypeName="Entity.ItemMasterfile+ItemMasterDetail" DeleteMethod="DeleteItemDetail" InsertMethod="AddItemDetail" UpdateMethod="UpdateItemDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="odsFab" runat="server" SelectMethod="getfabric" TypeName="Entity.ItemMasterfile+ItemMasterDetail" DataObjectTypeName="Entity.ItemMasterfile+ItemMasterDetail" DeleteMethod="DeleteFabricComp" InsertMethod="AddFabricComp" UpdateMethod="UpdateFabricComp">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="odsWHDetail" runat="server" SelectMethod="getItemWHDetail" TypeName="Entity.ItemMasterfile+ItemMasterDetail" DataObjectTypeName="Entity.ItemMasterfile+ItemMasterDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="odsSuppDetail" runat="server" SelectMethod="getItemSupplierDetail" TypeName="Entity.ItemMasterfile+ItemMasterDetail" DataObjectTypeName="Entity.ItemMasterfile+ItemMasterDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:SqlDataSource ID="sdsItemSupp" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM MasterFile.ItemCustomerPrice where ItemCode  is null " OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  masterfile.itemdetail where ItemCode  is null "
            OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsFabricComp" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  masterfile.FabricCompositionDetail where FabricCode  is null "
            OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdskiting" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.KittingItem WHERE MotherItemCode IS NULL"
            OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="ProdCat" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ProductCategoryCode,Description from  Masterfile.ProductCategory where ISNULL(IsInactive,0)=0"
            OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="ProdSubCat" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ProductSubCatCode,Description from  Masterfile.ProductCategorySub where ISNULL(IsInactive,0)=0"
            OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:ObjectDataSource ID="odsCusDetail" runat="server" DataObjectTypeName="Entity.ItemMasterfile+ItemCustomerPriceDetail" DeleteMethod="DeleteItemPriceDetail" InsertMethod="AddItemPriceDetail" SelectMethod="getdetail" TypeName="Entity.ItemMasterfile+ItemCustomerPriceDetail" UpdateMethod="UpdateItemPriceDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </form>

    <asp:SqlDataSource ID="supplier" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select SupplierCode,Name from  Masterfile.BPSupplierInfo"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="customer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select BizPartnerCode,Name from  Masterfile.BPCustomerInfo"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Unit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select UnitCode,Description from Masterfile.Unit WHERE ISNULL(IsInactive,0) =0"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Color" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ColorCode,Description from Masterfile.Color WHERE ISNULL(IsInactive,0) =0"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Class" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ClassCode,Description from Masterfile.Class WHERE ISNULL(IsInactive,0) =0"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Size" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select SizeCode,Description from Masterfile.Size WHERE ISNULL(IsInactive,0) =0"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="ItemCategory" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ItemCategoryCode,Description from Masterfile.ItemCategory WHERE ISNULL(IsInactive,0) =0 and isnull(IsAsset,0)=0 ORDER BY CONVERT(int, ItemCategoryCode) ASC"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Statussql" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select StatusCode, Description from masterfile.StockStatus where ISNULL(IsInactive,0)=0"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="StorageType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select StorageType, StorageDescription from masterfile.StorageType"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="FabricGroup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM IT.GenericLookup WHERE LookUpKey = 'FBGRP' AND ISNULL(ISINACTIVE,0)!=1"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="FabDesign" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM MasterFile.FabricDesignCategory ORDER BY 1"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Dye" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from masterfile.dyeing"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Weave" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Finishing" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT FinishingCode,Description FROM MasterFile.Finishing WHERE ISNULL(IsInactive,'0') = '0'"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ItemType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select Code,Description from it.GenericLookup where LookUpKey = 'ITMTYP' and ISNULL(IsInactive,'0') = '0'"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="CompType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select Description from it.GenericLookup where LookUpKey = 'COMTP' and ISNULL(IsInactive,'0') = '0'"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] where isnull(IsInactive,'')=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="KittingItemList" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [StandardQty] FROM Masterfile.[Item] where isnull(IsInactive,'')=0 AND ISNULL(Kitting, 0) = 1" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="BlastItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], CASE WHEN ISNULL(UnitBase,'') = '' THEN UnitBulk ELSE UnitBase END AS [Unit] FROM Masterfile.[Item] where isnull(IsInactive,'')=0 AND ISNULL(Blast,0) = 1" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBizPartner" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select BizPartnerCode,Name from masterfile.BPCustomerInfo where ISNULL(isinactive,0)!=1" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsVAT" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT TCode AS Tax, Description, ISNULL(Rate,0) AS Rate FROM Masterfile.Tax WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTaxCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TCode, Description, Rate FROM Masterfile.Tax WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="PutawayStrategies" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="WITH StrategiesCTE AS (SELECT 'Standard' AS PutawayStrategies, 'ST' AS PutawayStrategiesCode UNION ALL SELECT 'Manual', 'MA'
    UNION ALL SELECT 'Cross Duck', 'CR' UNION ALL SELECT 'Consolidation (Kitting)', 'CO(KI)') SELECT PutawayStrategies, PutawayStrategiesCode FROM StrategiesCTE;"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="AllocationStrategies" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="WITH AllocationCTE AS (SELECT 'Manual Allocation' AS AllocationStrategies, 'MA' AS AllocationStrategiesCode 
    UNION ALL SELECT 'Auto-Allocation', 'AA' UNION ALL SELECT 'Consolidation (Kitting)', 'CO(KI)' UNION ALL SELECT 'Store Picking', 'SP') SELECT AllocationStrategies, AllocationStrategiesCode FROM AllocationCTE;"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ABCSpeed" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT 'Fast Moving' AS ABC UNION ALL SELECT 'Slow Moving' AS ABC UNION ALL SELECT 'Average Moving' AS ABC"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="LocationCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select RoomCode from Masterfile.Room"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Packaging" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT 'Box' AS Packaging UNION ALL SELECT 'Pack' AS Packaging UNION ALL SELECT 'Carcass etc' AS Packaging"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="DateFormats" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="[dbo].[sp_GetScannableDateFormats]"
        SelectCommandType="StoredProcedure"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


