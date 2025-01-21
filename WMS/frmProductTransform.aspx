<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmProductTransform.aspx.cs" Inherits="GWL.frmProductTransform" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Product Transform</title>
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
            if (glStorerKey.GetText() == "" || glDocnumber.GetText() == "") {

                isValid = false;
            }
            else {
                isValid = true;
            }
        }

        var baseqty = 0;
        function OnUpdateClick(s, e) { //Add/Edit/Close button function

            //var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            //for (var i = 0; i < indicies.length; i++) {
            //    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
            //        gv1.batchEditApi.ValidateRow(indicies[i]);
            //        gv1.batchEditApi.StartEdit(indicies[i]);
            //    }
            //    else {
            //        var key = gv1.GetRowKey(indicies[i]);
            //        if (gv1.batchEditApi.IsDeletedRow(key))
            //            console.log("deleted row " + indicies[i]);
            //        else {
            //            gv1.batchEditApi.ValidateRow(indicies[i]);
            //            gv1.batchEditApi.StartEdit(indicies[i]);
            //        }
            //    }
            //}

            //gv1.batchEditApi.EndEdit();

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

            if (s.cp_search) {

                console.log("done cp");

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
        var valchange4;
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
                itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "Item"); //needed var for all lookups; this is where the lookups vary for
                console.log('Start:' + e.focusedColumn.fieldName);
                if (bulkqty == null) {
                    bulkqty = 0;
                }

                //checks the value of each button
                if (e.focusedColumn.fieldName == "Item") {//Check the column name
                    console.log('item2');
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                }
                if (e.focusedColumn.fieldName == "UOM") {
                    glUOM.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                    index = e.visibleIndex;

                }

            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            console.log('end');
            //displays the value of selected from the lookup
            if (entry != "V" && entry != "D") {
                var cellInfo = e.rowValues[currentColumn.index];
                if (currentColumn.fieldName === "Item") {
                    console.log(gl.GetText());
                    cellInfo.value = gl.GetValue();
                    cellInfo.text = gl.GetText();
                }

                if (currentColumn.fieldName == "UOM") {
                    cellInfo.value = glUOM.GetValue();
                    cellInfo.text = glUOM.GetText();
                }

            }


        }

        var val;
        var temp;

        function GridEnd(s, e) {
            console.log('gridend');
            val = s.GetGridView().cp_codes;

            temp = val.split(';');
            if (valchange) {
                console.log(val);
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
            if (valchange4) {
                console.log(val);
            }

            if (valchange2) {
                valchange2 = false;
                closing = false;
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
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
        function Search(s, e) {
            if ([null, ""].includes(glStorerKey.GetText(), glDocnumber.GetText())) {
                alert("Values required before searching:\n1. Customer\n2. OCN Number\n3. Reference Date")
            }
            else {
                var search = confirm("Is the following data in Customer,OCN Number and Reference Date correct?");
                if (search) {
                    cp.PerformCallback('Search');
                }
            }

        }
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
            gv1.SetWidth(width - 120);//sets the width and height of gv1 id to be responsive
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
                    <dx:ASPxLabel runat="server" Text="Product Transform" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
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
                                                        <dx:ASPxTextBox ReadOnly="true" ID="txtDocnumber" runat="server" Width="170px" OnLoad="LookupLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date:" Name="DocDate" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ReadOnly="true" ID="deDocDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Customer:" Name="Customer">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup Width="170px" ID="glStorerKey" runat="server" AutoGenerateColumns="False" ClientInstanceName="glStorerKey" DataSourceID="Masterfilebiz" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}">
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
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('CC');}" />
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

                                            <dx:LayoutItem Caption="OCN Docnumber:" Name="OCNdocnumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glDocnumber" runat="server" AutoGenerateColumns="False" DataSourceID="OCN" KeyFieldName="OCNdocnumber" Width="170px"
                                                            ClientInstanceName="glDocnumber" OnLoad="LookupLoad" TextFormatString="{0}">

                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="OCNdocnumber" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains"></dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="WarehouseCode" ShowInCustomizationForm="True" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation" />
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
                                            <dx:LayoutItem Caption="Reference Date:" Name="RefDocDate" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="refDocDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="" Name="Search">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxButton ID="Searchbtn" runat="server" AutoPostBack="False" CausesValidation="False" Text="Search" UseSubmitBehavior="False" Width="170px">
                                                            <ClientSideEvents Click="Search" />
                                                        </dx:ASPxButton>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                        </Items>
                                    </dx:LayoutGroup>

                                </Items>
                            </dx:TabbedLayoutGroup>

                            <dx:LayoutGroup Caption="Product Detail">
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
                                                        <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="530" ShowFooter="True" />

                                                        <SettingsBehavior AllowSort="False"></SettingsBehavior>

                                                        <SettingsCommandButton>
                                                            <%--<NewButton>
                                                                <Image IconID="actions_addfile_16x16"></Image>
                                                            </NewButton>--%>
                                                            <DeleteButton>
                                                                <Image IconID="actions_cancel_16x16"></Image>
                                                            </DeleteButton>
                                                        </SettingsCommandButton>
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="60px">
                                                                <CustomButtons>
                                                                    <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                        <Image IconID="support_info_16x16"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>

                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="False" Caption="#" ReadOnly="True" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="OCN Docnumber" ReadOnly="true" FieldName="DocNumber" VisibleIndex="1">
                                                                <PropertiesTextEdit>
                                                                    <Style Border-BorderWidth="0">
                                                                     </Style>
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                           <dx:GridViewDataTextColumn Caption="Customer Code" ReadOnly="true" FieldName="Customercode" VisibleIndex="1">
                                                                <PropertiesTextEdit>
                                                                    <Style Border-BorderWidth="0">
                                                                     </Style>
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataDateColumn ReadOnly="true" FieldName="MfgDate" Caption="Mfg Date" ShowInCustomizationForm="True" VisibleIndex="2">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataDateColumn ReadOnly="true" FieldName="ExpiryDate" Caption="Expiry Date" ShowInCustomizationForm="True" VisibleIndex="3">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataTextColumn ReadOnly="true" FieldName="Itemcode" VisibleIndex="4" Width="100px" Caption="ItemCode">

                                                                <PropertiesTextEdit>
                                                                    <Style Border-BorderWidth="0">
                                                                     </Style>
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn ReadOnly="true" FieldName="PalletID" Name="PalletID" VisibleIndex="5" Width="100px" Caption="PalletID">

                                                                <PropertiesTextEdit>
                                                                    <Style Border-BorderWidth="0">
                                                                     </Style>
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataSpinEditColumn ReadOnly="true" FieldName="Quantity" Name="Quantity" VisibleIndex="6" Width="90px" Caption="Qty" PropertiesSpinEdit-DisplayFormatString="{0:N}" UnboundType="Decimal">
                                                            </dx:GridViewDataSpinEditColumn>


                                                            <dx:GridViewDataSpinEditColumn Caption="Kilos" Name="Kilos" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="Kilos" PropertiesSpinEdit-DisplayFormatString="{0:N}" UnboundType="Decimal" Width="100px">
                                                                <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}" MaxValue="9999999999999999" MinValue="0" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                            <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="120px" Caption="Batch #" FieldName="Batchno" Name="Batchno" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                <PropertiesTextEdit Width="100px" Native="True"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="UOM" Name="UOM" VisibleIndex="9" Width="200px">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glUOM" runat="server" ClientInstanceName="glUOM" Width="170px" DataSourceID="UOMd" OnLoad="gvLookupLoad" KeyFieldName="UOM">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" AllowDragDrop="False" />
                                                                            <Settings ShowFilterRow="True"></Settings>
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="UOM" ReadOnly="True" Settings-AutoFilterCondition="Contains" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" />
                                                                    </dx:ASPxGridLookup>

                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                        </Columns>
                                                    </dx:ASPxGridView>
                                                </div>

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


    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.ProductTransform" SelectMethod="getdata" TypeName="Entity.ProductTransform" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="Docnumber" Name="Docnumber" SessionField="Docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ProductTransform+ProductTransformDetail" DataObjectTypeName="Entity.ProductTransform+ProductTransformDetail" DeleteMethod="DeleteProductDetail" InsertMethod="AddProductDetail" UpdateMethod="UpdateProductDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="DocNumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  WMS.[ProductTransformDetail] where DocNumber is not null " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,'')=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BizPartner WHERE (ISNULL(IsInactive, '') = 0)" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="AreaCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT CustomerCode,StorageType FROM PORTAL.IT.PalletInfo" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Customer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select BizPartnerCode from masterfile.BizPartner"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="OCN" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select Docnumber as OCNdocnumber,WarehouseCode,StorerKey from wms.ocn where SubmittedDate is not null"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="UOMd" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT 'PCS' AS UOM UNION ALL SELECT 'Pack' AS UOM UNION ALL SELECT 'Box' AS UOM UNION ALL SELECT 'Bulk' AS UOM UNION ALL SELECT 'Sack' AS UOM UNION ALL SELECT 'Crates' AS UOM"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


