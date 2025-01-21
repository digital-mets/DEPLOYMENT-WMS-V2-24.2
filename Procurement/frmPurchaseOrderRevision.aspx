<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmPurchaseOrderRevision.aspx.cs" Inherits="GWL.frmPurchaseOrderRevision" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <script src="../js/Procurement/PORevision.js" type="text/javascript"></script>
    <title>Purchase Order Revision</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>

     <!--#region Region Javascript-->


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
        .dxeTextBoxSys input{
            text-transform:uppercase;
        }
        .pnl-content
        {
            text-align: right;
        }
    </style>
   <script>
    </script>
    <!--#endregion-->
</head>
<body style="height: 910px" onload="onload()">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
            <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Purchase Order Revision" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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
        <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
            EnableViewState="False" HeaderText="Notes" Height="370px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="471"
            ShowCloseButton="False" Collapsed="true" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" />
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
            <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents CloseUp="function (s, e) { cp.PerformCallback('RefGrid') }" />
    </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="1050px" Width="850px" style="margin-left: -3px">
                       <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>

                          <%--<!--#region Region Header --> --%>
                            <%-- <!--#endregion --> --%>
                            
                          <%--<!--#region Region Details --> --%>
                            
                            <%-- <!--#endregion --> --%>
                            <dx:TabbedLayoutGroup>
                                <SettingsTabPages EnableClientSideAPI="True">
                                </SettingsTabPages>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2" Width="850px">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDoc" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="txtDocnumber">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date:" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDate" runat="server" Width="170px" OnLoad="Date_Load" OnInit="dtpDate_Init">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="PO DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvPODoc" runat="server" Width="170px" AutoGenerateColumns="False" DataSourceID="PODoc" OnLoad="LookupLoad" TextFormatString="{0}"  KeyFieldName="DocNumber">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>

                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                               <Settings AutoFilterCondition="Contains" />
                                                                     </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                               <Settings AutoFilterCondition="Contains" />
                                                                     </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="DocDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" PropertiesTextEdit-DisplayFormatString="d">
                                                               <Settings AutoFilterCondition="Contains" />
                                                                     </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Status" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                               <Settings AutoFilterCondition="Contains" />
                                                                     </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Remarks" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                               <Settings AutoFilterCondition="Contains" />
                                                                     </dx:GridViewDataTextColumn>
                                                            </Columns>

                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('PO'); 
                                                                } "/>
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                       <dx:LayoutItem Caption="Target Delivery Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpTarget" runat="server" OnInit="dtpTarget_Init" OnLoad="Date_Load" Width="170px">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Broker">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtBroker" runat="server" Width="170px" ReadOnly="True"  ClientInstanceName="txtBroker" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Old Supplier Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtOldSupplierCode" runat="server" Width="170px" ReadOnly="True"  ClientInstanceName="txtOldSupplierCode" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Supplier Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glSupplierCode" runat="server" ClientInstanceName="glSupplierCode" DataSourceID="sdsSupplier" KeyFieldName="SupplierCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                <Settings AutoFilterCondition="Contains" />
                                                                     </dx:GridViewDataTextColumn>
                                                            </Columns>

                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Commitment Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpComm" runat="server" Width="170px" OnInit="dtpComm_Init" OnLoad="Date_Load">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                       
                                            <dx:LayoutItem Caption="Total Qty">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtQty" runat="server" Width="170px" ReadOnly="True"  ClientInstanceName="txtQty" DisplayFormatString="{0:#,#.0000}" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Cancellation Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpCancel" runat="server" Width="170px" OnInit="dtpCancel_Init" OnLoad="Date_Load">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                           <%-- <dx:LayoutItem Caption="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRemarks" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                                 <dx:LayoutItem Caption="Remarks">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxMemo ID="txtRemarks" runat="server" Width="170px" Height="50" OnLoad="memoremarks_Load">
                                                    </dx:ASPxMemo>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                              <dx:LayoutItem Caption="Reference:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPQ" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="" ClientVisible="False" Name="Genereatebtn">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxButton ID="Generatebtn" runat="server" AutoPostBack="False" CausesValidation="False" Text="Generate" UseSubmitBehavior="False">
                                                            <ClientSideEvents Click="Generate" />
                                                        </dx:ASPxButton>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                     <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                          <dx:LayoutItem Caption="Field 1:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server"  OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Field 2:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server"   OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Field 6:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server"  OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                               <dx:LayoutItem Caption="Field 7:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>   
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
 
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Audit Trail" ColCount="2" ColSpan="2">
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
                                            <dx:LayoutItem Caption="Cancelled By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px" ReadOnly="true">
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
                                                      <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="1250px"  KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Settings-ShowStatusBar="Hidden">

<Settings ShowStatusBar="Hidden"></Settings>

                                                        <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="NextColumn" />
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                        <SettingsPager PageSize="5">
                                                        </SettingsPager>
                                                        <SettingsEditing Mode="Batch">
                                                        </SettingsEditing>
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
                                             <%--   </Items>
                                            </dx:LayoutGroup>--%>
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>
                            <dx:LayoutGroup Caption="Purchase Order Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="747px" 
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                                                    OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber">
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager PageSize="5"/> 
                                                            <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130" ShowFooter="True"  /> 
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" Width="0px"
                                                            VisibleIndex="1">
                                                        </dx:GridViewDataTextColumn> 
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="true" Width="100px" VisibleIndex="3" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn> 
                                                        <dx:GridViewDataTextColumn FieldName="PRNumber" Visible="true" Width="100px" VisibleIndex="3" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn> 
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="4" Width="100px" Name="glItemCode" ReadOnly="True">
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ItemDescription" Visible="true" Width="150px" VisibleIndex="4" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="5" Width="80px" Caption="Color" ReadOnly="True">   
                                                                                                                        <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    KeyFieldName="ColorCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="80px" OnInit="lookup_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="6" Width="80px" Name="glClassCode" Caption="Class" ReadOnly="True">
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                KeyFieldName="ClassCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="80px" >
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
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="7" Width="80px" Name ="glSizeCode" Caption="Size" ReadOnly="True">
 <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                KeyFieldName="SizeCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="80px" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                        DropDown="function dropdown(s, e){
                                                                        gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                          
                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Unit" ShowInCustomizationForm="True" VisibleIndex="11"  UnboundType="Decimal" FieldName="Unit"> 
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="StatusCode" ShowInCustomizationForm="True" VisibleIndex="17" UnboundType="String" ReadOnly="true" FieldName="StatusCode">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image"  ShowInCustomizationForm="True"  VisibleIndex="0" Width="60px">
                                                                                                               <CustomButtons>
                                                            <dx:GridViewCommandColumnCustomButton ID="Details">
                                                               <Image IconID="support_info_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                       
                                                        </CustomButtons>
                                                            
                                                             </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn Caption="DocNumber" Name="IncomingDocNumber" ShowInCustomizationForm="True" VisibleIndex="2" FieldName="IncomingDocNumber" UnboundType="String" Visible="False" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="OldUnitCost" ShowInCustomizationForm="True" VisibleIndex="8" UnboundType="String" FieldName="OldUnitCost" PropertiesTextEdit-DisplayFormatString="{0:N}">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="18" FieldName="Field1" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="19" FieldName="Field2" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="20" FieldName="Field3" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="21" FieldName="Field4" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="22" FieldName="Field5" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="23" FieldName="Field6" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="24" FieldName="Field7" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="25" FieldName="Field8" UnboundType="String" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="26" FieldName="Field9" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn Caption="BaseQty" ShowInCustomizationForm="True" VisibleIndex="14" FieldName="BaseQty" PropertiesTextEdit-DisplayFormatString="{0:#,#.0000}">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataCheckColumn Caption="VATable" ShowInCustomizationForm="True" VisibleIndex="16" FieldName="IsVAT" ReadOnly="true">
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataTextColumn Caption="VATCode" ShowInCustomizationForm="True" VisibleIndex="17" FieldName="VATCode" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        
                                                        <dx:GridViewDataSpinEditColumn Caption="OldOrderQty" FieldName="OldOrderQty" ShowInCustomizationForm="True" ReadOnly="true" VisibleIndex="10" Width="90px" >
                                                            <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:#,#.0000}" MaxValue="9999999999" AllowMouseWheel="false" > 
                                                                <SpinButtons ShowIncrementButtons ="false" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="NewOrderQty" FieldName="OrderQty" ShowInCustomizationForm="True" VisibleIndex="10" Width="90px"  UnboundType="Decimal">
                                                            <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:#,#.0000}" MaxValue="9999999999" AllowMouseWheel="false" >
                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                <SpinButtons ShowIncrementButtons ="false" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="UnitCost" FieldName="UnitCost" ShowInCustomizationForm="True" Width="0" UnboundType="String" VisibleIndex="13">
                                                            <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}" MaxValue="9999999999" AllowMouseWheel="false" >
                                                                <SpinButtons ShowIncrementButtons ="false" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>

<%--                                                        <dx:GridViewDataSpinEditColumn Caption="AverageCost" FieldName="AverageCost" ShowInCustomizationForm="True" VisibleIndex="15">
                                                            <PropertiesSpinEdit Increment="0" DisplayFormatString="g" MinValue="0" MaxValue="9999999999">
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>--%>
                                                        <dx:GridViewDataSpinEditColumn Caption="NewUnitCost" FieldName="NewUnitCost" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="9" Width="80px">
                                                            <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}" MaxValue="9999999999" AllowMouseWheel="false">
                                                            <SpinButtons ShowIncrementButtons ="false" />
                                                            </PropertiesSpinEdit>
                                                            
                                                        </dx:GridViewDataSpinEditColumn>

                                                    </Columns>
                                                    <TotalSummary>
                                                        <dx:ASPxSummaryItem FieldName="InputBaseQty" SummaryType="Sum" ShowInColumn="InputBaseQty" ShowInGroupFooterColumn="InputBaseQty" />
                                                        <dx:ASPxSummaryItem FieldName="BulkQty" ShowInColumn="Bulk" ShowInGroupFooterColumn="Bulk" SummaryType="Sum" />
                                                    </TotalSummary>
                                                    <GroupSummary>
                                                        <dx:ASPxSummaryItem ShowInColumn="InputBaseQty" SummaryType="Sum" />
                                                        <dx:ASPxSummaryItem ShowInColumn="BulkQty" SummaryType="Sum" />
                                                    </GroupSummary>
                                                    <SettingsPager Mode="ShowAllRecords" />
                                                        <SettingsEditing Mode="Batch" />
                                                        <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300" ShowFooter="True" />
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>

                            
                            <dx:LayoutGroup Caption="Purchase Order Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gvService" runat="server" AutoGenerateColumns="False" Width="747px" 
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gvService" 
                                                    OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber">
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager PageSize="5"/><SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130" ShowFooter="True"  /> 
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="60px" ShowDeleteButton="false">
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" Width="0px" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="true" Width="100px" VisibleIndex="1" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="PRNumber" Visible="true" Width="100px" VisibleIndex="1" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn> 
                                                        <dx:GridViewDataTextColumn Caption="Service" FieldName="Service" VisibleIndex="2" Width="140px" Name="glItemCode" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn> 
                                                        <dx:GridViewDataTextColumn FieldName="Description" Width="180px" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="true" PropertiesTextEdit-Height="50px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="OldServiceQty" VisibleIndex="4" Width="100px" ReadOnly="true" >
                                                        <PropertiesSpinEdit Increment="0" ClientInstanceName="OldServiceQty" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:#,#.0000}">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="NewServiceQty" VisibleIndex="4" Width="100px" UnboundType="Decimal">
                                                        <PropertiesSpinEdit Increment="0" ClientInstanceName="NewServiceQty" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:#,#.0000}">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents LostFocus="calccost" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Unit" VisibleIndex="5" Width="100px" Caption="Unit">   
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="OldUnitCost" ShowInCustomizationForm="True" VisibleIndex="6" Width="80px">
                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="OldUnitCost" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" >
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="NewUnitCost" ShowInCustomizationForm="True" VisibleIndex="6" Width="80px" UnboundType="Decimal">
                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="NewUnitCost" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00" >
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents LostFocus="calccost" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="OldTotalCost" ShowInCustomizationForm="True" VisibleIndex="7" Width="80px" ReadOnly="true">
                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" Increment="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="NewTotalCost" ShowInCustomizationForm="True" VisibleIndex="7" Width="80px" ReadOnly="true">
                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" Increment="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="AllowProgressBilling" Caption="Progress Billing"  ShowInCustomizationForm="True" VisibleIndex="8" ReadOnly="true">  
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="VatLiable" Caption="VATable" Name="glpIsVat" ShowInCustomizationForm="True" VisibleIndex="9" ReadOnly="true">
                                                            </dx:GridViewDataCheckColumn>
                                                            <dx:GridViewDataTextColumn FieldName="VatCode" VisibleIndex="10" Width="80px" Caption="VATCode">    
                                                            </dx:GridViewDataTextColumn> 
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
                                                    <SettingsPager Mode="ShowAllRecords" />
                                                        <SettingsEditing Mode="Batch" />
                                                        <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300" ShowFooter="True" />
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>


                            <%--<dx:LayoutGroup Caption="Purchase Order Service Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gvService" runat="server" AutoGenerateColumns="False" Width="770px"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gvService"
                                                    OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber" SettingsBehavior-AllowSort="False">
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                        />
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" BatchEditStartEditing="OnStartEditing"  />
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
                                                                        
                                                    </SettingsCommandButton>
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px" ShowDeleteButton="false">
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="true" Width="100px" VisibleIndex="1" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Service" FieldName="Service" VisibleIndex="2" Width="140px" Name="glItemCode" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn> 
                                                        <dx:GridViewDataTextColumn FieldName="Description" Width="180px" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="true" PropertiesTextEdit-Height="50px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="OldServiceQty" VisibleIndex="4" Width="100px" >
                                                        <PropertiesSpinEdit Increment="0" ClientInstanceName="OldServiceQty" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="NewServiceQty" VisibleIndex="4" Width="100px" >
                                                        <PropertiesSpinEdit Increment="0" ClientInstanceName="NewServiceQty" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents LostFocus="calccost" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Unit" VisibleIndex="5" Width="100px" Caption="Unit">   
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="OldUnitCost" ShowInCustomizationForm="True" VisibleIndex="6" Width="80px">
                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="OldUnitCost" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" >
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="NewUnitCost" ShowInCustomizationForm="True" VisibleIndex="6" Width="80px">
                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="NewUnitCost" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" >
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents LostFocus="calccost" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="OldTotalCost" ShowInCustomizationForm="True" VisibleIndex="7" Width="80px" ReadOnly="true">
                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" Increment="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="NewTotalCost" ShowInCustomizationForm="True" VisibleIndex="7" Width="80px" ReadOnly="true">
                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}" Increment="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="AllowProgressBilling" Caption="Progress Billing"  ShowInCustomizationForm="True" VisibleIndex="8" ReadOnly="true">  
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="VatLiable" Caption="VATable" Name="glpIsVat" ShowInCustomizationForm="True" VisibleIndex="9" ReadOnly="true">
                                                            </dx:GridViewDataCheckColumn>
                                                            <dx:GridViewDataTextColumn FieldName="VatCode" VisibleIndex="10" Width="80px" Caption="VATCode">    
                                                            </dx:GridViewDataTextColumn> 
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
                                            ClientInstanceName="gvPRDetails" OnCustomCallback="gvPRDetails_CustomCallback" KeyFieldName="DocNumber;LineNumber;Service;Description;OldServiceQty;NewServiceQty;Unit;OldUnitCost;NewUnitCost;OldTotalCost;NewTotalCost;AllowProgressBilling;VatLiable;VatCode;Field1;Field2;Field3;Field4;Field5;Field6;Field7;Field8;Field9">                             
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
                            </dx:LayoutGroup>--%>
                        </Items>
                    </dx:ASPxFormLayout>
      


                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
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
                         <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" AutoPostBack="False" UseSubmitBehavior="false">
                             <ClientSideEvents Click="function (s, e){  cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                             </dx:ASPxButton>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel">
                             <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                             </dx:ASPxButton> 
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.PurchaseOrderRevision" DataObjectTypeName="Entity.PurchaseOrderRevision" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.PurchaseOrderRevision+PurchaseOrderRevisionDetail" DataObjectTypeName="Entity.PurchaseOrderRevision+PurchaseOrderRevisionDetail" DeleteMethod="DeletePurchaseOrderRevisionDetail" InsertMethod="AddPurchaseOrderRevisionDetail" UpdateMethod="UpdatePurchaseOrderRevisionDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail2" runat="server" SelectMethod="getdetail" TypeName="Entity.PurchaseOrderRevision+PurchaseOrderRevisionService" DataObjectTypeName="Entity.PurchaseOrderRevision+PurchaseOrderRevisionService" DeleteMethod="DeletePurchasedOrderService" InsertMethod="AddPurchasedOrderService" UpdateMethod="UpdatePurchasedOrderService">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.PurchaseOrderRevision+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT *, '' AS ItemDescription FROM  Procurement.PurchaseOrderRevisionDetail where DocNumber  is null " OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Procurement.PurchaseOrderRevisionService where DocNumber  is null " OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] where isnull(IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [ColorCode], [ClassCode],[SizeCode] FROM Masterfile.[ItemDetail] where isnull(IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="PODoc" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select A.DocNumber, A.SupplierCode, A.DocDate, Status, A.Remarks 
from Procurement.PurchaseOrder A with (nolock) 
where isnull(A.SubmittedBy,'') !='' AND Status = 'N' 
AND (A.DocNumber NOT IN (select DISTINCT B.PODocNumber from Procurement.ReceivingReport A
     inner join Procurement.ReceivingReportDetailPO B
     ON A.DocNumber = B.DocNumber
	 WHERE ISNULL(SubmittedBy,'') = '' 
	 AND ISNULL(ReferenceNumber,'') != ''
	 AND ISNULL(B.PODocNumber,'') != ''))" OnInit = "Connection_Init"></asp:SqlDataSource>
  <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BizPartner WHERE (ISNULL(IsInactive, 0) = 0)" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebizcustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,0)=0 and IsCustomer='1'" OnInit = "Connection_Init"></asp:SqlDataSource>
      <asp:SqlDataSource ID="sdsPODetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select * from procurement.purchaseorderrevisiondetail where docnumber is null" OnInit = "Connection_Init"></asp:SqlDataSource>
          <asp:SqlDataSource ID="sdsPOServDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select * from procurement.purchaseorderrevisionservice where docnumber is null" OnInit = "Connection_Init"></asp:SqlDataSource>
          <asp:SqlDataSource ID="sdsSupplier" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select SupplierCode,Name from Masterfile.BPSupplierInfo where ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>

     <!--#endregion-->
</body>
</html>


