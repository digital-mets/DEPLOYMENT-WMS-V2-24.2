<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmServiceOrder.aspx.cs" Inherits="GWL.frmServiceOrder" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Service Order</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
        height: 800px; /*Change this whenever needed*/
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
        var isValid = true;
        var counterror = 0;

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        function OnInitTrans(s, e) {

            var BizPartnerCode = gvSup.GetText();
        
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
            gvsize.SetWidth(width - 120);
            gvbom.SetWidth(width - 120);
            gvwoi.SetWidth(width - 120);
            gvclass.SetWidth(width - 120);
            gvRef.SetWidth(width - 120)
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
            }
            else {
                isValid = true;
            }
        }

        var cnterr1 = 0;
        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            var btnmode = btn.GetText(); //gets text of button
            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }

            var cnterr1 = 0;
            var indicies = gvwoi.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indicies.length; i++) {
                if (gvwoi.batchEditApi.IsNewRow(indicies[i])) {
                    gvwoi.batchEditApi.ValidateRow(indicies[i]);
                    gvwoi.batchEditApi.StartEdit(indicies[i], gvwoi.GetColumnByField("DocNumber").index);
                    //gvwoi.batchEditApi.StartEdit(indicies[i], gvwoi.GetColumnByField("Labor").index);
                }
                else {
                    var key = gvwoi.GetRowKey(indicies[i]);
                    if (gvwoi.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else {  
                        gvwoi.batchEditApi.ValidateRow(indicies[i]);
                        gvwoi.batchEditApi.StartEdit(indicies[i], gvwoi.GetColumnByField("DocNumber").index);
                        //gvwoi.batchEditApi.StartEdit(indicies[i], gvwoi.GetColumnByField("Labor").index);
                    }
                }
            }

            var indiciesSize = gvsize.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indiciesSize.length; i++) {
                if (gvsize.batchEditApi.IsNewRow(indiciesSize[i])) {
                    gvsize.batchEditApi.ValidateRow(indiciesSize[i]);
                    gvsize.batchEditApi.StartEdit(indiciesSize[i], gvsize.GetColumnByField("DocNumber").index);
                    //gvsize.batchEditApi.StartEdit(indiciesSize[i], gvsize.GetColumnByField("SVOQty").index);
                }
                else {
                    var key = gvsize.GetRowKey(indiciesSize[i]);
                    if (gvsize.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indiciesSize[i]);
                    else {
                        gvsize.batchEditApi.ValidateRow(indiciesSize[i]);
                        gvsize.batchEditApi.StartEdit(indiciesSize[i], gvsize.GetColumnByField("DocNumber").index);
                        //gvsize.batchEditApi.StartEdit(indiciesSize[i], gvsize.GetColumnByField("SVOQty").index);
                    }
                }
            }

            //gv1.batchEditApi.EndEdit();
            if (cnterr1 > 0) {
                alert('Please check all fields!');
            }
            else if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
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
            if (s.cp_generated) {
                delete (s.cp_generated);
                gv1.CancelEdit();
                autocalculate();
            }

            if (s.cp_unitcost) {
                delete (s.cp_unitcost);
            }

            if (s.cp_vatrate != null) {

                vatrate = s.cp_vatrate;
                delete (s.cp_vatrate);
                vatdetail1 = 1 + parseFloat(vatrate);
            }

            if (s.cp_iswithdr == "1") {
                RefQuote.SetEnabled(true);
            }
            else if (s.cp_iswithdr == "0") {
                RefQuote.SetEnabled(false);
                RefQuote.SetText(null);
            }
        }

        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields) 
            for (var i = 0; i < gvwoi.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                if (column.fieldName == "WorkCenter" || column.fieldName == "Labor") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || value == 0) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false; cnterr1++; 
                    }
                }
            } 
        }
        function Grid_BatchEditRowValidating1(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gvsize.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                if (column.fieldName == "StockSize" || column.fieldName == "SVOQty") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || value == 0) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false; cnterr1++;
                    }
                }
            }
        }

        var index;
        var closing;
        var valchange = false;
        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var curr;

        var customerload;
        var itemcodeload;

        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
         
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            curr = e;
            index = e.visibleIndex;

            var entry = getParameterByName('entry');

            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }
            
            if (e.focusedColumn.fieldName === "UnitFreight" || e.focusedColumn.fieldName == "LineNumber") {
                e.cancel = true;
            }

            if (entry != "V") {
         
                if (e.focusedColumn.fieldName === "PerPieceConsumption") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "ByBulk") == true) {
                        e.cancel = true;
                    }
                    else {
                        glPerPieceConsumption.GetInputElement().value = cellInfo.value; //Gets the column value
                        isSetTextRequired = true;
                    }
                }
                if (e.focusedColumn.fieldName === "Consumption") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "ByBulk") == false) {
                        e.cancel = true;
                    }
                    else {
                        glConsumption.GetInputElement().value = cellInfo.value; //Gets the column value
                        isSetTextRequired = true;
                    }
                }
                if (e.focusedColumn.fieldName === "INQty" || e.focusedColumn.fieldName === "OutQty" 
                       || e.focusedColumn.fieldName === "AdjQty" || e.focusedColumn.fieldName === "FinalQty" || e.focusedColumn.fieldName === "FullDesc") { //Check the column name
                    e.cancel = true;
                }
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
                if (e.focusedColumn.fieldName === "StockSize") {
                    glsizecode.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                    closing = true;
                }
                if (e.focusedColumn.fieldName === "StockSizes") {
                    glsizecodes.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                    closing = true;
                }
                
        
                if (e.focusedColumn.fieldName === "BulkUnit") {
                    gl6.GetInputElement().value = cellInfo.value;
                }
        
                if (e.focusedColumn.fieldName === "IsByBulk") {
                    glIsByBulk.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "WorkCenter") {
                    glworkcenter.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                    closing = true;
                }

                
            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];

            var entry = getParameterByName('entry');

            if (currentColumn.fieldName === "ItemCode") {
                cellInfo.value = gl.GetValue();
                cellInfo.text = gl.GetText();
                valchange = true;
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


            if (currentColumn.fieldName === "StockSizes") {
                cellInfo.value = glsizecodes.GetValue();
                cellInfo.text = glsizecodes.GetText().toUpperCase();
            }

            if (currentColumn.fieldName === "StockSize") {
                cellInfo.value = glsizecode.GetValue();
                cellInfo.text = glsizecode.GetText().toUpperCase();
            }

            if (currentColumn.fieldName === "BulkUnit") {
                cellInfo.value = gl6.GetValue();
                cellInfo.text = gl6.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "VATCode") {
                cellInfo.value = glVATCode.GetValue();
                cellInfo.text = glVATCode.GetText();
            }
            if (currentColumn.fieldName === "IsVAT") {
                cellInfo.value = glIsVAT.GetValue();
            }
            if (currentColumn.fieldName === "IsByBulk") {
                cellInfo.value = glIsByBulk.GetValue();
            }
            if (currentColumn.fieldName === "WorkCenter") {

                cellInfo.value = glworkcenter.GetValue();
                cellInfo.text = glworkcenter.GetText();
                valchange = true;
            }

           
        }


        var identifier;
        var val_ALL;
        function GridEndChoice(s, e) {
            identifier = s.GetGridView().cp_identifier;
            val_ALL = s.GetGridView().cp_codes;


            if (identifier == "ItemCode") {
                delete (s.GetGridView().cp_identifier);
                if (s.GetGridView().cp_valch) {
                    delete (s.GetGridView().cp_valch);
                    for (var i = 0; i < gvbom.GetColumnsCount() ; i++) {

                        var column = gvbom.GetColumn(i);
                        if (column.visible == false || column.fieldName == undefined)
                            continue;
                        ProcessCells_ItemCode(0, e.visibleIndex, column, gvbom);
                    }
                }
                gvbom.batchEditApi.EndEdit();
            }


            if (identifier == "WorkCenter") {
                delete (s.GetGridView().cp_identifier);
                if (s.GetGridView().cp_valch) {
                    delete (s.GetGridView().cp_valch);
                    for (var i = 0; i < gvwoi.GetColumnsCount() ; i++) {

                        var column = gvwoi.GetColumn(i);
                        if (column.visible == false || column.fieldName == undefined)
                            continue;
                        ProcessCells_WorkCenter(0, e.visibleIndex, column, gvwoi);
                    }
                }
                gvwoi.batchEditApi.EndEdit();
            }


           
        }

        function ProcessCells_ItemCode(selectedIndex, e, column, s) {
            var temp_ALL;
            if (temp_ALL == null) {
                temp_ALL = ";;;;";
            }
            temp_ALL = val_ALL.split(';');
            if (temp_ALL[0] == null) {
                temp_ALL[0] = "";
            }
            if (temp_ALL[1] == null) {
                temp_ALL[1] = "";
            }
            if (temp_ALL[2] == null) {
                temp_ALL[2] = "";
            }
            if (temp_ALL[3] == null) {
                temp_ALL[3] = "";
            }
            if (temp_ALL[4] == null) {
                temp_ALL[4] = "";
            }
            if (temp_ALL[5] == null) {
                temp_ALL[5] = "";
            }

            if (selectedIndex == 0) {
                if (column.fieldName == "ColorCode") {
                    s.batchEditApi.SetCellValue(index, "ColorCode", temp_ALL[0]);
                }
                if (column.fieldName == "ClassCode") {
                    s.batchEditApi.SetCellValue(index, "ClassCode", temp_ALL[1]);
                }
                if (column.fieldName == "SizeCode") {
                    s.batchEditApi.SetCellValue(index, "SizeCode", temp_ALL[2]);
                }
                if (column.fieldName == "FullDesc") {
                    s.batchEditApi.SetCellValue(index, "FullDesc", temp_ALL[3]);
                }
                if (column.fieldName == "Unit") {
                    s.batchEditApi.SetCellValue(index, "Unit", temp_ALL[4]);
                }
                if (column.fieldName == "Cost") {
                    s.batchEditApi.SetCellValue(index, "Cost", Number(temp_ALL[5]));
                }


            }
            loader.Hide();
        }

        function ProcessCells_WorkCenter(selectedIndex, e, column, s) {
            var temp_ALL;
            if (temp_ALL == null) {
                temp_ALL = ";;";
            }
            temp_ALL = val_ALL.split(';');
            if (temp_ALL[0] == null) {
                temp_ALL[0] = "";
            }

            if (selectedIndex == 0) {
                if (column.fieldName == "VATCode") {
                    s.batchEditApi.SetCellValue(index, "VATCode", temp_ALL[0]);
                }


            }
            loader.Hide();
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
            if (gvwoi.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
            if (gvbom.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
            if (gvsize.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
        }

        function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == ASPxKey.Enter) {
                gv1.batchEditApi.EndEdit();
                gvwoi.batchEditApi.EndEdit();
                gvbom.batchEditApi.EndEdit();
                gvsize.batchEditApi.EndEdit();
            }

            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
            gvwoi.batchEditApi.EndEdit();
            gvbom.batchEditApi.EndEdit();
            gvsize.batchEditApi.EndEdit();
        }

        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                var Warehouse = "";
     
                factbox3.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&Warehouse=' + Warehouse); 
            }
            if (e.buttonID == "DeleteSB" ) {
                gvsize.DeleteRow(e.visibleIndex);
                autocalculate();
                detailautocalculate();
            }
            if (e.buttonID == "DeleteBOM" ) {
                gvbom.DeleteRow(e.visibleIndex);
                autocalculate();
                detailautocalculate();
            }
            if (e.buttonID == "ViewTransaction") {

                var transtype = s.batchEditApi.GetCellValue(e.visibleIndex, "TransType");
                var docnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "DocNumber");
                var commandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "CommandString");

                window.open(commandtring + '?entry=V&transtype=' + transtype + '&parameters=&iswithdetail=true&docnumber=' + docnumber, '_blank', "", false);
                
            }
            if (e.buttonID == "ViewReferenceTransaction") {

                var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
                var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
                var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
                window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
                
            }
        }


        function endcp(s, e) {
            var endg = s.GetGridView().cp_endgl1;
            if (endg == true) {
                sup_cp_Callback.PerformCallback(aglCustomerCode.GetValue().toString());
                e.processOnServer = false;
                endg = null;
            }
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

        function Frieght(s, e) {
            //detailautocalculate();
            autocalculate();
        }

        function VATCheckChange(s, e) {

            gv1.batchEditApi.EndEdit();

            if(s.GetChecked() == false){
                gv1.batchEditApi.SetCellValue(index, 'VATCode', 'NONV');
                gv1.batchEditApi.SetCellValue(index, 'Rate', '0');
            }

            autocalculate();
        }

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
                num = this.toFixed(Math.max(0, ~~d));

            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };
        var Nanprocessor = function (entry) {
            if (isNaN(entry) == true || entry == null || isFinite(entry) == false) { 
                return 0.00;
            }
            else {
                return entry;
            }
        }

        function autocalculate(s, e) {

       
            OnInitTrans();
            detailautocalculate();

            var TotalSVO = 0.0000;
            var EstAcc = 0.00;
            var EstUnit = 0.00;

            var svoqty = 0.0000;
            var comsumption = 0.00;
            var percomsumption = 0.00;
            var workorderprice = 0.00;
            var code = "";

            setTimeout(function () {
                var indicies = gvsize.batchEditApi.GetRowVisibleIndices();
                var indicies1 = gvbom.batchEditApi.GetRowVisibleIndices();
                var indicies2 = gvwoi.batchEditApi.GetRowVisibleIndices();

                var temp1 = indicies.length;
                var arrunit = [];
                var arrqty = [];
                var cntr = 0;
                var holder = 0;
                var txt1 = "";
                //RA

              

                for (var b = 0; b <= temp1; b++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[b])) {
                        for (var a = 0; a <= temp1; a++) {
                            if (gv1.batchEditApi.GetCellValue(indicies[b], "Unit") == arrunit[a]) {
                                var ter = gv1.batchEditApi.GetCellValue(indicies[b], "OrderQty");

                                if (isNaN(ter) == true) {
                                    ter = 0;
                                }

                                arrqty[a] += +ter; //adds qty with same unit
                                cntr++; //increment if found an existing unit
                            }
                        }
                        if (cntr == 0) {
                            holder++;
                            arrunit[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "Unit"); //add new unit
                            arrqty[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "OrderQty"); //along with qty
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
                                    var ter = gv1.batchEditApi.GetCellValue(indicies[b], "OrderQty");

                                    if (isNaN(ter) == true) {
                                        ter = 0;
                                    }

                                    arrqty[a] += +ter; //adds qty with same unit
                                    cntr++; //increment if found an existing unit
                                }
                            }
                            if (cntr == 0) {
                                holder++;
                                arrunit[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "Unit"); //add new unit
                                arrqty[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "OrderQty"); //along with qty
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
                        {
                            txt1 += "(" + arrunit[c].toUpperCase() + "|" + arrqty[c].format(2, 3, ',', '.') + ") ";
                        }
                    }
                }
                //end
           
                for (var i = 0; i < indicies.length; i++) {
                    if (gvsize.batchEditApi.IsNewRow(indicies[i])) {

                        svoqty = gvsize.batchEditApi.GetCellValue(indicies[i], "SVOQty");
                        TotalSVO += svoqty * 1.0000;



                    }
                    else {
                        var key = gvsize.GetRowKey(indicies[i]);
                        if (gvsize.batchEditApi.IsDeletedRow(key)) {
                            console.log("deleted row " + indicies[i]);
                        }
                        else { 
                            svoqty = gvsize.batchEditApi.GetCellValue(indicies[i], "SVOQty"); 
                            TotalSVO += svoqty * 1.0000; 
                        }
                    }
                }                
                
                for (var i = 0; i < indicies1.length ; i++) {
                    if (gvbom.batchEditApi.IsNewRow(indicies1[i])) {

                        comsumption = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "Consumption"));
                        percomsumption = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "PerPieceConsumption"));
                        workorderprice = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "Cost"));
                        EstAcc += percomsumption * workorderprice;
                        //RA 
                    }
                    else {
                        var key = gvbom.GetRowKey(indicies1[i]);
                        if (gvbom.batchEditApi.IsDeletedRow(key)) {
                            console.log("deleted row " + indicies1[i]);
                        }
                        else {

                            comsumption = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "Consumption"));
                            percomsumption = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "PerPieceConsumption"));
                            workorderprice = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "Cost"));
                            EstAcc += percomsumption * workorderprice; 
                        }
                    }

                }


                for (var a = 0; a < indicies.length; a++) {
                    for (var i = 0; i < indicies1.length ; i++) {


                        if (gvsize.batchEditApi.IsNewRow(indicies[a])) {


                   
                            if (gvbom.batchEditApi.IsNewRow(indicies1[i])) {

                                comsumption = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "Consumption"));
                                percomsumption = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "PerPieceConsumption"));

                                svoqty = Nanprocessor(gvsize.batchEditApi.GetCellValue(indicies[a], "SVOQty"));


                                if (gvbom.batchEditApi.GetCellValue(indicies1[i], "ByBulk") == true) {

                                    if (gvbom.batchEditApi.GetCellValue(indicies1[i], "StockSizes") == gvsize.batchEditApi.GetCellValue(indicies[a], "StockSize")) {
                                
                                        gvbom.batchEditApi.SetCellValue(indicies1[i], "PerPieceConsumption", Nanprocessor((comsumption / svoqty).toFixed(4)) || 0.00);
                                        gvbom.batchEditApi.SetCellValue(indicies1[i], "Tagged", '0'); 
                                    }


                                }

                                else {
                                    if (gvbom.batchEditApi.GetCellValue(indicies1[i], "StockSizes").trim() == gvsize.batchEditApi.GetCellValue(indicies[a], "StockSize").trim()) {
                                
                                        gvbom.batchEditApi.SetCellValue(indicies1[i], "Consumption", Nanprocessor((percomsumption * svoqty).toFixed(4)));
                                        gvbom.batchEditApi.SetCellValue(indicies1[i], "Tagged", '0');
                                    }
                                   

                                }

                            }
                        }
                    

                    
                        else {
                            var key = gvsize.GetRowKey(indicies[a]);
                            if (gvsize.batchEditApi.IsDeletedRow(key)) {
                                console.log("deleted row " + indicies[a]);
                            }

                            var key1 = gvbom.GetRowKey(indicies1[i]);
                            if (gvbom.batchEditApi.IsDeletedRow(key1)) {
                                console.log("deleted row " + indicies1[i]);
                            }
                            else {
                                comsumption = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "Consumption"));
                                percomsumption = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "PerPieceConsumption"));

                                svoqty = gvsize.batchEditApi.GetCellValue(indicies[a], "SVOQty");


                                if (gvbom.batchEditApi.GetCellValue(indicies1[i], "ByBulk") == true) {

                                    if (gvbom.batchEditApi.GetCellValue(indicies1[i], "StockSizes").trim() == gvsize.batchEditApi.GetCellValue(indicies[a], "StockSize").trim()) {

                                        gvbom.batchEditApi.SetCellValue(indicies1[i], "PerPieceConsumption", Nanprocessor((comsumption / svoqty).toFixed(4)) || 0.00);
                                        gvbom.batchEditApi.SetCellValue(indicies1[i], "Tagged", '0');  
                                    } 
                                }

                                else {
                                    if (gvbom.batchEditApi.GetCellValue(indicies1[i], "StockSizes").trim() == gvsize.batchEditApi.GetCellValue(indicies[a], "StockSize").trim()) {

                                        gvbom.batchEditApi.SetCellValue(indicies1[i], "Consumption", Nanprocessor((percomsumption * svoqty).toFixed(4)));
                                        gvbom.batchEditApi.SetCellValue(indicies1[i], "Tagged", '0');
                                    }


                                }

                          
                            }
                        }

                    }
                }



                for (var i = 0; i < indicies1.length ; i++) {
                    if (gvbom.batchEditApi.IsNewRow(indicies1[i])) {

                        comsumption = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "Consumption"));
                        percomsumption = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "PerPieceConsumption"));
                   

                        if (gvbom.batchEditApi.GetCellValue(indicies1[i], "ByBulk") == true) {

                            if (gvbom.batchEditApi.GetCellValue(indicies1[i], "Tagged") != '0') {
                                gvbom.batchEditApi.SetCellValue(indicies1[i], "PerPieceConsumption", Nanprocessor((comsumption / TotalSVO).toFixed(4)) || 0.00); 
                            }

                        }
                        else {
                            if (gvbom.batchEditApi.GetCellValue(indicies1[i], "Tagged") != '0') {
                                gvbom.batchEditApi.SetCellValue(indicies1[i], "Consumption", Nanprocessor((percomsumption * TotalSVO).toFixed(4)));
                            }


                        }




                    }
                    else {
                        var key = gvbom.GetRowKey(indicies1[i]);
                        if (gvbom.batchEditApi.IsDeletedRow(key)) {
                            console.log("deleted row " + indicies1[i]);
                        }
                        else {

                            comsumption = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "Consumption"));
                            percomsumption = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies1[i], "PerPieceConsumption"));

                            if (gvbom.batchEditApi.GetCellValue(indicies1[i], "ByBulk") == true) {

                                if (gvbom.batchEditApi.GetCellValue(indicies1[i], "Tagged") != '0') {
                                    gvbom.batchEditApi.SetCellValue(indicies1[i], "PerPieceConsumption", Nanprocessor((comsumption / TotalSVO).toFixed(4)) || 0.00); 
                                }

                            }
                            else {
                                if (gvbom.batchEditApi.GetCellValue(indicies1[i], "Tagged") != '0') {
                                    gvbom.batchEditApi.SetCellValue(indicies1[i], "Consumption", Nanprocessor((percomsumption * TotalSVO).toFixed(4)));
                                }


                            }


                        }
                    }




                }



    
             
                if (isNaN(EstAcc) == true) {
                    EstAcc = 0;
                }

                txtTotalSVOQty.SetValue(TotalSVO);
                detailautocalculate(s,e)
    

            }, 500);
        }

        function detailautocalculate(s, e) {
            var workorderprice = 0.00;
            var EstUnit = 0.00;
            var TotalCost = 0;
            var ItemCode = [];
            var ColorCode = [];
            var Cost1 = [];
            var Count = [];
            setTimeout(function () { //New Rows
                var indicies = gvbom.batchEditApi.GetRowVisibleIndices();
                var indicies2 = gvwoi.batchEditApi.GetRowVisibleIndices();
           
              
                for (var i = 0; i < indicies.length; i++) {
                    if (gvbom.batchEditApi.IsNewRow(indicies[i])) { 
                        var pasok = false;
                        var count = 0;
                        item = gvbom.batchEditApi.GetCellValue(indicies[i], "ItemCode");
                        color = gvbom.batchEditApi.GetCellValue(indicies[i], "ColorCode");
                        qty = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies[i], "PerPieceConsumption"));
                        cost = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies[i], "Cost")); 
                        if (ItemCode.length == 0) {
                            var temptotalcost = qty * cost;
                            ItemCode.push(item);
                            ColorCode.push(color);
                            Cost1.push(temptotalcost);
                            Count.push(1);
                            pasok = true;
                        }
                        else { 
                            for (var y = 0; y < ItemCode.length; y++) {
                                if (ItemCode[y] == item) { 
                                    if (ColorCode[y] == color) {
                                        var temptotalcost = qty * cost;
                                        Cost1[y] += temptotalcost;
                                        Count[y] += 1;
                                        pasok = true;
                                    }
                                }
                            }
                        }


                        if (pasok == false) {
                            var temptotalcost = qty * cost;
                            ItemCode.push(item);
                            ColorCode.push(color);
                            Cost1.push(temptotalcost);
                            Count.push(1);
                        }
                        

                       

                    }
                    else { //Existing Rows
                        var key = gvbom.GetRowKey(indicies[i]);
                        if (gvbom.batchEditApi.IsDeletedRow(key)) {
                            console.log("deleted row " + indicies[i]);
                            //gv1.batchEditHelper.EndEdit();
                        }
                        else {  
                            var pasok = false;
                            var count = 0;
                            item = gvbom.batchEditApi.GetCellValue(indicies[i], "ItemCode");
                            color = gvbom.batchEditApi.GetCellValue(indicies[i], "ColorCode");
                            qty = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies[i], "PerPieceConsumption"));
                            cost = Nanprocessor(gvbom.batchEditApi.GetCellValue(indicies[i], "Cost")); 
                            if (ItemCode.length == 0) {
                                var temptotalcost = qty * cost;
                                ItemCode.push(item);
                                ColorCode.push(color);
                                Cost1.push(temptotalcost);
                                Count.push(1);
                                pasok = true;
                            }
                            else { 
                                for (var y = 0; y < ItemCode.length; y++) {
                                    if (ItemCode[y] == item) { 
                                        if (ColorCode[y] == color) {
                                            var temptotalcost = qty * cost;
                                            Cost1[y] += temptotalcost;
                                            Count[y] += 1;
                                            pasok = true;
                                        }
                                    }
                                }
                            }


                            if (pasok == false) {
                                var temptotalcost = qty * cost;
                                ItemCode.push(item);
                                ColorCode.push(color);
                                Cost1.push(temptotalcost);
                                Count.push(1);
                            }
                        }
                    }
                }


                for (var i = 0; i < ItemCode.length; i++)
                {
                    TotalCost += Cost1[i] / Count[i]
                }
                txtEstAcc.SetValue(TotalCost);


                for (var i = 0; i < indicies2.length; i++) {
                    if (gvwoi.batchEditApi.IsNewRow(indicies2[i])) {

                        workorderprice = gvwoi.batchEditApi.GetCellValue(indicies2[i], "Labor");

                        EstUnit += workorderprice * 1.00;

                    }
                    else {
                        var key = gvwoi.GetRowKey(indicies2[i]);
                        if (gvwoi.batchEditApi.IsDeletedRow(key)) {
                            console.log("deleted row " + indicies2[i]);
                        }
                        else {

                            workorderprice = gvwoi.batchEditApi.GetCellValue(indicies2[i], "Labor");

                            EstUnit += workorderprice * 1.00;


                        }
                    }
                }
                txtEstUnitCost.SetValue((TotalCost + EstUnit).format(2, 3, ',', '.'));


            }, 500);

    
            
        }
      

        var transtype = getParameterByName('transtype');
        function onload() {
            fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + txtDocnumber.GetText() + '&transtype=' + transtype);
        }

    </script>
    <!--#endregion-->
