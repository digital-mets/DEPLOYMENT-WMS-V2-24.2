<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmPalletMaster.aspx.cs" Inherits="GWL.frmPalletMaster" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title></title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 350px; /*Change this whenever needed*/
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
            if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
                //Sends request to server side
                if (btnmode.includes('Save') && getParameterByName('entry').toUpperCase() === 'N') {
                    cp.PerformCallback("Save");
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

        function generatePalletDetails(s, e) {
            cp.PerformCallback('GeneratePalletDetails');
            e.processOnServer = false;
        }

        function updateFields(s, e) {
            cp.PerformCallback('UpdateFields');
            e.processOnServer = false;
        }

        function onWarehouseChange(s, e) {
            const areaCode = glAreaCode.GetGridView();
            cp.PerformCallback('UpdateFields');
            areaCode.PerformCallback();
            e.processOnServer = false;
        }

        function gridView_EndCallback(s, e) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);
                delete (s.cp_message);

                window.open(`../WebReports/ReportViewer.aspx?val=~GEARS_Printout.P_PalletID&docnumber=${s.cp_docNumber}&start=${s.cp_seriesStart}&end=${s.cp_seriesEnd}`, '_blank');

                if (s.cp_forceclose) {
                    delete (s.cp_forceclose);
                    window.close();
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
                    delete (s.cp_close);
                    window.location.reload();
                }
                else {
                    delete (s.cp_close);
                    window.close();
                }
            }

            if (s.cp_delete) {
                delete (s.cp_delete);
                DeleteControl.Show();
            }

            if (s.cpGenerate) {
                delete (s.cpGenerate);
                if (s.cp_message != null) {
                    alert(s.cp_message);
                    delete (s.cp_message);
                }
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
            if (typeof gvPalletDetails === 'undefined') return;
            gvPalletDetails.SetHeight(height - 120);
            gvPalletDetails.SetWidth(width - 120);
        }

        //jQuery(document).ready(function (event) {//ADDNEW
        //    var isExpired = false;
        //    setInterval(checkSession, 2000);

        //    function checkSession() {
        //        var xhr = $.ajax({
        //            type: "POST",
        //            url: "../checksession.aspx/check",
        //            contentType: "application/json; charset=utf-8",
        //            dataType: "json",
        //            success: function (result) {
        //                if (result.d && !isExpired) {
        //                    isExpired = true;
        //                    alert('User Session Expired. Please click Ok to close the window.');
        //                    window.close();
        //                }
        //            }
        //        });
        //    }
        //});

    </script>
</head>
<body style="height: 910px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Pallet" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>

        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="338px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="form1_layout" runat="server" Height="269px" Width="850px" Style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600"></SettingsAdaptivity>

                        <Items>

                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>

                                            <dx:LayoutItem Caption="Warehouse Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glWarehouseCode" runat="server" Width="170px" OnLoad="LookupLoad" ClientInstanceName="glWarehouseCode" DataSourceID="WarehouseData" KeyFieldName="WarehouseCode" TextFormatString="{0}">
                                                            <ClientSideEvents Validation="OnValidation"
                                                                ValueChanged="onWarehouseChange" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="WarehouseCode" Caption="Warehouse Code" ReadOnly="True" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Area Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glAreaCode" runat="server" Width="170px" OnLoad="LookupLoad" ClientInstanceName="glAreaCode" DataSourceID="AreaData" KeyFieldName="Area;WarehouseCode" TextFormatString="{0}" OnInit="GLAreaCode_Init" ClientSideEvents-EndCallback="">
                                                            <ClientSideEvents Validation="OnValidation"
                                                                ValueChanged="updateFields" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="Area" Caption="Area" ReadOnly="True" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="WarehouseCode" Caption="WarehouseCode" ReadOnly="True" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Storage Type">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ClientInstanceName="textStorageType" ID="textStorageType" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Prefix">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ClientInstanceName="textPrefix" ID="textPrefix" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Series Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ClientInstanceName="textSeriesNum" ID="textSeriesNum" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Name="Amount" Caption="Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="inputAmount" runat="server" Number="1" Increment="1" NumberType="Integer" Width="170px" MinValue="1" MaxValue="1000" OnLoad="SpinEdit_Load">
                                                            <SpinButtons ShowIncrementButtons="True" ShowLargeIncrementButtons="false" />
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="" Name="Spacer">
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="" Name="GenerateBtn">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxButton ID="btnGenerate" runat="server" Text="Generate" AutoPostBack="False" CssClass="btn" Width="170px" ClientInstanceName="btnGenerate"
                                                            UseSubmitBehavior="false" CausesValidation="true">
                                                            <ClientSideEvents Click="generatePalletDetails" />
                                                        </dx:ASPxButton>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>

                                </Items>
                            </dx:TabbedLayoutGroup>

                            <dx:LayoutGroup Name="GeneratedPallets" Caption="Generated Pallets">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gvPalletDetails" runat="server" AutoGenerateColumns="False" Width="747px"
                                                    ClientInstanceName="gvPalletDetails" DataSourceID="PalletData"
                                                    SettingsBehavior-AllowSort="false">
                                                    <SettingsPager Mode="ShowPager" />
                                                    <Settings VerticalScrollBarMode="Auto" ShowFooter="True" />
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="SeriesNumber" VisibleIndex="1" Width="170px" CellStyle-HorizontalAlign="Left" />
                                                        <dx:GridViewDataTextColumn FieldName="PalletID" VisibleIndex="2" Width="170px" />
                                                    </Columns>
                                                </dx:ASPxGridView>

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
                        <dx:ASPxButton ID="updateBtn" runat="server" Text="Save & Print" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
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
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" AutoPostBack="False" UseSubmitBehavior="false">
                                    <ClientSideEvents Click="function (s, e){  cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
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

    <asp:SqlDataSource ID="WarehouseData" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.[Warehouse] where isnull(IsInactive,'')=0" OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="StorageTypeData" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT StorageType, StorageDescription from Masterfile.StorageType WHERE ISNULL(DeactivatedDate, '') = ''"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="AreaData" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="PalletData" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select '' AS SeriesNumber, '' AS PalletID" OnInit="Connection_Init"></asp:SqlDataSource>
</body>
</html>
