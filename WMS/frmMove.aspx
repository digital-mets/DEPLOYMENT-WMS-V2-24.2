<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmMove.aspx.cs" Inherits="GWL.frmMove" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Move</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 875px; /*Change this whenever needed*/
        }

        .Entry {
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
        }

        .pnl-content {
            text-align: right;
        }

        #frmlayout1_cp_ASPxFormLayout1_PC_0_0_0_5 .dxflCaptionCellSys:first-of-type {
            width: 0px !important;
            min-width: 0px !important;
        }
        .hidden-column {
    display: none;
}
    </style>
    <!--#endregion-->
    <!--#region Region Javascript-->
    <script>
        var isValid = false;
        var counterror = 0;
        var calcVal = 0;
        var qtyEdited = 0;
        var qIndex;
        var updatedvaluesIndex = []
        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var entry = getParameterByName('entry');

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
        var rowIndex, colIndex;
        function InitTrans(s, e) {


            var rowsCount = gv1.GetVisibleRowsOnPage();
            var columnsCount = gv1.GetColumnCount();
            var readOnlyIndexes = gv1.cpReadOnlyColumns;


            ASPxClientUtils.AttachEventToElement(s.GetMainElement(), "keydown", function (event) {
                if (event.keyCode == 13) {

                    if (ASPxClientUtils.IsExists(columnIndex) && ASPxClientUtils.IsExists(rowIndex)) {
                        ASPxClientUtils.PreventEventAndBubble(event);
                        if (rowIndex < rowsCount - 1)
                            rowIndex++;
                        else {
                            rowIndex = 0;
                            if (columnIndex < columnsCount - 1)
                                columnIndex++;
                            else
                                columnIndex = 0;
                            console.log(columnIndex);
                            while (readOnlyIndexes.indexOf(columnIndex) > -1)
                                columnIndex++;
                        }
                        gv1.batchEditApi.StartEdit(rowIndex, columnIndex);
                    }
                }
            });


        }

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


        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            var btnmode = btn.GetText(); //gets text of button
            //gv1.batchEditApi.EndEdit();
            //gv1.CancelEdit();
            if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
                //Sends request to server side
                if (btnmode == "Submit") {
                    cp.PerformCallback("Submit");
                    gv1.CancelEdit();

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

            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }
        }

        function OnConfirm(s, e) {//function upon saving entry
            //console.log(e.requestTriggerID)
            if (e.requestTriggerID === "frmlayout1_cp" || e.requestTriggerID === undefined)//disables confirmation message upon saving.
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {

            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_valmsg);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);

            }

            else {
                if (s.cp_fail) {
                    alert(s.cp_message);
                    delete (s.cp_success);//deletes cache variables' data
                    delete (s.cp_message);
                    delete (s.cp_fail)
                    return;
                }

            }

            if (s.cp_close) {
                if (s.cp_message != null) {
                    alert(s.cp_message);
                    delete (s.cp_message);
                }
                if (glcheck.GetChecked()) {
                    delete (s.cp_close);
                    window.location.reload();
                }
                else {
                    delete (s.cp_close);
                    window.close();//close window if callback successful
                }
            }
            if (s.cp_delete) {
                delete (s.cp_delete);
                DeleteControl.Show();
            }

        }
        var index;
        var index2;
        var valchange = false;
        var valchange2;
        var val;
        var temp;
        var bulkqty;
        var closing;
        var itemc; //variable required for lookup
        var iteme;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var isbusy;
        var editorobj;
        function OnStartEditing(s, e) {//On start edit grid function     
            rowIndex = e.visibleIndex;
            columnIndex = e.focusedColumn.index;
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "NewItemCode");
            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}
            index = e.visibleIndex;
            editorobj = e;
            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }

            if (entry != "V") {


                if (e.focusedColumn.fieldName === "NewItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                }


                if (e.focusedColumn.fieldName === "ItemCode" || e.focusedColumn.fieldName === "FullDesc" || e.focusedColumn.fieldName === "LineNumber"
                    || e.focusedColumn.fieldName === "BulkUnit" || e.focusedColumn.fieldName === "BaseUnit" || e.focusedColumn.fieldName === "NewItemCode"
                    || e.focusedColumn.fieldName === "PalletID" || e.focusedColumn.fieldName === "Location" || e.focusedColumn.fieldName === "BatchNumber"
                    || e.focusedColumn.fieldName === "ExpiryDate" || e.focusedColumn.fieldName === "MfgDate" || e.focusedColumn.fieldName === "RRdate") { //Check the column name
                    e.cancel = true;
                }



            }
        }

        function OnStartEditing1(s, e) {//On start edit grid function     
            rowIndex = e.visibleIndex;
            columnIndex = e.focusedColumn.index;
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];

            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}

            index = e.visibleIndex;
            editorobj = e;
            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }

            if (entry != "V") {

                if (e.focusedColumn.fieldName === "ItemCode" || e.focusedColumn.fieldName === "FullDesc" || e.focusedColumn.fieldName === "LineNumber" || e.focusedColumn.fieldName === "BulkQty"
                    || e.focusedColumn.fieldName === "BulkUnit" || e.focusedColumn.fieldName === "BaseQty" || e.focusedColumn.fieldName === "BaseUnit"
                    || e.focusedColumn.fieldName === "NewItemCode" || e.focusedColumn.fieldName === "NewBulkQty" || e.focusedColumn.fieldName === "NewBulkUnit"
                    || e.focusedColumn.fieldName === "NewBaseQty" || e.focusedColumn.fieldName === "NewBaseUnit" || e.focusedColumn.fieldName === "BatchNo"
                    || e.focusedColumn.fieldName === "PalletID" || e.focusedColumn.fieldName === "Location" || e.focusedColumn.fieldName === "BatchNumber"
                    || e.focusedColumn.fieldName === "ExpiryDate" || e.focusedColumn.fieldName === "MfgDate" || e.focusedColumn.fieldName === "RRdate") { //Check the column name
                    e.cancel = true;
                }

            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            rowIndex = null;
            columnIndex = null;

            var rowV = e.visibleIndex;

            //fromloc value
            //var orig = e.rowValues[11];


            if (currentColumn.fieldName === "NewLocation" || currentColumn.fieldName === "NewPallet" || currentColumn.fieldName === "MoveQty" || currentColumn.fieldName === "MoveKilo") {

                var newValue = ["NewLocation", "NewPallet", "MoveQty", "MoveKilo"]
                var cur = e.rowValues[currentColumn.index];
                var OldValue = ["Location", "PalletID", "BulkQty", "BaseQty"]

                var currentV, OldV;


                for (let a = 0; a <= newValue.length; a++) {
                    currentV = currentColumn.fieldName == newValue[a] ? cur["value"] : s.batchEditApi.GetCellValue(e.visibleIndex, newValue[a]);
                    OldV = s.batchEditApi.GetCellValue(e.visibleIndex, OldValue[a]);

                    if (newValue[a] == "MoveQty" || newValue[a] == "MoveKilo") {
                        if (newValue[a] == "MoveQty") {
                            currentV = parseFloat(currentV).toFixed(2)
                            OldV = parseFloat(OldV).toFixed(2)
                        } else if (newValue[a] == "MoveKilo") {
                            currentV = parseFloat(currentV).toFixed(4)
                            OldV = parseFloat(OldV).toFixed(4)
                        }

                    }
                    //console.log(newValue[a]);
                    //console.log(currentV);
                    //  console.log(OldV);
                    if (currentV !== OldV) {
                        //napalitan
                        if (!(updatedvaluesIndex.includes(e.visibleIndex))) {
                            updatedvaluesIndex.push(e.visibleIndex);

                        }
                        break;

                    } else if (currentV == OldV) {

                        //console.log(newValue.length - 1);
                        if (updatedvaluesIndex.includes(e.visibleIndex) && a == newValue.length - 1) {
                            updatedvaluesIndex = updatedvaluesIndex.filter(index => index !== e.visibleIndex);
                        }
                        else {
                            continue;
                        }
                    }
                }

                //  console.log(currentColumn.fieldName);
                //  console.log(cur);
                //console.log(s.batchEditApi.GetCellValue(e.visibleIndex, "NewLocation"));
                //console.log(s.batchEditApi.GetCellValue(e.visibleIndex, "NewPallet"));
                //console.log(s.batchEditApi.GetCellValue(e.visibleIndex, "MoveQty"));
                //console.log(s.batchEditApi.GetCellValue(e.visibleIndex, "MoveQty"));
                //console.log(updatedvaluesIndex);
            }


            if (currentColumn.fieldName === "NewItemCode") {
                cellInfo.value = gl.GetValue();
                //cellInfo.text = gl.GetText().toUpperCase();
                cellInfo.text = gl.GetText(); // need sa n/a
            }


        }
        var val;
        var temp;
        function GridEnd(s, e) {
            val = s.GetGridView().cp_codes;
            if (val != null) {
                temp = val.split(';');
            }
            if (closing == true) {
                gv1.batchEditApi.EndEdit();
            }


            if (valchange2) {
                valchange2 = false;
                for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, index, column, gv1);
                }
                gv1.batchEditApi.EndEdit();
            }

            if (valchange) {
                valchange = false;
                closing = false;
                for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells2(0, index, column, gv1);
                }
            }
            loader.Hide();
        }

        function lookup(s, e) {
            //setTimeout(function () {
            //    gl.GetGridView().PerformCallback();
            //}, 500);
            //setTimeout(function () {
            if (isSetTextRequired) {//Sets the text during lookup for item code
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
            }
            //}, 500);
        }

        function GridEnd2(s, e) {
            //if (isSetTextRequired) {//Sets the text during lookup for item code
            //    if (itemc == null) {
            //        console.log('itemc:'+itemc);
            //        s.SetText(null);
            //    }
            //    isSetTextRequired = false;
            //}
        }
        function GridEnd3(s, e) {
            var svval = s.cp_calc;
            //console.log(svval);
            //console.log(qtyEdited);
            //console.log(qIndex);
            //Autocalculate the standard items
            if (svval > 0) {
                var total = qtyEdited * svval
                gv1.batchEditApi.SetCellValue(qIndex, 'MoveKilo', total);
            }


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
            if (temp[4] == null || temp[4] == "") {
                temp[4] = 0;
            }
            if (selectedIndex == 0) {

                if (column.fieldName == "ColorCode") {
                    gv1.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                }
                if (column.fieldName == "ClassCode") {
                    gv1.batchEditApi.SetCellValue(index, column.fieldName, temp[1]);
                }
                if (column.fieldName == "SizeCode") {
                    gv1.batchEditApi.SetCellValue(index, column.fieldName, temp[2]);
                }
                if (column.fieldName == "Qty") {
                    gv1.batchEditApi.SetCellValue(index, column.fieldName, temp[4]);
                }
            }
        }

        function ProcessCells2(selectedIndex, focused, column, s) {//Auto calculate qty function :D
            if (val == null) {
                val = ";";
                temp = val.split(';');
            }
            if (temp[0] == null) {
                temp[0] = 0;
            }

            if (selectedIndex == 0) {
                if (column.fieldName == "Qty") {
                    gv1.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                    isbusy = false;
                    gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField("Qty").index);
                }
            }
        }



        //var preventEndEditOnLostFocus = false;

        function gridLookup1_KeyDown(s, e) { //Allows tabbing between gridlookup on details

            isSetTextRequired = false;
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode !== ASPxKey.Tab) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusDownward" : "MoveFocusUpward";
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
            setTimeout(function () {
                gv1.batchEditApi.EndEdit();
            }, 1000);
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                var column = s.GetColumn(i);
                if (column.fieldName == "ColorCode") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
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

        //function getParameterByName(name) {
        //    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        //    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        //        results = regex.exec(location.search);
        //    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        //}
        function OnCustomClick(s, e) {


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
            var height = Math.max(0, document.documentElement.clientHeight);
            gv1.SetWidth(width - 120);
            gv1.SetHeight(height - 290);
            gvd1.SetWidth(width - 120);
            gvd1.SetHeight(height - 290);

            console.log('test');

            //$('frmlayout1_cp_ASPxFormLayout1_PC_0_gv1_col1').css('display', 'none'); 
        }

        //To real Grid
        var arrayGrid = new Array();
        var arrayGrid2 = new Array();
        var arrayGL = new Array();
        var arrayGL2 = new Array();
        var OnConf = false;
        var glText;
        var ValueChanged = false;
        var deleting = false;
        var endcbgrid = false;
        //Function Autobind to GridEnd
        function isInArray(value, array) {
            return array.indexOf(value) > -1;
        }

        function gvExtract_end(s, e) {
            if (endcbgrid) {
                gvExtract.GetSelectedFieldValues('DocNumber;LineNumber;ItemCode;ColorCode;ClassCode;SizeCode;PalletID;ToPalletID;BulkQty;Qty;FromLoc;ToLoc;StatusCode;BatchNumber', OnGetSelectedFieldValues);
                endcbgrid = false;
            }
        }

        function OnGetSelectedFieldValues(selectedValues) {
            //if (selectedValues.length == 0) return;
            //arrayGL.push(glTranslook.GetText().split(';'));
            var item;
            var checkitem;
            for (i = 0; i < selectedValues.length; i++) {
                var s = "";
                for (j = 0; j < selectedValues[i].length; j++) {
                    s = s + selectedValues[i][j] + ";";
                }
                item = s.split(';');
                gv1.AddNewRow();
                getCol(gv1, editorobj, item);
            }
            loader.Hide();
        }

        function getCol(ss, ee, item) {
            for (var i = 0; i < ss.GetColumnsCount(); i++) {
                var column = ss.GetColumn(i);
                if (column.visible == false || column.fieldName == undefined)
                    continue;
                Bindgrid(item, ee, column, ss);
            }
        }

        function Bindgrid(item, e, column, s) {//Clone function :D
            if (column.fieldName == "DocNumber") {
                console.log('here', item[0])
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[0]);
            }
            if (column.fieldName == "LineNumber") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[1]);
            }
            if (column.fieldName == "ItemCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[2]);
            }
            if (column.fieldName == "ColorCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[3]);
            }
            if (column.fieldName == "ClassCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[4]);
            }
            if (column.fieldName == "SizeCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[5]);
            }
            if (column.fieldName == "PalletID") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[6] == 'null' ? null : item[6]);
            }
            if (column.fieldName == "BulkQty") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[8] == 'null' ? null : item[8]);
            }
            if (column.fieldName == "Qty") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[9] == 'null' ? null : item[9]);
            }
            if (column.fieldName == "FromLoc") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[10] == 'null' ? null : item[10]);
            }
            if (column.fieldName == "StatusCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[12] == 'null' ? null : item[12]);
            }
            if (column.fieldName == "BatchNumber") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[13] == 'null' ? null : item[13]);
            }
        }
        function QtyValueChanged(s, e) {
            qtyEdited = s.GetValue();
            qIndex = rowIndex;
            var itemcalc = gv1.batchEditApi.GetCellValue(rowIndex, 'ItemCode');
            gvd1.PerformCallback(`ItemCodeCalc|${itemcalc}`);
        }

        function OnUpdateClick2() {

            //alert("Hello");
            //console.log(updatedvaluesIndex);
            var updatedData = [];
            var dataRe = gv1.batchEditApi.GetRowVisibleIndices();
            for (var h = 0; h < dataRe.length; h++) {

                if (updatedvaluesIndex.includes(h)) {
                    const jsonData = {

                        "DocNumber": txtDocnumber.GetText(),
                        "DocDate": dtpdocdate.GetText(),
                        "WarehouseCode": txtwarehousecode.GetText(),
                        "CustomerC": cmbStorerKey.GetText(),
                        "LineNumber": gv1.batchEditApi.GetCellValue(dataRe[h], "LineNumber"),
                        "ItemCode": gv1.batchEditApi.GetCellValue(dataRe[h], "ItemCode"),
                        "RecordID": null,
                        "BulkQty": gv1.batchEditApi.GetCellValue(dataRe[h], "BulkQty"),
                        "BulkUnit": gv1.batchEditApi.GetCellValue(dataRe[h], "BulkUnit"),
                        "BaseQty": gv1.batchEditApi.GetCellValue(dataRe[h], "BaseQty"),
                        "BaseUnit": gv1.batchEditApi.GetCellValue(dataRe[h], "BaseUnit"),
                        "PalletID": gv1.batchEditApi.GetCellValue(dataRe[h], "PalletID"),
                        "Location": gv1.batchEditApi.GetCellValue(dataRe[h], "Location"),
                        "NewLocation": gv1.batchEditApi.GetCellValue(dataRe[h], "NewLocation"),
                        "NewPallet": gv1.batchEditApi.GetCellValue(dataRe[h], "NewPallet"),
                        "MoveQty": gv1.batchEditApi.GetCellValue(dataRe[h], "MoveQty"),
                        "MoveKilo": gv1.batchEditApi.GetCellValue(dataRe[h], "MoveKilo"),
                        "BatchNumber": gv1.batchEditApi.GetCellValue(dataRe[h], "BatchNumber"),
                        "LotID2": gv1.batchEditApi.GetCellValue(dataRe[h], "LotID2"),
                        "ExpiryDate": gv1.batchEditApi.GetCellValue(dataRe[h], "ExpiryDate"),
                        "MfgDate": gv1.batchEditApi.GetCellValue(dataRe[h], "MfgDate"),
                        "RRdate": gv1.batchEditApi.GetCellValue(dataRe[h], "RRdate")

                    };
                    updatedData.push(jsonData);
                }
            }

            //console.log(updatedvaluesIndex)

            if (updatedvaluesIndex.length > 0) {
                $.ajax({
                    type: 'POST',
                    url: "frmMove.aspx/MovePallet",
                    contentType: "application/json",
                    data: '{ _movePallets: ' + JSON.stringify(updatedData) + '}',
                    dataType: "json",
                    success: function (data) {

                        if (data.d != '') {
                            //console.log('eee');
                            //ChargesPop.Hide();
                            alert("ERROR : " + data.d);
                        }

                        else {
                            //console.log('wwww');
                            //ChargesPop.Hide();
                            alert("SUCCESS : Submitted Successfully!")
                            window.location.reload();
                            updatedvaluesIndex = []
                        }
                    }
                });

            } else {

                alert('No Value/s Changed!');

            }

        }
    </script>
    <!--#endregion-->
