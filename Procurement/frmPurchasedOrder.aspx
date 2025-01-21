<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmPurchasedOrder.aspx.cs" Inherits="GWL.frmPurchasedOrder" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <script src="../js/Procurement/PurchaseOrder.js" type="text/javascript"></script>
    <script src="../js/keyboardNavi.js" type="text/javascript"></script>
    <title>Purchase Order</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
        height: 1280px; /*Change this whenever needed*/
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

         .pnl-content
        {
            text-align: right;
        }

        .invalid{ border-left-color:deeppink;
                  border-right-color:deeppink;
                  border-bottom-color:deeppink;
                  border-top-color:deeppink;

                  border-width:medium;

        }

        .textContainer
        {
            height: 40px;
            overflow: hidden;
        }

    </style>
    <!--#endregion-->
    
    <!--#region Region Javascript-->
    
    <!--#endregion-->
</head>
<body style="height: 910px;" onload="onload()">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
<form id="form1" runat="server" class="Entry">
    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Purchase Order" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
     </dx:ASPxPanel>
    <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="50"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>


    <dx:ASPxPopupControl ID="popup2" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox2" CloseAction="None" 
        EnableViewState="False" HeaderText="BizPartner info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="260"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
     <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
            EnableViewState="False" HeaderText="Notes" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="450"
            ShowCloseButton="False" Collapsed="true" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents CloseUp="function (s, e) { window.location.reload(); }" />
    </dx:ASPxPopupControl>
    <dx:ASPxCallback ID="callbacker" runat="server" OnCallback="callbacker_Callback" ClientInstanceName="cbacker">
        <ClientSideEvents EndCallback="setCode"></ClientSideEvents>
    </dx:ASPxCallback>

    <dx:ASPxFormLayout ID="MainForm" runat="server" Height="400px" Width="1280px" style="margin-left: -3px">
        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
        <Items>
            <dx:LayoutItem ShowCaption="False">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer>
                        <%--<dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="200px" ClientInstanceName="cp" OnCallback="cp_Callback">--%>
                         <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="200px" ClientInstanceName="cp" OnCallback="cp_Callback" SettingsLoadingPanel-Enabled="true" SettingsLoadingPanel-Delay="3000" Images-LoadingPanel-Url="..\images\loadinggear.gif" Images-LoadingPanel-Height="30px" Styles-LoadingPanel-BackColor="Transparent" Styles-LoadingPanel-Border-BorderStyle="None" SettingsLoadingPanel-Text="" SettingsLoadingPanel-ShowImage="true" >
   
                         <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxFormLayout ID="HeaderForm" runat="server" Height="300px" Width="1280px" style="margin-left: -3px">
                                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                                        <Items>
                                            <dx:TabbedLayoutGroup>
                                                <Items>
                                                    <dx:LayoutGroup Caption="General">
                                                        <Items>
                                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                                <Items>
                                                                    <dx:LayoutItem Caption="Document Number">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxTextBox ID="txtDocNumber" ClientInstanceName="txtDocNumber" runat="server" Width="170px"  AutoCompleteType="Disabled" ClientEnabled="false">
                                                                                </dx:ASPxTextBox>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem  Caption="Document Date">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxDateEdit  ID="dtDocDate" ClientInstanceName="CINDocDate" runat="server" Width="170px" OnInit ="dtpDocDate_Init" >
                                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="SetDefaultTargetDate"/>
                                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                        <RequiredField IsRequired="True" />
                                                                                    </ValidationSettings>
                                                                                    <InvalidStyle BackColor="Pink">
                                                                                    </InvalidStyle>
                                                                                </dx:ASPxDateEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Supplier Code">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxGridLookup ID="glSupplierCode" runat="server" Width="170px" ClientInstanceName="clBizPartnerCode" DataSourceID="SupplierCodelookup" KeyFieldName="SupplierCode" 
                                                                                    GridViewProperties-SettingsLoadingPanel-Text="" GridViewImages-LoadingPanel-Url="..\images\loadinggear.gif"  GridViewImages-LoadingPanel-Height="30px" GridViewStyles-LoadingPanel-BackColor="Transparent" GridViewProperties-SettingsLoadingPanel-ShowImage="true" GridViewProperties-SettingsLoadingPanel-Delay="3000" GridViewStyles-LoadingPanel-Border-BorderColor="Transparent" 
                                                                                     TextFormatString="{0}"
                                                                                    >
                                                                                    <ClientSideEvents Validation="OnValidation" GotFocus="function(s,e){
                                                                                        console.log('D')
                                                                                        //s.SetText(s.GetInputElement().value);
                                                                                        s.GetGridView().Refresh();
                                                                                        }"
                                                                                    ValueChanged="function (s, e){ console.log('clickedsupplier');  var g = clBizPartnerCode.GetGridView(); 
                                                                                             cp.PerformCallback('SupplierCodeCase|'+g.GetRowKey(g.GetFocusedRowIndex())); e.processOnServer = false; SetDefaultCommitment();
                                                                                             glQuotationNumber.SetValue(null);}"/>
                                                                                    <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                                        <RequiredField IsRequired="True"/>
                                                                                    </ValidationSettings>
                                                                                    <InvalidStyle BackColor="Pink">
                                                                                    </InvalidStyle>
                                                                                    <GridViewProperties>
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                        <Settings ShowFilterRow="True" />
                                                                                    </GridViewProperties>
                                                                                        <Columns>
					                                                                        <dx:GridViewDataTextColumn Caption="Supplier Code" FieldName="SupplierCode" ShowInCustomizationForm="True" VisibleIndex="1">
					                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
					                                                                        <dx:GridViewDataTextColumn Caption="Name" FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="2">
					                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
				                                                                        </Columns>
                                                                                </dx:ASPxGridLookup>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Target Delivery Date">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxDateEdit ID="dtTargetDate" ClientInstanceName="CINTargetDeliveryDate" runat="server" Width="170px">
                                                                                    <ClientSideEvents Validation="OnValidation"  DateChanged="SetDefaultCommitment" ValueChanged="SetDefaultCommitment" />
                                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                        <RequiredField IsRequired="True" />
                                                                                    </ValidationSettings>
                                                                                      <InvalidStyle BackColor="Pink">
                                                                                    </InvalidStyle>
                                                                                </dx:ASPxDateEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Status">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxTextBox ID="txtStatus" runat="server" ReadOnly="true" Width="170px">
                                                                                </dx:ASPxTextBox>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Date Completed">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxDateEdit ID="dtDateCompleted" runat="server" Width="170px" ReadOnly="true" DropDownButton-Enabled="false">
                                                                                    <DropDownButton Enabled="False"></DropDownButton>
                                                                                </dx:ASPxDateEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Receiving Warehouse">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxGridLookup ID="glReceivingWarehouse" ClientInstanceName="CINReceivingWarehouse" runat="server" Width="170px" DataSourceID="ReceivingWarehouselookup" KeyFieldName="WarehouseCode" TextFormatString="{0}">
                                                                                    <GridViewProperties>
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                        <Settings ShowFilterRow="True" />
                                                                                    </GridViewProperties>
                                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="OnInitTrans"/>
                                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                        <RequiredField IsRequired="True" />
                                                                                    </ValidationSettings>
                                                                                    <InvalidStyle BackColor="Pink">
                                                                                    </InvalidStyle>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="WarehouseCode" ShowInCustomizationForm="True" VisibleIndex="1">
					                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
					                                                                        <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="2">
					                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridLookup>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                   <dx:LayoutItem Caption="Commitment Date">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxDateEdit ID="dtCommitmentDate" ClientInstanceName="CINCommitmentDate" runat="server" Width="170px">
                                                                                    <ClientSideEvents Validation="OnValidation" DateChanged="SetDefaultCancellation"/>
                                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                                        <RequiredField IsRequired="True" />
                                                                                    </ValidationSettings>
                                                                                   <%--   <InvalidStyle BackColor="Pink">
                                                                                    </InvalidStyle>--%>
                                                                                </dx:ASPxDateEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Contact Person">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxTextBox ID="txtContactPerson" ClientInstanceName="CINContactPerson" runat="server" Width="170px">
                                                                                        <ClientSideEvents Validation="OnValidation"/>
                                                                                        <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip" EnableCustomValidation="true">
                                                                                        <RequiredField IsRequired="True"/>
                                                                                        </ValidationSettings>
                                                                                        <InvalidStyle BackColor="Pink">
                                                                                    </InvalidStyle>
                                                                                </dx:ASPxTextBox>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                     <dx:LayoutItem Caption="Cancellation Date">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxDateEdit ID="dtCancellationDate" ClientInstanceName="CINCancellationDate" runat="server" Width="170px">
                                                                                </dx:ASPxDateEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Quotation Number">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxGridLookup ID="glQuotationNumber" runat="server" Width="170px"
                                                                                    ClientInstanceName="glQuotationNumber" DataSourceID="QuotationNumberlookup" KeyFieldName="DocNumber" TextFormatString="{0}">
                                                                                    <GridViewProperties>
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                        <Settings ShowFilterRow="True" />
                                                                                    </GridViewProperties>
                                                                                        <Columns>
                                                                                        <%--<dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="10px">
                                                                                        </dx:GridViewCommandColumn>--%>
                                                                                        <dx:GridViewDataTextColumn Caption="Quotation Number" FieldName="DocNumber" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                             <dx:GridViewDataTextColumn Caption="Supplier Code" FieldName="Supplier" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents GotFocus="function(s,e){
                                                                                                    //s.SetText(s.GetInputElement().value);
                                                                                                    s.GetGridView().Refresh();
                                                                                                  }" />
                                                                                </dx:ASPxGridLookup>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                             
                                                                     <%--<dx:LayoutItem Caption="Remarks">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxTextBox ID="txtRemarks" runat="server"  Width="170px">
                                                                                </dx:ASPxTextBox>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>--%>

                                                                    <dx:LayoutItem Caption="Broker">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxGridLookup ID="glBroker" runat="server" ClientInstanceName="CINBroker"  Width="170px" 
                                                                                    DataSourceID="SupplierCodelookup" KeyFieldName="SupplierCode" TextFormatString="{0}" OnInit="glBroker_Init">
                                                                                    <GridViewProperties>
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                        <Settings ShowFilterRow="True" />
                                                                                        <SettingsPager PageSize="5"></SettingsPager>
                                                                                    </GridViewProperties>
                                                                                     <ClientSideEvents GotFocus="function(s,e){
                                                                                        //s.SetText(s.GetInputElement().value);
                                                                                         s.GetGridView().Refresh();
                                                                                        }" />
                                                                                        <Columns>
					                                                                        <dx:GridViewDataTextColumn Caption="Broker" FieldName="SupplierCode" ShowInCustomizationForm="True" VisibleIndex="1">
					                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
					                                                                        <dx:GridViewDataTextColumn Caption="Name" FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="2">
					                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
				                                                                        </Columns>
                                                                                </dx:ASPxGridLookup>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="With PR">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxCheckBox ID="chkIsWithPR" runat="server" ClientInstanceName="cbiswithpr" CheckState="Unchecked">
                                                                                    <ClientSideEvents CheckedChanged="checkedchanged"/>
                                                                                </dx:ASPxCheckBox>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="PR Number:">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxGridLookup ID="glPRNumber" runat="server" Width="170px" DataSourceID="PRNumberlookup" AutoGenerateColumns="False" KeyFieldName="DocNumber" SelectionMode="Multiple" TextFormatString="{0}"
                                                                                     ClientInstanceName="prnum" OnInit="glPRNumber_Init">
                                                                                    <ClientSideEvents DropDown="function(){
                                                                                        prnum.GetGridView().PerformCallback();
                                                                                        }" />
                                                                                    <GridViewProperties>
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                        <Settings ShowFilterRow="True" />
                                                                                        <SettingsPager PageSize="5"></SettingsPager>
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="1">
                                                                                        </dx:GridViewCommandColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="PR Number" FieldName="DocNumber" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridLookup>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem> 

                                                                    

                                                                    <dx:LayoutItem Caption="With RefNumber">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxCheckBox ID="chkIsWithInvoice" runat="server" CheckState="Unchecked">
                                                                                </dx:ASPxCheckBox>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="" Name="Genereatebtn">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxButton ID="Generatebtn" ClientInstanceName="CINGenerate" runat="server" Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" onload="Generate_Btn" ClientVisible="true" Text="Generate" Theme="MetropolisBlue">
                                                                                    <ClientSideEvents Click="Generate" />
                                                                                </dx:ASPxButton>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                    

                                                                    <dx:LayoutItem Caption="Released">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxCheckBox ID="chkIsReleased" runat="server" CheckState="Unchecked" ReadOnly="true">
                                                                                </dx:ASPxCheckBox>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                    
                                                                    <dx:EmptyLayoutItem></dx:EmptyLayoutItem>

                                                                    <dx:LayoutItem Caption="Printed">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxCheckBox ID="chkIsPrinted" runat="server" CheckState="Unchecked" ReadOnly="true">
                                                                                </dx:ASPxCheckBox>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                    <dx:LayoutItem Caption="Remarks">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer>
                                                                                <dx:ASPxMemo ID="memoremarks" runat="server" Width="170px" Height="50">
                                                                                </dx:ASPxMemo>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                    
                                                                </Items>
                                                            </dx:LayoutGroup>   <%--END OF Information LayoutGroup--%>

                                                            <dx:LayoutGroup Caption="Amount" ColCount="2">
                                                                <Items>
                                                                    <dx:LayoutItem Caption="Currency">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxGridLookup ID="txtCurrency" runat="server" Width="170px" DataSourceID="Currencylookup" KeyFieldName="Currency"
                                                                                    AutoGenerateColumns="true" TextFormatString="{0}">
                                                                                    <GridViewProperties>                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="Currency" ShowInCustomizationForm="True" VisibleIndex="1">
					                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
					                                                                        <dx:GridViewDataTextColumn FieldName="CurrencyName" ShowInCustomizationForm="True" VisibleIndex="2">
					                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridLookup>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Terms">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxSpinEdit ID="spinTerms" ClientInstanceName="CINTerms" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" 
                                                                                    NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" MinValue="0">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                </dx:ASPxSpinEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Exchange Rate">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxSpinEdit ID="spinExchangeRate" ClientInstanceName="CINExchangeRate" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False"
                                                                                     NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" MinValue="0">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                                                </dx:ASPxSpinEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Total Freight">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxSpinEdit ID="spinTotalFreight" ClientInstanceName="CINTotalFreight" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    <ClientSideEvents ValueChanged="detailautocalculate" />
                                                                                </dx:ASPxSpinEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Withholding Tax">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxSpinEdit ID="spinWithholdingTax" ClientInstanceName="CINWithholdingTax" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                </dx:ASPxSpinEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Total Quantity">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxSpinEdit ID="spinTotalQty" ClientInstanceName="CINTotalQty" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    
                                                                                </dx:ASPxSpinEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="VAT Amount">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxSpinEdit ID="spinVATAmount" ClientInstanceName="CINVATAmount" runat="server" ClientEnabled="false" Width="170px" SpinButtons-ShowIncrementButtons="False" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    <ClientSideEvents ValueChanged="autocalculate" /> 
                                                                                </dx:ASPxSpinEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="Peso Amount">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxSpinEdit ID="spinPesoAmount" ClientInstanceName="CINPesoAmount" runat="server" ClientEnabled="false" Width="170px" SpinButtons-ShowIncrementButtons="False" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                </dx:ASPxSpinEdit> 
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>



                                                                     <dx:LayoutItem Caption="Gross VATable Amount">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxSpinEdit ID="spinGrossVATableAmount" ClientInstanceName="CINGrossVATableAmount" ClientEnabled="false" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    <ClientSideEvents NumberChanged="autocalculate" />
                                                                                </dx:ASPxSpinEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                     <dx:LayoutItem Caption="Foreign Amount">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxSpinEdit ID="spinForeignAmount" ClientInstanceName="CINForeignAmount" ClientEnabled="false" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                </dx:ASPxSpinEdit> 
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                    <dx:LayoutItem Caption="NonVATable Amount">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxSpinEdit ID="spinNonVATableAmount" ClientInstanceName="CINNonVATableAmount" ClientEnabled="false" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    <ClientSideEvents NumberChanged="autocalculate" />
                                                                                </dx:ASPxSpinEdit>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>

                                                                </Items>
                                                            </dx:LayoutGroup>   <%--END OF Amount LayoutGroup--%>
                                                        </Items>
                                                    </dx:LayoutGroup>   <%--END OF General LayoutGroup--%>
                                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                                        <Items>
                                                            <dx:LayoutItem Caption="Field1">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtHField1" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Field2">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtHField2" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Field3">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtHField3" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Field4">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtHField4" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Field5">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtHField5" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Field6">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtHField6" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Field7">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtHField7" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Field8">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtHField8" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Field9">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtHField9" runat="server">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>   <%--END OF User Defined LayoutGroup--%>
                                                    <dx:LayoutGroup Caption="Audit Trail" ColSpan="2" ColCount="2">
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
                                                             <dx:LayoutItem Caption="Cancelled By">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtCancelledBy" runat="server" Width="170px" ReadOnly="True">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Cancelled Date">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtCancelledDate" runat="server" Width="170px" ReadOnly="True">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Force Closed By">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtForceClosedBy" runat="server" Width="170px" ReadOnly="True">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Force Closed Date">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtForceClosedDate" runat="server" Width="170px" ReadOnly="True">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Released By">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtReleasedBy" runat="server" Width="170px" ReadOnly="True">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Released Date">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtReleasedDate" runat="server" Width="170px" ReadOnly="True">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>   <%--END OF Audit Trail LayoutGroup--%>

                                                    <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction">
                                                        <Items>
                                                            <dx:LayoutGroup Caption="Reference Detail">
                                                                <Items>
                                                                    <dx:LayoutItem Caption="">
                                                                        <LayoutItemNestedControlCollection>
                                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                                <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Width="860px" ClientInstanceName="gvRef" SettingsBehavior-AllowSort="False">
                                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  Init="OnInitTrans" />
                                                                                    <Settings ShowStatusBar="Hidden"/>
                                                                                    <SettingsPager PageSize="5">
                                                                                    </SettingsPager>
                                                                                    <SettingsEditing Mode="Batch">
                                                                                    </SettingsEditing>
                                                                                    <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" ReadOnly="True">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="Reference TransType" FieldName="RTransType" Name="RTransType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="90px" ShowUpdateButton="True" ShowCancelButton="False">
                                                                                            <CustomButtons>
                                                                                                <dx:GridViewCommandColumnCustomButton ID="ViewReferenceTransaction">
                                                                                                    <Image IconID="functionlibrary_lookupreference_16x16">
                                                                                                    </Image>
                                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                                <dx:GridViewCommandColumnCustomButton ID="ViewTransaction">
                                                                                                    <Image IconID="find_find_16x16">
                                                                                                    </Image>
                                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                            </CustomButtons>
                                                                                        </dx:GridViewCommandColumn>
                                                                                        <dx:GridViewDataTextColumn Caption="Reference DocNumber" FieldName="REFDocNumber" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4" ReadOnly="True">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                </dx:ASPxGridView>
                                                                            </dx:LayoutItemNestedControlContainer>
                                                                        </LayoutItemNestedControlCollection>
                                                                    </dx:LayoutItem>
                                                                </Items>
                                                            </dx:LayoutGroup>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                </Items>
                                            </dx:TabbedLayoutGroup>
                                        </Items>
                                    </dx:ASPxFormLayout>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxCallbackPanel>
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>    <%--END OF HEADER LAYOUTITEM--%>


            <dx:LayoutItem ShowCaption="False">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer>
                        <dx:ASPxFormLayout ID="GridForm" runat="server" Height="600px" Width="1280px" style="margin-left: -3px">
                            <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                            <Items>
                                <dx:LayoutGroup Caption="Purchase Order Detail">
                                    <Items>
                                        <dx:LayoutItem ShowCaption="False">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False"  Width="770px"
                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gv1" SettingsBehavior-AllowDragDrop="false"
                                                        OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate"  OnCustomButtonInitialize="gv1_CustomButtonInitialize" 
                                                        OnInit="gv1_Init" SettingsBehavior-AllowSort="False" OnCustomCallback="gv1_CustomCallback"
                                                        Settings-ShowStatusBar="Hidden">
                                                        <ClientSideEvents CustomButtonClick="OnCustomClick" Init="OnInitTrans" EndCallBack="gridView_EndCallback" />
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" 
                                                            BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" />
                                                        <SettingsPager Mode="ShowAllRecords" /> 
                                                         <SettingsEditing Mode="Batch"/>
                                                        <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="200"  /> 
                                                        <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                        <SettingsCommandButton>
                                                                        <NewButton>
                                                                        <Image IconID="actions_addfile_16x16"></Image>
                                                                        </NewButton>
                                                                        <EditButton>
                                                                        <Image IconID="actions_addfile_16x16"></Image>
                                                                        </EditButton>
                                                                        <DeleteButton>
                                                                        <Image IconID="actions_cancel_16x16"></Image>
                                                                        </DeleteButton>
                                                                    </SettingsCommandButton>
                                                        <Columns>
                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" Width="0px" VisibleIndex="1">
                                                            </dx:GridViewDataTextColumn>
                                                        
                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Width="100px" Name="LineNumber" ReadOnly="True">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxTextBox ID="glpLineNumber" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                        KeyFieldName="LineNumber" ClientInstanceName="gl7" TextFormatString="{0}" Width="100px" ReadOnly="true">
                                                                    </dx:ASPxTextBox>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>

                                                             <dx:GridViewDataTextColumn FieldName="PRNumber" Name="PRNumber" ShowInCustomizationForm="True" Visible="true" VisibleIndex="3" Width="0px" ReadOnly="True" Caption="PRNumber">
                                                             </dx:GridViewDataTextColumn>

                                                            <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="4" Width="150px" Name="glpItemCode" ReadOnly="True">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                        DataSourceID="sdsItem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="150px" 
                                                                        GridViewProperties-SettingsLoadingPanel-Text="" GridViewImages-LoadingPanel-Url="..\images\loadinggear.gif"  GridViewImages-LoadingPanel-Height="30px" GridViewStyles-LoadingPanel-BackColor="Transparent" GridViewProperties-SettingsLoadingPanel-ShowImage="true" GridViewProperties-SettingsLoadingPanel-Delay="3000" GridViewStyles-LoadingPanel-Border-BorderColor="Transparent" 
                                                                         OnInit="glItemCode_Init">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                            <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                        </Columns>
                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" BeginCallback="function(){loader.Show();}"
                                                                         EndCallback="GridEndChoice" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="FullDesc" VisibleIndex="5" Width="300px" Caption="Item Description" PropertiesTextEdit-EncodeHtml="false">   
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="5" Width="100px" Name="ColorCode" ReadOnly="True">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                        KeyFieldName="ColorCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="100px" OnInit="lookup_Init">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0"  Settings-AutoFilterCondition="Contains">
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                            DropDown="function dropdown(s, e){
                                                                            gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                            //e.processOnServer = false;
                                                                            }" ValueChanged="function(s,e){
                                                                            gv1.batchEditApi.EndEdit();
                                                                            cbacker.PerformCallback(gv1.batchEditApi.GetCellValue(index, 'ItemCode') + '|' +gv1.batchEditApi.GetCellValue(index, 'ColorCode') +
                                                                            '|' + gv1.batchEditApi.GetCellValue(index, 'ClassCode') + '|' + gv1.batchEditApi.GetCellValue(index, 'SizeCode'));
                                                                            }"/>
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="6" Width="100px" Name="ClassCode" ReadOnly="True">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    KeyFieldName="ClassCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="100px">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        </Columns>
                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                            DropDown="function dropdown(s, e){
                                                                            gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                            }" ValueChanged="function(s,e){
                                                                            gv1.batchEditApi.EndEdit();
                                                                            cbacker.PerformCallback(gv1.batchEditApi.GetCellValue(index, 'ItemCode') + '|' +gv1.batchEditApi.GetCellValue(index, 'ColorCode') +
                                                                            '|' + gv1.batchEditApi.GetCellValue(index, 'ClassCode') + '|' + gv1.batchEditApi.GetCellValue(index, 'SizeCode'));
                                                                            }"/>
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                        
                                                            <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="7" Width="100px" Name="SizeCode" ReadOnly="True">
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    KeyFieldName="SizeCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="100px">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        </Columns>
                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                            DropDown="function dropdown(s, e){
                                                                            gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                            }" ValueChanged="function(s,e){
                                                                            gv1.batchEditApi.EndEdit();
                                                                            cbacker.PerformCallback(gv1.batchEditApi.GetCellValue(index, 'ItemCode') + '|' +gv1.batchEditApi.GetCellValue(index, 'ColorCode') +
                                                                            '|' + gv1.batchEditApi.GetCellValue(index, 'ClassCode') + '|' + gv1.batchEditApi.GetCellValue(index, 'SizeCode'));
                                                                            }"/>
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                       
                                                          

                                                            <dx:GridViewDataSpinEditColumn FieldName="OrderQty" Name="OrderQty"  ShowInCustomizationForm="True" VisibleIndex="9" Width="80px" UnboundType="Bound">
                                                                <PropertiesSpinEdit NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" DecimalPlaces="4"
                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0.99999" MaxValue ="9999999999" ClientInstanceName="CINOrderQtyDetail">

                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="autocalculate" NumberChanged="orderqtynegativecheck" />
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>


                                                            <dx:GridViewDataTextColumn FieldName="Unit" VisibleIndex="10" Width="80px" Caption="Unit">   
                                                                  <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                        KeyFieldName="Unit" DataSourceID="Unitlookup" ClientInstanceName="gl5" TextFormatString="{0}" Width="80px">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="Unit" ReadOnly="True" VisibleIndex="0">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>

                                                            <dx:GridViewDataSpinEditColumn FieldName="UnitCost" Name="UnitCost" ShowInCustomizationForm="True" VisibleIndex="11" Width="80px">
                                                              <PropertiesSpinEdit NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"  DisplayFormatString="{0:N4}" DecimalPlaces="4"
                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999" ClientInstanceName="CINUnitCostDetail">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                  <ClientSideEvents ValueChanged="autocalculate" NumberChanged="unitcostnegativecheck" />
                                                            </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                            <dx:GridViewDataSpinEditColumn FieldName="ReceivedQty" Name="ReceivedQty" ShowInCustomizationForm="True" VisibleIndex="12" Width="80px" ReadOnly="true">
                                                                <PropertiesSpinEdit ClientInstanceName="txtReceivedQty" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" Increment="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>

                                                            <dx:GridViewDataSpinEditColumn FieldName="UnitFreight" Name="glpUnitFreight" ShowInCustomizationForm="True" VisibleIndex="13" Width="80px">
                                                                <PropertiesSpinEdit NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"  DisplayFormatString="{0:N4}" DecimalPlaces="4"
                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999" ClientInstanceName="CINUnitFreightDetail">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="autocalculate" NumberChanged="negativecheck" />
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>

                                                            <dx:GridViewDataCheckColumn Caption="Vatable" FieldName="IsVat" Name="glpIsVat" ShowInCustomizationForm="True" VisibleIndex="14">
                                                                <PropertiesCheckEdit ClientInstanceName="glIsVat" >
                                                                    <ClientSideEvents CheckedChanged="function(s,e){ 
                                                                        gv1.batchEditApi.EndEdit(); 
                                                                        if (s.GetChecked() == false) 
                                                                        {
                                                                            gv1.batchEditApi.SetCellValue(index, 'VATCode', 'NONV');
                                                                            gv1.batchEditApi.SetCellValue(index, 'Rate', '0');
                                                                        }
                                                                        else{
                                                                            gv1.batchEditApi.SetCellValue(index, 'VATCode', null);
                                                                            gv1.batchEditApi.SetCellValue(index, 'Rate', '0');
                                                                        }
                                                                        autocalculate();
                                                                        }" />
                                                                </PropertiesCheckEdit>
              
                                                            </dx:GridViewDataCheckColumn>
                                                            <dx:GridViewDataTextColumn FieldName="VATCode" VisibleIndex="15" Width="80px" Caption="VATCode">   
                                                                  <EditItemTemplate>
                                                                      <dx:ASPxGridLookup ID="glVATCode" runat="server" DataSourceID="VatCodeLookup"  AutoGenerateColumns="False" AutoPostBack="false" 
                                                                        KeyFieldName="TCode" ClientInstanceName="glVATCode" TextFormatString="{0}" Width="80px">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                        </GridViewProperties>
                                                                       <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="TCode" ReadOnly="True" VisibleIndex="0" >
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                             </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                             </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Rate" ReadOnly="True" VisibleIndex="2" >
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                             </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents DropDown="lookup" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" ValueChanged="function(s,e){
                                                                                closing = true;
                                                                                var grid = glVATCode.GetGridView();
                                                                                grid.GetRowValues(grid.GetFocusedRowIndex(), 'Rate', PutRate);    
                                                                                valchange_VAT = true;
                                                                                
                                                                              }" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>

                                                            <dx:GridViewDataCheckColumn Caption="Partial Delivery" FieldName="IsAllowPartial" Name="glpIsAllowPartial" ShowInCustomizationForm="True" VisibleIndex="16">
                                                            </dx:GridViewDataCheckColumn>

                                                            <%--<dx:GridViewDataTextColumn FieldName="Rate" VisibleIndex="17" Width="100px">
                                                                <PropertiesTextEdit ClientInstanceName="txtRate"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>--%>

                                                            <dx:GridViewDataSpinEditColumn FieldName="Rate" Name="Rate" ShowInCustomizationForm="True" VisibleIndex="17" Width="0px">
                                                                <PropertiesSpinEdit ClientInstanceName="txtRate" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" Width="0px" Increment="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>

                                                            <%--<dx:GridViewDataTextColumn FieldName="ATCRate" VisibleIndex="18" Width="100px">
                                                                <PropertiesTextEdit ClientInstanceName="txtATCRate"></PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>--%>

                                                            <dx:GridViewDataSpinEditColumn FieldName="ATCRate" Name="ATCRate" ShowInCustomizationForm="True" VisibleIndex="18" Width="0px">
                                                                <PropertiesSpinEdit ClientInstanceName="txtATCRate" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" Width="0px" Increment="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>

                                                            <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" VisibleIndex="19" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" VisibleIndex="20" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" VisibleIndex="21" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" VisibleIndex="22" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" VisibleIndex="23" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" VisibleIndex="24" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" VisibleIndex="25" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="26" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="27" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True"  ShowNewButtonInHeader="True" VisibleIndex="0" Width="60px">
                                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                                                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Top" Paddings-PaddingTop="0" />
                                                                <HeaderTemplate>
                                                                        <dx:ASPxButton runat="server" ID="Newbtn" Image-IconID="actions_addfile_16x16" RenderMode="Link" AutoPostBack="false"
                                                                            OnInit="Newbtn_Init">
                                                                            <ClientSideEvents Click="function(s,e){ gv1.AddNewRow();
                                                                                gv1.batchEditApi.SetCellValue(index, 'VATCode', VATCode);
                                                                                gv1.batchEditApi.SetCellValue(index, 'Rate', VATRate);
                                                                                gv1.batchEditApi.SetCellValue(index, 'ATCRate', ATCRate);
                                                                                if (VATCode != 'NONV') {
                                                                                    gv1.batchEditApi.SetCellValue(index, 'IsVat', true);
                                                                                  }
                                                                                }" />
                                                                        </dx:ASPxButton>
                                                                </HeaderTemplate>    
                                                                <CustomButtons>
                                                                    <dx:GridViewCommandColumnCustomButton ID="Details" >
                                                                       <Image IconID="support_info_16x16" ToolTip="Countsheet"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                   <%-- <dx:GridViewCommandColumnCustomButton ID="CountSheet">
                                                                       <Image IconID="arrange_withtextwrapping_topleft_16x16" ToolTip="Countsheet"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton> --%>
                                                                     <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                    </CustomButtons>
                                                                </dx:GridViewCommandColumn>
                                                        </Columns>
                                                    </dx:ASPxGridView>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:LayoutGroup>
                                <dx:LayoutGroup Caption="Purchase Order Service Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gvService" runat="server" AutoGenerateColumns="False" Width="770px"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gvService" SettingsBehavior-AllowDragDrop="false"
                                                    OnCustomButtonInitialize="gv1_CustomButtonInitialize" OnCustomCallback="gvService_CustomCallback"
                                                    OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber" SettingsBehavior-AllowSort="False"
                                                    Settings-ShowStatusBar="Hidden">
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                        BatchEditStartEditing="OnStartEditing2" BatchEditEndEditing="OnEndEditing2"/>
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager Mode="ShowAllRecords"/> 
                                                    <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="200" ShowFooter="True"  /> 
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <SettingsCommandButton>
                                                                        <NewButton>
                                                                        <Image IconID="actions_addfile_16x16"></Image>
                                                                        </NewButton>
                                                                        <EditButton>
                                                                        <Image IconID="actions_addfile_16x16"></Image>
                                                                        </EditButton>
                                                                        <DeleteButton>
                                                                        <Image IconID="actions_cancel_16x16"></Image>
                                                                        </DeleteButton>
                                                                    </SettingsCommandButton>
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="60px">
                                                        <CustomButtons>
                                                                     <dx:GridViewCommandColumnCustomButton ID="Delete2">
                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                    </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="true" Width="100px" VisibleIndex="1">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="PRNumber" Visible="true" Width="0px" VisibleIndex="1">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Service" FieldName="ServiceType" VisibleIndex="2" Width="140px" Name="glItemCode">
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glService" runat="server" AutoGenerateColumns="False" AutoPostBack="false" GridViewProperties-EnableCallbackCompression="true"
                                                                    DataSourceID="ServiceLookup" KeyFieldName="ServiceCode" ClientInstanceName="glService" TextFormatString="{0}" Width="140px"
                                                                    OnInit="glService_Init" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ServiceCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="IsAllowBilling" ReadOnly="True" VisibleIndex="2" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" 
                                                                                 EndCallback="function(s,e){
                                                                                    if(s.GetGridView().cp_serv){
                                                                                        delete(s.GetGridView().cp_serv);
                                                                                        var grid = glService.GetGridView();
                                                                                grid.GetRowValues(grid.GetFocusedRowIndex(), 'ServiceCode;Description;IsAllowBilling', PutDesc);
                                                                                    }
                                                                                }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Description" Width="180px" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="true" PropertiesTextEdit-Height="50px">
                                                            
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="ServiceQty" VisibleIndex="4" Width="100px" Caption="ServiceQty" PropertiesSpinEdit-LargeIncrement="0"  >
                                                        <PropertiesSpinEdit Increment="0" ClientInstanceName="Qty" MinValue="0.99999" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents LostFocus="calccost" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Unit" VisibleIndex="5" Width="100px" Caption="Unit">   
                                                              <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    KeyFieldName="Unit"  DataSourceID="UnitLookup" ClientInstanceName="glUnit" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"  />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Unit" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains"  >
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitCost" ShowInCustomizationForm="True" VisibleIndex="6" PropertiesSpinEdit-LargeIncrement="0" Width="80px">
                                                            <PropertiesSpinEdit NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"  DisplayFormatString="{0:N4}" DecimalPlaces="4"
                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" ClientInstanceName="UnitCost2" MinValue ="0" MaxValue ="9999999999">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents LostFocus="calccost" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="TotalCost" ShowInCustomizationForm="True" VisibleIndex="7" Width="80px" ReadOnly="true">
                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" Increment="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="autocalculate" NumberChanged="unitcostnegativecheck" />
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsAllowProgressBilling" Caption="Progress Billing"  ShowInCustomizationForm="True" VisibleIndex="8">
                                                            <PropertiesCheckEdit ClientInstanceName="chkIsAllowProgress">
                                                                <ClientSideEvents CheckedChanged="function(){gvService.batchEditApi.EndEdit()}" />
                                                            </PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataCheckColumn Caption="Vatable" FieldName="IsVat" Name="glpIsVat" ShowInCustomizationForm="True" VisibleIndex="9">
                                                                <PropertiesCheckEdit ClientInstanceName="glIsVat" >
                                                                    <ClientSideEvents CheckedChanged="function(s,e){ 
                                                                        gvService.batchEditApi.EndEdit(); 
                                                                        if (s.GetChecked() == false) 
                                                                        {
                                                                            gvService.batchEditApi.SetCellValue(index, 'VATCode', 'NONV');
                                                                            gvService.batchEditApi.SetCellValue(index, 'VATRate', '0');
                                                                        }
                                                                        else{
                                                                            gvService.batchEditApi.SetCellValue(index, 'VATCode', null);
                                                                            gvService.batchEditApi.SetCellValue(index, 'VATRate', '0');
                                                                        }
                                                                        autocalculate();
                                                                        }" />
                                                                </PropertiesCheckEdit>
                                                            </dx:GridViewDataCheckColumn>
                                                            <dx:GridViewDataTextColumn FieldName="VATCode" VisibleIndex="10" Width="80px" Caption="VATCode">   
                                                                  <EditItemTemplate>
                                                                      <dx:ASPxGridLookup ID="glVATCode" runat="server" DataSourceID="VatCodeLookup"  AutoGenerateColumns="False" AutoPostBack="false" 
                                                                        KeyFieldName="TCode" ClientInstanceName="glVATCode2" TextFormatString="{0}" Width="80px">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                        </GridViewProperties>
                                                                       <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="TCode" ReadOnly="True" VisibleIndex="0" >
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                             </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                             </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Rate" ReadOnly="True" VisibleIndex="2" >
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                             </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents DropDown="lookup" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" ValueChanged="function(s,e){
                                                                                closing = true;
                                                                                //gl2.GetGridView().PerformCallback('VATCode' + '|' + glVATCode.GetValue() + '|' + 'code');
                                                                                var grid = glVATCode2.GetGridView();
                                                                                grid.GetRowValues(grid.GetFocusedRowIndex(), 'Rate', PutDesc2);    
                                                                                valchange_VAT = true
                                                                                gvService.batchEditApi.EndEdit(); 
                                                                              }" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="VATRate" ShowInCustomizationForm="True" VisibleIndex="11"  Width="0px">
                                                                <PropertiesSpinEdit ClientInstanceName="txtVatRate" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" Width="0px" Increment="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="CostApplied" ShowInCustomizationForm="True" VisibleIndex="12" Width="80px" ReadOnly="true">
                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" Width="0px" Increment="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn> 
                                                        <dx:GridViewDataTextColumn FieldName="EPNumber" Name="EPNumber" ShowInCustomizationForm="True" VisibleIndex="13" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsClosed" Caption="Closed" ReadOnly="true"  ShowInCustomizationForm="True" VisibleIndex="14">
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" VisibleIndex="15">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" VisibleIndex="16">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" VisibleIndex="17">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" VisibleIndex="18">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" VisibleIndex="19">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" VisibleIndex="20">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" VisibleIndex="21">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="22">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="23">
                                                        </dx:GridViewDataTextColumn>
                                                        
                                                    </Columns> 
                                                </dx:ASPxGridView>
                                            <dx:ASPxGridView ID="gvPRDetails" runat="server" AutoGenerateColumns="True" Width="0px" ClientVisible="false"
                                            ClientInstanceName="gvPRDetails" OnCustomCallback="gvPRDetails_CustomCallback" KeyFieldName="LineNumber;DocNumber;PRNumber;ServiceType;Description;ServiceQty;Unit;UnitCost;TotalCost;IsAllowProgressBilling;IsVat;VATCode;VATRate;CostApplied;EPNumber;IsClosed;Field1;Field2;Field3;Field4;Field5;Field6;Field7;Field8;Field9">                             
                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" EndCallback="POPUPGetJODetail"/>
                                            <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                            <SettingsPager Mode="ShowAllRecords"/> 
                                            <SettingsEditing Mode="Batch" />
                                            <Settings VerticalScrollableHeight="250" VerticalScrollBarMode="Auto" ShowStatusBar="Hidden" /> 
                                            <SettingsBehavior AllowSelectSingleRowOnly="false" />
                                        </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                            </Items>
                        </dx:ASPxFormLayout>
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem> <%--END OF GRID LAYOUTITEM--%>

 
        </Items>
    </dx:ASPxFormLayout>

    <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
        <PanelCollection>
            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                <div class="pnl-content">
                <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
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
                        <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                            <ClientSideEvents Click="function (s, e){ gv1.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                            </dx:ASPxButton>
                        <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                            <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                            </dx:ASPxButton> 
                    </tr>
                </table>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

   <%-- <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Loading..."
        ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
        <LoadingDivStyle Opacity="0"></LoadingDivStyle>
   </dx:ASPxLoadingPanel>--%>
        
    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server"  Text=""   Image-Url="..\images\loadinggear.gif" Image-Height="30px" Image-Width="30px" Height="30px" Width="30px" Enabled="true" ShowImage="true" BackColor="Transparent" Border-BorderStyle="None" 
            ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
        <LoadingDivStyle Opacity="0"></LoadingDivStyle>
   </dx:ASPxLoadingPanel>


