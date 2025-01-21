<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmTaxRecording.aspx.cs" Inherits="GWL.frmTaxRecording" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <title>Tax Recording</title>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 800px; /*Change this whenever needed*/
        }

        .Entry {
            /*width: 1280px;*/ /*Change this whenever needed*/
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
            /*border-radius: 10px;
            -webkit-border-radius: 10px;
            -moz-border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
            -moz-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
            -webkit-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);*/
        }

        /*.dxeButtonEditSys input,
        .dxeTextBoxSys input{
            text-transform:uppercase;
        }*/

        .uppercase .dxeEditAreaSys
        {
            text-transform: uppercase;
        }

        .pnl-content
        {
            text-align: right;
        }
    </style>
    <!--#endregion-->
    <script>
        var isValid = true;
        var entry = getParameterByName('entry');

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
            if ((s.GetText() == "" || e.value == "" || e.value == null)) {
                isValid = false;
            }
        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        function OnUpdateClick(s, e) {  
            var btnmode = btn.GetText();   
            if (btnmode == "Close") {
                cp.PerformCallback("Close");
            }
        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        function OnEndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);
                location.reload();
            }
            else if (s.cp_message != null) {
                alert(s.cp_message);
                delete (s.cp_message);
            }
            if (s.cp_close) { 
                delete (cp_close);
                window.close();  
            } 
        }

        var index;
        var currentColumn = null;
        var fieldnamecolumn;
        function OnStartEditing(s, e) { 
            index = e.visibleIndex;
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[currentColumn.index];
            var fieldnamecolumn = e.focusedColumn.fieldName;

            var IsSelected = s.GetColumnByField("SelectData");
            console.log(e.rowValues[IsSelected.index].value);
            if (e.focusedColumn.fieldName == "SelectData") {
                e.cancel = false;
            }
            else if (e.rowValues[IsSelected.index].value == "False") {
                e.cancel = true;
            }
            else {  
                if (e.focusedColumn.fieldName != "InvoiceNo"  && e.focusedColumn.fieldName != "ATC" &&
                    e.focusedColumn.fieldName != "WTaxBase" && e.focusedColumn.fieldName != "WTaxAmount")  
                    e.cancel = true; 
                else 
                    e.cancel = false; 
            } 
            if (e.focusedColumn.fieldName === "ATC") {
                glATC.GetInputElement().value = cellInfo.value;
            }
        }
         
        function OnEndEditing(s, e) {
            var cellInfo = e.rowValues[currentColumn.index];
            if (currentColumn.fieldName === "ATC") {
                cellInfo.value = glATC.GetValue();
                cellInfo.text = glATC.GetText().toUpperCase();
            }
        }

        function OnGetRowValues(values) {
            txtSupplierDesc.SetText(values);
        }

        function OnGetRowValuesATC(values) {
            gv1.batchEditApi.SetCellValue(index, "ATCRate", values * 100); 
            autocalculate();
        }

        function gridLookup_KeyDown(s, e) { 
            isSetTextRequired = false;
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode !== ASPxKey.Tab) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            var moveActionNameUpDown = e.htmlEvent.shiftKey ? "MoveFocusUp" : "MoveFocusDown";
            if (gv1.batchEditApi[moveActionName]() || gv1.batchEditApi[moveActionNameUpDown]()) {
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
            autocalculate();
        }


        function autocalculate(s, e) {
            gv1.batchEditApi.EndEdit();
            var totalamount = 0.0000;
            var totalwbase = 0.0000;
            var totalwtax = 0.0000;
            var totalamountgrid = 0.0000;   
            var totalwbasegrid = 0.0000;
            var totalwtaxgrid = 0.0000;


            var totalwbase2 = 0.0000;
            var atcrate = 0.00;
            var finalcompwtax = 0.0000;

            if (gv1.batchEditApi.GetCellValue(index, "SelectData") == "True" ||
                gv1.batchEditApi.GetCellValue(index, "SelectData") == true) {
                totalwbase2 = gv1.batchEditApi.GetCellValue(index, "WTaxBase");
                atcrate = (gv1.batchEditApi.GetCellValue(index, "ATCRate") / 100);
                finalcompwtax = atcrate * totalwbase2;
                gv1.batchEditApi.SetCellValue(index, "WTaxAmount", finalcompwtax);
            }
            else {
                gv1.batchEditApi.SetCellValue(index, "WTaxAmount", 0);
                gv1.batchEditApi.SetCellValue(index, "WTaxBase", 0);
            }

            gv1.batchEditApi.EndEdit();
            
            setTimeout(function () { 
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();  
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.GetCellValue(indicies[i], "SelectData") == "True" ||
                        gv1.batchEditApi.GetCellValue(indicies[i], "SelectData") == true) {
                        totalamount = gv1.batchEditApi.GetCellValue(indicies[i], "TotalAmount");
                        totalwbase = gv1.batchEditApi.GetCellValue(indicies[i], "WTaxBase");
                        totalwtax = gv1.batchEditApi.GetCellValue(indicies[i], "WTaxAmount"); 
                        totalamountgrid += totalamount;
                        totalwbasegrid += totalwbase;
                        totalwtaxgrid += totalwtax;
                    }
                } 
                txtTotalAmount.SetValue(totalamountgrid);
                txtTotWithTaxBase.SetValue(totalwbasegrid);
                txtTotWithTaxAmount.SetValue(totalwtaxgrid);

            }, 500);
        }


        function autocalculateXXX(s, e) {
            gv1.batchEditApi.EndEdit();
            var totalamount = 0.0000;
            var totalwbase = 0.0000;
            var totalwtax = 0.0000;
            var totalamountgrid = 0.0000;
            var totalwbasegrid = 0.0000;
            var totalwtaxgrid = 0.0000; 

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.GetCellValue(indicies[i], "SelectData") == "True" ||
                        gv1.batchEditApi.GetCellValue(indicies[i], "SelectData") == true) {
                        totalamount = gv1.batchEditApi.GetCellValue(indicies[i], "TotalAmount");
                        totalwbase = gv1.batchEditApi.GetCellValue(indicies[i], "WTaxBase");
                        totalwtax = gv1.batchEditApi.GetCellValue(indicies[i], "WTaxAmount");
                        totalamountgrid += totalamount;
                        totalwbasegrid += totalwbase;
                        totalwtaxgrid += totalwtax;
                    }
                }
                txtTotalAmount.SetValue(totalamountgrid);
                txtTotWithTaxBase.SetValue(totalwbasegrid);
                txtTotWithTaxAmount.SetValue(totalwtaxgrid);

            }, 500);
        }
    </script>
    <!--#endregion-->
