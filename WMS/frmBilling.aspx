<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmBilling.aspx.cs" Inherits="GWL.frmBilling" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Billing</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 710px; /*Change this whenever needed*/
        }

        .Entry {
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
        }

        /*.dxeButtonEditSys input,
        .dxeTextBoxSys input{
            text-transform:uppercase;
        }*/

        .pnl-content {
            text-align: right;
        }
    </style>
    <!--#endregion-->

    <!--#region Region Javascript-->
    <script>
        var isValid = true;
        var counterror = 0;
        var dateerror = 0;

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
            var BizPartnerCode = aglBizPartnerCode.GetText();
            factbox.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
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
            gvJournal.SetWidth(width - 120);
        }

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            var btnmode = btn.GetText(); //gets text of button

            if (isValid && counterror < 1 && dateerror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
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
                dateerror = 0;
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

                if (s.cp_forceclose) {
                    alert(s.cp_message);
                    delete (s.cp_success);
                    delete (s.cp_message);
                    delete (s.cp_forceclose);
                    window.close();
                }
                else {
                    alert(s.cp_message);
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                    delete (s.cp_success);
                    delete (s.cp_message);
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
            if (s.cp_generated) {
                delete (s.cp_generated);
                autocalculate();
            }
            if (s.cp_noparameter) {
                alert(s.cp_noparametermsg);
                delete (s.cp_noparameter);
                delete (s.cp_noparametermsg);
            }
            if (s.cp_defaultServ) {
                aglStorageCode.SetText(aglServiceType.GetText());
                delete (s.cp_defaultServ);
            }
            if (s.cp_defaultBiz) {
                aglCustomerCode.SetText(aglBizPartnerCode.GetText());
                delete (s.cp_defaultServ);
            }
        }

        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;

        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            e.cancel = true;
        }

        function OnEndEditing(s, e) {
        }

        function autocalculate(s, e) {

            OnInitTrans();

            var totalamount = 0.00;
            var totalvat = 0.00;
            var totalgross = 0.00;

            var amount = 0.00;
            var vat = 0.00;
            var gross = 0.00;

            setTimeout(function () {

                var iGrid = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < iGrid.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(iGrid[i])) {

                        amount = gv1.batchEditApi.GetCellValue(iGrid[i], "Amount");
                        vat = gv1.batchEditApi.GetCellValue(iGrid[i], "Vat");
                        gross = gv1.batchEditApi.GetCellValue(iGrid[i], "GrossAmount");

                        totalamount += amount;
                        totalvat += vat;
                        totalgross += gross;

                    }
                    else {
                        var key = gv1.GetRowKey(iGrid[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) {
                            console.log("deleted row " + iGrid[i]);
                        }
                        else {
                            amount = gv1.batchEditApi.GetCellValue(iGrid[i], "Amount");
                            vat = gv1.batchEditApi.GetCellValue(iGrid[i], "Vat");
                            gross = gv1.batchEditApi.GetCellValue(iGrid[i], "GrossAmount");

                            totalamount += amount;
                            totalvat += vat;
                            totalgross += gross;
                        }
                    }
                }

                speTotalAmount.SetValue(totalamount.toFixed(2));
                speTotalVat.SetValue(totalvat.toFixed(2));
                speTotalGross.SetValue(totalgross.toFixed(2));

            }, 100);

            //console.log(gv1.GetVisibleRowsOnPage());
            //for (var i = 0; i < gv1.GetVisibleRowsOnPage() ; i++) {


            //    var amount = 0.00;
            //    var vat = 0.00;
            //    var gross = 0.00;
            //        amount = gv1.batchEditApi.GetCellValue(i, "Amount");
            //        vat = gv1.batchEditApi.GetCellValue(i, "Vat");
            //        gross = gv1.batchEditApi.GetCellValue(i, "GrossAmount");

            //        totalamount += amount;
            //        totalvat += vat;
            //        totalgross += gross;

            //        console.log(amount);
            //    }
            //    //txtTotalAmount.SetText(totalamount);
            //    //txtTotalVat.SetText(totalvat);

            //    speTotalAmount.SetValue(totalamount.toFixed(2));
            //    speTotalVat.SetValue(totalvat.toFixed(2));
            //    speTotalGross.SetValue(totalgross.toFixed(2));
        }

        function lookup(s, e) {
            if (isSetTextRequired) {//Sets the text during lookup for item code
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
            }
        }
        function OnCustomClick(s, e) {
            //if (e.buttonID == "Details") {
            //    var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
            //    var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
            //    var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
            //    var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
            //    factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
            //    + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode);
            //}
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

        function gridLookup_KeyPress(s, e) {
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == ASPxKey.Enter) {
                gv1.batchEditApi.EndEdit();
            }
        }

        function gridLookup_CloseUp(s, e) {
            gv1.batchEditApi.EndEdit();
        }

        function Grid_BatchEditRowValidating(s, e) {
            for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                var column = s.GetColumn(i);
                if (column != s.GetColumn(1) && column != s.GetColumn(2) && column != s.GetColumn(3) && column != s.GetColumn(1) && column != s.GetColumn(1) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
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

        function Generate(s, e) {
            cp.PerformCallback('Generate');
        }

        function CheckBizPartner(s, e) {

            var service = aglServiceType.GetText();

            if (service == "" || service == null) {
                aglBizPartnerCode.SetText("");
                alert('Select Service Type first!');
            }
            else {
                cp.PerformCallback('CallbackBizPartner=' + aglBizPartnerCode.GetText() + '|' + aglServiceType.GetText());
            }
        }

        function OnCompareDate(s, e) {

            var ddate = Date.parse(dtpDocDate.GetValue());
            var dOP = Date.parse(dtpOpenPeriod.GetValue());
            var msg = "";

            if (ddate < dOP) {
                msg = "Document date should not be lesser than Open Period!";
            }

            if (msg != "" || (s.GetText() == "" || e.value == "" || e.value == null)) {
                if (msg != "") {
                    alert(msg);
                    dtpDocDate.SetText("");
                }
                dateerror++;
                isValid = false;
            }
            else {
                isValid = true;
            }
        }

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
                    <dx:ASPxLabel runat="server" Text="Billing" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None"
            EnableViewState="False" HeaderText="BizPartner Info" Height="330px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="50"
            ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="900px" Height="1px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" Style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Proforma Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnInit="dtpDocDate_Init" Width="170px" OnLoad="Date_Load" ClientInstanceName="dtpDocDate">
                                                            <ClientSideEvents Validation="OnCompareDate" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Billing Type">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtBillingType" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Service Type">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="aglServiceType" runat="server" DataSourceID="sdsServiceType" OnLoad="LookupLoad"
                                                            KeyFieldName="ServiceType" TextFormatString="{0}" Width="170px" AutoGenerateColumns="false" ClientInstanceName="aglServiceType">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="ServiceType" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function (s, e) { cp.PerformCallback('CallbackServType'); }" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Warehouse Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="aglWarehouse" runat="server" DataSourceID="sdsWarehouse" OnLoad="LookupLoad"
                                                            Width="170px" KeyFieldName="WarehouseCode" TextFormatString="{0}" AutoGenerateColumns="false">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Business Partner Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="aglBizPartnerCode" runat="server" Width="170px" ClientInstanceName="aglBizPartnerCode"
                                                            DataSourceID="sdsBizPartner" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}" AutoGenerateColumns="false">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="true" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="true" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="BusinessAccountCode" ReadOnly="true" VisibleIndex="2">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="BizAccountName" ReadOnly="true" VisibleIndex="3">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Address" ReadOnly="true" VisibleIndex="4">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="ContactPerson" ReadOnly="true" VisibleIndex="5">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="CheckBizPartner" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Profit Center Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="aglProfitCenter" runat="server" DataSourceID="sdsProfitCenter" OnLoad="LookupLoad"
                                                            KeyFieldName="ProfitCenterCode" TextFormatString="{0}" Width="170px" AutoGenerateColumns="false">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
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
                                            <dx:LayoutItem Caption="Date From">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDateFrom" runat="server" OnInit="dtpDateFrom_Init" Width="170px" OnLoad="dtpDateFrom_Load" ReadOnly="True">
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
                                            <dx:LayoutItem Caption="Invoice Number Storage">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtBillingStatement" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Date To">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDateTo" runat="server" OnInit="dtpDateTo_Init" Width="170px" OnLoad="Date_Load">
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
                                            <dx:LayoutItem Caption="Invoice Number Handling">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtBillingStatementHandling" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Contract Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtContract" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Beginning Inventory">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speBegInv" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            ClientInstanceName="speBegInv" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speTotalAmount" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            ClientInstanceName="speTotalAmount" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ClientEnabled="false">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="BRemarks" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total VAT">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speTotalVat" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            ClientInstanceName="speTotalVat" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ClientEnabled="false">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="" Name="Genereatebtn">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxButton ID="Generatebtn" runat="server" AutoPostBack="False" Text="Generate" Theme="MetropolisBlue" Width="170px" OnLoad="Generatebtn_Load">
                                                            <ClientSideEvents Click="Generate" />
                                                        </dx:ASPxButton>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Customer Code" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="aglCustomerCode" runat="server" Width="170px" ClientInstanceName="aglCustomerCode"
                                                            DataSourceID="sdsCustomer" KeyFieldName="Customer" OnLoad="LookupLoad" TextFormatString="{0}" AutoGenerateColumns="false" OnInit="Customer_Init" SelectionMode="Multiple">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0"
                                                                    Width="30px" SelectAllCheckboxMode="AllPages">
                                                                </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Customer" ReadOnly="true" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="true" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Address" ReadOnly="true" VisibleIndex="2">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="ContactPerson" ReadOnly="true" VisibleIndex="3">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:EmptyLayoutItem></dx:EmptyLayoutItem>
                                            <dx:LayoutItem Caption="Total Amount Due">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speTotalGross" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            ClientInstanceName="speTotalGross" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ClientEnabled="false">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Storage Code" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="aglStorageCode" runat="server" Width="170px" ClientInstanceName="aglStorageCode"
                                                            DataSourceID="sdsStorage" KeyFieldName="StorageCode" OnLoad="LookupLoad" TextFormatString="{0}" AutoGenerateColumns="false" OnInit="Storage_Init" SelectionMode="Multiple">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0"
                                                                    Width="30px" SelectAllCheckboxMode="AllPages">
                                                                </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn FieldName="StorageCode" ReadOnly="true" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="StorageDesc" Caption="Description" ReadOnly="true" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Open Period" ShowCaption="False">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpOpenPeriod" runat="server" Width="170px" ClientInstanceName="dtpOpenPeriod" ClientVisible="False">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Billing Period Type" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtBillPeriod" runat="server" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Unit of Measure">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtUnit" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <%--<dx:LayoutItem Caption="Storage Rate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speStorageRate" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                            ClientInstanceName ="speStorageRate" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <%--<dx:LayoutItem Caption="Handling In Rate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speHandlingInRate" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                            ClientInstanceName ="speHandlingInRate" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <%--<dx:LayoutItem Caption="Handling Out Rate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speHandlingOutRate" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                            ClientInstanceName ="speHandlingOutRate" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <%--<dx:LayoutItem Caption="Minimum Handling In">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speMinHandlingIn" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                            ClientInstanceName ="speMinHandlingIn" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <%--<dx:LayoutItem Caption="Minimum Handling Out">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speMinHandlingOut" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                            ClientInstanceName ="speMinHandlingOut" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <%--<dx:LayoutItem Caption="Minimum Storage">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speMinStorage" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                            ClientInstanceName ="speMinStorage" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
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
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad">
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
                                    <dx:LayoutGroup Caption="Journal Entries">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
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
                            <dx:LayoutGroup Caption="Billing Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="784px"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;Date" OnCustomButtonInitialize="gv1_CustomButtonInitialize">
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager Mode="ShowAllRecords" />
                                                    <Settings ShowStatusBar="Hidden" HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300" />
                                                    <SettingsEditing Mode="Batch" />
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="False" ShowInCustomizationForm="True" ShowNewButtonInHeader="False" VisibleIndex="1" Width="60px" Visible="false">
                                                        </dx:GridViewCommandColumn>
                                                        <%--<dx:GridViewDataSpinEditColumn Caption="Line" FieldName="BillingLine" Name="BillingLine" ShowInCustomizationForm="True" VisibleIndex="1" Width="0" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="BillingLine" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"
                                                                DisplayFormatString="0" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>--%>
                                                        <%--<dx:GridViewDataDateColumn FieldName="Date" Name="Date" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="3" Width="80px" ReadOnly="True">
                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy">
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>--%>
                                                        <dx:GridViewDataDateColumn Caption="Date" FieldName="Date" Name="Date" ShowInCustomizationForm="True" VisibleIndex="3" Width="100px" ReadOnly="true" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible="false">
                                                                <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocIn" VisibleIndex="4" Width="270px" Name="DocIn" ReadOnly="True" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocOut" VisibleIndex="5" Width="270px" Name="DocOut" ReadOnly="True" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="QtyIn" FieldName="QtyIn" Name="QtyIn" ShowInCustomizationForm="True" VisibleIndex="6" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="QtyIn" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="QtyOut" FieldName="QtyOut" Name="QtyOut" ShowInCustomizationForm="True" VisibleIndex="7" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="QtyOut" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="HandlingQtyIn" FieldName="HandlingQtyIN" Name="CHandlingQtyIn" ShowInCustomizationForm="True" VisibleIndex="7" Width="100px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CHandlingQtyIn" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="HandlingQtyOut" FieldName="HandlingQtyOut" Name="CHandlingQtyOut" ShowInCustomizationForm="True" VisibleIndex="7" Width="100px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CHandlingQtyOut" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Ending Balance" FieldName="EndingBal" Name="EndingBal" ShowInCustomizationForm="True" VisibleIndex="8" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="EndingBal" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Chargeable End.Bal." FieldName="ChargeableEndBal" Name="ChargeableEndBal" ShowInCustomizationForm="True" VisibleIndex="9" Width="120px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="ChargeableEndBal" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Storage Charge" FieldName="StorageCharge" Name="StorageCharge" ShowInCustomizationForm="True" VisibleIndex="10" Width="100px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="StorageCharge" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Holding" FieldName="Holding" Name="Holding" ShowInCustomizationForm="True" VisibleIndex="11" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="Holding" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="HandlingIn" FieldName="HandlingIn" Name="HandlingIn" ShowInCustomizationForm="True" VisibleIndex="12" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="HandlingIn" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="HandlingOut" FieldName="HandlingOut" Name="HandlingOut" ShowInCustomizationForm="True" VisibleIndex="13" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="HandlingOut" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Amount" FieldName="Amount" Name="Amount" ShowInCustomizationForm="True" VisibleIndex="14" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="Amount" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="VAT" FieldName="Vat" Name="Vat" ShowInCustomizationForm="True" VisibleIndex="15" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="Vat" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Gross Amount" FieldName="GrossAmount" Name="GrossAmount" ShowInCustomizationForm="True" VisibleIndex="16" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="GrossAmount" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="CQtyIn" FieldName="CQtyIn" Name="CQtyIn" ShowInCustomizationForm="True" VisibleIndex="17" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CQtyIn" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="CQtyOut" FieldName="CQtyOut" Name="CQtyOut" ShowInCustomizationForm="True" VisibleIndex="18" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CQtyOut" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>

                                                        <dx:GridViewDataTextColumn FieldName="UOM" VisibleIndex="19" Width="80px" Name="UOM" ReadOnly="True" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BillingType" VisibleIndex="20" Width="100px" Name="BillingType" ReadOnly="True" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Storage Rate" FieldName="StorageRate" Name="StorageRate" ShowInCustomizationForm="True" VisibleIndex="21" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit ClientInstanceName="aStorageRate" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                                DisplayFormatString="{0:N4}" DecimalPlaces="4" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="HandlingIn Rate" FieldName="HandlingInRate" Name="HandlingInRate" ShowInCustomizationForm="True" VisibleIndex="22" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit ClientInstanceName="aHandlingInRate" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                                DisplayFormatString="{0:N4}" DecimalPlaces="4" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="HandlingOut Rate" FieldName="HandlingOutRate" Name="HandlingOutRate" ShowInCustomizationForm="True" VisibleIndex="23" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit ClientInstanceName="aHandlingOutRate" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                                DisplayFormatString="{0:N4}" DecimalPlaces="4" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Minimum Qty" FieldName="MinimumQty" Name="MinimumQty" ShowInCustomizationForm="True" VisibleIndex="24" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit ClientInstanceName="aMinimumQty" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" DecimalPlaces="2" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Min. HandlingIn" FieldName="MinHandlingIn" Name="MinHandlingIn" ShowInCustomizationForm="True" VisibleIndex="25" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="aMinHandlingIn" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Min. HandlingOut" FieldName="MinHandlingOut" Name="MinHandlingOut" ShowInCustomizationForm="True" VisibleIndex="26" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="aMinHandlingOut" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataDateColumn Caption="RR Date" FieldName="RRDate" Name="RRDate" ShowInCustomizationForm="True" VisibleIndex="27" Width="100px" ReadOnly="true" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible="false">
                                                                <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ProdNum" VisibleIndex="28" Width="100px" Name="ProdNum" ReadOnly="True" Caption="Prod. Number" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn Caption="ProdDate" FieldName="ProdDate" Name="ProdDate" ShowInCustomizationForm="True" VisibleIndex="29" Width="100px" ReadOnly="true" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible="false">
                                                                <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn Caption="Allocation Date" FieldName="AllocationDate" Name="AllocationDate" ShowInCustomizationForm="True" VisibleIndex="30" Width="100px" ReadOnly="true" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible="false">
                                                                <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="NoStorageCharge" Name="NoStorageCharge" Caption="No Storage Charge" ShowInCustomizationForm="True" VisibleIndex="31" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesCheckEdit AllowGrayed="false" ValueChecked="true" ValueUnchecked="false" ValueType="System.Boolean">
                                                                <ClientSideEvents CheckedChanged="function(s, e){ gv1.batchEditApi.EndEdit();}" />
                                                            </PropertiesCheckEdit>
                                                            <Settings AllowSort="False"></Settings>
                                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="NoHandlingCharge" Name="NoHandlingCharge" Caption="No Handling Charge" ShowInCustomizationForm="True" VisibleIndex="32" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesCheckEdit AllowGrayed="false" ValueChecked="true" ValueUnchecked="false" ValueType="System.Boolean">
                                                                <ClientSideEvents CheckedChanged="function(s, e){ gv1.batchEditApi.EndEdit();}" />
                                                            </PropertiesCheckEdit>
                                                            <Settings AllowSort="False"></Settings>
                                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Allocation Chargeable" FieldName="AllocChargeable" Name="AllocChargeable" ShowInCustomizationForm="True" VisibleIndex="33" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="aAllocChargeable" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"
                                                                DisplayFormatString="{0}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Staging Free of Charges" FieldName="Staging" Name="Staging" ShowInCustomizationForm="True" VisibleIndex="34" Width="80px" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="aStaging" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"
                                                                DisplayFormatString="{0}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="RefContract" VisibleIndex="35" Width="100px" Name="RefContract" Caption="Reference Contract" ReadOnly="True" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="ExcludeInBilling" Name="ExcludeInBilling" Caption="Excluded In Billing" ShowInCustomizationForm="True" VisibleIndex="36" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                            <PropertiesCheckEdit AllowGrayed="false" ValueChecked="true" ValueUnchecked="false" ValueType="System.Boolean">
                                                                <ClientSideEvents CheckedChanged="function(s, e){ gv1.batchEditApi.EndEdit();}" />
                                                            </PropertiesCheckEdit>
                                                            <Settings AllowSort="False"></Settings>
                                                            <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="True"></HeaderStyle>
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Remarks" VisibleIndex="37" Width="150px" Name="Remarks" ReadOnly="True" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="RefRecordID" VisibleIndex="38" Width="150px" Name="RefRecordID" ReadOnly="True" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Caption="Reference RecordID">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="MulStorageCode" VisibleIndex="39" Width="100px" Name="MulStorageCode" ReadOnly="True" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Caption="Storage Code">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="MulCustomerCode" VisibleIndex="40" Width="100px" Name="MulCustomerCode" ReadOnly="True" HeaderStyle-Wrap="True"
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Caption="Customer Code">
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                </dx:ASPxGridView>
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
                                                                        <dx:ASPxButton ID="Ok" runat="server" Text="Ok" AutoPostBack="False" UseSubmitBehavior="false">
                                                                            <ClientSideEvents Click="function (s, e){  cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                                                        </dx:ASPxButton>
                                                                    </td>
                                                                    <td>
                                                                        <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false">
                                                                            <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                                                        </dx:ASPxButton>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </dx:PopupControlContentControl>
                                                    </ContentCollection>
                                                </dx:ASPxPopupControl>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                        </Items>
                    </dx:ASPxFormLayout>
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
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>

    </form>

    <form id="form2" runat="server" visible="false">
        <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.Billing+BillingDetail" SelectMethod="getdetail" UpdateMethod="UpdateBillingDetail" TypeName="Entity.Billing+BillingDetail" DeleteMethod="DeleteBillingDetail" InsertMethod="AddBillingDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="DocNumber" QueryStringField="DocNumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.Billing+JournalEntry">
            <SelectParameters>
                <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <%--<asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM WMS.BillingDetail WHERE DocNumber IS NULL" OnInit = "Connection_Init" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsForQuery" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TOP 1 [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] WHERE 1 = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBizPartner" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.BizPartnerCode, A.Name, ISNULL(B.BusinessAccountCode,'') AS BusinessAccountCode, ISNULL(C.BizAccountName,'') AS BizAccountName, B.Address, B.ContactPerson FROM Masterfile.BPCustomerInfo A 
        INNER JOIN Masterfile.BizPartner B ON A.BizPartnerCode = B.BizPartnerCode LEFT JOIN Masterfile.BizAccount C ON B.BusinessAccountCode = C.BizAccountCode WHERE (ISNULL(A.IsInactive,0) = 0 AND ISNULL(B.IsInactive,0) = 0)" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.[Warehouse] WHERE ISNULL([IsInactive],0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsContract" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber FROM WMS.Contract WHERE ISNULL(SubmittedBy,'') != '' and Status != 'Closed'" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsServiceType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ServiceType, Description FROM Masterfile.WMSServiceType WHERE Type = 'STORAGE' AND ISNULL(IsInActive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsProfitCenter" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProfitCenterCode, Description FROM Accounting.ProfitCenter WHERE ISNULL(IsInActive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBillingPeriod" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BillingPeriodCode, Description FROM Masterfile.WMSBillingPeriod" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsUnitOfMeasure" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT UnitOfMeasure, Description FROM Masterfile.WMSUnitOfMeasure" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT A.DiffCustomerCode AS Customer, UPPER(B.Name) AS Name, C.Address, C.ContactPerson 
        FROM WMS.ContractDetail A INNER JOIN Masterfile.BPCustomerInfo B ON A.DiffCustomerCode = B.BizPartnerCode INNER JOIN Masterfile.BizPartner C ON B.BizPartnerCode = C.BizPartnerCode WHERE B.BizPartnerCode IS NULL" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsStorage" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT A.StorageCode AS StorageCode, UPPER(B.Description) AS StorageDesc FROM WMS.ContractDetail A INNER JOIN Masterfile.WMSServiceType B ON A.StorageCode = B.ServiceType WHERE B.ServiceType IS NULL" OnInit = "Connection_Init"></asp:SqlDataSource>
        --%>
        <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM WMS.BillingDetail WHERE DocNumber IS NULL"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsForQuery" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TOP 1 [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] WHERE 1 = 0"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsBizPartner" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.BizPartnerCode, A.Name, ISNULL(B.BusinessAccountCode,'') AS BusinessAccountCode, ISNULL(C.BizAccountName,'') AS BizAccountName, B.Address, B.ContactPerson FROM Masterfile.BPCustomerInfo A 
        INNER JOIN Masterfile.BizPartner B ON A.BizPartnerCode = B.BizPartnerCode LEFT JOIN Masterfile.BizAccount C ON B.BusinessAccountCode = C.BizAccountCode WHERE (ISNULL(A.IsInactive,0) = 0 AND ISNULL(B.IsInactive,0) = 0)"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.[Warehouse] WHERE ISNULL([IsInactive],0) = 0"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsContract" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber FROM WMS.Contract WHERE ISNULL(SubmittedBy,'') != '' and Status != 'Closed'"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsServiceType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ServiceType, Description FROM Masterfile.WMSServiceType WHERE Type = 'STORAGE' AND ISNULL(IsInActive,0) = 0"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsProfitCenter" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProfitCenterCode, Description FROM Accounting.ProfitCenter WHERE ISNULL(IsInActive,0)=0"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsBillingPeriod" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BillingPeriodCode, Description FROM Masterfile.WMSBillingPeriod"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsUnitOfMeasure" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT UnitOfMeasure, Description FROM Masterfile.WMSUnitOfMeasure"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsCustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT A.DiffCustomerCode AS Customer, UPPER(B.Name) AS Name, C.Address, C.ContactPerson 
        FROM WMS.ContractDetail A INNER JOIN Masterfile.BPCustomerInfo B ON A.DiffCustomerCode = B.BizPartnerCode INNER JOIN Masterfile.BizPartner C ON B.BizPartnerCode = C.BizPartnerCode WHERE B.BizPartnerCode IS NULL"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsStorage" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT A.StorageCode AS StorageCode, UPPER(B.Description) AS StorageDesc FROM WMS.ContractDetail A INNER JOIN Masterfile.WMSServiceType B ON A.StorageCode = B.ServiceType WHERE B.ServiceType IS NULL"></asp:SqlDataSource>

        <!--#endregion-->
    </form>
</body>
</html>


