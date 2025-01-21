<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmICN.aspx.cs" Inherits="GWL.frmICN" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>ICN</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
    <%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
    <%--NEWADD--%>
    <%--Link to global stylesheet--%>

    <!--#region Region Javascript-->
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
        /*::-moz-selection{
        background-color:Transparent;
        color:#000;
        }

        ::selection {
        background-color:Transparent;
        color:#000;
        }
        .myclass::-moz-selection,
        .myclass::selection { ... }*/

        .pnl-content {
            text-align: right;
        }
    </style>
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
            if (glStorerKey.GetText() == "" || glWarehouseCode.GetText() == "" || txtOvertime.GetText() == "" || txtTBSB.GetText() == "" || txtTProvided.GetText() == "" ||                     txtHTranstype.GetText() == "" || txtShipType.GetText() == "" || txtConsignee.GetText() == '' || txtConAddr.GetText() == '' || txtHTruckingCo.GetText() == ''
                || txtTruckType.GetText() == ''
            ) {

                isValid = false;
            }
            else {
                isValid = true;
            }
        }

        var baseqty = 0;
        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            OnValidation(null, null)
            if (!isValid) {
                alert('Please check all the fields!');
                return;
            }
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                    gv1.batchEditApi.ValidateRow(indicies[i]);
                    //gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("BulkUnit").index);
                }
                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else {
                        gv1.batchEditApi.ValidateRow(indicies[i]);
                        //gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("BulkUnit").index);
                    }
                }
            }

            gv1.batchEditApi.EndEdit();

            var btnmode = btn.GetText(); //gets text of button

            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }

            if (glStorerKey.GetText() != "" && glWarehouseCode.GetText() != "" || btnmode == "Close") { //check if there's no error then proceed to callback
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
                else if (btnmode == "Delete") {
                    cp.PerformCallback("Delete");
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

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);
                if (s.cp_forceclose) {//NEWADD
                    delete (s.cp_forceclose);
                    window.close();
                }
            }


            if (s.cp_close) {
                var btnmode = btn.GetText();
                if (s.cp_message != null && s.cp_message !== undefined && s.cp_message.toString().trim() != '') {
                    alert(s.cp_message);
                    delete (s.cp_message);
                }
                if (s.cp_valmsg !== null && s.cp_valmsg !== undefined && s.cp_valmsg.toString().trim() != '') {
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                }
                if (glcheck.GetChecked() && btnmode != "Close") {
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
            if (s.cp_clear) {
                delete (s.cp_clear);//deletes cache variables' data
                gv1.CancelEdit();
            }
        }

        var isBusy = false;
        var index;
        var index2;
        var closing;
        var valchange;
        var valchange2;
        var valchange3;
        var val;
        var temp;
        var bulkqty;
        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        function OnStartEditing(s, e) {//On start edit grid function     
            if (entry != "V" && entry != "D") {
                currentColumn = e.focusedColumn;
                var cellInfo = e.rowValues[e.focusedColumn.index];
                itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
                bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "BulkQty");

                if (bulkqty == null) {
                    bulkqty = 0;
                }

                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
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
                if (e.focusedColumn.fieldName === "BulkUnit") {
                    //e.cancel = true;
                    isSetTextRequired = true;
                    glBulkUnit.GetInputElement().value = cellInfo.value;
                    index = e.visibleIndex;
                }
                if (e.focusedColumn.fieldName === "BulkQty") {
                    index = e.visibleIndex;
                }
                if (e.focusedColumn.fieldName === "DocBulkQty") {
                    index = e.visibleIndex;
                }
                if (e.focusedColumn.fieldName === "Price") {
                    index = e.visibleIndex;
                }


            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            if (entry != "V" && entry != "D") {
                var cellInfo = e.rowValues[currentColumn.index];
                console.log('End:' + currentColumn.fieldName);
                if (currentColumn.fieldName === "ItemCode") {
                    cellInfo.value = gl.GetValue();
                    cellInfo.text = gl.GetText();
                }

                if (currentColumn.fieldName === "ColorCode") {
                    cellInfo.value = gl2.GetValue();
                    cellInfo.text = gl2.GetText();
                }
                if (currentColumn.fieldName === "ClassCode") {
                    cellInfo.value = gl3.GetValue();
                    cellInfo.text = gl3.GetText();
                }
                if (currentColumn.fieldName === "SizeCode") {
                    cellInfo.value = gl4.GetValue();
                    cellInfo.text = gl4.GetText();
                }
                if (currentColumn.fieldName === "BulkUnit") {

                    cellInfo.value = glBulkUnit.GetValue();
                    cellInfo.text = glBulkUnit.GetText();
                }

                if (currentColumn.fieldName === "BulkQty") {
                    index2 = index;
                }
                if (currentColumn.fieldName === "DocBulkQty") {
                    index2 = index;
                }

                if (currentColumn.fieldName === "Price") {
                    index2 = index;
                }
            }
        }

        var val;
        var temp;

        function GridEnd(s, e) {
            console.log('column value');
            console.log(s.GetGridView().cp_codes);
            val = s.GetGridView().cp_codes;
            temp = val.split(';');
            if (valchange) {
                valchange = false;
                var column = gv1.GetColumn(6);
                ProcessCells2(0, index2, column, gv1);
                isBusy = false;
            }
            if (valchange3) {
                valchange3 = false;
                var column = gv1.GetColumn(8);
                ProcessCells4(0, index2, column, gv1);
                isBusy = false;
            }

            if (valchange2) {
                valchange2 = false;
                closing = false;
                console.log(gv1.GetColumnsCount());
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    console.log(column.fieldName)
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells3(0, e, column, gv1);
                }
                gv1.batchEditApi.EndEdit();
            }
            loader.Hide();
        }

        function ProcessCells3(selectedIndex, e, column, s) {

            if (val == null) {
                val = ";;;;;";
                temp = val.split(';');
            }
            if (temp[0] == null || temp[0] == "") {
                temp[0] = "";
            }
            if (temp[1] == null || temp[1] == "") {
                temp[1] = "";
            }
            if (temp[2] == null || temp[2] == "") {
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
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                }
                if (column.fieldName == "ClassCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[1]);
                }
                if (column.fieldName == "SizeCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[2]);
                }
                if (column.fieldName == "FullDesc") {
                    console.log('input')
                    console.log(temp[3]);
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[3]);
                }
                if (column.fieldName == "BulkUnit") { //Change fieldname according to your main qty
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[4]);
                }
                if (column.fieldName == "InputBaseQty") { //Change fieldname according to your main qty
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[5]);
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
                s.batchEditApi.SetCellValue(focused, "InputBaseQty", temp[0]);//Change fieldname according to your main qty
            }
        }
        function ProcessCells4(selectedIndex, focused, column, s) {//Auto calculate qty function :D
            if (val == null) {
                val = ";";
                temp = val.split(';');
            }
            if (temp[0] == null) {
                temp[0] = 0;
            }
            if (selectedIndex == 0) {
                s.batchEditApi.SetCellValue(focused, "DocBaseQty", temp[0]);//Change fieldname according to your main qty
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
        function DeleteDetail(s, e) {


            var indicies = gv1.batchEditApi.GetRowVisibleIndices();

            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                    gv1.DeleteRow(indicies[i]);
                }


                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else {
                        gv1.DeleteRow(indicies[i]);

                    }
                }
            }

        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            setTimeout(function () {
                gv1.batchEditApi.EndEdit();
            }, 500);
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                //if (column.fieldName == "BulkUnit") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                //    var cellValidationInfo = e.validationInfo[column.index];
                //    if (!cellValidationInfo) continue;
                //    var value = cellValidationInfo.value;
                //    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = column.fieldName + " is required";
                //        isValid = false;
                //        console.log('')
                //    }
                //}
            }
        }

        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode);
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
            gv1.SetHeight(height - 120);
        }

        jQuery(document).ready(function (event) {//ADDNEW
            var isExpired = false;
            setInterval(checkSession, 2000);

            function checkSession() {
                var xhr = $.ajax({
                    type: "POST",
                    url: "../checksession.aspx/check",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        if (result.d && !isExpired) {
                            isExpired = true;
                            alert('User Session Expired. Please click Ok to close the window.');
                            window.close();
                        }
                    }
                });
            }
        });

    </script>
    <!--#endregion-->
