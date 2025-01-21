<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmFGTransferOut.aspx.cs" Inherits="GWL.frmFGTransferOut" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>FG Transfer Out</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%><%--Link to global stylesheet--%>
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

        function DateCheck(s, e) {
            var ddate = Date.parse(dtpDocDate.GetValue());
            var rdate = Date.parse(dtpReceivedDate.GetValue());
            var msg = "";

            if (glType.GetText().toUpperCase() == "DISPATCH") {
                if (ddate > rdate) {
                    msg = "Target received date is lower than document date!";
                }
                console.log("timing")
                if (msg != "" || s.GetText() == "" || e.value == "" || e.value == null) {
                    if (msg != "") {
                        alert(msg);
                    }
                    dtpReceivedDate.SetText("");
                    counterror++;
                    isValid = false;
                }
                else {
                    isValid = true;
                }
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
            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }

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
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        var vatrate = 0;
        var vatdetail1 = 0;
        function gridView_EndCallback(s, e) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);
                delete (s.cp_message);

                if (s.cp_forceclose) {
                    delete (s.cp_forceclose);
                    window.close();
                }
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
                    window.close();
                }
            }

            if (s.cp_delete) {
                delete (cp_delete);
                DeleteControl.Show();
            }
            if (s.cp_refdel != null) {
                gv1.CancelEdit();
                delete (s.cp_refdel);
            }
            if (s.cp_generated) {
                delete (s.cp_generated);

                //START 2020-10-30 RAA Added Code for odsdetail approach
                gv1.CancelEdit();
                var _indices = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < _indices.length; i++) {
                    gv1.DeleteRow(_indices[i]);
                }

           


                var _refindices = gv2.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < _refindices.length; i++) {


                    gv1.AddNewRow();
                    _indices = gv1.batchEditApi.GetRowVisibleIndices();

                    var today = new Date();
                    var str = dtpDocDate.GetValue();
                    var str1 = str.getDay();




                   
                    gv1.batchEditApi.SetCellValue(_indices[0], 'ItemCode', gv2.batchEditApi.GetCellValue(_refindices[i], 'SKUCode'));
                    gv1.batchEditApi.SetCellValue(_indices[0], 'ItemDesc', gv2.batchEditApi.GetCellValue(_refindices[i], 'ItemDescription'));

                        gv1.batchEditApi.SetCellValue(_indices[0], 'OrderQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Orders'));
                        gv1.batchEditApi.SetCellValue(_indices[0], 'TransferredQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Orders'));
                  
                    

                    gv1.batchEditApi.EndEdit();
                    gv1.DeleteRow(-1);

                }
            }
        }

        var index;
        var closing;
        var itemc; //variable required for lookup
        var valchange = false;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var editorobj;
        var evn;
        function OnStartEditing(s, e) {

            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
            evn = e;
            editorobj = e;

            var entry = getParameterByName('entry');
            if (entry != "V" && entry != "D") {

            //    if (glType.GetText().toUpperCase() == "DISPATCH") {
            //        if (e.focusedColumn.fieldName == "ReceivedQty" ||
            //            e.focusedColumn.fieldName == "ReceivedBulkQty")
            //            e.cancel = true;
            //    }
            //    if (glType.GetText().toUpperCase() != "DISPATCH") {
            //        if (e.focusedColumn.fieldName != "ReceivedQty" &&
            //            e.focusedColumn.fieldName != "ReceivedBulkQty")
            //            e.cancel = true;
            //    }
            }
            else {
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
                if (e.focusedColumn.fieldName === "OISNo") {
                    glOISNo.GetInputElement().value = cellInfo.value;
                }
            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            var entry = getParameterByName('entry');

            //if (currentColumn.fieldName === "OISNo") {
            //    cellInfo.value = glOISNo.GetValue();
            //    cellInfo.text = glOISNo.GetText().toUpperCase();
            //}
            //if (currentColumn.fieldName === "ItemCode") {
            //    cellInfo.value = gl.GetValue();
            //    cellInfo.text = gl.GetText().toUpperCase();
            //}
            //if (currentColumn.fieldName === "ColorCode") {
            //    cellInfo.value = gl2.GetValue();
            //    cellInfo.text = gl2.GetText().toUpperCase();
            //}
            //if (currentColumn.fieldName === "ClassCode") {
            //    cellInfo.value = gl3.GetValue();
            //    cellInfo.text = gl3.GetText().toUpperCase();
            //}
            //if (currentColumn.fieldName === "SizeCode") {
            //    cellInfo.value = gl4.GetValue();
            //    cellInfo.text = gl4.GetText().toUpperCase();
            //}
            //if (currentColumn.fieldName === "Unit") {
            //    cellInfo.value = gl5.GetValue();
            //    cellInfo.text = gl5.GetText().toUpperCase();
            //}
            //if (currentColumn.fieldName === "BulkUnit") {
            //    cellInfo.value = gl6.GetValue();
            //    cellInfo.text = gl6.GetText().toUpperCase();
            //}
            //if (currentColumn.fieldName === "IsByBulk") {
            //    cellInfo.value = glIsByBulk.GetValue();
            //}

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

        function Datechange() {

            gv1.CancelEdit();
            var _indices = gv1.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < _indices.length; i++) {
                gv1.DeleteRow(_indices[i]);
            }

            //gv1.AddNewRow();



            //var _refindices = gv2.batchEditApi.GetRowVisibleIndices();
            //for (var i = 0; i < _refindices.length; i++) {


            //    gv1.AddNewRow();
            //    _indices = gv1.batchEditApi.GetRowVisibleIndices();

            //    var today = new Date();
            //    var str = dtpDocDate.GetValue();
            //    var str1 = str.getDay();



            //    console.log(str1);

            //    gv1.batchEditApi.SetCellValue(_indices[0], 'ItemCode', gv2.batchEditApi.GetCellValue(_refindices[i], 'SKUCode'));
            //    gv1.batchEditApi.SetCellValue(_indices[0], 'ItemDesc', gv2.batchEditApi.GetCellValue(_refindices[i], 'ItemDescription'));

            //    if (str1 == 1) {

            //        gv1.batchEditApi.SetCellValue(_indices[0], 'OrderQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day1'));
            //        gv1.batchEditApi.SetCellValue(_indices[0], 'TransferredQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day1'));
            //    }
            //    if (str1 == 2) {

            //        gv1.batchEditApi.SetCellValue(_indices[0], 'OrderQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day2'));
            //        gv1.batchEditApi.SetCellValue(_indices[0], 'TransferredQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day2'));
            //    }
            //    if (str1 == 3) {

            //        gv1.batchEditApi.SetCellValue(_indices[0], 'OrderQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day3'));
            //        gv1.batchEditApi.SetCellValue(_indices[0], 'TransferredQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day3'));
            //    }
            //    if (str1 == 4) {

            //        gv1.batchEditApi.SetCellValue(_indices[0], 'OrderQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day4'));
            //        gv1.batchEditApi.SetCellValue(_indices[0], 'TransferredQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day4'));
            //    }
            //    if (str1 == 5) {

            //        gv1.batchEditApi.SetCellValue(_indices[0], 'OrderQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day5'));
            //        gv1.batchEditApi.SetCellValue(_indices[0], 'TransferredQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day5'));
            //    }
            //    if (str1 == 6) {

            //        gv1.batchEditApi.SetCellValue(_indices[0], 'OrderQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day6'));
            //        gv1.batchEditApi.SetCellValue(_indices[0], 'TransferredQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day6'));
            //    }
            //    if (str1 == 7) {

            //        gv1.batchEditApi.SetCellValue(_indices[0], 'OrderQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day7'));
            //        gv1.batchEditApi.SetCellValue(_indices[0], 'TransferredQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'Day7'));
            //    }



            //    gv1.batchEditApi.EndEdit();
            //    gv1.DeleteRow(-1);
            //}
        }
        var val;
        var temp;
        function ProcessCells(selectedIndex, e, column, s) {
            if (val == null) {
                val = ";;;;;";
                temp = val.split(';');
            }
            temp = val.split(';');
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
            }
        }

        function GridEnd(s, e) {
            val = s.GetGridView().cp_codes;
            temp = val.split(';');
            console.log(val + ' valpota')


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
        }

        function lookup(s, e) {
            if (isSetTextRequired) {
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
            }
        }

        function gridLookup_KeyDown(s, e) {
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
        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                if (glType.GetText().toUpperCase() == 'DISPATCH') {
                    var Warehouse = glWarehouseFr.GetText()
                }
                else {
                    var Warehouse = glWarehouseTo.GetText();
                }

                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode + '&colorcode=' + colorcode
                                    + '&classcode=' + classcode + '&sizecode=' + sizecode + '&Warehouse=' + Warehouse);
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
            }
            if (e.buttonID == "ViewReferenceTransaction") {
                var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
                var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
                var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
                window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
            }
            if (e.buttonID == "CountSheet") {
                CSheet.Show();
                var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
                var docnumber = getParameterByName('docnumber');
                var transtype = getParameterByName('transtype');
                //var refdocnum = glDispatchNumber.GetText();
                var refdocnum = "";
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var expdate = s.batchEditApi.GetCellValue(e.visibleIndex, "ExpDate");
                var mfgdate = s.batchEditApi.GetCellValue(e.visibleIndex, "MfgDate");
                var batchno = s.batchEditApi.GetCellValue(e.visibleIndex, "BatchNo");
                var lotno = s.batchEditApi.GetCellValue(e.visibleIndex, "LotNo");
                var docdate = dtpDocDate.GetText();
                console.log(itemcode);
                if (glType.GetText().toUpperCase() == 'DISPATCH') {
                    var Warehouse = glWarehouseFr.GetText()
                    var bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "DispatchBulkQty");
                }
                else {
                    var Warehouse = glWarehouseTo.GetText();
                    var bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "ReceivedBulkQty");
                }
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

        function convertDate(str) {
            var date = new Date(str),
                mnth = ("0" + (date.getMonth() + 1)).slice(-2),
                day = ("0" + date.getDate()).slice(-2);
            return [date.getFullYear(), mnth, day].join("-");
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

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')', num = this.toFixed(Math.max(0, ~~d));
            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };

        function autocalculate(s, e) {
            var rqty = 0.0000;
            var rtotalqty = 0.0000;
            var rbulkqty = 0.00;
            var rtotalbulkqty = 0.00;

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        if (glType.GetText() == "RECEIVE") {
                            rqty = gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedQty");
                            rbulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedBulkQty");
                        }
                        else {
                            rqty = gv1.batchEditApi.GetCellValue(indicies[i], "DispatchQty");
                            rbulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "DispatchBulkQty");
                        }
                        rtotalqty += rqty;
                        rtotalbulkqty += rbulkqty;
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            if (glType.GetText() == "RECEIVE") {
                                rqty = gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedQty");
                                rbulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedBulkQty");
                            }
                            else {
                                rqty = gv1.batchEditApi.GetCellValue(indicies[i], "DispatchQty");
                                rbulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "DispatchBulkQty");
                            }
                            rtotalqty += rqty;
                            rtotalbulkqty += rbulkqty;
                        }
                    }
                }
                txtTotalQty.SetText(rtotalqty.format(4, 5, ',', '.'));
                txtTotalBulkQty.SetText(rtotalbulkqty.format(2, 3, ',', '.'));
            }, 500);
        }

       





        function Generate(s, e) {
            var prtext = glRefMONum.GetText();
            if (!prtext) { alert('No Tool Accountability to generate!'); return; }
            var generate = confirm("Are you sure you want to generate these Material Order");
            if (generate) {
                cp.PerformCallback('Generate');
                e.processOnServer = false;
            }

        }
    </script>
