<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmJournalVoucher.aspx.cs" Inherits="GWL.frmJournalVoucher" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>



<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <script src="../js/keyboardNavi.js" type="text/javascript"></script>
    <title>Journal Voucher</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 450px; /*Change this whenever needed*/
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
            }
            else {
                isValid = true;
            }
        }

        function OnUpdateClick(s, e) { //Add/Edit/Close button function

            var btnmode = btn.GetText(); //gets text of button


            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                    gv1.batchEditApi.ValidateRow(indicies[i]);
                    gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("Field1").index);
                }
                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else {
                        gv1.batchEditApi.ValidateRow(indicies[i]);
                        gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("Field1").index);
                    }
                }
            }

            gv1.batchEditApi.EndEdit();

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
                delete (s.cp_success); //deletes cache variables' data
                delete (s.cp_message);


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
                    window.close(); //close window if callback successful
                }
            }
            if (s.cp_delete) {
                delete (cp_delete);
                DeleteControl.Show();
            }
            if (s.cp_generated) {
                delete (s.cp_generated);
                console.log('autocalculate');
                autocalculate();
            }

            if (s.cp_forceclose) {
                delete (s.cp_forceclose);
                window.close();

            }
        }

        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var accountcode;
        var valchange2 = false;
        var index;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            accountcode = s.batchEditApi.GetCellValue(e.visibleIndex, "AccountCode"); //needed var for all lookups; this is where the lookups vary for
            index = e.visibleIndex;
            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}
            if (entry == "V" || entry == "D") {
                e.cancel = true; //this will made the gridview readonly
            }
            if (e.focusedColumn.fieldName === "AccountCode") { //Check the column name
                gl.GetInputElement().value = cellInfo.value; //Gets the column value
                isSetTextRequired = true;
            }
            if (e.focusedColumn.fieldName === "SubsiCode") {
                gl2.GetInputElement().value = cellInfo.value;
                //isSetTextRequired = true;
            }
            if (e.focusedColumn.fieldName === "ProfitCenterCode") {
                gl3.GetInputElement().value = cellInfo.value;
                isSetTextRequired = true;
            }
            if (e.focusedColumn.fieldName === "CostCenterCode") {
                gl4.GetInputElement().value = cellInfo.value;
                isSetTextRequired = true;
            }
            if (e.focusedColumn.fieldName === "BizPartnerCode") {
                gl5.GetInputElement().value = cellInfo.value;
                isSetTextRequired = true;
            }
            if (e.focusedColumn.fieldName === "Credit") {
                if ((s.batchEditApi.GetCellValue(e.visibleIndex, "Debit") != null) && (s.batchEditApi.GetCellValue(e.visibleIndex, "Debit") != 0))
                    e.cancel = true;
            }
            if (e.focusedColumn.fieldName === "Debit") {
                if ((s.batchEditApi.GetCellValue(e.visibleIndex, "Credit") != null) && (s.batchEditApi.GetCellValue(e.visibleIndex, "Credit") != 0))
                    e.cancel = true;
            }
            keybGrid = s;
            keyboardOnStart(e);
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "AccountCode") {
                cellInfo.value = gl.GetValue();
                cellInfo.text = gl.GetText();
            }
            if (currentColumn.fieldName === "SubsiCode") {
                cellInfo.value = gl2.GetValue();
                cellInfo.text = gl2.GetText();
 
            }
            if (currentColumn.fieldName === "ProfitCenterCode") {
                cellInfo.value = gl3.GetValue();
                cellInfo.text = gl3.GetText();
            }
            if (currentColumn.fieldName === "CostCenterCode") {
                cellInfo.value = gl4.GetValue();
                cellInfo.text = gl4.GetText();
            }
            if (currentColumn.fieldName === "BizPartnerCode") {
                cellInfo.value = gl5.GetValue();
                cellInfo.text = gl5.GetText();
            }
            keyboardOnEnd();
        }
        function autocalculate(s, e) {

            //OnInitTrans();
            //console.log(txtNewUnitCost.GetValue());
            var debit = 0;
            var totaldebit = 0;
            var credit = 0;
            var totalcredit = 0;


            setTimeout(function () { //New Rows
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        debit = gv1.batchEditApi.GetCellValue(indicies[i], "Debit");
                        credit = gv1.batchEditApi.GetCellValue(indicies[i], "Credit");
                        totaldebit += debit;
                        totalcredit += credit;
                    }
                    else { //Existing Rows
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            debit = gv1.batchEditApi.GetCellValue(indicies[i], "Debit");
                            credit = gv1.batchEditApi.GetCellValue(indicies[i], "Credit");
                            totaldebit += debit;
                            totalcredit += credit;
                        }
                    }


                }
                spTotalDebit.SetText(totaldebit.toFixed(2));
                spTotalCredit.SetText(totalcredit.toFixed(2));
            }, 500);
        }
        function lookup(s, e) {
            if (isSetTextRequired) {//Sets the text during lookup for item code
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
                console.log('a');
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
            if (keyCode == 13) {
                gv1.batchEditApi.EndEdit();
            }
            if (keyCode == ASPxKey.Enter)
                gv1.batchEditApi.EndEdit();
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                if (column.fieldName == "AccountCode" || column.fieldName == "SubsiCode" || column.fieldName == "ProfitCenterCode" || column.fieldName == "CostCenterCode" || column.fieldName == "BizPartnerCode") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                        e.isValid = false;
                    }
                }
            }
        }

        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var BizPartnerCode = s.batchEditApi.GetCellValue(e.visibleIndex, "BizPartnerCode");


                factbox.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);

            }
            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate();
            }

        }

        function typechanged(s, e) {
            var type = cboType.GetText();
            console.log(type);
            if (type == "JV Template" || type == "JVT") {
                glRef.SetEnabled(true);
                //glRef.SetValue(null);
            }
            else {
                console.log('here');
                glRef.SetEnabled(false);
                glRef.SetValue(null);
            }
        }

        function OnInitTrans(s, e) {
            AdjustSize();
            OnInit(s);
        }

        function OnControlsInitialized(s, e) {
            ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                AdjustSize();
            });
        }

        function AdjustSize() {
            var width = Math.max(0, document.documentElement.clientWidth);
            gv1.SetWidth(width - 120);
            gvJournal.SetWidth(width - 120);
        }

        //#region For future reference JS 

        function OnGetRowValues(values) {
            gv1.batchEditApi.SetCellValue(index, 'AccountCode', values[0]);
            gv1.batchEditApi.SetCellValue(index, 'Description', values[1]);
            //var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            //for (var i = 0; i < indicies.length; i++) {
            gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField("SubsiCode").index);
            //}
        }
        function OnGetRowValuesSubsiCode(values){

            gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField("ProfitCenterCode").index);
        }
        function OnGetRowValuesProfitCenterCode(values) {

            gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField("CostCenterCode").index);
        }
        function OnGetRowValuesCostCenterCode(values) {

            gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField("BizPartnerCode").index);
        }
        function OnGetRowValuesBizPartnerCode(values) {

            gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField("Debit").index);
        }

    </script>
    <!--#endregion-->
