<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDeliveryReceipt.aspx.cs" Inherits="GWL.frmDeliveryReceipt" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Delivery Receipt</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/keyboardNavi.js" type="text/javascript"></script>
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
                console.log(s);
                console.log(e);
            }
            else {
                isValid = true;
            }

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
            gvJournal.SetWidth(width - 100);

        }

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            var btnmode = btn.GetText(); //gets text of button
            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }

            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            var cntdetails = indicies.length;

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

            if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
                //Sends request to server side
                if (btnmode == "Add") {
                    if (cntdetails == 0) {
                        cp.PerformCallback("AddZeroDetail");
                    }
                    else {
                        cp.PerformCallback("Add");
                    }
                }
                else if (btnmode == "Update") {
                    if (cntdetails == 0) {
                        console.log("update to")
                        cp.PerformCallback("UpdateZeroDetail");
                    }
                    else {
                        cp.PerformCallback("Update");
                    }
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

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        var vatrate = 0;
        var vatdetail1 = 0;

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);
                if (s.cp_forceclose) {//NEWADD
                    delete (s.cp_forceclose);
                    window.close();
                }
                gv1.CancelEdit();

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

            if (s.cp_counterror) {
                delete (s.cp_counterror);
                counterror = 0;
            }

            if (s.cp_generated) {
                delete (s.cp_generated);
                autocalculate();
                autocalculate1();
            }

            if (s.cp_unitcost) {
                delete (s.cp_unitcost);
            }

            if (s.cp_vatrate != null) {

                vatrate = s.cp_vatrate;
                delete (s.cp_vatrate);
                vatdetail1 = 1 + parseFloat(vatrate);
            }

            if (s.cp_reference != null) {
                ReferenceCheck();
                delete (s.cp_reference);
            }

            if (s.cp_test != null) {
                autocalculate();
                delete (s.cp_test);
            }
        }

        var index;
        var closing;
        var itemc; //variable required for lookup
        var valchange = false;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var evn;
        var editorobj;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            editorobj = e;

            var entry = getParameterByName('entry');
            evn = e;

            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }

            if (chkRefSO.GetChecked()) {
                console.log("checked");
            }
            else {
                console.log("unchecked");
                if (e.focusedColumn.fieldName !== "DeliveredQty" && e.focusedColumn.fieldName !== "BulkQty"
                    && e.focusedColumn.fieldName !== "Field1" && e.focusedColumn.fieldName !== "Field2" && e.focusedColumn.fieldName !== "Field3"
                    && e.focusedColumn.fieldName !== "Field4" && e.focusedColumn.fieldName !== "Field5" && e.focusedColumn.fieldName !== "Field6"
                    && e.focusedColumn.fieldName !== "Field7" && e.focusedColumn.fieldName !== "Field8" && e.focusedColumn.fieldName !== "Field9"
                    && e.focusedColumn.fieldName !== "ExpDate" && e.focusedColumn.fieldName !== "MfgDate" && e.focusedColumn.fieldName !== "BatchNo"
                    && e.focusedColumn.fieldName !== "LotNo") {
                    e.cancel = true;
                }
            }


            console.log(e.focusedColumn.fieldName);

            if (e.focusedColumn.fieldName == "FullDesc")
            {
                e.cancel = true;
            }
            if (aglType.GetText() == "SALES ORDER" && e.focusedColumn.fieldName == "TransPONo") {
                e.cancel = true;
            }


            if (entry != "V") {
                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
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
                    gl6.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "IsByBulk") {
                    glIsByBulk.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "StatusCode") {
                    glpStatusCode.GetInputElement().value = cellInfo.value;
                }

                
            }

            keybGrid = s;
            keyboardOnStart(e);
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];

            var entry = getParameterByName('entry');

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
                cellInfo.value = gl5.GetValue();
                cellInfo.text = gl5.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "BulkUnit") {
                cellInfo.value = gl6.GetValue();
                cellInfo.text = gl6.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "IsByBulk") {
                cellInfo.value = glIsByBulk.GetValue();
            }
            if (currentColumn.fieldName === "StatusCode") {
                cellInfo.value = glIsByBulk.GetValue();
            }


            if (valchange) {

                valchange = false;
                closing = false;
                for (var i = 0; i < s.GetColumnsCount() ; i++) {
                    var column = s.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, e, column, s);
                }
            }
            keyboardOnEnd();
        }

 

        var val;
        var temp;
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
            if (temp[7] == null) {
                temp[7] = "";
            }
            if (temp[8] == null) {
                temp[8] = "";
            }

            if (selectedIndex == 0) {
                if (column.fieldName == "ColorCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
                }
                if (column.fieldName == "ClassCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
                }
                if (column.fieldName == "SizeCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
                }
                if (column.fieldName == "Unit") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
                }
                if (column.fieldName == "BulkUnit") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
                }
                if (column.fieldName == "FullDesc") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
                }
                if (column.fieldName == "IsByBulk") {
                    if (temp[6] == "True") {
                        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsByBulk.SetChecked = true);
                    }
                    else {
                        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsByBulk.SetChecked = false);
                    }
                }
                if (column.fieldName == "StatusCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[7]);
                }
                if (column.fieldName == "Version") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[8]);
                }
            }

        }


        function GridEnd(s, e) {
            val = s.GetGridView().cp_codes;
            temp = val.split(';');

            if (s.GetGridView().cp_valch) {
                delete (s.GetGridView().cp_valch);
                //valchange = false;
                //closing = false;
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, editorobj, column, gv1);
                }
                gv1.batchEditApi.EndEdit();
                gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField("ColorCode").index);
            }
             

        }



        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                var chckd;
                var chckd2;

                if (column.fieldName == "DeliveredQty") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == null) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
                if (column.fieldName == "IsByBulk") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    console.log("validate " + value)
                    if (value == true) {
                        chckd2 = true;
                    }
                }
                if (column.fieldName == "BulkQty") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == null)&& chckd2 == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
                if (column.fieldName == "BulkUnit") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == null) && chckd2 == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
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
            if (keyCode !== ASPx.Key.Tab) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (gv1.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }

        }

        function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column

            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == ASPx.Key.Enter) {
                gv1.batchEditApi.EndEdit();
            }

        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.

            gv1.batchEditApi.EndEdit();

        }

        function Try(s, e)
        {
            if (e.command == DELETEROW) {
                console.log("DELETE BUTTON INE")
            }
        }


        var clonenumber = 0;
        var cloneindex;
        function OnCustomClick(s, e)
        {
            if (e.buttonID == "Details")
            {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                var Warehouse = prnum.GetText();
                var BizPartnerCode = clBizPartnerCode.GetText();
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&unit=' + unitbase + '&Warehouse=' + Warehouse);

                factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);

                
            }
            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate(s,e);
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
                var expdate = s.batchEditApi.GetCellValue(e.visibleIndex, "ExpDate");
                var mfgdate = s.batchEditApi.GetCellValue(e.visibleIndex, "MfgDate");
                var batchno = s.batchEditApi.GetCellValue(e.visibleIndex, "BatchNo");
                var lotno = s.batchEditApi.GetCellValue(e.visibleIndex, "LotNo");
                var bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "BulkQty");
                console.log(itemcode);
                var entry = getParameterByName('entry');
                var Warehouse = prnum.GetText();
                CSheet.SetContentUrl('../WMS/frmTRRSetup.aspx?entry=' + entry + '&docnumber=' + docnumber
                    + '&transtype=' + transtype
                    + '&linenumber=' + linenum
                    + '&refdocnum=' + refdocnum
                    + '&itemcode=' + encodeURIComponent(itemcode)
                    + '&colorcode=' + encodeURIComponent(colorcode)
                    + '&classcode=' + encodeURIComponent(classcode)
                    + '&sizecode=' + encodeURIComponent(sizecode)
                    + '&warehouse=' + encodeURIComponent(Warehouse)
                    + '&expdate=' + encodeURIComponent(convertDate(expdate))
                    + '&mfgdate=' + encodeURIComponent(convertDate(mfgdate))
                    + '&batchno=' + encodeURIComponent(batchno)
                    + '&lotno=' + encodeURIComponent(lotno)
                    + '&bulkqty=' + bulkqty);
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

        function convertDate(str) {
            var date = new Date(str),
                mnth = ("0" + (date.getMonth() + 1)).slice(-2),
                day = ("0" + date.getDate()).slice(-2);
            return [date.getFullYear(), mnth, day].join("-");
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


        function endcp(s, e) {
            var endg = s.GetGridView().cp_endgl1;
            if (endg == true) {
                console.log(endg);
                e.processOnServer = false;
                endg = null;
            }
        }

        function RefSO(s, e) {
                cp.PerformCallback('CallbackRefSO');
        }

        function checkedchanged(s, e) {
            var checkState = cbiswithdr.GetChecked();
            if (checkState == true) {
                cp.PerformCallback('iswithquotetrue');
                e.processOnServer = false;
            }
            else {
                cp.PerformCallback('iswithquotefalse');
                e.processOnServer = false;
            }

        }

        function ReferenceCheck(s, e) {

            if (chkRefSO.GetChecked(true))
            {
                aglType.SetText("SALES SLIP");
            }
            else
            {
                aglType.SetText("SALES ORDER");
            }
            gv1.CancelEdit();
        }

        function TypeChange(s, e) {
            
            if (aglType.GetText() == "SALES SLIP")
            {
                chkRefSO.SetChecked(true);
                speTotalBulkQty.SetText("0");
            }
            else
            {
                chkRefSO.SetChecked(false);
                speTotalBulkQty.SetText("0");
            }

            cp.PerformCallback('CallbackCheck');

        }

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
                num = this.toFixed(Math.max(0, ~~d));

            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };

        function autocalculate(s, e) {

         //   OnInitTrans();

            var unitfrieght = 0.00;
            var receivedqty = 0.0000;
            var unitcost = 0.00;
            var receivedqty1 = 0.0000;
            var unitcost1 = 0.00;
            var receivedqty2 = 0.0000;
            var unitcost2 = 0.00;
            var exchangerate = 0.00;
            var freight = 0.00;
            var totalqty = 0.0000
            var discountrate = 0.00;
            var totalfreight = 0.00;
            var TotalQuantity = 0.0000;
            var PesoAmount = 0.00;
            var TotalAmount1 = 0.00;
            var NonVatAmount = 0.00;
            var ForeignAmount = 0.00;
            var frieght = 0.00;
            var vatable = 0.00;
            var VATAmount = 0.00;

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                var temp1 = indicies.length;
                var temp2 = indicies.length;
                var temp3 = indicies.length;
                var arrunit = [];
                var arrqty = [];
                var arrSO = [];
                var arrTrans = [];
                var cntr = 0;
                var cntr1 = 0;
                var cntr2 = 0;
                var holder = 0;
                var holder1 = 0;
                var holder2 = 0;
                var txt1 = "";
                var txt2 = "";
                var txt3 = "";

                //FOR Total Quantity
                for (var b = 0; b <= temp1; b++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[b])) {
                        for (var a = 0; a <= temp1; a++)
                        {
                            if (gv1.batchEditApi.GetCellValue(indicies[b], "Unit") == arrunit[a]) {
                                var ter = gv1.batchEditApi.GetCellValue(indicies[b], "DeliveredQty");
                                arrqty[a] += +ter; //adds qty with same unit
                                cntr++; //increment if found an existing unit
                            }
                        }
                        if (cntr == 0) {
                            holder++;
                            arrunit[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "Unit"); //add new unit
                            arrqty[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "DeliveredQty"); //along with qty
                        }
                        else cntr = 0;
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[b]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[b]);
                        else {
                            for (var a = 0; a <= temp1; a++) {
                                if (gv1.batchEditApi.GetCellValue(indicies[b], "Unit") == arrunit[a]) {
                                    var ter = gv1.batchEditApi.GetCellValue(indicies[b], "DeliveredQty");
                                    arrqty[a] += +ter; //adds qty with same unit
                                    cntr++; //increment if found an existing unit
                                }
                            }
                            if (cntr == 0) {
                                holder++;
                                arrunit[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "Unit"); //add new unit
                                arrqty[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "DeliveredQty"); //along with qty
                            }
                            else cntr = 0;
                        }
                    }
                }

                for (var c = 0; c <= holder; c++) {
                    if (c == 0 && isNaN(arrqty[0]) == true && c == null)
                        console.log('skip');
                    else {
                        if (arrunit[c] != 0 && arrunit[c] != null)
                        { txt1 += "(" + arrunit[c] + "|" + arrqty[c].format(4, 5, ',', '.') + ") "; }
                    }
                }
                //END Total Quantity

                //FOR SONumber
                for (var x = 0; x <= temp2; x++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[x])) {
                        for (var y = 0; y <= temp2; y++) {
                            if (gv1.batchEditApi.GetCellValue(indicies[x], "SONumber") == arrSO[y]) {
                                cntr1++;
                            }
                        }
                        if (cntr1 == 0) {
                            holder1++;
                            arrSO[holder1] = gv1.batchEditApi.GetCellValue(indicies[x], "SONumber");
                        }
                        else cntr1 = 0;
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[x]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[x]);
                        else {
                            for (var y = 0; y <= temp2; y++) {
                                if (gv1.batchEditApi.GetCellValue(indicies[x], "SONumber") == arrSO[y]) {
                                }
                            }
                            if (cntr1 == 0) {
                                holder1++;
                                arrSO[holder1] = gv1.batchEditApi.GetCellValue(indicies[x], "SONumber");
                            }
                            else cntr1 = 0;
                        }
                    }
                }

                for (var z = 0; z <= holder1; z++) {
                    if (z == 0 && z == null)
                        console.log('skip');
                    else {
                        if (arrSO[z] != 0 && arrSO[z] != null)
                        { txt2 += arrSO[z] + ";"; }
                    }
                }
                
                var str = txt2;
                str = str.slice(0, -1);
                //END SONumber

                ////FOR TransPONo
                //for (var r = 0; r <= temp3; r++) {
                //    if (gv1.batchEditApi.IsNewRow(indicies[r])) {
                //        for (var e = 0; e <= temp3; e++) {
                //            if (gv1.batchEditApi.GetCellValue(indicies[r], "TransPONo") == arrTrans[e]) {
                //                cntr2++;
                //            }
                //        }
                //        if (cntr2 == 0) {
                //            holder2++;
                //            arrTrans[holder2] = gv1.batchEditApi.GetCellValue(indicies[r], "TransPONo");
                //        }
                //        else cntr2 = 0;
                //    }
                //    else {
                //        var key = gv1.GetRowKey(indicies[r]);
                //        if (gv1.batchEditApi.IsDeletedRow(key))
                //            console.log("deleted row " + indicies[r]);
                //        else {
                //            for (var e = 0; e <= temp3; e++) {
                //                if (gv1.batchEditApi.GetCellValue(indicies[r], "TransPONo") == arrTrans[e]) {
                //                    cntr2++;
                //                }
                //            }
                //            if (cntr2 == 0) {
                //                holder2++;
                //                arrTrans[holder2] = gv1.batchEditApi.GetCellValue(indicies[r], "TransPONo");
                //            }
                //            else cntr2 = 0;
                //        }
                //    }
                //}

                //for (var v = 0; v <= holder2; v++) {
                //    if (v == 0 && v == null)
                //        console.log('skip');
                //    else {
                //        if (arrTrans[v] != 0 && arrTrans[v] != null)
                //        { txt3 += arrTrans[v] + ";"; }
                //    }
                //}

                //var str2 = txt3;
                //str2 = str2.slice(0, -1);
                ////END TransPONo

                txtTotalQty.SetText(txt1);

                if (chkRefSO.GetChecked(true)) {
                    aglRefSO.SetText("");
                }
                else {
                    aglRefSO.SetText(str);
                }
                //txtCustomerPONo.SetText(str2);
            }, 500);
        }

        //function simulateCustomerPO(s, e) {

        //    OnInitTrans();

        //    setTimeout(function () {
        //        var indicies = gv1.batchEditApi.GetRowVisibleIndices();

        //        var rowcnt = indicies.length;
        //        var arrTrans = [];
        //        var counter = 0;
        //        var getval = 0;
        //        var result = "";

        //        //FOR TransPONo
        //        for (var r = 0; r <= rowcnt; r++) {
        //            if (gv1.batchEditApi.IsNewRow(indicies[r])) {
        //                for (var e = 0; e <= rowcnt; e++) {
        //                    if (gv1.batchEditApi.GetCellValue(indicies[r], "TransPONo") == arrTrans[e]) {
        //                        counter++;
        //                    }
        //                }
        //                if (counter == 0) {
        //                    getval++;
        //                    arrTrans[getval] = gv1.batchEditApi.GetCellValue(indicies[r], "TransPONo");
        //                }
        //                else counter = 0;
        //            }
        //            else {
        //                var key = gv1.GetRowKey(indicies[r]);
        //                if (gv1.batchEditApi.IsDeletedRow(key))
        //                    console.log("deleted row " + indicies[r]);
        //                else {
        //                    for (var e = 0; e <= rowcnt; e++) {
        //                        if (gv1.batchEditApi.GetCellValue(indicies[r], "TransPONo") == arrTrans[e]) {
        //                            counter++;
        //                        }
        //                    }
        //                    if (counter == 0) {
        //                        getval++;
        //                        arrTrans[getval] = gv1.batchEditApi.GetCellValue(indicies[r], "TransPONo");
        //                    }
        //                    else counter = 0;
        //                }
        //            }
        //        }

        //        for (var v = 0; v <= getval; v++) {
        //            if (v == 0 && v == null)
        //                console.log('skip');
        //            else {
        //                if (arrTrans[v] != 0 && arrTrans[v] != null)
        //                { result += arrTrans[v] + ";"; }
        //            }
        //        }

        //        var str = result;
        //        str = str.slice(0, -1);
        //        //END TransPONo

        //        txtOnDetail.SetText(str);

        //        CopyText();                

        //        txtCustomerPONo.replace(str, '');



        //    }, 500);
        //}


        //function CopyText(s, e) {
        //    //simulateCustomerPO();

        //    //txtUserInput.SetText(txtOnDetail.GetText());
        //    txtUserInput.SetText(';' + txtCustomerPONo.GetText());

        //    txtPool.SetText(txtOnDetail.GetText() + txtUserInput.GetText())
        //}

        //function SetCustomerPO(s, e) {
        //    txtCustomerPONo.SetText(txtPool.GetText());
        //}
        function autocalculate1(s, e) {
            //console.log(txtNewUnitCost.GetValue());

            var TotalBulkQty = 0.00;

            var totalbulkqty = 0.00
            var bulkqty = 0.00;


            setTimeout(function () { //New Rows
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        bulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "BulkQty");

                        TotalBulkQty += bulkqty;



                        //console.log(gv1.batchEditApi.GetCellValue(indicies[i], "IsVat"));

                    }




                    else { //Existing Rows
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {

                            bulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "BulkQty");


                            TotalBulkQty += bulkqty;

                        }
                    }


                    speTotalBulkQty.SetText(TotalBulkQty.toFixed(2));

                }






            }, 500);
        }
        function detailautocalculate(s, e) {

            var freight = 0.00;
            var totalqty = 0.00

            var totalfreight = 0.00;

            if (txtTotalFreight.GetText() == null || txtTotalFreight.GetText() == "") {
                freight = 0;
            }
            else {
                freight = txtTotalFreight.GetText();
            }
            
            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var a = 0; a < indicies.length; a++) {
                    receivedqty = gv1.batchEditApi.GetCellValue(indicies[a], "OrderQty");

                    totalqty += receivedqty;
                }

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        gv1.batchEditApi.SetCellValue(indicies[i], "UnitFreight", (freight / totalqty).toFixed(2));
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            gv1.batchEditApi.SetCellValue(indicies[i], "UnitFreight", (freight / totalqty).toFixed(2));                      
                        }
                    }
                }

            }, 500);

    
        }

        var transtype = getParameterByName('transtype');
        function onload() {
            fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + txtDocnumber1.GetText() + '&transtype=' + transtype);
        }

    </script>
    <!--#endregion-->
