<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmItemAdjustmentOpen.aspx.cs" Inherits="GWL.frmItemAdjustmentOpen" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Item Adjustment</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 750px; /*Change this whenever needed*/
        }

        .Entry {
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
        }

        .dxeButtonEditSys input,
        .dxeTextBoxSys input {
            text-transform: uppercase;
        }

        .pnl-content {
            text-align: right;
        }

        #cp_frmlayout1_PC_0_0_0_6 {
            height: 100px !important;
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
                console.log(s.GetText());
                console.log(e.value);
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

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            console.log(counterror);
            console.log(isValid);
            Statusautocalculate();
            var btnmode = btn.GetText(); //gets text of button
            console.log("keskesa")
            if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
                //Sends request to server side
                console.log("dumdumai")
                if (btnmode == "Submit") {
                    cp.PerformCallback("Submit");
                    gv1.CancelEdit();
                }

            }
            else {
                console.log(this);
                counterror = 0;
                alert('Please check all the fields!');
            }

            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }
        }

        function OnConfirm(s, e) {//function upon saving entry
            console.log(e.requestTriggerID);
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
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

            Statusautocalculate();
        }

        var index;
        var closing;
        var valchange;
        var valchange2;
        var bulkqty;
        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var editorobj;
        function OnStartEditing(s, e) {//On start edit grid function     
            rowIndex = e.visibleIndex;
            columnIndex = e.focusedColumn.index;
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "BulkQty");
            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}
            index = e.visibleIndex;
            editorobj = e;

            console.log(e.focusedColumn.fieldName)
            if (e.focusedColumn.fieldName === "ItemCode" || e.focusedColumn.fieldName === "RecordID"
                || e.focusedColumn.fieldName === "ItemDescription" || e.focusedColumn.fieldName === "PalletNumber"
                || e.focusedColumn.fieldName === "Location" || e.focusedColumn.fieldName === "CurrentQty"
                || e.focusedColumn.fieldName === "CurrentBulkQty" || e.focusedColumn.fieldName === "AdjustedQty"
                || e.focusedColumn.fieldName === "BulkQty" || e.focusedColumn.fieldName === "Unit"
                || e.focusedColumn.fieldName === "BatchNo" || e.focusedColumn.fieldName === "RRDate"
                || e.focusedColumn.fieldName === "ExpiryDate" || e.focusedColumn.fieldName === "Mkfgdate"
                || e.focusedColumn.fieldName === "StorageType" || e.focusedColumn.fieldName === "BulkUnit"
            ) {

                e.cancel = true;
            }




        }

        function OnStartEditing1(s, e) {//On start edit grid function     
            rowIndex = e.visibleIndex;
            columnIndex = e.focusedColumn.index;
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "BulkQty");
            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}
            index = e.visibleIndex;


            e.cancel = true;





        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            rowIndex = null;
            columnIndex = null;

            if (valchange2) {
                valchange2 = false;
                closing = false;
                for (var i = 0; i < s.GetColumnsCount(); i++) {
                    var column = s.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, e, column, s);
                }
            }


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
            if (temp[3] == null || temp[3] == "") {
                temp[3] = "";
            }
            if (temp[4] == null || temp[4] == "") {
                temp[4] = "";
            }
            if (temp[5] == null || temp[5] == "") {
                temp[5] = 0;
            }
            if (selectedIndex == 0) {
                if (column.fieldName == "BulkUnit") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
                }
                if (column.fieldName == "Unit") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
                }
                if (column.fieldName == "Qty") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
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
                s.batchEditApi.SetCellValue(index, "Qty", temp[0]);
            }
        }




        function Statusautocalculate(s, e) {
            OnInitTrans();




            var TargetQty = 0.00;
            var CurrentBulkQty = 0.00;
            var TargetBulkQty = 0.00;
            var CurrentQty = 0.00;
            var Result = 0.00;
            var Result2 = 0.00;
            var arrTrans = [];
            var cntr = 0;
            var holder = 0;
            var txt = "";

            setTimeout(function () {

                var iDetail = gv1.batchEditApi.GetRowVisibleIndices();


                for (var i = 0; i < iDetail.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(iDetail[i])) {

                        CurrentQty = parseFloat(gv1.batchEditApi.GetCellValue(iDetail[i], "CurrentQty"));
                        TargetQty = parseFloat(gv1.batchEditApi.GetCellValue(iDetail[i], "TargetQty")) || 0;
                        Result = TargetQty - CurrentQty;

                        if (Result.toFixed(4) != 0.0000) {
                            gv1.batchEditApi.SetCellValue(iDetail[i], "AdjustedQty", Result.toFixed(4));
                        }

                        CurrentBulkQty = parseFloat(gv1.batchEditApi.GetCellValue(iDetail[i], "CurrentBulkQty"));
                        TargetBulkQty = parseFloat(gv1.batchEditApi.GetCellValue(iDetail[i], "TargetBulkQty")) || 0;
                        Result2 = TargetBulkQty - CurrentBulkQty;

                        if (Result2.toFixed(2) != 0.00) {
                            gv1.batchEditApi.SetCellValue(iDetail[i], "BulkQty", Result2.toFixed(2));
                        }

                    }
                    else {
                        var key = gv1.GetRowKey(iDetail[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) {

                        }
                        else {

                            CurrentQty = parseFloat(gv1.batchEditApi.GetCellValue(iDetail[i], "CurrentQty"));
                            TargetQty = parseFloat(gv1.batchEditApi.GetCellValue(iDetail[i], "TargetQty")) || 0;
                            Result = TargetQty - CurrentQty;

                            if (Result.toFixed(4) != 0.0000) {
                                gv1.batchEditApi.SetCellValue(iDetail[i], "AdjustedQty", Result.toFixed(4));
                            }

                            CurrentBulkQty = parseFloat(gv1.batchEditApi.GetCellValue(iDetail[i], "CurrentBulkQty"));
                            TargetBulkQty = parseFloat(gv1.batchEditApi.GetCellValue(iDetail[i], "TargetBulkQty")) || 0;
                            Result2 = TargetBulkQty - CurrentBulkQty;

                            if (Result2.toFixed(2) != 0.00) {
                                gv1.batchEditApi.SetCellValue(iDetail[i], "BulkQty", Result2.toFixed(2));
                            }


                        }
                    }
                }



            }, 100);
        }

        function GridEnd(s, e) {
            val = s.GetGridView().cp_codes;
            if (val != null) {
                temp = val.split(';');
            }
            if (closing == true) {
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
            if (isSetTextRequired) {//Sets the text during lookup for item code
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
            }
        }

        function rowclick(s, e) {

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
            setTimeout(function () {
                gv1.batchEditApi.EndEdit();
            }, 1000);
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                var column = s.GetColumn(i);
                if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
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
            if (e.buttonID == "CountSheet") {
                if (s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber") == null) {
                    e.cancel = true;
                }
                else {
                    CSheet.Show();
                    var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
                    var docnumber = getParameterByName('docnumber');
                    var transtype = getParameterByName('transtype');
                    var entry = getParameterByName('entry');
                    CSheet.SetContentUrl('frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
                        '&linenumber=' + linenum);
                    console.log('here');
                }
            }
            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate(s, e);

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
            var height = Math.max(0, document.documentElement.clientHeight);
            gvd.SetWidth(width - 120);
            gvd.SetHeight(height - 290);
            gv1.SetWidth(width - 120);
            gv1.SetHeight(height - 290);

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
                gvExtract.GetSelectedFieldValues('RecordId;ItemCode;PalletID;Customer;MfgDate;ExpirationDate;BatchNumber,TargetQty', OnGetSelectedFieldValues);
                endcbgrid = false;
            }
        }

        function isInArray(value, array) {
            return array.indexOf(value) > -1;
        }

        var arrayGrid = [];
        function checkGrid() {
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            var Keyfield;
            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                    Keyfield = gv1.batchEditApi.GetCellValue(indicies[i], "RecordId");
                    arrayGrid.push(Keyfield);
                }
                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        var ss = "";
                    else {
                        Keyfield = gv1.batchEditApi.GetCellValue(indicies[i], "RecordId");
                        arrayGrid.push(Keyfield);
                    }
                }
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
                checkGrid();
                if (isInArray(item[0], arrayGrid))
                    continue;

                gv1.AddNewRow();
                getCol(gv1, editorobj, item);
            }
            arrayGrid = [];
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

        //function Bindgrid(item, e, column, s) {//Clone function :D
        //    if (column.fieldName == "DocNumber") {
        //        console.log('here', item[0])
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[0]);
        //    }
        //    if (column.fieldName == "LineNumber") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[1]);
        //    }
        //    if (column.fieldName == "ItemCode") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[2]);
        //    }
        //    if (column.fieldName == "ColorCode") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[3]);
        //    }
        //    if (column.fieldName == "ClassCode") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[4]);
        //    }
        //    if (column.fieldName == "SizeCode") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[5]);
        //    }
        //    if (column.fieldName == "PalletNumber") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[6] == 'null' ? null : item[6]);
        //    }
        //    if (column.fieldName == "BulkQty") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[8] == 'null' ? null : item[8]);
        //    }
        //    if (column.fieldName == "Qty") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[9] == 'null' ? null : item[9]);
        //    }
        //    if (column.fieldName == "Location") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[10] == 'null' ? null : item[10]);
        //    }
        //    if (column.fieldName == "StatusCode") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[12] == 'null' ? null : item[12]);
        //    }
        //    if (column.fieldName == "Unit") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[13] == 'null' ? null : item[13]);
        //    }
        //    if (column.fieldName == "BulkUnit") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[14] == 'null' ? null : item[14]);
        //    }
        //    if (column.fieldName == "Mkfgdate") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[15] == 'null' ? null : new Date(item[15]));
        //    }
        //    if (column.fieldName == "ExpiryDate") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[16] == 'null' ? null : new Date(item[16]));
        //    }
        //    if (column.fieldName == "BatchNo") {
        //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[17] == 'null' ? null : item[17]);
        //    }

        //}

    </script>
    <!--#endregion-->