</head>
<body style="height: 910px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">

        <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None"
            EnableViewState="False" HeaderText="BizPartner info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="50"
            ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent ID="PanelContent1" runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Journal Voucher" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>

        <%--<dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">--%>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback" SettingsLoadingPanel-Enabled="true" SettingsLoadingPanel-Delay="3000" Images-LoadingPanel-Url="..\images\loadinggear.gif" Images-LoadingPanel-Height="30px" Styles-LoadingPanel-BackColor="Transparent" Styles-LoadingPanel-Border-BorderStyle="None" SettingsLoadingPanel-Text="" SettingsLoadingPanel-ShowImage="true">

            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent ID="PanelContent2" runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="FormLayout" runat="server" Height="558px" Width="850px" Style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>

                            <dx:TabbedLayoutGroup>
                                <Items>


                                    <dx:LayoutGroup Caption="Header" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                        <dx:ASPxTextBox ID="txtDoc" runat="server" ReadOnly="true" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date:" Name="DocDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                        <dx:ASPxDateEdit ID="deDocDate" OnLoad="Date_Load" runat="server" OnInit="deDocDate_Init" Width="170px">
                                                            <%--  <ClientSideEvents Init="function(s,e){ s.SetDate(new Date());}" Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>--%>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Template Type:" Name="TemplateType">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                        <dx:ASPxComboBox ID="cboType" OnLoad="Comboboxload" runat="server" Width="170px" ClientInstanceName="cboType">
                                                            <ClientSideEvents SelectedIndexChanged="typechanged" />
                                                            <Items>
                                                                <dx:ListEditItem Text="Manual" Value="M" Selected="true" />
                                                                <dx:ListEditItem Text="Recurring JV" Value="RJV" />
                                                                <dx:ListEditItem Text="JV Template" Value="JVT" />
                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Debit:" Name="TotalDebit">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                                        <dx:ASPxTextBox ID="spTotalDebit" runat="server" ClientInstanceName="spTotalDebit" DisplayFormatString="{0:N}" Number="0.00" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Reference Template Code:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
                                                        <dx:ASPxGridLookup ID="glRef" ClientInstanceName="glRef" runat="server" OnLoad="LookupLoad" AutoGenerateColumns="False" DataSourceID="JVTemplate" KeyFieldName="DocNumber" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false" />
                                                                <Settings ShowFilterRow="True" />

                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataDateColumn FieldName="DocDate" ShowInCustomizationForm="True" VisibleIndex="1" Width="100px" ReadOnly="true">
                                                                    <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible="false">
                                                                        <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                    </PropertiesDateEdit>
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataDateColumn>
                                                                <dx:GridViewDataTextColumn FieldName="TotalDebit" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                    <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="TotalCredit" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                    <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Init="typechanged" ValueChanged="function(s,e){cp.PerformCallback('JVT')} " />
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Credit:" Name="TotalCredit">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                                        <dx:ASPxTextBox ID="spTotalCredit" runat="server" ClientInstanceName="spTotalCredit" DisplayFormatString="{0:N}" Number="0.00" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- <dx:LayoutItem Caption="Memo">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
                                                        <dx:ASPxTextBox ID="txtMemo" OnLoad="TextboxLoad" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             </Items>
                                    </dx:LayoutGroup>--%>
                                            <dx:LayoutItem Caption="Memo">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="txtMemo" runat="server" OnLoad="memoremarks_Load" Width="843px" Height="200px">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="User Defined Fields" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field 1:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer8" runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer9" runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer10" runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer11" runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer12" runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer13" runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer14" runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer15" runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer16" runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Journal Entries">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer17" runat="server">
                                                        <dx:ASPxGridView ID="gvJournal" runat="server" AutoGenerateColumns="False" Width="850px" ClientInstanceName="gvJournal" KeyFieldName="RTransType;TransType">
                                                            <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />
                                                            <SettingsPager Mode="ShowAllRecords" />
                                                            <SettingsEditing Mode="Batch" />
                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130" />
                                                            <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="AccountCode" Name="jAccountCode" ShowInCustomizationForm="True" VisibleIndex="0" Width="120px" Caption="Account Code">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="AccountDescription" Name="jAccountDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width="150px" Caption="Account Description">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="SubsidiaryCode" Name="jSubsidiaryCode" ShowInCustomizationForm="True" VisibleIndex="2" Width="120px" Caption="Subsidiary Code">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="SubsidiaryDescription" Name="jSubsidiaryDescription" ShowInCustomizationForm="True" VisibleIndex="3" Width="150px" Caption="Subsidiary Description">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="ProfitCenter" Name="jProfitCenter" ShowInCustomizationForm="True" VisibleIndex="4" Width="120px" Caption="Profit Center">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="CostCenter" Name="jCostCenter" ShowInCustomizationForm="True" VisibleIndex="5" Width="120px" Caption="Cost Center">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Debit" Name="jDebit" ShowInCustomizationForm="True" VisibleIndex="6" Width="120px" Caption="Debit  Amount">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Credit" Name="jCredit" ShowInCustomizationForm="True" VisibleIndex="7" Width="120px" Caption="Credit Amount">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Audit Trail" ColCount="2" ColSpan="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer18" runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer19" runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer20" runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer21" runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer22" runat="server">
                                                        <dx:ASPxTextBox ID="txtSubmittedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer23" runat="server">
                                                        <dx:ASPxTextBox ID="txtSubmittedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Posted By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer24" runat="server">
                                                        <dx:ASPxTextBox ID="txtPostedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Posted Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer25" runat="server">
                                                        <dx:ASPxTextBox ID="txtPostedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>

                            <dx:LayoutGroup Caption="Lines">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer26" runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="747px" DataSourceID="sdsDetail"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber">
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager Mode="ShowAllRecords" />
                                                    <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="400" ShowStatusBar="Hidden" />
                                                    <SettingsBehavior AllowSort="False" AllowDragDrop="False" />
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="True"
                                                            VisibleIndex="0" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px" ShowNewButtonInHeader="true">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                    <Image IconID="actions_cancel_16x16"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                    <Image IconID="support_info_16x16"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Caption="Line" ReadOnly="True" Width="0px" Visible="True">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" VisibleIndex="3" Width="150px" Name="glAccountCode" Caption="AccountCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glAccountCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="AccountCode" KeyFieldName="AccountCode" ClientInstanceName="gl" TextFormatString="{0}" Width="150px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp"
                                                                        RowClick="function(s,e){
                                                                                        loader.SetText('Loading...'); loader.Show(); 
                                                                                        setTimeout( function() { var g = gl.GetGridView(); 
                                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'AccountCode;Description', OnGetRowValues); loader.Hide();},1000)}" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4" UnboundType="String" Width="150px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubsiCode" VisibleIndex="5" Width="150px" Caption="SubsiCode" Name="glSubsiCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSubsiCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" DataSourceID="SubsiCode"
                                                                    KeyFieldName="SubsiCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="150px" OnInit="lookup_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SubsiCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />

                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="function dropdown(s, e){
                                                                                gl2.GetGridView().PerformCallback('SubsiGetCode' + '|' + accountcode);
                                                                            }"
                                                                        KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" CloseUp="gridLookup_CloseUp"   RowClick="function(s,e){
                                                                                        loader.SetText('Loading...'); loader.Show(); 
                                                                                        setTimeout( function() { var g = gl.GetGridView(); 
                                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'Description', OnGetRowValuesSubsiCode); loader.Hide();},1000)}"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" VisibleIndex="6" Width="150px" Name="glProfitCenterCode" Caption="ProfitCenterCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glProfitCenterCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" DataSourceID="ProfitCenterCode"
                                                                    KeyFieldName="ProfitCenterCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="150px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        CloseUp="gridLookup_CloseUp" DropDown="lookup"  RowClick="function(s,e){
                                                                                        loader.SetText('Loading...'); loader.Show(); 
                                                                                        setTimeout( function() { var g = gl.GetGridView(); 
                                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'Description', OnGetRowValuesProfitCenterCode); loader.Hide();},1000)}"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" VisibleIndex="7" Width="150px" Name="glCostCenterCode" Caption="CostCenterCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glCostCenterCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" DataSourceID="CostCenterCode"
                                                                    KeyFieldName="CostCenterCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="150px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        CloseUp="gridLookup_CloseUp" DropDown="lookup"  RowClick="function(s,e){
                                                                                        loader.SetText('Loading...'); loader.Show(); 
                                                                                        setTimeout( function() { var g = gl.GetGridView(); 
                                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'Description', OnGetRowValuesCostCenterCode); loader.Hide();},1000)}"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" VisibleIndex="8" Width="150px" Name="glBizPartnerCode" Caption="BizPartnerCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glBizPartnerCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" DataSourceID="BizPartnerCode"
                                                                    KeyFieldName="BizPartnerCode" ClientInstanceName="gl5" TextFormatString="{0}" Width="150px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        CloseUp="gridLookup_CloseUp" DropDown="lookup" RowClick="function(s,e){
                                                                                        loader.SetText('Loading...'); loader.Show(); 
                                                                                        setTimeout( function() { var g = gl.GetGridView(); 
                                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'Description', OnGetRowValuesBizPartnerCode); loader.Hide();},1000)}"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Debit" FieldName="Debit" Name="spDebit" ShowInCustomizationForm="True" VisibleIndex="9" Width="150px" PropertiesSpinEdit-LargeIncrement="0">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="spDebit" MinValue="0" MaxValue="9999999999" DisplayFormatString="{0:N}">
                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                <SpinButtons ShowIncrementButtons="false" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Credit" FieldName="Credit" Name="spCredit" ShowInCustomizationForm="True" VisibleIndex="10" Width="150px" PropertiesSpinEdit-LargeIncrement="0">
                                                            <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}" ClientInstanceName="spCredit" MinValue="0" MaxValue="9999999999">
                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                <SpinButtons ShowIncrementButtons="false" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="11" FieldName="Field1" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="12" FieldName="Field2" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="13" FieldName="Field3" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="14" FieldName="Field4" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="15" FieldName="Field5" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="16" FieldName="Field6" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="17" FieldName="Field7" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="18" FieldName="Field8" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="19" FieldName="Field9" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                </dx:ASPxGridView>
                                                <%--  <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Loading..."
                                                                    ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
                                                                    <LoadingDivStyle Opacity="0"></LoadingDivStyle>
                                                                </dx:ASPxLoadingPanel>--%>

                                                <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="" Image-Url="..\images\loadinggear.gif" Image-Height="30px" Image-Width="30px" Height="30px" Width="30px" Enabled="true" ShowImage="true" BackColor="Transparent" Border-BorderStyle="None"
                                                    ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
                                                    <LoadingDivStyle Opacity="0"></LoadingDivStyle>
                                                </dx:ASPxLoadingPanel>


                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>

                        </Items>
                    </dx:ASPxFormLayout>


                    <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent ID="PanelContent3" runat="server" SupportsDisabledAttribute="True">
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
                    <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="Are you sure you want to delete this specific document?" />
                    <table>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                    <ClientSideEvents Click="function (s, e){ gv1.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
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
        <!--#region Region Datasource-->
        <%--                                                      
                                                            </Columns>--%>
        <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.JournalVoucher" DataObjectTypeName="Entity.JournalVoucher" InsertMethod="InsertData" UpdateMethod="UpdateData">
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.JournalVoucher+JournalVoucherDetail" DataObjectTypeName="Entity.JournalVoucher+JournalVoucherDetail" DeleteMethod="DeleteJournalVoucherDetail" InsertMethod="AddJournalVoucherDetail" UpdateMethod="UpdateJournalVoucherDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.*, B.Description FROM  Accounting.JournalVoucherDetail A INNER JOIN Accounting.ChartOfAccount B ON A.AccountCode = B.AccountCode WHERE DocNumber IS NULL" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.JournalVoucher+JournalEntry">
            <SelectParameters>
                <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:SqlDataSource ID="AccountCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AccountCode,Description from Accounting.ChartOfAccount where Isnull(AllowJV,0)=1 and isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SubsiCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select A.AccountCode,B.SubsiCode,B.Description from Accounting.ChartOfAccount A inner join Accounting.GLSubsiCode B on A.AccountCode = B.AccountCode WHERE ISNULL(B.IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="ProfitCenterCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProfitCenterCode, Description FROM Accounting.ProfitCenter where ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="CostCenterCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT CostCenterCode, Description FROM Accounting.CostCenter where ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="BizPartnerCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="BizAccount" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select BusinessAccountCode,BusinessAccountName from Masterfile.BizAccount  where ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="Currency" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select Currency,CurrencyName from masterfile.Currency where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="ItemCategory" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ItemCategoryCode,Description from Masterfile.ItemCategory where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="JVTemplate" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DocNumber,DocDate, TotalDebit, TotalCredit,Description from Accounting.JVTemplate where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsJVTDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select A.DocNumber, A.LineNumber, A.AccountCode, C.Description, A.SubsiCode, A. ProfitCenterCode, A. CostCenterCode, A.BizPartnerCode, A.Debit, A. Credit,A.Field1,A.Field2,A.Field3,A.Field4,A.Field5,A.Field6,A.Field7,A.Field8,A.Field9 from Accounting.JVTemplateDetail A inner join Accounting.JVTemplate B on A.DocNumber = B.DocNumber inner join Accounting.ChartOfAccount C on A.AccountCode = C.AccountCode" OnInit="Connection_Init"></asp:SqlDataSource>

    </form>

    <!--#endregion-->
</body>
</html>
