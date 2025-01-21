<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmJobOrder.aspx.cs" Inherits="GWL.frmJobOrder" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <script src="../js/Production/JobOrder.js" type="text/javascript"></script>
    <title>Job Order</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
        height: 710px; /*Change this whenever needed*/
        }

        .getsize{
            height: 100px;
            
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

         .statusBar a:first-child
            {
                display: none;
            }
    </style>
    <!--#endregion-->
    
    <!--#region Region Javascript-->
    
    <!--#endregion-->
</head>
<body style="height: 910px;" onload="onload()" >
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">   
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Job Order" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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
            EnableViewState="False" HeaderText="BizPartner Info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="260"
             ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
            EnableViewState="False" HeaderText="Notes" Height="207px" Width="247px" PopupHorizontalOffset="1085" PopupVerticalOffset="470"
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
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback" SettingsLoadingPanel-ImagePosition="Left" SettingsLoadingPanel-Enabled="False">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True"> 
                    <dx:ASPxPopupControl ID="v" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="SizeHorizontalPopup" CloseAction="CloseButton" CloseOnEscape="true"
                            EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="400px" ShowHeader="true" Width="600px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
                            ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
                        <HeaderImage Height="10px"></HeaderImage>
                        <ContentStyle HorizontalAlign="Center"></ContentStyle>
                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                                <dx:ASPxFormLayout ID="Special" runat="server" Height="300px" Width="800px" style="margin-left: -20px" >
                                    <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                                    <Items>
                                        <dx:LayoutGroup Caption="Item Detail">
                                            <Items>
                                                <dx:LayoutItem Caption="" HorizontalAlign ="Center">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server" >
                                                            <dx:ASPxGridView ID="gvSizeHorizontal" runat="server" AutoGenerateColumns="False" Width="800px" KeyFieldName="DocNumberX"
                                                                OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gvSizeHorizontal" 
                                                                OnRowValidating="grid_RowValidating" OnBatchUpdate="gvProductOrder_BatchUpdate" OnCustomButtonInitialize="gv_CustomButtonInitialize">                             
                                                                <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"
                                                                    BatchEditStartEditing="OnStartEditing"  BatchEditEndEditing="OnEndEditing" />
                                                                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                <Settings ColumnMinWidth="60" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="50" VerticalScrollBarMode="Auto" />
                                                                <SettingsBehavior AllowSort="False" AllowSelectSingleRowOnly="false" />
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
                                                                <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                                <Columns>
                                                                    <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumberX" Name="DocNumberX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="0px">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="Item" FieldName="ItemCodeX" Name="ItemCodeX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="100">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="Item Description" FieldName="FullDescX" Name="FullDescX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3" Width="150">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="Color" FieldName="ColorCodeX" Name="ColorCodeX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4" Width="100">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="Class" FieldName="ClassCodeX" Name="ClassCodeX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5" Width="100">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="Unit" FieldName="UnitX" Name="UnitX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6" Width="0">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataSpinEditColumn Caption="Order Qty" FieldName="OrderQtyX" Name="OrderQtyX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" PropertiesSpinEdit-DisplayFormatString="{0:N}">
                                                                        <PropertiesSpinEdit DisplayFormatString="{0:N}"></PropertiesSpinEdit>
                                                                    </dx:GridViewDataSpinEditColumn>  
                                                                    <dx:GridViewDataSpinEditColumn Caption="Unit Cost" FieldName="UnitPriceX" Name="UnitPriceX" Width="0" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8" PropertiesSpinEdit-DisplayFormatString="{0:N}">
                                                                        <PropertiesSpinEdit DisplayFormatString="{0:N}"></PropertiesSpinEdit>
                                                                    </dx:GridViewDataSpinEditColumn> 
                                                                    <dx:GridViewDataTextColumn Caption="BulkUnit" FieldName="BulkUnitX" Name="BulkUnitX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9" Width="0">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataCheckColumn Caption="IsByBulk" FieldName="IsByBulkX" Name="IsByBulkX" ShowInCustomizationForm="True" VisibleIndex="10" Width="0px">
                                                                        <PropertiesCheckEdit ClientInstanceName="glIsByBulkX">
                                                                        </PropertiesCheckEdit>
                                                                    </dx:GridViewDataCheckColumn>
                                                                </Columns>
                                                            </dx:ASPxGridView>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                            </Items>
                                        </dx:LayoutGroup>
                                        <dx:LayoutGroup Caption="Sizes">
                                            <Items>
                                                <dx:LayoutItem Caption="" HorizontalAlign ="Center">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxGridView ID="gvSizes" runat="server" AutoGenerateColumns="False" Width="800px" KeyFieldName="DocNumberX"
                                                                OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gvSizes" 
                                                                OnRowValidating="grid_RowValidating" OnBatchUpdate="gvProductOrder_BatchUpdate" OnCustomButtonInitialize="gv_CustomButtonInitialize">                             
                                                                <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing"  BatchEditEndEditing="OnEndEditing" />
                                                                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                <Settings ColumnMinWidth="60" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="50" VerticalScrollBarMode="Auto" />
                                                                <SettingsBehavior AllowSort="False" AllowSelectSingleRowOnly="false" />
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
                                                                <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                                <Columns>
                                                                    <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumberX" Name="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="0px">
                                                                    </dx:GridViewDataTextColumn>
                                                                </Columns>
                                                            </dx:ASPxGridView>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                            </Items>
                                        </dx:LayoutGroup>
                                        <dx:LayoutItem Caption="" HorizontalAlign="Center" ShowCaption="False" VerticalAlign="Middle">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxButton ID="btnSizeHorizontalExec" ClientInstanceName="btnSizeHorizontalExec" runat="server" Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" 
                                                        AutoPostBack="False" onload="ButtonLoad" ClientVisible="true" Text="Save" Theme="MetropolisBlue">                                                       
                                                        <ClientSideEvents Click="CallbackSize" />
                                                    </dx:ASPxButton>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:ASPxFormLayout>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                    
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="300px" Width="1280px" style="margin-left: -3px">
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
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server"  Width="170px" AutoCompleteType="Disabled" ClientEnabled="False" ClientInstanceName="txtDocNumber">
                                                                </dx:ASPxTextBox>
                                                                <dx:ASPxHiddenField runat="server" ID="hidcon"></dx:ASPxHiddenField>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" Width="170px" ClientInstanceName="dtpDocDate">
                                                                    <ClientSideEvents Validation="CheckDocDate"/>
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
                                                                <dx:ASPxTextBox ID="txtStatus" runat="server" ReadOnly="True" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="SO Due Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpSODueDate" runat="server" Width="170px" ClientInstanceName="dtpSODueDate">                                                                    
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="JO Due Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDueDate" runat="server" Width="170px" ClientInstanceName="dtpDueDate">
                                                                    <ClientSideEvents Validation="CheckDueDate" ValueChanged="calculateLead" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Customer Code">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglCustomerCode" runat="server" DataSourceID="sdsCustomer" Width="170px" KeyFieldName="BizPartnerCode" 
                                                                        TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName="aglCustomerCode">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Currency" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="0px" Visible="false">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function (s, e){ cp.PerformCallback('CallbackCustomer'); }"/>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Production Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpProdDate" runat="server" Width="170px" ClientInstanceName="dtpProdDate">
                                                                    <ClientSideEvents Validation ="CheckProdDate" ValueChanged="calculateLead" />
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Leadtime (Days)">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speLeadtime" runat="server" AllowMouseWheel="False" ClientInstanceName="speLeadtime" ConvertEmptyStringToNull="False" DisplayFormatString="{0}" MaxValue="9999999999" 
                                                                        NullDisplayText="0" NullText="0" Number="0" Width="170px">
                                                                    <SpinButtons ShowIncrementButtons="False">
                                                                    </SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Date Completed">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDateCompleted" runat="server" Width="170px" ReadOnly ="True">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Designer">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglDesigner" runat="server" Width="170px" DataSourceID="sdsDesigner" KeyFieldName="EmployeeCode" 
                                                                        TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName ="aglDesigner">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="EmployeeCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="DIS #">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglDIS" runat="server" Width="170px" DataSourceID="sdsDIS" KeyFieldName="DIS" 
                                                                        TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName="aglDIS">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DIS" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="DocDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="100px">
                                                                            <PropertiesDateEdit AllowMouseWheel="False" DisplayFormatString="MM/dd/yyyy">
                                                                                <DropDownButton ClientVisible="False" Enabled="False">
                                                                                </DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="DueDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="100px">
                                                                            <PropertiesDateEdit AllowMouseWheel="False" DisplayFormatString="MM/dd/yyyy">
                                                                                <DropDownButton ClientVisible="False" Enabled="False">
                                                                                </DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Type" ReadOnly="True" VisibleIndex="3" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Customer" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="StyleNo" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Color" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="OriginalDIS" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="DIS Qty" FieldName="DISQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:N}">
                                                                            </PropertiesTextEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Parent Step">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglParentStep" runat="server" AutoGenerateColumns="False" ClientInstanceName="aglParentStep" DataSourceID="sdsParentSteps" 
                                                                    KeyFieldName="StepCode"  TextFormatString="{0}" Width="170px" SelectionMode="Single">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="StepCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Allow Multi-In">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsMultiIn" runat="server" CheckState="Unchecked" ClientInstanceName="chkIsMultiIn">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Original JO">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtOriginalJO" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Auto JO">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsAutoJO" runat="server" CheckState="Unchecked" ClientEnabled="False" ClientInstanceName="chkIsAutoJO">
                                                                    <ClientSideEvents CheckedChanged="AutoJOchanged" />
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Customer Brand">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtCustBrand" runat="server" ReadOnly="True" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" Width="170px" ClientInstanceName="memRemarks">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="BookDate" ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpBookdate" runat="server" Width="170px" ClientInstanceName="dtpBookdate" ClientEnabled="true" ClientVisible="false">
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Product Order">
                                                <Items>
                                                    <dx:LayoutItem Caption="SizeHorizontal" ShowCaption="False" HorizontalAlign="Left">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxButton ID="btnSizeHorizontal" runat="server" Text="Size Horizontal" Width="170px" OnLoad="ButtonLoad"
                                                                        AutoPostBack="false" UseSubmitBehavior="false">
                                                                    <ClientSideEvents Click="ShowSizeHorizontal" />
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <div id="divProduct">
                                                                <dx:ASPxCallback ID="callbacker" runat="server" OnCallback="callbacker_Callback" ClientInstanceName="cbacker">
                                                                    <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
                                                                </dx:ASPxCallback>
                                                                <dx:ASPxGridView ID="gvProductOrder" runat="server" AutoGenerateColumns="False" Width="770px" ClientInstanceName="gvProductOrder" OnBatchUpdate="gvProductOrder_BatchUpdate" 
                                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize"
                                                                         KeyFieldName ="LineNumber">
                                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="gvProductRow"
                                                                        BatchEditEndEditing="gvProductOrder_OnEndEditing" BatchEditStartEditing="gvProductOrder_OnStartEditing" CustomButtonClick="OnCustomClick" />
                                                                    <SettingsPager Mode="ShowAllRecords">
                                                                    </SettingsPager>
                                                                    <SettingsEditing Mode="Batch">
                                                                    </SettingsEditing>
                                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />
                                                                    <SettingsBehavior AllowSort="False" />
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
                                                                    <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="0">
                                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px" ShowNewButtonInHeader="True">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="ProductDetails">
                                                                                <Image IconID="support_info_16x16"> </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                                <dx:GridViewCommandColumnCustomButton ID="ProductDelete">
                                                                                <Image IconID="actions_cancel_16x16"> </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Line Number" FieldName="LineNumber" Name="aLineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Reference SO" FieldName="ReferenceSO" Name="aReferenceSO" ShowInCustomizationForm="True" VisibleIndex="3" Width="150px" ReadOnly="true">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="4" Name="glpItemCode" Width="100px" HeaderStyle-Wrap="True" 
                                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">                                                            
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" OnInit="glItemCode_Init"
                                                                                    KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="100px" >
                                                                                        <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                            Settings-VerticalScrollBarMode="Visible"> 
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True"/>
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyDown="gvProductOrder_KeyDown"  
                                                                                        DropDown="lookup" EndCallback="GridEnd" ValueChanged="checkItem" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" VisibleIndex="5" Width="150px" Name="FullDesc" Caption="ItemDesc" ReadOnly="True" PropertiesTextEdit-EncodeHtml="false">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="6" Width="100px">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" 
                                                                                    DataSourceID="sdsColor" KeyFieldName="ColorCode" OnInit="lookup_Init"  TextFormatString="{0}" Width="100px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" >
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents CloseUp="gvProductOrder_CloseUp" DropDown="function(s, e){
                                                                                        gl2.GetGridView().PerformCallback('ColorCode' + '|' + PItem + '|' + s.GetInputElement().value);}" 
                                                                                        KeyDown="gvProductOrder_KeyDown" KeyPress="gvProductOrder_KeyPress" ValueChanged="validateRow" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" VisibleIndex="7" Width="100px">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl3" 
                                                                                    DataSourceID="sdsClass" KeyFieldName="ClassCode" OnInit="lookup_Init"  TextFormatString="{0}" Width="100px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" >
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents CloseUp="gvProductOrder_CloseUp" DropDown="function(s, e){
                                                                                        gl3.GetGridView().PerformCallback('ClassCode' + '|' + PItem + '|' + s.GetInputElement().value);}" 
                                                                                        KeyDown="gvProductOrder_KeyDown" KeyPress="gvProductOrder_KeyPress" ValueChanged="validateRow" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" VisibleIndex="8" Width="100px">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl4"
                                                                                        DataSourceID="sdsSize" KeyFieldName="SizeCode" OnInit="lookup_Init"  TextFormatString="{0}" Width="100px">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0">
                                                                                            <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents DropDown="function(s, e){
                                                                                        gl4.GetGridView().PerformCallback('SizeCode' + '|' + PItem + '|' + s.GetInputElement().value);}" 
                                                                                        KeyDown="gvProductOrder_KeyDown" KeyPress="gvProductOrder_KeyPress"
                                                                                        ValueChanged ="function(s, e){gvProductOrder.batchEditApi.EndEdit(); 
                                                                                        calculations();
                                                                                        getSize();
                                                                                        validateRow();
                                                                                        }" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="SOQty" Name="aSOQty" ShowInCustomizationForm="True" VisibleIndex="9" Caption="SO Quantity"> 
                                                                            <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="JOQty" Name="aJOQty" ShowInCustomizationForm="True" VisibleIndex="10" Caption="JO Quantity"> 
                                                                            <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                <ClientSideEvents ValueChanged ="function(s, e){gvProductOrder.batchEditApi.EndEdit(); 
                                                                                    calculations();
                                                                                    getSize();
                                                                                    }"/>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="INQty" Name="aINQty" ShowInCustomizationForm="True" VisibleIndex="11" Caption="IN Quantity" Width="0px"> 
                                                                            <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="FinalQty" Name="aFinalQty" ShowInCustomizationForm="True" VisibleIndex="12" Caption="Final Quantity" Width="0px"> 
                                                                            <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="aDField1" ShowInCustomizationForm="True" VisibleIndex="17" UnboundType="String" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="aDField2" ShowInCustomizationForm="True" VisibleIndex="18" UnboundType="String" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="aDField3" ShowInCustomizationForm="True" VisibleIndex="19" UnboundType="String" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="aDField4" ShowInCustomizationForm="True" VisibleIndex="20" UnboundType="String" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="aDField5" ShowInCustomizationForm="True" VisibleIndex="21" UnboundType="String" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="aDField6" ShowInCustomizationForm="True" VisibleIndex="22" UnboundType="String" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="aDField7" ShowInCustomizationForm="True" VisibleIndex="23" UnboundType="String" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="aDField8" ShowInCustomizationForm="True" VisibleIndex="24" UnboundType="String" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="aDField9" ShowInCustomizationForm="True" VisibleIndex="25" UnboundType="String" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Version" Name="aVersion" Caption="Version" ShowInCustomizationForm="True" VisibleIndex="26" Width="0px" >
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                                </div>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Quantity" ColCount="4">
                                                <Items>
                                                    <dx:LayoutItem Caption="Total JO Qty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalJO" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="speTotalJO" AllowMouseWheel="False"
                                                                                MaxValue="9999999999" MinValue ="0" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total SO Qty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalSO" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="speTotalSO" AllowMouseWheel="False"
                                                                                MaxValue="9999999999" MinValue ="0" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total IN Qty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalIN" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="speTotalIN" AllowMouseWheel="False"
                                                                                MaxValue="9999999999" MinValue ="0" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Final Qty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalFinal" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="speTotalFinal" AllowMouseWheel="False"
                                                                                MaxValue="9999999999" MinValue ="0" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Costing" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Currency" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglCurrency" runat="server" AutoGenerateColumns="False" DataSourceID="sdsCurrency" 
                                                                    KeyFieldName="Currency"  TextFormatString="{0}" Width="170px" ClientInstanceName="aglCurrency">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Currency" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CurrencyName" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
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
                                                    <dx:LayoutItem Caption="SRP">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speSRP" runat="server" AllowMouseWheel="False" ClientInstanceName="speSRP" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" 
                                                                    MaxValue="9999999999" NullDisplayText="0.00" NullText="0.00" Number="0.00" Width="170px">
                                                                    <SpinButtons ShowIncrementButtons="False">
                                                                    </SpinButtons>
                                                                    <ClientSideEvents GotFocus="" />
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Direct Labor">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTDirectLabor" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="speTDirectLabor" AllowMouseWheel="False"
                                                                                MaxValue="9999999999" MinValue ="0" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Actual Unit Cost">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speUnitCost" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="speUnitCost" AllowMouseWheel="False"
                                                                                MaxValue="9999999999" MinValue ="0" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Direct Material">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTDirectMat" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="speTDirectMat" AllowMouseWheel="False"
                                                                                MaxValue="9999999999" MinValue ="0" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Est. Unit Cost.">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speEstUnitCost" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="speEstUnitCost" AllowMouseWheel="False"
                                                                                MaxValue="9999999999" MinValue ="0" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Overhead">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTotalOH" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="speTotalOH" AllowMouseWheel="False"
                                                                                MaxValue="9999999999" MinValue ="0" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Est. Acc. Cost.">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speEstAccCost" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="speEstAccCost" AllowMouseWheel="False"
                                                                                MaxValue="9999999999" MinValue ="0" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Overhead Adjustment">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speOHAdj" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="speOHAdj" AllowMouseWheel="False"
                                                                                MaxValue="9999999999" MinValue ="0" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Standard OH Cost">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speStdOHCost" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="speStdOHCost" AllowMouseWheel="False"
                                                                                MaxValue="9999999999" MinValue ="0" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>                                            
                                            <dx:LayoutGroup Caption="Submission" ColCount="3">
                                                <Items>
                                                    <dx:LayoutItem Caption="Allocation Submitted By">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtHAllocSubmittedBy" runat="server" Width="170px" ClientEnabled="False" ClientInstanceName="txtHAllocSubmittedBy" DisabledStyle-BackColor="White" DisabledStyle-ForeColor="Black">
    <DisabledStyle BackColor="White" ForeColor="Black"></DisabledStyle>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Production Submitted By">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtHProdSubmittedBy" runat="server" Width="170px" ClientEnabled="False" DisabledStyle-BackColor="White" DisabledStyle-ForeColor="Black">
    <DisabledStyle BackColor="White" ForeColor="Black"></DisabledStyle>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Approved Leadtime By">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtHApprovedBy" runat="server" Width="170px" ClientEnabled="False" DisabledStyle-BackColor="White" DisabledStyle-ForeColor="Black">
    <DisabledStyle BackColor="White" ForeColor="Black"></DisabledStyle>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Allocation Submitted Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtHAllocSubmittedDate" runat="server" Width="170px" ClientEnabled="False" DisabledStyle-BackColor="White" DisabledStyle-ForeColor="Black">
    <DisabledStyle BackColor="White" ForeColor="Black"></DisabledStyle>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Production Submitted Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtHProdSubmittedDate" runat="server" Width="170px" ClientEnabled="False" DisabledStyle-BackColor="White" DisabledStyle-ForeColor="Black">
    <DisabledStyle BackColor="White" ForeColor="Black"></DisabledStyle>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Approved Leadtime Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtHApprovedDate" runat="server" Width="170px" ClientEnabled="False" DisabledStyle-BackColor="White" DisabledStyle-ForeColor="Black">
    <DisabledStyle BackColor="White" ForeColor="Black"></DisabledStyle>
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Bill of Material">
                                                
                                                <Items>
                                                    <dx:LayoutItem Caption="PIS No.">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td>  
                                                                            <dx:ASPxGridLookup ID="aglPISNumber" runat="server" Width="300px" DataSourceID="sdsPIS" KeyFieldName="PISNumber" 
                                                                                TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName ="aglPISNumber">
                                                                            <GridViewProperties>
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                <Settings ShowFilterRow="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="PISNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="PISDescription" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="CustomerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn> 
                                                                                <dx:GridViewDataTextColumn FieldName="StyleTemplateCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
																		    </dx:ASPxGridLookup>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel ID="lblLabel1" runat="server" Text="" Width="20" />
                                                                                
                                                                        </td>
                                                                        <td>
		                                                                    <dx:ASPxButton ID="btnPISDetail" runat="server" Text="Generate" Width="50px" AutoPostBack ="false" UseSubmitBehavior="false" ClientInstanceName ="btnPISDetail">                                                           
																			    <ClientSideEvents Click="function(s,e){gvBOM.PerformCallback('GeneratePIS|'+ aglPISNumber.GetText());}" />      
																		    </dx:ASPxButton>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutGroup Caption="BOM Details">
                                                        <Items>
                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <div id="divBOM">
                                                                        <dx:ASPxGridView ID="gvBOM" runat="server" AutoGenerateColumns="False" Width="770px" ClientInstanceName="gvBOM" OnBatchUpdate="gvBOM_BatchUpdate" 
                                                                                OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize"
                                                                            OnRowValidating="grid_RowValidating" KeyFieldName ="LineNumber" OnInit="gvBOM_Init" OnCustomCallback="gvBOM_CustomCallback" OnInitNewRow="gvBOM_InitNewRow">
                                                                            <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="gvBOM_OnEndEditing" 
                                                                                BatchEditStartEditing="gvBOM_OnStartEditing" CustomButtonClick="OnCustomClick" EndCallback="gvBOM_EndCallback"
                                                                                BatchEditRowValidating="Grid_BatchEditRowValidating"/>
                                                                            <SettingsPager Mode="ShowAllRecords">
                                                                            </SettingsPager>
                                                                            <SettingsEditing Mode="Batch">
                                                                            </SettingsEditing>
                                                                            <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" />
                                                                            <SettingsBehavior AllowSort="False" />
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
                                                                    <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" VisibleIndex="0" Width ="0">
                                                                                    <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                                    </PropertiesTextEdit>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px" ShowNewButtonInHeader="True" FixedStyle="Left" >
                                                                                    <CustomButtons>
                                                                                        <dx:GridViewCommandColumnCustomButton ID="BOMDetails">
                                                                                        <Image IconID="support_info_16x16"> </Image>
                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                        <dx:GridViewCommandColumnCustomButton ID="BOMDelete">
                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                    </CustomButtons>
                                                                                </dx:GridViewCommandColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Line Number" FieldName="LineNumber" Name="bLineNumber" Width="80px" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" FixedStyle="Left"  HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Components" FieldName="Components" Name="bComponents" Width="80px" ShowInCustomizationForm="True" VisibleIndex="3" FixedStyle="Left"  HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="bComponents" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="bComponents" 
                                                                                            DataSourceID="sdsComponents" KeyFieldName="Components"   TextFormatString="{0}" Width="80px">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="Components" ReadOnly="True" VisibleIndex="0">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            </Columns>
																					        <ClientSideEvents KeyPress="gvBOM_KeyPress" KeyDown="gvBOM_KeyDown" DropDown="lookup" ValueChanged="gvBOM_CloseUp"/>                                                                             
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="StepCode" FieldName="StepCode" Name="bStepCode" ShowInCustomizationForm="True" VisibleIndex="4" Width="80px" FixedStyle="Left"  HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="bStepCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="bStepCode" 
                                                                                                DataSourceID="sdsSteps" KeyFieldName="StepCode" TextFormatString="{0}" Width="80px" SelectionMode="Single">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="StepCode" ReadOnly="True" VisibleIndex="0">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            </Columns>
																					        <ClientSideEvents DropDown="lookup" KeyDown="gvBOM_KeyDown" ValueChanged="gvBOM_CloseUp"/>                                                                              
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Product Code" FieldName="ProductCode" Name="glProductCode" FixedStyle="Left"  ShowInCustomizationForm="True" VisibleIndex="5" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="bProductCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="bProductCode"
                                                                                                DataSourceID="sdsProdItem" KeyFieldName="ItemCode"  TextFormatString="{0}" Width="80px"  OnInit="bProductOrders_Init">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                            AllowSelectSingleRowOnly="True"/>
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            </Columns>
                                                                                            <ClientSideEvents KeyPress="gvBOM_KeyPress" KeyDown="gvBOM_KeyDown"
                                                                                                EndCallback="function(s,e){console.log(ProdItem ,s.GetGridView().cp_test); if((ProdItem === '' || ProdItem === null )&& dropdown){dropdown = false; s.SetValue(null); 
                                                                                                }
                                                                                                else{
                                                                                                loader.Hide();
                                                                                                }
                                                                                                    if(s.GetGridView().cp_unsel)
                                                                                                    {
                                                                                                delete (s.GetGridView().cp_unsel);
                                                                                                loader.Hide();
                                                                                                    }
                                                                                                }"
                                                                                                DropDown="function(s, e){dropdown = true; 
                                                                                                loader.Show();
                                                                                                loader.SetText('Filtering Lookup...');
                                                                                                bProductCode.GetGridView().PerformCallback('ItemCode' + '|' + 'code' + '|' + s.GetInputElement().value + '|' + 'noitem');
                                                                                                }"
                                                                                                ValueChanged ="function(){ calculations_specific(); gvBOM.batchEditApi.EndEdit(); }"/>                                                                            
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Product Color" FieldName="ProductColor" Name="glProductColor" FixedStyle="Left"  ShowInCustomizationForm="True" VisibleIndex="6" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="bProductColor" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="bProductColor"
                                                                                                DataSourceID="sdsProdColor" KeyFieldName="ColorCode"  TextFormatString="{0}" Width="80px" OnInit="bProductOrders_Init">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" Width="100px">
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            </Columns>
                                                                                            <ClientSideEvents KeyPress="gvBOM_KeyPress" KeyDown="gvBOM_KeyDown" CloseUp="gvBOM_CloseUp" 
                                                                                                DropDown="ProductColorFilter" ValueChanged ="function(){ calculations_specific(); gvBOM.batchEditApi.EndEdit(); }" />                                                                            
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Product Size" FieldName="ProductSize" Name="glProductSize" FixedStyle="Left"  ShowInCustomizationForm="True" VisibleIndex="7" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="bProductSize" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="bProductSize" 
                                                                                                DataSourceID="sdsProdSize" KeyFieldName="SizeCode"  TextFormatString="{0}" Width="80px" OnInit="bProductOrders_Init" >
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" Width="80px">
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            </Columns>
                                                                                            <ClientSideEvents KeyPress="gvBOM_KeyPress" KeyDown="gvBOM_KeyDown" CloseUp="gvBOM_CloseUp" 
                                                                                                DropDown="ProductSizeFilter" ValueChanged ="function(){ calculations_specific(); gvBOM.batchEditApi.EndEdit(); }"
                                                                                                LostFocus="function(){ calculations_specific(); }"/>                                                                             
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="8" Name="glpItemCode" FixedStyle="Left"  Width="80px" HeaderStyle-Wrap="True" 
                                                                                    HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">                                                            
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="bItemCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" OnInit="bItemCode_Init"
                                                                                            KeyFieldName="ItemCode" ClientInstanceName="BOMgl" TextFormatString="{0}" Width="80px" >
                                                                                            <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" Settings-VerticalScrollBarMode="Visible"> 
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Width="100px">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Width="150px">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                            </Columns>
                                                                                            <ClientSideEvents KeyPress="gvBOM_KeyPress" KeyDown="gvBOM_KeyDown" EndCallback="BOM_GridEnd"
                                                                                                DropDown="lookup" 
                                                                                                />
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="FullDesc" VisibleIndex="9" Width="150px" FixedStyle="Left"  Name="FullDesc" Caption="ItemDesc" ReadOnly="True" PropertiesTextEdit-EncodeHtml="false" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="10" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="bColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="BOMgl2" 
                                                                                            DataSourceID="sdsBOMColor" KeyFieldName="ColorCode" OnInit="BOM_Init"  TextFormatString="{0}" Width="80px">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" >
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                            </Columns>
                                                                                            <ClientSideEvents CloseUp="gvBOM_CloseUp" DropDown="function(s, e){
                                                                                                BOMgl2.GetGridView().PerformCallback('ColorCode' + '|' + BItem + '|' + s.GetInputElement().value);}" 
                                                                                                KeyDown="gvBOM_KeyDown" KeyPress="gvBOM_KeyPress" />
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="ClassCode" Name="ClassCode" ShowInCustomizationForm="True" VisibleIndex="11" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="bClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="BOMgl3" 
                                                                                            DataSourceID="sdsBOMClass" KeyFieldName="ClassCode" OnInit="BOM_Init"  TextFormatString="{0}" Width="80px">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" >
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                            </Columns>
                                                                                            <ClientSideEvents CloseUp="gvBOM_CloseUp" DropDown="function(s, e){
                                                                                                BOMgl3.GetGridView().PerformCallback('ClassCode' + '|' + BItem + '|' + s.GetInputElement().value);}" 
                                                                                                KeyDown="gvBOM_KeyDown" KeyPress="gvBOM_KeyPress"/>                                                                                           
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="SizeCode" Name="SizeCode" ShowInCustomizationForm="True" VisibleIndex="12" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="bSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="BOMgl4"
                                                                                                DataSourceID="sdsBOMSize" KeyFieldName="SizeCode" OnInit="BOM_Init"  TextFormatString="{0}" Width="80px">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                            </Columns>
                                                                                            <ClientSideEvents CloseUp="gvBOM_CloseUp" DropDown="function(s, e){
                                                                                                BOMgl4.GetGridView().PerformCallback('SizeCode' + '|' + BItem + '|' + s.GetInputElement().value);}" 
                                                                                                KeyDown="gvBOM_KeyDown" KeyPress="gvBOM_KeyPress"/>                                                                                            
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit" ShowInCustomizationForm="True" VisibleIndex="13" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="bUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="BOMgl5" DataSourceID="sdsUnit" KeyFieldName="Unit"   TextFormatString="{0}" Width="80px">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="Unit" ReadOnly="True" VisibleIndex="0">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                    </dx:GridViewDataTextColumn>
                                                                                            </Columns>
                                                                                            <ClientSideEvents CloseUp="gvBOM_CloseUp" KeyDown="gvBOM_KeyDown" KeyPress="gvBOM_KeyPress" />
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataSpinEditColumn FieldName="PerPieceConsumption" Name="bPerPieceConsumption" ShowInCustomizationForm="True" VisibleIndex="14" Caption="Per Piece Consumption" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False"> 
                                                                                    <PropertiesSpinEdit NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"  DisplayFormatString="{0:N6}" DecimalPlaces="6"
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                        <ClientSideEvents ValueChanged ="calculations_specific" />
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn FieldName="Consumption" Name="bConsumption" ShowInCustomizationForm="True" VisibleIndex="15" Caption="Consumption" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False"> 
                                                                                    <PropertiesSpinEdit NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"  DisplayFormatString="{0:N6}" DecimalPlaces="6"
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                        <ClientSideEvents ValueChanged ="calculations_specific" />
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn FieldName="AllowancePerc" Name="bAllowancePerc" ShowInCustomizationForm="True" VisibleIndex="16" Caption="Allowance %" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False"> 
                                                                                    <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" 
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                        <ClientSideEvents ValueChanged ="calculations_specific" />
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn FieldName="AllowanceQty" Name="bAllowanceQty" ShowInCustomizationForm="True" VisibleIndex="17" Caption="Allowance Qty" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False"> 
                                                                                    <PropertiesSpinEdit NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"  DisplayFormatString="{0:N6}" DecimalPlaces="6"
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                        <ClientSideEvents ValueChanged ="calculate_allowance_specific2" />
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn FieldName="RequiredQty" Name="bRequiredQty" ShowInCustomizationForm="True" VisibleIndex="18" Caption="Required Qty" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False"> 
                                                                                    <PropertiesSpinEdit NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"  DisplayFormatString="{0:N6}" DecimalPlaces="6"
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn FieldName="UnitCost" Name="bUnitCost" ShowInCustomizationForm="True" VisibleIndex="19" Caption="Unit Cost" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False"> 
                                                                                    <PropertiesSpinEdit NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"  DisplayFormatString="{0:N4}" DecimalPlaces="4"
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                        <ClientSideEvents ValueChanged ="calculations_specific" />
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataCheckColumn FieldName="IsMajorMaterial" Name="bIsMajorMaterial" ShowInCustomizationForm="True" VisibleIndex="20" Caption="Major Material"  Width="55px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesCheckEdit ClientInstanceName="glIsMajorMaterial" >
                                                                                        <ClientSideEvents CheckedChanged ="function(s, e){gvBOM.batchEditApi.EndEdit(); calculations_specific();}" />
                                                                                    </PropertiesCheckEdit>              
                                                                                </dx:GridViewDataCheckColumn>
                                                                                <dx:GridViewDataCheckColumn FieldName="IsBulk" Name="bIsBulk" ShowInCustomizationForm="True" VisibleIndex="21" Caption="Is Bulk"  Width="50px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesCheckEdit ClientInstanceName="glIsByBulk" >
                                                                                        <ClientSideEvents CheckedChanged ="function(s, e){gvBOM.batchEditApi.EndEdit(); calculations_specific();}" />
                                                                                    </PropertiesCheckEdit>              
                                                                                </dx:GridViewDataCheckColumn>
                                                                                <dx:GridViewDataCheckColumn FieldName="IsRounded" Name="bIsRounded" ShowInCustomizationForm="True" VisibleIndex="22" Caption="Is Rounded" Width="58px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesCheckEdit ClientInstanceName="glIsRounded" >
                                                                                        <ClientSideEvents CheckedChanged ="function(s, e){gvBOM.batchEditApi.EndEdit(); calculations_specific();}" />
                                                                                    </PropertiesCheckEdit>              
                                                                                </dx:GridViewDataCheckColumn>
                                                                                <dx:GridViewDataCheckColumn FieldName="IsExcluded" Name="bIsExcluded" ShowInCustomizationForm="True" VisibleIndex="23" Caption="Is Excluded" ReadOnly="true" Width="58px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesCheckEdit ClientInstanceName="glIsExcluded" >
                                                                                    </PropertiesCheckEdit>              
                                                                                </dx:GridViewDataCheckColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field1" Name="bDField1" ShowInCustomizationForm="True" VisibleIndex="27" UnboundType="String" Width="150px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field2" Name="bDField2" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="String" Width="150px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field3" Name="bDField3" ShowInCustomizationForm="True" VisibleIndex="29" UnboundType="String" Width="150px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field4" Name="bDField4" ShowInCustomizationForm="True" VisibleIndex="30" UnboundType="String" Width="150px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field5" Name="bDField5" ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="String" Width="150px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field6" Name="bDField6" ShowInCustomizationForm="True" VisibleIndex="32" UnboundType="String" Width="150px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field7" Name="bDField7" ShowInCustomizationForm="True" VisibleIndex="33" UnboundType="String" Width="150px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field8" Name="bDField8" ShowInCustomizationForm="True" VisibleIndex="34" UnboundType="String" Width="150px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field9" Name="bDField9" ShowInCustomizationForm="True" VisibleIndex="35" UnboundType="String" Width="150px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Version" Name="bVersion" Caption="Version" ShowInCustomizationForm="True" VisibleIndex="36" Width="0px" >
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
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Step">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvSteps" runat="server" AutoGenerateColumns="False" Width="770px" ClientInstanceName="gvSteps" OnBatchUpdate="gvSteps_BatchUpdate" 
                                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize"
                                                                    KeyFieldName ="LineNumber">
                                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="gvSteps_OnEndEditing" BatchEditStartEditing="gvSteps_OnStartEditing" CustomButtonClick="OnCustomClick" 
                                                                       />
                                                                    <SettingsPager Mode="ShowAllRecords">
                                                                    </SettingsPager>
                                                                    <SettingsEditing Mode="Batch">
                                                                    </SettingsEditing>
                                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" />
                                                                    <SettingsBehavior AllowSort="False" />
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
                                                                    <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="0">
                                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <%--<dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="30px" ShowNewButtonInHeader="True">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="StepsDelete">
                                                                                <Image IconID="actions_cancel_16x16"> </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>--%>
                                                                        <dx:GridViewDataTextColumn Caption="Line Number" FieldName="LineNumber" Name="cLineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Step Code" FieldName="StepCode" Name="cStepCode" ShowInCustomizationForm="True" VisibleIndex="2" Width="150px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="In Qty" FieldName="InQty" Name="cInQty" ShowInCustomizationForm="True" VisibleIndex="3" Width="150px">
                                                                            <PropertiesSpinEdit ClientInstanceName ="cInQty" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            <ClientSideEvents ValueChanged ="calculations" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Out Qty" FieldName="OutQty" Name="cOutQty" ShowInCustomizationForm="True" VisibleIndex="4" Width="150px">
                                                                            <PropertiesSpinEdit ClientInstanceName ="cOutQty" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            <ClientSideEvents ValueChanged ="calculations" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Adj Qty" FieldName="AdjQty" Name="cAdjQty" ShowInCustomizationForm="True" VisibleIndex="5" Width="150px">
                                                                            <PropertiesSpinEdit ClientInstanceName ="cAdjQty" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            <ClientSideEvents ValueChanged ="calculations" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>     
                                                                        <dx:GridViewDataSpinEditColumn Caption="Est. Loss" FieldName="Allowance" Name="cAllowance" ShowInCustomizationForm="True" VisibleIndex="6" Width="150px">
                                                                            <PropertiesSpinEdit ClientInstanceName ="cAllowance" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            <ClientSideEvents ValueChanged ="calculations" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>     
                                                                        <dx:GridViewDataSpinEditColumn Caption="Est. Yield" FieldName="Yield" Name="cYield" ShowInCustomizationForm="True" VisibleIndex="7" Width="150px">
                                                                            <PropertiesSpinEdit ClientInstanceName ="cYield" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            <ClientSideEvents ValueChanged ="calculations" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>     
                                                                        <dx:GridViewDataSpinEditColumn Caption="Actual Loss" FieldName="ActualLoss" Name="cActualLoss" ShowInCustomizationForm="True" VisibleIndex="6" Width="150px">
                                                                            <PropertiesSpinEdit ClientInstanceName ="cActualLoss" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            <ClientSideEvents ValueChanged ="calculations" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>     
                                                                        <dx:GridViewDataSpinEditColumn Caption="Actual Yield" FieldName="ActualYield" Name="cActualYield" ShowInCustomizationForm="True" VisibleIndex="7" Width="150px">
                                                                            <PropertiesSpinEdit ClientInstanceName ="cActualYield" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            <ClientSideEvents ValueChanged ="calculations" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>     
                                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="cDField1" ShowInCustomizationForm="True" VisibleIndex="8" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="cDField2" ShowInCustomizationForm="True" VisibleIndex="9" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="cDField3" ShowInCustomizationForm="True" VisibleIndex="10" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="cDField4" ShowInCustomizationForm="True" VisibleIndex="11" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="cDField5" ShowInCustomizationForm="True" VisibleIndex="12" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="cDField6" ShowInCustomizationForm="True" VisibleIndex="13" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="cDField7" ShowInCustomizationForm="True" VisibleIndex="14" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="cDField8" ShowInCustomizationForm="True" VisibleIndex="15" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="cDField9" ShowInCustomizationForm="True" VisibleIndex="16" UnboundType="String">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Version" Name="cVersion" Caption="Version" ShowInCustomizationForm="True" VisibleIndex="17" Width="0px" >
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Step Planning">
                                                <Items>
                                                    <dx:LayoutItem Caption="Step Template No.">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td> 
                                                                            <dx:ASPxGridLookup ID="aglStepTemplate" runat="server" Width="300px" DataSourceID="sdsStepTemplate" KeyFieldName="StepTemplateCode" 
                                                                                TextFormatString="{0}" AutoGenerateColumns="false" ClientInstanceName="aglStepTemplate">
                                                                                <GridViewProperties>
                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                    <Settings ShowFilterRow="True" />
                                                                                </GridViewProperties>
                                                                                <Columns>
                                                                                    <dx:GridViewDataTextColumn FieldName="StepTemplateCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="ParentStepCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                                        <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                </Columns>
                                                                                <%--<ClientSideEvents ValueChanged="function(s,e){gvStepPlanning.PerformCallback('CallbackTemplate');}"/>--%>
                                                                            </dx:ASPxGridLookup>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel ID="lblLabel2" runat="server" Text="" Width="20" /> 
                                                                        </td>
                                                                        <td>
		                                                                    <dx:ASPxButton ID="btnStepTempDetail" runat="server" Text="Generate" Width="50px" AutoPostBack ="false" UseSubmitBehavior="false" ClientInstanceName ="btnStepTempDetail">                                                           
                                                                                <ClientSideEvents Click="function(s,e){gvStepPlanning.PerformCallback('GenerateStepTemplate|' + aglStepTemplate.GetText());}" />  
                                                                            </dx:ASPxButton>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="" Width="20" />
                                                                        </td>
                                                                        <td>
		                                                                    <dx:ASPxButton ID="btnMultiPrintStep" runat="server" Text="Multi-Print" Width="100px" AutoPostBack ="false" UseSubmitBehavior="false" ClientInstanceName ="CINbtnMultiPrint">                                                           
																			    <ClientSideEvents Click="function(s,e){gvStepPlanning.PerformCallback('GenerateMultiPrint|');}" />      
																		    </dx:ASPxButton>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutGroup Caption="Step Planning Detail">
                                                        <Items>
                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <div id="divPlan">
                                                                        <dx:ASPxGridView ID="gvStepPlanning" runat="server" AutoGenerateColumns="False" Width="770px" ClientInstanceName="gvStepPlanning" OnBatchUpdate="gvStepPlanning_BatchUpdate" 
                                                                                OnCommandButtonInitialize="gv_CommandButtonInitialize_2" OnCustomButtonInitialize="gv_CustomButtonInitialize_2" OnDataBound="gvStepPlanning_DataBound"
                                                                            OnRowValidating="grid_RowValidating" KeyFieldName ="LineNumber" OnInit="gvStepPlanning_Init" OnCustomCallback="gvStepPlanning_CustomCallback" OnInitNewRow="gvStepPlanning_InitNewRow">
                                                                            <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="gvStepPlanning_OnEndEditing" 
                                                                                BatchEditStartEditing="gvStepPlanning_OnStartEditing" CustomButtonClick="OnCustomClick" EndCallback="gvStepPlanning_EndCallback" BatchEditRowValidating="gvStepCheck"/>
                                                                            <SettingsPager Mode="ShowAllRecords">
                                                                            </SettingsPager>
                                                                            <SettingsEditing Mode="Batch">
                                                                            </SettingsEditing>
                                                                            <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" />
                                                                            <SettingsBehavior AllowSort="False" />
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
                                                                    <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" VisibleIndex="0" Width="0" FixedStyle="Left" >
                                                                                    <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                                    </PropertiesTextEdit>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="30px" ShowNewButtonInHeader="True" FixedStyle="Left" >
                                                                                    <CustomButtons>
                                                                                        <dx:GridViewCommandColumnCustomButton ID="PlanDelete">
                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                    </CustomButtons>
                                                                                </dx:GridViewCommandColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Line Number" FieldName="LineNumber" Name="dLineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" FixedStyle="Left" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Sequence" FieldName="Sequence" Name="dSequence" ShowInCustomizationForm="True" VisibleIndex="3" Width="50px" FixedStyle="Left"  HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit ClientInstanceName ="dSequence" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataTextColumn Caption="StepCode" FieldName="StepCode" Name="dStepCode" ShowInCustomizationForm="True" VisibleIndex="4" Width="80px" FixedStyle="Left"  HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="dStepCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName ="dStepCode" 
                                                                                                DataSourceID="sdsPlanSteps" KeyFieldName="StepCode"  TextFormatString="{0}" Width="80px">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="StepCode" ReadOnly="True" VisibleIndex="0">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataCheckColumn FieldName="Inhouse" ReadOnly="True" VisibleIndex="3">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataCheckColumn>
                                                                                                <dx:GridViewDataCheckColumn FieldName="PreProd" ReadOnly="True" VisibleIndex="4">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataCheckColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="Overhead" ReadOnly="True" VisibleIndex="5">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataSpinEditColumn FieldName="WorkOrderPrice" ReadOnly="True" VisibleIndex="6">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="OHRate" ReadOnly="True" VisibleIndex="7">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="OHType" ReadOnly="True" VisibleIndex="8">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataSpinEditColumn FieldName="MinPrice" ReadOnly="True" VisibleIndex="9">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                <dx:GridViewDataSpinEditColumn FieldName="MaxPrice" ReadOnly="True" VisibleIndex="10">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                            </Columns>
                                                                                            <%--<ClientSideEvents KeyPress="gvStepPlanning_KeyPress" KeyDown="gvStepPlanning_KeyDown" DropDown="lookup" />
                                                                                            <GridViewClientSideEvents FocusedRowChanged ="function(s, e) { OnGridFocusedRowChangedStepCode(); }" />--%>
                                                                                            <ClientSideEvents ValueChanged="function(s,e){ 
                                                                                                        var grid = dStepCode.GetGridView();
                                                                                                        grid.GetRowValues(grid.GetFocusedRowIndex(), 'StepCode;Inhouse;PreProd;Overhead;WorkOrderPrice;OHRate;OHType;MinPrice;MaxPrice', OnGetRowValuesStepCode);
                                                                                                        calculate_UnitCost(); }" /> 
																					        <%--<ClientSideEvents KeyPress="gvStepPlanning_KeyPress" KeyDown="gvStepPlanning_KeyDown" DropDown="lookup" 
                                                                                                ValueChanged="function(s,e){
                                                                                                if(SPStep != dStepCode.GetValue()){
                                                                                                dForCallback.GetGridView().PerformCallback('StepCode' + '|' + dStepCode.GetValue() + '|' + 'code');
                                                                                                e.processOnServer = false;
                                                                                                SPvalchange = true;
                                                                                                calculate_UnitCost();
                                                                                                }}"/>    --%>                                             
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <%--<dx:GridViewDataTextColumn FieldName="WorkCenter" Name="dWorkCenter" ShowInCustomizationForm="True" VisibleIndex="5" UnboundType="String" ReadOnly="true" Width="80px">
                                                                                </dx:GridViewDataTextColumn>--%>
                                                                                <dx:GridViewDataTextColumn Caption="WorkCenter" FieldName="WorkCenter" Name="dWorkCenter" ShowInCustomizationForm="True" VisibleIndex="5" Width="80px" FixedStyle="Left"  HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="dWorkCenter" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName ="dWorkCenter" 
                                                                                                DataSourceID="sdsWorkCenter" KeyFieldName="WorkCenter"  TextFormatString="{0}" Width="80px">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="WorkCenter" ReadOnly="True" VisibleIndex="0">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            </Columns>
																					        <ClientSideEvents KeyPress="gvStepPlanning_KeyPress" KeyDown="gvStepPlanning_KeyDown" DropDown="lookup" />                                                 
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Overhead" FieldName="Overhead" Name="dOverhead" ShowInCustomizationForm="True" VisibleIndex="6" Width="80px" HeaderStyle-Wrap="True" 
                                                                                    HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" >
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="glOverhead" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="dOverhead" 
                                                                                            DataSourceID="sdsOverhead" KeyFieldName="Overhead" TextFormatString="{0}" Width="80px" OnInit="dStepCode_Init">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="Overhead" ReadOnly="True" VisibleIndex="0">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="OverheadCost" ReadOnly="True" ShowInCustomizationForm="True" 
                                                                                                        VisibleIndex="2" Caption="Overhead Cost">
                                                                                                    <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="OverheadType" ReadOnly="True" VisibleIndex="3">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            </Columns>
																				            <ClientSideEvents KeyPress="gvStepPlanning_KeyPress" KeyDown="gvStepPlanning_KeyDown" DropDown="lookup" 
                                                                                                ValueChanged="function(s,e){
                                                                                                if(SPOverhead != dOverhead.GetValue()){
                                                                                                dForCallback.GetGridView().PerformCallback('Overhead' + '|' + dOverhead.GetValue() + '|' + 'code');
                                                                                                e.processOnServer = false;
                                                                                                SPvalchange = true;}}"/>                                                                             
                                                                                        </dx:ASPxGridLookup>
                                                                                    </EditItemTemplate>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataCheckColumn FieldName="PreProd" Name="dPreProd" ShowInCustomizationForm="True" VisibleIndex="7" Caption="Pre Prod" ReadOnly="true" Width="50px" HeaderStyle-Wrap="True" 
                                                                                    HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesCheckEdit ClientInstanceName="dPreProd" >
                                                                                    </PropertiesCheckEdit>              
                                                                                </dx:GridViewDataCheckColumn>
                                                                                <dx:GridViewDataCheckColumn FieldName="IsInhouse" Name="dIsInhouse" ShowInCustomizationForm="True" VisibleIndex="8" Caption="In House" Width="50px" HeaderStyle-Wrap="True" 
                                                                                    HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesCheckEdit ClientInstanceName="dIsInhouse" ClientSideEvents-CheckedChanged="IsInhouseChanged" >
                                                                                    </PropertiesCheckEdit>              
                                                                                </dx:GridViewDataCheckColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="In Qty" FieldName="InQty" Name="dInQty" ShowInCustomizationForm="True" VisibleIndex="9" Width="70px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit ClientInstanceName ="dInQty" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Out Qty" FieldName="OutQty" Name="dOutQty" ShowInCustomizationForm="True" VisibleIndex="10" Width="70px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit ClientInstanceName ="dOutQty" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Adj Qty" FieldName="AdjQty" Name="dAdjQty" ShowInCustomizationForm="True" VisibleIndex="11" Width="70px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit ClientInstanceName ="dAdjQty" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>    
                                                                                <dx:GridViewDataSpinEditColumn Caption="Est. Loss" FieldName="Allowance" Name="dAllowance" ShowInCustomizationForm="True" VisibleIndex="12" Width="70px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit ClientInstanceName ="dAllowance" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn> 
                                                                                <dx:GridViewDataSpinEditColumn Caption="Est. Yield" FieldName="Yield" Name="dYield" ShowInCustomizationForm="True" VisibleIndex="13" Width="70px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit ClientInstanceName ="dYield" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>          
                                                                                <dx:GridViewDataSpinEditColumn Caption="Actual Loss" FieldName="ActualLoss" Name="dActualLoss" ShowInCustomizationForm="True" VisibleIndex="12" Width="70px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit ClientInstanceName ="dActualLoss" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn> 
                                                                                <dx:GridViewDataSpinEditColumn Caption="Actual Yield" FieldName="ActualYield" Name="dActualYield" ShowInCustomizationForm="True" VisibleIndex="13" Width="70px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit ClientInstanceName ="dActualYield" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>                                                                          
                                                                                <dx:GridViewDataSpinEditColumn FieldName="MinPrice" Name="dMinPrice" ShowInCustomizationForm="True" VisibleIndex="43" ReadOnly="True" Width="0px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                            SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>                                                                                
                                                                                <dx:GridViewDataSpinEditColumn FieldName="MaxPrice" Name="dMaxPrice" ShowInCustomizationForm="True" VisibleIndex="43" ReadOnly="True" Width="0px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                            SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Instruction" Name="dInstruction" ShowInCustomizationForm="True" VisibleIndex="14" UnboundType="String" Width="150px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Est. Work Order Price" FieldName="EstWorkOrderPrice" Name="dEstWorkOrderPrice" ShowInCustomizationForm="True" VisibleIndex="13" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit ClientInstanceName ="dEstWorkOrderPrice" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ClientSideEvents-ValueChanged="calculate_UnitCost">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Work Order Price" FieldName="WorkOrderPrice" Name="dWorkOrderPrice" ShowInCustomizationForm="True" VisibleIndex="15" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit ClientInstanceName ="dWorkOrderPrice" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn> 
                                                                                <dx:GridViewDataDateColumn Caption="Work Order Date" FieldName="WorkOrderDate" Name="dWorkOrderDate" ShowInCustomizationForm="True" VisibleIndex="16" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesDateEdit DisplayFormatString="MM/d/yyyy">
                                                                                    </PropertiesDateEdit>
                                                                                </dx:GridViewDataDateColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Work Order Qty" FieldName="WorkOrderQty" Name="dWorkOrderQty" ShowInCustomizationForm="True" VisibleIndex="17" Width="100px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit ClientInstanceName ="dWorkOrderQty" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                        SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataDateColumn Caption="Date Committed" FieldName="DateCommitted" Name="dDateCommitted" ShowInCustomizationForm="True" VisibleIndex="18" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesDateEdit DisplayFormatString="MM/d/yyyy">
                                                                                    </PropertiesDateEdit>
                                                                                </dx:GridViewDataDateColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="VAT" Name="dVAT" ShowInCustomizationForm="True" VisibleIndex="18" UnboundType="String" ReadOnly="true" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">                                                                                    
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataSpinEditColumn FieldName="VATRate" Caption="VAT Rate" Name="glpRate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="19" Width="0px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesSpinEdit ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                                        <SpinButtons Enabled="False" ShowIncrementButtons="False">
                                                                                        </SpinButtons>
                                                                                    </PropertiesSpinEdit>                                                                                    
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataDateColumn Caption="Target Date IN" FieldName="TargetDateIn" Name="dTargetDateIn" ShowInCustomizationForm="True" VisibleIndex="20" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesDateEdit DisplayFormatString="MM/d/yyyy">
                                                                                    </PropertiesDateEdit>
                                                                                </dx:GridViewDataDateColumn>
                                                                                <dx:GridViewDataDateColumn Caption="Target Date Out" FieldName="TargetDateOut" Name="dTargetDateOut" ShowInCustomizationForm="True" VisibleIndex="21" Width="80px" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesDateEdit DisplayFormatString="MM/d/yyyy">
                                                                                    </PropertiesDateEdit>
                                                                                </dx:GridViewDataDateColumn>
                                                                                <dx:GridViewDataDateColumn Caption="Actual Date IN" FieldName="ActualDateIn" Name="dActualDateIn" ShowInCustomizationForm="True" VisibleIndex="22" Width="80px" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesDateEdit DisplayFormatString="MM/d/yyyy">
                                                                                    </PropertiesDateEdit>
                                                                                </dx:GridViewDataDateColumn>
                                                                                <dx:GridViewDataDateColumn Caption="Actual Date Out" FieldName="ActualDateOut" Name="dActualDateOut" ShowInCustomizationForm="True" VisibleIndex="23" Width="80px" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <PropertiesDateEdit DisplayFormatString="MM/d/yyyy">
                                                                                    </PropertiesDateEdit>
                                                                                </dx:GridViewDataDateColumn>
                                                                                <dx:GridViewDataButtonEditColumn FieldName="WOPrint" Caption="Single Step" Name="dWOPrint" VisibleIndex="24" Width="100px" UnboundType="Object" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <DataItemTemplate >
                                                                                        <dx:ASPxButton ID="btnWOPrint"  ClientInstanceName="dWOPrint" runat="server" Width="90px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" 
                                                                                            ClientVisible="true" Text="Print" Theme="MetropolisBlue">
                                                                                            <ClientSideEvents Click="PrintoutPrintSingle" />
                                                                                        </dx:ASPxButton>
                                                                                    </DataItemTemplate>
                                                                                </dx:GridViewDataButtonEditColumn>
                                                                                <dx:GridViewDataButtonEditColumn FieldName="WOPrint1" Caption="Multiple Steps" Name="dWOPrintMultiple" VisibleIndex="25" Width="100px" UnboundType="Object" ReadOnly="true" HeaderStyle-Wrap="True" 
                                                            HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False">
                                                                                    <DataItemTemplate >
                                                                                        <dx:ASPxButton ID="btnWOPrint1"  ClientInstanceName="dWOPrint1" runat="server" Width="90px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" 
                                                                                            ClientVisible="true" Text="Print" Theme="MetropolisBlue">   
                                                                                            <ClientSideEvents Click="PrintoutPrintMulti" />                                                                                         
                                                                                        </dx:ASPxButton>
                                                                                    </DataItemTemplate>
                                                                                </dx:GridViewDataButtonEditColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field1" Name="dDField1" ShowInCustomizationForm="True" VisibleIndex="29" UnboundType="String">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field2" Name="dDField2" ShowInCustomizationForm="True" VisibleIndex="30" UnboundType="String">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field3" Name="dDField3" ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="String">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field4" Name="dDField4" ShowInCustomizationForm="True" VisibleIndex="32" UnboundType="String">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field5" Name="dDField5" ShowInCustomizationForm="True" VisibleIndex="33" UnboundType="String">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field6" Name="dDField6" ShowInCustomizationForm="True" VisibleIndex="34" UnboundType="String">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field7" Name="dDField7" ShowInCustomizationForm="True" VisibleIndex="35" UnboundType="String">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field8" Name="dDField8" ShowInCustomizationForm="True" VisibleIndex="36" UnboundType="String">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field9" Name="dDField9" ShowInCustomizationForm="True" VisibleIndex="37" UnboundType="String">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Version" Name="dVersion" Caption="Version" ShowInCustomizationForm="True" VisibleIndex="38" Width="0px" >
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataSpinEditColumn FieldName="OHRate" Name="dOHRate" ShowInCustomizationForm="True" VisibleIndex="39" ReadOnly="True" Width="0px">
                                                                                    <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                                            SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="false">
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>                                           
                                                                                <dx:GridViewDataTextColumn FieldName="OHType" Name="dOHType" ShowInCustomizationForm="True" VisibleIndex="40" ReadOnly="True" Width="0px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="ForCallback" FieldName="ForCallback" Name="dForCallback" ShowInCustomizationForm="True" VisibleIndex="41" Width="0px">
                                                                                    <EditItemTemplate>
                                                                                        <dx:ASPxGridLookup ID="glForCallback" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="dForCallback" 
                                                                                            DataSourceID="sdsForCallback" KeyFieldName="Overhead"   TextFormatString="{0}" Width="0px" OnInit="dStepCode_Init">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                            </GridViewProperties>
                                                                                            <Columns>
                                                                                                <dx:GridViewDataTextColumn FieldName="Overhead" ReadOnly="True" VisibleIndex="0">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            </Columns>
																				            <ClientSideEvents KeyPress="gvStepPlanning_KeyPress" KeyDown="gvStepPlanning_KeyDown" CloseUp="gvStepPlanning_CloseUp" EndCallback="SP_GridEnd"/>                                                                             
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
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup ShowCaption="False" Width="100%">
                                                <Items>
                                                    <dx:LayoutGroup Caption="Class" Width="50%" ColCount="1" Height="190">
                                                        <Items>
                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <div id="divClass">
                                                                        <dx:ASPxGridView ID="gvClass" runat="server" AutoGenerateColumns="False" ClientInstanceName="gvClass" KeyFieldName="LineNumber" OnBatchUpdate="gvClass_BatchUpdate"  
                                                                            OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize" OnRowValidating="grid_RowValidating" Width="660">
                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="gvClass_OnEndEditing" BatchEditStartEditing="gvClass_OnStartEditing" CustomButtonClick="OnCustomClick"/>
                                                                            <SettingsPager Mode="ShowAllRecords">
                                                                            </SettingsPager>
                                                                            <SettingsEditing Mode="Batch">
                                                                            </SettingsEditing>
                                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" />
                                                                            <SettingsBehavior AllowSort="False" />
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
                                                                    <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                                    <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                                    </PropertiesTextEdit>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Line Number" FieldName="LineNumber" Name="eLineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="0px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Class Code" FieldName="ClassCode" Name="eClassCode" ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Quantity" FieldName="Qty" Name="eQty" ShowInCustomizationForm="True" VisibleIndex="3" Width="100px">
                                                                                    <PropertiesSpinEdit AllowMouseWheel="False" ClientInstanceName="eQty" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" MaxValue="9999999999" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                                        <SpinButtons ShowIncrementButtons="False">
                                                                                        </SpinButtons>
                                                                                        <ClientSideEvents ValueChanged ="calculations" />
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field1" Name="eDField1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="4">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field2" Name="eDField2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="5">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field3" Name="eDField3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="6">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field4" Name="eDField4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field5" Name="eDField5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="8">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field6" Name="eDField6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="9">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field7" Name="eDField7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="10">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field8" Name="eDField8" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="11">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field9" Name="eDField9" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="12">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Version" FieldName="Version" Name="eVersion" ShowInCustomizationForm="True" VisibleIndex="13" Width="0px">
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                        </dx:ASPxGridView>
                                                                        </div>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutGroup Caption="Sizes" Width="50%" ColCount="1" Height="190">
                                                        <Items>
                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <div id="divSize">
                                                                        <dx:ASPxGridView ID="gvSize" runat="server" AutoGenerateColumns="False" ClientInstanceName="gvSize" KeyFieldName="LineNumber" OnBatchUpdate="gvSize_BatchUpdate"  
                                                                            OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize" OnRowValidating="grid_RowValidating" Width="660">
                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="gvSize_OnEndEditing" BatchEditStartEditing="gvSize_OnStartEditing" CustomButtonClick="OnCustomClick" />
                                                                            <SettingsPager Mode="ShowAllRecords">
                                                                            </SettingsPager>
                                                                            <SettingsEditing Mode="Batch">
                                                                            </SettingsEditing>
                                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" />
                                                                            <SettingsBehavior AllowSort="False" />
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
                                                                    <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                                                    <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                                    </PropertiesTextEdit>
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Line Number" FieldName="LineNumber" Name="fLineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="0px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Sizes" FieldName="StockSize" Name="fStockSize" ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="SO Qty" FieldName="SOQty" Name="fSOQty" ShowInCustomizationForm="True" VisibleIndex="3" Width="80px">
                                                                                    <PropertiesSpinEdit AllowMouseWheel="False" ClientInstanceName="fSOQty" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" MaxValue="9999999999" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                                        <SpinButtons ShowIncrementButtons="False">
                                                                                        </SpinButtons>
                                                                                        <ClientSideEvents ValueChanged ="calculations" />
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="JO Qty" FieldName="JOQty" Name="fJOQty" ShowInCustomizationForm="True" VisibleIndex="4" Width="80px">
                                                                                    <PropertiesSpinEdit AllowMouseWheel="False" ClientInstanceName="fJOQty" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" MaxValue="9999999999" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                                        <SpinButtons ShowIncrementButtons="False">
                                                                                        </SpinButtons>
                                                                                        <ClientSideEvents ValueChanged ="calculations" />
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="IN Qty" FieldName="INQty" Name="fINQty" ShowInCustomizationForm="True" VisibleIndex="5" Width="80px">
                                                                                    <PropertiesSpinEdit AllowMouseWheel="False" ClientInstanceName="fINQty" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" MaxValue="9999999999" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                                        <SpinButtons ShowIncrementButtons="False">
                                                                                        </SpinButtons>
                                                                                        <ClientSideEvents ValueChanged ="calculations" />
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Final Qty" FieldName="FinalQty" Name="fFinalQty" ShowInCustomizationForm="True" VisibleIndex="6" Width="80px">
                                                                                    <PropertiesSpinEdit AllowMouseWheel="False" ClientInstanceName="fFinalQty" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" MaxValue="9999999999" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                                        <SpinButtons ShowIncrementButtons="False">
                                                                                        </SpinButtons>
                                                                                        <ClientSideEvents ValueChanged ="calculations" />
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field1" Name="fDField1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field2" Name="fDField2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="8">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field3" Name="fDField3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="9">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field4" Name="fDField4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="10">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field5" Name="fDField5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="11">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field6" Name="fDField6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="12">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field7" Name="fDField7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="13">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field8" Name="fDField8" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="14">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Field9" Name="fDField9" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="15">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn Caption="Version" FieldName="Version" Name="fVersion" ShowInCustomizationForm="True" VisibleIndex="16" Width="0px">
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
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Material Movement">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <div id="divMat">
                                                                <dx:ASPxGridView ID="gvMaterial" runat="server" AutoGenerateColumns="False" Width="770px" ClientInstanceName="gvMaterial" 
                                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize"
                                                                    OnRowValidating="grid_RowValidating" KeyFieldName ="LineNumber">
                                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="gvMaterial_OnEndEditing" BatchEditStartEditing="gvMaterial_OnStartEditing" CustomButtonClick="OnCustomClick" />
                                                                    <SettingsPager Mode="ShowAllRecords">
                                                                    </SettingsPager>
                                                                    <SettingsEditing Mode="Batch">
                                                                    </SettingsEditing>
                                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" />
                                                                    <SettingsBehavior AllowSort="False" />
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
                                                                    <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="0">
                                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                            </PropertiesTextEdit>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="30px" ShowNewButtonInHeader="False">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="MatDetails">
                                                                                <Image IconID="support_info_16x16"> </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Line Number" FieldName="LineNumber" Name="fLineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="StepCode" FieldName="StepCode" Name="gStepCode" ShowInCustomizationForm="True" VisibleIndex="3" Width="150px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" Name="gItemCode" ShowInCustomizationForm="True" VisibleIndex="4" Caption="ItemCode" Width="150px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" Name="gFullDesc" ShowInCustomizationForm="True" VisibleIndex="5" Caption="Item Decription" Width="150px" PropertiesTextEdit-EncodeHtml="false">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" Name="gColorCode" ShowInCustomizationForm="True" VisibleIndex="6" Caption="ColorCode" Width="150px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" Name="gClassCode" ShowInCustomizationForm="True" VisibleIndex="7" Caption="ClassCode" Width="150px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Name="gSizeCode" ShowInCustomizationForm="True" VisibleIndex="8" Caption="SizeCode" Width="150px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Unit" Name="gUnit" ShowInCustomizationForm="True" VisibleIndex="9" Caption="Unit" Width="150px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Issued Qty" FieldName="IssuedQty" Name="gIssuedQty" ShowInCustomizationForm="True" VisibleIndex="10" Width="150px" ReadOnly="True">
                                                                            <PropertiesSpinEdit ClientInstanceName ="gIssuedQty" NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"  
                                                                                DisplayFormatString="{0:N6}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Return Qty" FieldName="ReturnQty" Name="gReturnQty" ShowInCustomizationForm="True" VisibleIndex="11" Width="150px" ReadOnly="True">
                                                                            <PropertiesSpinEdit ClientInstanceName ="gReturnQty" NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"  
                                                                                DisplayFormatString="{0:N6}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Consumption" FieldName="Consumption" Name="gConsumption" ShowInCustomizationForm="True" VisibleIndex="12" Width="150px" ReadOnly="True">
                                                                            <PropertiesSpinEdit ClientInstanceName ="gConsumption" NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"  
                                                                                DisplayFormatString="{0:N6}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Allowance Qty" FieldName="AllowanceQty" Name="gAllowanceQty" ShowInCustomizationForm="True" VisibleIndex="13" Width="150px" ReadOnly="True">
                                                                            <PropertiesSpinEdit ClientInstanceName ="gAllowanceQty" NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"  
                                                                                DisplayFormatString="{0:N6}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" MaxValue="9999999999">
                                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="IN Qty" FieldName="INQty" Name="gINQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="14" Width="150px">
                                                                            <PropertiesSpinEdit AllowMouseWheel="False" ClientInstanceName="gINQty" ConvertEmptyStringToNull="False" NullDisplayText="0.000000" NullText="0.000000"  
                                                                                DisplayFormatString="{0:N6}" MaxValue="9999999999" NumberFormat="Custom">
                                                                                <SpinButtons ShowIncrementButtons="False">
                                                                                </SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Allocation" FieldName="Allocation" Name="gAllocation" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="15" Width="150px">
                                                                            <PropertiesSpinEdit AllowMouseWheel="False" ClientInstanceName="gAllocation" ConvertEmptyStringToNull="False" NullDisplayText="0.000000" NullText="0.000000"  
                                                                                DisplayFormatString="{0:N6}" MaxValue="9999999999" NumberFormat="Custom">
                                                                                <SpinButtons ShowIncrementButtons="False">
                                                                                </SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Replacement Qty" FieldName="ReplacementQty" Name="gReplacementQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="16" Width="150px">
                                                                            <PropertiesSpinEdit AllowMouseWheel="False" ClientInstanceName="gReplacementQty" ConvertEmptyStringToNull="False" NullDisplayText="0.000000" NullText="0.000000"  
                                                                                DisplayFormatString="{0:N6}" MaxValue="9999999999" NumberFormat="Custom">
                                                                                <SpinButtons ShowIncrementButtons="False">
                                                                                </SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Charge Qty" FieldName="ChargeQty" Name="gChargeQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="17" Width="150px">
                                                                            <PropertiesSpinEdit AllowMouseWheel="False" ClientInstanceName="gChargeQty" ConvertEmptyStringToNull="False" NullDisplayText="0.000000" NullText="0.000000"  
                                                                                DisplayFormatString="{0:N6}" MaxValue="9999999999" NumberFormat="Custom">
                                                                                <SpinButtons ShowIncrementButtons="False">
                                                                                </SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataCheckColumn Caption="No Return" FieldName="NoReturn" Name="gNoReturn" ShowInCustomizationForm="True" VisibleIndex="18" Width="70px">
                                                                            <PropertiesCheckEdit ClientInstanceName="glNoReturn">
                                                                            </PropertiesCheckEdit>
                                                                        </dx:GridViewDataCheckColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Remarks" Name="gRemarks" ShowInCustomizationForm="True" VisibleIndex="19" Caption="Remarks" Width="150px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataCheckColumn Caption="Charged Already" FieldName="IsChargedAlready" Name="gIsChargedAlready" ShowInCustomizationForm="True" VisibleIndex="20" Width="100px">
                                                                            <PropertiesCheckEdit ClientInstanceName="glIsChargedAlready">
                                                                            </PropertiesCheckEdit>
                                                                        </dx:GridViewDataCheckColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                                </div>
                                                             </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>                                 
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" >
                                                        </dx:ASPxTextBox>
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
                                            <dx:LayoutItem Caption="Manual Closed By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtManualClosedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Manual Closed Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtManualClosedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px"  KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Settings-ShowStatusBar="Hidden">
                                                        <Settings ShowStatusBar="Hidden"></Settings>
                                                        <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="NextColumn" />
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                        <SettingsPager PageSize="5">
                                                        </SettingsPager>
                                                        <SettingsEditing Mode="Batch">
                                                        </SettingsEditing>
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
                                                                    <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ButtonType="Image"  ShowInCustomizationForm="True" VisibleIndex="0" Width="90px" >            
                                                                <CustomButtons>
                                                                    <dx:GridViewCommandColumnCustomButton ID="ViewReferenceTransaction">
                                                                    <Image IconID="functionlibrary_lookupreference_16x16"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                    <dx:GridViewCommandColumnCustomButton ID="ViewTransaction">
                                                                    <Image IconID="find_find_16x16"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>
                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="RTransType" Caption="Reference TransType" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly="True"  Name="RTransType">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="REFDocNumber" Caption="Reference DocNumber" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="True" >
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4" ReadOnly="True">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Caption="DocNumber"  ReadOnly="True">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6"   ReadOnly="True">
                                                            </dx:GridViewDataTextColumn>
                                                        </Columns>
                                                    </dx:ASPxGridView>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:LayoutGroup>  
                                </Items>
                            </dx:TabbedLayoutGroup>
                        </Items>
                    </dx:ASPxFormLayout>
                    <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px" >
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content"">
                                <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                                    UseSubmitBehavior="false" CausesValidation="true">
                                    <ClientSideEvents Click="OnUpdateClick" />
                                </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                    <dx:ASPxLoadingPanel ID="ProductLoader" runat="server" Text="Saving..." Modal="true"
                        ClientInstanceName="ProductLoader" ContainerElementID="divProduct" HorizontalAlign="Center" VerticalAlign="Middle">
                            <LoadingDivStyle Opacity="0" BackColor="#333333" BorderRight-BorderStyle="NotSet"></LoadingDivStyle>
                    </dx:ASPxLoadingPanel>
                    <dx:ASPxLoadingPanel ID="BOMLoader" runat="server" Text="Saving..." Modal="true"
                        ClientInstanceName="BOMLoader" ContainerElementID="divBOM" LoadingDivStyle-BackgroundImage-HorizontalPosition="center"
                        LoadingDivStyle-BackgroundImage-VerticalPosition="center">
                            <LoadingDivStyle Opacity="0" BackColor="#333333"></LoadingDivStyle>
                    </dx:ASPxLoadingPanel>
                    <dx:ASPxLoadingPanel ID="PlanLoader" runat="server" Text="Saving..." Modal="true"
                        ClientInstanceName="PlanLoader" ContainerElementID="divPlan" LoadingDivStyle-BackgroundImage-HorizontalPosition="center"
                        LoadingDivStyle-BackgroundImage-VerticalPosition="center">
                            <LoadingDivStyle Opacity="0" BackColor="#333333"></LoadingDivStyle>
                    </dx:ASPxLoadingPanel>
                    <dx:ASPxLoadingPanel ID="ClassLoader" runat="server" Text="Saving..." Modal="true"
                        ClientInstanceName="ClassLoader" ContainerElementID="divClass" LoadingDivStyle-BackgroundImage-HorizontalPosition="center"
                        LoadingDivStyle-BackgroundImage-VerticalPosition="center">
                            <LoadingDivStyle Opacity="0" BackColor="#333333"></LoadingDivStyle>
                    </dx:ASPxLoadingPanel>
                    <dx:ASPxLoadingPanel ID="SizeLoader" runat="server" Text="Saving..." Modal="true"
                        ClientInstanceName="SizeLoader" ContainerElementID="divSize" LoadingDivStyle-BackgroundImage-HorizontalPosition="center"
                        LoadingDivStyle-BackgroundImage-VerticalPosition="center">
                            <LoadingDivStyle Opacity="0" BackColor="#333333"></LoadingDivStyle>
                    </dx:ASPxLoadingPanel>
                    <dx:ASPxLoadingPanel ID="MatLoader" runat="server" Text="Saving..." Modal="true"
                        ClientInstanceName="MatLoader" ContainerElementID="divMat" LoadingDivStyle-BackgroundImage-HorizontalPosition="center"
                        LoadingDivStyle-BackgroundImage-VerticalPosition="center">
                            <LoadingDivStyle Opacity="0" BackColor="#333333"></LoadingDivStyle>
                    </dx:ASPxLoadingPanel>
                    <dx:ASPxLoadingPanel ID="Loader" runat="server" Text="" Modal="true"
                        ClientInstanceName="loader" ContainerElementID="divBOM" LoadingDivStyle-BackgroundImage-HorizontalPosition="center"
                        LoadingDivStyle-BackgroundImage-VerticalPosition="center">
                            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
                    </dx:ASPxLoadingPanel>
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
                                    <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false">
                                        <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                        </dx:ASPxButton></td>
                                    <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" AutoPostBack="false" UseSubmitBehavior="false">
                                        <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                        </dx:ASPxButton> </td>
                                </tr>
                            </table>
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>         
            </dx:PanelContent>
        </PanelCollection>
        </dx:ASPxCallbackPanel> 
       
    </form>
    <!--#region Region Datasource-->
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.Collection" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.Collection" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.SalesInvoice+SalesInvoiceDetail" SelectMethod="getdetail" UpdateMethod="UpdateSalesInvoiceDetail" TypeName="Entity.SalesInvoice+SalesInvoiceDetail" DeleteMethod="DeleteSalesInvoiceDetail" InsertMethod="AddSalesInvoiceDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsProductOrder" runat="server" DataObjectTypeName="Entity.JobOrder+JOProductOrder" SelectMethod="getJOProductOrder" UpdateMethod="UpdateJOProductOrder" TypeName="Entity.JobOrder+JOProductOrder" DeleteMethod="DeleteJOProductOrder" InsertMethod="AddJOProductOrder">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsBOM" runat="server" DataObjectTypeName="Entity.JobOrder+JOBillOfMaterial" SelectMethod="getJOBillOfMaterial" UpdateMethod="UpdateJOBillOfMaterial" TypeName="Entity.JobOrder+JOBillOfMaterial" DeleteMethod="DeleteJOBillOfMaterial" InsertMethod="AddJOBillOfMaterial">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsSteps" runat="server" DataObjectTypeName="Entity.JobOrder+JOStep" SelectMethod="getJOStep" UpdateMethod="UpdateJOStep" TypeName="Entity.JobOrder+JOStep" DeleteMethod="DeleteJOStep" InsertMethod="AddJOStep">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsStepPlanning" runat="server" DataObjectTypeName="Entity.JobOrder+JOStepPlanning" SelectMethod="getJOStepPlanning" UpdateMethod="UpdateJOStepPlanning" TypeName="Entity.JobOrder+JOStepPlanning" DeleteMethod="DeleteJOStepPlanning" InsertMethod="AddJOStepPlanning">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsClass" runat="server" DataObjectTypeName="Entity.JobOrder+JOClassBreakdown" SelectMethod="getJOClassBreakdown" UpdateMethod="UpdateJOClassBreakdown" TypeName="Entity.JobOrder+JOClassBreakdown" DeleteMethod="DeleteJOClassBreakdown" InsertMethod="AddJOClassBreakdown">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsSize" runat="server" DataObjectTypeName="Entity.JobOrder+JOSizeBreakdown" SelectMethod="getJOSizeBreakdown" UpdateMethod="UpdateJOSizeBreakdown" TypeName="Entity.JobOrder+JOSizeBreakdown" DeleteMethod="DeleteJOSizeBreakdown" InsertMethod="AddJOSizeBreakdown">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsMaterial" runat="server" SelectMethod="getJOMaterialMovement" TypeName="Entity.JobOrder+JOMaterialMovement">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.Collection+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.Collection+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Production.JobOrder WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsProductOrder" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Production.JOProductOrder WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBOM" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT top 10 * FROM Production.JOBillOfMaterial WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsJOSteps" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Production.JOStep WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsStepPlanning" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Production.JOStepPlanning WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsJOClass" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Production.JOClassBreakdown WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsJOSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Production.JOSizeBreakdown WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsMaterial" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Production.JOMaterialMovement WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT top 10 [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] A INNER JOIN Masterfile.ItemCategory B ON A.ItemCategoryCode = B.ItemCategoryCode WHERE ISNULL(A.IsInactive,0) = 0 AND ISNULL(B.IsAsset,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsClass" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBOMItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT top 10 [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] A INNER JOIN Masterfile.ItemCategory B ON A.ItemCategoryCode = B.ItemCategoryCode WHERE ISNULL(A.IsInactive,0) = 0 AND ISNULL(B.IsAsset,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBOMColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBOMClass" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBOMSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UPPER(UnitCode) AS Unit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBulkUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UPPER(UnitCode) AS BulkUnit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBOMItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT BizPartnerCode, Name, ISNULL(Currency,'PHP') AS Currency FROM Masterfile.BPCustomerInfo WHERE ISNULL(IsInActive,0)=0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDIS" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber AS DIS, DocDate, DueDate, Type, PIS, Customer, StyleNo, Color, OriginalDIS, ISNULL(DISQty,0) AS DISQty FROM Production.DIS WHERE Status IN ('N','W','C') AND ISNULL(SubmittedBy,'') != ''" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDesigner" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT EmployeeCode, FirstName + ' ' + LastName AS Name FROM Masterfile.BPEmployeeInfo WHERE ISNULL(IsInactive,0) = 0 ORDER BY FirstName, LastName ASC" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTaxCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TCode, Description, ISNULL(Rate,0) AS Rate FROM Masterfile.Tax WHERE ISNULL(IsInactive,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCurrency" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Currency, CurrencyName FROM Masterfile.Currency WHERE ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsPIS" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PISNumber, PISDescription, CustomerCode, StyleTemplateCode FROM Production.ProductInfoSheet WHERE ISNULL(ApprovedBy,'') != '' UNION ALL SELECT StyleCode AS PISNumber, Description AS PISDescription, '' AS CustomerCode, StyleCode AS StyleTemplateCode FROM Masterfile.StyleTemplate WHERE ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"> </asp:SqlDataSource>   
    <asp:SqlDataSource ID="sdsPISDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsComponents" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ComponentCode AS Components, Description FROM Masterfile.Component WHERE ISNULL(IsInactive,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSteps" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT StepCode, Description FROM Masterfile.Step WHERE ISNULL(IsInactive,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>  
    <asp:SqlDataSource ID="sdsPlanSteps" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT StepCode, A.Description, ISNULL(IsInhouse,0) AS Inhouse, ISNULL(IsPreProductionStep,0) AS PreProd, ISNULL(OverheadCode,'') AS Overhead, 
         ISNULL(EstimatedWOPrice,0) AS WorkOrderPrice, ISNULL(OverheadCost,0) AS OHRate, 
         CASE WHEN ISNULL(OverheadType,'')!= '' THEN LEFT(OverheadType,LEN(OverheadType)- (LEN(OverheadType)-1)) ELSE '' END AS OHType, 
         ISNULL(A.MinimumWOPrice,0) AS MinPrice, ISNULL(A.MaximumWOPrice,0) AS MaxPrice
         FROM Masterfile.Step A LEFT JOIN Masterfile.Overhead B ON A.OverheadCode = B.OHCode" OnInit ="Connection_Init"></asp:SqlDataSource>  
    <asp:SqlDataSource ID="sdsStepTemplate" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT StepTemplateCode, Description, ParentStepCode FROM Masterfile.StepTemplate WHERE ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsStepTemplateDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT '' AS DocNumber, RIGHT('00000'+ CAST(ROW_NUMBER() OVER (ORDER BY B.IsPreProductionStep DESC, Sequence ASC, A.StepCode ASC) AS VARCHAR(5)),5) AS LineNumber, Sequence,A.StepCode, '' AS WorkCenter,
        '' AS Overhead, ISNULL(B.IsPreProductionStep,0) AS PreProd, ISNULL(B.IsInhouse,0) AS IsInhouse, 0.00 AS InQty, 0.00 AS OutQty, 0.00 AS AdjQty, '' As Instruction, 0.00 AS EstWorkOrderPrice, ISNULL(B.EstimatedWOPrice,0) AS WorkOrderPrice, 0.00 AS WorkOrderQty, CONVERT(datetime,NULL) AS DateCommitted, '' AS VAT, 0.00 AS VATRate, CONVERT(datetime,NULL) AS TargetDateIn, CONVERT(datetime,NULL) AS TargetDateOut, CONVERT(datetime,NULL) AS ActualDateIn, 
        CONVERT(datetime,NULL) AS ActualDateOut, '' AS WOPrint,'' AS WOPrint1, CONVERT(VARCHAR(MAX),'') AS Field1, CONVERT(VARCHAR(MAX),'') AS Field2, CONVERT(VARCHAR(MAX),'') AS Field3, CONVERT(VARCHAR(MAX),'') AS Field4, CONVERT(VARCHAR(MAX),'') AS Field5, CONVERT(VARCHAR(MAX),'') AS Field6, CONVERT(VARCHAR(MAX),'') AS Field7, CONVERT(VARCHAR(MAX),'') AS Field8, CONVERT(VARCHAR(MAX),'') AS Field9, 
        '2' AS Version, 0.00 AS OHRate, '' AS OHType, '' AS ForCallback, ISNULL(B.MinimumWOPrice,0) AS MinPrice, ISNULL(B.MaximumWOPrice,0) AS MaxPrice FROM Masterfile.StepTemplateDetail A INNER JOIN Masterfile.Step B ON A.StepCode = B.StepCode" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsOverhead" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT OHCode AS Overhead, Description, OverheadCost, OverheadType FROM Masterfile.Overhead WHERE ISNULL(IsInactive,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>	
    <asp:SqlDataSource ID="sdsProdItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>  
    <asp:SqlDataSource ID="sdsProdColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>  
    <asp:SqlDataSource ID="sdsProdSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>  
    <%--<asp:SqlDataSource ID="sdsProdColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT DocNumber, ItemCode, ColorCode, '' AS SizeCode FROM Production.JOProductOrder" OnInit ="Connection_Init"></asp:SqlDataSource>  
    <asp:SqlDataSource ID="sdsProdSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT DocNumber, ItemCode, '' AS ColorCode, SizeCode FROM Production.JOProductOrder " OnInit ="Connection_Init"></asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="sdsParentSteps" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT StepCode, Description FROM Masterfile.Step WHERE ISNULL(IsInactive,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>  
    <asp:SqlDataSource ID="sdsForCallback" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT 'C' AS Overhead, 'CASCADED' AS Description UNION ALL SELECT DISTINCT 'N' AS Overhead, 'NOT CASCADED' AS Description" OnInit ="Connection_Init"></asp:SqlDataSource>	
    <asp:SqlDataSource ID="sdsWorkCenter" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select BizPartnerCode AS WorkCenter, Name AS Description from Masterfile.BizPartner where ISNULL(IsInactive,0) != 1" OnInit ="Connection_Init"></asp:SqlDataSource>	
    
    <asp:SqlDataSource ID="sdsSizeHorizontal" runat="server" SelectCommand="SELECT DISTINCT CONVERT(varchar(MAX),'') AS DocNumberX, CONVERT(varchar(MAX),'') AS ItemCodeX, CONVERT(varchar(MAX),'') AS ColorCodeX, CONVERT(varchar(MAX),'') AS ClassCodeX, CONVERT(varchar(MAX),'') AS UnitX, CONVERT(decimal(15,2), 0) AS OrderQtyX, CONVERT(decimal(15,2), 0) AS UnitPriceX, CONVERT(varchar(MAX),'') AS FullDescX, CONVERT(varchar(MAX),'') AS BulkUnitX, CONVERT(bit,'false') AS IsByBulkX FROM Sales.SalesOrderDetail WHERE DocNumber IS NULL" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSizes" runat="server" SelectCommand="SELECT DocNumber AS DocNumberX FROM Sales.SalesOrderDetail WHERE DocNumber IS NULL" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


