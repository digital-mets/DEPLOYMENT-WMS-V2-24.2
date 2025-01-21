<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmReceivingReport.aspx.cs" Inherits="GWL.frmReceivingReport" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <script src="../js/keyboardNavi.js" type="text/javascript"></script>
    <title></title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
        height: 600px; /*Change this whenever needed*/
        }

    .Entry {
 padding: 20px;
 margin: 10px auto;
 background: #FFF;
 }

        .dxeButtonEditSys input,
        .dxeTextBoxSys input{
            text-transform:uppercase;
        }

         .pnl-content
        {
            text-align: right;
        }


    </style>
    <!--#endregion-->
    
    <!--#region Region Javascript-->
    <script>

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var entry = getParameterByName('entry');

        var isValid = true;
        var counterror = 0;
        var totalvat = 0;
        var totalnonvat = 0;

        var module = getParameterByName("transtype");
        var id = getParameterByName("docnumber");
        var entry = getParameterByName("entry");

        function onload() {
            window.setTimeout(function () {
                fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + txtDocNumber.GetText() + '&transtype=' + module);
            }, 500);
        }

        $(document).ready(function () {
            PerfStart(module, entry, id);
        });

        function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)
            if (s.GetText() == "" || e.value == "" || e.value == null) {
                counterror++;
                isValid = false
                console.log(s);
                console.log(e);

            }
            else {
                isValid = true;

            }
        }

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            var btnmode = btn.GetText(); //gets text of button
            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }
            if (glBroker.GetText() != "" && (txtTotalFreight.GetText() == "" || txtTotalFreight.GetValue() == null || txtTotalFreight.GetValue() == 0)) {
                alert('Total freight is required!'); ////tercode
            }
            else {
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
                    console.log(counterror);
                }
            }
        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        var vatrate = 0;
        var atc = 0
        var VATCode = "";
        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);

                //if (s.cp_forceclose) {//NEWADD
                //    delete (s.cp_forceclose);
                //    window.close();
                //}

            }

            if (s.cp_close) {
                gv1.CancelEdit();
                if (s.cp_message != null) {
                    alert(s.cp_message);
                    delete (s.cp_message);
                }
                if (s.cp_valmsg != null && s.cp_valmsg != "" && s.cp_valmsg != undefined) {
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
            if (s.cp_generated) {
                delete (s.cp_generated);
                console.log('daan')
                autocalculate();
                // cp.PerformCallback('vat');
            }

            //if (s.cp_vatdetail != null) {
            //    totalvat = s.cp_vatdetail;
            //    delete (s.cp_vatdetail);
            //    txtgross.SetText(totalvat);
            //    console.log('vat');
            //}

            //if (s.cp_nonvatdetail != null) {
            //    totalnonvat = s.cp_nonvatdetail;
            //    delete (s.cp_nonvatdetail);
            //    txtnonvat.SetText(totalnonvat);
            //}
            //if(s.cp_vatrate !=null)
            //{

            //    vatrate = s.cp_vatrate;
            //    var vatdetail1 = 1 + parseFloat(vatrate);

            //    txtVatAmount.SetText(((txtgross.GetText() / vatdetail1) * vatrate).toFixed(2))
            //}
            //if (s.cp_atc != null) {

            //    atc = s.cp_atc;

            //    txtWithHoldingTax.SetText(((txtgross.GetText() - txtVatAmount.GetText()) * atc).toFixed(2))
            //}
        }
        var index;
        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var valchange = false;
        var valchange1 = false;
        var evn;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            index = e.visibleIndex;
            evn = e;

            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}
            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }
            if (entry != "V") {


                if (e.focusedColumn.fieldName === "VATCode" || e.focusedColumn.fieldName === "ATCCode") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsVat") == false) {
                        e.cancel = true;
                    }
                    else {
                        glVATCode.GetInputElement().value = cellInfo.value; //Gets the column value
                        isSetTextRequired = true;
                    }
                }

                if (e.focusedColumn.fieldName === "ReturnedBulkQty" || e.focusedColumn.fieldName === "PesoAmount" || e.focusedColumn.fieldName === "POQty") { //Check the column name
                    e.cancel = true;
                }
                if (txtHSubmittedBy.GetText() != "") {
                    if (e.focusedColumn.fieldName === "ReceivedQty" || e.focusedColumn.fieldName === "BulkQty" || e.focusedColumn.fieldName === "Unit") { //Check the column name
                        e.cancel = true;
                    }
                }

                if (glBroker.GetText() == "" || glBroker.GetValue() == null || glBroker.GetValue() == undefined) { ////tercode
                    if (e.focusedColumn.fieldName === "UnitFreight") {
                        e.cancel = true;
                    }
                }

                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
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
                    glpUnit.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName === "ATCCode") {
                    glAtcCode.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "VATCode") {
                    glVATCode.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "ReturnedQty" || e.focusedColumn.fieldName === "FullDesc") {
                    e.cancel = true;
                }
            }

            keybGrid = s;
            keyboardOnStart(e);
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "ItemCode") {
                cellInfo.value = gl.GetValue();
                cellInfo.text = gl.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "ColorCode") {
                cellInfo.value = gl2.GetValue();
                cellInfo.text = gl2.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "ClassCode") {
                cellInfo.value = gl3.GetValue();
                cellInfo.text = gl3.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "SizeCode") {
                cellInfo.value = gl4.GetValue();
                cellInfo.text = gl4.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "Unit") {
                cellInfo.value = glpUnit.GetValue();
                cellInfo.text = glpUnit.GetText().toUpperCase();
            }

            if (currentColumn.fieldName === "ATCCode") {
                cellInfo.value = glAtcCode.GetValue();
                cellInfo.text = glAtcCode.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "VATCode") {
                cellInfo.value = glVATCode.GetValue();
                cellInfo.text = glVATCode.GetText();
            }
            keyboardOnEnd();
        }
        function autocalculate(s, e) {
            //console.log(txtNewUnitCost.GetValue());
           // OnInitTrans();
            var unitfrieght = 0.00;
            var receivedqty = 0.0000;
            var bulkqty = 0.00;
            var unitcost = 0.00;
            var receivedqty1 = 0.0000;
            var unitcost1 = 0.00;
            var receivedqty2 = 0.0000;
            var unitcost2 = 0.00;
            var exchangerate = 0.00;
            var freight = 0.00;
            var totalqty = 0.0000
            var vatrate = 0.00;
            var pesoamount = 0.00
            var atcrate = 0.00

            var totalfreight = 0.00;
            var TotalQuantity = 0.0000;
            var TotalAmount = 0.00;
            var TotalAmount1 = 0.00;
            var TotalAmount2 = 0.00;
            var TotalAmount3 = 0.00;
            var ForeignAmount = 0.00;
            var frieght = 0.00;
            var TotalVAt = 0.00;
            var TotalWithHolding = 0.00;
            var TotalBulk = 0.00;
            if (txtexchangerate.GetText() == null || txtexchangerate.GetText() == "") {
                exchangerate = 0;
            }
            else {
                exchangerate = txtexchangerate.GetText();
            }







            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {


                        receivedqty = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedQty"));
                        unitcost = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost"));

                        bulkqty = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "BulkQty"));

                        unitfrieght = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "UnitFreight"));

                        totalfreight += unitfrieght * receivedqty
                        TotalAmount3 += unitcost * receivedqty
                        TotalQuantity += receivedqty * 1.00;
                        TotalBulk += bulkqty * 1.00;

                        if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVat") == true) {

                            receivedqty1 = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedQty"));
                            unitcost1 = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost"));
                            TotalAmount1 += unitcost1 * receivedqty1


                        }

                        else if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVat") == false) {

                            receivedqty2 = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedQty"));
                            unitcost2 = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost"));
                            TotalAmount2 += unitcost2 * receivedqty2


                        }


                        gv1.batchEditApi.SetCellValue(indicies[i], "PesoAmount", ((unitcost * exchangerate) * receivedqty).toFixed(2));
                        //RRA
                        vatrate = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "VATRate"));
                        pesoamount = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "PesoAmount"));
                        atcrate = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "ATCRate"));
                        TotalAmount += pesoamount;
                        TotalVAt += (pesoamount) * vatrate;
                        TotalWithHolding += pesoamount * atcrate;


                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            receivedqty = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedQty"));
                            unitcost = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost"));

                            bulkqty = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "BulkQty"));

                            unitfrieght = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "UnitFreight"));

                            totalfreight += unitfrieght * receivedqty
                            TotalAmount3 += unitcost * receivedqty
                            TotalQuantity += receivedqty * 1.00;
                            TotalBulk += bulkqty * 1.00;

                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVat") == true) {

                                receivedqty1 = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedQty"));
                                unitcost1 = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost"));
                                TotalAmount1 += unitcost1 * receivedqty1


                            }

                            else if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVat") == false) {

                                receivedqty2 = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedQty"));
                                unitcost2 = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost"));
                                TotalAmount2 += unitcost2 * receivedqty2


                            }


                            gv1.batchEditApi.SetCellValue(indicies[i], "PesoAmount", ((unitcost * exchangerate) * receivedqty).toFixed(2));
                            //RRA
                            vatrate = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "VATRate"));
                            pesoamount = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "PesoAmount"));
                            atcrate = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "ATCRate"));
                            TotalAmount += pesoamount;
                            TotalVAt += (pesoamount) * vatrate;
                            TotalWithHolding += pesoamount * atcrate;

                        }
                    }
                }










                //var pesoamount = gv1.GetEditValue("UnitCost");
                ///RRA

                //alert(totalfreight.toFixed(2) + 'TotalFreight')
                //alert(TotalAmount1 * parseFloat(exchangerate).toFixed(2) + 'txtgross')
                //alert(TotalAmount2 * parseFloat(exchangerate).toFixed(2) + 'txtnonvat')
                //alert(TotalAmount.toFixed(2) + 'txtTotalAmount')
                //alert(TotalAmount3.toFixed(2) + 'txtForeignAmount')
                //alert(TotalQuantity.toFixed(4) + 'txttotalqty')
                //alert(TotalBulk.toFixed(2) + 'txttotalbulk')
                //alert(TotalWithHolding.toFixed(2) + 'txtWithHoldingTax')
                //alert(TotalVAt + 'txtVatAmount')

                txtTotalFreight.SetValue(totalfreight.toFixed(2));

                txtgross.SetValue(TotalAmount1 * parseFloat(exchangerate).toFixed(2));
                txtnonvat.SetValue(TotalAmount2 * parseFloat(exchangerate).toFixed(2))

                txtTotalAmount.SetValue(TotalAmount.toFixed(2));
                txtForeignAmount.SetValue(TotalAmount3.toFixed(2));
                txttotalqty.SetValue(TotalQuantity.toFixed(4));
                txttotalbulk.SetValue(TotalBulk.toFixed(2));
                txtWithHoldingTax.SetValue(TotalWithHolding.toFixed(2));
                txtVatAmount.SetValue(TotalVAt);
                //   cp.PerformCallback('vat')
            }, 500);
        }
        function detailautocalculate(s, e) {
            //console.log(txtNewUnitCost.GetValue());
            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {



                        gv1.batchEditApi.SetCellValue(indicies[i], "UnitFreight", (txtTotalFreight.GetValue() / txttotalqty.GetValue()).toFixed(2));


                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {


                            gv1.batchEditApi.SetCellValue(indicies[i], "UnitFreight", (txtTotalFreight.GetValue() / txttotalqty.GetValue()).toFixed(2));
                        }
                    }
                }








            }, 500);
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
            if (keyCode !== ASPxKey.Tab) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (gv1.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
        }

        function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == ASPxKey.Enter) {
                gv1.batchEditApi.EndEdit();
            }
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            setTimeout(function () {
                gv1.batchEditApi.EndEdit();
            }, 500);
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields/index 0 is from the commandcolumn)
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                var chckd2;
                //if (column != s.GetColumn(1) && column != s.GetColumn(2) && column != s.GetColumn(3)
                //    && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15)
                //    && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18)
                //    && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21)
                //    && column != s.GetColumn(22) && column != s.GetColumn(23)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                //    var cellValidationInfo = e.validationInfo[column.index];
                //    if (!cellValidationInfo) continue;
                //    var value = cellValidationInfo.value;
                //    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = column.fieldName + " is required";
                //        isValid = false;
                //        console.log(column);
                //    }
                //    else {
                //        isValid = true;
                //    }
                //}

                if (column.fieldName == "IsVat") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;

                    //console.log(value + ' IsVat value')
                    if (value == true) {
                        //console.log('weee')
                        chckd2 = true;
                    }
                }
                if (column.fieldName == "VATCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    console.log(value + ' value' + chckd2)

                    //console.log(chckd2 + ' chckd2')
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == "NONV") && chckd2 == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required!";
                        isValid = false;
                        console.log(column.fieldName);
                    }
                }
            }
        }


        var clonenumber = 0;
        var cloneindex;
        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                var Warehouse = prnum.GetText();
                var BizPartnerCode = glSupplierCode.GetText();
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&unit=' + unitbase + '&Warehouse=' + Warehouse);

                factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
            }
            if (e.buttonID == "CountSheet") {
                CSheet.Show();
                var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
                var docnumber = getParameterByName('docnumber');
                var transtype = getParameterByName('transtype');
                var refdocnum = "";
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");

                var entry = getParameterByName('entry');
                CSheet.SetContentUrl('../WMS/frmTRRSetup.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
                    '&linenumber=' + linenum + '&refdocnum=' + refdocnum + '&itemcode=' + encodeURIComponent(itemcode) + '&colorcode=' + encodeURIComponent(colorcode) +
                    '&classcode=' + encodeURIComponent(classcode) + '&sizecode=' + encodeURIComponent(sizecode));

            }
            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate(s, e);

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
            if (e.buttonID == "CloneButton") {
                if (!CINClone.GetText()) {
                    alert('Please input a number to Clone textbox!');
                    return;
                }

                cloneloading.Show();
                setTimeout(function () {
                    clonenumber = CINClone.GetText();
                    for (i = 1; i <= clonenumber; i++) {
                        cloneindex = e.visibleIndex;
                        copyFlag = true;
                        gv1.AddNewRow();
                        precopy(gv1, evn);
                    }
                }, 1000);
            }
        }


        function precopy(ss, ee) {
            if (copyFlag) {
                copyFlag = false;

                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCellsClone(0, ee, column, gv1);
                }
            }
        }



        function ProcessCellsClone(selectedIndex, e, column, s) {//Clone function :D
            if (selectedIndex == 0) {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, s.batchEditApi.GetCellValue(cloneindex, column.fieldName));
                if (column.fieldName == "LineNumber") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "");
                }
            }
            cloneloading.Hide();
        }


        function Generate(s, e) {
            var prtext = glPickList.GetText();
            if (!prtext) { alert('No PO to generate!'); return; }
            var generate = confirm("Are you sure you want to generate these purchase order?");
            if (generate) {
                cp.PerformCallback('Generate');
                e.processOnServer = false;
            }
        }


        var val;
        var temp;
        var identifier;
        var testinglang;
        var valchange = false;
        var valchange1 = false;
        function GridEnd(s, e) {
            identifier = s.GetGridView().cp_identifier;
            val = s.GetGridView().cp_codes;
            //console.log(val + 'val');
            if (val != null) {
                temp = val.split(';');
                delete (s.GetGridView().cp_codes);
            }
            else {
                val = "";
                delete (s.GetGridView().cp_codes);
            }
            console.log('identifier ' + identifier)



            if (valchange) {
                valchange = false;
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    gridcheck = 1;
                    ProcessCells(0, e, column, gv1);
                    gv1.batchEditApi.EndEdit();
                }
            }


            if (valchange1) {
                console.log('pasok')
                valchange1 = false;
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    gridcheck = 2;
                    ProcessCells(0, index, column, gv1);
                }
                gv1.batchEditApi.EndEdit();
                loader.Hide();
            }
            loading = false;
            loader.Hide();
        }

        function ProcessCells(selectedIndex, e, column, s) {

            if (val == null) {
                val = ";;;;";
                temp = val.split(';');
            }

            if (temp[0] == null) {
                temp[0] = "0";
            }


            //console.log('val ' + val);

            if (selectedIndex == 0) {
                if (gridcheck == 1) {
                    if (identifier == "VAT") {
                        if (column.fieldName == "VATRate") {
                            s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                            autocalculate()
                        }

                    }
                }
                    //RA
                else if (gridcheck == 2) {

                    if (column.fieldName == "ATCRate") {

                        s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                        autocalculate();
                    }
                }
                valchange1 = false;
                valchange = false;
            }
        }







        function endcp2(s, e) {
            var endg = s.cp_endgl1;

            console.log('endg2');
            cp.PerformCallback('RR');
            e.processOnServer = false;
            endg = null;

        }

        function OnInitTrans(s, e) {
            OnInit(s);
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
            gvRef.SetWidth(width - 120);
            gvJournal.SetWidth(width - 120);
            brokerchange(); ////tercode
        }

        function CancelEditing(s, e) {
            e.cancel = true;
        }

        function brokerchange() { ////tercode
            if (glBroker.GetValue() != "" && glBroker.GetValue() != null && glBroker.GetValue() != undefined) {
                txtTotalFreight.SetEnabled(true);
            }
            else {
                txtTotalFreight.SetText(null);
                txtTotalFreight.SetEnabled(false);
                setTimeout(function () {
                    var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                    for (var i = 0; i < indicies.length; i++) {
                        gv1.batchEditApi.SetCellValue(indicies[i], "UnitFreight", 0.0000);
                    }
                }, 500);
            }
        }

    </script>
    <!--#endregion-->