</head>
<body style="height: 910px;">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
        <PanelCollection>
            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                <dx:ASPxLabel ID="HeaderText" runat="server" Text="FG Transfer Out" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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
                                                    <dx:LayoutItem Caption="Transfer Out Number" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" ReadOnly="True" AutoCompleteType="Disabled" >
                                                                <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Document Date" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnLoad="Date_Load" Width="170px" ClientInstanceName="dtpDocDate" onchange="Datechange()">
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="Datechange"  />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                     <dx:LayoutItem Caption="Reference MO Number" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glRefMONum" runat="server" SelectionMode="Multiple" ClientInstanceName="glRefMONum" Width="170px" DataSourceID="sdsRefMONum" KeyFieldName="DocNumber" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('Type');   e.processOnServer = false;}"/>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    
                                                    <dx:LayoutItem Caption="Picklist Number" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                               <dx:ASPxTextBox ID="txtPicklistNumber" runat="server" Width="170px" AutoCompleteType="Disabled" >
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="" Name="Genereatebtn">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxButton ID="Generatebtn" ClientInstanceName="CINGenerate" runat="server" Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" OnLoad="Generate_Btn" ClientVisible="true" Text="Generate" Theme="MetropolisBlue">
                                                                                        <ClientSideEvents Click="Generate" />
                                                                                    </dx:ASPxButton>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Customer Code" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glCustomer" runat="server" ClientInstanceName="glCustomer" Width="170px" DataSourceID="sdsCustomer" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}">
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
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Warehouse Code" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glWarehouse" runat="server" ClientInstanceName="glWarehouse" Width="170px" DataSourceID="sdsWarehouse" KeyFieldName="WarehouseCode" OnLoad="LookupLoad" TextFormatString="{0}">
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
                                                    </dx:LayoutItem>
                                                    
                                                    <dx:LayoutItem Caption="Remarks" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                               <%-- <dx:ASPxTextBox ID="txtRemarks" runat="server" Width="170px" AutoCompleteType="Disabled" >
                                                                </dx:ASPxTextBox>--%>
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" Width="170px" OnLoad="MemoLoad">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <%-- <dx:LayoutItem Caption="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" Width="170px" OnLoad="MemoLoad">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                    
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Detail">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" ClientInstanceName="gv1" KeyFieldName="DocNumber;LineNumber" OnBatchUpdate="gv1_BatchUpdate" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize" Width="770px">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" Init="OnInitTrans" />
                                                                    <SettingsPager Mode="ShowAllRecords">
                                                                    </SettingsPager>
                                                                    <SettingsEditing Mode="Batch">
                                                                    </SettingsEditing>
                                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="350" VerticalScrollBarMode="Auto" />
                                                                    <SettingsBehavior AllowSort="False" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                       <%-- <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="90px">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                                    <Image IconID="support_info_16x16" ToolTip="Details">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                <dx:GridViewCommandColumnCustomButton ID="CountSheet">
                                                                                    <Image IconID="arrange_withtextwrapping_topleft_16x16" ToolTip="Countsheet">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                                    <Image IconID="actions_cancel_16x16">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                <dx:GridViewCommandColumnCustomButton ID="CloneButton" Text="Copy">
                                                                                    <Image IconID="edit_copy_16x16" ToolTip="Clone">
                                                                                    </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>--%>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" Name="glpItemCode" ShowInCustomizationForm="True" VisibleIndex="4" Width="100px">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" ClientInstanceName="gl" DataSourceID="" KeyFieldName="ItemCode" OnInit="glItemCode_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="200px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true" Settings-VerticalScrollableHeight="150" Settings-VerticalScrollBarMode="Visible" SettingsBehavior-FilterRowMode="Auto">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents DropDown="lookup" EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                                    <%--ValueChanged="function(s,e){
                                                                        if(itemc != gl.GetValue()){
                                                                        gl2.GetGridView().PerformCallback('ItemCode' + '|' + gl.GetValue() + '|' + 'code');
                                                                        e.processOnServer = false;
                                                                        valchange = true;}}"--%>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemDesc" Name="ItemDesc" ShowInCustomizationForm="True" VisibleIndex="5" Width="200px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Order Qty" FieldName="OrderQty" Name="OrderQty" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                            <PropertiesSpinEdit AllowMouseWheel="False" ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" Increment="0" MaxValue="2147483647" NullDisplayText="0.0000" NullText="0.0000" NumberFormat="Custom" Width="100px">
                                                                                <SpinButtons ShowIncrementButtons="False">
                                                                                </SpinButtons>
                                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>

