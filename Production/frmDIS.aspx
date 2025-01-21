<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDIS.aspx.cs" Inherits="GWL.frmDIS" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title></title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%>

     <!--#region Region Javascript-->
        <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 
        {
            height: 800px; /*Change this whenever needed*/
        }

        .Entry 
        {
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
        }

        .pnl-content
        {
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
           gv2.SetWidth(width - 120);
           gv3.SetWidth(width - 120);
           //gvJournal.SetWidth(width - 100);
           gvRef.SetWidth(width - 120);
       } //Add for all three

       function OnUpdateClick(s, e) { //Add/Edit/Close button function
           var btnmode = btn.GetText(); //gets text of button
           if (CINType.GetText() == "" || CINDocDate.GetText() == "" ||
               CINDueDate.GetText() == "" || CINDesigner.GetText() == "" ||
               CINCustomerCode.GetText() == "" && CINBrand.GetText() == "" ||
               CINGender.GetText() == "" || CINProductCategory.GetText() == "" ||
               CINFitCode.GetText() == "") {
               counterror = 0; 
               alert('Please check all fields!');
           }
           else if (CINType.GetText() != "Development" && CINOriginalDIS.GetText() == "") {
               counterror = 0;
               alert('Original DIS required when type is not \'Development\'!');
           }
           else { 
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
                   DeleteControl.Show();
               }
           }
       }

       function OnConfirm(s, e) {//function upon saving entry
           if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
               e.cancel = true;
       }

       function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
           if (s.cp_success) {
               alert(s.cp_message);
               delete (s.cp_success);
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
                   window.close();
               }
           }
           if (s.cp_refdel != null) {
               gv2.CancelEdit();
               console.log('bebeloves');
               delete (s.cp_refdel);
               //autocalculateApplied();
           }
           if (s.cp_generated != null) {
               //autocalculateApplied();
               delete (s.cp_generated);
           }
           if (s.cp_forceclose) {//NEWADD
               delete (s.cp_forceclose);
               window.close();
           }

           SetVals();
       }

       function lookup(s, e) {
           if (isSetTextRequired) {//Sets the text during lookup for item code
               s.SetText(s.GetInputElement().value);
               isSetTextRequired = false;
           }
       }

       function gridLookup_KeyDown(s, e) {
           isSetTextRequired = false;
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode !== 9) return;
           var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
           if (gv1.batchEditApi[moveActionName]()) {
               ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
           }
           if (gv2.batchEditApi[moveActionName]()) {
               ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
           }
           if (gv3.batchEditApi[moveActionName]()) {
               ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
           }
       } //Add for all three

       function gridLookup_KeyPress(s, e) {
           //var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           //if (keyCode == 13) {
               //gv1.batchEditApi.EndEdit();
               //gv2.batchEditApi.EndEdit();
               //gv3.batchEditApi.EndEdit();
           //}
	   var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    	   if (keyCode == 13) {
               ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    	   }
       } //Add for all three

       function gridLookup_CloseUp(s, e) {
           gv1.batchEditApi.EndEdit();
           gv2.batchEditApi.EndEdit();
           gv3.batchEditApi.EndEdit();
       } //Add for all three

       function OnCustomClick(s, e) {
           if (e.buttonID == "BizPartner") {
               var BizPartnerCode = s.batchEditApi.GetCellValue(e.visibleIndex, "WorkCenter");
               factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
           }
           if (e.buttonID == "Details") {
               var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
               var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
               var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
               var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");   
               factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
               + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&Warehouse=' + "");
           }
           if (e.buttonID == "Delete") {
               gv1.DeleteRow(e.visibleIndex);
           }
           if (e.buttonID == "Delete1") {
               gv2.DeleteRow(e.visibleIndex);
           }
           if (e.buttonID == "Delete2") {
               gv3.DeleteRow(e.visibleIndex);
               autocalculateSizeBreakdown();
           }
           if (e.buttonID == "ViewReferenceTransaction") {
               var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
               var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
               var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
               window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
               console.log('ViewTransaction')
           }
           //autocalculateApplied();
       } //Add for all three



       ////////////////////////////////////////////////////////////JAVASCRIPT SECTION FOR GV1 
       var val;
       var temp;
       var itemc;
       var index;
       var closing;
       var valchange;
       var linecount = 1;
       var currentColumn = null;
       var isSetTextRequired = false;

       function OnStartEditing(s, e) {   
           currentColumn = e.focusedColumn;
           var cellInfo = e.rowValues[e.focusedColumn.index];
           itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");

           var entry = getParameterByName('entry');
           if (entry != "V" && entry != "D") {
               e.cancel = false;
           }
           else
               e.cancel = true;

           if (e.focusedColumn.fieldName === "Step") {
               glStep.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "ItemCode") { 
               gl.GetInputElement().value = cellInfo.value; 
               isSetTextRequired = true;
               index = e.visibleIndex;
               closing = true;
           }
           if (e.focusedColumn.fieldName === "ColorCode") {
               gl2.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "ClassCode") {
               gl3.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "SizeCode") {
               gl4.GetInputElement().value = cellInfo.value;
           }
       }

       function OnEndEditing(s, e) { 
           var cellInfo = e.rowValues[currentColumn.index];
           //console.log(cellInfo.value + '-------------');
            if (currentColumn.fieldName === "Step") {
                cellInfo.value = glStep.GetValue();
                cellInfo.text = glStep.GetText();
            }
            if (currentColumn.fieldName === "ItemCode") {
                cellInfo.value = gl.GetValue();
                cellInfo.text = gl.GetText();
            }
            if (currentColumn.fieldName === "ColorCode") {
                cellInfo.value = gl2.GetValue();
                cellInfo.text = gl2.GetText();
            }
            if (currentColumn.fieldName === "ClassCode") {
                cellInfo.value = gl3.GetValue();
                cellInfo.text = gl3.GetText();
            }
            if (currentColumn.fieldName === "SizeCode") {
                cellInfo.value = gl4.GetValue();
                cellInfo.text = gl4.GetText();
            }
            if (valchange) {
                valchange = false;
                closing = false;
                for (var i = 0; i < s.GetColumnsCount() ; i++) {
                    var column = s.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, e, column, s);
                }
            } 
       }

       function ProcessCells(selectedIndex, e, column, s) {
           if (val == null) {
               temp = val.split(';');
           }
           if (temp[0] == null) {
               temp[0] = "";
           }
           if (temp[1] == null) {
               temp[1] = "";
           }
           if (temp[2] == null) {
               temp[2] = "";
           }
           if (temp[3] == null) {
               temp[3] = "";
           }
           if (selectedIndex == 0) {
               if (column.fieldName == "ColorCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
               }
               if (column.fieldName == "ClassCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
               }
               if (column.fieldName == "SizeCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
               }
               if (column.fieldName == "Cost") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
               }
           }
       }

       function GridEnd(s, e) {
           val = s.GetGridView().cp_codes;
           temp = val.split(';');
           if (closing == true) {
               gv1.batchEditApi.EndEdit();
               //autocalculateApplied();
           }
           loader.Hide();
       }




       ////////////////////////////////////////////////////////////JAVASCRIPT SECTION FOR GV2
       var currentColumn2 = null;
       function OnStartEditing2(s, e) {
           currentColumn2 = e.focusedColumn;
           var cellInfo2 = e.rowValues[e.focusedColumn.index];

           if (s.batchEditApi.GetCellValue(e.visibleIndex, "TargetDateIN") === null || s.batchEditApi.GetCellValue(e.visibleIndex, "TargetDateIN") === "") {
               var today = new Date();
               s.batchEditApi.SetCellValue(e.visibleIndex, "TargetDateIN", today) 
           }
           if (s.batchEditApi.GetCellValue(e.visibleIndex, "TargetDateOUT") === null || s.batchEditApi.GetCellValue(e.visibleIndex, "TargetDateIN") === "") {
               var today = new Date();
               s.batchEditApi.SetCellValue(e.visibleIndex, "TargetDateOUT", today) 
           }

           var entry = getParameterByName('entry');
           if (entry != "V" && entry != "D") {
               if (e.focusedColumn.fieldName == "DateIN" || e.focusedColumn.fieldName == "DateOUT" || e.focusedColumn.fieldName == "Days") {
                   e.cancel = true;
               }
               else
                   e.cancel = false;
           }
           else
               e.cancel = true;

           if (e.focusedColumn.fieldName === "Step") {
               glStep1.GetInputElement().value = cellInfo2.value;
           }
           if (e.focusedColumn.fieldName === "WorkCenter") {
               glWorkCenter.GetInputElement().value = cellInfo2.value;
           }
       }

       function OnEndEditing2(s, e) {
           //console.log(cellInfo2.value + '++++++++');
            var cellInfo2 = e.rowValues[currentColumn2.index];
            if (currentColumn2.fieldName === "Step") {
                cellInfo2.value = glStep1.GetValue();
                cellInfo2.text = glStep1.GetText();
            }
            if (currentColumn2.fieldName === "WorkCenter") {
                cellInfo2.value = glWorkCenter.GetValue();
                cellInfo2.text = glWorkCenter.GetText();
            }
       }



       ////////////////////////////////////////////////////////////JAVASCRIPT SECTION FOR GV3
       var currentColumn3 = null;
       function OnStartEditing3(s, e) {
           currentColumn3 = e.focusedColumn;
           var cellInfo3 = e.rowValues[e.focusedColumn.index];

           var entry = getParameterByName('entry');
           if (entry != "V" && entry != "D") {
               e.cancel = false;
           }
           else
               e.cancel = true;

           if (e.focusedColumn.fieldName === "Size") {
               glSize.GetInputElement().value = cellInfo3.value;
               console.log(cellInfo3.value + ' value to. ' + glSize.GetInputElement().value);
           }
       }

       function OnEndEditing3(s, e) {
           var cellInfo3 = e.rowValues[currentColumn3.index];
           if (currentColumn3.fieldName === "Size") {
               cellInfo3.value = glSize.GetValue();
               cellInfo3.text = glSize.GetText();
           }
       }


       Number.prototype.format = function (d, w, s, c) {
           var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
               num = this.toFixed(Math.max(0, ~~d));

           return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
       };


       function autocalculateSizeBreakdown(s, e) {
           var totalqty = 0.00;
           var qty = 0.00;
           setTimeout(function () {
               var indicies = gv3.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indicies.length; i++) {
                   if (gv3.batchEditApi.IsNewRow(indicies[i])) {
                       qty = gv3.batchEditApi.GetCellValue(indicies[i], "Qty");
                       totalqty += qty;
                   }
                   else {
                       var key = gv3.GetRowKey(indicies[i]);
                       if (gv3.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + indicies[i]);
                       else {
                           qty = gv3.batchEditApi.GetCellValue(indicies[i], "Qty");
                           totalqty += qty;
                       }
                   }
               }
               console.log(totalqty);
               txtDISQty.SetText(totalqty.format(2, 3, ',', '.'));
           }, 500);
       }


       //function checkdoc(s, e) {
       //    var transdoc;
       //    var getalltrans;
       //    var indicies = gv2.batchEditApi.GetRowVisibleIndices();
       //    console.log(indicies.length);
       //    for (var i = 0; i < indicies.length; i++) {
       //        if (gv2.batchEditApi.IsNewRow(indicies[i])) {
       //            transdoc = gv2.batchEditApi.GetCellValue(indicies[i], "Step") + ";";
       //            getalltrans += transdoc;
       //        }
       //        else {
       //            var keyB = gv2.GetRowKey(indicies[i]);
       //            if (gv2.batchEditApi.IsDeletedRow(keyB))
       //                console.log("deleted row " + indicies[i]);
       //            else {
       //                transdoc = gv2.batchEditApi.GetCellValue(indicies[i], "Step") + ";";
       //                getalltrans += transdoc;

       //            }
       //        }
       //    }
       //    glStep1.GetGridView().PerformCallback('checkdoc' + '|' + getalltrans + '|' + 'code');
       //    e.processOnServer = false;
       //}

       function checkdocs(s, e) {
           var transdoc;
           var getalltrans;
           var indicies = gv1.batchEditApi.GetRowVisibleIndices();
           console.log(indicies.length);
           for (var i = 0; i < indicies.length; i++) {
               if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                   transdoc = gv1.batchEditApi.GetCellValue(indicies[i], "Step") + ";";
                   getalltrans += transdoc;
               }
               else {
                   var keyB = gv1.GetRowKey(indicies[i]);
                   if (gv1.batchEditApi.IsDeletedRow(keyB))
                       console.log("deleted row " + indicies[i]);
                   else {
                       transdoc = gv1.batchEditApi.GetCellValue(indicies[i], "Step") + ";";
                       getalltrans += transdoc;

                   }
               }
           }

           var transdoc1;
           var getalltrans1 = "'';";
           var indicies1 = gv2.batchEditApi.GetRowVisibleIndices();
           console.log(indicies1.length);
           for (var i = 0; i < indicies1.length; i++) {
               if (gv2.batchEditApi.IsNewRow(indicies1[i])) {
                   console.log(gv2.batchEditApi.GetCellValue(indicies1[i], "Step"));
                   transdoc1 = gv2.batchEditApi.GetCellValue(indicies1[i], "Step") + ";";
                   getalltrans1 += transdoc1;
               }
               else {
                   var keyB = gv2.GetRowKey(indicies1[i]);
                   if (gv2.batchEditApi.IsDeletedRow(keyB))
                       console.log("deleted row " + indicies1[i]);
                   else {
                       transdoc1 = gv2.batchEditApi.GetCellValue(indicies1[i], "Step") + ";";
                       getalltrans1 += transdoc1;
                   }
               }
           }

           glStep.GetGridView().PerformCallback('stepcode' + '|' + getalltrans + '|' + getalltrans1 + '|' + 'code');
           e.processOnServer = false;
       }

       var transtype = getParameterByName('transtype');
       function onload() {
           fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + txtDocnumber.GetText() + '&transtype=' + transtype);
           SetVals();
       }
    
       function OnGetRowValues(values) {
           setTimeout(function () {
               //alert(values);
               //CINCustomerCode.SetValue(values[0].trim());
               //CINBrand.SetValue(values[1].trim());
               //CINGender.SetValue(values[2].trim());
               //CINProductCategory.SetValue(values[3].trim());
               //CINFitCode.SetValue(values[4].trim());
               //CINFabricCode.SetValue(values[5]);
               //CINDesigner.SetValue(values[6]);
               //CINWashDescription.SetText(values[7]);
               cp.PerformCallback('PISNumber');
               //CINDISNumber.SetText(CINPISNumber.GetText() == "" ? "" : values[8] + '-001');
           }, 500);
       }

       function SetVals() {
           var yosh = CINPISNumber.GetText() == "" ? true : false;
           CINCustomerCode.SetEnabled(yosh);
           CINBrand.SetEnabled(yosh);
           CINGender.SetEnabled(yosh);
           CINProductCategory.SetEnabled(yosh);
           CINFitCode.SetEnabled(yosh);
           CINFabricCode.SetEnabled(yosh);
           if (CINPISNumber.GetText() == "") { 
               CINDesigner.SetEnabled(true);
           }
           else {
               if (CINDesigner.GetText() == "") {
                   CINDesigner.SetEnabled(true);
               }
               else {
                   CINDesigner.SetEnabled(false);
               }
           }
           CINWashDescription.SetEnabled(yosh);
           CINDISNumber.SetEnabled(yosh);
       }
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
                    <dx:ASPxLabel runat="server" Text="Design Information Sheet" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
            EnableViewState="False" HeaderText="Notes" Height="370px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="470"
            ShowCloseButton="False" Collapsed="true" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" />
            </ContentCollection>
        </dx:ASPxPopupControl>
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
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="1240px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="806px" style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General Information" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="PIS Number:" Name="PIS" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glPIS" runat="server" DataSourceID="sdsPIS" ClientInstanceName="CINPISNumber" KeyFieldName="PISNumber" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewCommandColumn ShowInCustomizationForm="True" VisibleIndex="0" Width="10px"></dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn FieldName="PISNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="PISDescription" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="CustomerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Brand" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Gender" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="ProductCategory" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="FitCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="FabricCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Designer" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="WashDescription" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="10">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents ValueChanged="function(s,e){var g = CINPISNumber.GetGridView();
                                                                g.GetRowValues(g.GetFocusedRowIndex(), 'CustomerCode;Brand;Gender;ProductCategory;FitCode;FabricCode;Designer;WashDescription;PISNumber', OnGetRowValues); 
                                                                SetVals(); }" /> 
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" OnLoad="LookupLoad" ReadOnly =" true" ClientInstanceName="txtDocnumber">
                                                        <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Type:" Name="Type" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glType" runat="server" DataSourceID="sdsType" KeyFieldName="Type" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px" ClientInstanceName="CINType">
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                            <ClientSideEvents ValueChanged="function (s,e){cp.PerformCallback('OriginalDIS');}"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Doc Date:" Name="DocDate" RequiredMarkDisplayMode="Required" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDocDate" ClientInstanceName="CINDocDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                        <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Original DIS :" Name="OriginalDIS" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glOriginalDIS" runat="server" DataSourceID="sdsOriginalDIS" ClientInstanceName="CINOriginalDIS" KeyFieldName="DocNumber" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Due Date:" Name="DueDate" RequiredMarkDisplayMode="Required" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDueDate" ClientInstanceName="CINDueDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                        <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <dx:LayoutItem Caption="DIS Number:" Name="DocNumber" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDISNumber" runat="server" Width="170px" OnLoad="LookupLoad" ClientInstanceName="CINDISNumber">
                                                        <%--<ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>--%>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Status" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStatus" runat="server" ReadOnly="true" Width="170px" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Color:" Name="Color" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glColor" runat="server" DataSourceID="sdsColor" KeyFieldName="ColorGroup" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Design Number" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStyleNo" runat="server" ClientVisible="false" ReadOnly="false" Width="170px" OnLoad="TextboxLoad">
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                    <RequiredField IsRequired="True"/>
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink"></InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> --%>
                                            <dx:LayoutItem Caption="Designer :" Name="Designer" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glDesigner" runat="server" DataSourceID="sdsSupplier" KeyFieldName="EmployeeCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px" ClientInstanceName="CINDesigner">
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="SetVals"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="EmployeeCode" ReadOnly="True" VisibleIndex="0" >
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1" >
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Customer :" Name="Customer" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glCustomer" runat="server" ClientInstanceName="CINCustomerCode" DataSourceID="sdsCustomer" KeyFieldName="BizPartnerCode" TextFormatString="{0}" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                    <RequiredField IsRequired="True"/>
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink" />
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Customer" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCustomer" ClientInstanceName="CINCustomerCode" runat="server" Width="170px" >
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                    <RequiredField IsRequired="True"/>
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink"></InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> --%>
                                            <dx:LayoutItem Caption="JO Number" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtJONumber" runat="server" ReadOnly="true" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Brand :" Name="Brand" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glBrand" runat="server" ClientInstanceName="CINBrand" DataSourceID="sdsBrand" KeyFieldName="BrandCode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                    <RequiredField IsRequired="True"/>
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink" />
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <%--<dx:LayoutItem Caption="Brand" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtBrand" ClientInstanceName="CINBrand" runat="server" Width="170px" >
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                    <RequiredField IsRequired="True"/>
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink"></InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%> 
                                            <dx:LayoutItem Caption="DIS Quantity" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxTextBox ID="txtDISQty" runat="server" ReadOnly="true" Width="170px" ClientInstanceName="txtDISQty" DisplayFormatString="{0:N}"> 
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Gender :" Name="Gender" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glGender" runat="server" DataSourceID="sdsGender" ClientInstanceName="CINGender" KeyFieldName="GenderCode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                    <RequiredField IsRequired="True"/>
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink" />
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <%--<dx:LayoutItem Caption="Gender" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtGender" ClientInstanceName="CINGender" runat="server" Width="170px" >
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                    <RequiredField IsRequired="True"/>
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink"></InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> --%>
                                            <dx:LayoutItem Caption="Total DIS Days" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxTextBox ID="txtTotalDISDays" runat="server" ReadOnly="true" Width="170px" ClientInstanceName="txtTotalDISQty" DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Product Category" Name="Category" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glCategory" runat="server" DataSourceID="sdsCategory" ClientInstanceName="CINProductCategory" KeyFieldName="ProductCategoryCode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                    <RequiredField IsRequired="True"/>
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink" />
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <%--<dx:LayoutItem Caption="Product Category" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCategory" ClientInstanceName="CINProductCategory" runat="server" Width="170px" >
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                    <RequiredField IsRequired="True"/>
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink"></InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> --%>
                                            <dx:LayoutItem Caption="Washing Instruction" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtWashingInstruction" runat="server" Width="170px" ClientInstanceName="CINWashDescription">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Fit Code:" Name="Fitting" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glFitting" runat="server" DataSourceID="sdsFitting" ClientInstanceName="CINFitCode" KeyFieldName="FitCode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                    <RequiredField IsRequired="True"/>
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink" />
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <%--<dx:LayoutItem Caption="Fit Code" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtFitting" ClientInstanceName="CINFitCode" runat="server" Width="170px" >
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                    <RequiredField IsRequired="True"/>
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> --%>
                                            <dx:LayoutItem Caption="Specs" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSpecs" runat="server" ReadOnly="false" Width="170px" OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Fabric Code:" Name="Fabric" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glFabric" runat="server" DataSourceID="sdsFabric" ClientInstanceName="CINFabricCode" KeyFieldName="FabricCode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                                <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                    <RequiredField IsRequired="True"/>
                                                                </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink" />
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            <%--<dx:LayoutItem Caption="Fabric Code" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtFabric" ClientInstanceName="CINFabricCode" runat="server" Width="170px" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> --%>
                                            <dx:LayoutItem Caption="Shrinkage" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtShrinkage" runat="server" ReadOnly="false" Width="170px" Onload="TextboxLoad">
                                                        </dx:ASPxTextBox>
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
                                    <dx:LayoutGroup Caption="Customer Issuance and Return" ColCount="2" ColSpan ="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Date Sent:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDateSent" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Returned Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtReturnedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Last Date Sent:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastDateSent" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Last Returned Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLastReturnedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>  
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field 1:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad">
                                                            <%--<ClientSideEvents Validation="function(){isValid = true;}" />--%>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad">
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
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <%--<dx:LayoutGroup Caption="Journal Entries">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvJournal" runat="server" AutoGenerateColumns="False" Width="850px" ClientInstanceName="gvJournal"  KeyFieldName="RTransType;TransType"  >
                                                            <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                            <SettingsPager Mode="ShowAllRecords" />  
                                                            <SettingsEditing Mode="Batch"/>
                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130"  /> 
                                                            <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="AccountCode" Name="jAccountCode" ShowInCustomizationForm="True" VisibleIndex="0" Width ="120px" Caption="Account Code" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="AccountDescription" Name="jAccountDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width ="150px" Caption="Account Description" >
                                                                </dx:GridViewDataTextColumn>
																<dx:GridViewDataTextColumn FieldName="SubsidiaryCode" Name="jSubsidiaryCode" ShowInCustomizationForm="True" VisibleIndex="2" Width ="120px" Caption="Subsidiary Code" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="SubsidiaryDescription" Name="jSubsidiaryDescription" ShowInCustomizationForm="True" VisibleIndex="3" Width ="150px" Caption="Subsidiary Description" >
                                                                </dx:GridViewDataTextColumn>																
																<dx:GridViewDataTextColumn FieldName="ProfitCenter" Name="jProfitCenter" ShowInCustomizationForm="True" VisibleIndex="4" Width ="120px" Caption="Profit Center" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="CostCenter" Name="jCostCenter" ShowInCustomizationForm="True" VisibleIndex="5" Width ="120px" Caption="Cost Center" >
                                                                </dx:GridViewDataTextColumn>
																<dx:GridViewDataTextColumn FieldName="Debit" Name="jDebit" ShowInCustomizationForm="True" VisibleIndex="6" Width ="120px" Caption="Debit  Amount" PropertiesTextEdit-DisplayFormatString="{0:N}">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Credit" Name="jCredit" ShowInCustomizationForm="True" VisibleIndex="7" Width ="120px" Caption="Credit Amount" PropertiesTextEdit-DisplayFormatString="{0:N}">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>--%>
                                    <dx:LayoutGroup Caption="Audit Trail" ColSpan="2" ColCount="2">
                                        <Items>
                                          <dx:LayoutItem Caption="Added By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Added Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Last Edited By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Last Edited Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                            <ClientSideEvents Validation="function(){isValid = true;}" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>  
                                          <dx:LayoutItem Caption="Submitted By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Submitted Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                          </dx:LayoutItem> 
                                          <dx:LayoutItem Caption="Start DIS By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHStartDISBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Start DIS Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHStartDISDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                          </dx:LayoutItem> 
                                          <%--<dx:LayoutItem Caption="Posted By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPostedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                          </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Posted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPostedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                          </dx:LayoutItem>--%>
                                          <dx:LayoutItem Caption="Cancelled By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem>
                                          <dx:LayoutItem Caption="Cancelled Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
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
                            <dx:LayoutGroup Caption="Costing" >
                                <Items>
                                    <dx:LayoutItem Caption="Labor Cost" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" >
                                                <dx:ASPxTextBox ID="txtCSTLaborCost" runat="server" ReadOnly="true" Width="170px" ClientInstanceName="txtCSTLaborCost" DisplayFormatString="f4">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Material Cost" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" >
                                                <dx:ASPxTextBox ID="txtCSTMaterialCost" runat="server" ReadOnly="true" Width="170px" ClientInstanceName="txtCSTMaterialCost" DisplayFormatString="f4">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Total DIS Cost" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" >
                                                <dx:ASPxTextBox ID="txtCSTTotalDISCost" runat="server" ReadOnly="true" Width="170px" ClientInstanceName="txtCSTTotalDISCost" DisplayFormatString="f4">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                            <dx:LayoutGroup Caption="Step" >
                                <Items>
                                    <dx:LayoutItem Caption="Step Template Code" Width="100%" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <dx:ASPxGridLookup ID="glStepTemplateCode" runat="server" DataSourceID="sdsStepTemplate" KeyFieldName="StepTemplateCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="200px">
                                                                <GridViewProperties>
                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                    <Settings ShowFilterRow="True" />
                                                                </GridViewProperties>
                                                            </dx:ASPxGridLookup> 
                                                        </td>
                                                        <td><dx:ASPxLabel Text="" runat="server" Width="5" /></td>
                                                        <td>
                                                            <dx:ASPxButton ID="btnGenerate" runat="server" Width="84px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Text="Generate" Theme="MetropolisBlue" >
                                                                <ClientSideEvents Click="function(s,e) {cp.PerformCallback('Generate'); e.processOnServer = false;}" />
                                                            </dx:ASPxButton>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem> 
                                    <dx:LayoutItem ShowCaption="False" Width="100%" >
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv2" runat="server" AutoGenerateColumns="False" Width="985px" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv2" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="LineNumber"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing2" 
                                                        BatchEditEndEditing="OnEndEditing2"/>
                                                    <SettingsPager Mode="ShowAllRecords"/><SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="150" ShowFooter="True"  /> 
                                                    <SettingsCommandButton>
                                                        <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                        <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                        <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                    </SettingsCommandButton>
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True"  ShowNewButtonInHeader="True" VisibleIndex="0" Width="70px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="BizPartner">
                                                                    <Image IconID="support_info_16x16" ToolTip="BizPartner"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete1">
                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False" VisibleIndex="0" ReadOnly="true"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="true" VisibleIndex="2" Caption="Line" ReadOnly="True" Width="100px"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Step" ShowInCustomizationForm="True" VisibleIndex="3" Width="100px" UnboundType="String">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glStep1" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnLoad="gvLookupLoad" 
                                                                    DataSourceID="sdsSTStep" KeyFieldName="Step" ClientInstanceName="glStep1" TextFormatString="{0}" Width="100px"  ><%--OnInit="lookupStep_Init"--%>
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Step" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" /> 
                                                                    <%--<ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="checkdoc" CloseUp="gridLookup_CloseUp" />--%>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="WorkCenter" ShowInCustomizationForm="True" VisibleIndex="4" Width="100px" UnboundType="String">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glWorkCenter" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnLoad="gvLookupLoad"
                                                                    DataSourceID="sdsSTWorkCenter" KeyFieldName="Code" ClientInstanceName="glWorkCenter" TextFormatString="{0}" Width="100px"  >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Code" Caption ="WorkCenterCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="2" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="LaborCost" Name="LaborCost" ShowInCustomizationForm="True" VisibleIndex="6" Caption="Labor Cost" UnboundType="Decimal">
                                                            <PropertiesSpinEdit NullDisplayText="0.0000" ConvertEmptyStringToNull="False" ClientInstanceName="txtLaborCost" NullText="0.0000"  DisplayFormatString="f4" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" Width="100px">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataDateColumn Caption="TargetDateIn" Name="TargetDateIN" ShowInCustomizationForm="True" VisibleIndex="7" FieldName="TargetDateIN" ></dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn Caption="TargetDateOut" Name="TargetDateOUT" ShowInCustomizationForm="True" VisibleIndex="8" FieldName="TargetDateOUT" ></dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn Caption="SpecialInstruction" Name="SpecialInst" ShowInCustomizationForm="True" VisibleIndex="9" FieldName="SpecialInst" Width="200px"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn Caption="DateIn" Name="DateIN" ShowInCustomizationForm="True" VisibleIndex="10" FieldName="DateIN" PropertiesDateEdit-ConvertEmptyStringToNull="true"></dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn Caption="DateOut" Name="DateOUT" ShowInCustomizationForm="True" VisibleIndex="11" FieldName="DateOUT" PropertiesDateEdit-ConvertEmptyStringToNull="true"></dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Days" Name="Days" ShowInCustomizationForm="True" VisibleIndex="12" Caption="Days" UnboundType="Integer">
                                                            <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="False" ClientInstanceName="DISDays" NullText="0"  DisplayFormatString="f" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" Width="100px">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn Caption="Remarks" Name="Remarks" ShowInCustomizationForm="True" VisibleIndex="13" FieldName="Remarks" Width="200px" ></dx:GridViewDataTextColumn>
                                                        
                                                        <dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="21" FieldName="Field1" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="22" FieldName="Field2" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="23" FieldName="Field3" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="24" FieldName="Field4" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="25" FieldName="Field5" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="26" FieldName="Field6" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="27" FieldName="Field7" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="28" FieldName="Field8" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="29" FieldName="Field9" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                    </Columns>
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                            <dx:LayoutGroup Caption="Bill of Material" >
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="985px" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" KeyFieldName="LineNumber"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" Init="OnInitTrans" />
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing"/>
                                                    <SettingsPager Mode="ShowAllRecords"/><SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="150" ShowFooter="True"  /> 
                                                    <SettingsCommandButton>
                                                        <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                        <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                        <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                    </SettingsCommandButton>
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True"  ShowNewButtonInHeader="True" VisibleIndex="0" Width="70px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                       <Image IconID="support_info_16x16" ToolTip="Item Info"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False" VisibleIndex="0" ReadOnly="true"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="false" VisibleIndex="2" Caption="Line" ReadOnly="True" Width="100px"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Step" ShowInCustomizationForm="True" VisibleIndex="3" Width="100px" UnboundType="String">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glStep" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnLoad="gvLookupLoad" OnInit="lookupBOM_Init"
                                                                    DataSourceID="sdsBOMStep" KeyFieldName="Step" ClientInstanceName="glStep" TextFormatString="{0}" Width="100px"  >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Step" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="checkdocs" CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="4" Name="glpItemCode" Width="200px">                                                            
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false"
                                                                    DataSourceID="sdsItem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="200px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" Settings-VerticalScrollBarMode="Visible"> 
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True"/>
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  DropDown="function(s,e){gl.GetGridView().PerformCallback(); e.processOnServer = false;}"
                                                                         ValueChanged="function(s,e){
                                                                        if(itemc != gl.GetValue()){
                                                                        gl2.GetGridView().PerformCallback('ItemCode' + '|' + gl.GetValue() + '|' + 'code');
                                                                        e.processOnServer = false;
                                                                        valchange = true;}}" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="5" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" KeyFieldName="ColorCode"  OnInit="lookupItem_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp" DropDown="function dropdown(s, e){
                                                                gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ShowInCustomizationForm="True" VisibleIndex="5" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl3" KeyFieldName="ClassCode"  OnInit="lookupItem_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="function dropdown(s, e){
                                                                gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Name="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl4" KeyFieldName="SizeCode"  OnInit="lookupItem_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp" DropDown="function dropdown(s, e){
                                                                gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Consumption" Name="Consumption" ShowInCustomizationForm="True" VisibleIndex="7" Caption="Consumption" UnboundType="Decimal">
                                                            <PropertiesSpinEdit NullDisplayText="0.000000" ConvertEmptyStringToNull="False" ClientInstanceName="txtConsumption" NullText="0.000000"  DisplayFormatString="f6" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" Width="100px">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <%--<ClientSideEvents ValueChanged="autocalculate"></ClientSideEvents>--%>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Cost" Name="Cost" ShowInCustomizationForm="True" VisibleIndex="8" Caption="Cost" UnboundType="Decimal">
                                                            <PropertiesSpinEdit NullDisplayText="0.0000" ConvertEmptyStringToNull="False" ClientInstanceName="txtCost" NullText="0.0000"  DisplayFormatString="f4" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" Width="100px">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <%--<ClientSideEvents ValueChanged="autocalculate"></ClientSideEvents>--%>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="11" FieldName="Field1" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="12" FieldName="Field2" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="13" FieldName="Field3" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="14" FieldName="Field4" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="15" FieldName="Field5" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="16" FieldName="Field6" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="17" FieldName="Field7" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="18" FieldName="Field8" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="19" FieldName="Field9" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                    </Columns>
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                            <dx:LayoutGroup Caption="Size Breakdown" >
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv3" runat="server" AutoGenerateColumns="False" Width="985px" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv3" KeyFieldName="LineNumber"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" Init="OnInitTrans"/>
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing3" BatchEditEndEditing="OnEndEditing3"/>
                                                    <SettingsPager Mode="ShowAllRecords"/><SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="150" ShowFooter="True"  /> 
                                                    <SettingsCommandButton>
                                                        <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                        <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                        <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                    </SettingsCommandButton>
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True"  ShowNewButtonInHeader="True" VisibleIndex="0" Width="70px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete2">
                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False" VisibleIndex="0" ReadOnly="true"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="False" VisibleIndex="2" Caption="Line" ReadOnly="True" Width="100px"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Size" ShowInCustomizationForm="True" VisibleIndex="3" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSize" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnLoad="gvLookupLoad"
                                                                    DataSourceID="sdsSize" KeyFieldName="SizeCode" ClientInstanceName="glSize" TextFormatString="{0}" Width="100px"  >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Qty" Name="Qty" ShowInCustomizationForm="True" VisibleIndex="6" Caption="Qty" UnboundType="Decimal">
                                                            <PropertiesSpinEdit NullDisplayText="0.00" ConvertEmptyStringToNull="False" ClientInstanceName="txtQty" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" Width="100px">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculateSizeBreakdown" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="11" FieldName="Field1" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="12" FieldName="Field2" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="13" FieldName="Field3" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="14" FieldName="Field4" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="15" FieldName="Field5" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="16" FieldName="Field6" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="17" FieldName="Field7" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="18" FieldName="Field8" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="19" FieldName="Field9" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
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
                    <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" 
                    TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                        <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn" 
                            ClientInstanceName="btn" UseSubmitBehavior="false" CausesValidation="true">
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
                        <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="False">
                             <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                             </dx:ASPxButton>
                        <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="False">
                             <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                             </dx:ASPxButton> 
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Loading..." Modal="true" ClientInstanceName="loader" ContainerElementID="gv1">
             <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
    </form>
    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.DIS" DataObjectTypeName="Entity.DIS" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail1" runat="server" SelectMethod="getDetail" TypeName="Entity.DIS+DISBillOfMaterial" DataObjectTypeName="Entity.DIS+DISBillOfMaterial" DeleteMethod="DeleteDISBillOfMaterial" InsertMethod="AddDISBillOfMaterial" UpdateMethod="UpdateDISBillOfMaterial">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail2" runat="server" SelectMethod="getDetail" TypeName="Entity.DIS+DISStep" DataObjectTypeName="Entity.DIS+DISStep" DeleteMethod="DeleteDISStep" InsertMethod="AddDISStep" UpdateMethod="UpdateDISStep">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail3" runat="server" SelectMethod="getDetail" TypeName="Entity.DIS+DISSizeBreakdown" DataObjectTypeName="Entity.DIS+DISSizeBreakdown" DeleteMethod="DeleteDISSizeBreakdown" InsertMethod="AddDISSizeBreakdown" UpdateMethod="UpdateDISSizeBreakdown">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.DIS+JournalEntry" >
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
    <asp:SqlDataSource ID="sdsDetail3" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Production.DISSizeBreakdown where DocNumber is null " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail1" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Production.DISBillOfMaterial where DocNumber is null " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Production.DISStep where DocNumber is null " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Description AS Type FROM it.GenericLookup Where LookUpKey = 'DISTYPE'" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsPIS" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select A.PISNumber, A.PISDescription, CustomerCode, Brand, Gender, ProductCategory, FitCode, FabricCode, Designer, WashDescription from Production.ProductInfoSheet A where ISNULL(CancelledBy,'') = ''" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.BPCustomerInfo WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ColorGroup, Description FROM Masterfile.ColorGroup WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsOriginalDIS" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber, DocDate FROM Production.DIS WHERE ISNULL(SubmittedBy,'') != ''" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBrand" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BrandCode, BrandName FROM Masterfile.Brand WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsGender" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT GenderCode, Description FROM Masterfile.Gender WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsFitting" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT FitCode, FitName FROM Masterfile.Fit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSTStep" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT StepCode AS Step, Description, '' AS WorkCenter, '' AS LaborCost, GETDATE() AS TargetDateIN, GETDATE() AS TargetDateOUT,'' AS SpecialInst, '' AS DateIN, '' AS DateOUT,'' AS Remarks, '' AS Field1, '' AS Field2, '' AS Field3, '' AS Field4, '' AS Field5, '' AS Field6, '' AS Field7, '' AS Field8, '' AS Field9 FROM Masterfile.Step WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBOMStep" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT StepCode AS Step, Description, '' AS ItemCode, '' AS ColorCode, '' AS ClassCode, '' AS SizeCode, '' AS Consumption, '' AS Cost, '' AS Field1, '' AS Field2, '' AS Field3, '' AS Field4, '' AS Field5, '' AS Field6, '' AS Field7, '' AS Field8, '' AS Field9 FROM Masterfile.Step WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSTWorkCenter" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select SupplierCode AS Code, Name AS Description from Masterfile.BPSupplierInfo WHERE ISNULL(IsInactive,0) = 0 UNION ALL select EmployeeCode AS Code, EmployeeID AS Description from Masterfile.BPEmployeeInfo WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] WHERE ISNULL(IsInactive,0)=0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [ColorCode], [ClassCode], [SizeCode] FROM Masterfile.[ItemDetail] WHERE ISNULL(IsInactive,0)=0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT SizeCode, Description FROM Masterfile.Size WHERE ISNULL(IsInactive,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSupplier" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT EmployeeCode, UPPER(ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'')) AS Name FROM Masterfile.BPEmployeeInfo WHERE ISNULL([IsInactive],0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsStepTemplate" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT StepTemplateCode, Description FROM Masterfile.StepTemplate WHERE ISNULL(IsInactive,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCategory" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ProductCategoryCode, Description from Masterfile.ProductCategory WHERE ISNULL(IsInactive,0) = 0 AND ItemCategoryCode = 1" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsFabric" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT FabricCode, FabricDescription FROM Masterfile.Fabric" OnInit ="Connection_Init"></asp:SqlDataSource>
</body>
</html>