</form>
<form id="form2" runat="server" visible="false">
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.PurchasedOrder" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.PurchasedOrder" UpdateMethod="UpdateData" DeleteMethod="Deletedata">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <%--Purchase Order ADD / UPDATE / EDIT Methods--%>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.PurchasedOrder+PurchasedOrderDetail" SelectMethod="getdetail" UpdateMethod="UpdatePurchasedOrderDetail" TypeName="Entity.PurchasedOrder+PurchasedOrderDetail" DeleteMethod="DeletePurchasedOrderDetail" InsertMethod="AddPurchasedOrderDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail2" runat="server" DataObjectTypeName="Entity.PurchasedOrder+PurchasedOrderService" SelectMethod="getdetail" UpdateMethod="UpdatePurchasedOrderService" TypeName="Entity.PurchasedOrder+PurchasedOrderService" DeleteMethod="DeletePurchasedOrderService" InsertMethod="AddPurchasedOrderService">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.PurchasedOrder+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Procurement.PurchaseOrderDetail where DocNumber is null"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Procurement.PurchaseOrderService where DocNumber is null"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
         OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
         OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsPicklistDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
      <%--Supplier Code Look Up--%>
    <asp:SqlDataSource ID="SupplierCodelookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <%--Contact Person Code Look Up--%>
    <%--<asp:SqlDataSource ID="ContactPersonlookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit = "Connection_Init">
    </asp:SqlDataSource>--%>
    <%--Currency Look Up--%>
    <asp:SqlDataSource ID="Currencylookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select Currency,CurrencyName from masterfile.Currency where ISNULL(IsInactive,0)!=1"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <%--Contact Person Code Look Up--%>
    <asp:SqlDataSource ID="Termslookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT APTerms,SupplierCode FROM Masterfile.BPSupplierInfo WHERE ISNULL([IsInactive],0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <%--Receiving Warehouse Code Look Up--%>
    <asp:SqlDataSource ID="ReceivingWarehouselookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Description FROM Masterfile.[Warehouse] WHERE ISNULL([IsInactive],0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <%--PR Number Look Up--%>
    <asp:SqlDataSource ID="PRNumberlookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <%--Quotation Number Look Up--%>
    <asp:SqlDataSource ID="QuotationNumberlookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber,Supplier FROM Procurement.[Quotation] WHERE ISNULL(SubmittedBy,'')!='' AND Status = 'A'"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
        <%--Quotation Number Look Up--%>
    <asp:SqlDataSource ID="Unitlookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select DISTINCT UnitCode AS Unit, Description from masterfile.Unit where ISNULL(IsInactive, 0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
   <asp:SqlDataSource ID="VatCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TCode,Description,Rate FROM Masterfile.Tax WHERE ISNULL(IsInactive,0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Temporary" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="ServiceLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select ServiceCode,Description,Type,IsVatable,IsAllowBilling from Masterfile.Service where ISNULL(IsInactive, 0)=0
        and Type = 'EXPENSE' and isnull(IsCore,0)=1"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
</form>
    <!--#region Region Datasource-->
</body>
</html>


