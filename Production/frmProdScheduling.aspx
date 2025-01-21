<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmProdScheduling.aspx.cs" Inherits="GWL.Production.frmProdScheduling" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
<title>Production Scheduling</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
                  #form1 {
            height: 600px; /*Change this whenever needed*/
            }

            .Entry {
             padding: 20px;
             margin: 10px auto;
             background: #FFF;
            }

            .invalidlength *
            {
                background-color:#FFCCCC !important;
            }

            .validlength
            {
                background-color:transparent; 
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
               console.log(s.GetText());
               console.log(e.value);
           }
           else {
               isValid = true;
           }
       }

       function OnUpdateClick(s, e) { //Add/Edit/Close button function
           counterror = 0;
           //var btnmode = btn.GetText(); //gets text of button
           var indicies = gvSteps.batchEditApi.GetRowVisibleIndices();
           for (var i = 0; i < indicies.length; i++) {
               if (gvSteps.batchEditApi.IsNewRow(indicies[i])) {
                   var ss = "";
               }
               else {
                   var key = gvSteps.GetRowKey(indicies[i]);
                   if (gvSteps.batchEditApi.IsDeletedRow(key))
                       var as = "";
                   else {
                       gvSteps.batchEditApi.ValidateRow(indicies[i]);
                       gvSteps.batchEditApi.StartEdit(indicies[i], 9);
                   }
               }
           }
           //gvSteps.batchEditApi.StartEdit(0, gvSteps.GetColumnByField("DateCommitted").index);
           console.log(counterror)
           if (counterror > 0) {
               alert("Please check fields!");
           }
           else {
               cp.PerformCallback('Update');
           }
       }

       function OnConfirm(s, e) {//function upon saving entry
           if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
               e.cancel = true;
       }

       function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
           if (s.cp_success) {
               if (s.cp_valmsg != null && s.cp_valmsg != "" && s.cp_valmsg != undefined) {
                   alert(s.cp_valmsg);
               }
               alert(s.cp_message);
               delete (s.cp_valmsg);
               delete (s.cp_success);//deletes cache variables' data
               delete (s.cp_message);

           }
           if (s.cp_popup) {
               DatePop.Show();
               delete (s.cp_popup);
           }

           if (s.cp_close) {
               if (s.cp_message != null) {
                   alert(s.cp_message);
                   delete (s.cp_message);
               }
               if (s.cp_valmsg != null && s.cp_valmsg != "" && s.cp_valmsg != undefined) {
                   alert(s.cp_valmsg);
                   delete (s.cp_valmsg);
               }
               if (glcheck.GetChecked()) {
                   delete (cp_close);
                   window.location.reload();
               }
               else {
                   delete (cp_close);
                   window.close();//close window if callback successful
               }
           }
           if (s.cp_delete) {
               delete (cp_delete);
               DeleteControl.Show();
           }
       }

       var itemc; //variable required for lookup
       var currentColumn = null;
       var isSetTextRequired = false;
       var linecount = 1;
       var index;
       function OnStartEditing(s, e) {//On start edit grid function     
           index = e.visibleIndex;

           //if (e.focusedColumn.fieldName !== "TargetDateIn" && e.focusedColumn.fieldName !== "TargetDateOut") {
           //    e.cancel = true;
           //}
       }

       function getParameterByName(name) {
           name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
           var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
               results = regex.exec(location.search);
           return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
       }

       function OnCustomClick(s, e) {
           if (e.buttonID == "Details") {
               var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
               var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
               var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
               var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
               factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
               + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode);
           }
           if (e.buttonID == "CountSheet") {
               CSheet.Show();
               var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
               var docnumber = getParameterByName('docnumber');
               var transtype = getParameterByName('transtype');
               var entry = getParameterByName('entry');
               CSheet.SetContentUrl('frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
                   '&linenumber=' + linenum);
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
           gvLoaded.SetWidth(width - 120);
           gvUnloaded.SetWidth(width - 120);
       }

       function autocalculate() {
           var mach = 0;
           var op = 0;
           var shift = 0;
           var util = 0;
           var sam = 0;
           var daily = 0;
           var day = 0;
           var daily = 0;

           mach = txtMachine.GetText();
           op = txtOPHours.GetText();
           shift = txtShift.GetText();
           util = txtUtil.GetText();
           sam = txtSAM.GetText();
           day = txtDays.GetText();

           util = parseFloat(util) / 100.00;

           txtDaily.SetValue((mach * op * shift * util) / sam);
           daily = txtDaily.GetText();
           txtWeekly.SetValue(day * daily);

       }

       function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
           for (var i = 0; i < gvSteps.GetColumnsCount() ; i++) {
               var column = s.GetColumn(i);
               var date;
               if (column.fieldName == "TargetDateIn") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                   var cellValidationInfo = e.validationInfo[column.index];
                   if (!cellValidationInfo) continue;
                   var value = cellValidationInfo.value;
                   date = value;
               }
               if (column.fieldName == "TargetDateOut") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                   var cellValidationInfo = e.validationInfo[column.index];
                   if (!cellValidationInfo) continue;
                   var value = cellValidationInfo.value;
                   CheckDifference(Date.parse(convert(value)),Date.parse(convert(date)));
                   if (!isValid2) {
                       cellValidationInfo.isValid = isValid2;
                       cellValidationInfo.errorText = "TargetDateOut must not be less than TargetDateIn";
                       isValid = isValid2;
                       counterror++;
                   }
               }
           }
       }

       function convert(str) {
           var date = new Date(str),
               mnth = ("0" + (date.getMonth() + 1)).slice(-2),
               day = ("0" + date.getDate()).slice(-2);
           return [mnth, day, date.getFullYear()].join("/");
       }

       var arrayGrid = new Array();
       var isValid2 = false;
       var Okay = true;
       var isValid3 = true;
       function checkGrid() {
           var indicies = gvSteps.batchEditApi.GetRowVisibleIndices();
           var Keyfield;
           var errormsg = "";
           for (var i = 0; i < indicies.length; i++) {
                   var key = gvSteps.GetRowKey(indicies[i]);
                   if (!gvSteps.batchEditApi.IsDeletedRow(key)) {
                       Keyfield = gvSteps.batchEditApi.GetCellValue(indicies[i], "TargetDateOut") + '|' + gvSteps.batchEditApi.GetCellValue(indicies[i], "TargetDateIn");
                       step = gvSteps.batchEditApi.GetCellValue(indicies[i], "Stepcode");
                       sequence = gvSteps.batchEditApi.GetCellValue(indicies[i], "Sequence");
                       if (i == 0) {
                           arrayGrid.push(Keyfield);
                       }
                       else {
                           //console.log(arrayGrid[0]);
                           var check1 = arrayGrid[0].split('|');
                           var check2 = Keyfield.split('|');
                           //console.log(convert(check1[1]), convert(check2[1]));
                           if (!isNaN(Date.parse(convert(check2[1]))) && check2[1] != "null")
                               CheckDifference2(Date.parse(convert(check1[1])), Date.parse(convert(check2[1])));

                           //console.log(Date.parse(convert(check1[1])), Date.parse(convert(check2[1])));
                           if (isValid3 == false) {
                               errormsg += sequence + ":" + step + "'s TargetDateIn must not be less than the previous step's TargetDateIn. \n";
                               //console.log('here');
                           }

                           isValid3 = true;

                           //console.log(Date.parse(convert(check1[0])), Date.parse(convert(check2[0]))); if(check2[0] != "null")
                           if (!isNaN(Date.parse(convert(check2[0]))) && check2[0] != "null")
                               CheckDifference2(Date.parse(convert(check1[0])), Date.parse(convert(check2[0])));

                           if (isValid3 == false) {
                               errormsg += sequence + ":" + step + "'s TargetDateOut must not be less than the previous step's TargetDateOut. \n";
                               //console.log('here');
                           }

                           isValid3 = true;
                           arrayGrid = [];
                           arrayGrid.push(Keyfield);
                       }
                       
                       gvSteps.batchEditApi.ValidateRow(indicies[i]);
                   }
           }
           //console.log(errormsg);
           if (errormsg == "") {
               Okay = true;
           }
           else {
               alert(errormsg);
               errormsg = null;
               Okay = false;
           }
           arrayGrid = [];
       }

       function CheckDifference(date, date2) {
           //console.log("date:", date, date2);
           if (date != "" && date2 != "") {
               var startDate = new Date();
               var endDate = new Date();
               var difference = -1;
               startDate = date2;
               if (startDate != null) {
                   endDate = date;
                   //var startTime = startDate.getTime();
                   //var endTime = endDate.getTime();
                   difference = (endDate - startDate) / 86400000;
               }
               if (difference >= 0) {
                   isValid2 = true;
               }
               else {
                   isValid2 = false;
               }
           }
       }

       function CheckDifference2(date, date2) {
           //console.log("date:", date, date2);
           if (date != "" && date2 != "") {
               var startDate = new Date();
               var endDate = new Date();
               var difference = -1;
               startDate = date2;
               if (startDate != null) {
                   endDate = date;
                   //var startTime = startDate.getTime();
                   //var endTime = endDate.getTime();
                   difference = (endDate - startDate) / 86400000;
                   console.log(difference);
               }
               if (difference <= 0) {
                   isValid3 = true;
               }
               else {
                   isValid3 = false;
               }
           }
       }
        
       function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode == 13) {
               cp.PerformCallback("Filter");
           }
           //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
       }
    </script>
    <!--#endregion-->
