<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmChartOfAccounts.aspx.cs" Inherits="GWL.frmChartOfAccounts" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>



<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Chart Of Accounts</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
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
       var AccFr;
       var AccTo;


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
               gv1.CancelEdit();
               //alert(s.cp_valmsg);
               alert(s.cp_message);
               //delete (s.cp_valmsg);
               delete (s.cp_success);//deletes cache variables' data
               delete (s.cp_message);

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
           AccFr = s.cp_AccountFr;
           AccTo = s.cp_AccountTo;
           delete (s.cp_AccountFr);
           delete (s.cp_AccountTo);
       }

       function Oncheckboxchanged(s, e) {
           var IsBudget = checkBox.GetChecked();
           if (IsBudget == false) {
               console.log('test');
               cboApproach.SetEnabled(false);
               cboApproach.SetText(null);
               cboCoverage.SetEnabled(false);
               cboCoverage.SetText(null);
               cboLevel.SetEnabled(false);
               cboLevel.SetText(null);
           }
           else {
               cboApproach.SetEnabled(true);
               //cboCoverage.SetEnabled(true);
               //cboLevel.SetEnabled(true);
           }
       }
       function ComboboxChanged(s, e) {
           var Approach = cboApproach.GetText();
           console.log(Approach);
           //var IsBudget = checkBox.GetChecked();
           if (Approach == "ByPass") {
               console.log('test');
               ////cboApproach.SetEnabled(false);
               ////cboApproach.SetText(null);
               cboCoverage.SetEnabled(false);
               cboCoverage.SetText(null);
               cboLevel.SetEnabled(false);
               cboLevel.SetText(null);
           }
           else {
               //cboApproach.SetEnabled(true);
               cboCoverage.SetEnabled(true);
               cboLevel.SetEnabled(true);
           }
       }

       //function Group(s, e) {
       //    var GroupC = gvGroupCode.GetText();
       //    if (e.GroupC == "Details") {
       //        var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
       //        var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
       //        var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
       //        var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
       //        factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
       //        + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode);
       //    }

       //}
       var itemc; //variable required for lookup
       var currentColumn = null;
       var isSetTextRequired = false;
       var linecount = 1;
       function OnStartEditing(s, e) {//On start edit grid function     
           currentColumn = e.focusedColumn;
           var cellInfo = e.rowValues[e.focusedColumn.index];
           itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
           //if (e.visibleIndex < 0) {//new row
           //    var linenumber = s.GetColumnByField("LineNumber");
           //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
           //}
           if (entry == "V" || entry == "D") {
               e.cancel = true; //this will made the gridview readonly
           }
           if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
               gl.GetInputElement().value = cellInfo.value; //Gets the column value
               isSetTextRequired = true;
           }

           if (e.focusedColumn.fieldName === "ClassCode") {
               gl3.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "SizeCode") {
               gl4.GetInputElement().value = cellInfo.value;
           }
           //if (e.focusedColumn.fieldName === "BudgetApproach" || e.focusedColumn.fieldName === "BudgetCoverage" || e.focusedColumn.fieldName === "BudgetLevel") {
           //    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsBudget") == false) {
           //        e.cancel = true;
           //    }
           //}
       }

       function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
           var cellInfo = e.rowValues[currentColumn.index];
           if (currentColumn.fieldName === "ItemCode") {
               cellInfo.value = gl.GetValue();
               cellInfo.text = gl.GetText();
           }

           if (currentColumn.fieldName === "ClassCode") {
               cellInfo.value = gl3.GetValue();
               cellInfo.text = gl3.GetText();
           }
           if (currentColumn.fieldName === "SizeCode") {
               cellInfo.value = gl4.GetValue();
               cellInfo.text = gl4.GetText();
           }
       }

       function lookup(s, e) {
           if (isSetTextRequired) {//Sets the text during lookup for item code
               s.SetText(s.GetInputElement().value);
               isSetTextRequired = false;
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
               if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(5) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
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

       function initlayout() {
           Oncheckboxchanged();
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
           gv1.SetWidth(width - 120);
       }

       function chkCon() {
           var check = chkConfi.GetChecked();
           if (check == true) {
               txtBalAmt.SetVisible(false);

           }
           else {
               txtBalAmt.SetVisible(true);
           }
           ;
       }
       function chkCntrl() {
           var chk = chkControl.GetChecked();
           //if (chk == true) {
           //    chkAmortization.SetEnabled(false);
           //    chkAmortization.SetValue(false);

           //}
           //else {
           //    chkAmortization.SetEnabled(true);
           //    chkAmortization.SetValue(false);
           //}

       }
       //function GroupC() {
       //    var group = gvGroup.GetText();

       //    ;
       //}
       function chkAmor() {
           var chek = chkAmortization.GetChecked();
           if (chek == true) {
               chkControl.SetEnabled(false);
               chkControl.SetValue(false);

           }
           else {
               chkControl.SetEnabled(true);
               chkControl.SetValue(false);
           }
       }

       function txtAmt() {
           var dec = txtBalAmt.GetText();
           if (dec == 0) {
               chkIsInactive.SetEnabled(true);
               chkIsInactive.SetValue(false);
               chkControl.SetEnabled(true);
               chkControl.SetValue(false);
               chkAmortization.SetEnabled(true);
               chkAmortization.SetValue(false);

           }
           else {
               chkIsInactive.SetEnabled(false);
               chkIsInactive.SetValue(false);
               chkControl.SetEnabled(false);
               chkControl.SetValue(false);
               chkAmortization.SetEnabled(false);
               chkAmortization.SetValue(false);
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
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Chart Of Accounts" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
  
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px " Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="FormLayout" runat="server"  Height="565px" Width="850px " style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <%--<ClientSideEvents Init="initlayout" />--%>
                        <Items>

                            <dx:TabbedLayoutGroup>
                                <Items>
                                    
                                    
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <Items>
                                            <dx:LayoutItem Caption="Group Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvGroupCode" runat="server" DataSourceID="sdsGroup" KeyFieldName="GroupCode" OnLoad="LookupLoad" 
                                                            TextFormatString="{0}" Width="170px" AutoGenerateColumns="false">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="GroupCode" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="GroupLevel" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="AccountFr" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="AccountTo" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns> 
                                                            <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('Group') }" />
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                              <dx:LayoutItem Caption="IsBudget">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkBudget" runat="server" CheckState="Unchecked" Text=" " ClientInstanceName="checkBox" Onload="CheckBoxLoad">
                                                            <ClientSideEvents  ValueChanged="Oncheckboxchanged" Init="Oncheckboxchanged" />
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Account Code" Name="AccountCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtAccount" runat="server"  Width="170px" OnLoad="SpinEdit_Load" MaxLength="4">
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <SpinButtons ShowIncrementButtons="false" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption="Budget Control Approach" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="cboApproach" runat="server" ClientInstanceName="cboApproach" OnLoad="Comboboxload" Width="170px" ClientEnabled="false">
                                                            <ClientSideEvents SelectedIndexChanged="ComboboxChanged"  />
                                                            <Items>
                                                                <dx:ListEditItem Text="Block" Value="B" />
                                                                <dx:ListEditItem Text="Warning" Value="A" />
                                                                <dx:ListEditItem Text="ByPass" Value="BP" />
                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                                 </dx:LayoutItem>
                                              <dx:LayoutItem Caption="Description">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDesc" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Budget Control Coverage">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="cboCoverage" runat="server" ClientInstanceName="cboCoverage" OnLoad="Comboboxload" Width="170px" ClientEnabled="false">
                                                            <Items>
                                                                <dx:ListEditItem Text="Annual Budget" Value="A" />
                                                                <dx:ListEditItem Text="Monthly Budget" Value="M" />
                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             <dx:LayoutItem Caption="External Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtExternal" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             <dx:LayoutItem Caption="Budget Control Level">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="cboLevel" runat="server" ClientInstanceName="cboLevel" OnLoad="Comboboxload" Width="170px" ClientEnabled="false">
                                                            <Items>
                                                                <dx:ListEditItem Text="GL Account" Value="GL" />
                                                                <dx:ListEditItem Text="SubsiCode" Value="S" />
                                                                <dx:ListEditItem Text="Cost Center" Value="C" />
                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                              <%--<dx:LayoutItem Caption="GL Balance Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextbox ID="txtBalAmt" runat="server" ClientInstanceName="txtBalAmt" Width="170px" ReadOnly="true">
                                                            <ClientSideEvents ValueChanged="txtAmt" Init="txtAmt" />
                                                        </dx:ASPxTextbox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="GL Balance Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speBalAmt" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                        DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="txtBalAmt" AllowMouseWheel="False"
                                                                        MaxValue="9999999999" MinValue ="0.00000000001" ReadOnly="true" >
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            <%--<ClientSideEvents ValueChanged="txtAmt"/>--%> 
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             <dx:LayoutItem Caption="Confidential">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkConfi" runat="server" CheckState="Unchecked" ClientInstanceName="chkConfi" OnLoad="CheckBoxLoad" Text=" ">
                                                            <ClientSideEvents CheckedChanged="chkCon" />
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Fixed Cost Center">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glCost" runat="server" DataSourceID="sdsCostCenterCode" KeyFieldName="CostCenterCode" 
                                                            OnLoad="gvLookupLoad" TextFormatString="{0}" Width="170px" AutoGenerateColumns="false">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="CostCenterCode" ReadOnly="true">
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
                                             <dx:LayoutItem Caption="Cash Account">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkCash" runat="server" CheckState="Unchecked" OnLoad="CheckBoxLoad" Text=" ">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption="Opex Type">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="cboOpex" runat="server" OnLoad="Comboboxload" Width="170px">
                                                            <Items>
                                                                <dx:ListEditItem Text="Outlet" Value="0" />
                                                                <dx:ListEditItem Text="Head Office" Value="H" />
                                                                <dx:ListEditItem Text="Mixed" Value="M" />
                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                               <dx:LayoutItem Caption="Control Account">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkControl" runat="server" OnLoad="OtherCheckBox" CheckState="Unchecked" ClientInstanceName="chkControl">
                                                            <ClientSideEvents CheckedChanged="chkCntrl"  />
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                              <dx:LayoutItem Caption="Allow JV">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkAllowJV" runat="server" OnLoad="CheckBoxLoad" CheckState="Unchecked" Text=" ">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                               <dx:LayoutItem Caption="Amortization Account">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkAmortization" runat="server" OnLoad="OtherCheckBox" CheckState="Unchecked" ClientInstanceName="chkAmortization">
                                                            <ClientSideEvents CheckedChanged="chkAmor"  />
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Is Debit">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkDebit" runat="server" Onload="CheckBoxLoad" CheckState="Unchecked">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="IsInactive">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkIsInactive" ClientInstanceName="chkIsInactive" ReadOnly="true" runat="server" CheckState="Unchecked">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>

                                      <dx:LayoutGroup Caption="Details" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem ShowCaption="False">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="747px"
                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                                                        OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="AccountCode;SubsiCode" OnInitNewRow="gv1_InitNewRow">
                                                            <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" 
                                                            BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick"/>
                                                            <SettingsPager Mode="ShowAllRecords"/>
                                                            <SettingsEditing Mode="Batch" />
                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  ShowStatusBar="Hidden"/> 
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="AccountCode" Visible="False"
                                                                    VisibleIndex="0" Width="0px">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px" ShowNewButtonInHeader="true" ShowDeleteButton="true">
                                                                    <CustomButtons>
                                                                    </CustomButtons>
                                                                </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn FieldName="SubsiCode" VisibleIndex="3" Caption="SubsiCode" Name="SubsiCode">                                                                                                                     
                                                                </dx:GridViewDataTextColumn>
                                                                 <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="4" Width="300px" Caption="Description" >
                                                                </dx:GridViewDataTextColumn>
                                                                 <dx:GridViewDataCheckColumn Caption="Variable" FieldName="IsVariable" Name="IsVariable" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                </dx:GridViewDataCheckColumn>
                                                                <dx:GridViewDataCheckColumn Caption="IsInactive" FieldName="IsInactive" Name="IsInactive" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                </dx:GridViewDataCheckColumn>
                                                                 <dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="6" FieldName="Field1" UnboundType="String">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="Field2" UnboundType="String">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="8" FieldName="Field3" UnboundType="String">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="9" FieldName="Field4" UnboundType="String">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="10" FieldName="Field5" UnboundType="String">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="11" FieldName="Field6" UnboundType="String">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="12" FieldName="Field7" UnboundType="String">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="13" FieldName="Field8" UnboundType="String">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="14" FieldName="Field9" UnboundType="String">
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
                                    <dx:LayoutGroup Caption="User Defined Fields" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field 1:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad" >
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
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad" >
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
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad" >
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
                                                        <dx:ASPxTextBox ID="txtAddedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastEditedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Activated By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActivatedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Activated Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtActivatedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="DeActivated By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDeActivatedBy" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="DeActivated Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDeActivatedDate" runat="server" ColCount="1" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>
                            
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
                            <td>
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" AutoPostBack="False" UseSubmitBehavior="false" CausesValidation="true">
                                <ClientSideEvents Click="function (s, e){  cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" AutoPostBack="False" UseSubmitBehavior="false" CausesValidation="true">
                                <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                </dx:ASPxButton>
                            </td> 
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
    <!--#region Region Datasource-->
        <%--<ClientSideEvents Init="initlayout" />--%>
    </form>
    
            <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ChartOfAccounts+GLSubsiCode" DataObjectTypeName="Entity.ChartOfAccounts+GLSubsiCode" DeleteMethod="DeleteGLSubsiCode" InsertMethod="AddGLSubsiCode" UpdateMethod="UpdateGLSubsiCode">
        <SelectParameters>
            <asp:QueryStringParameter Name="AccountCode" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Accounting.GLSubsiCode WHERE AccountCode IS NULL" OnInit = "Connection_Init" >
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCostCenterCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT CostCenterCode, Description FROM Accounting.CostCenter" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsGroup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select GroupCode, GroupLevel, Description, AccountFr, AccountTo from accounting.GLAccountGroup" OnInit = "Connection_Init"></asp:SqlDataSource>

     <!--#endregion-->
</body>
</html>