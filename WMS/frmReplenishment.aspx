<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmReplenishment.aspx.cs" Inherits="GWL.frmReplenishment" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Replenishment</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 500px; /*Change this whenever needed*/
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

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            console.log(counterror);
            console.log(isValid);
            //autocalculate();
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
                    cbacker.PerformCallback("Close");
                }
            }
            else {
                //console.log(this);
                counterror = 0;
                alert('Please check all the fields!');
            }

            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }
        }

        var custchanged = true;
        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {

            if (s.cp_delete == "Loc") {
                delete (s.cp_delete);
            } else {
                if (s.cp_delete) {
                    delete (s.cp_delete);
                    DeleteControl.Show();
                }

                if (s.cp_success) {
                    //alert(s.cp_valmsg);
                    alert(s.cp_message);
                    if (s.cp_message2 != null) {
                        alert(s.cp_message2);
                    }

                    delete (s.cp_valmsg);
                    delete (s.cp_success);//deletes cache variables' data
                    delete (s.cp_message);
                    delete (s.cp_message2);
                }

                else {

                    if (s.cp_close == undefined) {
                        alert(s.cp_message);
                        delete (s.cp_success);//deletes cache variables' data
                        delete (s.cp_message);
                        return;
                    }

                }


                if (s.cp_close) {
                    console.log('nats');
                    if (s.cp_message != null) {
                        alert(s.cp_message);
                        delete (s.cp_message);
                    }
                    if (s.cp_valmsg != null) {
                        alert(s.cp_valmsg);
                        delete (s.cp_valmsg);
                    }
                    if (glcheck.GetChecked()) {
                        delete (s.cp_close);
                        window.location.reload();
                    }
                    else {
                        delete (cp_close);
                        window.close();//close window if callback successful
                    }
                }

            }

            //autocalculate();
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


            if (entry != "V") {
                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                }
                if (e.focusedColumn.fieldName === "ColorCode") {
                    gl2.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "ClassCode") {
                    gl3.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "SizeCode") {
                    gl4.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "BulkUnit") {
                    e.cancel = true;
                    glBulkUnit.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "Unit") {
                    glUnit.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "Location") {
                    glLoc.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "StorageType") {
                    glStorageType.GetInputElement().value = cellInfo.value;
                }
            }

        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "ItemCode") {
                cellInfo.value = gl.GetValue();
                //cellInfo.text = gl.GetText().toUpperCase();
                cellInfo.text = gl.GetText(); // need sa n/a
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
            if (currentColumn.fieldName === "BulkUnit") {
                cellInfo.value = glBulkUnit.GetValue();
                cellInfo.text = glBulkUnit.GetText();
                isSetTextRequired = true;
            }
            if (currentColumn.fieldName === "Unit") {
                cellInfo.value = glUnit.GetValue();
                cellInfo.text = glUnit.GetText();
                isSetTextRequired = true;
            }

            if (currentColumn.fieldName === "LocationCode") {
                cellInfo.value = glLoc.GetValue();
                cellInfo.text = glLoc.GetText().toUpperCase();

            }


            //if (valchange2) {
            //    valchange2 = false;
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
                if (column.fieldName == "ColorCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
                }
                if (column.fieldName == "ClassCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
                }
                if (column.fieldName == "SizeCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
                }
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
        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            setTimeout(function () {
                gv1.batchEditApi.EndEdit();
            }, 500);
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

        function autocalculate(s, e) {
            //console.log(txtNewUnitCost.GetValue());


            OnInitTrans()
            var TotalQuantity1 = 0.00;

            var qty = 0.00;


            setTimeout(function () {

                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                        qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");

                        console.log(qty)
                        //Total Amount of OrderQty
                        TotalQuantity1 += qty * 1.00;          //Sum of all Quantity
                        console.log(TotalQuantity1)
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");

                            TotalQuantity1 += qty * 1.00;          //Sum of all Quantity
                            console.log(TotalQuantity1)
                        }
                    }

                }


                //txtTotalAmount.SetText(TotalAmount.toFixed(2))
                txtTotalQty.SetText(TotalQuantity1.toFixed(2));

            }, 500);
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
            console.log(keyCode);
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
                //if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                //    var cellValidationInfo = e.validationInfo[column.index];
                //    if (!cellValidationInfo) continue;
                //    var value = cellValidationInfo.value;
                //    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = column.fieldName + " is required";
                //        isValid = false;
                //    }
                //    else {
                //        isValid = true;
                //    }
                //}
            }
        }
        //function getParameterByName(name) {
        //    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        //    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        //        results = regex.exec(location.search);
        //    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        //}

        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                //var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                //var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                //var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                //var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                //factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode);
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



        function Bindgrid(item, e, column, s) {//Clone function :D
            //if (column.fieldName == "DocNumber") {
            //    console.log('here', item[0])
            //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[0]);
            //}
            if (column.fieldName == "RecordId") {
                console.log(item[0]);
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[0]);
            }
            if (column.fieldName == "ItemCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[1]);
            }
            //if (column.fieldName == "ColorCode") {
            //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[3]);
            //}
            //if (column.fieldName == "ClassCode") {
            //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[4]);
            //}
            //if (column.fieldName == "SizeCode") {
            //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[5]);
            //}
            if (column.fieldName == "PalletID") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[2] == 'null' ? null : item[2]);
            }
            //if (column.fieldName == "BulkQty") {
            //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[8] == 'null' ? null : item[8]);
            //}
            //if (column.fieldName == "Qty") {
            //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[9] == 'null' ? null : item[9]);
            //}
            //if (column.fieldName == "Location") {
            //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[10] == 'null' ? null : item[10]);
            //}
            //if (column.fieldName == "StatusCode") {
            //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[12] == 'null' ? null : item[12]);
            //}
            //if (column.fieldName == "Unit") {
            //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[13] == 'null' ? null : item[13]);
            //}
            //if (column.fieldName == "BulkUnit") {
            //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[14] == 'null' ? null : item[14]);
            //}
            //if (column.fieldName == "ManufacturingDate") {
            //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[4] == 'null' ? null : new Date(item[4]));
            //}
            //if (column.fieldName == "ExpiryDate") {
            //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[5] == 'null' ? null : new Date(item[5]));
            //}
            if (column.fieldName == "BatchNumber") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[6] == 'null' ? null : item[6]);
            }


        }

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
                    <dx:ASPxLabel runat="server" Text="Replenishment" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
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
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Minimum Weight">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtMinWeight" runat="server" Width="170px" MinValue="0" MaxValue="9999999999">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date:" Name="DocDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpdocdate" runat="server" Width="170px" ReadOnly="true">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Current Weight">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtCurWeight" runat="server" Width="170px" MinValue="0" MaxValue="9999999999">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Warehouse">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glWarehousecode" runat="server" Width="170px" ClientInstanceName="glWarehousecode" DataSourceID="warehouseC" OnLoad="LookupLoad" KeyFieldName="WarehouseCode" TextFormatString="{0}">
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="True" Settings-AutoFilterCondition="Contains" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>

                                                            </Columns>
                                                            <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('Loc');}" Validation="OnValidation" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" />
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Excess Weight">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtRemWeight" ReadOnly="true" runat="server" Width="170px">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Customer">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="glStorerKey" runat="server" AutoGenerateColumns="False" ClientInstanceName="glStorerKey"
                                                            DataSourceID="customer" KeyFieldName="CustomerCode" OnLoad="LookupLoad" TextFormatString="{0}" ReadOnly="true" >
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="CustomerCode" ReadOnly="True" Settings-AutoFilterCondition="Contains" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" Settings-AutoFilterCondition="Contains" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents  Validation="OnValidation" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" />

                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Max Weight">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtMaxWeight" ReadOnly="true" runat="server" Width="170px">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Location">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="gLoc" runat="server" AutoGenerateColumns="False" OnInit="glItemCode_Init" ClientInstanceName="gLoc"
                                                            DataSourceID="loc" KeyFieldName="LocationCode" OnLoad="gvLookupLoad" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn Caption="Location" FieldName="LocationCode" ReadOnly="True" Settings-AutoFilterCondition="Contains" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>


                                                            </Columns>
                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" />

                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>

                                            <dx:EmptyLayoutItem>
                                            </dx:EmptyLayoutItem>




                                        </Items>
                                    </dx:LayoutGroup>

                                    <dx:LayoutGroup Caption="Audit Trail" ColSpan="2" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
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
                            <dx:LayoutGroup Caption="Replenishment Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <div id="loadingcont">
                                                    <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="747px" OnInit="gv1_Init"
                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                        OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber"
                                                        SettingsBehavior-AllowSort="false" OnRowValidating="grid_RowValidating">
                                                        <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                            BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" />
                                                        <SettingsPager Mode="ShowAllRecords" />
                                                        <SettingsEditing Mode="Batch" />
                                                        <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" VerticalScrollableHeight="530" ShowFooter="True" />

                                                        <SettingsBehavior AllowSelectByRowClick="True" AllowSort="False"></SettingsBehavior>

                                                        <SettingsCommandButton>
                                                            <NewButton>
                                                                <Image IconID="actions_addfile_16x16"></Image>
                                                            </NewButton>
                                                            <DeleteButton>
                                                                <Image IconID="actions_cancel_16x16"></Image>
                                                            </DeleteButton>
                                                        </SettingsCommandButton>
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="0px">
                                                                <CustomButtons>
                                                                    <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                        <Image IconID="support_info_16x16"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>

                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="1">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="false" Caption="LineNumber" ReadOnly="True" Width="100px">
                                                            </dx:GridViewDataTextColumn>

                                                            <dx:GridViewDataTextColumn Caption="Itemcode" FieldName="ItemCode" VisibleIndex="2" Width="200px" Name="Item">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="glItemCode_Init"
                                                                        DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="200px">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" AllowDragDrop="False" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                            <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                        </Columns>
                                                                        <ClientSideEvents RowClick="gridLookup_CloseUp" ValueChanged="function(s, e){ console.log('Selected Value:', s.GetValue()); }" DropDown="function(s,e){gl.GetGridView().PerformCallback('ItemCodeDropDown'+ '|' + glStorerKey.GetValue());}" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="PalletID" Name="PalletID" ShowInCustomizationForm="True" VisibleIndex="2" FieldName="PalletID" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="ColorCode" Name="ColorCode" Width="0px" ShowInCustomizationForm="True" VisibleIndex="3" FieldName="ColorCode" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="ClassCode" Name="ClassCode" Width="0px" ShowInCustomizationForm="True" VisibleIndex="4" FieldName="ClassCode" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="SizeCode" Name="SizeCode" Width="0px" ShowInCustomizationForm="True" VisibleIndex="5" FieldName="SizeCode" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="BulkUnit" Name="BulkUnit" Width="0px" ShowInCustomizationForm="True" VisibleIndex="6" FieldName="BulkUnit" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Unit" Name="Unit" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="Unit" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="FromLoc" Name="FromLoc" ShowInCustomizationForm="True" VisibleIndex="8" FieldName="FromLoc" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="ToLoc" Name="ToLoc" ShowInCustomizationForm="True" VisibleIndex="9" FieldName="ToLoc" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Location" FieldName="LocationCode" VisibleIndex="10" Width="0px" Name="Customer">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup Width="200px" ID="glLoc" runat="server" AutoGenerateColumns="False" OnInit="glItemCode_Init" ClientInstanceName="glLoc"
                                                                        DataSourceID="Masterfileloc" KeyFieldName="Location" OnLoad="gvLookupLoad" TextFormatString="{0}">
                                                                        <GridViewProperties>
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            <Settings ShowFilterRow="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="Location" ReadOnly="True" Settings-AutoFilterCondition="Contains" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            </dx:GridViewDataTextColumn>


                                                                        </Columns>
                                                                        <ClientSideEvents DropDown="function(s,e){glLoc.GetGridView().PerformCallback('LocationCodeDropDown'+ '|' + gl.GetValue());}" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" />

                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataSpinEditColumn Caption="Qty" Name="Quantity" ShowInCustomizationForm="True" VisibleIndex="11" FieldName="Qty" PropertiesSpinEdit-DisplayFormatString="{0:N}" UnboundType="Decimal" Width="100px">
                                                                <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}" MaxValue="9999999999" MinValue="0" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                            <dx:GridViewDataSpinEditColumn Caption="Kilo" Name="Kilo" ShowInCustomizationForm="True" VisibleIndex="12" FieldName="Kilo" PropertiesSpinEdit-DisplayFormatString="{0:N}" UnboundType="Decimal" Width="100px">
                                                                <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}" MaxValue="9999999999999999" MinValue="0" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>


                                                            <dx:GridViewDataTextColumn Caption="MfgDate" FieldName="Field1" ShowInCustomizationForm="True" VisibleIndex="13">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="ExpDate" FieldName="Field2"  ShowInCustomizationForm="True" VisibleIndex="14">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="RRDate" FieldName="Field3"  ShowInCustomizationForm="True" VisibleIndex="15">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="BatchNumber" Name="BatchNumber" ShowInCustomizationForm="True" VisibleIndex="16" FieldName="BatchNumber" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="LotNumber" Name="LotNumber" ShowInCustomizationForm="True" VisibleIndex="17" FieldName="LotNumber" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <%--<dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="17" FieldName="Field1" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="18" FieldName="Field2" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="19" FieldName="Field3" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="20" FieldName="Field4" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="21" FieldName="Field5" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="22" FieldName="Field6" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="23" FieldName="Field7" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="24" FieldName="Field8" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="25" FieldName="Field9" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>--%>
                                                        </Columns>
                                                    </dx:ASPxGridView>
                                                </div>

                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                            <%-- <!--#endregion --> --%>
                        </Items>
                    </dx:ASPxFormLayout>

                    <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                    <dx:ASPxCheckBox Style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                    <dx:ASPxButton ID="updateBtn" runat="server" Text="Submit" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
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
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                    <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>

                            </td>
                            <td>
                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                    <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Calculating..."
            ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.Replenishment" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.Inbound" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" TypeName="Entity.Replenishment+ReplenishmentDetail" SelectMethod="getdetail" UpdateMethod="UpdateRepDetail" DataObjectTypeName="Entity.Replenishment+ReplenishmentDetail" DeleteMethod="DeleteRepDetail" InsertMethod="AddRepDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM wms.ReplenishmentDetail where DocNumber is null " OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="warehouseC" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select A.WarehouseCode from Masterfile.Location A Left Join Masterfile.Warehouse B on A.WarehouseCode=B.WarehouseCode where ISNULL(Replenish,0) !=0 and B.WarehouseCode is not null group by A.WarehouseCode" OnInit="Connection_Init"></asp:SqlDataSource>
    <%--<asp:SqlDataSource ID="customer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select C.CustomerC as CustomerCode,B.Name from Masterfile.Location A  LEFT JOIN wms.CountSheetSetup C ON A.LocationCode = C.Location Left Join Masterfile.BizPartner B on C.CustomerC=B.BizPartnerCode where ISNULL(A.Replenish,0) !=0 and B.BizPartnerCode is not null group by C.CustomerC,B.Name" OnInit="Connection_Init"></asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="customer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [BizPartnerCode] as CustomerCode, [Name] FROM Masterfile.[BizPartner] WHERE ISNULL([IsInactive],0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="loc" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT LocationCode from Masterfile.Location where ISNULL(Replenish,0) != 0" OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileloc" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


