<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmRouting.aspx.cs" Inherits="GWL.frmRouting" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Production Routing</title>
    
    <link rel="stylesheet" href="../css/form.css" /><%--Link to global stylesheet--%>
    <link rel="stylesheet" href="../css/bootstrap.min.css" /><%--Link to global stylesheet--%>
    <link rel="Stylesheet" type="text/css" href="../css/bootstrap.min.css" /><%--Link to global stylesheet--%>
    <link rel="Stylesheet" type="text/css" href="~/css/fontawesome.min.css" /><%--Link to global stylesheet--%>
    <link rel="Stylesheet" type="text/css" href="~/css/select2.min.css" /><%--Link to global stylesheet--%>

    <script type='text/javascript' src="../js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../js/moment-with-locales.js"></script>
    <script type="text/javascript" src="../js/select2.min.js"></script>

    <script src="../js/Routing.js" type="text/javascript"></script> <%-- Production Routing JS --%>

    <style>
        .dxflCLLSys .dxflCaptionCell_MetropolisBlue {
            padding-right: 0px;
        }

        .dxeCalendarFastNavMonthArea_MetropolisBlue, .dxeCalendar_MetropolisBlue
        {
            display: block !important;
        }
    </style>
</head>
<body style="height: 910px;">

    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>

    <form id="form1" runat="server">

        <%-- Top Panel --%>
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Production Routing" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>

        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback" SettingsLoadingPanel-ImagePosition="Left" SettingsLoadingPanel-Enabled="False">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True"> 
                    <%-- Form Layout Start --%>
                    <dx:ASPxFormLayout ID="frmLayoutRouting" runat="server" Height="300px" Width="1280px" style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <%-- General Tab Start --%>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <%-- FG-SKU Code Field --%>
                                            <dx:LayoutGroup Caption="Info" ColCount="2">
                                                <Items>
                                                    <%-- SKU Code Field --%>
                                                    <dx:LayoutItem Caption="SKU Code" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxHiddenField runat="server" ID="hidcon"></dx:ASPxHiddenField>
                                                                <input type="hidden" runat="server" id="RecordID"/>
                                                                <dx:ASPxTextBox ID="SKUCode" runat="server"  Width="170px" AutoCompleteType="Disabled" ClientEnabled="False" ClientInstanceName="SKUCode">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Effectivity Date Field --%>
                                                    <dx:LayoutItem Caption="Effectivity Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="EffectivityDate" runat="server" Width="170px" ClientInstanceName="EffectivityDate" ReadOnly="true" ClientEnabled="false"></dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- SKU Description Field --%>
                                                    <dx:LayoutItem Caption="SKU Description">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="SKUDescription" runat="server" Width="170px" ClientEnabled="false" ClientInstanceName="SKUDescription" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Unit of Measure Field --%>
                                                    <dx:LayoutItem Caption="Unit of Measure">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="UnitMeasure" runat="server" Width="170px" ClientEnabled="false" ClientInstanceName="Unit" ReadOnly="true" />
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Customer Code Field --%>
                                                    <dx:LayoutItem Caption="Customer Code">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="CustomerCode" runat="server" DataSourceID="sdsCustomerCode" Width="170px" KeyFieldName="BizPartnerCode" 
                                                                        TextFormatString="{0}" AutoGenerateColumns="False" ClientInstanceName="CustomerCode">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" Caption="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" Caption="Name" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents ValueChanged="function(s,e){ 
                                                                        var g = CustomerCode.GetGridView();
                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'Name', UpdateCustomerName); 
                                                                    }"/>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="false" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Expected Output Qty Field --%>
                                                    <dx:LayoutItem Caption="Expected Output Qty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="ExpectedOutputQty" ClientInstanceName="ExpectedOutputQty" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="False" DisplayFormatString="G">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents LostFocus="calculatehead"/>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Customer Name Field --%>
                                                    <dx:LayoutItem Caption="Customer Name">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="CustomerName" runat="server"  Width="170px" AutoCompleteType="Disabled" ClientEnabled="False" ClientInstanceName="CustomerName" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Status Field --%>
                                                    <dx:LayoutItem Caption="Status">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="Status" runat="server" Width="170px" ClientEnabled="false" ClientInstanceName="Status" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%-- Remarks --%>
                                                    <dx:LayoutItem Caption="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="Remarks" runat="server" Height="71px" Width="170px">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <%-- Processing Steps Field --%>
                                            <dx:LayoutGroup Caption="NRTE">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <div class="container-fluid" id="StepProcessTable">
                                                                    <dx:ASPxGridView DataSourceID="sdsStepProcess" ID="gvStepProcess" ClientInstanceName="gvStepProcess" runat="server" 
                                                                        AutoGenerateColumns="False" KeyFieldName="StepSequence" Width="100%" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize" OnRowValidating="grid_RowValidating" 
                                                                        OnBeforePerformDataSelect="masterGrid_BeforePerformDataSelect" OnRowInserting="gvStepProcess_RowInserting" OnRowUpdating="gvStepProcess_RowUpdating" 
                                                                        OnRowDeleting="gvStepProcess_RowDeleting">

                                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick" EndCallback="OnEndCallback" BatchEditRowValidating="OnBatchEditRowValidating"/>

                                                                        <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 

                                                                        <SettingsPager Mode="ShowAllRecords"></SettingsPager>

                                                                        <SettingsEditing Mode="Batch"></SettingsEditing>

                                                                        <SettingsBehavior AllowSort="False" ConfirmDelete="true"/>

                                                                        <SettingsDetail ShowDetailRow="true" ShowDetailButtons="true" AllowOnlyOneMasterRowExpanded="true" />

                                                                        <SettingsCommandButton>
                                                                            <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                            <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                            <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                        </SettingsCommandButton>

                                                                        <Styles><StatusBar CssClass="statusBar"></StatusBar></Styles>
                                                                        <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>

                                                                        <Columns>
                                                                            <%-- Buttons --%>
                                                                            <dx:GridViewCommandColumn ShowNewButtonInHeader="True" Width="5%">
                                                                                <CustomButtons>
                                                                                    <dx:GridViewCommandColumnCustomButton ID="StepProcessRemove" ><Image IconID="actions_cancel_16x16"></Image></dx:GridViewCommandColumnCustomButton>
                                                                                </CustomButtons>
                                                                            </dx:GridViewCommandColumn>
                                                                            <%-- RecordID Hidden Field --%>
                                                                            <dx:GridViewDataTextColumn FieldName="RecordID" Width="0%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%-- HeaderID Hidden Field --%>
                                                                            <dx:GridViewDataTextColumn FieldName="HeaderID" Width="0%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%-- SKUCode Hidden Field --%>
                                                                            <dx:GridViewDataTextColumn FieldName="SKUCode" Width="0%">
                                                                                <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                                </PropertiesTextEdit>
                                                                                <EditFormSettings Visible="False" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%-- Step Sequence Field --%>
                                                                            <dx:GridViewDataSpinEditColumn FieldName="StepSequence" Caption="Step Sequence" ShowInCustomizationForm="True" Width="10%">
                                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="g">  
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>  
                                                                                    <ClientSideEvents ValueChanged="OnKeyUp" />
                                                                                    <ValidationSettings Display="Static" ErrorDisplayMode="ImageWithTooltip">
                                                                                        <RequiredField IsRequired="true" />
                                                                                    </ValidationSettings>
                                                                                    <InvalidStyle BackColor="Pink"></InvalidStyle>
                                                                                </PropertiesSpinEdit>  
                                                                                <EditFormSettings VisibleIndex="0"/>
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <%-- Step Code Field --%>
                                                                            <dx:GridViewDataTextColumn FieldName="StepCode" Caption="Step Code" Name="StepCode" ShowInCustomizationForm="True" Width="40%">
                                                                                <EditItemTemplate>
                                                                                    <dx:ASPxGridLookup ID="glStepCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="StepCode"
                                                                                        ClientInstanceName="glStepCode" TextFormatString="{0}" DataSourceID="sdsStepCode" Width="100%">
                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                        </GridViewProperties>
                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                            <RequiredField IsRequired="True" ErrorText="Stepcode is required" />  
                                                                                        </ValidationSettings>  
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="StepCode" Caption="Step Code" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Description" Caption="Step Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="IsBackFlush" Caption="" ReadOnly="True" VisibleIndex="1" width="0px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                        <ClientSideEvents Validation="OnValidation" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                            var g = glStepCode.GetGridView();
                                                                                            g.GetRowValues(g.GetFocusedRowIndex(), 'StepCode;Description;IsBackFlush', UpdateStepCode); 
                                                                                        }"/>
                                                                                    </dx:ASPxGridLookup>
                                                                                </EditItemTemplate>
                                                                                <EditFormSettings VisibleIndex="1"/>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%-- Step Description --%>
                                                                            <dx:GridViewDataTextColumn FieldName="StepDescription" Caption="Step Description" ShowInCustomizationForm="True" ReadOnly="true" Width="40%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%-- IsBackFlush --%>
                                                                            <dx:GridViewDataCheckColumn FieldName="IsBackFlush" Caption="IsBackFlush" ShowInCustomizationForm="True" VisibleIndex="8" Width="10%">
                                                                                <PropertiesCheckEdit ClientInstanceName="IsBackFlush"></PropertiesCheckEdit>
                                                                            </dx:GridViewDataCheckColumn>
                                                                        </Columns>
                                                                        <Templates>
                                                                            <DetailRow>
                                                                                <div style="padding: 3px 3px 2px 3px">
                                                                                    <dx:ASPxPageControl runat="server" ID="StepProcessDetail" Width="100%" EnableCallBacks="true">
                                                                                        <TabPages>
                                                                                            <dx:TabPage Text="Bill of Materials" Visible="true">
                                                                                                <ContentCollection>
                                                                                                    <dx:ContentControl runat="server">
                                                                                                        <dx:ASPxGridView ID="gvStepBOM" ClientInstanceName="gvStepBOM" DataSourceID="sdsBOM" runat="server" KeyFieldName="RecordID" Width="100%" 
                                                                                                            OnBeforePerformDataSelect="detailBOM_BeforePerformDataSelect" OnRowInserting="gvStepBOM_RowInserting" OnRowUpdating="gvStepBOM_RowUpdating"
                                                                                                            OnRowDeleting="gvStepBOM_RowDeleting" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize" OnInitNewRow="DefaultValues">
                                                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" EndCallback="OnEndCallback"/>
                                                                                                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                                            <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                                                            <SettingsBehavior AllowSort="False"/>
                                                                                                            <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 
                                                                                                             <SettingsCommandButton>
                                                                                                                <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                                                                <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                                                                <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                                                            </SettingsCommandButton>
                                                                                                            <Styles>
                                                                                                                <Row CssClass="BOMClass"/>
                                                                                                                <StatusBar CssClass="statusBar">
                                                                                                                </StatusBar>
                                                                                                            </Styles>
                                                                                                            <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                                                            <Columns>
                                                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="50px" ShowNewButtonInHeader="True">
                                                                                                                    <CustomButtons>
                                                                                                                        <dx:GridViewCommandColumnCustomButton ID="BOMDelete">
                                                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                                                    </CustomButtons>
                                                                                                                </dx:GridViewCommandColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="SKUCode" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="StepCode" Width="0%"/>
                                                                                                                <%-- Item Code --%>
                                                                                                                <dx:GridViewDataTextColumn Caption="Item Code" FieldName="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <EditItemTemplate>
                                                                                                                        <dx:ASPxGridLookup ID="glStepBOMItemCode" ClientInstanceName="glStepBOMItemCode" runat="server" DataSourceID="sdsItemCode" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="ItemCode" TextFormatString="{0}" Width="100%" >
                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                            </GridViewProperties>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Item Code is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="ItemCode" Caption="Code" ReadOnly="True">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="FullDesc" Caption="Description" ReadOnly="True">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="UnitBase" ReadOnly="True" Width="0px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="StandardQty" ReadOnly="True" Width="0px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                            </Columns>
                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                                                    var g = glStepBOMItemCode.GetGridView();
                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'ItemCode;FullDesc;UnitBase;StandardQty', UpdateItemCodeBOM); 
                                                                                                                            }"/>
                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                    </EditItemTemplate>
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <%-- Description --%>
                                                                                                                <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" Name="Description" ShowInCustomizationForm="True" Width="150px"></dx:GridViewDataTextColumn>
                                                                                                                <%-- Unit --%>
                                                                                                                <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit" Name="Unit" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <EditItemTemplate>
                                                                                                                        <dx:ASPxGridLookup ID="glStepBOMUnitCode" ClientInstanceName="glStepBOMUnitCode" DataSourceID="" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="Unit" TextFormatString="{0}" Width="100%" OnInit="lookup_Init" >
                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                            </GridViewProperties>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Unit is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Unit" Caption="Code" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                            </Columns>
                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                                                                                DropDown="function dropdown(s, e){
                                                                                                                                    glStepBOMUnitCode.GetGridView().PerformCallback('Unit' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                                                                                    }" 
                                                                                                                                ValueChanged="function(s,e){ 
                                                                                                                                    var g = glStepBOMUnitCode.GetGridView();
                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'Unit', UpdateUnitCodeBOM); 
                                                                                                                            }"/>
                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                    </EditItemTemplate>
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <%-- Consumption Per Product --%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="ConsumptionPerProduct" ShowInCustomizationForm="True" Width="170px" ReadOnly="true">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n4}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <%-- Total Consumption --%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="TotalConsumption" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n4}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                            <RequiredField IsRequired="True" ErrorText="Total Consumption is required" />  
                                                                                                                        </ValidationSettings> 
                                                                                                                        <ClientSideEvents NumberChanged="calculate"/>
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <%-- Percentage Allowance --%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="PercentageAllowance" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:P2}" MinValue="0">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                        <ClientSideEvents NumberChanged="percentage"/>
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <%-- Qty Allowance --%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="QtyAllowance" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n}" MinValue="0">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                        <ClientSideEvents NumberChanged="calculate"/>
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <%-- Client Supplied Material --%>
                                                                                                                <dx:GridViewDataCheckColumn FieldName="ClientSuppliedMaterial" Width="150px">
                                                                                                                    <PropertiesCheckEdit ClientInstanceName="pClientSuppliedMaterial">
                                                                                                                        <ClientSideEvents CheckedChanged="function(s,e){ 
                                                                                                                            if (s.GetChecked() == true) 
                                                                                                                            {
                                                                                                                                gvStepBOM.batchEditApi.SetCellValue(index, 'EstimatedUnitCost', 0);
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                                gvStepBOM.batchEditApi.SetCellValue(index, 'EstimatedUnitCost', null);
                                                                                                                            }
                                                                                                                        }" />
                                                                                                                    </PropertiesCheckEdit>
                                                                                                                </dx:GridViewDataCheckColumn>
                                                                                                                <%-- Estimated Unit Cost --%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="EstimatedUnitCost" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n4}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                        <ValidationSettings Display="Static" ErrorDisplayMode="ImageWithTooltip">
                                                                                                                            <RequiredField IsRequired="true" />
                                                                                                                        </ValidationSettings>
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <%-- Standard Usage --%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="StandardUsage" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="g">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                            <RequiredField IsRequired="True" ErrorText="Standard Usage is required" />  
                                                                                                                        </ValidationSettings> 
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <%-- Standard Usage Unit --%>
                                                                                                                <dx:GridViewDataTextColumn FieldName="StandardUsageUnit" Name="StandardUsageUnit" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <EditItemTemplate>
                                                                                                                        <dx:ASPxGridLookup ID="glBOMStandardUsage" ClientInstanceName="glBOMStandardUsage" DataSourceID="sdsUnit1" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="UnitCode" TextFormatString="{0}" Width="100%" >
                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                            </GridViewProperties>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Standard Usage Unit is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="UnitCode" Caption="Code" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                            </Columns>
                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                                                    var g = glBOMStandardUsage.GetGridView();
                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'UnitCode', UpdateStandardUsageBOM); 
                                                                                                                            }"/>
                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                    </EditItemTemplate>
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="Remarks" Width="150px"/>
                                                                                                            </Columns>
                                                                                                            <SettingsDetail IsDetailGrid="True" />
                                                                                                        </dx:ASPxGridView>
                                                                                                    </dx:ContentControl>
                                                                                                </ContentCollection>
                                                                                            </dx:TabPage>
                                                                                            <dx:TabPage Text="Machineries" Visible="true">
                                                                                                <ContentCollection>
                                                                                                    <dx:ContentControl runat="server">
                                                                                                        <dx:ASPxGridView ID="gvStepMachine" ClientInstanceName="gvStepMachine" runat="server" DataSourceID="sdsMachine" KeyFieldName="RecordID" Width="100%"
                                                                                                            OnBeforePerformDataSelect="detailMachine_BeforePerformDataSelect" OnRowInserting="gvStepMachine_RowInserting" OnRowUpdating="gvStepMachine_RowUpdating"
                                                                                                            OnRowDeleting="gvStepMachine_RowDeleting" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize">
                                                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" EndCallback="OnEndCallback"/>
                                                                                                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                                            <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                                                            <SettingsBehavior AllowSort="False"/>
                                                                                                            <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 
                                                                                                             <SettingsCommandButton>
                                                                                                                <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                                                                <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                                                                <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                                                            </SettingsCommandButton>
                                                                                                            <Styles>
                                                                                                                <StatusBar CssClass="statusBar">
                                                                                                                </StatusBar>
                                                                                                            </Styles>
                                                                                                            <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                                                            <Columns>
                                                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="5%" ShowNewButtonInHeader="True">
                                                                                                                    <CustomButtons>
                                                                                                                        <dx:GridViewCommandColumnCustomButton ID="MachineDelete">
                                                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                                                    </CustomButtons>
                                                                                                                </dx:GridViewCommandColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="SKUCode" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="SKUDescription" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="StepSequence" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="StepCode" Width="0%"/>
                                                                                                                <%--<dx:GridViewDataColumn FieldName="MachineType" Width="13.57%"/>--%>
                                                                                                                <dx:GridViewDataTextColumn Caption="Machine Type" FieldName="MachineType" Name="MachineType" ShowInCustomizationForm="True" Width="13.57%">
                                                                                                                    <EditItemTemplate>
                                                                                                                        <dx:ASPxGridLookup ID="glStepMachineMachineType" ClientInstanceName="glStepMachineMachineType" DataSourceID="sdsMachineCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="MachineCode" TextFormatString="{0}" Width="100%" >
                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                            </GridViewProperties>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Machine Type is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="MachineCode" Caption="Type" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Location" ReadOnly="True" VisibleIndex="2" width="0px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="CapacityQty" ReadOnly="True" VisibleIndex="3" width="0px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="CapacityUnit" ReadOnly="True" VisibleIndex="4" width="0px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                            </Columns>
                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                                                    var g = glStepMachineMachineType.GetGridView();
                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'MachineCode;Location;CapacityQty;CapacityUnit', UpdateMachineTypeMachine); 
                                                                                                                            }"/>
                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                    </EditItemTemplate>
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="Location" Width="13.57%" ReadOnly="true"/>
                                                                                                                <%--<dx:GridViewDataColumn FieldName="MachineRun" Width="13.57%"/>--%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="MachineRun" ShowInCustomizationForm="True" Width="13.57%">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n4}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>  
                                                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                            <RequiredField IsRequired="True" ErrorText="Machine Run is required" />  
                                                                                                                        </ValidationSettings> 
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <%--<dx:GridViewDataColumn FieldName="Unit" Width="13.57%"/>--%>
                                                                                                                <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit" Name="Unit" ShowInCustomizationForm="True" Width="13.57%">
                                                                                                                    <EditItemTemplate>
                                                                                                                        <dx:ASPxGridLookup ID="glStepMachineUnit" ClientInstanceName="glStepMachineUnit" DataSourceID="sdsUnit1" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="UnitCode" TextFormatString="{0}" Width="100%" >
                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                            </GridViewProperties>
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="UnitCode" Caption="Type" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                            </Columns>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Unit is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                                                    var g = glStepMachineUnit.GetGridView();
                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'UnitCode', UpdateUnitMachine); 
                                                                                                                            }"/>
                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                    </EditItemTemplate>
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <%--<dx:GridViewDataColumn FieldName="MachineCapacityQty" Width="13.57%"/>--%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="MachineCapacityQty" ShowInCustomizationForm="True" Width="13.57%" ReadOnly="true">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="G">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>  
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="MachineCapacityUnit" Width="13.57%" ReadOnly="true"/>
                                                                                                                <%--<dx:GridViewDataColumn FieldName="CostPerUnit" Width="13.57%"/>--%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="CostPerUnit" ShowInCustomizationForm="True" Width="13.57%">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:N}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>  
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                            </Columns>
                                                                                                            <SettingsDetail IsDetailGrid="True" />
                                                                                                        </dx:ASPxGridView>
                                                                                                    </dx:ContentControl>
                                                                                                </ContentCollection>
                                                                                            </dx:TabPage>
                                                                                            <dx:TabPage Text="Manpower" Visible="true">
                                                                                                <ContentCollection>
                                                                                                    <dx:ContentControl runat="server">
                                                                                                        <dx:ASPxGridView ID="gvStepManpower" ClientInstanceName="gvStepManpower" runat="server" DataSourceID="sdsManpower" KeyFieldName="RecordID" Width="100%"
                                                                                                            OnBeforePerformDataSelect="detailManpower_BeforePerformDataSelect" OnRowInserting="gvStepManpower_RowInserting" OnRowUpdating="gvStepManpower_RowUpdating"
                                                                                                            OnRowDeleting="gvStepManpower_RowDeleting" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize">
                                                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" EndCallback="OnEndCallback"/>
                                                                                                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                                            <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                                                            <SettingsBehavior AllowSort="False"/>
                                                                                                            <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 
                                                                                                             <SettingsCommandButton>
                                                                                                                <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                                                                <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                                                                <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                                                            </SettingsCommandButton>
                                                                                                            <Styles>
                                                                                                                <StatusBar CssClass="statusBar">
                                                                                                                </StatusBar>
                                                                                                            </Styles>
                                                                                                            <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                                                            <Columns>
                                                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="5%" ShowNewButtonInHeader="True">
                                                                                                                    <CustomButtons>
                                                                                                                        <dx:GridViewCommandColumnCustomButton ID="ManpowerDelete">
                                                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                                                    </CustomButtons>
                                                                                                                </dx:GridViewCommandColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="SKUCode" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="SKUDescription" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="StepSequence" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="StepCode" Width="0%"/>
                                                                                                                <%--<dx:GridViewDataColumn FieldName="Designation" Width="15.83%"/>--%>
                                                                                                                <dx:GridViewDataTextColumn FieldName="Designation" Name="Designation" ShowInCustomizationForm="True" Width="15.83%">
                                                                                                                    <EditItemTemplate>
                                                                                                                        <dx:ASPxGridLookup ID="glStepManpowerDesignation" ClientInstanceName="glStepManpowerDesignation" DataSourceID="sdsDesignation" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="Designation;Name" TextFormatString="{0}" Width="100%" >
                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                            </GridViewProperties>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Designation is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Designation" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="StandardRate" ReadOnly="True" VisibleIndex="2" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="StandardRateUnit" ReadOnly="True" VisibleIndex="3" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                            </Columns>
                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                                                    var g = glStepManpowerDesignation.GetGridView();
                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'Designation;StandardRate;StandardRateUnit', UpdateDesignationManpower); 
                                                                                                                            }"/>
                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                    </EditItemTemplate>
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <%--<dx:GridViewDataColumn FieldName="NoManpower" Width="15.83%"/>--%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="NoManpower" ShowInCustomizationForm="True" Width="15.83%">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n}" MinValue="0">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Number of Manpower is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="NoHour" Caption="No. of Hours" ShowInCustomizationForm="True" Width="15.83%">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n4}" MinValue="0">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Number of Hour is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="StandardRate" Width="15.83%" ReadOnly="true"/>
                                                                                                                <dx:GridViewDataColumn FieldName="StandardRateUnit" Width="15.83%" ReadOnly="true"/>
                                                                                                                <%--<dx:GridViewDataColumn FieldName="CostPerUnit" Width="15.83%"/>--%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="CostPerUnit" ShowInCustomizationForm="True" Width="15.83%">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:N}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>  
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                            </Columns>
                                                                                                            <SettingsDetail IsDetailGrid="True" />
                                                                                                        </dx:ASPxGridView>
                                                                                                    </dx:ContentControl>
                                                                                                </ContentCollection>
                                                                                            </dx:TabPage>
                                                                                        </TabPages>
                                                                                    </dx:ASPxPageControl>
                                                                                </div>
                                                                            </DetailRow>
                                                                        </Templates>
                                                                    </dx:ASPxGridView>
                                                                </div>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <%-- Packaging Steps Field --%>
                                            <dx:LayoutGroup Caption="RTE">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <div class="container-fluid" id="StepProcessTable1">
                                                                    <dx:ASPxGridView DataSourceID="sdsStepProcess1" ID="gvStepProcess1" ClientInstanceName="gvStepProcess1" runat="server" 
                                                                        AutoGenerateColumns="False" KeyFieldName="StepSequence" Width="100%" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize" OnRowValidating="grid_RowValidating" 
                                                                        OnBeforePerformDataSelect="masterGrid_BeforePerformDataSelect1" OnRowInserting="gvStepProcess_RowInserting1" OnRowUpdating="gvStepProcess_RowUpdating1" 
                                                                        OnRowDeleting="gvStepProcess_RowDeleting1">

                                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick" EndCallback="OnEndCallback"/>

                                                                        <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 

                                                                        <SettingsPager Mode="ShowAllRecords"></SettingsPager>

                                                                        <SettingsEditing Mode="Batch"></SettingsEditing>

                                                                        <SettingsBehavior AllowSort="False" ConfirmDelete="true"/>

                                                                        <SettingsDetail ShowDetailRow="true" ShowDetailButtons="true" AllowOnlyOneMasterRowExpanded="true" />

                                                                        <SettingsCommandButton>
                                                                            <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                            <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                            <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                        </SettingsCommandButton>

                                                                        <Styles><StatusBar CssClass="statusBar"></StatusBar></Styles>
                                                                        <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>

                                                                        <Columns>
                                                                            <%-- Buttons --%>
                                                                            <dx:GridViewCommandColumn ShowNewButtonInHeader="True" Width="5%">
                                                                                <CustomButtons>
                                                                                    <dx:GridViewCommandColumnCustomButton ID="StepProcessRemove1" ><Image IconID="actions_cancel_16x16"></Image></dx:GridViewCommandColumnCustomButton>
                                                                                </CustomButtons>
                                                                            </dx:GridViewCommandColumn>
                                                                            <%-- RecordID Hidden Field --%>
                                                                            <dx:GridViewDataTextColumn FieldName="RecordID" Width="0%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%-- HeaderID Hidden Field --%>
                                                                            <dx:GridViewDataTextColumn FieldName="HeaderID" Width="0%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%-- SKUCode Hidden Field --%>
                                                                            <dx:GridViewDataTextColumn FieldName="SKUCode" Width="0%">
                                                                                <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                                                </PropertiesTextEdit>
                                                                                <EditFormSettings Visible="False" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%-- Step Sequence Field --%>
                                                                            <dx:GridViewDataSpinEditColumn FieldName="StepSequence" Caption="Step Sequence" ShowInCustomizationForm="True" Width="10%">
                                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="g">  
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>   
                                                                                    <ClientSideEvents ValueChanged="OnKeyUp" />                                                                                    
                                                                                    <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                        <RequiredField IsRequired="True" ErrorText="Step Sequence is required" />  
                                                                                    </ValidationSettings> 
                                                                                    <InvalidStyle BackColor="Pink"></InvalidStyle>
                                                                                </PropertiesSpinEdit>  
                                                                                <EditFormSettings VisibleIndex="0"/>
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <%-- Step Code Field --%>
                                                                            <dx:GridViewDataTextColumn FieldName="StepCode" Caption="Step Code" Name="StepCode" ShowInCustomizationForm="True" Width="40%">
                                                                                <EditItemTemplate>
                                                                                    <dx:ASPxGridLookup ID="glStepCode1" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="StepCode"
                                                                                        ClientInstanceName="glStepCode1" TextFormatString="{0}" DataSourceID="sdsStepCode1" Width="100%">
                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                        </GridViewProperties>
                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                            <RequiredField IsRequired="True" ErrorText="Step Code is required" />  
                                                                                        </ValidationSettings> 
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="StepCode" Caption="Step Code" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Description" Caption="Step Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="IsBackFlush" Caption="" ReadOnly="True" VisibleIndex="1" width="0px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                            var g = glStepCode1.GetGridView();
                                                                                            g.GetRowValues(g.GetFocusedRowIndex(), 'StepCode;Description;IsBackFlush', UpdateStepCode1); 
                                                                                        }"/>
                                                                                    </dx:ASPxGridLookup>
                                                                                </EditItemTemplate>
                                                                                <EditFormSettings VisibleIndex="1"/>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%-- Step Description --%>
                                                                            <dx:GridViewDataTextColumn FieldName="StepDescription" Caption="Step Description" ShowInCustomizationForm="True" ReadOnly="true" Width="40%">
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%-- IsBackFlush --%>
                                                                            <dx:GridViewDataCheckColumn FieldName="IsBackFlush" Name="IsBackFlush" Caption="IsBackFlush" ShowInCustomizationForm="True" VisibleIndex="8" Width="10%">
                                                                                <PropertiesCheckEdit ClientInstanceName="IsBackFlush"></PropertiesCheckEdit>
                                                                            </dx:GridViewDataCheckColumn>
                                                                        </Columns>
                                                                        <Templates>
                                                                            <DetailRow>
                                                                                <div style="padding: 3px 3px 2px 3px">
                                                                                    <dx:ASPxPageControl runat="server" ID="StepProcessDetail" Width="100%" EnableCallBacks="true">
                                                                                        <TabPages>
                                                                                            <dx:TabPage Text="Bill of Materials" Visible="true">
                                                                                                <ContentCollection>
                                                                                                    <dx:ContentControl runat="server">
                                                                                                        <dx:ASPxGridView ID="gvStepBOM1" ClientInstanceName="gvStepBOM1" DataSourceID="sdsBOM1" runat="server" KeyFieldName="RecordID" Width="100%" 
                                                                                                            OnBeforePerformDataSelect="detailBOM_BeforePerformDataSelect1" OnRowInserting="gvStepBOM_RowInserting1" OnRowUpdating="gvStepBOM_RowUpdating1"
                                                                                                            OnRowDeleting="gvStepBOM_RowDeleting1" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize" OnInitNewRow="DefaultValues">
                                                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" EndCallback="OnEndCallback"/>
                                                                                                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                                            <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                                                            <SettingsBehavior AllowSort="False"/>
                                                                                                            <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 
                                                                                                             <SettingsCommandButton>
                                                                                                                <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                                                                <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                                                                <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                                                            </SettingsCommandButton>
                                                                                                            <Styles>
                                                                                                                <Row CssClass="BOMClass"/>
                                                                                                                <StatusBar CssClass="statusBar">
                                                                                                                </StatusBar>
                                                                                                            </Styles>
                                                                                                            <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                                                            <Columns>
                                                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="50px" ShowNewButtonInHeader="True">
                                                                                                                    <CustomButtons>
                                                                                                                        <dx:GridViewCommandColumnCustomButton ID="BOMDelete1">
                                                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                                                    </CustomButtons>
                                                                                                                </dx:GridViewCommandColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="SKUCode" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="StepCode" Width="0%"/>
                                                                                                                <%-- Item Code --%>
                                                                                                                <dx:GridViewDataTextColumn Caption="Item Code" FieldName="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <EditItemTemplate>
                                                                                                                        <dx:ASPxGridLookup ID="glStepBOMItemCode" ClientInstanceName="glStepBOMItemCode" runat="server" DataSourceID="sdsItemCode" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="ItemCode" TextFormatString="{0}" Width="100%" >
                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                            </GridViewProperties>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Item Code is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="ItemCode" Caption="Code" ReadOnly="True">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="FullDesc" Caption="Description" ReadOnly="True">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="UnitBase" ReadOnly="True" Width="0px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="StandardQty" ReadOnly="True" Width="0px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                    </dx:GridViewDataTextColumn>
                                                                                                                            </Columns>
                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                                                    var g = glStepBOMItemCode.GetGridView();
                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'ItemCode;FullDesc;UnitBase;StandardQty', UpdateItemCodeBOM1); 
                                                                                                                            }"/>
                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                    </EditItemTemplate>
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <%-- Description --%>
                                                                                                                <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" Name="Description" ShowInCustomizationForm="True" Width="150px"></dx:GridViewDataTextColumn>
                                                                                                                <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit" Name="Unit" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <EditItemTemplate>
                                                                                                                        <dx:ASPxGridLookup ID="glStepBOMUnitCode" ClientInstanceName="glStepBOMUnitCode" DataSourceID="" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="UnitCode" TextFormatString="{0}" Width="100%" OnInit="lookup_Init">
                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                            </GridViewProperties>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Unit is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Unit" Caption="Code" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                            </Columns>
                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                                                                                DropDown="function dropdown(s, e){
                                                                                                                                    glStepBOMUnitCode.GetGridView().PerformCallback('Unit' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                                                                                    }" 
                                                                                                                                 ValueChanged="function(s,e){ 
                                                                                                                                    var g = glStepBOMUnitCode.GetGridView();
                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'UnitCode', UpdateUnitCodeBOM1); 
                                                                                                                            }"/>
                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                    </EditItemTemplate>
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="ConsumptionPerProduct" ShowInCustomizationForm="True" Width="170px" ReadOnly="true">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n4}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="TotalConsumption" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                            <RequiredField IsRequired="True" ErrorText="Total Consumption is required" />  
                                                                                                                        </ValidationSettings> 
                                                                                                                        <ClientSideEvents NumberChanged="calculate1"/>
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="PercentageAllowance" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:P2}" MinValue="0">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                        <ClientSideEvents NumberChanged="percentage1"/>
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="QtyAllowance" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n}" MinValue="0">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                        <ClientSideEvents NumberChanged="calculate1"/>
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataCheckColumn FieldName="ClientSuppliedMaterial" Width="150px">
                                                                                                                    <PropertiesCheckEdit ClientInstanceName="pClientSuppliedMaterial">
                                                                                                                        <ClientSideEvents CheckedChanged="function(s,e){ 
                                                                                                                            if (s.GetChecked() == true) 
                                                                                                                            {
                                                                                                                                gvStepBOM1.batchEditApi.SetCellValue(index, 'EstimatedUnitCost', 0);
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                                gvStepBOM1.batchEditApi.SetCellValue(index, 'EstimatedUnitCost', null);
                                                                                                                            }
                                                                                                                        }" />
                                                                                                                    </PropertiesCheckEdit>
                                                                                                                </dx:GridViewDataCheckColumn>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="EstimatedUnitCost" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                            <RequiredField IsRequired="True" ErrorText="Estimated Unit Cost is required" />  
                                                                                                                        </ValidationSettings> 
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="StandardUsage" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="g">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                            <RequiredField IsRequired="True" ErrorText="Standard Usage is required" />  
                                                                                                                        </ValidationSettings> 
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataTextColumn FieldName="StandardUsageUnit" Name="StandardUsageUnit" ShowInCustomizationForm="True" Width="150px">
                                                                                                                    <EditItemTemplate>
                                                                                                                        <dx:ASPxGridLookup ID="glBOMStandardUsage" ClientInstanceName="glBOMStandardUsage" DataSourceID="sdsUnit1" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="UnitCode" TextFormatString="{0}" Width="100%" >
                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                            </GridViewProperties>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Standard Usage Unit is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="UnitCode" Caption="Code" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                            </Columns>
                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                                                    var g = glBOMStandardUsage.GetGridView();
                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'UnitCode', UpdateStandardUsageBOM1); 
                                                                                                                            }"/>
                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                    </EditItemTemplate>
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="Remarks" Width="150px"/>
                                                                                                            </Columns>
                                                                                                            <SettingsDetail IsDetailGrid="True" />
                                                                                                        </dx:ASPxGridView>
                                                                                                    </dx:ContentControl>
                                                                                                </ContentCollection>
                                                                                            </dx:TabPage>
                                                                                            <dx:TabPage Text="Machineries" Visible="true">
                                                                                                <ContentCollection>
                                                                                                    <dx:ContentControl runat="server">
                                                                                                        <dx:ASPxGridView ID="gvStepMachine1" ClientInstanceName="gvStepMachine1" runat="server" DataSourceID="sdsMachine1" KeyFieldName="RecordID" Width="100%"
                                                                                                            OnBeforePerformDataSelect="detailMachine_BeforePerformDataSelect1" OnRowInserting="gvStepMachine_RowInserting1" OnRowUpdating="gvStepMachine_RowUpdating1"
                                                                                                            OnRowDeleting="gvStepMachine_RowDeleting1" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize">
                                                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" EndCallback="OnEndCallback"/>
                                                                                                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                                            <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                                                            <SettingsBehavior AllowSort="False"/>
                                                                                                            <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 
                                                                                                             <SettingsCommandButton>
                                                                                                                <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                                                                <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                                                                <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                                                            </SettingsCommandButton>
                                                                                                            <Styles>
                                                                                                                <StatusBar CssClass="statusBar">
                                                                                                                </StatusBar>
                                                                                                            </Styles>
                                                                                                            <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                                                            <Columns>
                                                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="5%" ShowNewButtonInHeader="True">
                                                                                                                    <CustomButtons>
                                                                                                                        <dx:GridViewCommandColumnCustomButton ID="MachineDelete1">
                                                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                                                    </CustomButtons>
                                                                                                                </dx:GridViewCommandColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="SKUCode" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="SKUDescription" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="StepSequence" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="StepCode" Width="0%"/>
                                                                                                                <dx:GridViewDataTextColumn Caption="Machine Type" FieldName="MachineType" Name="MachineType" ShowInCustomizationForm="True" Width="13.57%">
                                                                                                                    <EditItemTemplate>
                                                                                                                        <dx:ASPxGridLookup ID="glStepMachineMachineType" ClientInstanceName="glStepMachineMachineType" DataSourceID="sdsMachineCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="MachineCode" TextFormatString="{0}" Width="100%" >
                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                            </GridViewProperties>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Machine Type is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="MachineCode" Caption="Type" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Location" ReadOnly="True" VisibleIndex="2" width="0px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="CapacityQty" ReadOnly="True" VisibleIndex="3" width="0px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="CapacityUnit" ReadOnly="True" VisibleIndex="4" width="0px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                            </Columns>
                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                                                    var g = glStepMachineMachineType.GetGridView();
                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'MachineCode;Location;CapacityQty;CapacityUnit', UpdateMachineTypeMachine1); 
                                                                                                                            }"/>
                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                    </EditItemTemplate>
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="Location" Width="13.57%" ReadOnly="true"/>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="MachineRun" ShowInCustomizationForm="True" Width="13.57%">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n4}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>  
                                                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                            <RequiredField IsRequired="True" ErrorText="Machine Run is required" />  
                                                                                                                        </ValidationSettings> 
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit" Name="Unit" ShowInCustomizationForm="True" Width="13.57%">
                                                                                                                    <EditItemTemplate>
                                                                                                                        <dx:ASPxGridLookup ID="glStepMachineUnit" ClientInstanceName="glStepMachineUnit" DataSourceID="sdsUnit1" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="UnitCode" TextFormatString="{0}" Width="100%" >
                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                            </GridViewProperties>
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="UnitCode" Caption="Type" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                            </Columns>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Unit is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                                                    var g = glStepMachineUnit.GetGridView();
                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'UnitCode', UpdateUnitMachine1); 
                                                                                                                            }"/>
                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                    </EditItemTemplate>
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="MachineCapacityQty" ShowInCustomizationForm="True" Width="13.57%" ReadOnly="true">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:N}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>  
                                                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                            <RequiredField IsRequired="True" ErrorText="Machine Capacity Qty is required" />  
                                                                                                                        </ValidationSettings> 
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="MachineCapacityUnit" Width="13.57%" ReadOnly="true"/>
                                                                                                                <%--<dx:GridViewDataColumn FieldName="CostPerUnit" Width="13.57%"/>--%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="CostPerUnit" ShowInCustomizationForm="True" Width="13.57%">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:N}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>  
                                                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                            <RequiredField IsRequired="True" ErrorText="Cost Per Unit is required" />  
                                                                                                                        </ValidationSettings> 
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                            </Columns>
                                                                                                            <SettingsDetail IsDetailGrid="True" />
                                                                                                        </dx:ASPxGridView>
                                                                                                    </dx:ContentControl>
                                                                                                </ContentCollection>
                                                                                            </dx:TabPage>
                                                                                            <dx:TabPage Text="Manpower" Visible="true">
                                                                                                <ContentCollection>
                                                                                                    <dx:ContentControl runat="server">
                                                                                                        <dx:ASPxGridView ID="gvStepManpower1" ClientInstanceName="gvStepManpower1" runat="server" DataSourceID="sdsManpower1" KeyFieldName="RecordID" Width="100%"
                                                                                                            OnBeforePerformDataSelect="detailManpower_BeforePerformDataSelect1" OnRowInserting="gvStepManpower_RowInserting1" OnRowUpdating="gvStepManpower_RowUpdating1"
                                                                                                            OnRowDeleting="gvStepManpower_RowDeleting1" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize">
                                                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" EndCallback="OnEndCallback"/>
                                                                                                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                                                            <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                                                            <SettingsBehavior AllowSort="False"/>
                                                                                                            <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 
                                                                                                             <SettingsCommandButton>
                                                                                                                <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                                                                <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                                                                <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                                                            </SettingsCommandButton>
                                                                                                            <Styles>
                                                                                                                <StatusBar CssClass="statusBar">
                                                                                                                </StatusBar>
                                                                                                            </Styles>
                                                                                                            <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>
                                                                                                            <Columns>
                                                                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="5%" ShowNewButtonInHeader="True">
                                                                                                                    <CustomButtons>
                                                                                                                        <dx:GridViewCommandColumnCustomButton ID="ManpowerDelete1">
                                                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                                                                    </CustomButtons>
                                                                                                                </dx:GridViewCommandColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="RecordID" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="SKUCode" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="SKUDescription" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="StepSequence" Width="0%"/>
                                                                                                                <dx:GridViewDataColumn FieldName="StepCode" Width="0%"/>
                                                                                                                <dx:GridViewDataTextColumn FieldName="Designation" Name="Designation" ShowInCustomizationForm="True" Width="15.83%">
                                                                                                                    <EditItemTemplate>
                                                                                                                        <dx:ASPxGridLookup ID="glStepManpowerDesignation" ClientInstanceName="glStepManpowerDesignation" DataSourceID="sdsDesignation" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="Designation;Name" TextFormatString="{0}" Width="100%" >
                                                                                                                                <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                                                    Settings-VerticalScrollBarMode="Visible"> 
                                                                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                                                    AllowSelectSingleRowOnly="True"/>
                                                                                                                            </GridViewProperties>
                                                                                                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                                <RequiredField IsRequired="True" ErrorText="Designation is required" />  
                                                                                                                            </ValidationSettings> 
                                                                                                                            <Columns>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Designation" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="StandardRate" ReadOnly="True" VisibleIndex="2" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                                <dx:GridViewDataTextColumn FieldName="StandardRateUnit" ReadOnly="True" VisibleIndex="3" width="150px">
                                                                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                            </Columns>
                                                                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                                                    var g = glStepManpowerDesignation.GetGridView();
                                                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'Designation;StandardRate;StandardRateUnit', UpdateDesignationManpower1); 
                                                                                                                            }"/>
                                                                                                                        </dx:ASPxGridLookup>
                                                                                                                    </EditItemTemplate>
                                                                                                                </dx:GridViewDataTextColumn>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="NoManpower" ShowInCustomizationForm="True" Width="15.83%">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n}" MinValue="0">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                            <RequiredField IsRequired="True" ErrorText="Number of Manpower is required" />  
                                                                                                                        </ValidationSettings> 
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="NoHour" Caption="No. of Hours" ShowInCustomizationForm="True" Width="15.83%">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n4}" MinValue="0">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                            <RequiredField IsRequired="True" ErrorText="Number of Hour is required" />  
                                                                                                                        </ValidationSettings> 
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                                <dx:GridViewDataColumn FieldName="StandardRate" Width="15.83%" ReadOnly="true"/>
                                                                                                                <dx:GridViewDataColumn FieldName="StandardRateUnit" Width="15.83%" ReadOnly="true"/>
                                                                                                                <%--<dx:GridViewDataColumn FieldName="CostPerUnit" Width="15.83%"/>--%>
                                                                                                                <dx:GridViewDataSpinEditColumn FieldName="CostPerUnit" ShowInCustomizationForm="True" Width="15.83%">
                                                                                                                    <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:N}">  
                                                                                                                        <SpinButtons ShowIncrementButtons="False"></SpinButtons>  
                                                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                                                            <RequiredField IsRequired="True" ErrorText="Cost Per Unit is required" />  
                                                                                                                        </ValidationSettings> 
                                                                                                                    </PropertiesSpinEdit>  
                                                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                                            </Columns>
                                                                                                            <SettingsDetail IsDetailGrid="True" />
                                                                                                        </dx:ASPxGridView>
                                                                                                    </dx:ContentControl>
                                                                                                </ContentCollection>
                                                                                            </dx:TabPage>
                                                                                        </TabPages>
                                                                                    </dx:ASPxPageControl>
                                                                                </div>
                                                                            </DetailRow>
                                                                        </Templates>
                                                                    </dx:ASPxGridView>
                                                                </div>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <%-- Other Materials Field --%>
                                            <dx:LayoutGroup Caption="Other Materials">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <div id="divOtherMaterials">
                                                                    <dx:ASPxGridView ID="gvOtherMaterial" DataSourceID="sdsOtherMaterials" ClientInstanceName="gvOtherMaterial" runat="server" 
                                                                        AutoGenerateColumns="False" KeyFieldName="RecordID" Width="100%" OnRowValidating="grid_RowValidating"  
                                                                        OnBeforePerformDataSelect="otherGrid_BeforePerformDataSelect" OnRowInserting="gvOtherMaterial_RowInserting" OnRowUpdating="gvOtherMaterial_RowUpdating"
                                                                        OnRowDeleting="gvOtherMaterial_RowDeleting" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv_CustomButtonInitialize" OnInitNewRow="DefaultValues">

                                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick"/>
                                                                    
                                                                        <SettingsPager Mode="ShowAllRecords"></SettingsPager>

                                                                        <SettingsEditing Mode="Batch"></SettingsEditing>

                                                                        <Settings HorizontalScrollBarMode="Visible" ColumnMinWidth="500"/> 

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
                                                                        <Styles Header-HorizontalAlign="Center" Header-BackColor="#EBEBEB" Header-Font-Bold="true"/>

                                                                        <Columns>
                                                                            <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" Width="50px" ShowNewButtonInHeader="True">
                                                                                <CustomButtons>
                                                                                    <dx:GridViewCommandColumnCustomButton ID="MaterialDelete">
                                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                                </CustomButtons>
                                                                            </dx:GridViewCommandColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="RecordID" ShowInCustomizationForm="True" Width="0%"></dx:GridViewDataTextColumn>
                                                                            <%-- SKUCode Field --%>
                                                                            <dx:GridViewDataTextColumn FieldName="SKUCode" ShowInCustomizationForm="True" Width="0%"></dx:GridViewDataTextColumn>
                                                                            <%-- Item Code --%>
                                                                            <%--<dx:GridViewDataTextColumn Caption="Item Code" FieldName="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" Width="7.3%">
                                                                                <EditItemTemplate>
                                                                                    <dx:ASPxGridLookup ID="glOMItemCode" ClientInstanceName="glOMItemCode" runat="server" DataSourceID="sdsItemCode" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="ItemCode" TextFormatString="{0}" Width="100%" >
                                                                                            <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                Settings-VerticalScrollBarMode="Visible"> 
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                AllowSelectSingleRowOnly="True"/>
                                                                                        </GridViewProperties>
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="ItemCode" Caption="Code" ReadOnly="True">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="FullDesc" Caption="Description" ReadOnly="True">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                var g = glOMItemCode.GetGridView();
                                                                                                g.GetRowValues(g.GetFocusedRowIndex(), 'ItemCode;FullDesc', UpdateItemCodeOM); 
                                                                                        }"/>
                                                                                    </dx:ASPxGridLookup>
                                                                                </EditItemTemplate>
                                                                            </dx:GridViewDataTextColumn>--%>
                                                                            <%-- Description --%>
                                                                            <%--<dx:GridViewDataTextColumn FieldName="Description" Caption="Description" Name="Description" ShowInCustomizationForm="True" Width="7.3%"></dx:GridViewDataTextColumn>--%>
                                                                            <%-- Item Code --%>
                                                                            <dx:GridViewDataTextColumn Caption="Item Code" FieldName="ItemCode" Name="ItemCode" ShowInCustomizationForm="True" Width="150px">
                                                                                <EditItemTemplate>
                                                                                    <dx:ASPxGridLookup ID="glOMItemCode" ClientInstanceName="glOMItemCode" runat="server" DataSourceID="sdsItemCodeOther" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="ItemCode" TextFormatString="{0}" Width="100%" >
                                                                                            <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                Settings-VerticalScrollBarMode="Visible"> 
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                AllowSelectSingleRowOnly="True"/>
                                                                                        </GridViewProperties>
                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                            <RequiredField IsRequired="True" ErrorText="Item Code is required" />  
                                                                                        </ValidationSettings> 
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="ItemCode" Caption="Code" ReadOnly="True">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="FullDesc" Caption="Description" ReadOnly="True">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="UnitBase" ReadOnly="True" Width="0px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                var g = glOMItemCode.GetGridView();
                                                                                                g.GetRowValues(g.GetFocusedRowIndex(), 'ItemCode;FullDesc;UnitBase', UpdateItemCodeOM); 
                                                                                        }"/>
                                                                                    </dx:ASPxGridLookup>
                                                                                </EditItemTemplate>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <%-- Description --%>
                                                                            <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" Name="Description" ShowInCustomizationForm="True" Width="150px"></dx:GridViewDataTextColumn>
                                                                            <%-- Step Code --%>
                                                                            <dx:GridViewDataTextColumn Caption="Step Code" FieldName="StepCode" Name="StepCode" ShowInCustomizationForm="True" ReadOnly="true" Width="150px">
                                                                                <EditItemTemplate>
                                                                                    <dx:ASPxGridLookup ID="glOMStepCode" ClientInstanceName="glOMStepCode" DataSourceID="sdsStepCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="StepCode" TextFormatString="{0}" Width="100%" >
                                                                                            <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                Settings-VerticalScrollBarMode="Visible"> 
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                AllowSelectSingleRowOnly="True"/>
                                                                                        </GridViewProperties>
                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                            <RequiredField IsRequired="True" ErrorText="Step Code is required" />  
                                                                                        </ValidationSettings> 
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="StepCode" Caption="Code" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                                </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                var g = glOMStepCode.GetGridView();
                                                                                                g.GetRowValues(g.GetFocusedRowIndex(), 'StepCode', UpdateStepCode2); 
                                                                                        }"/>
                                                                                    </dx:ASPxGridLookup>
                                                                                </EditItemTemplate>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit" Name="Unit" ShowInCustomizationForm="True" Width="150px">
                                                                                <EditItemTemplate>
                                                                                    <dx:ASPxGridLookup ID="glOMUnitCode" ClientInstanceName="glOMUnitCode" DataSourceID="sdsUnit1" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="UnitCode" TextFormatString="{0}" Width="100%" OnInit="lookup_Init">
                                                                                            <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                Settings-VerticalScrollBarMode="Visible"> 
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                AllowSelectSingleRowOnly="True"/>
                                                                                        </GridViewProperties>
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="UnitCode" Caption="Code" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                                            DropDown="function dropdown(s, e){
                                                                                                glStepBOMUnitCode.GetGridView().PerformCallback('Unit' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                                                }" 
                                                                                            ValueChanged="function(s,e){ 
                                                                                                var g = glOMUnitCode.GetGridView();
                                                                                                g.GetRowValues(g.GetFocusedRowIndex(), 'UnitCode', UpdateUnitCodeOM); 
                                                                                        }"/>
                                                                                    </dx:ASPxGridLookup>
                                                                                </EditItemTemplate>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataSpinEditColumn FieldName="ConsumptionPerProduct" ShowInCustomizationForm="True" Width="170px" ReadOnly="true">
                                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n4}">  
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <dx:GridViewDataSpinEditColumn FieldName="TotalConsumption" ShowInCustomizationForm="True" Width="150px">
                                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n}">  
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                        <RequiredField IsRequired="True" ErrorText="Total Consumption is required" />  
                                                                                    </ValidationSettings> 
                                                                                    <ClientSideEvents NumberChanged="calculate2"/>
                                                                                </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <dx:GridViewDataSpinEditColumn FieldName="PercentageAllowance" ShowInCustomizationForm="True" Width="150px">
                                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:P2}" MinValue="0">  
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    <ClientSideEvents NumberChanged="percentage2"/>
                                                                                </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <%--<dx:GridViewDataColumn FieldName="QtyAllowance" Width="150px"/>--%>
                                                                            <dx:GridViewDataSpinEditColumn FieldName="QtyAllowance" ShowInCustomizationForm="True" Width="150px">
                                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n}" MinValue="0">  
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    <ClientSideEvents NumberChanged="calculate2"/>
                                                                                </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <%--<dx:GridViewDataColumn FieldName="ClientSuppliedMaterial" Width="150px"/>--%>
                                                                            <dx:GridViewDataCheckColumn FieldName="ClientSuppliedMaterial" Width="150px">
                                                                                <PropertiesCheckEdit ClientInstanceName="pClientSuppliedMaterial">  
                                                                                    <ClientSideEvents CheckedChanged="function(s,e){ 
                                                                                        if (s.GetChecked() == true) 
                                                                                        {
                                                                                            gvOtherMaterial.batchEditApi.SetCellValue(index, 'EstimatedUnitCost', 0);
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            gvOtherMaterial.batchEditApi.SetCellValue(index, 'EstimatedUnitCost', null);
                                                                                        }
                                                                                    }" />
                                                                                </PropertiesCheckEdit>
                                                                            </dx:GridViewDataCheckColumn>
                                                                            <%--<dx:GridViewDataColumn FieldName="EstimatedUnitCost" Width="150px"/>--%>
                                                                            <dx:GridViewDataSpinEditColumn FieldName="EstimatedUnitCost" ShowInCustomizationForm="True" Width="150px">
                                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="{0:n}">  
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                        <RequiredField IsRequired="True" ErrorText="Estimated Unit Cost is required" />  
                                                                                    </ValidationSettings> 
                                                                                </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <%--<dx:GridViewDataColumn FieldName="StandardUsage" Width="150px"/>--%>
                                                                            <dx:GridViewDataSpinEditColumn FieldName="StandardUsage" ShowInCustomizationForm="True" Width="150px">
                                                                                <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" DisplayFormatString="g">  
                                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                    <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                        <RequiredField IsRequired="True" ErrorText="Standard Usage is required" />  
                                                                                    </ValidationSettings> 
                                                                                </PropertiesSpinEdit>  
                                                                            </dx:GridViewDataSpinEditColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="StandardUsageUnit" Name="StandardUsageUnit" ShowInCustomizationForm="True" Width="150px">
                                                                                <EditItemTemplate>
                                                                                    <dx:ASPxGridLookup ID="glOMStandardUsage" ClientInstanceName="glOMStandardUsage" DataSourceID="sdsUnit1" runat="server" AutoGenerateColumns="false" AutoPostBack="false" KeyFieldName="UnitCode" TextFormatString="{0}" Width="100%" >
                                                                                            <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" 
                                                                                                Settings-VerticalScrollBarMode="Visible"> 
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                                AllowSelectSingleRowOnly="True"/>
                                                                                        </GridViewProperties>
                                                                                        <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="ImageWithTooltip">  
                                                                                            <RequiredField IsRequired="True" ErrorText="Standard Usage Unit is required" />  
                                                                                        </ValidationSettings> 
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="UnitCode" Caption="Code" ReadOnly="True" VisibleIndex="0" Width="150px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="True" VisibleIndex="1" width="150px">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="function(s,e){ 
                                                                                                var g = glOMStandardUsage.GetGridView();
                                                                                                g.GetRowValues(g.GetFocusedRowIndex(), 'UnitCode', UpdateStandardUsageOM); 
                                                                                        }"/>
                                                                                    </dx:ASPxGridLookup>
                                                                                </EditItemTemplate>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataColumn FieldName="Remarks" Width="150px"/>
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
                                    <%-- General Tab End --%>

                                    <%-- Audit Trail Tab Start --%>
                                    <dx:LayoutGroup Caption="Audit Trail" ColCount="2">
                                        <Items>
                                            <%-- Added By Field --%>
                                            <dx:LayoutItem Caption="Added By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Added Date Field --%>
                                            <dx:LayoutItem Caption="Added Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Last Edited By Field --%>
                                            <dx:LayoutItem Caption="Last Edited By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Last Edited Date Field --%>
                                            <dx:LayoutItem Caption="Last Edited Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Activated By Field --%>
                                            <dx:LayoutItem Caption="Activated By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActivatedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Activated Date Field --%>
                                            <dx:LayoutItem Caption="Activated Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActivatedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Deactivated By Field --%>
                                            <dx:LayoutItem Caption="Deactivated By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDeactivatedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- Deactivated Date Field --%>
                                            <dx:LayoutItem Caption="Deactivated Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDeactivatedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <%-- Audit Trail Tab END --%>
                                </Items>
                            </dx:TabbedLayoutGroup>
                        </Items>
                    </dx:ASPxFormLayout>
                    <%-- Form Layout END --%>

                    <dx:ASPxPopupControl ID="Error" Modal="true" ShowCloseButton="true" ContentStyle-HorizontalAlign="Center" runat="server" ClientInstanceName="errorpop" CloseAction="CloseButton" Theme="Aqua" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" CloseOnEscape="True" HeaderText="Error Message">
                        <ContentStyle HorizontalAlign="Center"></ContentStyle>
                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                                <dx:ASPxLabel ID="ASPxLabel2" runat="server" ForeColor="Red" Text="" ClientInstanceName="errorlabel"></dx:ASPxLabel>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                        <ClientSideEvents Shown="OnShown"/>
                    </dx:ASPxPopupControl>

                    <dx:ASPxPopupControl ID="Success" Modal="true" ShowCloseButton="true" ContentStyle-HorizontalAlign="Center" runat="server" ClientInstanceName="successpop" CloseAction="CloseButton" Theme="Aqua" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" CloseOnEscape="True" HeaderText="Success Message">
                        <ContentStyle HorizontalAlign="Center"></ContentStyle>
                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                                <dx:ASPxLabel ID="ASPxLabel6" runat="server" ForeColor="Green" Text="" ClientInstanceName="successlabel"></dx:ASPxLabel>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                        <ClientSideEvents Shown="OnShown"/>
                    </dx:ASPxPopupControl>

                    <%-- Bottom Panel --%>
                    <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                    <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                    <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn btn-primary" ClientInstanceName="btn"
                                        UseSubmitBehavior="false" CausesValidation="true">
                                        <ClientSideEvents Click="OnUpdateClick" />
                                    </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>

                    <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server"  Text=""   Image-Url="..\images\loadinggear.gif" Image-Height="30px" Image-Width="30px" Height="30px" Width="30px" Enabled="true" ShowImage="true" BackColor="Transparent" Border-BorderStyle="None" 
                        ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
                        <LoadingDivStyle Opacity="0"></LoadingDivStyle>
                   </dx:ASPxLoadingPanel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel> 
    </form>
    <form id="form2" runat="server" visible="false">
        <asp:SqlDataSource ID="sdsmachineCP" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT * FROM Accounting.APMemo"></asp:SqlDataSource>

        <%-- SKUCode DataSource --%>
        <asp:SqlDataSource ID="sdsSKUCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" SelectCommand="SELECT A.ItemCode, A.FullDesc FROM Masterfile.Item A LEFT JOIN Masterfile.ItemCategory B ON A.ItemCategoryCode = B.ItemCategoryCode LEFT JOIN Production.ProdRouting C ON A.ItemCode=C.SKUCode WHERE ISNULL(A.IsInactive,0)=0 AND A.ItemCategoryCode = 003 AND C.SKUCode IS NULL"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsSKUCode2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" SelectCommand="SELECT A.ItemCode, A.FullDesc FROM Masterfile.Item A LEFT JOIN Masterfile.ItemCategory B ON A.ItemCategoryCode = B.ItemCategoryCode LEFT JOIN Production.ProdRouting C ON A.ItemCode=C.SKUCode WHERE ISNULL(A.IsInactive,0)=0 AND A.ItemCategoryCode = 003 AND C.SKUCode IS NULL OR C.SKUCode=@SKUCode">
            <SelectParameters>
                <asp:Parameter Name="SKUCode" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>

        <%-- ItemCode DataSource --%>
        <asp:SqlDataSource ID="sdsItemCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT A.ItemCode, A.FullDesc, UnitBase, A.StandardQty FROM Masterfile.Item A LEFT JOIN Masterfile.ItemCategory B ON A.ItemCategoryCode = B.ItemCategoryCode WHERE ISNULL(A.IsInactive,0)=0 AND A.ItemCategoryCode NOT IN ('003','006','007')"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsItemCodeOther" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT A.ItemCode, A.FullDesc, UnitBase, A.StandardQty FROM Masterfile.Item A LEFT JOIN Masterfile.ItemCategory B ON A.ItemCategoryCode = B.ItemCategoryCode WHERE ISNULL(A.IsInactive,0)=0 AND A.ItemCategoryCode = '006'"></asp:SqlDataSource>

        <%-- CustomerCode DataSource --%>
        <asp:SqlDataSource ID="sdsCustomerCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BPCustomerInfo WHERE ISNULL(IsInactive,0)=0"></asp:SqlDataSource>

        <%-- Unit DataSource --%>
        <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand=""></asp:SqlDataSource>
        
        <asp:SqlDataSource ID="sdsUnit1" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT A.UnitCode, A.Description, B.ConversionFactor FROM Masterfile.Unit A LEFT JOIN Masterfile.UnitConversion B ON A.UnitCode = B.UnitCodeFrom WHERE ISNULL(A.IsInactive,0)=0" />

        <%-- StepCode DataSource --%>
        <asp:SqlDataSource ID="sdsStepCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT StepCode, Description, ISNULL(IsBackFlush,0) AS IsBackFlush FROM Masterfile.Step WHERE Stages='NRTE' AND ISNULL(IsInactive,0)=0"></asp:SqlDataSource>

        <%-- StepCode1 DataSource --%>g
        <asp:SqlDataSource ID="sdsStepCode1" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT StepCode, Description, ISNULL(IsBackFlush,0) AS IsBackFlush FROM Masterfile.Step WHERE Stages='RTE' AND ISNULL(IsInactive,0)=0"></asp:SqlDataSource>

        <%-- Machine DataSource --%>
        <asp:SqlDataSource ID="sdsMachineCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT MachineCategoryCode AS MachineCode, Description, Location, CapacityQty, CapacityUnit FROM Masterfile.MachineCategory WHERE ISNULL(IsInactive,0)=0"></asp:SqlDataSource>

        <%-- Machine DataSource --%>
        <asp:SqlDataSource ID="sdsDesignation" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" SelectCommand="SELECT DepartmentCode AS Designation ,Name ,ISNULL(StandardRate, 0) as StandardRate, StandardRateUnit from Masterfile.Manpower WHERE ISNULL(IsInactive,0)=0"></asp:SqlDataSource>

        <%-- StepProcess DataSource --%>
        <asp:SqlDataSource ID="sdsStepProcess" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init"
            SelectCommand="" 
            InsertCommand="INSERT INTO Production.ProdRoutingStep (SKUCode, StepSequence, StepCode, HeaderID, IsBackFlush) VALUES (@ISKUCode, @IStepSequence, @IStepCode, @IHeaderID, @IsBackFlush)" 
            UpdateCommand="UPDATE Production.ProdRoutingStep SET StepSequence=@UStepSequence, StepCode=@UStepCode, StepDescription=@UStepDescription WHERE RecordID=@ParamURecordID"
            DeleteCommand="DELETE Production.ProdRoutingStep WHERE RecordID=@DRecordID">
            <InsertParameters>
                <asp:Parameter Name="IHeaderID" Type="String" />
                <asp:Parameter Name="ISKUCode" Type="String" />
                <asp:Parameter Name="IStepSequence" Type="String" />
                <asp:Parameter Name="IStepCode" Type="String" />
                <asp:Parameter Name="IsBackFlush" Type="String" />
            </InsertParameters> 
            <UpdateParameters>
                <asp:Parameter Name="ParamURecordID" Type="String" />
                <asp:Parameter Name="UStepSequence" Type="String" />
                <asp:Parameter Name="UStepCode" Type="String" />
                <asp:Parameter Name="UStepDescription" Type="String" />
                <asp:Parameter Name="UIsBackFlush" Type="String" />
            </UpdateParameters> 
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:ObjectDataSource ID="odsStepProcess" runat="server" DataObjectTypeName="Entity.ProductionRouting+ProdRoutingStep" SelectMethod="getStepProcess" InsertMethod="AddStepProcess" TypeName="Entity.ProductionRouting+ProdRoutingStep" UpdateMethod="UpdateStepProcess" DeleteMethod="DeleteStepProcess">
            <SelectParameters>
                <asp:QueryStringParameter Name="SKUCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>

        <asp:SqlDataSource ID="sdsStepProcess1" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init"
            SelectCommand="" 
            InsertCommand="INSERT INTO Production.ProdRoutingStepPack (SKUCode, StepSequence, StepCode, HeaderID, IsBackFlush) VALUES (@ISKUCode, @IStepSequence, @IStepCode, @IHeaderID, @IsBackFlush)" 
            UpdateCommand="UPDATE Production.ProdRoutingStepPack SET StepSequence=@UStepSequence, StepCode=@UStepCode, StepDescription=@UStepDescription WHERE RecordID=@ParamURecordID"
            DeleteCommand="DELETE Production.ProdRoutingStepPack WHERE RecordID=@DRecordID">
            <InsertParameters>
                <asp:Parameter Name="IHeaderID" Type="String" />
                <asp:Parameter Name="ISKUCode" Type="String" />
                <asp:Parameter Name="IStepSequence" Type="String" />
                <asp:Parameter Name="IStepCode" Type="String" />
                <asp:Parameter Name="IsBackFlush" Type="String" />
                <%--<asp:Parameter Name="ISequenceDay" Type="String" />--%>
            </InsertParameters> 
            <UpdateParameters>
                <asp:Parameter Name="ParamURecordID" Type="String" />
                <asp:Parameter Name="UStepSequence" Type="String" />
                <asp:Parameter Name="UStepCode" Type="String" />
                <asp:Parameter Name="UStepDescription" Type="String" />
                <asp:Parameter Name="UIsBackFlush" Type="String" />
                <%--<asp:Parameter Name="USequenceDay" Type="String" />--%>
            </UpdateParameters> 
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:ObjectDataSource ID="odsStepProcess1" runat="server" DataObjectTypeName="Entity.ProductionRouting+ProdRoutingStep" SelectMethod="getStepProcess" InsertMethod="AddStepProcess" TypeName="Entity.ProductionRouting+ProdRoutingStep" UpdateMethod="UpdateStepProcess" DeleteMethod="DeleteStepProcess">
            <SelectParameters>
                <asp:QueryStringParameter Name="SKUCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>

        <%-- BOM DataSource --%>
        <asp:SqlDataSource ID="sdsBOM" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" 
            SelectCommand=""
            InsertCommand="INSERT INTO Production.ProdRoutingStepBOM (SKUCode, StepSequence, StepCode, ItemCode, Unit, ConsumptionPerProduct, TotalConsumption, PercentageAllowance, QtyAllowance, ClientSuppliedMaterial, EstimatedUnitCost, StandardUsage, StandardUsageUnit, Remarks, HeaderID) 
                            VALUES (@ISKUCode, @IStepSequence, @IStepCode, @IItemCode, @IUnit, @IConsumptionPerProduct, @ITotalConsumption, @IPercentageAllowance, @IQtyAllowance, @IClientSuppliedMaterial, @IEstimatedUnitCost, @IStandardUsage, @IStandardUsageUnit, @IRemarks, @IHeaderID)" 
            UpdateCommand="UPDATE Production.ProdRoutingStepBOM SET StepSequence=@UStepSequence, StepCode=@UStepCode, ItemCode=@UItemCode, Unit=@UUnit, ConsumptionPerProduct=@UConsumptionPerProduct, TotalConsumption=@UTotalConsumption, PercentageAllowance=@UPercentageAllowance, QtyAllowance=@UQtyAllowance, ClientSuppliedMaterial=@UClientSuppliedMaterial, EstimatedUnitCost=@UEstimatedUnitCost, StandardUsage=@UStandardUsage, StandardUsageUnit=@UStandardUsageUnit, Remarks=@URemarks WHERE RecordID=@ParamURecordID"
            DeleteCommand="DELETE Production.ProdRoutingStepBOM WHERE RecordID=@DRecordID">
            <InsertParameters>
                <asp:Parameter Name="IHeaderID" Type="String" />
                <asp:Parameter Name="ISKUCode" Type="String" />
                <asp:Parameter Name="IStepSequence" Type="String" />
                <asp:Parameter Name="IStepCode" Type="String" />
                <asp:Parameter Name="IItemCode" Type="String" />
                <asp:Parameter Name="IUnit" Type="String" />
                <asp:Parameter Name="IConsumptionPerProduct" Type="String" />
                <asp:Parameter Name="ITotalConsumption" Type="String" />
                <asp:Parameter Name="IPercentageAllowance" Type="String" />
                <asp:Parameter Name="IQtyAllowance" Type="String" />
                <asp:Parameter Name="IClientSuppliedMaterial" Type="String" />
                <asp:Parameter Name="IEstimatedUnitCost" Type="String" />
                <asp:Parameter Name="IStandardUsage" Type="String" />
                <asp:Parameter Name="IStandardUsageUnit" Type="String" />
                <asp:Parameter Name="IRemarks" Type="String" />
            </InsertParameters> 
            <UpdateParameters>
                <asp:Parameter Name="ParamURecordID" Type="String" />
                <asp:Parameter Name="UStepSequence" Type="String" />
                <asp:Parameter Name="UStepCode" Type="String" />
                <asp:Parameter Name="UItemCode" Type="String" />
                <asp:Parameter Name="UUnit" Type="String" />
                <asp:Parameter Name="UConsumptionPerProduct" Type="String" />
                <asp:Parameter Name="UTotalConsumption" Type="String" />
                <asp:Parameter Name="UPercentageAllowance" Type="String" />
                <asp:Parameter Name="UQtyAllowance" Type="String" />
                <asp:Parameter Name="UClientSuppliedMaterial" Type="String" />
                <asp:Parameter Name="UEstimatedUnitCost" Type="String" />
                <asp:Parameter Name="UStandardUsage" Type="String" />
                <asp:Parameter Name="UStandardUsageUnit" Type="String" />
                <asp:Parameter Name="URemarks" Type="String" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:ObjectDataSource ID="odsBOM" runat="server" DataObjectTypeName="Entity.ProductionRouting+ProdRoutingStepBOM" TypeName="Entity.ProductionRouting+getStepProcessBOM" SelectMethod="getStepProcessBOM" InsertMethod="AddStepProcessBOM" UpdateMethod="UpdateStepProcessBOM" DeleteMethod="DeleteStepProcessBOM">
            <SelectParameters>
                <asp:Parameter Name="SKUCode" Type="String" />
                <asp:Parameter Name="StepSequence" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>

        <asp:SqlDataSource ID="sdsBOM1" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit="Connection_Init" 
            SelectCommand=""
            InsertCommand="INSERT INTO Production.ProdRoutingStepPackBOM (SKUCode, StepSequence, StepCode, ItemCode, Unit, ConsumptionPerProduct, TotalConsumption, PercentageAllowance, QtyAllowance, ClientSuppliedMaterial, EstimatedUnitCost, StandardUsage, StandardUsageUnit, Remarks, HeaderID)
             VALUES (@ISKUCode, @IStepSequence, @IStepCode, @IItemCode, @IUnit, @IConsumptionPerProduct, @ITotalConsumption, @IPercentageAllowance, @IQtyAllowance, @IClientSuppliedMaterial, @IEstimatedUnitCost, @IStandardUsage, @IStandardUsageUnit, @IRemarks, @IHeaderID)" 
            UpdateCommand="UPDATE Production.ProdRoutingStepPackBOM SET StepSequence=@UStepSequence, StepCode=@UStepCode, ItemCode=@UItemCode, Unit=@UUnit, ConsumptionPerProduct=@UConsumptionPerProduct, TotalConsumption=@UTotalConsumption, PercentageAllowance=@UPercentageAllowance, QtyAllowance=@UQtyAllowance, ClientSuppliedMaterial=@UClientSuppliedMaterial, EstimatedUnitCost=@UEstimatedUnitCost, StandardUsage=@UStandardUsage, StandardUsageUnit=@UStandardUsageUnit, Remarks=@URemarks WHERE RecordID=@ParamURecordID"
            DeleteCommand="DELETE Production.ProdRoutingStepPackBOM WHERE RecordID=@DRecordID">
            <InsertParameters>
                <asp:Parameter Name="IHeaderID" Type="String" />
                <asp:Parameter Name="ISKUCode" Type="String" />
                <asp:Parameter Name="IStepSequence" Type="String" />
                <asp:Parameter Name="IStepCode" Type="String" />
                <asp:Parameter Name="IItemCode" Type="String" />
                <asp:Parameter Name="IUnit" Type="String" />
                <asp:Parameter Name="IConsumptionPerProduct" Type="String" />
                <asp:Parameter Name="ITotalConsumption" Type="String" />
                <asp:Parameter Name="IPercentageAllowance" Type="String" />
                <asp:Parameter Name="IQtyAllowance" Type="String" />
                <asp:Parameter Name="IClientSuppliedMaterial" Type="String" />
                <asp:Parameter Name="IEstimatedUnitCost" Type="String" />
                <asp:Parameter Name="IStandardUsage" Type="String" />
                <asp:Parameter Name="IStandardUsageUnit" Type="String" />
                <asp:Parameter Name="IRemarks" Type="String" />
            </InsertParameters> 
            <UpdateParameters>
                <asp:Parameter Name="ParamURecordID" Type="String" />
                <asp:Parameter Name="UStepSequence" Type="String" />
                <asp:Parameter Name="UStepCode" Type="String" />
                <asp:Parameter Name="UItemCode" Type="String" />
                <asp:Parameter Name="UUnit" Type="String" />
                <asp:Parameter Name="UConsumptionPerProduct" Type="String" />
                <asp:Parameter Name="UTotalConsumption" Type="String" />
                <asp:Parameter Name="UPercentageAllowance" Type="String" />
                <asp:Parameter Name="UQtyAllowance" Type="String" />
                <asp:Parameter Name="UClientSuppliedMaterial" Type="String" />
                <asp:Parameter Name="UEstimatedUnitCost" Type="String" />
                <asp:Parameter Name="UStandardUsage" Type="String" />
                <asp:Parameter Name="UStandardUsageUnit" Type="String" />
                <asp:Parameter Name="URemarks" Type="String" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>

        <%-- Machine DataSource --%>
        <asp:SqlDataSource ID="sdsMachine" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" 
            SelectCommand=""
            InsertCommand="INSERT INTO Production.ProdRoutingStepMachine (SKUCode, StepSequence, StepCode, MachineType, Location, MachineRun, Unit, MachineCapacityQty, MachineCapacityUnit, CostPerUnit, HeaderID) VALUES (@ISKUCode, @IStepSequence, @IStepCode, @IMachineType, @ILocation, @IMachineRun, @IUnit, @IMachineCapacityQty, @IMachineCapacityUnit, @ICostPerUnit, @IHeaderID)" 
            UpdateCommand="UPDATE Production.ProdRoutingStepMachine SET StepSequence=@UStepSequence, StepCode=@UStepCode, MachineType=@UMachineType, Location=@ULocation, MachineRun=@UMachineRun, Unit=@UUnit, MachineCapacityQty=@UMachineCapacityQty, MachineCapacityUnit=@UMachineCapacityUnit, CostPerUnit=@UCostPerUnit WHERE RecordID=@ParamURecordID"
            DeleteCommand="DELETE Production.ProdRoutingStepMachine WHERE RecordID=@DRecordID">
            <InsertParameters>
                <asp:Parameter Name="IHeaderID" Type="String" />
                <asp:Parameter Name="ISKUCode" Type="String" />
                <asp:Parameter Name="IStepSequence" Type="String" />
                <asp:Parameter Name="IStepCode" Type="String" />
                <asp:Parameter Name="IMachineType" Type="String" />
                <asp:Parameter Name="ILocation" Type="String" />
                <asp:Parameter Name="IMachineRun" Type="String" />
                <asp:Parameter Name="IUnit" Type="String" />
                <asp:Parameter Name="IMachineCapacityQty" Type="String" />
                <asp:Parameter Name="IMachineCapacityUnit" Type="String" />
                <asp:Parameter Name="ICostPerUnit" Type="String" />
            </InsertParameters> 
            <UpdateParameters>
                <asp:Parameter Name="ParamURecordID" Type="String" />
                <asp:Parameter Name="UStepSequence" Type="String" />
                <asp:Parameter Name="UStepCode" Type="String" />
                <asp:Parameter Name="UMachineType" Type="String" />
                <asp:Parameter Name="ULocation" Type="String" />
                <asp:Parameter Name="UMachineRun" Type="String" />
                <asp:Parameter Name="UUnit" Type="String" />
                <asp:Parameter Name="UMachineCapacityQty" Type="String" />
                <asp:Parameter Name="UMachineCapacityUnit" Type="String" />
                <asp:Parameter Name="UCostPerUnit" Type="String" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:ObjectDataSource ID="odsMachine" runat="server" DataObjectTypeName="Entity.ProductionRouting+ProdRoutingStepMachine" TypeName="Entity.ProductionRouting+getStepProcessMachine" SelectMethod="getStepProcessMachine" InsertMethod="AddStepProcessMachine" UpdateMethod="UpdateStepProcessMachine" DeleteMethod="DeleteStepProcessMachine">
            <SelectParameters>
                <asp:QueryStringParameter Name="SKUCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="StepSequence" SessionField="StepSequence" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>

        <asp:SqlDataSource ID="sdsMachine1" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init" 
            SelectCommand=""
            InsertCommand="INSERT INTO Production.ProdRoutingStepPackMachine (SKUCode, StepSequence, StepCode, MachineType, Location, MachineRun, Unit, MachineCapacityQty, MachineCapacityUnit, CostPerUnit, HeaderID) VALUES (@ISKUCode, @IStepSequence, @IStepCode, @IMachineType, @ILocation, @IMachineRun, @IUnit, @IMachineCapacityQty, @IMachineCapacityUnit, @ICostPerUnit, @IHeaderID)" 
            UpdateCommand="UPDATE Production.ProdRoutingStepPackMachine SET StepSequence=@UStepSequence, StepCode=@UStepCode, MachineType=@UMachineType, Location=@ULocation, MachineRun=@UMachineRun, Unit=@UUnit, MachineCapacityQty=@UMachineCapacityQty, MachineCapacityUnit=@UMachineCapacityUnit, CostPerUnit=@UCostPerUnit WHERE RecordID=@ParamURecordID"
            DeleteCommand="DELETE Production.ProdRoutingStepPackMachine WHERE RecordID=@DRecordID">
            <InsertParameters>
                <asp:Parameter Name="IHeaderID" Type="String" />
                <asp:Parameter Name="ISKUCode" Type="String" />
                <asp:Parameter Name="IStepSequence" Type="String" />
                <asp:Parameter Name="IStepCode" Type="String" />
                <asp:Parameter Name="IMachineType" Type="String" />
                <asp:Parameter Name="ILocation" Type="String" />
                <asp:Parameter Name="IMachineRun" Type="String" />
                <asp:Parameter Name="IUnit" Type="String" />
                <asp:Parameter Name="IMachineCapacityQty" Type="String" />
                <asp:Parameter Name="IMachineCapacityUnit" Type="String" />
                <asp:Parameter Name="ICostPerUnit" Type="String" />
            </InsertParameters> 
            <UpdateParameters>
                <asp:Parameter Name="ParamURecordID" Type="String" />
                <asp:Parameter Name="UStepSequence" Type="String" />
                <asp:Parameter Name="UStepCode" Type="String" />
                <asp:Parameter Name="UMachineType" Type="String" />
                <asp:Parameter Name="ULocation" Type="String" />
                <asp:Parameter Name="UMachineRun" Type="String" />
                <asp:Parameter Name="UUnit" Type="String" />
                <asp:Parameter Name="UMachineCapacityQty" Type="String" />
                <asp:Parameter Name="UMachineCapacityUnit" Type="String" />
                <asp:Parameter Name="UCostPerUnit" Type="String" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>

        <%-- Manpower DataSource --%>
        <asp:SqlDataSource ID="sdsManpower" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init"
             SelectCommand=""
            InsertCommand="INSERT INTO Production.ProdRoutingStepManpower (SKUCode, StepSequence, StepCode, Designation, NoManpower, NoHour, StandardRate, StandardRateUnit, CostPerUnit, HeaderID) VALUES (@ISKUCode, @IStepSequence, @IStepCode, @IDesignation, @INoManpower, @INoHour, @IStandardRate, @IStandardRateUnit, @ICostPerUnit, @IHeaderID)" 
            UpdateCommand="UPDATE Production.ProdRoutingStepManpower SET StepSequence=@UStepSequence, StepCode=@UStepCode, Designation=@UDesignation, NoManpower=@UNoManpower, NoHour=@UNoHour, StandardRate=@UStandardRate, StandardRateUnit=@UStandardRateUnit, CostPerUnit=@UCostPerUnit WHERE RecordID=@ParamURecordID"
            DeleteCommand="DELETE Production.ProdRoutingStepManpower WHERE RecordID=@DRecordID">
            <InsertParameters>
                <asp:Parameter Name="IHeaderID" Type="String" />
                <asp:Parameter Name="ISKUCode" Type="String" />
                <asp:Parameter Name="IStepSequence" Type="String" />
                <asp:Parameter Name="IStepCode" Type="String" />
                <asp:Parameter Name="IDesignation" Type="String" />
                <asp:Parameter Name="INoManpower" Type="String" />
                <asp:Parameter Name="INoHour" Type="String" />
                <asp:Parameter Name="IStandardRate" Type="String" />
                <asp:Parameter Name="IStandardRateUnit" Type="String" />
                <asp:Parameter Name="ICostPerUnit" Type="String" />
            </InsertParameters> 
            <UpdateParameters>
                <asp:Parameter Name="ParamURecordID" Type="String" />
                <asp:Parameter Name="UStepSequence" Type="String" />
                <asp:Parameter Name="UStepCode" Type="String" />
                <asp:Parameter Name="UDesignation" Type="String" />
                <asp:Parameter Name="UNoManpower" Type="String" />
                <asp:Parameter Name="UNoHour" Type="String" />
                <asp:Parameter Name="UStandardRate" Type="String" />
                <asp:Parameter Name="UStandardRateUnit" Type="String" />
                <asp:Parameter Name="UCostPerUnit" Type="String" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:ObjectDataSource ID="odsManpower" runat="server" DataObjectTypeName="Entity.ProductionRouting+ProdRoutingStepManpower" TypeName="Entity.ProductionRouting+getStepProcessManpower" SelectMethod="getStepProcessManpower" InsertMethod="AddStepProcessManpower" UpdateMethod="UpdateStepProcessManpower" DeleteMethod="DeleteStepProcessManpower">
            <SelectParameters>
                <asp:QueryStringParameter Name="SKUCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="StepSequence" SessionField="StepSequence" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>

        <asp:SqlDataSource ID="sdsManpower1" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init"
            SelectCommand=""
            InsertCommand="INSERT INTO Production.ProdRoutingStepPackManpower (SKUCode, StepSequence, StepCode, Designation, NoManpower, NoHour, StandardRate, StandardRateUnit, CostPerUnit, HeaderID) VALUES (@ISKUCode, @IStepSequence, @IStepCode, @IDesignation, @INoManpower, @INoHour, @IStandardRate, @IStandardRateUnit, @ICostPerUnit, @IHeaderID)" 
            UpdateCommand="UPDATE Production.ProdRoutingStepPackManpower SET StepSequence=@UStepSequence, StepCode=@UStepCode, Designation=@UDesignation, NoManpower=@UNoManpower, NoHour=@UNoHour, StandardRate=@UStandardRate, StandardRateUnit=@UStandardRateUnit, CostPerUnit=@UCostPerUnit WHERE RecordID=@ParamURecordID"
            DeleteCommand="DELETE Production.ProdRoutingStepPackManpower WHERE RecordID=@DRecordID">
            <InsertParameters>
                <asp:Parameter Name="IHeaderID" Type="String" />
                <asp:Parameter Name="ISKUCode" Type="String" />
                <asp:Parameter Name="IStepSequence" Type="String" />
                <asp:Parameter Name="IStepCode" Type="String" />
                <asp:Parameter Name="IDesignation" Type="String" />
                <asp:Parameter Name="INoManpower" Type="String" />
                <asp:Parameter Name="INoHour" Type="String" />
                <asp:Parameter Name="IStandardRate" Type="String" />
                <asp:Parameter Name="IStandardRateUnit" Type="String" />
                <asp:Parameter Name="ICostPerUnit" Type="String" />
            </InsertParameters> 
            <UpdateParameters>
                <asp:Parameter Name="ParamURecordID" Type="String" />
                <asp:Parameter Name="UStepSequence" Type="String" />
                <asp:Parameter Name="UStepCode" Type="String" />
                <asp:Parameter Name="UDesignation" Type="String" />
                <asp:Parameter Name="UNoManpower" Type="String" />
                <asp:Parameter Name="UNoHour" Type="String" />
                <asp:Parameter Name="UStandardRate" Type="String" />
                <asp:Parameter Name="UStandardRateUnit" Type="String" />
                <asp:Parameter Name="UCostPerUnit" Type="String" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>

        <%-- OtherMaterial DataSource --%>
        <asp:SqlDataSource ID="sdsOtherMaterials" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" OnInit = "Connection_Init"
            SelectCommand=""
            InsertCommand="INSERT INTO Production.ProdRoutingOtherMaterials (SKUCode, ItemCode, StepCode, Unit, ConsumptionPerProduct, TotalConsumption, PercentageAllowance, QtyAllowance, ClientSuppliedMaterial, EstimatedUnitCost, StandardUsage, StandardUsageUnit, Remarks, HeaderID) VALUES (@ISKUCode, @IItemCode, @IStepCode, @IUnit, @IConsumptionPerProduct, @ITotalConsumption, @IPercentageAllowance, @IQtyAllowance, @IClientSuppliedMaterial, @IEstimatedUnitCost, @IStandardUsage, @IStandardUsageUnit, @IRemarks, @IHeaderID)" 
            UpdateCommand="UPDATE Production.ProdRoutingOtherMaterials SET ItemCode=@UItemCode, StepSequence=@UStepSequence, StepCode=@UStepCode, Unit=@UUnit, ConsumptionPerProduct=@UConsumptionPerProduct, TotalConsumption=@UTotalConsumption, PercentageAllowance=@UPercentageAllowance, QtyAllowance=@UQtyAllowance, ClientSuppliedMaterial=@UClientSuppliedMaterial, EstimatedUnitCost=@UEstimatedUnitCost, StandardUsage=@UStandardUsage, StandardUsageUnit=@UStandardUsageUnit, Remarks=@URemarks WHERE RecordID=@ParamURecordID"
            DeleteCommand="DELETE Production.ProdRoutingOtherMaterials WHERE RecordID=@DRecordID">
            <InsertParameters>
                <asp:Parameter Name="IHeaderID" Type="String" />
                <asp:Parameter Name="ISKUCode" Type="String" />
                <asp:Parameter Name="IItemCode" Type="String" />
                <%--<asp:Parameter Name="IStepSequence" Type="String" />--%>
                <asp:Parameter Name="IStepCode" Type="String" />
                <asp:Parameter Name="IUnit" Type="String" />
                <asp:Parameter Name="IConsumptionPerProduct" Type="String" />
                <asp:Parameter Name="ITotalConsumption" Type="String" />
                <asp:Parameter Name="IPercentageAllowance" Type="String" />
                <asp:Parameter Name="IQtyAllowance" Type="String" />
                <asp:Parameter Name="IClientSuppliedMaterial" Type="String" />
                <asp:Parameter Name="IEstimatedUnitCost" Type="String" />
                <asp:Parameter Name="IStandardUsage" Type="String" />
                <asp:Parameter Name="IStandardUsageUnit" Type="String" />
                <asp:Parameter Name="IRemarks" Type="String" />
            </InsertParameters> 
            <UpdateParameters>
                <asp:Parameter Name="ParamURecordID" Type="String" />
                <asp:Parameter Name="UItemCode" Type="String" />
                <%--<asp:Parameter Name="UStepSequence" Type="String" />--%>
                <asp:Parameter Name="UStepCode" Type="String" />
                <asp:Parameter Name="UUnit" Type="String" />
                <asp:Parameter Name="UConsumptionPerProduct" Type="String" />
                <asp:Parameter Name="UTotalConsumption" Type="String" />
                <asp:Parameter Name="UPercentageAllowance" Type="String" />
                <asp:Parameter Name="UQtyAllowance" Type="String" />
                <asp:Parameter Name="UClientSuppliedMaterial" Type="String" />
                <asp:Parameter Name="UEstimatedUnitCost" Type="String" />
                <asp:Parameter Name="UStandardUsage" Type="String" />
                <asp:Parameter Name="UStandardUsageUnit" Type="String" />
                <asp:Parameter Name="URemarks" Type="String" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="DRecordID" Type="String" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <asp:ObjectDataSource ID="odsOtherMaterials" runat="server" DataObjectTypeName="Entity.ProductionRouting+ProdRoutingOtherMaterial" TypeName="Entity.ProductionRouting+getOtherMaterial" SelectMethod="getOtherMaterial" InsertMethod="AddOtherMaterial" UpdateMethod="UpdateOtherMaterial" DeleteMethod="DeleteOtherMaterial">
            <SelectParameters>
                <asp:QueryStringParameter Name="SKUCode" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
            </SelectParameters>
        </asp:ObjectDataSource>
    </form>
</body>
</html>
