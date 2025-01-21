<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmRequest.aspx.cs" Inherits="GWL.frmRequest" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title></title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%><%--Link to global stylesheet--%>
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
        var isValid = false;
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

        function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)
            if (s.GetText() == "" || e.value == "" || e.value == null) {
                counterror++;
                isValid = false
            }
            else {
                isValid = true;
            }
        }
        function OnInitTrans(s, e) {
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
        }

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
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
            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
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
                if (s.cp_forceclose) {
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

            //if (s.cp_delete) {

              //  delete (cp_delete);
            //   DeleteControl.Show();
            //}

            if (s.cp_generated) {
                delete (s.cp_generated);
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
            if (s.cp_reference != null) {

                ReferenceCheck();
                delete (s.cp_reference);
            }
            if (s.cp_refdel != null) {
                gv1.CancelEdit();
                delete (s.cp_refdel);
            }

            //ADDED NEW
            if (s.cp_forceclose) {
                delete (s.cp_forceclose);
                window.close();
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
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            editorobj = e;
            evn = e;
            var entry = getParameterByName('entry');
            var transtayp = getParameterByName('transtype');
            if (transtayp == "INVJOR")
            {
                if (entry == "V" || entry == "D") 
                {
                    e.cancel = true;
                   

                }
                else
                {
                    console.log('1');
                    console.log(glRefJONumber.GetText());
                    if (glRefJONumber.GetText() != "" && glRefJONumber.GetText() != null) {
                        console.log('2');
                        if (e.focusedColumn.fieldName == "RequestedQty" || e.focusedColumn.fieldName == "RequestedBulkQty" ||
                            e.focusedColumn.fieldName == "RequestedBulkUnit" || e.focusedColumn.fieldName == "Field1" ||                           
                            e.focusedColumn.fieldName == "Field2" || e.focusedColumn.fieldName == "Field3" ||
                            e.focusedColumn.fieldName == "Field4" || e.focusedColumn.fieldName == "Field5" ||
                            e.focusedColumn.fieldName == "Field6" || e.focusedColumn.fieldName == "Field7" ||
                            e.focusedColumn.fieldName == "Field8" || e.focusedColumn.fieldName == "Field9") {
                            e.cancel = false;
                        }
                        else {
                            e.cancel = true;
                        }
                    }
                    else {
                        console.log('3');
                        if (e.focusedColumn.fieldName == "IssuedQty" || e.focusedColumn.fieldName == "ReturnedQty" || e.focusedColumn.fieldName == "ReturnedBulkQty") {
                            e.cancel = true;
                        }
                        else e.cancel = false;
                    }


                    if (e.focusedColumn.fieldName == "MfgDate" || e.focusedColumn.fieldName == "ExpDate" ||
                        e.focusedColumn.fieldName == "BatchNo" || e.focusedColumn.fieldName == "LotNo") {
                        e.cancel = false;
                    }
                }
            }
            else
            {
                if (entry == "V" || entry == "D")
                {
                    e.cancel = true;
                }
                else
                {
                    if (  e.focusedColumn.fieldName == "IssuedQty" || e.focusedColumn.fieldName == "ItemPrice" || e.focusedColumn.fieldName == "ReturnedQty" || e.focusedColumn.fieldName == "ReturnedBulkQty") {
                        e.cancel = true;
                    }
                    else
                        e.cancel = false;
                }
            }

            if (entry != "V") {
                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column vaclue
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
                if (e.focusedColumn.fieldName === "ItemPrice") {
                    glItemPrice.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "StatusCode") {
                    CINStatusCode.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "RequestedBulkUnit") {
                    glRequestedBulkUnit1.GetInputElement().value = cellInfo.value;
                }
            }
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
            if (currentColumn.fieldName === "RequestedBulkUnit") {
                cellInfo.value = glRequestedBulkUnit1.GetValue();
                cellInfo.text = glRequestedBulkUnit1.GetText().toUpperCase();
            }

            //if (valchange) {
            //    valchange = false;
            //    closing = false;
            //    for (var i = 0; i < s.GetColumnsCount() ; i++) {
            //        var column = s.GetColumn(i);
            //        if (column.visible == false || column.fieldName == undefined)
            //            continue;
            //        ProcessCells(0, e, column, s);
            //    }
            //}
        }


        var val;
        var temp;
        function ProcessCells(selectedIndex, e, column, s) {
            if (val == null) {
                //val = ";;;;";
                val = ";;;;;;;;";
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
                if (column.fieldName == "RequestedBulkUnit") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
                }

                if (column.fieldName == "FullDesc") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
                }

                //ADDED NEW
                //if (column.fieldName == "ItemPrice") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[7]);
                //}
                if (column.fieldName == "ItemPrice") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[6]); 
                }
                if (column.fieldName == "StatusCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[7]);
                }
                
            }
        }


        function GridEnd(s, e) {

            val = s.GetGridView().cp_codes;
            if (val == null || val == "")
            {
                val = ";;;;;;;;";
            }
            temp = val.split(';');
            console.log(val + ' val')


            delete (s.GetGridView().cp_identifier);
            if (s.GetGridView().cp_valch) {
                delete (s.GetGridView().cp_valch);
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, editorobj, column, gv1);
                }
                gv1.batchEditApi.EndEdit();
            }
            //val = s.GetGridView().cp_codes;
            //temp = val.split(';');

            //if (closing == true) {
            //    for (var i = 0; i > -gv1.GetVisibleRowsOnPage() ; i--) {
            //        gv1.batchEditApi.ValidateRow(-1);
            //        gv1.batchEditApi.StartEdit(i, gv1.GetColumnByField("ColorCode").index);
            //    }
            //    gv1.batchEditApi.EndEdit();
            //}
            //loader.Hide();
        }

        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                var chckd;
                var chckd2;

                if (column.fieldName == "IsByBulk") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    //ASPxClientUtils.Trim(value)                    
                    if (value == true) {
                        chckd2 = true;
                    }
                }
                if (column.fieldName == "RequestedBulkQty") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    //if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == "0" || ASPxClientUtils.Trim(value) == null) && chckd2 == true) {
                    if ((!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == null) && chckd2 == true) {
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
                    else {
                        isValid = true;
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
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
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
                var unitbulk = s.batchEditApi.GetCellValue(e.visibleIndex,"UnitBulk")
                var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                //factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                //+ '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&unit=' + unitbase + '& Unitbulk=' + unitbulk + '&fulldesc=' + fulldesc);
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + encodeURIComponent(itemcode)
                + '&colorcode=' + encodeURIComponent(colorcode) + '&classcode=' + encodeURIComponent(classcode) + '&sizecode=' + encodeURIComponent(sizecode) + '&Warehouse=');
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
                var bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "RequestedBulkQty");
                console.log(itemcode);
                var expdate = s.batchEditApi.GetCellValue(e.visibleIndex, "ExpDate");
                var mfgdate = s.batchEditApi.GetCellValue(e.visibleIndex, "MfgDate");
                var batchno = s.batchEditApi.GetCellValue(e.visibleIndex, "BatchNo");
                var lotno = s.batchEditApi.GetCellValue(e.visibleIndex, "LotNo");
                var docdate = dtpDocDate.GetText();
                var entry = getParameterByName('entry'); 
                var Warehouse = CINIssuingWarehouse.GetText(); 
                CSheet.SetContentUrl('../WMS/frmTRRSetup.aspx?entry=' + entry + '&docnumber=' + docnumber
                   + '&transtype=' + transtype
                   + '&linenumber=' + linenum
                   + '&refdocnum=' + encodeURIComponent(refdocnum)
                   + '&itemcode=' + encodeURIComponent(itemcode)
                   + '&colorcode=' + encodeURIComponent(colorcode)
                   + '&classcode=' + encodeURIComponent(classcode)
                   + '&sizecode=' + encodeURIComponent(sizecode)
                   + '&warehouse=' + encodeURIComponent(Warehouse)
                   + '&expdate=' + encodeURIComponent(convertDate(expdate))
                   + '&mfgdate=' + encodeURIComponent(convertDate(mfgdate))
                   + '&batchno=' + encodeURIComponent(batchno)
                   + '&lotno=' + encodeURIComponent(lotno)
                   + '&bulkqty=' + bulkqty
				   + '&docdate=' + encodeURIComponent(convertDate(docdate)));
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
            cp.PerformCallback('DISChecked');
            cosole.log('here');
        }


        //function checkedchanged(s, e) {
           // var checkState = cbiswithdr.GetChecked();
            //if (checkState == true) {
               // cp.PerformCallback('iswithquotetrue');
              //  e.processOnServer = false;
            //}
            //else {
             //   cp.PerformCallback('iswithquotefalse');
            //    e.processOnServer = false;
          //  }
        //}

        function ReferenceCheck(s, e) {

            if (chkRefSO.GetChecked)
            {
                aglType.SetText("SALES SLIP");
            }
            else
            {
                aglType.SetText("SALES ORDER");
            }
        }

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
                num = this.toFixed(Math.max(0, ~~d));

            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };

        function autocalculate(s, e) {
            var reqqty = 0.00;
            var totreqqty = 0.00;
            //var TotalBulkQty = 0.00;
            //var totalbulkqty = 0.00;
            //var returnedbulkqty = 0.00;
            var a = 0;

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        reqqty = gv1.batchEditApi.GetCellValue(indicies[i], "RequestedQty");
                        totreqqty += reqqty;
                        //returnedbulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "ReturnedBulkQty");
                        //TotalBulkQty += returnedbulkqty;

                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                  
                        else {
                            reqqty = gv1.batchEditApi.GetCellValue(indicies[i], "RequestedQty");
                            totreqqty += reqqty;
                            //returnedbulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "ReturnedBulkQty");
                            //TotalBulkQty += returnedbulkqty;
                        }
                    }
                }
                txtTotalQty.SetText(totreqqty.format(4, 5, ',', '.'));
                //txtTotalBulkQty.SetText(TotalBulkQty.toFixed(2));

             
                //console.log('kate: ' + TotalBulkQty)
            }, 500);
        }

        function autocalculate1(s, e) {
            //console.log(txtNewUnitCost.GetValue());

            var TotalBulkQty = 0.00;

            var totalbulkqty = 0.00
            var requestbulkqty = 0.00;


            setTimeout(function () { //New Rows
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        requestbulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "RequestedBulkQty");

                        TotalBulkQty += requestbulkqty;



                        //console.log(gv1.batchEditApi.GetCellValue(indicies[i], "IsVat"));

                    }

                    else { //Existing Rows
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {

                            requestbulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "RequestedBulkQty");

                            TotalBulkQty += returnedbulkqty;

                        }
                    }
                    txtTotalBulkQty.SetText(TotalBulkQty.toFixed(2));

                }

            }, 500);
        }
        function OnGetSelectedFieldValues(selectedValues) {
            listBox.ClearItems();
            if (selectedValues.length == 0) return;
            for (i = 0; i < selectedValues.length; i++) {
                s = "";
                for (j = 0; j < selectedValues[i].length; j++) {
                    s = s + selectedValues[i][j] + "&nbsp;";
                }
                listBox.AddItem(s);
            }
        }

        //ADDED NEW
        function XDeal(s, e) {
            if (module != 'INVCOR') {
                console.log(module);
            }
            else {
                cp.PerformCallback('XDeal');
            }
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
                <dx:ASPxLabel ID="HeaderText" runat="server" Text="Request" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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


    

    <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents CloseUp="function (s, e) { cp.PerformCallback('RefGrid') }" />
    </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <SettingsTabPages EnableClientSideAPI="True">
                                </SettingsTabPages>
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <Items>
                                                    <%--<dx:LayoutItem Caption="Requested By" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glRequestedBy" runat="server" DataSourceID="sdsRequestedBy" AutoGenerateColumns="False" KeyFieldName="EmployeeCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="EmployeeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
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
                                                    </dx:LayoutItem>--%>
                                                    <%--<dx:LayoutItem Caption="Cost Center" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glCostCenter" runat="server" DataSourceID="sdsCostCenter" KeyFieldName="CostCenterCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
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
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                    <dx:LayoutItem Caption="Document Number" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" ReadOnly="True" AutoCompleteType="Disabled" >
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnInit="dtpDocDate_Init" OnLoad="Date_Load" Width="170px" ClientInstanceName="dtpDocDate">
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
                                                    <dx:LayoutItem Caption="Target Delivery Date" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDeliveryDate" runat="server" OnInit="dtpDocDate_Init" OnLoad="Date_Load" Width="170px">
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
                                                    <dx:LayoutItem Caption="Trans Type">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtTransType" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Type">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtType" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Requested By" RequiredMarkDisplayMode="Required" Name="requestedby">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtRequestedBy" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Cost Center">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtCostCenter" runat="server" ReadOnly="True" Width="170px" >
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Quantity">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTextBox ID="txtTotalQty" runat="server" Width="170px" ClientInstanceName="txtTotalQty" ReadOnly="True" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                            DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Status">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtStatus" runat="server" ReadOnly="True" Width="170px" >
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                     <dx:LayoutItem Caption="Total Bulk Qty" Name="TotalBulkQty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtTotalBulkQty" runat="server" Width="170px" ReadOnly="true" DisplayFormatString="{0:N}" ClientInstanceName="txtTotalBulkQty">
                                                                   <ClientSideEvents ValueChanged ="autocalculate1"/>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Reference Issuance">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtRefIssuance" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Printed" Name="Print">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="cbxIsPrinted" runat="server" CheckState="Unchecked" ReadOnly="true">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" Width="170px" OnLoad="MemoLoad">
                                                                </dx:ASPxMemo>
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
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Samples" ColCount="2" Name="SamplesGroup" ClientVisible="false">
                                                <Items>
                                                    <dx:LayoutItem Caption="With DIS">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="cbxWithDIS" runat="server" ClientInstanceName="cbwithdis" CheckState="Unchecked" OnLoad="CheckBoxLoad">
                                                                    <ClientSideEvents CheckedChanged="checkedchanged"/>
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="DIS Number">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDISNumber" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="JO Materials" ColCount="2" Name="JOMaterialGroup">
                                                <Items>
                                                    <%--<dx:LayoutItem Caption="Reference Number:" Name="RefJONumber" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glRefJONumber" runat="server" AutoGenerateColumns="False" DataSourceID="sdsRefDoc" KeyFieldName="DocNumber" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowSelectByRowClick="true" AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="10px"></dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('JOStep');}"/>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>  --%>
                                                    <dx:LayoutItem Caption="Issuing Warehouse" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glIssuingWarehouse" runat="server" Width="170px" DataSourceID="sdsWarehouse" AutoGenerateColumns="false" KeyFieldName="WarehouseCode" OnLoad="LookupLoad" TextFormatString="{0}" ClientInstanceName="CINIssuingWarehouse">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
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
                                                     <dx:LayoutItem Caption="Material Type">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glMaterialType" runat="server" Width="170px" AutoGenerateColumns="False" DataSourceID="sdsMaterialType" KeyFieldName="MaterialCode" OnLoad="LookupLoad" TextFormatString="{1}">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="MaterialCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('MaterialType');}"/>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Specific Material Type">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glSpecificMaterialType" runat="server" Width="170px" AutoGenerateColumns="False" DataSourceID="sdsSpecificMaterial" KeyFieldName="Description" OnLoad="LookupLoad" TextFormatString="{1}" 
                                                                    ClientInstanceName="glSpecificMaterialType">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('FilterRefDoc');}"/>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Reference Number:">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glRefJONumber" runat="server" DataSourceID="sdsRefDoc" SelectionMode="Single" KeyFieldName="DocNumber;Code;WorkCenter" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px" 
                                                                    ClientInstanceName="glRefJONumber" OnInit="glRefJONumber_Init">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="true" AllowSelectByRowClick="true"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" VisibleIndex="0" Width="10px"></dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="WorkCenter" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents ValueChanged="function(s,e){
                                                                         var g = glRefJONumber.GetGridView();
                                                                        cp.PerformCallback('JOStep|'+g.GetRowKey(g.GetFocusedRowIndex()));
                                                                        }" Validation="function(){isValid = true;}" />                                                                    
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Reference JO Step">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtRefJOStep" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="WorkCenter" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtWorkCenter" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Charge">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="cbxCharge" runat="server" ClientInstanceName="cbxCharge" CheckState="Unchecked" OnLoad="CheckBoxLoad">
                                                                    <%--<ClientSideEvents CheckedChanged="checkedchanged"/>--%>
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Replacement">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="cbxReplacement" runat="server" ClientInstanceName="cbxReplacement" CheckState="Unchecked" OnLoad="CheckBoxLoad">
                                                                    <%--<ClientSideEvents CheckedChanged="checkedchanged"/>--%>
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Issued">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="cbxIssued" runat="server" ClientInstanceName="cbxIssued" CheckState="Unchecked" ReadOnly="true">
                                                                    <%--<ClientSideEvents CheckedChanged="checkedchanged"/>--%>
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Complimentary" ColCount="2" Name="ComplimentaryGroup">
                                                <Items>
                                                    <dx:LayoutItem Caption="Complimentary Type:" ColSpan="2" Name="Compliementary Type" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox ID="cmbComplimentaryType" runat="server" OnLoad="ComboBoxLoad" Width="170px" >
                                                                    <Items>
                                                                        <dx:ListEditItem Text="Pre-Approved" Value="Pre-Approved" />
                                                                        <dx:ListEditItem Text="Others" Value="Others" />
                                                                    </Items>
                                                                    <CLientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('CompType'); e.processOnServer = false;}"/>
                                                                     <ValidationSettings Display="None" ValidateOnLeave="False" ErrorDisplayMode="ImageWithTooltip" >
                                                                <RequiredField IsRequired="True"/>
                                                                           <ErrorImage ToolTip="Type is required">
                                                                            </ErrorImage>
                                                                      </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%--ADDED NEW--%>
                                                    <%--<dx:LayoutItem Caption="Reference Document">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtRefDoc" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                    
                                                     <dx:LayoutItem Caption="Reference Document">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glRefDoc" runat="server" DataSourceID="sdsXDeal" SelectionMode="Single" 
                                                                    KeyFieldName="DocNumber" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px" 
                                                                    ClientInstanceName="glRefDoc" >
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="true" AllowSelectByRowClick="true"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" VisibleIndex="0" Width="10px"></dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                             <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="DocDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                             <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="ContractPeriodFrom" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                             <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="ContractPeriodTo" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                             <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Recipient" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                             <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>                                                             
                                                                </dx:ASPxGridLookup>
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
                                              <dx:LayoutItem Caption="Manual Closed By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtclosedby" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                              <dx:LayoutItem Caption="Manual Closed Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtcloseddate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Authorized By" Name="authby">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAuthorizedBy" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Authorized Date" Name="authdate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAuthorizedDate" runat="server" Width="170px" ReadOnly="true">
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
                                                                <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Width="1200px" ClientInstanceName="gvRef" OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  Init="OnInitTrans" />
                                                                    
                                                                    <SettingsPager PageSize="5">
                                                                    </SettingsPager>
                                                                    <SettingsEditing Mode="Batch">
                                                                    </SettingsEditing>
                                                                    <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Width="0px">
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
                             
                            <dx:LayoutGroup Caption="Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False"  Width="770px"
                                                    ClientInstanceName="gv1" OnBatchUpdate="gv1_BatchUpdate"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    OnInit="gv1_Init" OnRowValidating="grid_RowValidating" KeyFieldName="LineNumber">
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" 
                                                        CustomButtonClick="OnCustomClick" BatchEditRowValidating="Grid_BatchEditRowValidating"/>
                                                    <SettingsPager Mode="ShowAllRecords" />  
                                                    <SettingsEditing Mode="Batch"/>
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" VisibleIndex="0" Width="0px">
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
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="CloneButton" Text="Copy">
                                                                    <Image IconID="edit_copy_16x16" ToolTip="Clone"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="100px" ReadOnly="true" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="3" Name="glpItemCode" Width="200px" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">                                                            
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" OnInit="glItemCode_Init"  
                                                                    DataSourceID="sdsItem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="200px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" Settings-VerticalScrollBarMode="Visible"> 
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True"/>
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                       <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  DropDown="lookup" 
                                                                        EndCallback="GridEnd"/>
                                                                   <%-- <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  DropDown="function(s,e){gl.GetGridView().PerformCallback(); e.processOnServer = false;}"
                                                                         ValueChanged="function(s,e){
                                                                        if(itemc != gl.GetValue()){  
                                                                          loader.SetText('Loading...');
                                                                                      loader.Show();
                                                                        gl2.GetGridView().PerformCallback('ItemCode' + '|' + gl.GetValue() + '|' + 'code');
                                                                        e.processOnServer = false;
                                                                        valchange = true;}
                                                                        
                                                                        }" />--%>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn  FieldName="FullDesc" VisibleIndex="4" Width="300px" Name="FullDesc" Caption="Item Description" ReadOnly="True" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="5" Width="100px" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2"   KeyFieldName="ColorCode"
                                                                   OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents valuechanged="gridLookup_CloseUp" DropDown="function dropdown(s, e){
                                                                gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ShowInCustomizationForm="True" VisibleIndex="6" Width="100px" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl3" KeyFieldName="ClassCode" OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="function dropdown(s, e){
                                                                gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" ValueChanged="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Name="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Width="100px" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl4" KeyFieldName="SizeCode" OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents ValueChanged="gridLookup_CloseUp" DropDown="function dropdown(s, e){
                                                                gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Unit" Name="Unit" ShowInCustomizationForm="True" VisibleIndex="8" Width="100px" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"  ClientInstanceName="gl5"  KeyFieldName="Unit" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitBase" ReadOnly="True" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="function dropdown(s, e){
                                                                    gl5.GetGridView().PerformCallback('UnitBase' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                    }" CloseUp="gridLookup_CloseUp" />
                                                                   <%-- <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="gridLookup_CloseUp" />--%>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="ItemPrice" Name="ItemPrice" ShowInCustomizationForm="True" VisibleIndex="9" Caption="ItemPrice" UnboundType="Decimal" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" ClientInstanceName="glItemPrice" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" Width="100px">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate"></ClientSideEvents>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="RequestedQty" Name="RequestedQty" ShowInCustomizationForm="True" VisibleIndex="10" Caption="Requested Qty"  UnboundType="Decimal" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" ClientInstanceName="txtRequestedQty" NullText="0.00"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" Width="100px" MaxValue="2147483647">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate"></ClientSideEvents>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="RequestedBulkQty" Name="RequestedBulkQty" ShowInCustomizationForm="True" VisibleIndex="11" Caption="Requested Bulk Qty" UnboundType="Decimal" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" >
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" ClientInstanceName="txtRequestedBulkQty" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" Width="100px" MaxValue="2147483647">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate1"></ClientSideEvents>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="RequestedBulkUnit" ShowInCustomizationForm="True" VisibleIndex="12" Width="100px" UnboundType="String" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glRequestedBulkUnit" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnLoad="gvLookupLoad"
                                                                    DataSourceID="sdsRequestedBulkUnit" KeyFieldName="UnitBulk" ClientInstanceName="glRequestedBulkUnit1" TextFormatString="{0}" Width="100px"  >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitBulk" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="2" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="IssuedQty" Name="IssuedQty" ShowInCustomizationForm="True"  HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"  VisibleIndex="13" Caption="Issued Qty" UnboundType="Decimal">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" ClientInstanceName="txtIssuedQty" NullText="0.0000"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" Width="100px">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate"></ClientSideEvents>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="ReturnedQty" Name="ReturnedQty" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"  ShowInCustomizationForm="True" VisibleIndex="14" Caption="Returned Qty" UnboundType="Decimal">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" ClientInstanceName="txtReturnedQty" NullText="0.0000"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" Width="100px">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate"></ClientSideEvents>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="ReturnedBulkQty" Name="ReturnedBulkQty" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"   ShowInCustomizationForm="True" VisibleIndex="15" Caption="Returned Bulk Qty"  UnboundType="Decimal">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" ClientInstanceName="txtReturnedBulkQty" NullText="0.0000"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" Width="100px">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate"></ClientSideEvents>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        
                                                        <dx:GridViewDataSpinEditColumn FieldName="Cost" Name="Cost" HeaderStyle-HorizontalAlign="Center"  ShowInCustomizationForm="True" VisibleIndex="16" Caption="Cost" UnboundType="Decimal" Width="0px">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" Width="100px" ClientInstanceName="txtCost">
                                                                <SpinButtons ShowIncrementButtons="False" ></SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate"></ClientSideEvents>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataDateColumn FieldName="ExpDate" Name="dtpExpDate" ShowInCustomizationForm="True" VisibleIndex="20">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn FieldName="MfgDate" Name="dtpMfgDate" ShowInCustomizationForm="True" VisibleIndex="21">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BatchNo" Name="txtBatchNo" ShowInCustomizationForm="True" VisibleIndex="22">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LotNo" Name="txtLotNo" ShowInCustomizationForm="True" VisibleIndex="23">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1"  HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"   ShowInCustomizationForm="True" VisibleIndex="24" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2"  HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"   ShowInCustomizationForm="True" VisibleIndex="25" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3"  HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"   ShowInCustomizationForm="True" VisibleIndex="26" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4"  HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"   ShowInCustomizationForm="True" VisibleIndex="27" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"   ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6"  HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"    ShowInCustomizationForm="True" VisibleIndex="29" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7"  HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"    ShowInCustomizationForm="True" VisibleIndex="30" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8"  HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"   ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9"  HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"   ShowInCustomizationForm="True" VisibleIndex="32" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Version" Name="glpVersion"  HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center"   Caption="Version" ShowInCustomizationForm="True" VisibleIndex="33" Width="0px"  UnboundType="String">
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
                    <dx:ASPxPopupControl ID="DeleteControl"   usesubmitbehavior="false" runat="server" Width="250px" Height="100px" HeaderText="Warning!"
                    CloseAction="CloseButton" CloseOnEscape="True" Modal="True" ClientInstanceName="DeleteControl"
                    PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server"  usesubmitbehavior="false">
                                <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Are you sure you want to delete this specific document?" />
                                <table>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                     <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok"  usesubmitbehavior="false">
                                         <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                         </dx:ASPxButton>
                                         </td>
                                     <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" usesubmitbehavior="false">
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
      <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Calculating..."
            ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
    </form>
    <!--#region Region Datasource-->
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.Request" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.Request" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.Request+RequestDetail" SelectMethod="getdetail" UpdateMethod="UpdateRequestDetail" TypeName="Entity.Request+RequestDetail" DeleteMethod="DeleteRequestDetail" InsertMethod="AddRequestDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.Request+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            <asp:QueryStringParameter Name="TransType" QueryStringField="transtype" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Inventory.RequestDetail WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] WHERE ISNULL(IsInactive,0)=0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBizPartnerCus" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT BizPartnerCode, Name FROM Masterfile.BPCustomerInfo WHERE ISNULL(IsInActive,0)=0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.Warehouse WHERE ISNULL([IsInactive],0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsRefSO" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber FROM Sales.SalesOrder WHERE ISNULL(SubmittedBy,'') != '' AND Status IN ('N','P')" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Code, Description FROM IT.GenericLookup WHERE LookUpKey ='DRTYPE'" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSODetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber, RIGHT('00000'+ CAST(ROW_NUMBER() OVER (ORDER BY DocNumber) AS VARCHAR(5)),5) AS LineNumber, DocNumber AS SONumber, ItemCode,FullDesc,ColorCode,ClassCode,SizeCode,ISNULL(OrderQty,0) - ISNULL(DeliveredQty,0) AS DeliveredQty,Unit,BulkQty,BulkUnit,StatusCode,0.00 AS ReturnedQty,SubstituteItem,SubstituteColor,ISNULL(BaseQty,0.00) AS BaseQty,BarcodeNo,ISNULL(UnitFactor,0.0000) AS UnitFactor,Field1,Field2,Field3,Field4,Field5,Field6,Field7,Field8,Field9,'2' AS Version FROM Sales.SalesOrderDetail" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UnitCode AS Unit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBulkUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UnitCode AS BulkUnit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsRefDoc" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT '' AS DocNumber, '' AS Code, '' AS WorkCenter "  OnInit="Connection_Init"></asp:SqlDataSource>
    
    <asp:SqlDataSource ID="sdsTransDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsRequestedBy" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT EmployeeCode, LastName + ', ' + FirstName AS Name, CostCenterCode FROM Masterfile.BPEmployeeInfo WHERE ISNULL(IsInactive,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsMaterialType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT Code AS MaterialCode, Description FROM IT.GenericLookup WHERE LookUpKey = 'JOMATTYPE' ORDER BY Code ASC" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSpecificMaterialType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCostCenter" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT CostCenterCode, Description FROM Accounting.CostCenter WHERE ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSpecificMaterial" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT Code, Description FROM IT.GenericLookup WHERE LookUpKey IN ('JODIRECT','JOINDIRECT')" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsRequestedBulkUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select distinct UnitBulk,Description from Masterfile.Unit a inner join masterfile.Item b ON a.UnitCode = b.UnitBulk " OnInit="Connection_Init"></asp:SqlDataSource>
    <%--ADDED NEW--%>
    <asp:SqlDataSource ID="sdsXDeal" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