</head>
<body style="height: 910px;" onload="onload()">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
<form id="form1" runat="server" class="Entry">
    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
        <PanelCollection>
            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                <dx:ASPxLabel runat="server"  ID="FormTitle" Text="Receiving Report" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
            </dx:PanelContent>
        </PanelCollection>
    </dx:ASPxPanel>
    &nbsp;<br />
    <br />
    <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
    EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="50"
    ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popup2" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox2" CloseAction="None" 
    EnableViewState="False" HeaderText="Supplier info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="260"
    ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
    EnableViewState="False" HeaderText="Notes" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="470"
    ShowCloseButton="False" Collapsed="true" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
    EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
    ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents CloseUp="function (s, e) { window.location.reload(); }" />
    </dx:ASPxPopupControl>

        <%--<dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">--%>
             <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback" SettingsLoadingPanel-Enabled="true" SettingsLoadingPanel-Delay="3000" Images-LoadingPanel-Url="..\images\loadinggear.gif" Images-LoadingPanel-Height="30px" Styles-LoadingPanel-BackColor="Transparent" Styles-LoadingPanel-Border-BorderStyle="None" SettingsLoadingPanel-Text="" SettingsLoadingPanel-ShowImage="true" >

    <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -20px" SettingsAdaptivity-AdaptivityMode="SingleColumnWindowLimit" SettingsAdaptivity-SwitchToSingleColumnAtWindowInnerWidth="800">
                    <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" ClientInstanceName="txtDocNumber" runat="server" Width="170px"  OnLoad="TextboxLoad" AutoCompleteType="Disabled" ClientEnabled="False">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnLoad="Date_Load" OnInit ="dtpDocDate_Init"  Width="170px">
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
                                            <dx:LayoutItem Caption="APV Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtApVNumber" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                 <dx:LayoutItem Caption="Supplier Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glSupplierCode" ClientInstanceName="glSupplierCode" runat="server" DataSourceID="sdsSupplier" KeyFieldName="SupplierCode"
                                                            GridViewProperties-SettingsLoadingPanel-Text="" GridViewImages-LoadingPanel-Url="..\images\loadinggear.gif"  GridViewImages-LoadingPanel-Height="30px" GridViewStyles-LoadingPanel-BackColor="Transparent" GridViewProperties-SettingsLoadingPanel-ShowImage="true" GridViewProperties-SettingsLoadingPanel-Delay="3000" GridViewStyles-LoadingPanel-Border-BorderColor="Transparent" 
                                                              OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents  Validation="OnValidation" ValueChanged="function(s, e) {
                                                                   cp.PerformCallback('Supplier');
                                                                   e.processOnServer = false;
                                                                }"
                                                              />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Auxiliary Reference">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAuxiliaryReference" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                              <dx:LayoutItem Caption="DR Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDrNumber" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                    
                                              <dx:LayoutItem Caption="Broker">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtBroker" AutoGenerateColumns="false" ClientInstanceName="glBroker" runat="server" DataSourceID="sdsSupplier1" KeyFieldName="SupplierCode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SupplierCode" Caption="Broker Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents ValueChanged="brokerchange" /> <%--tercode--%>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Warehouse Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="aglWarehouseCode" ClientInstanceName="prnum" runat="server" DataSourceID="sdsWarehouse" KeyFieldName="WarehouseCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="WarehouseCode" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="Description" Settings-AutoFilterCondition="Contains" />
                                                            </Columns> 
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="PO DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glPicklist" runat="server" AutoGenerateColumns="False" ClientInstanceName="glPickList" 
                                                            KeyFieldName="DocNumber" OnInit="aglcustomerinit" OnLoad="LookupLoad" 
                                                            SelectionMode="Multiple" TextFormatString="{0}" Width="170px">
                                                            <ClientSideEvents DropDown="function (s,e) { glPickList.GetGridView().PerformCallback(glSupplierCode.GetText()) }" />
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                                </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn Caption="Purchase Order No" FieldName="DocNumber" ShowInCustomizationForm="True" 
                                                                    VisibleIndex="1" Width="50px">
                                                                <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            
                                            <dx:LayoutItem Caption="Total Quantity">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speTotalQuantity" runat="server" Width="170px"
                                                            ReadOnly="true" ClientInstanceName="txttotalqty" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                            DisplayFormatString="{0:#,0.0000;(#,0.0000);}" AllowMouseWheel="false" HorizontalAlign="Right">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            
                                            <dx:LayoutItem Caption="" Name="Genereatebtn">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxButton ID="Generatebtn" runat="server" Width="70px"  ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False"  Text="Generate" Theme="MetropolisBlue">
                                                            <ClientSideEvents Click="Generate" />
                                                        </dx:ASPxButton>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Bulk Quantity">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speTotalBulk" runat="server" Width="170px" 
                                                            ReadOnly="true" ClientInstanceName="txttotalbulk" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:EmptyLayoutItem>
                                            </dx:EmptyLayoutItem>
                                            <dx:LayoutItem Caption="Clone">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="SpinClone" runat="server" Increment="0" NullText="0"  MaxValue="9999999999" MinValue="0" Width="170px" ClientInstanceName="CINClone" SpinButtons-ShowIncrementButtons="false"> 
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:EmptyLayoutItem>
                                            </dx:EmptyLayoutItem>
                                            <dx:LayoutItem Caption="Complimentary Item">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chckComplimentary" runat="server" Width="170px"  CheckState="Unchecked" ClientInstanceName="chckcompli" OnLoad="CheckBoxLoad">
                                                            <ClientSideEvents CheckedChanged="function(s,e){cp.PerformCallback('CallbackCheck');}" />
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Remarks:" Name="Remarks:"> 
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" Width="800px" >
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
                                    <dx:LayoutGroup Caption="Costing" ColCount="2" Name="Costing">
                                        <Items>
                                            <dx:LayoutItem Caption="Currency ">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <%--<dx:ASPxTextBox ID="txtCurrency" runat="server" OnLoad="TextboxLoad" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>--%>
                                                        <dx:ASPxGridLookup ID="txtCurrency" runat="server" Width="170px" DataSourceID="Currencylookup" KeyFieldName="Currency" OnLoad="LookupLoad"
                                                               AutoGenerateColumns="true" TextFormatString="{0}" ClientInstanceName="txtCurrency">
                                                               <GridViewProperties>                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                   <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                               </GridViewProperties>
                                                               <Columns>
                                                                   <dx:GridViewDataTextColumn FieldName="Currency" ShowInCustomizationForm="True" VisibleIndex="1">
					                                                   <Settings AutoFilterCondition="Contains" />
                                                                   </dx:GridViewDataTextColumn>
					                                               <dx:GridViewDataTextColumn FieldName="CurrencyName" ShowInCustomizationForm="True" VisibleIndex="2">
					                                                    <Settings AutoFilterCondition="Contains" />
                                                                   </dx:GridViewDataTextColumn>
                                                               </Columns>
                                                               <ClientSideEvents ValueChanged="function(s,e){if(s.GetText()!='PHP'){
                                                                    txtexchangerate.SetEnabled(true);
                                                                   }}" />
                                                       </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="SI Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSINumber" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Terms">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <%--<dx:ASPxTextBox ID="txtTerms" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>--%>
                                                        <dx:ASPxSpinEdit ID="txtTerms" runat="server" Width="170px" ClientInstanceName="txtTerms"  
                                                            OnLoad="SpinEdit_Load"  NullText="0" MinValue="0" MaxValue="999999999"  
                                                            AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false" 
                                                            >
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Exchange Rate" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speExchangeRate" runat="server" Width="170px" ClientInstanceName="txtexchangerate"  OnLoad="SpinEdit_Load"  NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2" >
                                                            <ClientSideEvents ValueChanged="autocalculate" GotFocus="function test(){
                                                                if(txtCurrency.GetText() == 'PHP')
                                                                txtexchangerate.SetEnabled(false);                           
                                                                }" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Total Freight">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speTotalFreight" runat="server" Width="170px" DisplayFormatString="{0:N}" ClientInstanceName="txtTotalFreight" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">
                                                            <ClientSideEvents LostFocus="detailautocalculate" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Peso Amount" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="spePesoAmount" runat="server" Width="170px" ClientInstanceName="txtTotalAmount" DisplayFormatString="{0:N}" ReadOnly="true" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2" >
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Foreign Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speForeigntAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtForeignAmount" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Gross Vatable Amount" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speGrossVatableAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtgross" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">
                                                       <ClientSideEvents Validation="function (s,e)
                                                                {
                                                                 OnValidation = true;
                                                                }" />
                                                             </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Non Vatable Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speNonVatableAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtnonvat" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Vat Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speVatAmount" runat="server" Width="170px" ReadOnly="True" DisplayFormatString="{0:N}" ClientInstanceName="txtVatAmount" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Withholding Tax">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speWithHoldingTax" runat="server" DisplayFormatString="{0:N}"  ClientInstanceName="txtWithHoldingTax"  ReadOnly="True" Width="170px" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">
                                                        </dx:ASPxSpinEdit>
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
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" ReadOnly="True" Width="170px">
                                                            <ClientSideEvents Validation="function (s,e)
                                                                {
                                                                 OnValidation = true;
                                                                }" />
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
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px"  ReadOnly="true" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <dx:LayoutItem Caption="Last Edited Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ReadOnly="True" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" ClientInstanceName="txtHSubmittedBy" runat="server" Width="170px"  ReadOnly="true"  >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px"  ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px"  ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px"  ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Costing Submitted By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCostingSubmittedBy" runat="server" Width="170px"  ReadOnly="true"  >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption=" Costing Submitted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCostingSubmittedDate" runat="server" Width="170px"  ReadOnly="true">
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
                                        </Items>
                                    </dx:LayoutGroup>

                                    <dx:LayoutGroup Caption="Journal Entries" Name="JEntries">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvJournal" runat="server" AutoGenerateColumns="False" Width="850px" ClientInstanceName="gvJournal"  KeyFieldName="RTransType;TransType" 
                                                            Settings-ShowStatusBar="Hidden" >
                                                            <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" BatchEditStartEditing="CancelEditing" />
                                                            <SettingsPager Mode="ShowAllRecords" />  
                                                            <SettingsEditing Mode="Batch"/>
                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
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
                             
                                    <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px" ClientInstanceName="gvRef"
                                                            KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Settings-ShowStatusBar="Hidden"  >
                                                            <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="NextColumn"  />
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" BatchEditStartEditing="CancelEditing" />
                                                            <SettingsPager PageSize="5"></SettingsPager>
                                                            <SettingsEditing Mode="Batch"></SettingsEditing>
                                                            <ClientSideEvents Init="OnInitTrans" />
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
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Caption="DocNumber" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="RTransType" Caption="Reference TransType" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly="True"  Name="RTransType"> 
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="REFDocNumber" Caption="Reference DocNumber" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4" ReadOnly="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3"  ReadOnly="true"> 
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6"   ReadOnly="true">
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

                            <dx:LayoutGroup Caption="Receiving Report Detail" Name="RRDetail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False"  Width="770px" KeyFieldName="DocNumber;LineNumber;PODocNumber"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnInit="gv1_Init" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    Settings-ShowStatusBar="Hidden" >
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditRowValidating="Grid_BatchEditRowValidating"/>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Width="0px" VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="80px" ReadOnly="true">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="4" Width="100px" Name="glpItemCode" ReadOnly="True">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="sdsItem" KeyFieldName="ItemCode" ClientInstanceName="gl" 
                                                                    TextFormatString="{0}" Width="100px"  ReadOnly="True" 
                                                                    Enabled="false">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" VisibleIndex="5" Width="300px" Caption="Item Description">   
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="5" Width="80px" Name="glpColorCode" ReadOnly="True"  >
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"  Enabled="false"
                                                                    KeyFieldName="ColorCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" OnInit="lookup_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="6" Width="80px" Name="glpClassCode" ReadOnly="True">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    KeyFieldName="ClassCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" Enabled="false">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains"/>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                        DropDown="function dropdown(s, e){
                                                                        gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="7" Width="80px" UnboundType="String" Name="glpSizeCode" ReadOnly="True">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    KeyFieldName="SizeCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" Enabled="false">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                        DropDown="function dropdown(s, e){
                                                                        gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="BulkQty" VisibleIndex="13" Width="80px" UnboundType="Decimal"  Name="glpBulkQty" >
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="glpBulkQty" NullDisplayText="0"  DisplayFormatString="{0:N}" ConvertEmptyStringToNull="False" NullText="0"  MaxValue="9999999999" MinValue="0"  SpinButtons-ShowIncrementButtons ="false" AllowMouseWheel="false">
                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image"  ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="90px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                    <Image IconID="support_info_16x16" ToolTip="Countsheet"></Image>
                                                                </dx:GridViewCommandColumnCustomButton> 
                                                                <dx:GridViewCommandColumnCustomButton ID="CloneButton" Text="Copy">
                                                                    <Image IconID="edit_copy_16x16" ToolTip="Clone"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="CountSheet">
                                                                    <Image IconID="arrange_withtextwrapping_topleft_16x16" ToolTip="Countsheet"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="PODocNumber" Name="glpPicklistNo" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="True">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="PRNumber" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="True">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="RoundingAmt" Caption="RoundingAmount" Name="glRoundingAmount" ShowInCustomizationForm="True" VisibleIndex="14" >
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="glEounding" NullDisplayText="0.00" DisplayFormatString="{0:N}" ConvertEmptyStringToNull="False" NullText="0.00"  MaxValue="9999999999" MinValue="0"  SpinButtons-ShowIncrementButtons ="false">
                                                                <ClientSideEvents ValueChanged="autocalculate" /> 
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                    
                                                        <dx:GridViewDataTextColumn FieldName="Unit" Name="Unit" VisibleIndex="10" Width="80px" Caption="Unit">   
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    KeyFieldName="Unit" DataSourceID="Unitlookup" ClientInstanceName="glpUnit" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Unit" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                        DropDown="lookup" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="POQty" Name="glPOQty" ShowInCustomizationForm="True" VisibleIndex="8" ReadOnly="True" UnboundType="Decimal">
                                                            <PropertiesTextEdit DisplayFormatString="{0:#,0.0000;(#,0.0000);}" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="ReceivedQty" Name="glReceivedQty" PropertiesSpinEdit-LargeIncrement="0" ShowInCustomizationForm="True" VisibleIndex="9"  >
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="glReceivedQty" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}"  MaxValue="9999999999" MinValue="0.9999"  SpinButtons-ShowIncrementButtons ="false" AllowMouseWheel="false">
                                                                <ClientSideEvents ValueChanged="autocalculate" /> 
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitFreight" Name="glUnitFreight" ShowInCustomizationForm="True" PropertiesSpinEdit-LargeIncrement="0" VisibleIndex="15"  >
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="glUnitFreight" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:G}"  MaxValue="9999999999" MinValue="0" DecimalPlaces="4" SpinButtons-ShowIncrementButtons ="false"   AllowMouseWheel="false">
                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ReturnedQty" Name="glReturnQty" ShowInCustomizationForm="True" VisibleIndex="16"  ReadOnly="True">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitCost" Name="glUnitCost" ShowInCustomizationForm="True" VisibleIndex="11" PropertiesSpinEdit-LargeIncrement="0">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="glUnitCost"  NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N4}"  DecimalPlaces="4"  MaxValue="9999999999" MinValue="0"  SpinButtons-ShowIncrementButtons ="false" AllowMouseWheel="false">
                                                                <ClientSideEvents LostFocus="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="PesoAmount" Name="glPesoAmount" ShowInCustomizationForm="True" VisibleIndex="12" PropertiesSpinEdit-LargeIncrement="0"  ReadOnly="True">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="glPesoAmount"  NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" AllowMouseWheel="false" >
                                                                <ClientSideEvents ValueChanged="autocalculate"  />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataCheckColumn Caption="VAT Liable" FieldName="IsVat" Name="IsVat" ShowInCustomizationForm="True" VisibleIndex="17">
                                                            <PropertiesCheckEdit ClientInstanceName="glIsVat" >
                                                                <ClientSideEvents CheckedChanged="function(s,e){ 
                                                                    gv1.batchEditApi.EndEdit(); 
                                                                    if (s.GetChecked() == false) 
                                                                    {
                                                                    console.log('wew')
                                                                        gv1.batchEditApi.SetCellValue(index, 'VATCode', 'NONV');
                                                                        gv1.batchEditApi.SetCellValue(index, 'Rate', '0');
                                                                         gv1.batchEditApi.SetCellValue(index, 'ATCCode', '');
                                                                        gv1.batchEditApi.SetCellValue(index, 'ATCRate', '0');
                                                                    }
                                                                    else

                                                                    {
                                                                      gv1.batchEditApi.SetCellValue(index, 'VATCode', '');
                                                                    }
                                                                    autocalculate();
                                                                    }" />
                                                            </PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>

                                                        <dx:GridViewDataTextColumn FieldName="VATCode" VisibleIndex="17" Width="80px" Caption="VATCode">   
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glVATCode" runat="server" DataSourceID="VatCodeLookup"  AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    KeyFieldName="TCode" ClientInstanceName="glVATCode" TextFormatString="{0}" Width="80px" OnLoad="LookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="TCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Rate" ReadOnly="True" VisibleIndex="2" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        RowClick="function(s,e)
                                                                        {
                                                                            loader.Show();
                                                                            setTimeout(function() {
                                                                                gltrans1.GetGridView().PerformCallback('VATCode'  + '|' + glVATCode.GetValue() + '|' + 'code');
                                                                                e.processOnServer = false;
                                                                                valchange = true;
                                                                            } ,500);
                                                                        }" 
                                                                        ValueChanged="autocalculate" /> 
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn FieldName="ExpDate" Name="dtpExpDate" ShowInCustomizationForm="True" VisibleIndex="18">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn FieldName="MfgDate" Name="dtpMfgDate" ShowInCustomizationForm="True" VisibleIndex="18">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BatchNo" Name="txtBatchNo" ShowInCustomizationForm="True" VisibleIndex="19">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LotNo" Name="txtLotNo" ShowInCustomizationForm="True" VisibleIndex="20">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" VisibleIndex="22">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" VisibleIndex="23">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" VisibleIndex="24">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" VisibleIndex="25">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" VisibleIndex="26">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" VisibleIndex="27">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="28">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="29">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" VisibleIndex="21">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ReturnedBulkQty" Name="glReturnBulkQty" ShowInCustomizationForm="True" VisibleIndex="17">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup runat="server" OnInit="lookup_Init" ClientInstanceName="gltrans1">
                                                                    <ClientSideEvents EndCallback="GridEnd" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
 

                                                            

                                                        <dx:GridViewDataTextColumn FieldName="ATCCode" Name="glAtcCode" ShowInCustomizationForm="True" VisibleIndex="20">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glAtcCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    DataSourceID="sdsATC" KeyFieldName="ATCCode" ClientInstanceName="glAtcCode" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad"  OnInit="glAtcCode_Init" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ATCCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains"/>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        RowClick="function(s,e)
                                                                        {
                                                                            loader.Show();
                                                                            setTimeout(function() {
                                                                                gltrans1.GetGridView().PerformCallback('ATCCode'  + '|' + glAtcCode.GetValue() + '|' + 'code');
                                                                                e.processOnServer = false;
                                                                                valchange1 = true;
                                                                            },500);
                                                                        }"  ValueChanged="autocalculate" />   
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataSpinEditColumn FieldName="VATRate" Name="Rate" ShowInCustomizationForm="True" VisibleIndex="21" Width="0">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="txtRate" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" AllowMouseWheel="false">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>

                                                        <dx:GridViewDataSpinEditColumn FieldName="ATCRate" Name="ATCRate" ShowInCustomizationForm="True" VisibleIndex="22"  Width="0">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="txtATCRate" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" AllowMouseWheel="false">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                    </Columns>
                                                    <TotalSummary>
                                                        <dx:ASPxSummaryItem FieldName="PicklistQty" SummaryType="Sum" ShowInColumn="PicklistQty" ShowInGroupFooterColumn="PicklistQty" />
                                                        <dx:ASPxSummaryItem FieldName="BulkQty" ShowInColumn="BulkQty" ShowInGroupFooterColumn="BulkQty" SummaryType="Sum" />
                                                    </TotalSummary>
                                                    <GroupSummary>
                                                        <dx:ASPxSummaryItem ShowInColumn="PicklistQty" SummaryType="Sum" />
                                                        <dx:ASPxSummaryItem ShowInColumn="BulkQty" SummaryType="Sum" />
                                                    </GroupSummary>
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager Mode="ShowAllRecords"/> 
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Visible" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" 
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <SettingsEditing Mode="Batch"/>
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
                                <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                                    UseSubmitBehavior="false" CausesValidation="true">
                                    <ClientSideEvents Click="OnUpdateClick" />
                                </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                   <%-- <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Calculating..." Modal="true"
                        ClientInstanceName="loader" ContainerElementID="gv1">
                        <LoadingDivStyle Opacity="0"></LoadingDivStyle>
                    </dx:ASPxLoadingPanel>--%>

                     <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server"  Text=""   Image-Url="..\images\loadinggear.gif" Image-Height="30px" Image-Width="30px" Height="30px" Width="30px" Enabled="true" ShowImage="true" BackColor="Transparent" Border-BorderStyle="None" 
            ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
        <LoadingDivStyle Opacity="0"></LoadingDivStyle>
   </dx:ASPxLoadingPanel>


                    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel2" runat="server" Text="Cloning..." ClientInstanceName="cloneloading" ContainerElementID="gv1" Modal="true" ImagePosition="Left">
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
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </form>
    <!--#region Region Datasource-->
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.ReceivingReport" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.ReceivingReport" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.ReceivingReport+ReceivingReportDetail" SelectMethod="getdetail" UpdateMethod="UpdateReceivingReportDetail" TypeName="Entity.ReceivingReport+ReceivingReportDetail" DeleteMethod="DeleteReceivingReportDetaill" InsertMethod="AddReceivingReportDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.ReceivingReport+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Procurement.ReceivingReportDetailPO where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item]"   OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [ColorCode], [ClassCode], [SizeCode] FROM Masterfile.[ItemDetail] WHERE ISNULL(IsInactive,0)=0"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSupplier" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT A.SupplierCode, 
        B.Name FROM Procurement.PurchaseOrder A INNER JOIN Masterfile.BPSupplierInfo B ON A.SupplierCode = B.SupplierCode 
        INNER JOIN Masterfile.BizPartner C on A.SupplierCode = C.BizPartnerCode
        WHERE ISNULL(SubmittedBy,'')!='' and ISNULL(B.IsInactive,0)=0 and ISNULL(C.IsInactive,0)=0 "   OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSupplier1" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT SupplierCode, Name FROM  Masterfile.BPSupplierInfo WHERE ISNULL(IsInactive,0)=0  "   OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, [Description] FROM Masterfile.[Warehouse] WHERE ISNULL([IsInactive],0) = 0" OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsPicklist" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="
        SELECT DISTINCT SupplierCode, A.DocNumber, IsAsset
          FROM Procurement.PurchaseOrder A 
               INNER JOIN Procurement.PurchaseOrderDetail B ON A.DocNumber = B.DocNumber 
               INNER JOIN MasterFile.Item ITM ON B.ItemCode = ITM.ItemCode
               INNER JOIN MasterFile.ItemCategory CAT ON ITM.ItemCategoryCode = CAT.ItemCategoryCode
         WHERE ISNULL(SubmittedBy,'') != '' AND Status IN ('N','P')
			   AND ISNULL(IsAsset,0) = @IsAsset
        "
        OnInit = "Connection_Init">
        <SelectParameters>
            <asp:Parameter Name="IsAsset" Type="Int16" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsPicklistDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="
        SELECT A.DocNumber, LineNumber, A.DocNumber AS PODocNumber, A.PRNumber,
               A.ItemCode,D.FullDesc, ColorCode, ClassCode, SizeCode,
               CASE WHEN ISNULL(OrderQty,0) - ISNULL(ReceivedQty,0) < 0 
                    THEN 0 ELSE ISNULL(OrderQty,0) - ISNULL(ReceivedQty,0) END AS POQty,
               CASE WHEN ISNULL(OrderQty,0) - ISNULL(ReceivedQty,0) < 0 
                    THEN 0 ELSE ISNULL(OrderQty,0) - ISNULL(ReceivedQty,0) END AS ReceivedQty, 
               ISNULL(Unit,'') AS Unit, ISNULL(UnitCost,0) AS UnitCost, 0.00 AS PesoAmount,
               ISNULL(BulkQty,0) AS BulkQty , 0.00 AS RoundingAmt, ISNULL(UnitFreight,0) AS UnitFreight,
               0.00 AS ReturnedQty, 0.00 AS ReturnedBulkQty, 
               '' AS Field1, '' AS Field2, '' AS Field3, '' AS Field4, '' AS Field5, 
               '' AS Field6, '' AS Field7, '' AS Field8, '' AS Field9, 
               ISNULL(IsVat,0) AS IsVat, ISNULL(VATCode,'') AS VATCode, Rate AS VATRate, C.ATCCode,
               ISNULL(A.ATCRate,0) AS ATCRate, NULL AS ExpDate, NULL AS MfgDate, '' AS BatchNo, '' AS LotNo
          FROM Procurement.PurchaseOrderDetail A 
               INNER JOIN Procurement.PurchaseOrder B ON A.DocNumber = B.DocNumber 
               INNER JOIN Masterfile.BPSupplierInfo C ON B.SupplierCode = C.SupplierCode 
               LEFT JOIN Masterfile.Item D ON A.ItemCode = D.ItemCode
               INNER JOIN Masterfile.ItemCategory E ON D.ItemCategoryCode = E.ItemCategoryCode
         WHERE ISNULL(SubmittedBy,'') != '' AND ISNULL(IsAsset,0) = 0
        "
        OnInit="Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsPicklistDetail1" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>"
        SelectCommand="SELECT A.DocNumber,A.PRNumber, LineNumber, A.DocNumber AS PODocNumber, 
               A.ItemCode,D.FullDesc, ColorCode, ClassCode, SizeCode,
               CASE WHEN ISNULL(OrderQty,0) - ISNULL(ReceivedQty,0) < 0 THEN 0 ELSE ISNULL(OrderQty,0) - ISNULL(ReceivedQty,0) END AS POQty, CASE WHEN ISNULL(OrderQty,0) - ISNULL(ReceivedQty,0) < 0 
                    THEN 0 ELSE ISNULL(OrderQty,0) - ISNULL(ReceivedQty,0) END AS ReceivedQty,
               ISNULL(Unit,'') AS Unit, ISNULL(UnitCost,0) AS UnitCost, 0.00 AS PesoAmount,
               ISNULL(BulkQty,0) AS BulkQty, 0.00 AS RoundingAmt, ISNULL(UnitFreight,0) AS UnitFreight,
               0.00 AS ReturnedQty, 0.00 AS ReturnedBulkQty, 
               '' AS Field1, '' AS Field2, '' AS Field3, '' AS Field4, '' AS Field5,
               '' AS Field6, '' AS Field7, '' AS Field8, '' AS Field9, 
               ISNULL(IsVat,0) AS  IsVat, ISNULL(VATCode,'') AS VATCode, Rate as VATRate, C.ATCCode,
               ISNULL(A.ATCRate,0) AS ATCRate, NULL AS ExpDate, NULL AS MfgDate, '' AS BatchNo, '' AS LotNo
          FROM Procurement.PurchaseOrderDetail A 
               INNER JOIN Procurement.PurchaseOrder B ON A.DocNumber = B.DocNumber 
               INNER JOIN Masterfile.BPSupplierInfo C ON B.SupplierCode = C.SupplierCode 
               LEFT JOIN Masterfile.Item D ON A.ItemCode = D.ItemCode
               LEFT JOIN Masterfile.ItemCategory E ON D.ItemCategoryCode = E.ItemCategoryCode
         WHERE ISNULL(SubmittedBy,'') != '' AND ISNULL(IsAsset,0) = 1
        "
        OnInit="Connection_Init">
    </asp:SqlDataSource>
       <asp:SqlDataSource ID="sdsATC" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ATCCode,Description,Rate From Masterfile.ATC where ISNULL(IsInactive,0)=0 "   OnInit = "Connection_Init">
    </asp:SqlDataSource>

      <asp:SqlDataSource ID="VatCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TCode,Description,Rate FROM Masterfile.Tax WHERE ISNULL(IsInactive,0) = 0 and TCode!='NONV'"
        OnInit="Connection_Init">
    </asp:SqlDataSource>
        <asp:SqlDataSource ID="Unitlookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select DISTINCT UnitCode AS Unit, Description from masterfile.Unit where ISNULL(IsInactive, 0)=0"
        OnInit="Connection_Init">
    </asp:SqlDataSource>

     <asp:SqlDataSource ID="sdsCostingDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
         SelectCommand="
         SELECT A.DocNumber,PRNumber ,LineNumber, B.PODocNumber, ItemCode, ColorCode, ClassCode, SizeCode,
                POQty, ReceivedQty,  Unit, UnitCost, PesoAmount, BulkQty, RoundingAmt, UnitFreight, ReturnedQty, ReturnedBulkQty,
                B.Field1, B.Field2, B.Field3, B.Field4,B.Field5, B.Field6, B.Field7, B.Field8, B.Field9,
                IsVat , VATCode, VATRate, ATCCode, ATCRate, ExpDate, MfgDate, BatchNo, LotNo 
           FROM Procurement.ReceivingReport A 
                INNER JOIN Procurement.ReceivingReportDetailPO B ON A.DocNumber = B.DocNumber 
         "
         OnInit="Connection_Init">
    </asp:SqlDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.ReceivingReport+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="Currencylookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select Currency,CurrencyName from masterfile.Currency where ISNULL(IsInactive,0)!=1"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


