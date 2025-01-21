<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmInventoryHold.aspx.cs" Inherits="GWL.frmInventoryHold" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Inventory Hold</title>
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

        #cp_frmlayout1_PC_0_gv1_col2 {
            text-align: center;
        }

        #cp_frmlayout1_PC_0_0_0_7 .dxflCLLSys:first-of-type > div:first-of-type {
            width: 0px !important;
            min-width: 0px !important;
        }
        #cp_frmlayout1_PC_0_0_0_7 {
            height: 45px !important;
        }
    </style>
    <!-- Add this later -->

    <!--#endregion-->
    <!--#region Region Javascript-->
    <script>
        var isValid = false;
        var counterror = 0;
        var ALLcheckValues = "";

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
                //console.log(s.GetText());
                //console.log(e.value);
            }
            else {
                isValid = true;
            }
        }

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            reAdjustSelection();
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
                console.log(this);
                counterror = 0;
                alert('Please check all the fields!');
            }

            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
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
        function OnConfirm(s, e) {//function upon saving entry


            if (e.requestTriggerID === "cp" || e.requestTriggerID === "cp_frmlayout1_PC_0_gv1" || e.requestTriggerID === undefined)//disables confirmation message upon saving.
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                //alert(s.cp_valmsg);
                alert(s.cp_message);
                delete (s.cp_valmsg);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);

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
            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }

            if (entry != "V") {
                //if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                //    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                //    isSetTextRequired = true;
                //    index = e.visibleIndex;
                //}

                //if (e.focusedColumn.fieldName === "Location") {
                //    glLocation.GetInputElement().value = cellInfo.value;
                //}

            }

        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            //if (currentColumn.fieldName === "ItemCode") {
            //    cellInfo.value = gl.GetValue();
            //    cellInfo.text = gl.GetText().toUpperCase();
            //    cellInfo.text = gl.GetText(); // need sa n/a
            //}
            if (currentColumn.fieldName == "Selected") {
                //console.log('test');
                cellInfo.value = false;
            }


            //if (currentColumn.fieldName === "Location") {
            //    cellInfo.value = glLocation.GetValue();
            //    cellInfo.text = glLocation.GetText().toUpperCase();

            //}

            if (currentColumn.fieldName === "StorageType") {
                cellInfo.value = glStorageType.GetValue();
                cellInfo.text = glStorageType.GetText().toUpperCase();
            }

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

                //var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                var indicies = gv1.batchEditApi.GetRowVisibleIndices()();
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
        function ToggleCheckbox(checkbox) {
            // Toggle the checked state of the checkbox
            checkbox.SetChecked(!checkbox.GetChecked());
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
            gvd1.SetWidth(width - 120);
            gvd1.SetHeight(height - 290);
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

        function OnGridViewSelectionChanged(s, e) {

            if (e.visibleIndex == -1) {
                if (e.isSelected == true) {
                    let rowCount = gv1.batchEditApi.GetRowVisibleIndices();
                    ALLcheckValues = "";
                    for (let index of rowCount) {
                        ALLcheckValues += ALLcheckValues == "" ? gv1.batchEditApi.GetCellValue(index, "RecordID") : `|${gv1.batchEditApi.GetCellValue(index, "RecordID")}`
                    }
                    //console.log(ALLcheckValues);

                    gv1.PerformCallback(`SelectAll/${ALLcheckValues}`);
                } else {
                    ALLcheckValues = "";
                    gv1.PerformCallback("DeselectAll");
                }

            }
            else {
                var selectedRowKeys = s.GetSelectedKeysOnPage();
                var _indices = gv1.batchEditApi.GetRowVisibleIndices();
                var selected = s.batchEditApi.GetCellValue(e.visibleIndex, "Selected");
                var Record = s.batchEditApi.GetCellValue(e.visibleIndex, "RecordID");
                //console.log(Record);
                //gv1.batchEditApi.SetCellValue(e.visibleIndex, "Selected", !selected);
                gv1.PerformCallback(`updateValue|${e.visibleIndex}|Selected|${e.isSelected}|${Record}`);

            }
        }

        function reAdjustSelection() {

            let rowCount = gv1.batchEditApi.GetRowVisibleIndices();
            if (rowCount.length > 0) {
                let vall = document.getElementById('cp_frmlayout1_PC_0_gv1_DXSelAllBtn1').value

                if (vall == "U" || vall == undefined || vall == null) {
                    gv1.PerformCallback("DeselectAll");
                } else {
                    ALLcheckValues = "";
                    for (let index of rowCount) {
                        let Ichecked = document.getElementById(`cp_frmlayout1_PC_0_gv1_DXSelBtn${index}`).value
                        //console.log(Ichecked);
                        if (Ichecked == 'C') {

                            gv1.PerformCallback(`updateValue|${index}|Selected|${true}|${gv1.batchEditApi.GetCellValue(index, "RecordID")}`);
                            //ALLcheckValues += ALLcheckValues == "" ? gv1.batchEditApi.GetCellValue(index, "RecordID") : `|${gv1.batchEditApi.GetCellValue(index, "RecordID")}`;
                        }

                    }
                    //console.log(ALLcheckValues);
                    // gv1.PerformCallback(`SelectAll/${ALLcheckValues}`);
                }
            } else {
                gv1.PerformCallback("DeselectAll");
            }

        }



        function setCondition(type) {
            //console.log(txtNumber.GetValue())

            var condy = "";
            var finalVal = "";
            //batch 
            //console.log(txtNumber.GetValue())
            if (type == "Batch") {
                //console.log(type)
                //  console.log( batchConditionf.GetValue())
                condy = txtCondition.GetValue() == "=" ? 'equals' : 'like';
                finalVal = batchConditionf.GetValue() == null ? "" : `${batchConditionf.GetValue()} OR `;
                batchConditionf.SetValue(finalVal + `BatchNumber ${condy} '${txtValue.GetValue()}' `);

            } else if (type == "EVEN") {
                //console.log('test')
                //console.log(txtNumber.GetValue())
                //console.log('test');
                //console.log(batchConditionf ?.GetValue());
                if (batchConditionf?.GetValue() == null) {
                    console.log('test2');
                    if (txtNumber.GetValue() != "NONE") {
                        condy = txtNumber.GetValue() == "EVEN" ? "EVEN NUMBERS" : "ODD NUMBERS";
                        finalVal = `BatchNumbers with ${condy}`;
                    }
                    batchConditionf.SetValue(finalVal);

                } else {
                    //32
                    //33
                    // console.log('test5');
                    //console.log(batchConditionf.GetValue().includes("EVEN NUMBERS"));
                    if (batchConditionf.GetValue().includes("EVEN NUMBERS") || batchConditionf.GetValue().includes("ODD NUMBERS")) {

                        if (txtNumber.GetValue() == "EVEN" || txtNumber.GetValue() == "ODD") {
                            batchConditionf.SetValue(batchConditionf.GetValue().includes("EVEN NUMBERS") ? batchConditionf.GetValue().replace("EVEN NUMBERS", "ODD NUMBERS") : batchConditionf.GetValue().replace("ODD NUMBERS", "EVEN NUMBERS"));
                        } else {
                            if (batchConditionf.GetValue().includes("EVEN NUMBERS")) {
                                if (batchConditionf.GetValue().includes("EVEN NUMBERS OR")) {
                                    var ss = String(batchConditionf.GetValue().replace("BatchNumbers with EVEN NUMBERS OR ", ""));
                                    console.log(ss);
                                    console.log(batchConditionf.GetValue().length);
                                    console.log(batchConditionf.GetValue());
                                    batchConditionf.SetValue(batchConditionf.GetValue().slice(33));
                                }
                                else {
                                    var ssw = batchConditionf.GetValue(); // Ensure it’s a string
                                    ssw = ssw.replace("BatchNumbers with EVEN NUMBERS OR ", "");
                                    console.log(ssw);
                                    batchConditionf.SetValue(ssw);
                                }
                            } else {
                                //batchConditionf.SetValue(batchConditionf.GetValue().includes("ODD NUMBERS OR") ? batchConditionf.GetValue().replace("BatchNumbers with ODD NUMBERS OR ", "") : batchConditionf.GetValue().replace("BatchNumbers with ODD NUMBERS", ""));
                                if (batchConditionf.GetValue().includes("ODD NUMBERS OR")) {
                                    var ss = batchConditionf.GetValue().replace("BatchNumbers with ODD NUMBERS OR ", "");
                                    console.log(ss);
                                    console.log(batchConditionf.GetValue().length);
                                    console.log(batchConditionf.GetValue());
                                    batchConditionf.SetValue(batchConditionf.GetValue().slice(32));
                                }
                                else {
                                    var ssw = batchConditionf.GetValue().replace("BatchNumbers with ODD NUMBERS OR ", "");
                                    console.log(ssw);
                                    console.log(batchConditionf.GetValue());
                                    console.log(batchConditionf.GetValue());
                                    batchConditionf.SetValue(batchConditionf.GetValue().slice(28));
                                }
                            }

                        }

                    } else {
                        //console.log("DAGDAG SA KALIWA");
                        if (txtNumber.GetValue() != "NONE") {
                            console.log("wala");
                            condy = txtNumber.GetValue() == "EVEN" ? "EVEN NUMBERS" : "ODD NUMBERS";
                            finalVal = `BatchNumbers with ${condy} OR `;
                        }
                        batchConditionf.SetValue(finalVal + batchConditionf.GetValue());
                    }
                }
            }

        }
        function enableButton() {
            //  console.log(txtCondition.GetValue())
            //console.log(txtValue.GetValue())
            if (txtCondition?.GetValue() != null && txtValue?.GetValue() != null) {
                setBtn(true)
            } else {
                setBtn(false)

            }

        }
        function resetValues() {
            txtCondition.SetValue(null);
            txtValue.SetValue(null);
            txtNumber.SetValue(null);
            batchConditionf.SetValue(null);
            batchConditionf.SetEnabled(false);
        }
        function setBtn(condition) {

            btnCondition.GetMainElement().style.backgroundColor = condition ? "CornflowerBlue" : "gray";
            btnCondition.SetEnabled(condition);
        }

        function onUnHoldCheckChanged(s, e) {
            if (s.GetChecked()) {
                if (s.name.split("_").pop() == "unHold") {
                    inHold.SetChecked(false)
                } else {
                    unHold.SetChecked(false)
                }

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
                    <dx:ASPxLabel runat="server" Text="Inventory Hold" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <%--<!--#region Region Factbox --> --%>
        <%--        <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None"
            EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
            ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>--%>
        <%--<!--#endregion --> --%>
        <%--   <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
            EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents CloseUp="function (s, e) { cp.PerformCallback('refgrid'); e.processOnServer = false;}" />
        </dx:ASPxPopupControl>--%>

        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="200px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="200px" Width="850px" Style="margin-left: -3px; margin-right: 0px;">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />

                        <Items>
                            <%--<!--#region Region Header --> --%>


                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="Inventory Inquiry" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Warehouse Code:" Name="WarehouseCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtwarehousecode" runat="server" Width="170px" DataSourceID="Warehouse" KeyFieldName="WarehouseCode" OnLoad="LookupLoad"
                                                            ClientInstanceName="aglWarehouseCode" TextFormatString="{0}">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
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
                                            <dx:LayoutItem Caption="Hold Code:" Name="HoldCode" ColSpan="1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">

                                                        <dx:ASPxGridLookup ID="txtHoldCode" Width="170px" runat="server" DataSourceID="Holdstat" KeyFieldName="HoldCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="HoldCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
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
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Remarks:" Name="Remarks" ColSpan="1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtremarks" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                    <%--        <dx:EmptyLayoutItem>
                                            </dx:EmptyLayoutItem>--%>
                                        
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxRoundPanel ID="rpFilter" runat="server" Width="200px"  HeaderText=" " ShowHeader="false">
                                                            <PanelCollection>
                                                                <dx:PanelContent runat="server">
                                                                    <table>
                                                                        <tr align="left">
                                                                            <%--<td>
                                                                                <dx:ASPxLabel ID="lblLot" runat="server" Text="Lot:">
                                                                                </dx:ASPxLabel>
                                                                            </td>--%>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="ASPxLabel5" runat="server" Text="" Width="50px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="lblStatus" runat="server" Text="Status:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="" Width="10px">
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
                                                                                <dx:ASPxLabel ID="lblRRdoc" runat="server" Text="RR Doc:">
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
                                                                            <td>
                                                                                <dx:ASPxLabel ID="lblBacth" runat="server" Text="Batch:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="lblLot" runat="server" Text="Lot:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="lblMfgdate" runat="server" Text="MfgDate:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="lblExpdate" runat="server" Text="ExpDate:">
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
                                                                                <dx:ASPxLabel ID="ASPxLabel6" runat="server" Text="Filter:" Width="50px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxComboBox ID="txtStats" ClientInstanceName="txtStats" Width="90px" runat="server" OnLoad="Comboboxload">
                                                                                    <Items>
                                                                                        <dx:ListEditItem Text="OK" Value="OK" />
                                                                                        <dx:ListEditItem Text="HOLD" Value="HOLD" />
                                                                                    </Items>
                                                                                    <%-- from picklist <ClientSideEvents ValueChanged="function(s, e) {
                                                                                           var grid = glocn.GetGridView();
                                                                                            glocn.GetGridView().PerformCallback(s.GetInputElement().value + '|' + glcustomer.GetValue() + '|' + txtwarehousecode.GetValue() + '|' + '');
                                                                  
                                                                                        }" />--%>
                                                                                    <%--  <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                        <RequiredField IsRequired="True" />
                                                                                    </ValidationSettings>
                                                                                    <InvalidStyle BackColor="Pink">
                                                                                    </InvalidStyle>--%>
                                                                                </dx:ASPxComboBox>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxGridLookup ID="cmbStorerKey" runat="server" Width="90px" AutoGenerateColumns="False" DataSourceID="StorerKey" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}">
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
                                                                                    <%-- <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                        <ErrorImage ToolTip="Customer is required">
                                                                                        </ErrorImage>
                                                                                        <RequiredField IsRequired="True" />
                                                                                    </ValidationSettings>
                                                                                    <InvalidStyle BackColor="Pink">
                                                                                    </InvalidStyle>--%>
                                                                                </dx:ASPxGridLookup>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxGridLookup ID="txtRRDocno" ClientInstanceName="txtRRDocno" runat="server" Width="90px" AutoGenerateColumns="False" DataSourceID="Inbound" KeyFieldName="TransDoc" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                                    <GridViewProperties>
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                        <Settings ShowFilterRow="True"></Settings>
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="TransDoc" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="Warehouse" FieldName="WarehouseCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="Customer" FieldName="CustomerC" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
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
                                                                                <dx:ASPxTextBox ID="txtItem" runat="server" Width="110px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxTextBox ID="txtLocation" runat="server" Width="110px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxTextBox ID="txtPalletID" runat="server" Width="110px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxTextBox ID="txtBatch" runat="server" Width="110px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxTextBox ID="txtLot" runat="server" Width="110px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxDateEdit Width="100px" ID="txtMfgDate" runat="server">
                                                                                    <%-- <ClientSideEvents Validation="OnValidation" />--%>
                                                                                    <%--    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                        <RequiredField IsRequired="True" />
                                                                                    </ValidationSettings>
                                                                                    <InvalidStyle BackColor="Pink">
                                                                                    </InvalidStyle>--%>
                                                                                </dx:ASPxDateEdit>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxDateEdit Width="100px" ID="txtExpDateFil" runat="server">
                                                                                    <%--  <ClientSideEvents Validation="OnValidation" />--%>
                                                                                    <%--  <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                        <RequiredField IsRequired="True" />
                                                                                    </ValidationSettings>
                                                                                    <InvalidStyle BackColor="Pink">
                                                                                    </InvalidStyle>--%>
                                                                                </dx:ASPxDateEdit>
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
                                                                                       gv1.PerformCallback('getVal');
                                                                                       
                                                                                       }" />

                                                                                </dx:ASPxButton>

                                                                            </td>

                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
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
                                        <%--  <Items >
                                               <dx:LayoutItem Caption="" >
                                                  <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                       <dx:ASPxRoundPanel ID="ASPxRoundPanel1"  style="border:none;" runat="server" Width="200px" HeaderText=" " ShowHeader="false">
                                                            <PanelCollection>
                                                                <dx:PanelContent runat="server">
                                                                    <table>
                                                                        <tr align="left">
                                                                         
                                                                             <td>
                                                                                <dx:ASPxLabel ID="ASPxLabel11" runat="server" Text="" Width="50px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                             <td>
                                                                                 <dx:ASPxLabel ID="ASPxLabel10" runat="server" Text="Hold">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                             <td>
                                                                               <dx:ASPxLabel ID="ASPxLabel13" runat="server" Text="UnHold">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="ASPxLabel12" runat="server" Text="Even/Odd:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="ASPxLabel7" runat="server" Text="Identifier:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="ASPxLabel8" runat="server" Text="" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="ASPxLabel9" runat="server" Text="Value:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                              <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                         
                                                                           
                                                                        </tr>
                                                                        <tr>
                                                                          
                                                                            <td>
                                                                                <dx:ASPxLabel ID="ASPxLabel15" runat="server" Text="Batch:" Width="50px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                                 <td>
                                                                                    <dx:ASPxCheckBox ID="inHold" runat="server" ClientInstanceName="inHold">
                                                                                     <ClientSideEvents CheckedChanged="onUnHoldCheckChanged" />
                                                                                </dx:ASPxCheckBox>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                                 <td style="padding-left:7px;">
                                                                                   <dx:ASPxCheckBox ID="unHold" runat="server" ClientInstanceName="unHold">
                                                                                      <ClientSideEvents CheckedChanged="onUnHoldCheckChanged" />
                                                                                </dx:ASPxCheckBox>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                             <td>
                                                                                    <dx:ASPxComboBox ID="txtNumber" ClientInstanceName="txtNumber" Width="100px" runat="server" OnLoad="Comboboxload">
                                                                                    <Items>
                                                                                         <dx:ListEditItem Text="" Value="NONE" />
                                                                                        <dx:ListEditItem Text="EVEN" Value="EVEN" />
                                                                                        <dx:ListEditItem Text="ODD" Value="ODD" />
                                                                                    </Items>
                                                                                          <ClientSideEvents ValueChanged="function(){  setCondition('EVEN'); }" />
                                                                                
                                                                                </dx:ASPxComboBox>  
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel runat="server" Text="" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxComboBox ID="txtCondition" ClientInstanceName="txtCondition" Width="100px" runat="server" OnLoad="Comboboxload">
                                                                                    <Items>
                                                                                        <dx:ListEditItem Text="EQUALS" Value="=" />
                                                                                        <dx:ListEditItem Text="LIKE" Value="LIKE" />
                                                                                    </Items>
                                                                                     <ClientSideEvents ValueChanged="function(){  enableButton();}" />
                                                                                 
                                                                                </dx:ASPxComboBox>
                                                                                 
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                     
                                                                            <td>
                                                                                <dx:ASPxTextBox  ID="txtValue"  ClientInstanceName="txtValue"  runat="server" Width="200px">
                                                                                      <ClientSideEvents ValueChanged="function(){ enableButton()}" />
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                          
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            
                                                                            <td>

                                                                                <dx:ASPxButton ID="btnCondition" ClientInstanceName="btnCondition" runat="server" Text="ADD CONDITION" AutoPostBack="false" UseSubmitBehavior="false" BackColor="CornflowerBlue" ForeColor="White">
                                                                                    <ClientSideEvents Click="function(s, e) { 
                                                                                        setCondition('Batch');
                                                                                         
                                                                                       }" />

                                                                                </dx:ASPxButton>

                                                                            </td>
    
                                                                            <td>
                                                                                <dx:ASPxLabel Text="" runat="server" Width="10px">
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
                                             <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="batchConditionf"  style="margin-left:100px:padding:20px" ClientInstanceName="batchConditionf"  ScrollBars="Horizontal" runat="server" Height="100px" OnLoad="MemoLoad" Width="1000px">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                         
                                      
                                      </Items>--%>

                                        <Items>
                                            <dx:LayoutGroup Caption="Inventory Detail">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="1250px" SettingsBehavior-AllowSort="false"
                                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                                    OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="RecordID;ItemCode;PalletID;Location;BatchNo;LotID;MfgDate;ExpirationDate;RRDate" OnCustomCallback="gv1_CustomCallback"  
                                                                    >
                                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                                    <%-- <Settings ShowFilterRow="true" ShowFilterBar="Auto" />--%>
                                                                    <SettingsBehavior AllowGroup="false" AllowDragDrop="false" />
                                                                             <SettingsBehavior ColumnResizeMode="Control" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" PropertiesTextEdit-Native="true"
                                                                            VisibleIndex="0" Width="0px">
                                                                          
                                                                         
                                                                           
                                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>

                                                                        <%--  <dx:GridViewCommandColumn  Width="50px" Caption="  " Name=" " ShowSelectCheckbox="True" VisibleIndex="1"> 
                                                                              
                                                                              <HeaderTemplate>
                                                                               <div class="titleContainer BottomLargeMargin">
                                                                                        <dx:ASPxLabel ID="lblInfo" ClientInstanceName="info" runat="server" />
                                                                                        <dx:ASPxHyperLink ID="lnkSelectAllRows" ClientInstanceName="lnkSelectAllRows"
                                                                                            Text="Select all rows" runat="server" Cursor="pointer" ClientSideEvents-Click="OnSelectAllRowsLinkClick" />
                                                                                        &nbsp;
                                                                                        <dx:ASPxHyperLink ID="lnkClearSelection" ClientInstanceName="lnkClearSelection"
                                                                                            Text="Clear selection" runat="server" Cursor="pointer" ClientVisible="false" ClientSideEvents-Click="OnUnselectAllRowsLinkClick" />
                                                                            </div>
                                                                                
                                                                            </HeaderTemplate>


                                                                          </dx:GridViewCommandColumn>--%>

                                                                        <%--                         <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="False" VisibleIndex="1" Width="60px"   >
                                                                                            </dx:GridViewCommandColumn>--%>
                                                                        <%--<dx:GridViewDataCheckColumn FieldName="Selected" Name="Selected" ShowInCustomizationForm="True" Visible="True" VisibleIndex="0" Width="50px">    
                                                                                
                                                                        </dx:GridViewDataCheckColumn>--%>
                                                                        <dx:GridViewCommandColumn Width="50px" ShowSelectCheckbox="True" ShowClearFilterButton="true" SelectAllCheckboxMode="Page" VisibleIndex="1" />
                                                              

                                                                        <dx:GridViewDataColumn FieldName="Selected" Width="0" VisibleIndex="2">
                                                                          
                                                                         
                                                                           
                                                                        </dx:GridViewDataColumn>


                                                                        <dx:GridViewDataTextColumn Caption="Record ID"  Name="Record ID" FieldName="RecordID" VisibleIndex="3" Visible="true" Width="65px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true" >
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="4" Width="150px" Name="Item Code">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemDescription" Caption="Description" VisibleIndex="5" Width="150px" Name="Description">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="PalletID" Caption="Pallet ID" ShowInCustomizationForm="True" VisibleIndex="6" Name="Pallet ID">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Name="Location" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="Location" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <%--  <dx:GridViewDataSpinEditColumn FieldName="CurrentBulkQty" VisibleIndex="7" Width="100px">
                                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                ClientInstanceName="CurrentBulkQty" MinValue="0">
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>--%>
                                                                        <%--<dx:GridViewDataSpinEditColumn FieldName="Qty" VisibleIndex="8" Width="100px" UnboundType="Decimal" CellStyle-BackColor="#99ccff">
                                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                ClientInstanceName="TargetBulkQty" MinValue="0">
                                                                            </PropertiesSpinEdit>

                                                                            <CellStyle BackColor="#99ccff"></CellStyle>

                                                                            CurrentQty
                                                                            gBulkQty
                                                                            TargetQty
                                                                            AdjustedQty
                                                                        </dx:GridViewDataSpinEditColumn>--%>

                                                                        <dx:GridViewDataSpinEditColumn Caption="Qty" FieldName="RemainingBulkQty" Name="RemainingBulkQty" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="RemainingBulkQty" ConvertEmptyStringToNull="False" DisplayFormatString="g" NullDisplayText="0" NullText="0">
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="RemainingBaseQty" Name="Kilo" VisibleIndex="9" Width="110px" Caption="Kilo">
                                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                ClientInstanceName="RemainingBaseQty" MinValue="0">
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>


                                                                        <%--<dx:GridViewDataTextColumn FieldName="Unit" Caption="Unit" Name="Unit" ShowInCustomizationForm="True" VisibleIndex="13">
                                                                        </dx:GridViewDataTextColumn>--%>
                                                                        <dx:GridViewDataTextColumn FieldName="BulkUnit" Caption="Bulk Unit" VisibleIndex="10" Name="Bulk Unit">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="BatchNo" Caption="Batch No" Name="Batch No" Width="200px" ShowInCustomizationForm="True" VisibleIndex="11">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LotID" Caption="LotID" Name="LotID" Width="200px" ShowInCustomizationForm="True" VisibleIndex="12">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Expiration Date" FieldName="ExpirationDate" ShowInCustomizationForm="True" VisibleIndex="13" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Manufacturing Date" Name="Manufacturing Date" FieldName="MfgDate" Width="150px" ShowInCustomizationForm="True" VisibleIndex="14" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="RR Date" Name="RR Date" FieldName="RRDate" ShowInCustomizationForm="True" VisibleIndex="15" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Hold" Name="Hold" FieldName="HoldStatus" Width="50px" ShowInCustomizationForm="True" VisibleIndex="16">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Currently Hold In" Name="Current Hold In" Width="200px" FieldName="CurrentDoc" ShowInCustomizationForm="True" VisibleIndex="17" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>


                                                                    </Columns>
                                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Visible"  VerticalScrollableHeight="0" />

                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm"
                                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" SelectionChanged="OnGridViewSelectionChanged" />

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
                                                        <dx:ASPxGridView ID="gvd1" runat="server" AutoGenerateColumns="False" Width="1250px"
                                                            OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gvd1"
                                                            OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="RecordID;ItemCode;PalletID;Location;BatchNo;LotID;MfgDate;ExpirationDate;RRDate">

                                                            <ClientSideEvents Init="OnInitTrans" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="RecordID" VisibleIndex="1" Visible="true" Width="65px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true">
                                                                </dx:GridViewDataTextColumn>

                                                                <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="2" Width="150px" Name="glItemCode">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="ItemDescription" Caption="Description" VisibleIndex="3" Width="150px" Name="glItemCode">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="PalletID" Caption="Pallet ID" ShowInCustomizationForm="True" VisibleIndex="4" Name="PalletID">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Name="Location" ShowInCustomizationForm="True" VisibleIndex="5" FieldName="Location" UnboundType="String">
                                                                </dx:GridViewDataTextColumn>
                                                                <%--  <dx:GridViewDataSpinEditColumn FieldName="CurrentBulkQty" VisibleIndex="7" Width="100px">
                                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                ClientInstanceName="CurrentBulkQty" MinValue="0">
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>--%>
                                                                <%--<dx:GridViewDataSpinEditColumn FieldName="Qty" VisibleIndex="8" Width="100px" UnboundType="Decimal" CellStyle-BackColor="#99ccff">
                                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                                ClientInstanceName="TargetBulkQty" MinValue="0">
                                                                            </PropertiesSpinEdit>

                                                                            <CellStyle BackColor="#99ccff"></CellStyle>

                                                                            CurrentQty
                                                                            gBulkQty
                                                                            TargetQty
                                                                            AdjustedQty
                                                                        </dx:GridViewDataSpinEditColumn>--%>
                                                                <dx:GridViewDataSpinEditColumn Caption="Qty" FieldName="RemainingBulkQty" Name="RemainingBulkQty" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                    <PropertiesSpinEdit Increment="0" ClientInstanceName="RemainingBulkQty" ConvertEmptyStringToNull="False" DisplayFormatString="g" NullDisplayText="0" NullText="0">
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="RemainingBaseQty" Name="RemainingBaseQty" VisibleIndex="7" Width="110px" Caption="Kilo">
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                        ClientInstanceName="RemainingBaseQty" MinValue="0">
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>


                                                                <%--    <dx:GridViewDataTextColumn FieldName="Unit" Caption="Unit" Name="Unit" ShowInCustomizationForm="True" VisibleIndex="13">
                                                                        </dx:GridViewDataTextColumn>--%>
                                                                <dx:GridViewDataTextColumn FieldName="BulkUnit" VisibleIndex="8" Name="BulkUnit">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="BatchNo" Name="BatchNo" Width="200px" ShowInCustomizationForm="True" VisibleIndex="9">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="LotID" Name="LotID" Width="200px" ShowInCustomizationForm="True" VisibleIndex="9">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Expiry Date" FieldName="ExpirationDate" ShowInCustomizationForm="True" VisibleIndex="10" UnboundType="String">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Manufacturing Date" FieldName="MfgDate" Width="150px" ShowInCustomizationForm="True" VisibleIndex="11" UnboundType="String">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="RR Date" FieldName="RRDate" ShowInCustomizationForm="True" VisibleIndex="12" UnboundType="String">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="HoldStatus" Name="Hold" Width="100px" ShowInCustomizationForm="True" VisibleIndex="13">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Currently Hold In" Width="200px" FieldName="CurrentDoc" ShowInCustomizationForm="True" VisibleIndex="14" UnboundType="String">
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
                        </Items>
                    </dx:ASPxFormLayout>

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
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.InventoryHold" DataObjectTypeName="Entity.InventoryHold" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.InventoryHold+InventoryHoldDetail" DataObjectTypeName="Entity.InventoryHold+InventoryHoldDetail" DeleteMethod="DeleteInventoryHoldDetail" InsertMethod="AddInventoryHoldDetail" UpdateMethod="UpdateInventoryHoldDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="DocNumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.[RecordId] as RecordID,A.[Itemcode] as ItemCode,B.[FullDesc] as ItemDescription,A.[PalletID],A.Location,A.[Qty] as RemainingBaseQty ,A.[BulkQty] as RemainingBulkQty ,B.[UnitBulk] as BulkUnit,A.[BatchNo] ,A.[LotIDs] as LotID,A.[RRdate],A.[MfgDate],A.[ExpDate] as ExpirationDate, C.DocNumber as CurrentDoc,A.Customer as CustomerCode,A.StatusCode as HoldStatus FROM WMS.InventoryHoldDetail A LEFT JOIN MASTERFILE.ITEM B ON A.itemcode = b.itemcode AND A.Customer = B.Customer LEFT JOIN WMS.InventoryHoldDetail C ON A.[DocNumber] = C.[DocNumber] AND A.[RecordId] = C.[RecordId] and a.[PalletID] = c.[PalletID] LEFT JOIN IT.Users D ON A.Warehousecode = D.CompanyCode WHERE A.DocNumber is null order by RecordId" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsClass" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WareHouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,'')=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,'')=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Unit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.Unit where ISNULL(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="UnitBase" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.Unit where ISNULL(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsLocation" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select LocationCode,LocationDescription,WarehouseCode from masterfile.Location  where isnull(IsInactive,'')=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="StoragesType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT StorageType,StorageDescription FROM masterfile.StorageType " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="StorerKey" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name, Address, ContactPerson, TIN, ContactNumber, EmailAddress, BusinessAccountCode, AddedDate, AddedBy, LastEditedDate, LastEditedBy, IsInactive, IsCustomer, ActivatedBy, ActivatedDate, DeactivatedBy, DeactivatedDate, Field1, Field2, Field3, Field4, Field5, Field6, Field7, Field8, Field9 FROM Masterfile.BizPartner WHERE (ISNULL(IsInactive, 0) = '0') AND (IsCustomer = '1')" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Holdstat" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT 'Incomplete Documents' AS HoldCode UNION ALL SELECT 'Waiting' AS HoldCode UNION ALL SELECT 'Cancelled' AS HoldCode UNION ALL SELECT 'PLUG IN-OUT' AS HoldCode UNION ALL SELECT 'INSPECTION NEEDED' AS HoldCode UNION ALL SELECT 'TEMPERATURE REQUIREMENT' AS HoldCode UNION ALL SELECT 'NMIS TAGGING' AS HoldCode UNION ALL SELECT 'GPS DISARMING' AS HoldCode UNION ALL SELECT 'CLIENT INSTRUCTION' AS HoldCode UNION ALL SELECT 'TRUCK CONDITION' AS HoldCode UNION ALL SELECT 'OTHERS' AS HoldCode" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Inbound" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TransDoc,WarehouseCode,CustomerC FROM WMS.CountSheetSetup WHERE ISNULL(PutawayDate,'') !='' GROUP BY TransDoc,WarehouseCode,CustomerC ORDER BY TransDoc" OnInit="Connection_Init"></asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


