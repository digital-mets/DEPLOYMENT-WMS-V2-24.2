<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmJVTemplate.aspx.cs" Inherits="GWL.frmJVTemplate" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>



<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>JV Template</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <!--#region Region CSS-->
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
           if (s.cp_generated) {
               delete (s.cp_generated);
               console.log('autocalculate');
               autocalculate();
           }
       }

       var itemc; //variable required for lookup
       var currentColumn = null;
       var isSetTextRequired = false;
       var linecount = 1
       var accountcode;
       function OnStartEditing(s, e) {//On start edit grid function     
           currentColumn = e.focusedColumn;
           var cellInfo = e.rowValues[e.focusedColumn.index];
           accountcode = s.batchEditApi.GetCellValue(e.visibleIndex, "AccountCode"); //needed var for all lookups; this is where the lookups vary for
           //if (e.visibleIndex < 0) {//new row
           //    var linenumber = s.GetColumnByField("LineNumber");
           //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
           //}
           if (entry == "V" || entry == "D") {
               e.cancel = true; //this will made the gridview readonly
           }
           if (e.focusedColumn.fieldName === "AccountCode") { //Check the column name
               gl.GetInputElement().value = cellInfo.value; //Gets the column value
               isSetTextRequired = true;
           }
           if (e.focusedColumn.fieldName === "SubsiCode") {
               gl2.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "ProfitCenterCode") {
               gl3.GetInputElement().value = cellInfo.value;
               isSetTextRequired = true;
           }
           if (e.focusedColumn.fieldName === "CostCenterCode") {
               gl4.GetInputElement().value = cellInfo.value;
               isSetTextRequired = true;
           }
           if (e.focusedColumn.fieldName === "BizPartnerCode") {
               gl5.GetInputElement().value = cellInfo.value;
               isSetTextRequired = true;
           }
           if (e.focusedColumn.fieldName === "Credit") {
               if ((s.batchEditApi.GetCellValue(e.visibleIndex, "Debit") != null) && (s.batchEditApi.GetCellValue(e.visibleIndex, "Debit") != 0))
                   e.cancel = true;
           }
           if (e.focusedColumn.fieldName === "Debit") {
               if ((s.batchEditApi.GetCellValue(e.visibleIndex, "Credit") != null) && (s.batchEditApi.GetCellValue(e.visibleIndex, "Credit") != 0))
                   e.cancel = true;
           }
       }

       function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
           var cellInfo = e.rowValues[currentColumn.index];
           if (currentColumn.fieldName === "AccountCode") {
               cellInfo.value = gl.GetValue();
               cellInfo.text = gl.GetText();
           }
           if (currentColumn.fieldName === "SubsiCode") {
               cellInfo.value = gl2.GetValue();
               cellInfo.text = gl2.GetText();
           }
           if (currentColumn.fieldName === "ProfitCenterCode") {
               cellInfo.value = gl3.GetValue();
               cellInfo.text = gl3.GetText();
           }
           if (currentColumn.fieldName === "CostCenterCode") {
               cellInfo.value = gl4.GetValue();
               cellInfo.text = gl4.GetText();
           }
           if (currentColumn.fieldName === "BizPartnerCode") {
               cellInfo.value = gl5.GetValue();
               cellInfo.text = gl5.GetText();
           }
       }
       function autocalculate(s, e) {
           OnInitTrans();
           //console.log(txtNewUnitCost.GetValue());
           var debit = 0;
           var totaldebit = 0;
           var credit = 0;
           var totalcredit = 0;


           setTimeout(function () { //New Rows
               var indicies = gv1.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indicies.length; i++) {
                   if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                       debit = gv1.batchEditApi.GetCellValue(indicies[i], "Debit");
                       credit = gv1.batchEditApi.GetCellValue(indicies[i], "Credit");
                       totaldebit += debit;
                       totalcredit += credit;
                   }
                   else { //Existing Rows
                       var key = gv1.GetRowKey(indicies[i]);
                       if (gv1.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + indicies[i]);
                       else {
                           debit = gv1.batchEditApi.GetCellValue(indicies[i], "Debit");
                           credit = gv1.batchEditApi.GetCellValue(indicies[i], "Credit");
                           totaldebit += debit;
                           totalcredit += credit;
                       }
                   }


               }
               spTotalDebit.SetText(totaldebit.toFixed(2));
               spTotalCredit.SetText(totalcredit.toFixed(2));
           }, 500);
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
           if (keyCode == ASPxKey.Enter) {
               gv1.batchEditApi.EndEdit();
           }
           //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
       }

       function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
           gv1.batchEditApi.EndEdit();
       }

       function acceptch(s, e) {
           if (s.GetGridView().cp_ac) {
               delete (s.GetGridView().cp_ac)
               gv1.batchEditApi.EndEdit();
           }
       }

       //validation
       function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
           for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
               var column = s.GetColumn(i);
               if (column.fieldName == "AccountCode" || column.fieldName == "SubsiCode" || column.fieldName == "ProfitCenterCode" || column.fieldName == "CostCenterCode" || column.fieldName == "BizPartnerCode") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                   var cellValidationInfo = e.validationInfo[column.index];
                   if (!cellValidationInfo) continue;
                   var value = cellValidationInfo.value;
                   if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                       cellValidationInfo.isValid = false;
                       cellValidationInfo.errorText = column.fieldName + " is required";
                       isValid = false;
                       e.isValid = false;
                   }
               }
           }
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
           if (e.buttonID == "Delete") {
               gv1.DeleteRow(e.visibleIndex);
               autocalculate();
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
           gv1.SetWidth(width - 120);
       }
       //#endregion

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
                                <dx:ASPxLabel runat="server" Text="Journal Voucher Template" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
        
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="FormLayout" runat="server"  Height="558px" Width="850px" style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>

                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="Header" ColCount="2">
                                        <Items>  
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDoc" runat="server" Width="170px"  ReadOnly="true">
                                                        
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Debit:" Name="TotalCredit">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="spTotalDebit" runat="server" ClientInstanceName="spTotalDebit" Number="0.00" ReadOnly="True" Width="170px" DisplayFormatString ="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption="Document Date:" Name="DocDate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="deDocDate" runat="server" Width="170px" OnLoad="Date_Load" >
                                                            <ClientSideEvents Init="function(s,e){ s.SetDate(new Date());}"  Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                <dx:LayoutItem Caption="Total Credit:" Name="TotalCredit">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="spTotalCredit" runat="server" ClientInstanceName="spTotalCredit" Number="0.00" Width="170px" ReadOnly="true" DisplayFormatString ="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             <dx:LayoutItem Caption="Description">
                                                 <LayoutItemNestedControlCollection>
                                                     <dx:LayoutItemNestedControlContainer runat="server">
                                                         <dx:ASPxMemo ID="txtDesc" runat="server" Height="200px" OnLoad="memoremarks_Load" Width="550px">
                                                         </dx:ASPxMemo>
                                                     </dx:LayoutItemNestedControlContainer>
                                                 </LayoutItemNestedControlCollection>
                                             </dx:LayoutItem>
                                             <dx:LayoutItem Caption="IsInactive">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkIsInactive" runat="server" CheckState="Unchecked" ClientInstanceName="chkIsInactive" Text=" " ReadOnly="True">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>

                                    <dx:LayoutGroup Caption="User Defined Fields" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field 1:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server"  OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server"  OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server"  OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server"  OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server"  OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server"  OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server"  OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server"  OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server"  OnLoad="TextboxLoad">
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
                            
    <%--                    </Items>
                    </dx:ASPxFormLayout>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>--%>
                              <dx:LayoutGroup Caption="JV Template Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="747px" DataSourceId="sdsDetail"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber">
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick"/>
                                                    <SettingsPager Mode="ShowAllRecords" />  
                                                            <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  ShowStatusBar="Hidden" /> 
                                                    <SettingsBehavior AllowSort="False" AllowDragDrop="False" /> 
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="True"
                                                            VisibleIndex="0" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Caption="Line" ReadOnly="True" Width="0px" Visible="True">
                                                        </dx:GridViewDataTextColumn>
                                                        
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="60px" ShowNewButtonInHeader="true">
                                                                                                               <CustomButtons>
                                                            <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                        <Image IconID="actions_cancel_16x16"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                            <dx:GridViewCommandColumnCustomButton ID="Details">
                                                               <Image IconID="support_info_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>

                                                        </CustomButtons>
                                                            
                                                             </dx:GridViewCommandColumn>
                                                         <%--<dx:GridViewDataTextColumn FieldName="AccountCode" VisibleIndex="3" Width="150px" Name="glAccountCode" Caption="AccountCode" >
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glAccountCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    DataSourceID="AccountCode" KeyFieldName="AccountCode" ClientInstanceName="gl" TextFormatString="{0}" Width="150px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" AllowSort="false"/>

                                                                    </GridViewProperties>

                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="0" />
                                                                        
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>--%>
                                                        <dx:GridViewDataTextColumn Caption="Account Code" FieldName="AccountCode" Name="glAccountCode" ShowInCustomizationForm="True" VisibleIndex="3" Width="150px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glAccountCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl" DataSourceID="AccountCode" 
                                                                    KeyFieldName="AccountCode" TextFormatString="{0}" Width="150px" OnInit="glAccountCode_Init"
                                                                    ClientSideEvents-EndCallback="acceptch">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                    <ClientSideEvents KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"/>                                                                   
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubsiCode" VisibleIndex="4" Width="150px" Caption="SubsiCode" Name="glSubsiCode" >   
                                                                                                                        <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSubsiCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" DataSourceID="SubsiCode" 
                                                                    KeyFieldName="SubsiCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="150px" OnInit="lookup_Init" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SubsiCode" ReadOnly="True" VisibleIndex="0"/>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                        
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="function dropdown(s, e){
                                                                                gl2.GetGridView().PerformCallback('SubsiGetCode' + '|' + accountcode);
                                                                            }" 
                                                                         KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" VisibleIndex="5" Width="150px" Name="glProfitCenterCode" Caption="ProfitCenterCode" >
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glProfitCenterCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" DataSourceID="ProfitCenterCode" 
                                                                KeyFieldName="ProfitCenterCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="150px" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                         CloseUp="gridLookup_CloseUp" DropDown="lookup"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" VisibleIndex="6" Width="150px" Name="glCostCenterCode" Caption="CostCenterCode" >
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glCostCenterCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" DataSourceID="CostCenterCode" 
                                                                KeyFieldName="CostCenterCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="150px" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                         CloseUp="gridLookup_CloseUp" DropDown="lookup"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                             <dx:GridViewDataTextColumn FieldName="BizPartnerCode" VisibleIndex="6" Width="150px" Name="glBizPartnerCode" Caption="BizPartnerCode" >
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glBizPartnerCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" DataSourceID="BizPartnerCode" 
                                                                KeyFieldName="BizPartnerCode" ClientInstanceName="gl5" TextFormatString="{0}" Width="150px" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                         CloseUp="gridLookup_CloseUp" DropDown="lookup"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="16" FieldName="Field1" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="17" FieldName="Field2" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="18" FieldName="Field3" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="19" FieldName="Field4" UnboundType="Decimal">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="20" FieldName="Field5" UnboundType="Decimal">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="21" FieldName="Field6" UnboundType="Decimal">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="22" FieldName="Field7" UnboundType="Decimal">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="23" FieldName="Field8" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="24" FieldName="Field9" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataSpinEditColumn Caption="Debit" FieldName="Debit" Name="spDebit" ShowInCustomizationForm="True" VisibleIndex="14" Width="150">
                                                            <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}" ClientInstanceName="spDebit" MinValue="0" MaxValue="9999999999">
                                                            
                                                         <ClientSideEvents ValueChanged="autocalculate" />
                                                            <SpinButtons ShowIncrementButtons ="false" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Credit" FieldName="Credit" Name="spCredit" ShowInCustomizationForm="True" VisibleIndex="15" Width="150">
                                                            <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}" ClientInstanceName="spCredit" MinValue="0" MaxValue="9999999999" >
                                                                
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                            <SpinButtons ShowIncrementButtons ="false" />
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>


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
    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.JVTemplate" DataObjectTypeName="Entity.JVTemplate" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.JVTemplate+JVTemplateDetail" DataObjectTypeName="Entity.JVTemplate+JVTemplateDetail" DeleteMethod="DeleteJVTemplateDetail" InsertMethod="AddJVTemplateDetail" UpdateMethod="UpdateJVTemplateDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
        

    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Accounting.JVTemplateDetail where DocNumber  is null " OnInit = "Connection_Init">
  
        </asp:SqlDataSource>
    <!--#region Region Datasource-->
        <%--                                                      
                                                            </Columns>--%>
    <asp:SqlDataSource ID="AccountCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT AccountCode,Description from Accounting.ChartOfAccount where Isnull(AllowJV,0)=1 and isnull(IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SubsiCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DISTINCT A.AccountCode,B.SubsiCode,B.Description from Accounting.ChartOfAccount A inner join Accounting.GLSubsiCode B on A.AccountCode = B.AccountCode  AND ISNULL(B.IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="CostCenterCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT CostCenterCode, Description FROM Accounting.CostCenter WHERE ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ProfitCenterCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ProfitCenterCode, Description FROM Accounting.ProfitCenter WHERE ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="BizPartnerCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="BizAccount" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DISTINCT BusinessAccountCode,BusinessAccountName from Masterfile.BizAccount WHERE ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Currency" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DISTINCT Currency,CurrencyName from masterfile.Currency where isnull(IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ItemCategory" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ItemCategoryCode,Description from Masterfile.ItemCategory where isnull(IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Prefix" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select Prefix,Description from it.DocNumberSettings where Module = 'JVOUCH'  and isnull(IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
 </form>

     <!--#endregion-->
</body>
</html>