</head>
<body style="height: 475px">
    <% if (DesignMode)
        { %>
    <script src="~/js/ASPxScriptIntelliSense.js" type="text/javascript"></script>
    <% } %>
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" ID="ASPxLabel" Text="Move" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>

        <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="True"
            EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Modal="True" ContentStyle-HorizontalAlign="Center">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents CloseUp="function (s, e) { cp.PerformCallback('refgrid'); }" />
        </dx:ASPxPopupControl>
        <%--  --%>
        <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="400px" Width="1280px" Style="margin-left: -3px">
            <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
            <Items>
                <dx:LayoutItem Caption="">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="200px" ClientInstanceName="cp" OnCallback="cp_Callback">
                                <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
                                <PanelCollection>
                                    <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                        <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" Height="300px" Width="1280px" Style="margin-left: -3px">
                                            <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                                            <Items>
                                                <dx:TabbedLayoutGroup>
                                                    <Items>
                                                        <dx:LayoutGroup Caption="Inventory Inquiry" ColCount="3">
                                                            <Items>

                                                                <dx:LayoutItem Caption="Warehouse Code:" Name="WarehouseCode">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxGridLookup ID="txtwarehousecode" runat="server" ClientInstanceName="txtwarehousecode" AutoGenerateColumns="True" Width="170px" DataSourceID="Warehouse" OnLoad="LookupLoad" TextFormatString="{0}" KeyFieldName="WarehouseCode">
                                                                                <GridViewProperties>
                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                    <Settings ShowFilterRow="True"></Settings>
                                                                                </GridViewProperties>
                                                                                <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                   cp.PerformCallback('wh');
                                                                   e.processOnServer = false;
                                                                }" />
                                                                                <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                    <ErrorImage ToolTip="Supplier is required">
                                                                                    </ErrorImage>
                                                                                    <RequiredField IsRequired="True" />
                                                                                </ValidationSettings>
                                                                                <InvalidStyle BackColor="Pink">
                                                                                </InvalidStyle>
                                                                            </dx:ASPxGridLookup>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>


                                                                <dx:LayoutItem Caption="Document Number:" Name="DocNumber">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtDocnumber"  ClientInstanceName="txtDocnumber" runat="server" Width="170px" ReadOnly="true">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Document Date:" Name="DocDate" ColSpan="1">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxDateEdit ID="dtpdocdate" ClientInstanceName="dtpdocdate"  runat="server" Width="170px" OnLoad="Date_Load">
                                                                                <ClientSideEvents Validation="OnValidation" Init="function(s,e){ s.SetDate(new Date());}" />
                                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                                    <RequiredField IsRequired="True" />
                                                                                </ValidationSettings>
                                                                                <InvalidStyle BackColor="Pink">
                                                                                </InvalidStyle>
                                                                            </dx:ASPxDateEdit>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>

                                                                </dx:LayoutItem>


                                                                <dx:EmptyLayoutItem>
                                                                </dx:EmptyLayoutItem>
                                                                <dx:EmptyLayoutItem>
                                                                </dx:EmptyLayoutItem>
                                                                <dx:LayoutItem Caption="">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxRoundPanel ID="rpFilter" runat="server" Width="200px" HeaderText=" " ShowHeader="false">
                                                                                <PanelCollection>
                                                                                    <dx:PanelContent runat="server">
                                                                                        <table>
                                                                                            <tr align="left">
                                                                                                <%--<td>
                                                                                <dx:ASPxLabel ID="lblLot" runat="server" Text="Lot:">
                                                                                </dx:ASPxLabel>
                                                                            </td>--%>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="" Width="50px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel ID="lblCustomer" runat="server" Text="Customer:">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="RR Doc:">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel ID="lblItem" runat="server" Text="Item Code:">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel ID="lblBatch" runat="server" Text="Batch:">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel ID="lblLocation" runat="server" Text="Location:">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel ID="lblPallet" runat="server" Text="Pallet:">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <%--<td>
                                                                                <dx:ASPxTextBox ID="txtLot" runat="server" Width="170px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>--%>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="Filter:" Width="50px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxGridLookup ID="cmbStorerKey" runat="server"  ClientInstanceName="cmbStorerKey"  Width="170px" AutoGenerateColumns="False" DataSourceID="StorerKey" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                                                        <GridViewProperties>
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                                            <Settings ShowFilterRow="True"></Settings>
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                                            </dx:GridViewDataTextColumn>

                                                                                                        </Columns>
                                                                                                        <ClientSideEvents ValueChanged="function(s,e){cp.PerformCallback('customer');}" />
                                                                                                        <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                                            <ErrorImage ToolTip="Customer is required">
                                                                                                            </ErrorImage>
                                                                                                            <RequiredField IsRequired="True" />
                                                                                                        </ValidationSettings>
                                                                                                        <InvalidStyle BackColor="Pink">
                                                                                                        </InvalidStyle>
                                                                                                    </dx:ASPxGridLookup>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxGridLookup ID="txtRRDocno" ClientInstanceName="txtRRDocno" runat="server" Width="170px" AutoGenerateColumns="False" DataSourceID="Inbound" KeyFieldName="Docnumber" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                                                        <GridViewProperties>
                                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                                            <Settings ShowFilterRow="True"></Settings>
                                                                                                        </GridViewProperties>
                                                                                                        <Columns>
                                                                                                            <dx:GridViewDataTextColumn FieldName="Docnumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>
                                                                                                            <dx:GridViewDataTextColumn FieldName="CustomerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                            </dx:GridViewDataTextColumn>

                                                                                                        </Columns>
                                                                                                        <ClientSideEvents DropDown="function(s,e){
                                                                                                    s.SetText(s.GetInputElement().value);
                                                                                                  }" />
                                                                                                    </dx:ASPxGridLookup>

                                                                                                </td>

                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtItem" runat="server" Width="170px">
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtBatchFil" runat="server" Width="170px">
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtLocation" runat="server" Width="170px">
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxTextBox ID="txtPalletID" runat="server" Width="170px">
                                                                                                    </dx:ASPxTextBox>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                                <td>

                                                                                                    <dx:ASPxButton ID="btnSearch" runat="server" Text="Search" AutoPostBack="false" UseSubmitBehavior="false" BackColor="CornflowerBlue" ForeColor="White">
                                                                                                        <ClientSideEvents Click="function(s, e) { endcbgrid = true; //loader.Show(); 
                                                                                       loader.SetText('Searching...'); 
                                                                                       //gvExtract.PerformCallback('Pal');
                                                                                        updatedvaluesIndex = [];
                                                                                       gv1.PerformCallback();
                                                                                       }" />

                                                                                                    </dx:ASPxButton>

                                                                                                </td>
                                                                                                <td>
                                                                                                    <dx:ASPxLabel Text="" runat="server" Width="200px">
                                                                                                    </dx:ASPxLabel>
                                                                                                </td>
                                                                                            </tr>

                                                                                        </table>
                                                                                    </dx:PanelContent>
                                                                                </PanelCollection>
                                                                            </dx:ASPxRoundPanel>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>


                                                            </Items>

                                                            <Items>

                                                                <dx:LayoutGroup Caption="Inventory Detail">
                                                                    <Items>
                                                                        <dx:LayoutItem Caption="">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="1110px" SettingsBehavior-AllowSort="false" OnCustomCallback="gv1_CustomCallback"
                                                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                                                        OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber;PalletID" ClientSideEvents-Init="InitTrans" >
                                                                                        <ClientSideEvents Init="OnInitTrans" />
                                                                                      
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="TransType" Width="0px" 
                                                                                                VisibleIndex="0">
                                                                                                
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="DocDate" VisibleIndex="0"  Width="0px">
                                                                                              
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="WHCode" Width="0px"
                                                                                                VisibleIndex="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="CustCode"  Width="0px"
                                                                                                VisibleIndex="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <%--<dx:GridViewDataTextColumn FieldName="Storage" Width="0px"
                                                            VisibleIndex="0">
                                                            VisibleIndex="0">
                                                        </dx:GridViewDataTextColumn>

                                                         <dx:GridViewDataTextColumn FieldName="ToStorage" Width="0px"
                                                            VisibleIndex="0">
                                                        </dx:GridViewDataTextColumn>--%>

                                                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Width="0px" VisibleIndex="0">
                                                                                            </dx:GridViewDataTextColumn>

                                                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="1" Caption="RecordID" ReadOnly="True" Width="70px">
                                                                                            </dx:GridViewDataTextColumn>


                                                                                            <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="2" Width="120px" Name="glItemCode">
                                                                                            </dx:GridViewDataTextColumn>

                                                                                            <dx:GridViewDataTextColumn FieldName="FullDesc" Caption="Description" VisibleIndex="3" Width="150px">

                                                                                            </dx:GridViewDataTextColumn>


                                                                                            <dx:GridViewDataSpinEditColumn Caption="Qty" FieldName="BulkQty" VisibleIndex="4" Width="90px" ShowInCustomizationForm="True">
                                                                                                <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N4}"
                                                                                                    ClientInstanceName="gBulkQty" MinValue="0">
                                                                                                    <ClientSideEvents Init="InitTrans" />
                                                                                                </PropertiesSpinEdit>
                                                                                            </dx:GridViewDataSpinEditColumn>


                                                                                            <dx:GridViewDataTextColumn FieldName="BulkUnit" VisibleIndex="5" Width="100px">
                                                                                            </dx:GridViewDataTextColumn>

                                                                                            <dx:GridViewDataSpinEditColumn Caption="Kilo" FieldName="BaseQty" VisibleIndex="6"  Width="90px">
                                                                                                <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N4}"
                                                                                                    MinValue="0">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>
                                                                                            </dx:GridViewDataSpinEditColumn>

                                                                                            <dx:GridViewDataTextColumn FieldName="BaseUnit" VisibleIndex="7" Width="100px">
                                                                                            </dx:GridViewDataTextColumn>

                                                                                            <%--<dx:GridViewDataTextColumn  FieldName="NewItemCode" VisibleIndex="8" Width="120px" Name="glItemCode" CellStyle-BackColor="#99ccff">
                                                       </dx:GridViewDataTextColumn>--%>





                                                                                            <dx:GridViewDataTextColumn FieldName="PalletID" VisibleIndex="10" Width="100px">
                                                                                            </dx:GridViewDataTextColumn>

                                                                                            <dx:GridViewDataTextColumn FieldName="Location" VisibleIndex="10" Width="100px">
                                                                                            </dx:GridViewDataTextColumn>


                                                                                            <dx:GridViewDataTextColumn FieldName="NewLocation" VisibleIndex="10" Width="100px" CellStyle-BackColor="#99ccff">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="NewPallet" VisibleIndex="10" Width="100px" CellStyle-BackColor="#99ccff">
                                                                                            </dx:GridViewDataTextColumn>

                                                                                            <dx:GridViewDataSpinEditColumn Caption="Move Qty" FieldName="MoveQty" VisibleIndex="11" Width="100px" CellStyle-BackColor="#99ccff">
                                                                                                <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N4}"
                                                                                                    ClientInstanceName="NewBulkQty" MinValue="0">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                    <ClientSideEvents Init="InitTrans" ValueChanged="QtyValueChanged" />
                                                                                                </PropertiesSpinEdit>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn Caption="Move Kilo" FieldName="MoveKilo" VisibleIndex="11" Width="100px" CellStyle-BackColor="#99ccff">
                                                                                                <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N4}"
                                                                                                    MinValue="0">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>
                                                                                            </dx:GridViewDataSpinEditColumn>


                                                                                            <dx:GridViewDataTextColumn Name="BatchNumber" Width="150px" ShowInCustomizationForm="True" VisibleIndex="15" FieldName="BatchNumber" UnboundType="String">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn Caption="LotID" Width="150px" ShowInCustomizationForm="True" VisibleIndex="15" FieldName="LotID2" UnboundType="String">
                                                                                            </dx:GridViewDataTextColumn>

                                                                                            <dx:GridViewDataTextColumn Caption="Expiry Date"  Width="150px" FieldName="ExpiryDate" ShowInCustomizationForm="True" VisibleIndex="16">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn Caption="Manufacturing Date" FieldName="MfgDate" ShowInCustomizationForm="True" VisibleIndex="17"   Width="150px">
                                                                                            </dx:GridViewDataTextColumn>

                                                                                            <dx:GridViewDataTextColumn FieldName="RRdate" ShowInCustomizationForm="True" VisibleIndex="18"   Width="150px">
                                                                                            </dx:GridViewDataTextColumn>








                                                                                        </Columns>
                                                                                        <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                                                        <SettingsPager Mode="ShowAllRecords" />
                                                                                        <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto"  VerticalScrollableHeight="350" />
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


                                                        <dx:LayoutGroup Caption="Transaction Detail" Name="TransactionDetail">
                                                            <Items>
                                                                <dx:LayoutItem Caption="">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxGridView ID="gvd1" runat="server" AutoGenerateColumns="False" Width="608px" KeyFieldName="DocNumber;Linenumber" ClientInstanceName="gvd1" Settings-ShowStatusBar="Hidden"
                                                                                OnCustomCallback="gvd1_CustomCallback">




                                                                                <ClientSideEvents Init="OnInitTrans" EndCallback="GridEnd3" />
                                                                                <Columns>


                                                                                    <dx:GridViewDataTextColumn FieldName="DocNumber" Width="0px"
                                                                                        VisibleIndex="0">
                                                                                    
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="1" Caption="RecordID" ReadOnly="True" >
                                                                                        
                                                                                    </dx:GridViewDataTextColumn>


                                                                                    <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="2" Width="120px">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn FieldName="FullDesc" Caption="Description" VisibleIndex="3" Width="150px">
                                                                                    </dx:GridViewDataTextColumn>


                                                                                    <dx:GridViewDataSpinEditColumn FieldName="Qty" VisibleIndex="4" Width="90px" ShowInCustomizationForm="True">
                                                                                        <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                            ClientInstanceName="gBulkQty" MinValue="0">
                                                                                            <ClientSideEvents Init="InitTrans" />
                                                                                        </PropertiesSpinEdit>
                                                                                    </dx:GridViewDataSpinEditColumn>


                                                                                    <dx:GridViewDataTextColumn FieldName="BulkUnit" VisibleIndex="5" Width="100px">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataSpinEditColumn FieldName="Kilos" VisibleIndex="6" Width="90px">
                                                                                        <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                            MinValue="0">
                                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                        </PropertiesSpinEdit>
                                                                                    </dx:GridViewDataSpinEditColumn>

                                                                                    <dx:GridViewDataTextColumn FieldName="BaseUnit" VisibleIndex="7" Width="100px">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn Caption="New Pallet" FieldName="NewPallet" VisibleIndex="12" Width="100px">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="New Location" FieldName="NewLocation" VisibleIndex="12" Width="100px">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataSpinEditColumn Caption="Move Qty" FieldName="MoveQty" VisibleIndex="9" Width="90px">
                                                                                        <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}">
                                                                                        </PropertiesSpinEdit>
                                                                                    </dx:GridViewDataSpinEditColumn>


                                                                                    <dx:GridViewDataSpinEditColumn Caption="Move Kilo" FieldName="MoveKilos" VisibleIndex="11" Width="90px">
                                                                                        <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                            MinValue="0">
                                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                        </PropertiesSpinEdit>
                                                                                    </dx:GridViewDataSpinEditColumn>



                                                                                    <dx:GridViewDataTextColumn FieldName="PalletID" VisibleIndex="13" Width="100px">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn FieldName="Location" VisibleIndex="14" Width="100px">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn FieldName="BatchNumber" Width="150px" VisibleIndex="15" UnboundType="String">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="LotID" Width="150px" FieldName="LotID1" VisibleIndex="15" UnboundType="String">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn Caption="Expiry Date" FieldName="ExpiryDate" VisibleIndex="16">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="MfgDate" ShowInCustomizationForm="True" VisibleIndex="17" Width="120px">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn FieldName="RRdate" ShowInCustomizationForm="True" VisibleIndex="18" Width="120px">
                                                                                    </dx:GridViewDataTextColumn>


                                                                                </Columns>
                                                                                <SettingsPager Mode="ShowAllRecords" />

                                                                                <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" VerticalScrollableHeight="530" />
                                                                                <ClientSideEvents BatchEditConfirmShowing="OnConfirm"
                                                                                    BatchEditStartEditing="OnStartEditing1" BatchEditEndEditing="OnEndEditing" />
                                                                                <SettingsEditing Mode="Batch" />
                                                                            </dx:ASPxGridView>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                            </Items>
                                                        </dx:LayoutGroup>


                                                        <dx:LayoutGroup Caption="Audit Trail" ColSpan="2" ColCount="2">
                                                            <Items>
                                                                <dx:LayoutItem Caption="Added By:">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtAddedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Added Date:">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtAddedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Last Edited By:">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtLastEditedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Last Edited Date:">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtLastEditedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Submitted By:">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Submitted Date:">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                            </Items>
                                                        </dx:LayoutGroup>
                                                    </Items>
                                                </dx:TabbedLayoutGroup>

                                                <%--                            <dx:LayoutGroup Caption="Lines">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">--%>

                                                <%--</dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>--%>
                                            </Items>
                                        </dx:ASPxFormLayout>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxCallbackPanel>
                        </dx:LayoutItemNestedControlContainer>
                    </LayoutItemNestedControlCollection>
                </dx:LayoutItem>

            </Items>
        </dx:ASPxFormLayout>


        <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <div class="pnl-content">
                        <dx:ASPxCheckBox Style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon submit" CheckState="Unchecked" Width="200px"></dx:ASPxCheckBox>
                        <dx:ASPxButton ID="updateBtn" runat="server" Text="Submit" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                            UseSubmitBehavior="false" CausesValidation="true">
                            <ClientSideEvents Click="OnUpdateClick2" />
                        </dx:ASPxButton>
                    </div>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>



        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Calculating..."
            ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>


        <dx:ASPxPopupControl ID="DeleteControl" runat="server" Width="250px" Height="100px" HeaderText="Warning!"
            CloseAction="CloseButton" CloseOnEscape="True" Modal="True" ClientInstanceName="DeleteControl"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="Are you sure you want to delete this specific document?" />
                    <table>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                    <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                                <td>
                                    <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                        <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                    </dx:ASPxButton>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>

    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>


    <asp:SqlDataSource ID="Inbound" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Docnumber,CustomerCode FROM WMS.Inbound WHERE PutawayDate is not null order by AddedDate Desc " OnInit="Connection_Init"></asp:SqlDataSource>



    <asp:SqlDataSource ID="StorerKey" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BizPartner WHERE (ISNULL(IsInactive, 0) = '0') AND (IsCustomer = '1') " OnInit="Connection_Init"></asp:SqlDataSource>



    <!--#endregion-->
</body>
</html>