</head>
<body style="height: 200px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Item Adjustment" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>


        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="200px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="200px" Width="850px " Style="margin-left: -3px; margin-right: 0px;">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />

                        <Items>
                            <%--<!--#region Region Header --> --%>

                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="Inventory Inquiry" ColCount="3">
                                        <Items>
                                            <dx:LayoutItem Caption="Warehouse Code:" Name="WarehouseCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtwarehousecode" runat="server" Width="170px" DataSourceID="Warehouse" KeyFieldName="WarehouseCode" OnLoad="LookupLoad"
                                                            ClientInstanceName="aglWarehouseCode" TextFormatString="{0}">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date:" Name="DocDate" ColSpan="1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpdocdate" runat="server" Width="170px" OnLoad="Date_Load">
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
                                            <dx:LayoutItem Caption="IsCharged">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chckCharged" ClientInstanceName="chckCharged" runat="server" CheckState="Unchecked">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Remarks:" Name="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="remarksTxtBox" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Reason For Adjustment:" Name="Reason">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtReason" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--   <dx:EmptyLayoutItem>
                                            </dx:EmptyLayoutItem>--%>

                                            <dx:LayoutItem Caption="" CssClass="filterS">
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
                                                                                <dx:ASPxGridLookup ID="cmbStorerKey" runat="server" Width="170px" AutoGenerateColumns="False" DataSourceID="StorerKey" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                                    <GridViewProperties>
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                        <Settings ShowFilterRow="True"></Settings>
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                            <Settings AutoFilterCondition="Contains" />
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
                                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="true" Width="1250px" SettingsBehavior-AllowSort="false"
                                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                                    OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="RecordID" OnCustomCallback="gv1_CustomCallback"  >
                                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>


                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="RecordID" VisibleIndex="2" Visible="true" Width="65px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="3" Width="150px" Name="glItemCode">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemDescription" Caption="Description" VisibleIndex="4" Width="150px" Name="glItemCode">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="PalletNumber" Caption="Pallet ID"  ShowInCustomizationForm="True" VisibleIndex="5" Name="PalletNumber">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Name="Location" ShowInCustomizationForm="True"  VisibleIndex="6" FieldName="Location" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Current Qty" FieldName="CurrentBulkQty" VisibleIndex="7" Width="100px">
                                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                ClientInstanceName="CurrentBulkQty" MinValue="0">
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Target Qty" FieldName="TargetBulkQty" VisibleIndex="8" Width="100px" UnboundType="Decimal" CellStyle-BackColor="#99ccff">
                                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                ClientInstanceName="TargetBulkQty" MinValue="0">
                                                                                <ClientSideEvents ValueChanged="Statusautocalculate" Init="InitTrans" />
                                                                            </PropertiesSpinEdit>
                                                                            <CellStyle BackColor="#99ccff"></CellStyle>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="BulkQty" VisibleIndex="9" Width="110px" Caption="Adjusted Qty">
                                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                ClientInstanceName="gBulkQty" MinValue="0">
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Current Weight" FieldName="CurrentQty" Name="CurrentQty" ShowInCustomizationForm="True" VisibleIndex="10">
                                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CurrentQty" ConvertEmptyStringToNull="False" DisplayFormatString="g" NullDisplayText="0" NullText="0">
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Target Weight" FieldName="TargetQty" Name="TargetQty" ShowInCustomizationForm="True" VisibleIndex="11" CellStyle-BackColor="#99ccff">
                                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="TargetQty" ConvertEmptyStringToNull="False" DisplayFormatString="g" NullDisplayText="0" NullText="0">
                                                                                <ClientSideEvents ValueChanged="Statusautocalculate" Init="InitTrans" />
                                                                            </PropertiesSpinEdit>
                                                                            <CellStyle BackColor="#99ccff"></CellStyle>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Adjustment Weight" FieldName="AdjustedQty" Width="150px" Name="Qty" ShowInCustomizationForm="True" VisibleIndex="12">
                                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="AdjustedQty"  ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N4}">
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Unit" Caption="Unit" Name="Unit" ShowInCustomizationForm="True" VisibleIndex="13">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="BulkUnit" VisibleIndex="14" Name="BulkUnit">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="BatchNo" Name="BatchNo" Width="200px" ShowInCustomizationForm="True" VisibleIndex="15">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LotNo" Name="Lot" ShowInCustomizationForm="True" VisibleIndex="16" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="RR Date" FieldName="RRDate" ShowInCustomizationForm="True" VisibleIndex="17" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Expiry Date" FieldName="ExpiryDate"   ShowInCustomizationForm="True" VisibleIndex="18" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Manufacturing Date" FieldName="Mkfgdate" Width="150px" ShowInCustomizationForm="True" VisibleIndex="18" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="StorageType" Name="StorageType" Width="150px" ShowInCustomizationForm="True" VisibleIndex="19">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field1" Caption="Field1" ShowInCustomizationForm="True" VisibleIndex="20" Name="Field1" CellStyle-BackColor="#99ccff" Width="0px">
                                                                            <CellStyle BackColor="#99ccff"></CellStyle>
                                                                            
                                                                         
                                                                           
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field2" Caption="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="21" UnboundType="Bound" CellStyle-BackColor="#99ccff" Width="0px">
                                                                            <CellStyle BackColor="#99ccff"></CellStyle>
                                                                            
                                                                         
                                                                           
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field3" Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="22" UnboundType="Bound" CellStyle-BackColor="#99ccff" Width="0px">
                                                                            <CellStyle BackColor="#99ccff"></CellStyle>
                                                                            
                                                                         
                                                                           
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field4" Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="23" UnboundType="Bound" CellStyle-BackColor="#99ccff" Width="0px">
                                                                            <CellStyle BackColor="#99ccff"></CellStyle>
                                                                            
                                                                         
                                                                           
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field5" Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="24" UnboundType="Bound" CellStyle-BackColor="#99ccff" Width="0px">
                                                                            <CellStyle BackColor="#99ccff"></CellStyle>
                                                                            
                                                                         
                                                                           
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field6" Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="25" UnboundType="Bound" CellStyle-BackColor="#99ccff" Width="0px">
                                                                            <CellStyle BackColor="#99ccff"></CellStyle>
                                                                            
                                                                         
                                                                           
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field7" Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="26" UnboundType="Bound" CellStyle-BackColor="#99ccff" Width="0px">
                                                                            <CellStyle BackColor="#99ccff"></CellStyle>
                                                                            
                                                                         
                                                                           
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field8" Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="27" UnboundType="Bound" CellStyle-BackColor="#99ccff" Width="0px">
                                                                            <CellStyle BackColor="#99ccff"></CellStyle>
                                                                            
                                                                         
                                                                           
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field9" Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="Bound" CellStyle-BackColor="#99ccff" Width="0px">
                                                                            <CellStyle BackColor="#99ccff"></CellStyle>
                                                                            
                                                                         
                                                                           
                                                                        </dx:GridViewDataTextColumn>

                                                                    </Columns>
                                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Visible"  VerticalScrollableHeight="0" />
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
                                    <dx:LayoutGroup Caption="Transaction Detail" ColCount="3">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvd1" runat="server" AutoGenerateColumns="False" Width="747px"
                                                            OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gvd"
                                                            OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber">

                                                            <ClientSideEvents Init="OnInitTrans" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False"
                                                                    VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="80px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="3" Width="150px" Name="glItemCode">
                                                                    <EditItemTemplate>
                                                                    </EditItemTemplate>
                                                                </dx:GridViewDataTextColumn>

                                                                <dx:GridViewDataTextColumn FieldName="FullDesc" Caption="Description" VisibleIndex="4" Width="150px" Name="glItemCode">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="PalletNumber" ShowInCustomizationForm="True" VisibleIndex="5" Name="PalletNumber" Caption="Pallet ID">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Name="Location" ShowInCustomizationForm="True" VisibleIndex="6" FieldName="Location" UnboundType="String">
                                                                    <EditItemTemplate>
                                                                    </EditItemTemplate>
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="CurrentBulkQty" VisibleIndex="7" Width="100px">
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}" MinValue="0">
                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="TargetBulkQty" VisibleIndex="8" Width="100px">
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}" MinValue="0">
                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="BulkQty" VisibleIndex="9" Width="100px" Caption="Adjusted BulkQty">
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                        ClientInstanceName="gBulkQty" MinValue="0">
                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="CurrentQty" VisibleIndex="10" Width="100px">
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N4}" MinValue="0">
                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="TargetQty" VisibleIndex="11" Width="100px">
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N4}" MinValue="0">
                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn Caption="Adjustment Qty" FieldName="Qty" Name="Qty" ShowInCustomizationForm="True" VisibleIndex="12">
                                                                    <PropertiesSpinEdit Increment="0" ClientInstanceName="txtReturnedQty" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N4}" NullDisplayText="0" NullText="0">
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>


                                                                <dx:GridViewDataTextColumn FieldName="Unit" Caption="Unit" Name="Unit" ShowInCustomizationForm="True" VisibleIndex="13">
                                                                    <EditItemTemplate>
                                                                    </EditItemTemplate>
                                                                </dx:GridViewDataTextColumn>

                                                                <dx:GridViewDataTextColumn FieldName="BulkUnit" VisibleIndex="14" Name="BulkUnit">
                                                                    <EditItemTemplate>
                                                                    </EditItemTemplate>
                                                                </dx:GridViewDataTextColumn>

                                                                <dx:GridViewDataTextColumn FieldName="BatchNo" Name="BatchNo" ShowInCustomizationForm="True" VisibleIndex="15">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Lot" Name="LotNo" ShowInCustomizationForm="True" VisibleIndex="16" ReadOnly="true">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataDateColumn Caption="RR Date" FieldName="RRDate" ShowInCustomizationForm="True" VisibleIndex="17">
                                                                </dx:GridViewDataDateColumn>
                                                                <dx:GridViewDataDateColumn Caption="Expiry Date" FieldName="ExpiryDate" ShowInCustomizationForm="True" VisibleIndex="18">
                                                                </dx:GridViewDataDateColumn>
                                                                <dx:GridViewDataDateColumn Caption="Manufacturing Date" FieldName="Mkfgdate" ShowInCustomizationForm="True" VisibleIndex="19" Width="150px">
                                                                </dx:GridViewDataDateColumn>

                                                                <dx:GridViewDataTextColumn FieldName="StorageType" Name="StorageType" ShowInCustomizationForm="True" VisibleIndex="20">
                                                                    <EditItemTemplate>
                                                                    </EditItemTemplate>
                                                                </dx:GridViewDataTextColumn>



                                                            </Columns>
                                                            <SettingsPager Mode="ShowAllRecords" />

                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="530" />
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
                            <%-- <!--#endregion --> --%>

                            <%--<!--#region Region Details --> --%>



                            <%-- <!--#endregion --> --%>
                        </Items>
                    </dx:ASPxFormLayout>
                    <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                    <dx:ASPxCheckBox Style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px" CheckState="Checked"></dx:ASPxCheckBox>
                                    <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
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
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select '' as Docnumber,'' location ,0 RecordID,'' ItemDescription, '' PalletNumber, 
0.00 CurrentBulkQty, 
0.00 TargetBulkQty, 0 as BulkQty ,
0.00 CurrentQty, 
'' TargetQty, 
0 as AdjustedQty,'' Location,'' ToLoc,'' StatusCode, '' Customer,'' LotID,'' WarehouseCode,'' Unit,'' BulkUnit, '' Mkfgdate,
'' ExpiryDate,'' BatchNo,'' as Lot,'' as RRDate	 FROM  WMS.ItemAdjustmentDetail where Docnumber  is null "
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WareHouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,'')=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="StorerKey" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BizPartner WHERE (ISNULL(IsInactive, 0) = '0') AND (IsCustomer = '1')" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Inbound" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Docnumber,CustomerCode FROM WMS.Inbound WHERE PutawayDate is not null order by AddedDate Desc " OnInit="Connection_Init"></asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