</head>
<body style="height: 1600px;" onload="onload()">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
<form id="form1" runat="server" class="Entry">
    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Service Order" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
  <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="BizPartner info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="260"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    
    <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
        EnableViewState="False" HeaderText="Notes" Height="370px" Width="297px" PopupHorizontalOffset="785" PopupVerticalOffset="50"
        ShowCloseButton="False" Collapsed="true" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server" />
        </ContentCollection>
    </dx:ASPxPopupControl>

    <dx:ASPxPopupControl ID="popup3" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox3" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="50"
        ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
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
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
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
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="txtDocnumber">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date:" Name="DocDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpdocdate" runat="server"  Width="170px" OnInit="dtpdocdate_Init" OnLoad="Date_Load">
                                                              <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip" >
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Customer:" Name="Customer">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="aglCustomer"  Width="170px" runat="server" ClientInstanceName="gvSup" DataSourceID="Masterfilebizcustomer" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                              <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip" >
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                       <dx:LayoutItem Caption="Reference No">
                                                  <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                          <dx:ASPxTextBox ID="txtReferenceNo" runat="server" Width="170px">
                                                          </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Item Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glItemCode" runat="server"  Width="170px" DataSourceID="Masterfileitem" KeyFieldName="ItemCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                                 <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('Item');  } "  />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip" >
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle> 
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="ShortDesc" ReadOnly="True" VisibleIndex="2">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                 <dx:LayoutItem Caption="Due Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpduedate" runat="server"  Width="170px" OnLoad="Date_Load">
                                                            <ClientSideEvents  Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Color Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glColorCode"  Width="170px" runat="server" DataSourceID="MasterfileColor" KeyFieldName="ColorCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                              <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('Color');  } "/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip" >
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Status">
                                                  <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                          <dx:ASPxTextBox ID="txtStatus" runat="server" ReadOnly="True" Width="170px">
                                                          </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Remarks:" Name="Remarks:">
                                                <%--<LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRemarks" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>--%>
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="memReason" runat="server" Height="71px" Width="170px" OnLoad="Memo_Load">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Date Completed:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpdatecompleted" runat="server" Width="170px" ReadOnly="true" DropDownButton-Enabled="false">
                                                 
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                          </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Costing" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Total Labor:">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalLabor" runat="server" DisplayFormatString="{0:N}"  ConvertEmptyStringToNull="False"  ReadOnly="true"  Width="170px" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">  
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Raw Materials:">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalRaw" runat="server" DisplayFormatString="{0:N}"  ConvertEmptyStringToNull="False"  ReadOnly="true"  Width="170px" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">  
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Unit Cost:">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speUnitCost" runat="server" DisplayFormatString="{0:N}"  ConvertEmptyStringToNull="False"  ReadOnly="true"  Width="170px" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">  
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Est Acc. Cost:">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speEstAcc" runat="server" ClientInstanceName="txtEstAcc"  DisplayFormatString="{0:N}"  ConvertEmptyStringToNull="False"  ReadOnly="true"  Width="170px" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">  
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Est Unit Cost:">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speEstUnitCost" runat="server" ClientInstanceName="txtEstUnitCost"  DisplayFormatString="{0:N}"  ConvertEmptyStringToNull="False"  ReadOnly="true"  Width="170px" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="2">  
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Quantity" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Total SVO Qty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalSVOQty" runat="server" ClientInstanceName="txtTotalSVOQty" DisplayFormatString="{0:#,0.0000;(#,0.0000);}"  ConvertEmptyStringToNull="False"  ReadOnly="true"  Width="170px" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="4">  
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total  IN Qty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalInQty" runat="server"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}"  ConvertEmptyStringToNull="False"  ReadOnly="true"  Width="170px" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="4">  
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Final Qty:">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="speTotalfinalQty" runat="server"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}"  ConvertEmptyStringToNull="False"  ReadOnly="true"  Width="170px" NullDisplayText="0.00" NullText="0.00" MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="4">  
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Size Breakdown">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvsize" runat="server" AutoGenerateColumns="False"  Width="770px" KeyFieldName="DocNumber;LineNumber"
                                                                OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gvsize"
                                                                OnCustomButtonInitialize="gv1_CustomButtonInitialize" >
                                                                <ClientSideEvents Init="OnInitTrans" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="False" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="60px">
                                                                            <CustomButtons>
                                                                                <%--<dx:GridViewCommandColumnCustomButton ID="Details2">
                                                                                    <Image IconID="support_info_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>--%>
                                                                                
                                                                                <dx:GridViewCommandColumnCustomButton ID="DeleteSB">
                                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="StockSize" FieldName="StockSize" Name="StockSize" ShowInCustomizationForm="True" VisibleIndex="20" Width="100px">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glStockSize" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glsizecode" OnInit="glStockSize_Init" DataSourceID="sdsSizecode" KeyFieldName="SizeCode"  TextFormatString="{0}" Width="100px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" CloseUp="gridLookup_CloseUp" DropDown="lookup" 
                                                                                    />
                                                                    
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="SVO Qty" FieldName="SVOQty" Name="SVOQty" ShowInCustomizationForm="True" VisibleIndex="21">
                                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="gSVO" ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0" NullText="0"  MaxValue="9999999999" MinValue="0" SpinButtons-ShowIncrementButtons ="false">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="In Qty" FieldName="INQty" Name="INQty" ShowInCustomizationForm="True" VisibleIndex="22" ReadOnly="true">
                                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="ginqty" ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0" NullText="0"  MaxValue="9999999999" MinValue="0" SpinButtons-ShowIncrementButtons ="false">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Final Qty" FieldName="FinalQty" Name="FinalQty" ShowInCustomizationForm="True" VisibleIndex="23" ReadOnly="true">
                                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="gfinalqty" ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0" NullText="0"  MaxValue="9999999999" MinValue="0" SpinButtons-ShowIncrementButtons ="false">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field1" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="25">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field2" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="26">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field3" FieldName="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="27">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field4" FieldName="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="28">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field5" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="29">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field6" FieldName="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="30">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field7" FieldName="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="31">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field8" FieldName="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="32">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field9" FieldName="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="33">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                                    <SettingsPager Mode="ShowAllRecords"/> 
                                                                <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                                <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating1"  />
                                                                <SettingsEditing Mode="Batch"/>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Bill of Material">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                              <dx:ASPxGridView ID="gvbom" runat="server" AutoGenerateColumns="False"  Width="770px" KeyFieldName="DocNumber;LineNumber"
                                                                                OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gvbom"
                                                                                 OnInitNewRow="gvbom_InitNewRow" OnCustomButtonInitialize="gv1_CustomButtonInitialize" >
                                                                                <ClientSideEvents Init="OnInitTrans"  />

                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                    
                                 

                                                                        <dx:GridViewDataTextColumn Caption="StockSize" FieldName="StockSizes" Name="glsizecodes" ShowInCustomizationForm="True" VisibleIndex="2" Width="100px">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="glsizecodes" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glsizecodes" OnInit="Size_Init" DataSourceID="sdsSizecode" KeyFieldName="SizeCode"  TextFormatString="{0}" Width="100px">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                            </GridViewProperties>
                                                                                          <Columns>
                                                                                                    <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                          </Columns>
                                                                                           <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" CloseUp="gridLookup_CloseUp" DropDown="lookup" 
                                                                                         />
                                                                    
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>

                                                           
                                                       <dx:GridViewDataTextColumn FieldName="ItemCode" Caption="ItemCode" VisibleIndex="2" Width="150px" Name="glItemCode">
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="glItemCode_Init"
                                                                    DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="150px" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" 
                                                                         EndCallback="GridEndChoice" />
                                                                    
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                       
                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" VisibleIndex="2" Width="120px" Name="FullDesc" Caption="ItemDesc" ReadOnly="True">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="3" Width="100px" Caption="ColorCode">   
                                                              <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    KeyFieldName="ColorCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="100px"  OnInit="lookup_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains"  >
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEndChoice" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="4" Width="100px" Name="glClassCode" Caption="ClassCode">
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                KeyFieldName="ClassCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="100px" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains"  />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                        DropDown="function dropdown(s, e){
                                                                        gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="5" Width="100px" Name ="glSizeCode" Caption="SizeCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                KeyFieldName="SizeCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="100px" >
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
                                                         <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit" ShowInCustomizationForm="True" VisibleIndex="8" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl5" DataSourceID="sdsUnit" KeyFieldName="Unit" TextFormatString="{0}" Width="80px">
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
                                                                        }" EndCallback="GridEndChoice" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" ValueChanged="autocalculate" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="False" ShowInCustomizationForm="True" ShowNewButtonInHeader="true" VisibleIndex="1" Width="60px">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                                    <Image IconID="support_info_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                               <dx:GridViewCommandColumnCustomButton ID="DeleteBOM">
                                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                      

                                                                        <dx:GridViewDataSpinEditColumn Caption="PerPieceConsumption" FieldName="PerPieceConsumption" Name="PerPieceConsumption" ShowInCustomizationForm="True" VisibleIndex="9"  Width="130px">
                                                                        <PropertiesSpinEdit Increment="0" ClientInstanceName="glPerPieceConsumption"  ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0" NullText="0" MaxValue="9999999999" MinValue="0"  SpinButtons-ShowIncrementButtons ="false">
                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                                        <ClientSideEvents ValueChanged="autocalculate" />
                                                                    </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>

                                                                          <dx:GridViewDataSpinEditColumn Caption="Consumption" FieldName="Consumption" Name="Consumption" ShowInCustomizationForm="True" VisibleIndex="10">
                                                                    <PropertiesSpinEdit Increment="0" ClientInstanceName="glConsumption" ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0" NullText="0" MaxValue="9999999999" MinValue="0"  SpinButtons-ShowIncrementButtons ="false">
                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                                        <ClientSideEvents ValueChanged="autocalculate" />
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                                      <dx:GridViewDataSpinEditColumn Caption="Cost" FieldName="Cost" Name="Cost" ShowInCustomizationForm="True" VisibleIndex="10">
                                                                    <PropertiesSpinEdit Increment="0" ClientInstanceName="Cost" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0" NullText="0" MaxValue="9999999999" MinValue="0" SpinButtons-ShowIncrementButtons ="false">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                                        <ClientSideEvents ValueChanged="detailautocalculate" />
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>

                                                                        <dx:GridViewDataCheckColumn Caption="Major Material" FieldName="MajorMaterial" Name="MajorMaterial" ShowInCustomizationForm="True" VisibleIndex="23">
                                                                        </dx:GridViewDataCheckColumn>
                                                                        <dx:GridViewDataCheckColumn Caption="By Bulk" FieldName="ByBulk" Name="ByBulk" ShowInCustomizationForm="True"   VisibleIndex="24">
                                                                
                                                                              <PropertiesCheckEdit  ClientInstanceName="glByBulk">
                                                                                           <ClientSideEvents CheckedChanged="function(s,e){ 
                                                                    gvbom.batchEditApi.EndEdit(); 
                                                                    if (s.GetChecked() == false) 
                                                                    {
                                                               
                                                                        gvbom.batchEditApi.SetCellValue(index, 'Consumption', 0);
                                                                      
                                                                    }
                                                                    else

                                                                    {
                                                                      gvbom.batchEditApi.SetCellValue(index, 'PerPieceConsumption', 0);
                                                                    }
                                                                    autocalculate();
                                                                    }" />
                                                                          </PropertiesCheckEdit>
                                                                             
                                                                        </dx:GridViewDataCheckColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field1" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="25">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field2" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="26">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field3" FieldName="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="27">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field4" FieldName="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="28">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field5" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="29">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field6" FieldName="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="30">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field7" FieldName="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="31">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field8" FieldName="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="32">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field9" FieldName="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="33">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field9" FieldName="Tagged" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="33" Width="0" >
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                        <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                 <SettingsPager Mode="ShowAllRecords"/> 
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" 
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                     <SettingsEditing Mode="Batch"/>
                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Work Order Information">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                           <dx:ASPxGridView ID="gvwoi" runat="server" AutoGenerateColumns="False"  Width="770px" KeyFieldName="DocNumber;LineNumber"
                                                   OnCommandButtonInitialize="gv_CommandButtonInitialize1" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gvwoi"
                                                   SettingsBehavior-HeaderFilterMaxRowCount="1"  >
                                                    <ClientSideEvents Init="OnInitTrans" />
                                                <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                                    <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                    </PropertiesTextEdit>
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewCommandColumn Name="cmd" ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="60px">
                                                                    <CustomButtons>
                                                                        <%--<dx:GridViewCommandColumnCustomButton ID="Details4">
                                                                            <Image IconID="support_info_16x16">
                                                                            </Image>
                                                                        </dx:GridViewCommandColumnCustomButton>--%>
                                                                    </CustomButtons>
                                                                </dx:GridViewCommandColumn>
                                                         
                                                                <dx:GridViewDataTextColumn Caption="Work Center" FieldName="WorkCenter" Name="WorkCenter" ShowInCustomizationForm="True" VisibleIndex="20">
                                                                <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="WorkCenter" runat="server" OnInit="glWorkCenter_Init" AutoGenerateColumns="True"  AutoPostBack="false" IncrementalFilteringMode="Contains"
                                                                KeyFieldName="SupplierCode" ClientInstanceName="glworkcenter"   TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" DataSourceID="sdsWorkCenter">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                          <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains"  >
                                                                        </dx:GridViewDataTextColumn>
                                                                          <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains"  >
                                                                        </dx:GridViewDataTextColumn>    
                                                                    </Columns>
                                                                         <ClientSideEvents CloseUp="gridLookup_CloseUp" DropDown="lookup"  KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" EndCallback="GridEndChoice"  />
                                           
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataSpinEditColumn Caption="In Qty" FieldName="INQty" Name="INQty" ShowInCustomizationForm="True" ReadOnly="true" VisibleIndex="22">
                                                                                 <PropertiesSpinEdit Increment="0" ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0.0000" NullText="0.0000">
                                                            
                                                                    </PropertiesSpinEdit>
                                                                    
                                                                      </dx:GridViewDataSpinEditColumn>
                                                                   <dx:GridViewDataSpinEditColumn Caption="Out Qty" FieldName="OutQty" Name="OutQty" ShowInCustomizationForm="True"  ReadOnly="true" VisibleIndex="22">
                                                                <PropertiesSpinEdit Increment="0" ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0" NullText="0">
                                                            
                                                                    </PropertiesSpinEdit>
                                                                   </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn Caption="Adj Qty" FieldName="AdjQty" Name="AdjQty" ShowInCustomizationForm="True" ReadOnly="true"  VisibleIndex="23">
                                                               <PropertiesSpinEdit Increment="0"  ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0" NullText="0">
                                                                        <ClientSideEvents  />
                                                                    </PropertiesSpinEdit>
                                                                     </dx:GridViewDataSpinEditColumn>

                                                                                           <dx:GridViewDataSpinEditColumn Caption="Work Order Price" FieldName="Labor" Name="Labor" ShowInCustomizationForm="True" VisibleIndex="23">
                                                                    <PropertiesSpinEdit Increment="0" ClientInstanceName="gworkorderprice" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00"  MaxValue="9999999999" MinValue="0" SpinButtons-ShowIncrementButtons ="false">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                                        <ClientSideEvents ValueChanged="autocalculate" />
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>

                                                       
<%--                                                                    <dx:GridViewDataTextColumn Caption="VatCode" FieldName="Vat" Name="Vat" ShowInCustomizationForm="True" VisibleIndex="23">
                                                                         <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="VATCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" 
                                                                    DataSourceID="sdsTaxCode" KeyFieldName="VATCode" ClientInstanceName="glVAT" OnInit="lookup_Init" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="VATCode" ReadOnly="True" VisibleIndex="0" Caption="Tax Code"/>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"  />
                                                                </dx:ASPxGridLookup>
                                                                             </EditItemTemplate>
                                                                </dx:GridViewDataTextColumn>--%>


                                                       <dx:GridViewDataTextColumn FieldName="VATCode" Name="glpVATCode" ShowInCustomizationForm="True" VisibleIndex="23">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="VATCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" 
                                                                    DataSourceID="sdsTaxCode" KeyFieldName="TCode" ClientInstanceName="glVATCode"   TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="TCode" ReadOnly="True" VisibleIndex="0" Caption="Tax Code"/>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                      <ClientSideEvents CloseUp="gridLookup_CloseUp"  KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"  EndCallback="GridEndChoice"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field1" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="25">
                                                            
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field2" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="26">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field3" FieldName="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="27">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field4" FieldName="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="28">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field5" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="29">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field6" FieldName="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="30">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field7" FieldName="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="31">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field8" FieldName="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="32">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field9" FieldName="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="33">
                                                                </dx:GridViewDataTextColumn>

                                                          
                                                            </Columns>
                                                                   <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                 <SettingsPager Mode="ShowAllRecords"/> 
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" 
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" />
                                                     <SettingsEditing Mode="Batch"/>
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>

                                             <dx:LayoutGroup Caption="Class Breakdown">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                   <dx:ASPxGridView ID="gvclass" runat="server" AutoGenerateColumns="False"  Width="770px" KeyFieldName="DocNumber;LineNumber"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gvclass"
                                                     OnCustomButtonInitialize="gv1_CustomButtonInitialize" >
                                                    <ClientSideEvents Init="OnInitTrans" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                                    <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                    </PropertiesTextEdit>
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px">
                                                                    <CustomButtons>
                                                                        <dx:GridViewCommandColumnCustomButton ID="Details3">
                                                                            <Image IconID="support_info_16x16">
                                                                            </Image>
                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                    </CustomButtons>
                                                                </dx:GridViewCommandColumn>
                                                         
                                                                <dx:GridViewDataTextColumn Caption="ClassCode" FieldName="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" VisibleIndex="20">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Quantity" FieldName="Quantity" Name="Quantity" ShowInCustomizationForm="True" VisibleIndex="21">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field1" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="25">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field2" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="26">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field3" FieldName="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="27">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field4" FieldName="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="28">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field5" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="29">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field6" FieldName="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="30">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field7" FieldName="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="31">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field8" FieldName="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="32">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field9" FieldName="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="33">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                 <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                 <SettingsPager Mode="ShowAllRecords"/> 
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
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
                                    </dx:LayoutGroup>
                                   <dx:LayoutGroup Caption="Material Movement">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                      <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False"  Width="770px" KeyFieldName="DocNumber;LineNumber"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                      OnCustomButtonInitialize="gv1_CustomButtonInitialize" >
                                                    <ClientSideEvents Init="OnInitTrans" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                                    <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                    </PropertiesTextEdit>
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewCommandColumn ButtonType="Image"  ShowInCustomizationForm="True"  VisibleIndex="1" Width="60px">
                                                                    <CustomButtons>
                                                                        <dx:GridViewCommandColumnCustomButton ID="Details1">
                                                                            <Image IconID="support_info_16x16">
                                                                            </Image>
                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                    </CustomButtons>
                                                                </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn Caption="ItemCode" FieldName="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="ColorCode" FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7">
                                                                </dx:GridViewDataTextColumn>
                                                                 <dx:GridViewDataTextColumn Caption="ClassCode" FieldName="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="SizeCode" FieldName="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit" Name="Unit" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7">
                                                                </dx:GridViewDataTextColumn>
                                                                  <dx:GridViewDataTextColumn Caption="Issued Qty" FieldName="IssuedQty" Name="IssuedQty" ShowInCustomizationForm="True" VisibleIndex="20">
                                                                </dx:GridViewDataTextColumn>
                                                                  <dx:GridViewDataTextColumn Caption="Return Qty" FieldName="ReturnQty" Name="ReturnQty" ShowInCustomizationForm="True" VisibleIndex="20">
                                                                </dx:GridViewDataTextColumn>
                                          
                                                                <dx:GridViewDataTextColumn Caption="Consumption" FieldName="Consumption" Name="Consumption" ShowInCustomizationForm="True" VisibleIndex="21">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="IN Qty" FieldName="INQty" Name="INQty" ShowInCustomizationForm="True" VisibleIndex="22">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Allocation" FieldName="Allocation" Name="Allocation" ShowInCustomizationForm="True" VisibleIndex="23">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Replacement Qty" FieldName="ReplacementQty" Name="ReplacementQty" ShowInCustomizationForm="True" VisibleIndex="24">
                                                                </dx:GridViewDataTextColumn>
                                                                 <dx:GridViewDataTextColumn Caption="Charge Qty" FieldName="ChargeQty" Name="ChargeQty" ShowInCustomizationForm="True" VisibleIndex="24">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field1" FieldName="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="25">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field2" FieldName="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="26">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field3" FieldName="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="27">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field4" FieldName="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="28">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field5" FieldName="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="29">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field6" FieldName="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="30">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field7" FieldName="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="31">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field8" FieldName="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="32">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field9" FieldName="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="33">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                 <SettingsPager Mode="ShowAllRecords"/> 
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" 
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                     <SettingsEditing Mode="Batch"/>
                                                        </dx:ASPxGridView>
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

                                      <dx:LayoutGroup Caption="Audit Trail" ColCount="2">
                                                       <Items>
                                                           <dx:LayoutItem Caption="Added By">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHAddedBy" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Added Date">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHAddedDate" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Last Edited By">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Last Edited Date">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Submitted By">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Submitted Date">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Manual Closed By">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtmanualclosed" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Manual Closed Date">
                                                               <LayoutItemNestedControlCollection>
                                                                   <dx:LayoutItemNestedControlContainer runat="server">
                                                                       <dx:ASPxTextBox ID="txtmanualcloseddate" runat="server" ReadOnly="True" Width="170px">
                                                                       </dx:ASPxTextBox>
                                                                   </dx:LayoutItemNestedControlContainer>
                                                               </LayoutItemNestedControlCollection>
                                                           </dx:LayoutItem>
                                                       </Items>
                                                   </dx:LayoutGroup>
                                         <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction" ColCount="2">
                                               <Items>
                                                                  <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px" ClientInstanceName="gvRef"  KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber"   >
                                                              <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="NextColumn" />
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                            <SettingsPager PageSize="5">
                                                            </SettingsPager>
                                                            <SettingsEditing Mode="Batch">
                                                            </SettingsEditing>
                                                    
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber"
                                                            VisibleIndex="5" Caption="DocNumber" Name="DocNumber">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Reference TransType" Name="RTransType" ShowInCustomizationForm="True" VisibleIndex="1" FieldName="RTransType" ReadOnly="True">
                                                         
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="90px">
                                                        <CustomButtons>
                                                            <dx:GridViewCommandColumnCustomButton ID="ViewReferenceTransaction">
                                                               <Image IconID="functionlibrary_lookupreference_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                            	
                                                            <dx:GridViewCommandColumnCustomButton ID="ViewTransaction">
                                                                <Image IconID="find_find_16x16">
                                                                </Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                            	
                                                        </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="REFDocNumber" VisibleIndex="2" Visible="true" PropertiesTextEdit-ConvertEmptyStringToNull="true" Caption="Reference DocNumber">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4">
                                                        </dx:GridViewDataTextColumn>
                                                          <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3">
                                                        </dx:GridViewDataTextColumn>
                                                          <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6">
                                                        </dx:GridViewDataTextColumn>
                                                     
                                                    </Columns>
                                                            <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager PageSize="5"/> 
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
                            </dx:TabbedLayoutGroup>

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
                     <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Cloning..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="gvbom">
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
        <form id="form2" runat="server" visible="false">
    <!--#region Region Datasource-->
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.ServiceOrder" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.SalesOrder" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
         <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Procurement.SOMaterialMovement where DocNumber is null" OnInit ="Connection_Init"></asp:SqlDataSource>
      
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.ServiceOrder+SOMaterialMovement" SelectMethod="getdetail" TypeName="Entity.ServiceOrder+SOMaterialMovement" >
           <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

     
       <asp:SqlDataSource ID="sdsBOM" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Procurement.SOBillOfMaterial where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:ObjectDataSource ID="odsBOM" runat="server" DataObjectTypeName="Entity.ServiceOrder+SOBillOfMaterial" SelectMethod="getdetail" UpdateMethod="UpdateSOBillOfMaterial" TypeName="Entity.ServiceOrder+SOBillOfMaterial" DeleteMethod="DeleteSOBillOfMateriall" InsertMethod="AddSOBillOfMaterial">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="sdsWOI" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Procurement.SOWorkOrder where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:ObjectDataSource ID="odsWOI" runat="server" DataObjectTypeName="Entity.ServiceOrder+SOWorkOrder" SelectMethod="getdetail" UpdateMethod="UpdateSOWorkOrder" TypeName="Entity.ServiceOrder+SOWorkOrder" DeleteMethod="DeleteSOWorkOrder" InsertMethod="AddSOWorkOrder">
             <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Procurement.SOSizeBreakdown where DocNumber is null"   OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:ObjectDataSource ID="odsSize" runat="server" DataObjectTypeName="Entity.ServiceOrder+SoSizeBreakDown" SelectMethod="getdetail" UpdateMethod="UpdateSoSizeBreakDown" TypeName="Entity.ServiceOrder+SoSizeBreakDown" DeleteMethod="DeleteSoSizeBreakDown" InsertMethod="AddSoSizeBreakDown">
         <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

        <asp:ObjectDataSource ID="odsClass" runat="server" SelectMethod="getdetail" TypeName="Entity.ServiceOrder+SoClassBreakDown">
              <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.ServiceOrder+RefTransaction" >
          <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
     <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] where isnull(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
     <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"> </asp:SqlDataSource>

     <asp:SqlDataSource ID="sdsSizecode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTaxCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from masterfile.Tax where ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
     <asp:SqlDataSource ID="MasterfileColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT  DISTINCT [ColorCode],[ItemCode] FROM Masterfile.[ItemDetail] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WareHouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
   <asp:SqlDataSource ID="ItemAdjustment" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AdjustmentCode,TransType FROM Masterfile.[AdjustmentType]" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsUnit" runat="server" SelectCommand="SELECT DISTINCT UnitCode AS Unit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebizcustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,0)=0 and IsCustomer='1'" OnInit="Connection_Init"></asp:SqlDataSource>
     <asp:SqlDataSource ID="sdsWorkCenter" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
            </form>
</body>
</html>