</head>
<body style="height: 910px;">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
<form id="form1" runat="server" class="Entry">
    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Delivery Receipt" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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


    <dx:ASPxPopupControl ID="popup2" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox2" CloseAction="None" 
        EnableViewState="False" HeaderText="BizPartner info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="260"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

         <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
            EnableViewState="False" HeaderText="Notes" Height="370px" Width="297px" PopupHorizontalOffset="1060" PopupVerticalOffset="200"
            ShowCloseButton="False" Collapsed="true" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" />
            </ContentCollection>
        </dx:ASPxPopupControl>

    <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents CloseUp="function (s, e) { cp.PerformCallback('RefGrid') }" />
    </dx:ASPxPopupControl>
        <%--<dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">--%>
           
      <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback" SettingsLoadingPanel-Enabled="true" SettingsLoadingPanel-Delay="3000" Images-LoadingPanel-Url="..\images\loadinggear.gif" Images-LoadingPanel-Height="30px" Styles-LoadingPanel-BackColor="Transparent" Styles-LoadingPanel-Border-BorderStyle="None" SettingsLoadingPanel-Text="" SettingsLoadingPanel-ShowImage="true" >
<ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Document Number">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" OnLoad="TextboxLoad" Width="170px" AutoCompleteType="Disabled" Enabled="False" ReadOnly ="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnInit="dtpDocDate_Init" Width="170px" OnLoad="Date_Load">
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
                                                    <dx:LayoutItem Caption="Type" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglType" runat="server" DataSourceID="sdsType" Width="170px" KeyFieldName="Code" 
                                                                    OnLoad="LookupLoad" TextFormatString="{1}" ClientInstanceName ="aglType" >
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged ="TypeChange" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Picklist Number">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtPLNumber" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Customer Code">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglCustomerCode" runat="server"  ClientInstanceName="clBizPartnerCode"  DataSourceID="sdsBizPartnerCus" Width="170px" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}"
                                                                    GridViewProperties-SettingsLoadingPanel-Text="" GridViewImages-LoadingPanel-Url="..\images\loadinggear.gif"  GridViewImages-LoadingPanel-Height="30px" GridViewStyles-LoadingPanel-BackColor="Transparent" GridViewProperties-SettingsLoadingPanel-ShowImage="true" GridViewProperties-SettingsLoadingPanel-Delay="3000" GridViewStyles-LoadingPanel-Border-BorderColor="Transparent" 
                                                                      >
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){console.log('changed'); setTimeout(function(){cp.PerformCallback('CallbackCustomer');},0);}" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Invoice Number">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtInvoiceNo" runat="server" Width="170px" ReadOnly ="True">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Warehouse Code" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglWarehouseCode" runat="server" ClientInstanceName="prnum" Width="170px" DataSourceID="sdsWarehouse" KeyFieldName="WarehouseCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Counter Number">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtCounterNo" runat="server" Width="170px" ReadOnly ="True">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Delivery Address">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTextBox ID="txtAddress" runat="server" Width="170px" OnLoad="TextboxLoad" >
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Outlet">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtOutlet" runat="server" Width="170px" OnLoad="TextboxLoad" ClientInstanceName="txtOutlet">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="TIN">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtTIN" runat="server" ReadOnly="True" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Terms">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPXSpinEdit ID="speTerms" runat="server" Width="170px" OnLoad="SpinEdit_Load" NullText ="0.00"  MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="0"  >
                                                                </dx:ASPXSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Quantity">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memTotalQty" runat="server" ClientInstanceName="txtTotalQty" Height="80px" ReadOnly="True" Width="170px">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" OnLoad="MemoLoad" Width="170px">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Bulk Qty">
                                                    <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speTotalBulkQty" runat="server" ClientInstanceName="speTotalBulkQty" ReadOnly="True" Width="170px" NullText="0" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="0" DisplayFormatString="{0:N}" >
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                                 </dx:LayoutItem>
                                                    
                                                <dx:LayoutItem Caption="Clone">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxSpinEdit ID="SpinClone" runat="server" Increment="0" NullText="0"  MaxValue="9999999999" MinValue="0" Width="170px" ClientInstanceName="CINClone" SpinButtons-ShowIncrementButtons="false"> 
                                                            </dx:ASPxSpinEdit>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Without Ref. SO" ClientVisible="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkRefSO" runat="server" CheckState="Unchecked" ClientInstanceName="chkRefSO" OnLoad="CheckBoxLoad" ClientVisible="false">
                                                                    <ClientSideEvents CheckedChanged="function(s,e){cp.PerformCallback('CallbackCheck');}" />
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%--<dx:LayoutItem Caption="Customer PO">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtCustomerPONo" runat="server" ClientInstanceName="txtCustomerPONo" OnLoad="TextboxLoad" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Reference Sales Order" AlignItemCaptions="False" >
                                                <Items>
                                                    <dx:LayoutItem Caption="Reference SO">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglRefSO" runat="server" DataSourceID="sdsRefSO" KeyFieldName="DocNumber" OnLoad="LookupLoad" SelectionMode="Multiple" 
                                                                    GridViewProperties-SettingsLoadingPanel-Text="" GridViewImages-LoadingPanel-Url="..\images\loadinggear.gif"  GridViewImages-LoadingPanel-Height="30px" GridViewStyles-LoadingPanel-BackColor="Transparent" GridViewProperties-SettingsLoadingPanel-ShowImage="true" GridViewProperties-SettingsLoadingPanel-Delay="3000" GridViewStyles-LoadingPanel-Border-BorderColor="Transparent" 
                                                                      AutoGenerateColumns="False" TextFormatString="{0}" ClientInstanceName ="aglRefSO" Width="420px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn Caption="DocDate" FieldName="DocDate" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly ="true">
                                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                            <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CustomerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CustomerPONo" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Currency" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Quantity" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Remarks" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Terms" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn Caption="TargetDeliveryDate" FieldName="TargetDeliveryDate" ShowInCustomizationForm="True" VisibleIndex="8" ReadOnly ="true">
                                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                            <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <%--<dx:GridViewDataTextColumn FieldName="TargetDeliveryDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>--%>
                                                                    </Columns>                                                                 
                                                                    <ClientSideEvents Validation="OnValidation"/>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="" HorizontalAlign="Left" ColSpan ="1" ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxButton ID="btnGenDetail" runat="server" Text="Generate" OnLoad ="ButtonLoad" Width="50px" AutoPostBack ="false">                                                           
                                                                    <ClientSideEvents Click="RefSO" />      
                                                                </dx:ASPxButton>
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
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad" >
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
                                    <dx:LayoutGroup Caption="Journal Entries" Name="JournalEntry"> 
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvJournal" runat="server" AutoGenerateColumns="False" Width="850px" ClientInstanceName="gvJournal" >
                                                            <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
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
                                                        <dx:ASPxTextBox ID="txtHPostedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Posted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHPostedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Forwarded Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtForwardedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Dispatch Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDispatchDate" runat="server" Width="170px" ReadOnly="True">
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
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                        <SettingsPager PageSize="5">
                                                        </SettingsPager>
                                                        <SettingsEditing Mode="Batch">
                                                        </SettingsEditing>
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
                                                            <dx:GridViewDataTextColumn FieldName="RTransType" Caption="Reference TransType" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly="True"  Name="RTransType">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="REFDocNumber" Caption="Reference DocNumber" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="True" >
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4" ReadOnly="True">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Caption="DocNumber"  ReadOnly="True">
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
                            <dx:LayoutGroup Caption="Delivery Receipt Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False"  Width="770px"
                                                    ClientInstanceName="gv1" OnBatchUpdate="gv1_BatchUpdate" OnCellEditorInitialize="gv1_CellEditorInitialize"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    OnInit="gv1_Init" OnRowValidating="grid_RowValidating" KeyFieldName="LineNumber" OnRowDeleting="gv1_RowDeleting">
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" 
                                                        BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" BatchEditRowValidating="Grid_BatchEditRowValidating"/>
                                                    <SettingsPager Mode="ShowAllRecords"/>  
                                                    <SettingsEditing Mode="Batch"/>
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" VisibleIndex="0" Width="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="90px">
                                                            <CustomButtons>
                                                            <dx:GridViewCommandColumnCustomButton ID="Details" >
                                                                <Image IconID="support_info_16x16" ToolTip="Details"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="CountSheet">
                                                                   <Image IconID="arrange_withtextwrapping_topleft_16x16" ToolTip="Countsheet"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete" >
                                                                <Image IconID="actions_cancel_16x16" ToolTip="Delete"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="CloneButton" Text="Copy">
                                                                    <Image IconID="edit_copy_16x16" ToolTip="Clone"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="80px" ReadOnly="true">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SONumber" VisibleIndex="3" Name="glpSONumber" Caption="SO Number" Width="120px">                                                            
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransPONo" Name="glpTransPONo" ShowInCustomizationForm="True" VisibleIndex="4" Caption="Customer PO No." UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="5" Width="80px" Name="glpItemCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="80px"
                                                                    GridViewProperties-SettingsLoadingPanel-Text="" GridViewImages-LoadingPanel-Url="..\images\loadinggear.gif"  GridViewImages-LoadingPanel-Height="30px" GridViewStyles-LoadingPanel-BackColor="Transparent" GridViewProperties-SettingsLoadingPanel-ShowImage="true" GridViewProperties-SettingsLoadingPanel-Delay="3000" GridViewStyles-LoadingPanel-Border-BorderColor="Transparent" 
                                                                      OnInit="glItemCode_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd" DropDown="lookup" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                        <%--ValueChanged="function(s,e){
                                                                     if(gl.GetValue()!=itemc){
                                                                        console.log('valch');
                                                                            closing = true;
                                                                            //gl.GetGridView().PerformCallback('ItemCode' + '|' + gl.GetValue() + '|' + 'code');                                                                            
                                                                            //e.processOnServer = false;
                                                                            //e.processOnServer = false;
                                                                            valchange = true;
                                                                            closing = true;
                                                                        }	               
                                                                  }" />--%>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn ReadOnly="true" FieldName="FullDesc" Name="FullDesc" VisibleIndex="6" Width="120px" Caption="ItemDesc">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" Name="ColorCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" KeyFieldName="ColorCode" OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp" DropDown="function dropdown(s, e){
                                                                gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ShowInCustomizationForm="True" VisibleIndex="8" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl3" KeyFieldName="ClassCode" OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="function dropdown(s, e){
                                                                gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Name="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl4" KeyFieldName="SizeCode" OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp" DropDown="function dropdown(s, e){
                                                                gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn><dx:GridViewDataSpinEditColumn FieldName="DeliveredQty" Name="glpDeliveredQty" PropertiesSpinEdit-LargeIncrement="0" ShowInCustomizationForm="True" VisibleIndex="10" Caption="Delivered Qty" UnboundType="Decimal" >
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue="9999999999"> 
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit" ShowInCustomizationForm="True" VisibleIndex="11" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl5" DataSourceID="sdsUnit" KeyFieldName="Unit"  OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Unit" ReadOnly="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp" DropDown="function dropdown(s, e){
                                                                gl5.GetGridView().PerformCallback('Unit' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                e.processOnServer = false;
                                                                }" EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsByBulk" Name="glpIsByBulk" ShowInCustomizationForm="True" VisibleIndex="12" Caption="IsByBulk" Width ="55px">
                                                            <PropertiesCheckEdit ClientInstanceName="glIsByBulk" >
                                                            </PropertiesCheckEdit>              
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="BulkQty" Name="glpBulkQty" ShowInCustomizationForm="True" PropertiesSpinEdit-LargeIncrement="0" UnboundType="Decimal" VisibleIndex="13" Caption="Bulk Qty" Width="80px">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue="9999999999">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate1" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BulkUnit" ShowInCustomizationForm="True" Width="80px" Caption="Bulk Unit" VisibleIndex="14" Name="glpBulkUnit">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glBulkUnit" runat="server" AutoGenerateColumns="False" AutoPostBack="false"  ClientInstanceName="gl6" DataSourceID="sdsBulkUnit" KeyFieldName="BulkUnit" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BulkUnit" ReadOnly="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp" DropDown="function dropdown(s, e){
                                                                gl6.GetGridView().PerformCallback('BulkUnit' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                e.processOnServer = false;
                                                                }" EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>                                                          
                                                         <dx:GridViewDataTextColumn FieldName="StatusCode" Name="glpStatusCode" ShowInCustomizationForm="True" VisibleIndex="15" ReadOnly="True">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubstituteItem" Name="glpSubstituteItem" ShowInCustomizationForm="True" VisibleIndex="16" ReadOnly ="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubstituteColor" Name="glpSubstituteColor" ShowInCustomizationForm="True" VisibleIndex="17" ReadOnly ="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubstituteClass" Name="glpSubstituteClass" ShowInCustomizationForm="True" VisibleIndex="18" ReadOnly ="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="ReturnedQty" Name="glpReturnedQty" ShowInCustomizationForm="True" PropertiesSpinEdit-LargeIncrement="0" VisibleIndex="19" Caption="Returned Qty" ReadOnly="True">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false" MinValue ="0" MaxValue="9999999999">
                                                            <SpinButtons ShowIncrementButtons="False" Enabled="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="BaseQty" Name="glpBaseQty" ShowInCustomizationForm="True" PropertiesSpinEdit-LargeIncrement="0" VisibleIndex="20" ReadOnly="True">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue="9999999999">
                                                                <SpinButtons ShowIncrementButtons="False" Enabled="False"></SpinButtons>
                                                                </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BarcodeNo" Name="glpBarcodeNo" ShowInCustomizationForm="True" VisibleIndex="21" ReadOnly="True">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitFactor" Name="glpUnitFactor" ShowInCustomizationForm="True" VisibleIndex="22" Caption="Unit Factor" ReadOnly ="true">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false" MinValue ="0" MaxValue="9999999999">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn> 
                                                        <dx:GridViewDataDateColumn FieldName="ExpDate" Name="dtpExpDate" ShowInCustomizationForm="True" VisibleIndex="22" ReadOnly="false" UnboundType="DateTime">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn FieldName="MfgDate" Name="dtpMfgDate" ShowInCustomizationForm="True" VisibleIndex="23" ReadOnly="false" UnboundType="DateTime">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BatchNo" Name="txtBatchNo" ShowInCustomizationForm="True" VisibleIndex="24" ReadOnly="false">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LotNo" Name="txtLotNo" ShowInCustomizationForm="True" VisibleIndex="25" ReadOnly="false">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" VisibleIndex="26" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" VisibleIndex="27" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" VisibleIndex="29" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" VisibleIndex="30" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" VisibleIndex="32" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="33" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="34" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Version" Name="glpVersion" Caption="Version" ShowInCustomizationForm="True" VisibleIndex="35" Width="0px" >
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
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
                         <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" AutoPostBack="False" UseSubmitBehavior="false">
                             <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                             </dx:ASPxButton>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel">
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
<form id="form2" runat="server" visible="false" >
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Sales.DeliveryReceiptDetail WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] WHERE ISNULL(IsInActive,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [ColorCode], [ClassCode], [SizeCode] FROM Masterfile.[ItemDetail] WHERE ISNULL(IsInactive,0)=0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBizPartnerCus" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT A.BizPartnerCode, A.Name FROM Masterfile.BPCustomerInfo A INNER JOIN MasterFile.Bizpartner B ON A.BizpartnerCode = B.BizpartnerCode  WHERE ISNULL(A.IsInActive,0)=0 AND ISNULL(B.IsInActive,0)=0 " OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.Warehouse WHERE ISNULL([IsInactive],0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsRefSO" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.DocNumber, DocDate, CustomerCode, CustomerPONo, Currency, SUM(B.OrderQty-B.DeliveredQty) AS Quantity, Remarks, Terms, TargetDeliveryDate FROM Sales.SalesOrder A
        INNER JOIN Sales.SalesOrderDetail B ON A.DocNumber = B.DocNumber WHERE ISNULL(SubmittedBy,'') != '' AND Status IN ('N','P') GROUP BY A.DocNumber, DocDate, CustomerCode, CustomerPONo, Currency, Remarks, Terms, TargetDeliveryDate " OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Code, Description FROM IT.GenericLookup WHERE LookUpKey ='DRTYPE'" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSODetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=";WITH A AS 
    (SELECT '' AS DocNumber, A.DocNumber AS SONumber, ItemCode,FullDesc,ColorCode,ClassCode,SizeCode,ISNULL(OrderQty,0) - ISNULL(DeliveredQty,0) AS DeliveredQty,Unit,BulkQty,BulkUnit,StatusCode,0.00 AS ReturnedQty, 
    SubstituteItem,SubstituteColor,SubstituteClass, 0.00 AS BaseQty,BarcodeNo,ISNULL(UnitFactor,0.0000) AS UnitFactor,A.Field1,A.Field2,A.Field3,A.Field4,A.Field5,A.Field6,A.Field7,A.Field8,A.Field9,'2' AS Version, ISNULL(CustomerPONo,'') AS TransPONo FROM Sales.SalesOrderDetail A 
    INNER JOIN Sales.SalesOrder B ON A.DocNumber = B.DocNumber ) 
    SELECT DocNumber, RIGHT('00000'+ CAST(ROW_NUMBER() OVER (ORDER BY SONumber) AS VARCHAR(5)),5) AS LineNumber, SONumber, A.ItemCode, A.FullDesc, ColorCode, ClassCode, SizeCode, DeliveredQty, Unit, BulkQty, BulkUnit, StatusCode, ReturnedQty, SubstituteItem, SubstituteColor, SubstituteClass, 
    BaseQty, BarcodeNo, UnitFactor, A.Field1, A.Field2, A.Field3, A.Field4, A.Field5, A.Field6, A.Field7, A.Field8, A.Field9, Version, ISNULL(B.IsByBulk,0) AS IsByBulk, TransPONo, CAST(NULL AS Date) AS ExpDate, CAST(NULL AS Date) AS MfgDate, '' AS BatchNo, '' AS LotNo  FROM A INNER JOIN Masterfile.Item B ON A.ItemCode = B.ItemCode " OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UPPER(UnitCode) AS Unit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBulkUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UPPER(UnitCode) AS BulkUnit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    
    <!--#region Region Datasource-->
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.DeliveryReceipt" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.DeliveryReceipt" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.DeliveryReceipt+DeliveryReceiptDetail" SelectMethod="getdetail" UpdateMethod="UpdateDeliveryReceiptDetail" TypeName="Entity.DeliveryReceipt+DeliveryReceiptDetail" DeleteMethod="DeleteDeliveryReceiptDetail" InsertMethod="AddDeliveryReceiptDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.DeliveryReceipt+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.DeliveryReceipt+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    </form>
     <!--#endregion-->
</body>
</html>


