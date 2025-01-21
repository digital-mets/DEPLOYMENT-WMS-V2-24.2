<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmBOMRevision.aspx.cs" Inherits="GWL.frmBOMRevision" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>BOM Revision</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
     <script src="../js/Production/BOMRevision.js" type="text/javascript"></script>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
        height: 680px; /*Change this whenever needed*/
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
<body style="height: 910px;">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
<form id="form1" runat="server" class="Entry">
    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel ID="HeaderText" runat="server" Text="BOM Revision" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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
    <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents CloseUp="function (s, e) { cp.PerformCallback('RefGrid') }" />
    </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="Information">
                                                <Items>
                                                    <dx:LayoutItem Caption="Document Number" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" AutoCompleteType="Disabled" Enabled="False" ReadOnly ="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" Width="170px">
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
                                                    <dx:LayoutItem Caption="Type" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglType" runat="server" DataSourceID="sdsType" AutoGenerateColumns="False" KeyFieldName="Code" 
                                                                    TextFormatString="{1}" Width="170px" ClientInstanceName ="aglType">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0" Caption ="Code">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Caption ="Description" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged ="function (s,e) { cp.PerformCallback('CallbackType'); }"/>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Reference JO" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglReferenceJO" runat="server" DataSourceID="sdsReferenceJO" AutoGenerateColumns="False" KeyFieldName="DocNumber" 
                                                                    TextFormatString="{0}" Width="170px" ClientInstanceName="aglReferenceJO" OnInit="aglReferenceJO_Init" AutoPostBack="false"
                                                                    ClientSideEvents-KeyPress="gridLookup_KeyPress">
                                                                    <ClientSideEvents DropDown="function(){aglReferenceJO.GetGridView().PerformCallback();}" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0" Caption ="Document Number">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="DocDate" ShowInCustomizationForm="True" VisibleIndex="1" Width="100px" ReadOnly ="true">
                                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                            <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="DueDate" ShowInCustomizationForm="True" VisibleIndex="2" Width="100px" ReadOnly ="true">
                                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                            <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LeadTime" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3" Caption ="Cost Center">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CustomerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4" Caption ="Cost Center">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TotalJOQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TotalINQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TotalFinalQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Remarks" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                   <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){ cp.PerformCallback('CallbackReferenceJO');}" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" Width="170px">
                                                                </dx:ASPxMemo>
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
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" >
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
                                            <dx:LayoutItem Caption="Approved By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHApprovedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Approved Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHApprovedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px" ReadOnly="True">
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
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Width="860px" ClientInstanceName="gvRef" OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  Init="OnInitTrans" />
                                                                    
                                                            <SettingsPager PageSize="5">
                                                            </SettingsPager>
                                                            <SettingsEditing Mode="Batch">
                                                            </SettingsEditing>
                                                            <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5">
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
                                                                <dx:GridViewDataTextColumn Caption="Reference DocNumber" FieldName="REFDocNumber" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4">
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
                            </dx:TabbedLayoutGroup>
                            <dx:LayoutGroup Caption="BOM Revision Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False"  Width="850px" 
                                                    ClientInstanceName="gv1" OnBatchUpdate="gv1_BatchUpdate"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    OnInitNewRow="gv1_InitNewRow">
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" 
                                                        CustomButtonClick="OnCustomClick" BatchEditRowValidating="Grid_BatchEditRowValidating"/>
                                                    <SettingsPager Mode="ShowAllRecords" />  
                                                     <SettingsEditing Mode="Batch"/>
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
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
                                                    <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="90px">
                                                            <CustomButtons>
                                                            <dx:GridViewCommandColumnCustomButton ID="Details" >
                                                                <Image IconID="support_info_16x16" ToolTip="Details"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                <Image IconID="actions_cancel_16x16"> </Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="80px" ReadOnly="true">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="StepCode" FieldName="StepCode" Name="glStepCode" ShowInCustomizationForm="True" VisibleIndex="3" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glStepCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glStepCode" OnInit="glStepcode_Init"
                                                                        DataSourceID="sdsSteps" KeyFieldName="StepCode" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="StepCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        ValueChanged="resetbomdetail"/>                                                                             
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="OldItemCode" VisibleIndex="4" Name="glpItemCode" Width="100px">                                                            
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" OnInit="itemcode_Init"
                                                                    DataSourceID="sdsOldItem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="100px"
                                                                   GridViewProperties-SettingsBehavior-EnableRowHotTrack="true">
                                                                   <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" > 
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True"/>
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd"
                                                                        KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  
                                                                        RowClick="function(){
                                                                            loader.Show();
                                                                            loader.SetText('Loading...');
                                                                            loading = true;
                                                                        }"
                                                                        DropDown="function(s,e){
                                                                        if(nope==false){
                                                                            nope = true;
                                                                            //loader.Show();
                                                                            //loader.SetText('Loading...');
                                                                            //loading = true;
                                                                            console.log(itemc + ' | ' + gl.GetValue());
                                                                            gl.GetGridView().PerformCallback(itemstep + '|' + itemc + '|' + gl.GetValue()); 
                                                                            e.processOnServer = false;
                                                                            }
                                                                        }"
                                                                         />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="OldColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="5" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" 
                                                                    DataSourceID="sdsOldColor" KeyFieldName="ColorCode" OnInit="lookup_Init" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" Width="100px">
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" Width="400px">
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd"
                                                                        KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        RowClick="function(){
                                                                            //loader.Show();
                                                                            //loader.SetText('Loading...');
                                                                            //loading = true;
                                                                        }"
                                                                        GotFocus="function(s,e){
                                                                        if(nope==false){
                                                                        nope = true;
                                                                        //loader.Show();
                                                                        //loader.SetText('Loading...');
                                                                        //loading = true;
                                                                        gl2.GetGridView().PerformCallback('OldColorCode' + '|' + itemc + '|' + s.GetInputElement().value + '|' + 'code' + '|' + 'code' + '|' + 'code' + '|' + 'code'+ '|' + itemstep);
                                                                        
                                                                        }
                                                                        }"
                                                                        ValueChanged="function(s,e){
                                                                        if(itemclr!=gl2.GetValue()&&gl2.GetValue()!=null){
                                                                            gl2.GetGridView().PerformCallback('Product' + '|' + itemc + '|' + 'code' + '|' + gl2.GetValue() + '|' + itemcls + '|' + itemsze + '|' + 'item' + '|' + itemstep+ '|' + pcode + '|' + pcolor + '|' + psize);
                                                                            valchange2 = true;    
                                                                        }
                                                                        }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="OldClassCode" Name="ClassCode" ShowInCustomizationForm="True" VisibleIndex="6" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl3" 
                                                                    DataSourceID="sdsOldClass" KeyFieldName="ClassCode" OnInit="lookup_Init" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" Width="100px">
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" Width="400px">
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd"
                                                                        KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        RowClick="function(){
                                                                            //loader.Show();
                                                                            //loader.SetText('Loading...');
                                                                            //loading = true;
                                                                        }"
                                                                        GotFocus="function(s,e){
                                                                        if(nope==false){
                                                                        nope = true;
                                                                        //loader.Show();
                                                                        //loader.SetText('Loading...');
                                                                        //loading = true;
                                                                        gl3.GetGridView().PerformCallback('OldClassCode' + '|' + itemc + '|' + s.GetInputElement().value + '|' + 'code' + '|' + 'code' + '|' + 'code' + '|' + 'code' + '|' + itemstep);
                                                                        valchange2 = true;
                                                                        }
                                                                        }"
                                                                        ValueChanged="function(s,e){
                                                                        if(itemcls!=gl3.GetValue()&&gl3.GetValue()!=null){
                                                                            gl3.GetGridView().PerformCallback('Product' + '|' + itemc + '|' + 'code' + '|' + itemclr + '|' + gl3.GetValue() + '|' + itemsze + '|' + 'item' + '|' + itemstep+ '|' + pcode + '|' + pcolor + '|' + psize);
                                                                            valchange2 = true;    
                                                                        }
                                                                        }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="OldSizeCode" Name="SizeCode" ShowInCustomizationForm="True" VisibleIndex="7" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl4"
                                                                     DataSourceID="sdsOldSize" KeyFieldName="SizeCode" OnInit="lookup_Init" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" Width="100px">
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" Width="400px">
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd"
                                                                        KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        RowClick="function(){
                                                                            //loader.Show();
                                                                            //loader.SetText('Loading...');
                                                                            //loading = true;
                                                                        }"
                                                                        GotFocus="function(s,e){
                                                                        if(nope==false){
                                                                        nope = true;
                                                                        //loader.Show();
                                                                        //loader.SetText('Loading...');
                                                                        //loading = true;
                                                                        gl4.GetGridView().PerformCallback('OldSizeCode' + '|' + itemc + '|' + s.GetInputElement().value + '|' + 'code' + '|' + 'code' + '|' + 'code' + '|' + 'code' + '|' + itemstep);
                                                                        valchange2 = true;
                                                                        }
                                                                        }"
                                                                        ValueChanged="function(s,e){
                                                                        if(itemsze!=gl4.GetValue()&&gl4.GetValue()!=null){
                                                                            gl4.GetGridView().PerformCallback('Product' + '|' + itemc + '|' + 'code' + '|' + itemclr + '|' + itemcls + '|' + gl4.GetValue() + '|' + 'item' + '|' + itemstep+ '|' + pcode + '|' + pcolor + '|' + psize);
                                                                            valchange2 = true;    
                                                                        }
                                                                        }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="ProductCode" FieldName="ProductCode" Name="glProductCode" ShowInCustomizationForm="True" VisibleIndex="8" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glProductCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glProductCode" OnInit="glProductCode_Init"
                                                                        DataSourceID="sdsProductCode" KeyFieldName="ProductCode" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ProductCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" CloseUp="gridLookup_CloseUp" 
                                                                        DropDown="function(s,e){glProductCode.GetGridView().PerformCallback(itemstep + '|' + itemc + '|' + s.GetInputElement().value);
                                                                                                
                                                                        }"/>                                                                             
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Product Color" FieldName="ProductColor" Name="glProductColor" ShowInCustomizationForm="True" VisibleIndex="9" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glProductColor" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glProductColor" OnInit="glProductColor_Init"
                                                                        DataSourceID="sdsProductColor" KeyFieldName="ProductColor" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ProductColor" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" CloseUp="gridLookup_CloseUp" 
                                                                        DropDown="function(s,e){//glProductColor.GetGridView().PerformCallback(itemstep + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        glProductColor.GetGridView().PerformCallback(itemstep + '|' + itemc + '|' + s.GetInputElement().value + '|' + itemclr + '|' + itemcls + '|' + itemsze + '|' + pcode + '|' + pcolor);
                                                                        }"/>                                                                             
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Product Size" FieldName="ProductSize" Name="glProductSize" ShowInCustomizationForm="True" VisibleIndex="10" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glProductSize" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glProductSize" OnInit="glProductSize_Init"
                                                                        DataSourceID="sdsProductSize" KeyFieldName="ProductSize" TextFormatString="{0}" Width="100px" IncrementalFilteringDelay="0" IncrementalFilteringMode="Contains">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ProductSize" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function(s,e){glProductSize.GetGridView().PerformCallback(itemstep + '|' + itemc + '|' + s.GetInputElement().value + '|' + itemclr + '|' + itemcls + '|' + itemsze + '|' + pcode + '|' + pcolor);}"
                                                                        ValueChanged="function(s,e){
                                                                        if(aglType.GetValue() != 'ADD ITEM'){
                                                                        if(psize!=glProductSize.GetValue()&&glProductSize.GetValue()!=null){
                                                                            gl4.GetGridView().PerformCallback('Product' + '|' + itemc + '|' + 'code' + '|' + itemclr + '|' + itemcls + '|' + itemsze + '|' + 'item' + '|' + itemstep + '|' + pcode + '|' + pcolor + '|' + glProductSize.GetValue());
                                                                            valchange2 = true;    
                                                                        }
                                                                        }
                                                                        else{
                                                                        gv1.batchEditApi.EndEdit();
                                                                        return;
                                                                        }
                                                                        }"/>                                                                             
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="NewItemCode" VisibleIndex="11" Name="glpNewItemCode" Width="100px">                                                            
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glNewItemCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" OnInit="glNewItemCode_Init"  
                                                                    DataSourceID="sdsItem" KeyFieldName="ItemCode" ClientInstanceName="glN" TextFormatString="{0}" Width="100px">
                                                                   <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto"> 
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True"/>
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0"  Settings-AutoFilterCondition="Contains">
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1"  Settings-AutoFilterCondition="Contains">
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd"
                                                                        KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  
                                                                        DropDown="lookup"
                                                                         />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="NewColorCode" Name="NewColorCode" ShowInCustomizationForm="True" VisibleIndex="12" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glNewColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2N" 
                                                                    DataSourceID="sdsColor" KeyFieldName="ColorCode" OnInit="lookup_Init" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd" CloseUp="gridLookup_CloseUp" 
                                                                        KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        DropDown="function(s,e){
                                                                        if(nope==false){
                                                                        nope = true;
                                                                        //loader.Show();
                                                                        //loader.SetText('Loading...');
                                                                        loading = true;
                                                                        gl2N.GetGridView().PerformCallback('NewColorCode' + '|' + itemcN + '|' + s.GetInputElement().value + '|' + 'code' + '|' + 'code' + '|' + 'code' + '|' + 'code' + '|' + 'code');
                                                                        }
                                                                        }"
                                                                                                                                            
                                                                        />                                                                        
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="NewClassCode" Name="NewClassCode" ShowInCustomizationForm="True" VisibleIndex="13" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glNewClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl3N" 
                                                                    DataSourceID="sdsClass" KeyFieldName="ClassCode" OnInit="lookup_Init" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0"  Settings-AutoFilterCondition="Contains">
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd" CloseUp="gridLookup_CloseUp" 
                                                                        KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        DropDown="function(s,e){
                                                                        if(nope==false){
                                                                        nope = true;
                                                                        //loader.Show();
                                                                        //loader.SetText('Loading...');
                                                                        loading = true;
                                                                        gl3N.GetGridView().PerformCallback('NewClassCode' + '|' + itemcN + '|' + s.GetInputElement().value + '|' + 'code' + '|' + 'code' + '|' + 'code' + '|' + 'code' + '|' + 'code');
                                                                        valchange3 = true;
                                                                        }
                                                                        }"
                                                                        
                                                                        />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="NewSizeCode" Name="NewSizeCode" ShowInCustomizationForm="True" VisibleIndex="14" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glNewSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl4N"
                                                                     DataSourceID="sdsSize" KeyFieldName="SizeCode" OnInit="lookup_Init" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd" CloseUp="gridLookup_CloseUp" 
                                                                        KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        DropDown="function(s,e){
                                                                        if(nope==false){
                                                                        nope = true;
                                                                        //loader.Show();
                                                                        //loader.SetText('Loading...');
                                                                        loading = true;
                                                                        gl4N.GetGridView().PerformCallback('NewSizeCode' + '|' + itemcN + '|' + s.GetInputElement().value + '|' + 'code' + '|' + 'code' + '|' + 'code' + '|' + 'code' + '|' + 'code');
                                                                        valchange3 = true;
                                                                        }
                                                                        }"
                                                                       
                                                                        />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit" ShowInCustomizationForm="True" VisibleIndex="15" Width="100px" Name ="Unit">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl5" DataSourceID="sdsUnit" KeyFieldName="Unit" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Unit" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp"  KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Components" FieldName="Components" Name="Components" ShowInCustomizationForm="True" VisibleIndex="16" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glComponents" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glComponents"
                                                                     DataSourceID="sdsComponents" KeyFieldName="Components" TextFormatString="{0}" Width="100px" OnInit="glComponents_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Components" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents  ValueChanged="gridLookup_CloseUp"  KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" 
                                                                         DropDown="function(s,e){
                                                                            glComponents.GetGridView().PerformCallback(itemstep + '|' + itemc + '|' + s.GetInputElement().value + '|' + itemclr + '|' + itemcls + '|' + itemsze + '|' + pcode );
                                                                         }"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="PerPieceConsumption" Name="glpPerPieceConsumption" ShowInCustomizationForm="True" VisibleIndex="17" Caption="Per Piece Consumption" Width="140px">
                                                            <PropertiesSpinEdit NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"  DisplayFormatString="{0:N6}" DecimalPlaces="6"
                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="function(s, e){ gv1.batchEditApi.EndEdit();
                                                                    //if(aglType.GetValue() != 'ADD ITEM')
                                                                    callbacker.PerformCallback(gv1.batchEditApi.GetCellValue(BOMIndex, 'ProductSize')+'|'+aglReferenceJO.GetValue()); }"/>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Consumption" Name="glpConsumption" ShowInCustomizationForm="True" VisibleIndex="18" Caption="Consumption">
                                                            <PropertiesSpinEdit NullDisplayText="0.000000" NullText="0.000000"  DisplayFormatString="{0:N6}" DecimalPlaces="6"
                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="function(s, e){ gv1.batchEditApi.EndEdit(); autocalculate();}"/>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn> 
                                                        <dx:GridViewDataSpinEditColumn FieldName="AllowancePerc" Name="glpAllowancePerc" ShowInCustomizationForm="True" VisibleIndex="19" Caption="Allowance %"> 
                                                            <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" DecimalPlaces="2"
                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="function(s, e){ gv1.batchEditApi.EndEdit(); autocalculate();}"/>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="AllowanceQty" Name="glpAllowanceQty" ShowInCustomizationForm="True" VisibleIndex="20" Caption="Allowance Qty"> 
                                                            <PropertiesSpinEdit NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"  DisplayFormatString="{0:N6}" DecimalPlaces="6"
                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="function(s, e){ gv1.batchEditApi.EndEdit(); autocalculate_req();}"/>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="RequiredQty" Name="gRequiredQty" ShowInCustomizationForm="True" VisibleIndex="21" Caption="Required Qty" ReadOnly="true"> 
                                                            <PropertiesSpinEdit NullDisplayText="0.000000" ConvertEmptyStringToNull="False" NullText="0.000000"  DisplayFormatString="{0:N6}" DecimalPlaces="6"
                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsBulk" Name="glpIsBulk" ShowInCustomizationForm="True" VisibleIndex="22" Caption="Bulk" Width ="55px">
                                                            <PropertiesCheckEdit ClientInstanceName="glIsBulk" >
                                                            </PropertiesCheckEdit>              
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsMajorMaterial" Name="glpIsMajorMaterial" ShowInCustomizationForm="True" VisibleIndex="23" Caption="Major Material" Width="90px">
                                                            <PropertiesCheckEdit ClientInstanceName="glIsMajorMaterial" >
                                                                <ClientSideEvents CheckedChanged="function(){gv1.batchEditApi.EndEdit();}" />
                                                            </PropertiesCheckEdit>              
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsExcluded" Name="glpIsExcluded" ShowInCustomizationForm="True" VisibleIndex="24" Caption="Excluded" Width="90px">
                                                            <PropertiesCheckEdit ClientInstanceName="glIsExcluded" >
                                                                <ClientSideEvents CheckedChanged="function(){gv1.batchEditApi.EndEdit();}" />
                                                            </PropertiesCheckEdit>              
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsRounded" ShowInCustomizationForm="True" VisibleIndex="24" Caption="Rounded" Width="90px">
                                                            <PropertiesCheckEdit ClientInstanceName="glIsRounded" >
                                                                <ClientSideEvents CheckedChanged="
                                                                    function(){gv1.batchEditApi.EndEdit();
                                                                    if(gv1.batchEditApi.GetCellValue(index, 'IsRounded') == false){
                                                                    gv1.batchEditApi.SetCellValue(index, 'PerPieceConsumption', 0);
                                                                    gv1.batchEditApi.SetCellValue(index, 'Consumption', 0);
                                                                    gv1.batchEditApi.SetCellValue(index, 'AllowanceQty', 0);
                                                                    }
                                                                     autocalculate(); }" />
                                                            </PropertiesCheckEdit>              
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitCost" Name="glpUnitCost" ShowInCustomizationForm="True" VisibleIndex="25" Caption="Unit Cost"> 
                                                            <PropertiesSpinEdit NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"  DisplayFormatString="{0:N4}" DecimalPlaces="4"
                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue ="9999999999">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" VisibleIndex="29" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" VisibleIndex="30" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" VisibleIndex="32" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" VisibleIndex="33" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" VisibleIndex="34" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="35" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="36" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Version" Name="glpVersion" Caption="Version" ShowInCustomizationForm="True" VisibleIndex="37" Width="0px" >
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                </dx:ASPxGridView>
                                                <dx:ASPxCallback ID="callbacker" ClientInstanceName="callbacker" OnCallback="callbacker_Callback" runat="server">
                                                    <ClientSideEvents EndCallback="autocalculate3" />
                                                </dx:ASPxCallback>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
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
                    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Cloning..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="gv1">
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
                             </dx:ASPxButton>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel">
                             <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                             </dx:ASPxButton> 
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
</form>
<form id="form2" runat="server" visible="false">
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Production.BOMRevisionDetail WHERE DocNumber IS NULL"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsReferenceJO" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSteps" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" "></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Code, LTRIM(RTRIM(Description)) AS Description FROM IT.GenericLookup WHERE LookUpKey ='BOMREVTYP'"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsOldItem" runat="server" SelectCommand="" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsOldColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsOldClass" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsOldSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" "></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""></asp:SqlDataSource>
    <%--<asp:SqlDataSource ID="sdsColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ItemCode, [ColorCode], '' AS [ClassCode], '' AS [SizeCode] FROM Masterfile.ItemDetail WHERE ISNULL(IsInactive,0)=0 AND 1=0 "></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsClass" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ItemCode, '' AS [ColorCode], [ClassCode], '' AS [SizeCode] FROM Masterfile.ItemDetail WHERE ISNULL(IsInactive,0) = 0 AND 1=0 " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ItemCode, '' AS [ColorCode], '' AS [ClassCode], [SizeCode] FROM Masterfile.ItemDetail WHERE ISNULL(IsInactive,0) = 0 AND 1=0 " OnInit="Connection_Init"></asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="sdsColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsClass" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsProductCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsProductColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsProductSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsComponents" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ComponentCode AS Components, Description FROM Masterfile.Component WHERE ISNULL(IsInactive,0) = 0"></asp:SqlDataSource>
    <%--<asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [ColorCode], [ClassCode], [SizeCode] FROM Masterfile.[ItemDetail] WHERE ISNULL(IsInactive,0)=0"></asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UnitCode AS Unit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBulkUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UnitCode AS BulkUnit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
</form>
    <!--#region Region Datasource-->    
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.BOMRevision+BOMRevisionDetail" SelectMethod="getdetail" UpdateMethod="UpdateBOMRevisionDetail" TypeName="Entity.BOMRevision+BOMRevisionDetail" InsertMethod="AddBOMRevisionDetail" DeleteMethod="DeleteBOMRevisionDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.DIS+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            <asp:QueryStringParameter Name="TransType" QueryStringField="transtype" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <!--#endregion-->
</body>
</html>