</head>
<body style="height: 910px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Incoming Cargo Notice" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None"
            EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
            ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="910px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout SettingsAdaptivity-SwitchToSingleColumnAtWindowInnerWidth="600" SettingsAdaptivity-AdaptivityMode="SingleColumnWindowLimit" ID="frmlayout1" runat="server" Height="565px" Width="850px" Style="margin-left: -3px; margin-top: 49px;">

                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600"></SettingsAdaptivity>

                        <Items>

                            <%--<!--#region Region Header --> --%>
                            <%-- <!--#endregion --> --%>

                            <%--<!--#region Region Details --> --%>

                            <%-- <!--#endregion --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" OnLoad="LookupLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date:" Name="DocDate" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="deDocDate" runat="server" ReadOnly="true"  Width="170px">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Warehouse Code:" Name="WarehouseCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="glWarehouseCode" ClientInstanceName="glWarehouseCode" runat="server" AutoGenerateColumns="False" DataSourceID="Warehouse" OnLoad="LookupLoad" TextFormatString="{0}" KeyFieldName="WarehouseCode">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('WH');}" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <ErrorImage ToolTip="Warehouse Code is required">
                                                                </ErrorImage>
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Arrival Date:" Name="ArrivalDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpArrival" runat="server" OnLoad="Date_Load" Width="170px">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Plant Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvPlant" runat="server" AutoGenerateColumns="False" DataSourceID="Plant" KeyFieldName="Plantcode" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="Plantcode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Expected Delivery Date:" Name="ExpctDelDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="deExpDelDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Customer:" Name="Customer">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="glStorerKey" runat="server" AutoGenerateColumns="False" ClientInstanceName="glStorerKey" DataSourceID="Masterfilebiz" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}" ClientEnabled="true">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="DeleteDetail" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <ErrorImage ToolTip="Storer is required">
                                                                </ErrorImage>
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Expected Unloading Time:" Name="LoadingTIme">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="txtLoad" runat="server" EditFormat="Custom" EditFormatString="MM/dd/yyyy HH:mm:ss"
                                                            Width="170px" AnimationType="Slide" OnLoad="Date_Load">
                                                            <TimeSectionProperties Visible="true">
                                                            </TimeSectionProperties>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Type of Shipment:" Name="ShipmentType">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="txtShipType" AutoGenerateColumns="False" ClientInstanceName="txtShipType" OnSelectedIndexChanged="OnComboBoxSelectedIndexChanged"  runat="server"  AutoPostBack="false" Width="170px">
                                                            <Items>
                                                                <dx:ListEditItem Text="Import" Value="Import" />
                                                                <dx:ListEditItem Text="Consolidation" Value="Consolidation" />
                                                                <dx:ListEditItem Text="Local Transfer" Value="Local Transfer" />
                                                                <dx:ListEditItem Text="Others, please specify" Value="Others, please specify" />
                                                            </Items>
                                                        <%--    <ClientSideEvents SelectedIndexChanged="OnComboBoxSelectedIndexChanged" Validation="OnValidation" />--%>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink"></InvalidStyle>
                                                        </dx:ASPxComboBox>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <%--<dx:LayoutItem Caption="Supplier:" Name="SupplierCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtHSupplier" runat="server" AutoGenerateColumns="False" ClientInstanceName="txtHSupplier" DataSourceID="Masterfilebiz" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <%--<dx:LayoutItem Caption="Specify Shipment here:" runat="server">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSpecify" Enabled="False" runat="server" Width="170px" NullText="Specify other value">
                                                            <DisabledStyle BackColor="#F9F9F9" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Transtype:" Name="Transtype">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                         <dx:ASPxComboBox ID="txtHTranstype" AutoGenerateColumns="False" ClientInstanceName="txtHTranstype" runat="server" Width="170px" OnLoad="Comboboxload">
                                                            <Items>
                                                                <dx:ListEditItem Text="Normal" Value="Normal" />
                                                                <dx:ListEditItem Text="Return" Value="Return" />
                                                            </Items>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <%-- <dx:LayoutItem Caption=" " runat="server" Visible="true">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                       
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Consignee">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox  ClientInstanceName="txtConsignee" ID="txtConsignee" runat="server" Width="170px" Style="text-transform: uppercase;">
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
                                            <dx:LayoutItem Caption="Requesting Dept. Company">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtReqCoDept" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Consignee Address">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ClientInstanceName="txtConAddr" ID="txtConAddr" runat="server" Width="170px">
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

                                            <dx:LayoutItem Caption="Overtime Allowed:" Name="txtOvertime">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="txtOvertime" AutoGenerateColumns="False" ClientInstanceName="txtOvertime" runat="server" Width="170px" OnLoad="Comboboxload">
                                                            <Items>
                                                                <dx:ListEditItem Text="Yes" Value="Yes" />
                                                                <dx:ListEditItem Text="No" Value="No" />
                                                            </Items>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="ToBeSuppliedByMets:" Name="txtTBSB">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="txtTBSB" AutoGenerateColumns="False" ClientInstanceName="txtTBSB" runat="server" Width="170px" OnLoad="Comboboxload">
                                                            <Items>
                                                                <dx:ListEditItem Text="CUSTOMER" Value="CUSTOMER" />
                                                                <dx:ListEditItem Text="METS" Value="METS" />
                                                            </Items>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Additional Manpower">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="txtAddpower" AutoGenerateColumns="False" ClientInstanceName="txtTProvided" runat="server" Width="170px" OnLoad="Comboboxload">
                                                            <Items>
                                                                <dx:ListEditItem Text="Yes" Value="Yes" />
                                                                <dx:ListEditItem Text="No" Value="No" />
                                                            </Items>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Customer Ref. Document">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRefDoc" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="No. of Manpower">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtManpower" runat="server" ClientInstanceName="txtManpower" OnLoad="SpinEdit_Load" Width="170px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Truck Provided By Mets">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="txtTProvided" AutoGenerateColumns="False" ClientInstanceName="txtTProvided" runat="server" Width="170px" OnLoad="Comboboxload">
                                                            <Items>
                                                                <dx:ListEditItem Text="Yes" Value="Yes" />
                                                                <dx:ListEditItem Text="No" Value="No" />
                                                            </Items>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Status">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStatus" Enabled="false" runat="server" ReadOnly="true" Width="170px">
                                                              <DisabledStyle BackColor="#F9F9F9" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="DRNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDRNo" runat="server" ColCount="1" OnLoad="TextboxLoad" Width="170px" MaxLength="20">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Documentation Staff">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtdocstaf" enabled="false" runat="server" ReadOnly="true" Width="170px">
                                                              <DisabledStyle BackColor="#F9F9F9" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Special Instruction">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="txtSpIns" runat="server" Width="500px" Height="50px">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>

                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Other Information" ColSpan="2" ColCount="2">
                                        <Items>
                                            <%--<dx:LayoutItem Caption="Documentation Staff">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStaff" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>




                                            <dx:LayoutItem Caption="Warehouse Checker">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtChecker" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>



                                            <dx:LayoutItem Caption="Driver Name:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHDriverName" runat="server" Width="170px" ColCount="2" ReadOnly="False" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--                                            <dx:LayoutItem Caption="ContainerNo">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtContainerNo" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>





                                            <dx:LayoutItem Caption="Start Unloading">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpStart" runat="server" Width="170px" EditFormatString="MM/dd/yyyy hh:mm tt" UseMaskBehavior="True" TimeSectionProperties-Visible="True">
                                                            <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                            <dx:LayoutItem Caption="SealNo">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSeal" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Complete Unloading">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpComplete" runat="server" Width="170px" EditFormatString="MM/dd/yyyy hh:mm tt" UseMaskBehavior="True" TimeSectionProperties-Visible="True">
                                                            <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="InvoiceNo">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtInvoice" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>

                                            <dx:LayoutItem Caption="Trucker:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ClientInstanceName="txtHTruckingCo" ID="txtHTruckingCo" runat="server" Width="170px" ColCount="1" ReadOnly="False" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Plate Number:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHPlate" runat="server" Width="170px" ColCount="2" ReadOnly="False" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Truck Type:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                         <dx:ASPxGridLookup ClientInstanceName="txtTruckType" ID="txtTruckType" runat="server" AutoGenerateColumns="False" DataSourceID="TruckT" KeyFieldName="TruckType" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="TruckType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
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



                                            <%--  <dx:LayoutItem Caption="Special Instruction:" ColSpan="2" Width="500px">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSpecialIns" runat="server" Width="245px" ColCount="2" ReadOnly="False" Height="18px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field 1:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
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

                            <dx:LayoutGroup Caption="ICN Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <div id="loadingcont">
                                                    <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="747px"
                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                        OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber"
                                                        SettingsBehavior-AllowSort="false" OnRowValidating="grid_RowValidating">
                                                        <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                            BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" />
                                                        <SettingsPager Mode="ShowAllRecords" />
                                                        <SettingsEditing Mode="Batch" />
                                                        <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="530" ShowFooter="True" />

                                                        <SettingsBehavior AllowSort="False"></SettingsBehavior>

                                                        <SettingsCommandButton>
                                                            <NewButton>
                                                                <Image IconID="actions_addfile_16x16"></Image>
                                                            </NewButton>
                                                            <DeleteButton>
                                                                <Image IconID="actions_cancel_16x16"></Image>
                                                            </DeleteButton>
                                                        </SettingsCommandButton>
                                                        <Columns>
                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="1">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="3" Caption="LineNumber" ReadOnly="True" Width="100px">
                                                            </dx:GridViewDataTextColumn>

                                                            <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="5" Width="100px" Name="glItemCode">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="glItemCode_Init"
                                                                        DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" AllowDragDrop="False" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                            <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                        </Columns>
                                                                        <ClientSideEvents DropDown="function(s,e){gl.GetGridView().PerformCallback('ItemCodeDropDown' + '|' + glStorerKey.GetValue());}" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                            ValueChanged="function(s,e){
                                                                        //console.log(itemc+''+gl.GetValue());
                                                                        if(itemc != gl.GetValue()){
                                                                        loader.SetText('Loading...');
                                                                        loader.Show();
                                                                        closing = true;
                                                                        gl2.GetGridView().PerformCallback('ItemCode' + '|' + gl.GetValue() + '|' + 'code' + '|' + bulkqty);
      
                                                                        e.processOnServer = false;
                                                                        
                                                                        valchange2 = true;}
                                                                  }" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn ReadOnly="true" FieldName="FullDesc" VisibleIndex="6" Width="250px" Caption="Description">
                                                            </dx:GridViewDataTextColumn>
                                                          

                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Caption="Status Code" FieldName="StatusCode" Name="StatusCode" ShowInCustomizationForm="True" VisibleIndex="20">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Caption="Barcode Number" FieldName="BarcodeNo" Name="BarcodeNo" ShowInCustomizationForm="True" VisibleIndex="18">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataSpinEditColumn Visible="false" FieldName="Price" Caption="Price" VisibleIndex="8" Width="110px">
                                                                <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0"
                                                                    ClientInstanceName="gBulkQty" MinValue="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="function(s,e){
                                                                         loader.SetText('Calculating');
                                                                         loader.Show();
                                                                         gl4.GetGridView().PerformCallback('BulkQty' + '|' + itemc + '|' + s.GetValue());
                                                                         e.processOnServer = false;
                                                                         valchange = true;}" />
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>

                                                            <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="7" Width="0px" Caption="Color">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                        KeyFieldName="ColorCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" OnInit="lookup_Init">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0">
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                            DropDown="function dropdown(s, e){
                                                                 
                                                                        gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }"
                                                                            CloseUp="gridLookup_CloseUp" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="9" Width="0px" Name="glClassCode" Caption="Class">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                        KeyFieldName="ClassCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" />
                                                                        </Columns>
                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                            DropDown="function dropdown(s, e){
                                                                        gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }"
                                                                            CloseUp="gridLookup_CloseUp" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="13" Width="0px" Name="glSizeCode" Caption="Size">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                        KeyFieldName="SizeCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                                                                        </Columns>
                                                                        <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                            DropDown="function dropdown(s, e){
                                                                        gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }"
                                                                            CloseUp="gridLookup_CloseUp" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataSpinEditColumn Caption="Documented Kilos" Name="InputBaseQty" ShowInCustomizationForm="True" VisibleIndex="11" FieldName="InputBaseQty" PropertiesSpinEdit-DisplayFormatString="{0:N4}" UnboundType="Decimal" Width="100px">
                                                                <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N4}" MaxValue="9999999999" MinValue="0" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>

                                                            <dx:GridViewDataSpinEditColumn Caption="Received Kilos" Name="DocBaseQty" ShowInCustomizationForm="True" VisibleIndex="14" FieldName="DocBaseQty" PropertiesSpinEdit-DisplayFormatString="{0:N4}" UnboundType="Decimal" Width="100px">
                                                                <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N4}" MaxValue="9999999999" MinValue="0" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                            <dx:GridViewDataSpinEditColumn Caption="Received Qty" Name="DocBulkQty" ShowInCustomizationForm="True" VisibleIndex="12" FieldName="DocBulkQty" PropertiesSpinEdit-DisplayFormatString="{0:N}" UnboundType="Decimal" Width="100px">
                                                                <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0"
                                                                    ClientInstanceName="s" MinValue="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="function(s,e){
                                                                         loader.SetText('Calculating');
                                                                         loader.Show();
                                                                         gl4.GetGridView().PerformCallback('BulkQty' + '|' + itemc + '|' + s.GetValue());
                                                                         e.processOnServer = false;
                                                                         valchange3 = true;}" />
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                            <dx:GridViewDataDateColumn FieldName="ManufacturingDateICN" Caption="Mfg Date" ShowInCustomizationForm="True" VisibleIndex="17">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Caption="Batch Number" FieldName="BatchNumberICN" Name="BatchNumber" ShowInCustomizationForm="True" VisibleIndex="15">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Caption="Lot ID" FieldName="LotNo" Name="LotID" ShowInCustomizationForm="True" VisibleIndex="16">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>

                                                            <dx:GridViewDataDateColumn FieldName="ExpiryDateICN" Caption="ExpiryDate" ShowInCustomizationForm="True" VisibleIndex="18" Name="dtpExpiryDate">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataSpinEditColumn FieldName="BulkQty" Caption="Documented Qty" VisibleIndex="10" Width="110px">
                                                                <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0"
                                                                    ClientInstanceName="gBulkQty" MinValue="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="function(s,e){
                                                                         loader.SetText('Calculating');
                                                                         loader.Show();
                                                                         gl4.GetGridView().PerformCallback('BulkQty' + '|' + itemc + '|' + gBulkQty.GetValue());
                                                                         e.processOnServer = false;
                                                                         valchange = true;}" />
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                            <dx:GridViewDataTextColumn FieldName="BulkUnit" VisibleIndex="19" Width="100px">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="BulkUnit" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                        DataSourceID="Unit" KeyFieldName="UnitCode" ClientInstanceName="glBulkUnit" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" />
                                                                        </Columns>
                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" RowClick="gridLookup_CloseUp" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>      
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="200px" Caption="SpecialHandlingInstruction" FieldName="SpecialHandlingInstruc" Name="SpecialHandlingInstruc" ShowInCustomizationForm="True" VisibleIndex="25">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <%--<dx:GridViewDataTextColumn PropertiesTextEdit-Native="true"  Width="120px" Caption="Outlet" FieldName="UDF01" Name="UDF01" ShowInCustomizationForm="True" VisibleIndex="26">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="120px" Caption="Drop No" FieldName="UDF02" Name="UDF02" ShowInCustomizationForm="True" VisibleIndex="27">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>--%>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="120px" Caption="Deliver Receipt" FieldName="UDF03" Name="UDF03" ShowInCustomizationForm="True" VisibleIndex="28">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                             <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="120px" Caption="Remarks1" FieldName="MLIRemarks01" Name="Remarks" ShowInCustomizationForm="True" VisibleIndex="29">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="120px" Caption="Remarks2" FieldName="MLIRemarks02" Name="Remarks" ShowInCustomizationForm="True" VisibleIndex="30">
                                                                <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <%--<dx:GridViewDataTextColumn Caption="Price" Name="Price" ShowInCustomizationForm="True" VisibleIndex="13" FieldName="Price" UnboundType="Decimal">
                                                            </dx:GridViewDataTextColumn>--%>
                                                            <%--<dx:GridViewDataTextColumn Caption="StatusCode" Name="StatusCode" ShowInCustomizationForm="True" VisibleIndex="15" FieldName="StatusCode" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>--%>
                                                            <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="2" Width="60px">
                                                                <CustomButtons>
                                                                    <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                        <Image IconID="support_info_16x16"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>

                                                            </dx:GridViewCommandColumn>
                                                            <%--<dx:GridViewDataTextColumn Caption="Type" Name="IncomingDocType" ShowInCustomizationForm="True" VisibleIndex="3" FieldName="IncomingDocType" UnboundType="String" Width="50px">
                                                            </dx:GridViewDataTextColumn>--%>
                                                            <%--<dx:GridViewDataTextColumn Caption="Remarks" Name="Remarks" ShowInCustomizationForm="True" VisibleIndex="17" FieldName="Remarks" UnboundType="String">
                                                            </dx:GridViewDataTextColumn>--%>
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
                                                            <%--<dx:GridViewDataTextColumn Caption="Barcode No." FieldName="BarcodeNo" Name="BarcodeNo" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="16">
                                                            </dx:GridViewDataTextColumn>--%>
                                                        </Columns>
                                                    </dx:ASPxGridView>
                                                </div>
                                                <%--                                                <dx:ASPxLabel runat="server" Text="Min: " Width="100px" ClientInstanceName="Min"></dx:ASPxLabel>
                                                <dx:ASPxLabel runat="server" Text="Max: " Width="100px" ClientInstanceName="Max"></dx:ASPxLabel>
                                                <dx:ASPxLabel runat="server" Text="Average: " Width="150px" ClientInstanceName="Average"></dx:ASPxLabel>
                                                <dx:ASPxLabel runat="server" Text="Sum: " Width="100px" ClientInstanceName="Sum"></dx:ASPxLabel>
                                                <dx:ASPxLabel runat="server" Text="Sum of BulkQty: " Width="177px" ClientInstanceName="Bulk"></dx:ASPxLabel>
                                                <dx:ASPxButton ID="btnCancel" runat="server" Text="Cancel Changes" ClientInstanceName="btnCancel" CausesValidation="false" AutoPostBack="false" UseSubmitBehavior="false">
                                                    <ClientSideEvents Click="OnCancelClick" />
                                                </dx:ASPxButton>--%>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>

                        </Items>
                    </dx:ASPxFormLayout>

                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <div class="pnl-content">
                        <dx:ASPxCheckBox Style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                        <dx:ASPxButton ID="updateBtn" runat="server" Text="Add" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                            UseSubmitBehavior="false" CausesValidation="true">
                            <ClientSideEvents Click="OnUpdateClick" />
                        </dx:ASPxButton>
                    </div>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
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
            ClientInstanceName="loader" ContainerElementID="loadingcont" Modal="true">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.ICN" DataObjectTypeName="Entity.ICN" DeleteMethod="DeleteData" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ICN+ICNDetail" DataObjectTypeName="Entity.ICN+ICNDetail" DeleteMethod="DeleteICNDetail" InsertMethod="AddICNDetail" UpdateMethod="UpdateICNDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  WMS.ICNDetail where DocNumber  is null " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,'')=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BizPartner WHERE (ISNULL(IsInactive, '') = 0)" OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Unit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.Unit where ISNULL(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Plant" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Plantcode,WarehouseCode from Masterfile.Plant" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="TruckT" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select TruckType from it.TruckType" OnInit="Connection_Init"></asp:SqlDataSource>
   
    <!--#endregion-->
</body>
</html>


