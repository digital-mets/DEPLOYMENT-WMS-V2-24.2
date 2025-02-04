<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmItemRelocationModuleOpen.aspx.cs" Inherits="GWL.frmItemRelocationModuleOpen" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>

    <title runat="server" id="txttile"></title>
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
    </style>
    <!--#endregion-->
    <!--#region Region Javascript-->
    <script>
        var isValid = false;
        var counterror = 0;
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
            console.log(e.requestTriggerID)
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
                    e.processOnServer = false;
                    delete (s.cp_success);//deletes cache variables' data
                    delete (s.cp_message);
                    delete (s.cp_fail)
                    return;
                }

            }

            if (s.cp_error != null) {
                alert(s.cp_error);
                delete (s.cp_error);
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
        var originalValue = null
        function OnStartEditing(s, e) {//On start edit grid function     
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
            if (e.focusedColumn.fieldName === "ToLoc") {
                originalValue = e.rowValues[columnIndex].value;
            }
            if (entry != "V") {

                if (e.focusedColumn.fieldName === "ItemCode" || e.focusedColumn.fieldName === "FullDesc" || e.focusedColumn.fieldName === "LineNumber"
                    || e.focusedColumn.fieldName === "PalletID" || e.focusedColumn.fieldName === "Qty" || e.focusedColumn.fieldName === "FromLoc"
                    || e.focusedColumn.fieldName === "BulkQty" || e.focusedColumn.fieldName === "BatchNumber") { //Check the column name
                    e.cancel = true;
                }


              

                if (e.focusedColumn.fieldName === "Qty") {
                    if (isbusy == true) {
                        e.cancel = true;
                    }
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

                if (e.focusedColumn.fieldName === "ItemCode" || e.focusedColumn.fieldName === "FullDesc" || e.focusedColumn.fieldName === "LineNumber"
                    || e.focusedColumn.fieldName === "PalletID" || e.focusedColumn.fieldName === "Qty" || e.focusedColumn.fieldName === "FromLoc"
                    || e.focusedColumn.fieldName === "ToPalletID" || e.focusedColumn.fieldName === "ToLoc"
                    || e.focusedColumn.fieldName === "BulkQty" || e.focusedColumn.fieldName === "BatchNumber" || e.focusedColumn.fieldName === "Field1" || e.focusedColumn.fieldName === "Field2" || e.focusedColumn.fieldName === "Field3") { //Check the column name
                    e.cancel = true;
                }




                if (e.focusedColumn.fieldName === "Qty") {
                    if (isbusy == true) {
                        e.cancel = true;
                    }
                }

            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            //var cellInfo = e.rowValues[currentColumn.index];
            //rowIndex = null;
            //columnIndex = null;


            //console.log(e.visibleIndex);
            var rowIndex = e.visibleIndex;
            var cur = e.rowValues[currentColumn.index];
            //fromloc value
            var orig = e.rowValues[11];
            //console.log(e);

            //console.log(cur);
            //console.log(orig);
            // Compare the old value (originalValue) with the new value (newValue)
            if (orig.value !== cur.value) {
                //console.log("Change detected!");
                if (!(updatedvaluesIndex.includes(e.visibleIndex))) {
                    updatedvaluesIndex.push(rowIndex);
                }

                // You can now execute additional logic for handling the change, like saving the new value
            } else if (orig.value == cur.value) {

                if (updatedvaluesIndex.includes(e.visibleIndex)) {
                    updatedvaluesIndex = updatedvaluesIndex.filter(index => index !== e.visibleIndex);
                }
            }
            //else {
            //    console.log("No change detected.");
            //}

            //console.log(updatedvaluesIndex);


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


        function OnUpdateClick2() {

            //alert("Hello");
            console.log(updatedvaluesIndex);
            var updatedData = [];
            var dataRe = gv1.batchEditApi.GetRowVisibleIndices();
            for (var h = 0; h < dataRe.length; h++) {

                if (updatedvaluesIndex.includes(h)) {
                    const jsonData = {
                        "TransType": "WMSREL",
                        "DocNumber": txtDocnumber.GetText(),
                        "DocDate": dtpdocdate.GetText(),
                        "Customer": cmbStorerKey.GetText(),
                        //"Userid": txtUser.GetText(),
                        "WarehouseC": txtwarehousecode.GetText(),
                        "RecordId": gv1.batchEditApi.GetCellValue(dataRe[h], "RecordId"),
                        "ItemCode": gv1.batchEditApi.GetCellValue(dataRe[h], "ItemCode"),
                        "PalletID": gv1.batchEditApi.GetCellValue(dataRe[h], "PalletID"),
                        "ToPalletID": gv1.batchEditApi.GetCellValue(dataRe[h], "ToPalletID"),
                        "FromLoc": gv1.batchEditApi.GetCellValue(dataRe[h], "FromLoc"),
                        "ToLoc": gv1.batchEditApi.GetCellValue(dataRe[h], "ToLoc"),
                        "Qty": gv1.batchEditApi.GetCellValue(dataRe[h], "Qty"),
                        "BulkQty": gv1.batchEditApi.GetCellValue(dataRe[h], "BulkQty"),
                        "BatchNumber": gv1.batchEditApi.GetCellValue(dataRe[h], "BatchNumber"),
                        "Lottable2": gv1.batchEditApi.GetCellValue(dataRe[h], "Lottable2"),
                        "Field1": gv1.batchEditApi.GetCellValue(dataRe[h], "Field1"),
                        "Field2": gv1.batchEditApi.GetCellValue(dataRe[h], "Field2"),
                        "Field3": gv1.batchEditApi.GetCellValue(dataRe[h], "Field3"),
                    };
                    updatedData.push(jsonData);
                }
            }

            //console.log(updatedvaluesIndex)

            if (updatedvaluesIndex.length > 0) {
                $.ajax({
                    type: 'POST',
                    url: "frmItemRelocationModuleOpen.aspx/RelocatePallet",
                    contentType: "application/json",
                    data: '{ _relocatePallets: ' + JSON.stringify(updatedData) + '}',
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
                    <dx:ASPxLabel runat="server" ID="ASPxLabel" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
            EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents CloseUp="function (s, e) { cp.PerformCallback('refgrid'); }" />
        </dx:ASPxPopupControl>
        <%--  --%>
        <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="200px" Width="1280px" Style="margin-left: -3px">
            <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
            <Items>
                <dx:LayoutItem Caption="">
                    <LayoutItemNestedControlCollection>
                        <dx:LayoutItemNestedControlContainer>
                            <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="200px" ClientInstanceName="cp" OnCallback="cp_Callback">
                                <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
                                <PanelCollection>
                                    <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                        <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" Height="200px" Width="850px " Style="margin-left: -3px; margin-right: 0px;">
                                            <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                                            <Items>
                                                <dx:TabbedLayoutGroup>
                                                    <Items>
                                                        <dx:LayoutGroup Caption="Inventory Inquiry" ColCount="3">
                                                            <Items>
                                                                <dx:LayoutItem Caption="Warehouse Code:" Name="WarehouseCode">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxGridLookup ID="txtwarehousecode" runat="server" AutoGenerateColumns="True" Width="170px"   ClientInstanceName="txtwarehousecode"  DataSourceID="Warehouse" OnLoad="LookupLoad" TextFormatString="{0}" KeyFieldName="WarehouseCode">
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
                                                                            <dx:ASPxTextBox ID="txtDocnumber"   ClientInstanceName ="txtDocnumber" runat="server" Width="170px" ReadOnly="true">
                                                                            </dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Document Date:" Name="DocDate" ColSpan="1">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxDateEdit ID="dtpdocdate"   ClientInstanceName ="dtpdocdate" runat="server" Width="170px" OnLoad="Date_Load">
                                                                                <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                  
                                                                   cp.PerformCallback('DocDate');
                                                                   e.processOnServer = false;
                                                                }" />
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
                                                                                                    <dx:ASPxGridLookup ID="cmbStorerKey" runat="server" Width="170px"  ClientInstanceName ="cmbStorerKey"  AutoGenerateColumns="False" DataSourceID="StorerKey" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}">
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
                                                                                                        <ClientSideEvents Validation="OnValidation" ValueChanged="function(){txtRRDocno.SetValue(null)}" />
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
                                                                                                                                 updatedvaluesIndex= []
                                                                                                                                 //console.log (updatedvaluesIndex);
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
                                                                <dx:LayoutGroup Caption="   il">
                                                                    <Items>
                                                                        <dx:LayoutItem Caption="">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="747px" SettingsBehavior-AllowSort="false" OnCustomCallback="gv1_CustomCallback"
                                                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                                                        OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber;PalletID" ClientSideEvents-Init="InitTrans">
                                                                                        <ClientSideEvents Init="OnInitTrans" />
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="TransType" Width="0px" VisibleIndex="0">
                                                                                              
                                                                                              
                                                                                                
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="DocDate" Width="0px" VisibleIndex="0">
                                                                                              
                                                                                              
                                                                                                
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="WHCode" Width="0px" VisibleIndex="0">
                                                                                              
                                                                                              
                                                                                                
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="CustCode" Width="0px" VisibleIndex="0">
                                                                                              
                                                                                              
                                                                                                
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Storage" Width="0px" VisibleIndex="0">
                                                                                              
                                                                                              
                                                                                                
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Width="0px" VisibleIndex="0">
                                                                                              
                                                                                              
                                                                                                
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Caption="RecordID" ReadOnly="True" Width="70px">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="5" Width="150px" Name="glItemCode">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="FullDesc" Caption="Description" VisibleIndex="8" Width="170px" Name="glFullDesc">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="PalletID" VisibleIndex="9" Width="170px" Caption="PalletID">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="ToPalletID" VisibleIndex="9" Width="120px" Caption="To PalletID" PropertiesTextEdit-ClientSideEvents-Init="InitTrans">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="FromLoc" VisibleIndex="9" Width="120px" Name="FromLoc">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="ToLoc" VisibleIndex="9" Width="120px" Name="ToLoc">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataSpinEditColumn FieldName="Qty" Caption="Kilos" VisibleIndex="9" Width="90px" UnboundType="Decimal">
                                                                                                <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                                    MinValue="0">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataSpinEditColumn FieldName="BulkQty" Caption="Qty" VisibleIndex="9" Width="90px" UnboundType="Decimal">
                                                                                                <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                                    ClientInstanceName="gBulkQty" MinValue="0">
                                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                </PropertiesSpinEdit>
                                                                                            </dx:GridViewDataSpinEditColumn>
                                                                                            <dx:GridViewDataTextColumn Caption="BatchNumber" Name="BatchNumber" Width="120px" ShowInCustomizationForm="True" VisibleIndex="19" FieldName="BatchNumber" UnboundType="String">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn Caption="Expiry Date" FieldName="Field1" ShowInCustomizationForm="True" VisibleIndex="21" ReadOnly="true">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn Caption="MfgDate" FieldName="Field2" ShowInCustomizationForm="True" VisibleIndex="22" ReadOnly="true">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn Caption="RRDate" FieldName="Field3" ShowInCustomizationForm="True" VisibleIndex="23" ReadOnly="true">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn Caption="LotID" Name="Lottable2" Width="120px" ShowInCustomizationForm="True" VisibleIndex="20" FieldName="Lottable2" UnboundType="String" ReadOnly="true">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <%-- <dx:GridViewDataTextColumn Caption="BulkUnit" Name="BulkUnit" ShowInCustomizationForm="True" VisibleIndex="10" FieldName="BulkUnit">
                                                        </dx:GridViewDataTextColumn>--%>
                                                                                            <%--<dx:GridViewDataTextColumn Caption="FromLoc" FieldName="FromLoc" Name="FromLoc" ShowInCustomizationForm="True" VisibleIndex="13">
                                                        </dx:GridViewDataTextColumn>--%>
                                                                                            <%-- <dx:GridViewDataTextColumn Caption="ToLoc" FieldName="ToLoc" Name="ToLoc" ShowInCustomizationForm="True" VisibleIndex="14">
                                                        </dx:GridViewDataTextColumn>--%>
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

                                                        <dx:LayoutGroup Caption="Transaction Detail">
                                                            <Items>
                                                                <dx:LayoutItem Caption="">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                                            <dx:ASPxGridView ID="gvd1" runat="server" AutoGenerateColumns="False" Width="608px" KeyFieldName="DocNumber;Linenumber" ClientInstanceName="gvd1" Settings-ShowStatusBar="Hidden">
                                                                                <ClientSideEvents BatchEditConfirmShowing="OnConfirm"
                                                                                    BatchEditStartEditing="OnStartEditing1" />
                                                                                <SettingsEditing Mode="Batch" />
                                                                                <SettingsPager Mode="ShowAllRecords" />
                                                                                <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Visible" ColumnMinWidth="200" VerticalScrollableHeight="0" />
                                                                                <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />

                                                                                <Columns>
                                                                                    <dx:GridViewDataTextColumn FieldName="DocNumber" Width="0px"
                                                                                        VisibleIndex="0">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Caption="LineNumber" ReadOnly="True" Width="90px">
                                                                                    </dx:GridViewDataTextColumn>


                                                                                    <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="5" Width="150px" Name="glItemCode">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn FieldName="FullDesc" Caption="Description" VisibleIndex="8" Width="150px" Name="glFullDesc">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="PalletID" VisibleIndex="9" Width="150px" Caption="PalletID">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="ToPalletID" VisibleIndex="9" Width="150px" Caption="To PalletID" PropertiesTextEdit-ClientSideEvents-Init="InitTrans">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="FromLoc" VisibleIndex="9" Width="120px" Name="FromLoc">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                    <dx:GridViewDataTextColumn FieldName="ToLoc" VisibleIndex="9" Width="120px" Name="ToLoc">
                                                                                        <EditItemTemplate>
                                                                                        </EditItemTemplate>
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataSpinEditColumn FieldName="Qty" VisibleIndex="9" Width="100px" UnboundType="Decimal">
                                                                                        <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                            MinValue="0">
                                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                        </PropertiesSpinEdit>
                                                                                    </dx:GridViewDataSpinEditColumn>

                                                                                    <dx:GridViewDataSpinEditColumn FieldName="BulkQty" VisibleIndex="9" Width="100px" UnboundType="Decimal">
                                                                                        <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                            ClientInstanceName="gBulkQty" MinValue="0">
                                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                                                        </PropertiesSpinEdit>
                                                                                    </dx:GridViewDataSpinEditColumn>


                                                                                    <dx:GridViewDataTextColumn Caption="BatchNumber" Name="BatchNumber" ShowInCustomizationForm="True" Width="120px" VisibleIndex="10" FieldName="BatchNumber" UnboundType="String">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="LotID" Name="LotNumber" ShowInCustomizationForm="True" Width="120px" VisibleIndex="11" FieldName="LotNumber" UnboundType="String" ReadOnly="true">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="Expiry Date" FieldName="Field1" Width="120px" ShowInCustomizationForm="True" VisibleIndex="12" ReadOnly="true">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="MfgDate" FieldName="Field2" Width="120px" ShowInCustomizationForm="True" VisibleIndex="13" ReadOnly="true">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn Caption="RRDate" FieldName="Field3" Width="120px" ShowInCustomizationForm="True" VisibleIndex="14" ReadOnly="true">
                                                                                    </dx:GridViewDataTextColumn>

                                                                                </Columns>
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
                        <dx:ASPxCheckBox Style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon submit" CheckState="Checked" Width="200px"></dx:ASPxCheckBox>
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


    <asp:SqlDataSource ID="StorerKey" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name, Address, ContactPerson, TIN, ContactNumber, EmailAddress, BusinessAccountCode, AddedDate, AddedBy, LastEditedDate, LastEditedBy, IsInactive, IsCustomer, ActivatedBy, ActivatedDate, DeactivatedBy, DeactivatedDate, Field1, Field2, Field3, Field4, Field5, Field6, Field7, Field8, Field9 FROM Masterfile.BizPartner WHERE (ISNULL(IsInactive, 0) = '0') AND (IsCustomer = '1')" OnInit="Connection_Init"></asp:SqlDataSource>

    <!--#endregion-->
</body>
</html>