<%--<dx:GridViewBandColumn Name="OrderQ" AllowDragDrop="False" VisibleIndex="19" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="Order" ClientInstanceName="Order" runat="server" Text="Order Qty & Transferred Qty">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>

                                                                        <dx:GridViewBandColumn Name="Day1D" AllowDragDrop="False" VisibleIndex="19" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                        <dx:ASPxLabel ID="Day1D" ClientInstanceName="Day1D" runat="server" Text="">  
                                                                        </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                            
                                                                           <Columns>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Mon Order Qty" FieldName="Day1" Name="Day1" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="100px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="eDay1"  NullDisplayText="0.00" NullText="0.00"> 
                                                                                            
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>
                                                                               <dx:GridViewDataSpinEditColumn Caption="Mon Transferred Qty" FieldName="TDay1" Name="Day1" ShowInCustomizationForm="True" UnboundType="String"  VisibleIndex="20" Width="130px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                                    <PropertiesSpinEdit  ClientInstanceName="eDay1"  NullDisplayText="0.00" NullText="0.00"> 
                                                                                            
                                                                                     </PropertiesSpinEdit>  
                                                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>

                                                                                </dx:GridViewDataSpinEditColumn>
                                                                            </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>



                                                            <dx:GridViewBandColumn Name="Day2D"  AllowDragDrop="False" VisibleIndex="20" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                <HeaderCaptionTemplate>  
                                                                    <dx:ASPxLabel ID="Day2D" ClientInstanceName="Day2D" runat="server" Text="">  
                                                                    </dx:ASPxLabel>  
                                                                </HeaderCaptionTemplate>   
                                                                        <Columns>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Tue Order Qty" FieldName="Day2" Name="Day2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21"  Width="100px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                <PropertiesSpinEdit  ClientInstanceName="eDay2" NullDisplayText="0.00" NullText="0.00"> 
                                                                                        
                                                                                </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Tue Transferred Qty" FieldName="TDay2" Name="Day2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21"  Width="130px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                <PropertiesSpinEdit  ClientInstanceName="eDay2" NullDisplayText="0.00" NullText="0.00"> 
                                                                                        
                                                                                </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                        </Columns>
                                                                        <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                             </dx:GridViewBandColumn>



                                                             <dx:GridViewBandColumn Name="Day3D"  AllowDragDrop="False" VisibleIndex="21" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                            <dx:ASPxLabel ID="Day3D" ClientInstanceName="Day3D" runat="server" Text="">  
                                                                            </dx:ASPxLabel>  
                                                                   </HeaderCaptionTemplate>  
                                                                        <Columns>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Wed Order Qty" FieldName="Day3" Name="Day3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="22" Width="100px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                    <PropertiesSpinEdit  ClientInstanceName="eDay3" NullDisplayText="0.00" NullText="0.00"> 
                                                                                            
                                                                                    </PropertiesSpinEdit>  
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Wed Transferred Qty" FieldName="TDay3" Name="Day3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="22" Width="130px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                    <PropertiesSpinEdit  ClientInstanceName="eDay3" NullDisplayText="0.00" NullText="0.00"> 
                                                                                            
                                                                                    </PropertiesSpinEdit>  
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                        </Columns><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                             </dx:GridViewBandColumn>



                                                             <dx:GridViewBandColumn  Name="Day4D"  AllowDragDrop="False" VisibleIndex="22" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                            <dx:ASPxLabel ID="Day4D" ClientInstanceName="Day4D" runat="server" Text="">  
                                                                            </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                                        <Columns>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Thu Order Qty" FieldName="Day4" Name="Day4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="23" Width="100px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                 <PropertiesSpinEdit  ClientInstanceName="eDay4" NullDisplayText="0.00" NullText="0.00"> 
                                                                                     
                                                                                 </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Thu Transferred Qty" FieldName="TDay4" Name="Day4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="23" Width="130px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                                 <PropertiesSpinEdit  ClientInstanceName="eDay4" NullDisplayText="0.00" NullText="0.00"> 
                                                                                     
                                                                                 </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                    </Columns><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            </dx:GridViewBandColumn>






                                                            <dx:GridViewBandColumn Name="Day5D"  AllowDragDrop="False" VisibleIndex="23" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                                    <HeaderCaptionTemplate>  
                                                                            <dx:ASPxLabel ID="Day5D" ClientInstanceName="Day5D" runat="server" Text="">  
                                                                            </dx:ASPxLabel>  
                                                                    </HeaderCaptionTemplate>  
                                                                        <Columns>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Fri Order Qty" FieldName="Day5" Name="Day5" ShowInCustomizationForm="True"  UnboundType="String" VisibleIndex="24" Width="100px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                            <PropertiesSpinEdit  ClientInstanceName="eDay5" NullDisplayText="0.00" NullText="0.00"> 
                                                                            
                                                                            </PropertiesSpinEdit>  
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Fri Transferred Qty" FieldName="TDay5" Name="Day5" ShowInCustomizationForm="True"  UnboundType="String" VisibleIndex="24" Width="130px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                            <PropertiesSpinEdit  ClientInstanceName="eDay5" NullDisplayText="0.00" NullText="0.00"> 
                                                                            
                                                                            </PropertiesSpinEdit>  
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                </Columns><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                             </dx:GridViewBandColumn>






                                                                <dx:GridViewBandColumn Name="Day6D"  AllowDragDrop="False" VisibleIndex="25" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                            <HeaderCaptionTemplate>  
                                                            <dx:ASPxLabel ID="Day6D" ClientInstanceName="Day6D" runat="server" Text="">  
                                                            </dx:ASPxLabel>  
                                                        </HeaderCaptionTemplate>  
                                                                        <Columns>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Sat Order Qty" FieldName="Day6" Name="Day6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="26" Width="100px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                    <PropertiesSpinEdit  ClientInstanceName="eDay6" NullDisplayText="0.00" NullText="0.00"> 
                                                                    
                                                                    </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Sat Transferred Qty" FieldName="TDay6" Name="Day6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="26" Width="130px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                    <PropertiesSpinEdit  ClientInstanceName="eDay6" NullDisplayText="0.00" NullText="0.00"> 
                                                                    
                                                                    </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                </Columns><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>






                                                                <dx:GridViewBandColumn Name="Day7D"  AllowDragDrop="False"  VisibleIndex="27" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" >
                                                            <HeaderCaptionTemplate>  
                                                            <dx:ASPxLabel ID="Day7D" ClientInstanceName="Day7D" runat="server" Text="">  
                                                            </dx:ASPxLabel>  
                                                        </HeaderCaptionTemplate>  
                                                                        <Columns>
                                                                    <dx:GridViewDataSpinEditColumn Caption="Sun Order Qty" FieldName="Day7" Name="Day7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="28" Width="100px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                    <PropertiesSpinEdit  ClientInstanceName="eDay7" NullDisplayText="0.00" NullText="0.00"> 
                                                                    
                                                                    </PropertiesSpinEdit>  
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                            <dx:GridViewDataSpinEditColumn Caption="Sun Transferred Qty" FieldName="TDay7" Name="Day7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="28" Width="130px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true"><HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                    <PropertiesSpinEdit  ClientInstanceName="eDay7" NullDisplayText="0.00" NullText="0.00"> 
                                                                    
                                                                    </PropertiesSpinEdit>  
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                </Columns>
                                                                    <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                                </dx:GridViewBandColumn>
                            </Columns>
                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                        </dx:GridViewBandColumn>--%>
                                                                                              
                                                                        
                                                                        <dx:GridViewDataSpinEditColumn Caption="Transferred Qty" FieldName="TransferredQty" Name="TransferredQty" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="30">
                                                                            <PropertiesSpinEdit AllowMouseWheel="False" ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" Increment="0" MaxValue="2147483647" NullDisplayText="0.0000" NullText="0.0000" NumberFormat="Custom" Width="100px">
                                                                                <SpinButtons ShowIncrementButtons="False">
                                                                                </SpinButtons>
                                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Remaining Qty" FieldName="RemainingQty" Name="RemainingQty" ShowInCustomizationForm="True" VisibleIndex="31">
                                                                            <PropertiesSpinEdit AllowMouseWheel="False" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" Increment="0" MaxValue="2147483647" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom" Width="100px">
                                                                                <SpinButtons ShowIncrementButtons="False">
                                                                                </SpinButtons>
                                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="32">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="33">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="34">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="35">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="36">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="37">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="38">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="39">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="40">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Version" FieldName="Version" Name="glpVersion" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="33" Width="0px">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>

                                            <dx:LayoutItem ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gv2" runat="server" ClientInstanceName="gv2" AutoGenerateColumns="true" BatchEditStartEditing="OnStartEditing">
                                                                    <SettingsEditing Mode="Batch" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
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
                            <td>
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="False">
                                <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="False">
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
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.FGTransferOut" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.FGTransferOut" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.FGTransferOut+FGTransferOutDetail" SelectMethod="getdetail" UpdateMethod="UpdateFGTransferOutDetail" TypeName="Entity.FGTransferOut+FGTransferOutDetail" DeleteMethod="DeleteFGTransferOutDetail" InsertMethod="AddFGTransferOutDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" DataObjectTypeName="Entity.FGTransferOut+FGTransferOutDetail" SelectMethod="getmodetail" UpdateMethod="UpdateFGTransferOutDetail" TypeName="Entity.FGTransferOut+FGTransferOutDetail" DeleteMethod="DeleteFGTransferOutDetail" InsertMethod="AddFGTransferOutDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="MODocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Inventory.FGTransferOutDetail WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.Warehouse WHERE ISNULL([IsInactive],0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BizPartner WHERE ISNULL([IsInactive],0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsRefMONum" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select MAX(DocNumber) AS DocNumber, MAX(CustomerCode) AS CustomerCode From Production.MaterialOrder where SubmittedBy IS NOT NULL group by WorkWeek, Year" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsMODetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" select A.DocNumber,SKUCode,PackagingType,LineNumber,RecordID,ItemDescription,Day1,Day2,Day3,Day4,Day5,Day6,Day7,BatchWeight, B.Workweek,B.Year, B.SubmittedBy from Production.MaterialOrderDetail A left join Production.MaterialOrder B on A.DocNumber = B.DocNumber where SubmittedBy is not null" OnInit ="Connection_Init"></asp:SqlDataSource>
    <%--<asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.FGTransferOut+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>--%>
    <%-- <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Inventory.FGTransferOutDetail WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] WHERE ISNULL(IsInactive,0)=0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.Warehouse WHERE ISNULL([IsInactive],0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UnitCode AS Unit, Description  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsManualAlloc" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DocNumber from Inventory.ManualAllocation" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSTType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT 'D' AS Type, 'Dispatch' AS Description UNION ALL SELECT 'R' AS TYPE, 'Receive' AS Description" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsAccountType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDispatchNumber" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT A.DocNumber FROM Inventory.FGTransferOut A INNER JOIN Inventory.FGTransferOutDetail B ON A.DocNumber = B.DocNumber WHERE Type = 'D' AND ISNULL(SubmittedBy,'') != '' AND ISNULL(CancelledBy,'') = '' AND B.DispatchQty > B.ReceivedQty" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDispatchCallback" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>--%>
    <!--#endregion-->
</body>
</html>