</head>

<body style="height: 1065px; width: 1050px">
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel ID="FormTitle" runat="server" Text="Tax Recording" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="565px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="OnEndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="_FormLayout" runat="server" Height="565px" Width="1050px" style="margin-left: -3px" ClientInstanceName="frmlayout">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                          <%--<!--#region Region Header --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2" Width="1050px">
                                        <Items>
                                            
                                            <dx:LayoutItem Caption="Date Range">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <dx:ASPxDateEdit ID="dtpDateFrom" runat="server" OnLoad="Date_Load" Width="140px">
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                                                            <RequiredField IsRequired="True" ErrorText="Please specify a valid date"/>
                                                                        </ValidationSettings>
                                                                        <InvalidStyle BackColor="Pink" />
                                                                    </dx:ASPxDateEdit>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPXLabel ID="ASPxDateEdit1" runat="server" Text="to" Width="10px" HorizontalAlign="Left">
                                                                    </dx:ASPXLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPXLabel ID="ASPXLabel2" runat="server" Width="25px" HorizontalAlign="Left">
                                                                    </dx:ASPXLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxDateEdit ID="dtpDateTo" runat="server" OnLoad="Date_Load" Width="140px">
                                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                                                            <RequiredField IsRequired="True" ErrorText="Please specify a valid date"/>
                                                                        </ValidationSettings>
                                                                        <InvalidStyle BackColor="Pink" />
                                                                    </dx:ASPxDateEdit>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Total Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPXSpinEdit ID="speTotalAmount" ClientInstanceName="txtTotalAmount" runat="server" ReadOnly="true"
                                                            Width="170px" CssClass="uppercase" DisplayFormatString="N2" SpinButtons-ShowIncrementButtons="false" > 
                                                        </dx:ASPXSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                           
                                            <dx:LayoutItem Caption="Supplier">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <dx:ASPxGridLookup ID="glSupplierCode" ClientInstanceName="glSupplierCode" runat="server" DataSourceID="sdsSupplier" KeyFieldName="SupplierCode" TextFormatString="{0}" Width="141px">
                                                                        <GridViewProperties>
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                            <Settings ShowFilterRow="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Address" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="TIN" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents ValueChanged="function(s,e){ var g = glSupplierCode.GetGridView();
                                                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'Name', OnGetRowValues);}" /> 
                                                                        <ClientSideEvents  Validation="OnValidation"/>
                                                                        <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                            <RequiredField IsRequired="True" />
                                                                        </ValidationSettings>
                                                                        <InvalidStyle BackColor="Pink"></InvalidStyle>
                                                                    </dx:ASPxGridLookup> 
                                                                </td>
                                                                <td>
                                                                    <dx:ASPXLabel ID="ASPXLabel4" runat="server" Width="1px" HorizontalAlign="Left">
                                                                    </dx:ASPXLabel>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPxTextBox ID="txtSupplierDesc" runat="server" ReadOnly="true"
                                                                        ClientInstanceName="txtSupplierDesc" Width="200px" CssClass="uppercase" >
                                                                    </dx:ASPxTextBox>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            
                                            <dx:LayoutItem Caption="Total with Tax Base">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPXSpinEdit ID="speTotWithTaxBase" ClientInstanceName="txtTotWithTaxBase" runat="server" ReadOnly="true"
                                                            Width="170px" CssClass="uppercase" DisplayFormatString="N2" SpinButtons-ShowIncrementButtons="false" > 
                                                        </dx:ASPXSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <table>
                                                            <tr>
                                                                <td>
		                                                            <dx:ASPxButton ID="btnGenerate" runat="server" AutoPostBack="False" Width="170px" Theme="MetropolisBlue" Text="Generate AP Record" >
                                                                        <ClientSideEvents Click="function(s, e) { cp.PerformCallback('GenerateAP'); autocalculate(); }" />
                                                                    </dx:ASPxButton>
                                                                </td>
                                                                <td>
                                                                    <dx:ASPXLabel ID="ASPXLabel3" runat="server" Width="2px" HorizontalAlign="Left">
                                                                    </dx:ASPXLabel>
                                                                </td>
                                                                <td>
                                                                     <dx:ASPxButton ID="btnCreate" runat="server" AutoPostBack="False" Width="170px" Theme="Metropolis" Text="Create AP Record" >
                                                                        <ClientSideEvents Click="function(s, e) { cp.PerformCallback('CreateAP') }" />
                                                                    </dx:ASPxButton>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Total with Tax Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPXSpinEdit ID="speTotWithTaxAmount" ClientInstanceName="txtTotWithTaxAmount" runat="server" ReadOnly="true"
                                                            Width="170px" CssClass="uppercase" DisplayFormatString="N2" SpinButtons-ShowIncrementButtons="false" > 
                                                        </dx:ASPXSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>  

                                            <dx:LayoutItem Caption="" Border-BorderStyle="None" Width="900px" Paddings-PaddingLeft="0px" ColSpan="1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server"> 
                                                        <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" ClientInstanceName="gv1" 
                                                        Width="985px" KeyFieldName="APNo" OnRowValidating="grid_RowValidating" OnBatchUpdate="CreateAPMemo_BatchUpdate" Styles-Header-HorizontalAlign="Center">
                                                        <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="Control" AllowSelectByRowClick="true" />
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" />
                                                        <SettingsPager Mode="ShowAllRecords"/><SettingsEditing Mode="Batch" /> 
                                                        <Settings ColumnMinWidth="50" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" ShowStatusBar="Hidden" /> 
                                                        <Columns>
                                                                <dx:GridViewDataCheckColumn FieldName="SelectData" Name="SelectData" ShowInCustomizationForm="True" VisibleIndex="1" Caption="#" Width="60px" Settings-AllowDragDrop="False">
                                                                    <PropertiesCheckEdit ClientInstanceName="IsSelected" AllowGrayedByClick="true" >
                                                                        <ClientSideEvents CheckedChanged="function(s,e){ gv1.batchEditApi.EndEdit(); autocalculate(); }" />
                                                                    </PropertiesCheckEdit>
                                                                    <HeaderStyle VerticalAlign="Middle" Wrap="True" HorizontalAlign="Center"/>                                                            
                                                                </dx:GridViewDataCheckColumn>
                                                                <dx:GridViewDataTextColumn FieldName="APNo" VisibleIndex="2" Width="100px"/>
                                                                <dx:GridViewDataDateColumn FieldName="DocDate" VisibleIndex="3" Width="80px"/>
                                                                <dx:GridViewDataTextColumn FieldName="RefNo" VisibleIndex="5" Width="180px"/>
                                                                <dx:GridViewDataSpinEditColumn FieldName="TotalAmount" VisibleIndex="6" Width="110px" >
                                                                    <CellStyle HorizontalAlign="Right" /> 
                                                                    <PropertiesSpinEdit DisplayFormatString="N2" />
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataTextColumn FieldName="InvoiceNo" VisibleIndex="7" Width="100px" />
                                                                <dx:GridViewDataSpinEditColumn FieldName="WTaxBase" VisibleIndex="8" Width="90px" PropertiesSpinEdit-DisplayFormatString="N2" >
                                                                    <PropertiesSpinEdit><ClientSideEvents ValueChanged="autocalculate" /></PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="WTaxAmount" VisibleIndex="9" Width="90px" PropertiesSpinEdit-DisplayFormatString="N2" >
                                                                    <PropertiesSpinEdit><ClientSideEvents ValueChanged="autocalculateXXX" /></PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                                <dx:GridViewDataTextColumn FieldName="ATC" VisibleIndex="10" Width="80px" Caption="ATC">   
                                                                      <EditItemTemplate>
                                                                        <dx:ASPxGridLookup ID="glATC" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                            KeyFieldName="ATCCode" DataSourceID="sdsATC" ClientInstanceName="glATC" TextFormatString="{0}" Width="80px">
                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="ATCCode" ReadOnly="True" VisibleIndex="0">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Rate" ReadOnly="True" VisibleIndex="2">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                            <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" CloseUp="gridLookup_CloseUp"/>
                                                                            <ClientSideEvents ValueChanged="function(s,e){ var g = glATC.GetGridView();
                                                                                                        g.GetRowValues(g.GetFocusedRowIndex(), 'Rate', OnGetRowValuesATC);
                                                                                                        autocalculate(); }" /> 
                                                                        </dx:ASPxGridLookup>
                                                                    </EditItemTemplate>
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataSpinEditColumn FieldName="ATCRate" VisibleIndex="11" Width="70px" />
                                                            </Columns>
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                           </dx:TabbedLayoutGroup>
                           <%-- <!--#endregion --> --%>
                        </Items>
                    </dx:ASPxFormLayout>
                    <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content"> 
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
                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Are you sure you want to delete this specific document?" />
                    <table>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                           <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                             <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                             </dx:ASPxButton></td>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                             <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                             </dx:ASPxButton> </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
    </form>

    <!--#region Region Datasource-->
    <%-- put all datasource codeblock here --%>
    <asp:SqlDataSource ID="sdsSupplier" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT B.SupplierCode, 
        B.Name, B.Address, TIN FROM Masterfile.BPSupplierInfo B 
        INNER JOIN Masterfile.BizPartner C on B.SupplierCode = C.BizPartnerCode
        WHERE ISNULL(B.IsInactive,0)=0 and ISNULL(C.IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ForInit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsATC" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ATCCode, Description, Rate FROM Masterfile.ATC WHERE ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    
    <asp:SqlDataSource ID="sdsCheckDetail" runat="server" 
        SelectCommand=" DECLARE @ATCCode VARCHAR(20), @ATCRate DECIMAL(15,2)

                        SELECT @ATCCode = A.ATCCode, @ATCRate = ISNULL(B.Rate,0) 
                        FROM Masterfile.BPSupplierInfo A 
                        INNER JOIN Masterfile.ATC B
                        ON A.ATCCode = b.ATCCode
                        WHERE SupplierCode = @SupplierCode 

                        SELECT 'True' AS SelectData,
                               A.DocNumber AS APNo,
                               DocDate,
                               SUBSTRING(ReferenceNumber, 0, LEN(ReferenceNumber) - LEN(LEFT(ReferenceNumber, CHARINDEX ('/', ReferenceNumber))) - LEN(RIGHT(ReferenceNumber, LEN(ReferenceNumber) - CHARINDEX (':', ReferenceNumber)))) AS RefNo,
                               TotalAPAmount AS TotalAmount,
                               '' AS InvoiceNo,
                               0.00 AS WTaxBase,
                               0.00 AS WTaxAmount,
                               @ATCCode AS ATC,
                               ISNULL(@ATCRate,0) * 100 AS ATCRate
                        INTO #TER FROM Accounting.APVoucher A
                        INNER JOIN Accounting.APVoucherDetail B
                        ON A.DocNumber = B.DocNumber
	                    WHERE DocDate BETWEEN @DateFrom AND @DateTo
                        AND SupplierCode = @SupplierCode  
                        ORDER BY DocDate DESC ,A.DocNumber DESC
                        
                        SELECT A.*, B.DocNumber 
                        INTO #LEO FROM #TER A 
                        LEFT JOIN Accounting.APMemo B
                        ON A.APNo = B.ReferenceDocnumber
                        
                        SELECT SelectData, APNo, DocDate, RefNo, 
							   TotalAmount, InvoiceNo, WTaxBase, 
							   WTaxAmount, ATC, ATCRate 
						FROM #LEO WHERE DocNumber IS NULL
                        
                        DROP TABLE #LEO, #TER" 
        OnInit="Connection_Init">
        <SelectParameters>
            <asp:Parameter Name="SupplierCode" Type="String" DefaultValue="???"/>
            <asp:Parameter Name="DateFrom" Type="DateTime"/>
            <asp:Parameter Name="DateTo" Type="DateTime"/>
        </SelectParameters>
    </asp:SqlDataSource> 
    <!--#endregion-->
</body>
</html>