</head>
<body style="height: 1350px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Production Scheduling" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <%--<!--#region Region Factbox --> --%><%--<!--#endregion --> --%>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="600px" Width="550px" Style="margin-left: -3px; margin-right: 0px;">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="JO Step Loaded to WC" ColCount="4">
                                        <Items> 
                                            <dx:LayoutGroup ShowCaption="false" ColCount="4">
                                                <Items>
                                                    <dx:LayoutItem Caption="Work Center">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtWorkCenter" runat="server" DataSourceID="Masterfilebiz"  Width="220px"
                                                                     KeyFieldName="SupplierCode" AutoGenerateColumns="false" TextFormatString="{0}" GridViewProperties-Settings-ShowFilterRow="true">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" FilterRowMode="OnClick" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                         <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="True" VisibleIndex="0" >
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                 </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" >
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                 </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Address" ReadOnly="True" VisibleIndex="2" >
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                 </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Step">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtStep" runat="server" DataSourceID="MasterfileStep"  Width="220px"
                                                                     KeyFieldName="StepCode" AutoGenerateColumns="false" TextFormatString="{0}" GridViewProperties-Settings-ShowFilterRow="true">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" FilterRowMode="OnClick" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="StepCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem> 
                                                    <dx:LayoutItem Caption="Job Order">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtJO" runat="server" DataSourceID="JobOrder" Width="220px"
                                                                AutoGenerateColumns="false" TextFormatString="{0}" ClientInstanceName="glJO" KeyFieldName="DocNumber;StepCode;WorkCenter"  GridViewProperties-Settings-ShowFilterRow="true">
                                                                    <ClientSideEvents ValueChanged="function(s,e){
                                                                        var g = glJO.GetGridView(); 
                                                                        cp.PerformCallback('JO|'+g.GetRowKey(g.GetFocusedRowIndex()));
                                                                    }" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn Caption="Job Order No" ReadOnly="true" FieldName="DocNumber" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Work Center" ReadOnly="true" FieldName="WorkCenter" ShowInCustomizationForm="True" VisibleIndex="2" Width="50px">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="StepCode" ReadOnly="true" FieldName="StepCode" ShowInCustomizationForm="True" VisibleIndex="3" Width="50px">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>                                         
                                                    <dx:LayoutItem Caption="Include Unsubmitted Transactions">
                                                          <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxCheckBox ID="cbInclude" runat="server" CheckState="Unchecked">
                                                                    </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server" Width="220px" >
                                                                <dx:ASPxButton ID="btnGenerate" runat="server" Text="Generate" Width="296px"
                                                                    ClientInstanceName="cbGenerate" UseSubmitBehavior="false" AutoPostBack="false">
                                                                    <ClientSideEvents Click="function(){
                                                                        cp.PerformCallback('Generate');
                                                                        }" />
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem ShowCaption="True" Caption="Filter By">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server" Width="220px">
                                                                <dx:ASPxComboBox ID="cbFilter" runat="server" Width="220px">
                                                                    <Items>
                                                                        <dx:ListEditItem Selected="true" Text="DocNumber" Value="DocNumber" />
                                                                        <dx:ListEditItem Text="Stockcode" Value="Stockcode" />
                                                                        <dx:ListEditItem Text="CustomerCode" Value="CustomerCode" />
                                                                    </Items>
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="" ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtFilter" runat="server" Width="281px">
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvLoaded" runat="server" ClientSideEvents-ColumnStartDragging="false"
                                                                    ClientInstanceName="gvLoaded" Width="742px" KeyFieldName="No"
                                                                    OnDataBound="gvUnloaded_DataBound" SettingsBehavior-AllowSort="false">
                                                                    <ClientSideEvents Init="OnInitTrans" />
                                                                    <Settings HorizontalScrollBarMode="Visible"
                                                                    VerticalScrollBarMode="Visible" 
                                                                    VerticalScrollableHeight="240"
                                                                      />
                                                                    <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                    <SettingsBehavior AllowSelectByRowClick="true"/>
                                                                    <Settings HorizontalScrollBarMode="Visible" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="No" ShowInCustomizationForm="True" Visible="True" VisibleIndex="0" Width="40px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="JONumber" ShowInCustomizationForm="True" Visible="True" VisibleIndex="1" Width="110px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CustomerCode" ShowInCustomizationForm="True" Visible="True" VisibleIndex="1" Width="110px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Status" ShowInCustomizationForm="True" Visible="True" VisibleIndex="2" Width="80px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Stockcode" ShowInCustomizationForm="True" Visible="True" VisibleIndex="3" Width="180px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="DueDate" ShowInCustomizationForm="True" Visible="True" VisibleIndex="4" Width="100px">
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Stepcode" ShowInCustomizationForm="True" Visible="True" VisibleIndex="5" Width="110px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="JOQty" ShowInCustomizationForm="True" Visible="True" VisibleIndex="6" Width="80px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="TargetDateIn" ShowInCustomizationForm="True" Visible="True" VisibleIndex="7" Width="100px">
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="TargetDateOut" ShowInCustomizationForm="True" Visible="True" VisibleIndex="8" Width="100px">
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="WorkCenter" ShowInCustomizationForm="True" Visible="True" VisibleIndex="9" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="RecordID" ShowInCustomizationForm="True" Visible="True" VisibleIndex="10" Width="0px">
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
                                    
                                    <dx:LayoutGroup Caption="JO Step Unloaded to WC" ColCount="4">
                                        <Items>
                                            <dx:LayoutGroup ShowCaption="false" ColCount="4">
                                                <Items>
                                                    <dx:LayoutItem ShowCaption="True" Caption="Filter By">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox ID="cbFilter2" runat="server" Width="220px">
                                                                    <Items>
                                                                        <dx:ListEditItem Selected="true" Text="DocNumber" Value="DocNumber" />
                                                                        <dx:ListEditItem Text="Stockcode" Value="Stockcode" />
                                                                        <dx:ListEditItem Text="CustomerCode" Value="CustomerCode" />
                                                                    </Items>
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="" ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtFilter2" runat="server" Width="281px">
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem> 
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvUnloaded" runat="server" OnDataBound="gvUnloaded_DataBound"
                                                                    ClientInstanceName="gvUnloaded" Width="742px" KeyFieldName="No" ClientSideEvents-ColumnStartDragging="false" SettingsBehavior-AllowSort="false">
                                                                    <ClientSideEvents Init="OnInitTrans" />
                                                                    <Settings HorizontalScrollBarMode="Visible"
                                                                    VerticalScrollBarMode="Visible" 
                                                                    VerticalScrollableHeight="263" />
                                                                    <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                    <SettingsBehavior AllowSelectByRowClick="true"/>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="No" ShowInCustomizationForm="True" Visible="True" VisibleIndex="0" Width="40px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="JONumber" ShowInCustomizationForm="True" Visible="True" VisibleIndex="1" Width="110px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CustomerCode" ShowInCustomizationForm="True" Visible="True" VisibleIndex="1" Width="110px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Status" ShowInCustomizationForm="True" Visible="True" VisibleIndex="2" Width="80px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ShowInCustomizationForm="True" Visible="True" VisibleIndex="3" Width="180px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="DueDate" ShowInCustomizationForm="True" Visible="True" VisibleIndex="4" Width="100px">
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Stepcode" ShowInCustomizationForm="True" Visible="True" VisibleIndex="5" Width="110px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="JOQty" ShowInCustomizationForm="True" Visible="True" VisibleIndex="6" Width="80px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="TargetDateIn" ShowInCustomizationForm="True" Visible="True" VisibleIndex="7" Width="100px">
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="TargetDateOut" ShowInCustomizationForm="True" Visible="True" VisibleIndex="8" Width="100px">
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="WorkCenter" ShowInCustomizationForm="True" Visible="True" VisibleIndex="9" Width="100px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="RecordID" ShowInCustomizationForm="True" Visible="True" VisibleIndex="10" Width="0px">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <SettingsPager Mode="ShowAllRecords"/> 
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
                            <%--<!--#region Region Header --> --%> 
                            <dx:LayoutGroup GroupBoxDecoration="None" ColCount="16" >
                                <Items>
                                    <dx:LayoutItem ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxButton ID="btnTarget" runat="server" Text="Set Target Date" Width="170px"
                                                    UseSubmitBehavior="false" AutoPostBack="false">
                                                    <ClientSideEvents Click="function(){
                                                        cp.PerformCallback('Date');
                                                        }" />
                                                </dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxButton ID="btnLoad" runat="server" Width="170px" Text="Load WC" UseSubmitBehavior="false"
                                                        AutoPostBack="false">
                                                    <ClientSideEvents Click="function(){
                                                        cp.PerformCallback('Load');
                                                        }" />
                                                </dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxButton ID="btnUnload" runat="server"  Width="170px" Text="Unload WC" UseSubmitBehavior="false"
                                                        AutoPostBack="false">
                                                    <ClientSideEvents Click="function(){
                                                        cp.PerformCallback('Unload');
                                                        }" />
                                                </dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxButton ID="btnChart" ClientEnabled="false" runat="server"  Width="170px" Text="Chart" UseSubmitBehavior="false"
                                                        AutoPostBack="false">
                                                </dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup> 
                        </Items>
                    </dx:ASPxFormLayout>
                <dx:ASPxPopupControl ID="DatePop" runat="server" ClientInstanceName="DatePop"
                CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                HeaderText="JO Step" AllowDragging="True" PopupAnimationType="None" EnableViewState="False">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <dx:ASPxPanel ID="DPop" runat="server">
                            <PanelCollection>
                                <dx:PanelContent runat="server">
                                    <table>
                                        <tr>
                                            <td/>
                                            <dx:ASPxGridView ID="gvSteps" runat="server" OnBatchUpdate="gvSteps_BatchUpdate" OnCommandButtonInitialize="gv_CommandButtonInitialize"
                                                        ClientInstanceName="gvSteps" Width="400px" KeyFieldName="RecordID" SettingsBehavior-AllowSort="false">
                                                        <Settings HorizontalScrollBarMode="Visible"
                                                        VerticalScrollBarMode="Visible"
                                                        VerticalScrollableHeight="200"
                                                          />
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                            BatchEditStartEditing="OnStartEditing" />
                                                        <SettingsEditing Mode="Batch">
                                                        </SettingsEditing>
                                                        <Columns>
                                                            <dx:GridViewDataTextColumn FieldName="Sequence" ShowInCustomizationForm="True" Visible="True" VisibleIndex="0" Width="70px" ReadOnly="true">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Stepcode" ShowInCustomizationForm="True" Visible="True" VisibleIndex="1" Width="119px" ReadOnly="true">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataDateColumn FieldName="TargetDateIn" ShowInCustomizationForm="True" Visible="True" VisibleIndex="2" Width="90px">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataDateColumn FieldName="TargetDateOut" ShowInCustomizationForm="True" Visible="True" VisibleIndex="3" Width="100px">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataTextColumn FieldName="DateCommitted" ShowInCustomizationForm="True" Visible="True" VisibleIndex="4" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="WorkCenter" ShowInCustomizationForm="True" Visible="True" VisibleIndex="5" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="True" VisibleIndex="6" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="RecordID" ShowInCustomizationForm="True" Visible="True" VisibleIndex="7" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn ShowInCustomizationForm="True" Visible="True" VisibleIndex="7" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                        </Columns>
                                                        <SettingsPager Mode="ShowAllRecords"/> 
                                                    </dx:ASPxGridView>
                                        </tr>
                                        <tr>
                                            <td /><dx:ASPxButton ID="btnUp" runat="server" Text="Update" AutoPostBack="False" ClientInstanceName="btnUp"
                                            UseSubmitBehavior="false" CausesValidation="true">
                                            <ClientSideEvents Click="function(){
                                                checkGrid();
                                                console.log(Okay);
                                                if(Okay){
                                                OnUpdateClick();
                                                }
                                                }" />
                                    </dx:ASPxButton>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxPanel>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
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
                             </dx:ASPxButton>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
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
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.ItemAdjustment" DataObjectTypeName="Entity.ItemAdjustment" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ItemAdjustment+ItemAdjustmentDetail" DataObjectTypeName="Entity.ItemAdjustment+ItemAdjustmentDetail" DeleteMethod="DeleteItemAdjustmentDetail" InsertMethod="AddItemAdjustmentDetail" UpdateMethod="UpdateItemAdjustmentDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="DocNumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  wms.ItemAdjustmentDetail where DocNumber  is null " >
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] where isnull(IsInactive,'')=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" SELECT SupplierCode, [Name], [Address] FROM [MasterFile].BPSupplierInfo WHERE ISNULL(IsInActive,0) = 0 " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="MasterfileStep" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [StepCode], [Description] FROM [MasterFile].[Step] WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="JobOrder" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select a.DocNumber,ISNULL(WorkCenter,'') as  WorkCenter,ISNULL(StepCode,'') as StepCode from Production.JobOrder A
                        INNER JOIN Production.JOStepPlanning B on A.DocNumber = b.DocNumber where Status in ('N','W')" OnInit="Connection_Init"></asp:SqlDataSource>
     <!--#endregion-->
</body>
</html>


