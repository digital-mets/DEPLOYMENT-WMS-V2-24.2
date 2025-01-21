<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmCashPaymentVoucher.aspx.cs" Inherits="GWL.frmCashPaymentVoucher" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Cash Payment Voucher</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%>


     <!--#region Region Javascript-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 800px; /*Change this whenever needed*/
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
           gvJournal.SetWidth(width - 100);
       }

       function OnUpdateClick(s, e) { //Add/Edit/Close button function
           var btnmode = btn.GetText(); //gets text of button
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

       function OnConfirm(s, e) {//function upon saving entry
           if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
               e.cancel = true;
       }

       function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
           if (s.cp_success) {
               if (s.cp_valmsg != null) {
                   alert(s.cp_valmsg);
                   delete (s.cp_valmsg);
               }
               alert(s.cp_message);
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
           if (s.cp_refdel != null) {
               gv2.CancelEdit();
               delete (s.cp_refdel);
               autocalculate();
           }
           if (s.cp_generated != null) {
               autocalculate();
               delete (s.cp_generated);
           }
           if (s.cp_forceclose) {//NEWADD
               delete (s.cp_forceclose);
               window.close();
           }
       }

       var index;
       var closing;
       var valchange;
       var itemc; //variable required for lookup
       var currentColumn = null;
       var isSetTextRequired = false;
       var linecount = 1;
       function OnStartEditing(s, e) {//On start edit grid function     
           currentColumn = e.focusedColumn;
           var cellInfo = e.rowValues[e.focusedColumn.index];
           itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "TransDocNumber"); //needed var for all lookups; this is where the lookups vary for

           var entry = getParameterByName('entry');
           if (entry != "V" && entry != "D") {
               if (e.focusedColumn.fieldName != "TransDocNumber" && e.focusedColumn.fieldName != "TransAppliedAmount"
                   && e.focusedColumn.fieldName != "Field1" && e.focusedColumn.fieldName != "Field2"
                   && e.focusedColumn.fieldName != "Field3" && e.focusedColumn.fieldName != "Field4"
                   && e.focusedColumn.fieldName != "Field5" && e.focusedColumn.fieldName != "Field6"
                   && e.focusedColumn.fieldName != "Field7" && e.focusedColumn.fieldName != "Field8"
                   && e.focusedColumn.fieldName != "Field9") {
                   e.cancel = true;
               }
           }
           else
               e.cancel = true;

           if (e.focusedColumn.fieldName === "TransDocNumber") { //Check the column name
               gl.GetInputElement().value = cellInfo.value; //Gets the column value
               isSetTextRequired = true;
               index = e.visibleIndex;
               closing = true;
           }
           if (e.focusedColumn.fieldName === "TransType") {
               gl2.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "TransDate") {
               gl3.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "DueDate") {
               gl4.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "AccountCode") {
               gl5.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "SubsidiaryCode") {
               gl6.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "ProfitCenterCode") {
               gl7.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "CostCenterCode") {
               gl10.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "TransAmount") {
               gl8.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "TransAppliedAmount") {
               gl9.GetInputElement().value = cellInfo.value;
           }
       }

       function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
           var cellInfo = e.rowValues[currentColumn.index];
           if (currentColumn.fieldName === "TransDocNumber") {
               cellInfo.value = gl.GetValue();
               cellInfo.text = gl.GetText();
               //valchange = true;
           }
           if (currentColumn.fieldName === "TransType") {
               cellInfo.value = gl2.GetValue();
               cellInfo.text = gl2.GetText();
           }
           if (currentColumn.fieldName === "TransDate") {
               console.log(cellInfo.value);
               console.log(cellInfo.text);
               cellInfo.value = gl3.GetValue();
               cellInfo.text = gl3.GetText();
           }
           if (currentColumn.fieldName === "DueDate") {
               cellInfo.value = gl4.GetValue();
               cellInfo.text = gl4.GetText();
           }
           if (currentColumn.fieldName === "AccountCode") {
               cellInfo.value = gl5.GetValue();
               cellInfo.text = gl5.GetText();
           }
           if (currentColumn.fieldName === "SubsidiaryCode") {
               cellInfo.value = gl6.GetValue();
               cellInfo.text = gl6.GetText();
           }
           if (currentColumn.fieldName === "ProfitCenterCode") {
               cellInfo.value = gl7.GetValue();
               cellInfo.text = gl7.GetText();
           }
           if (currentColumn.fieldName === "CostCenterCode") {
               cellInfo.value = gl10.GetValue();
               cellInfo.text = gl10.GetText();
           }
           if (currentColumn.fieldName === "TransAmount") {
               cellInfo.value = gl8.GetValue();
               cellInfo.text = gl8.GetText();
           }
           if (currentColumn.fieldName === "TransAppliedAmount") {
               cellInfo.value = gl9.GetValue();
               cellInfo.text = gl9.GetText();
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

       var val;
       var temp;
       function ProcessCells(selectedIndex, e, column, s) {
           if (val == null) {
               val = ";;;;";
               console.log("pumasok sa null una");
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
           if (temp[4] == null) {
               temp[4] = "";
           }
           if (temp[5] == null) {
               temp[5] = "";
           }
           if (temp[6] == null) {
               temp[6] = "";
           }
           if (temp[7] == null) {
               temp[7] = "";
           }
           if (temp[8] == null) {
               temp[8] = "";
           }
           if (selectedIndex == 0) {
               if (column.fieldName == "TransType") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
               }
               if (column.fieldName == "TransDate") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
               }
               if (column.fieldName == "DueDate") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
               }
               if (column.fieldName == "AccountCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
               }
               if (column.fieldName == "SubsidiaryCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
               }
               if (column.fieldName == "ProfitCenterCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
               }
               if (column.fieldName == "CostCenterCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[6]);
               }
               if (column.fieldName == "TransAmount") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[7]);
               }
               if (column.fieldName == "TransAppliedAmount") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[8]);
               }
           }
       }

       function GridEnd(s, e) {
           val = s.GetGridView().cp_codes;
           temp = val.split(';');
           if (closing == true) {
               //gv1.batchEditApi.EndEdit();
               gv2.batchEditApi.EndEdit();

               autocalculate();
           }
           loader.Hide();
       }

       function GridEnd_2(s, e) {
           val_2 = s.GetGridView().cp_codes1;
           temp_2 = val_2.split(';');
           console.log(temp);
           //if (closing_2 == true) {
           //    gv1.batchEditApi.EndEdit();
           //}
           if (valchange_2) {
               valchange_2 = false;
               for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                   var column = gv1.GetColumn(i);
                   if (column.visible == false || column.fieldName == undefined)
                       continue;
                   gridcheck = 1;
                   ProcessCells_2(0, index_2, column, gv1);
               }
               gv1.batchEditApi.EndEdit();
               loader.Hide();
           }
           if (valchange_3) {
               valchange_3 = false;
               for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                   var column = gv1.GetColumn(i);
                   if (column.visible == false || column.fieldName == undefined)
                       continue;
                   gridcheck = 2;
                   ProcessCells_2(0, index_2, column, gv1);
               }
               gv1.batchEditApi.EndEdit();
               loader.Hide();
           }
       }

       function lookup(s, e) {
           //if (isSetTextRequired) {//Sets the text during lookup for item code
           //    s.SetText(s.GetInputElement().value);
           //    isSetTextRequired = false;
           //}
       }

       //var preventEndEditOnLostFocus = false;
       function gridLookup_KeyDown(s, e) { //Allows tabbing between gridlookup on details
           isSetTextRequired = false;
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode !== 9) return;
           var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";

           if (gv2.batchEditApi[moveActionName]()) {
               ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
           }
       }

       function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode == 13)
               gv2.batchEditApi.EndEdit();
       }

       function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
           //gv1.batchEditApi.EndEdit();
           gv2.batchEditApi.EndEdit();
       }

       function OnCustomClick(s, e) {
           if (e.buttonID == "Delete") {
               gv2.DeleteRow(e.visibleIndex);
           }
           if (e.buttonID == "ViewReferenceTransaction") {

               var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
               var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
               var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
               window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
               console.log('ViewTransaction')
           }
           autocalculate();
       }

       function lookup_2(s, e) {
           //if (isSetTextRequired) {//Sets the text during lookup for item code
           //    s.SetText(s.GetInputElement().value);
           //    isSetTextRequired = false;
           //}
       }




       //2nd grid's functions
       function OnCustomClick_2(s, e) {
           if (e.buttonID == "Delete1") {
               gv1.DeleteRow(e.visibleIndex);
               autocalculate();
           }
           if (e.buttonID == "ViewReferenceTransaction") {

               var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
               var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
               var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
               window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
               console.log('ViewTransaction')
           }
       }
       function OnConfirm_2(s, e) {//function upon saving entry
           if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
               e.cancel = true;
       }

       var index_2;
       var closing_2;
       var valchange_2 = false;
       var valchange_3 = false;
       var itemc_2; //variable required for lookup
       var currentColumn_2 = null;
       var isSetTextRequired_2 = false;
       var linecount_2 = 1;
       var accountcode;
       function OnStartEditing_2(s, e) {//On start edit grid function     
           currentColumn_2 = e.focusedColumn;
           var cellInfo1 = e.rowValues[e.focusedColumn.index];
           accountcode = s.batchEditApi.GetCellValue(e.visibleIndex, "AccountCode"); //needed var for all lookups; this is where the lookups vary for

           var entry1 = getParameterByName('entry');
           if (entry1 != "V" && entry1 != "D") {
               if (e.focusedColumn.fieldName != "AccountCode" && e.focusedColumn.fieldName != "SubsidiaryCode"
                   && e.focusedColumn.fieldName != "ProfitCenterCode" && e.focusedColumn.fieldName != "CostCenterCode"
                   && e.focusedColumn.fieldName != "DebitAmount" && e.focusedColumn.fieldName != "CreditAmount"
                   && e.focusedColumn.fieldName != "Field1" && e.focusedColumn.fieldName != "Field2"
                   && e.focusedColumn.fieldName != "Field3" && e.focusedColumn.fieldName != "Field4"
                   && e.focusedColumn.fieldName != "Field5" && e.focusedColumn.fieldName != "Field6"
                   && e.focusedColumn.fieldName != "Field7" && e.focusedColumn.fieldName != "Field8"
                   && e.focusedColumn.fieldName != "Field9") {
                   e.cancel = true;
               }
           }
           else
               e.cancel = true;

           if (e.focusedColumn.fieldName === "AccountCode") {
               glAC.GetInputElement().value = cellInfo1.value;
               index_2 = e.visibleIndex;
               isSetTextRequired_2 = true;
           }
           if (e.focusedColumn.fieldName === "SubsidiaryCode") {
               glSC.GetInputElement().value = cellInfo1.value;
               index_2 = e.visibleIndex;
               isSetTextRequired_2 = true;
           }
           if (e.focusedColumn.fieldName === "ProfitCenterCode") {
               glProfitCenterCode.GetInputElement().value = cellInfo1.value;
           }
           if (e.focusedColumn.fieldName === "CostCenterCode") {
               glCostCenterCode.GetInputElement().value = cellInfo1.value;
           }
       }

       var val_2;
       var temp_2;
       function ProcessCells_2(selectedIndex, e, column, s) {
           if (val_2 == null) {
               val_2 = ";";
               temp_2 = val_2.split(';');
           }
           if (selectedIndex == 0) {
               if (gridcheck == 1) {
                   if (column.fieldName == "AccountDescription") {
                       s.batchEditApi.SetCellValue(index_2, column.fieldName, temp_2[0]);
                   }
               }
               else {
                   if (column.fieldName == "SubsidiaryDescription") {
                       s.batchEditApi.SetCellValue(index_2, column.fieldName, temp_2[0]);
                   }
               }
           }
       }

       function OnEndEditing_2(s, e) {//end edit grid function, sets text after select/leaving the current lookup
           var cellInfo1 = e.rowValues[currentColumn_2.index];
           if (currentColumn_2.fieldName === "AccountCode") {
               cellInfo1.value = glAC.GetValue();
               cellInfo1.text = glAC.GetText().toUpperCase();
           }
           if (currentColumn_2.fieldName === "SubsidiaryCode") {
               cellInfo1.value = glSC.GetValue();
               cellInfo1.text = glSC.GetText().toUpperCase();
           }
           if (currentColumn_2.fieldName === "ProfitCenterCode") {
               cellInfo1.value = glProfitCenterCode.GetValue();
               cellInfo1.text = glProfitCenterCode.GetText();
           }
           if (currentColumn_2.fieldName === "CostCenterCode") {
               cellInfo1.value = glCostCenterCode.GetValue();
               cellInfo1.text = glCostCenterCode.GetText();
           }
       }

       function gridLookup_CloseUp_2(s, e) { //Automatically leaves the current cell if an item is selected.
           gv1.batchEditApi.EndEdit();
       }

       function gridLookup_KeyDown_2(s, e) { //Allows tabbing between gridlookup on details
           isSetTextRequired_2 = false;
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode !== 9) return;
           var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
           if (gv1.batchEditApi[moveActionName]()) {
               ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
           }
       }

       function gridLookup_KeyPress_2(s, e) { //Prevents grid refresh when a user press enter key for every column
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode == 13)
               gv1.batchEditApi.EndEdit();
       }

       Number.prototype.format = function (d, w, s, c) {
           var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
               num = this.toFixed(Math.max(0, ~~d));

           return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
       };

       function autocalculate(s, e) {
           var totaladjustment = 0.00;
           var totaldebitamount = 0.00;
           var totalcreditamount = 0.00;
           var debitamount = 0.00;
           var creditamount = 0.00;

           var totalapplied = 0.00;
           var applied = 0.00;

           var cashAmount = 0.00;

           if (speHCash.GetText() == null || speHCash.GetText() == "")
               cashAmount = 0;
           else
               cashAmount = speHCash.GetValue();

           setTimeout(function () {
               var indicies = gv1.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indicies.length; i++) {
                   if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                       debitamount = gv1.batchEditApi.GetCellValue(indicies[i], "DebitAmount");
                       creditamount = gv1.batchEditApi.GetCellValue(indicies[i], "CreditAmount");
                       totaldebitamount += debitamount;
                       totalcreditamount += creditamount;
                   }
                   else {
                       var key = gv1.GetRowKey(indicies[i]);
                       if (gv1.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + indicies[i]);
                       else {
                           debitamount = gv1.batchEditApi.GetCellValue(indicies[i], "DebitAmount");
                           creditamount = gv1.batchEditApi.GetCellValue(indicies[i], "CreditAmount");
                           totaldebitamount += debitamount;
                           totalcreditamount += creditamount;
                       }
                   }
               }
               totaladjustment = totaldebitamount - totalcreditamount;
               txtTotalAdjustment.SetText(totaladjustment.format(2, 3, ',', '.'));

               var indicies2 = gv2.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indicies2.length; i++) {
                   if (gv1.batchEditApi.IsNewRow(indicies2[i])) {
                       applied = gv2.batchEditApi.GetCellValue(indicies2[i], "TransAppliedAmount");
                       totalapplied += +applied;
                   }
                   else {
                       var key = gv2.GetRowKey(indicies2[i]);
                       if (gv2.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + indicies2[i]);
                       else {
                           applied = gv2.batchEditApi.GetCellValue(indicies2[i], "TransAppliedAmount");
                           totalapplied += +applied;
                       }
                   }
               }
               txtTotalAppliedAmount.SetText(totalapplied.format(2, 3, ',', '.'));

               variance = cashAmount - (totalapplied + totaladjustment);
               txtVariance.SetText(variance.format(2, 3, ',', '.'));
               console.log(variance + ' = ' + cashAmount + ' - (' + totalapplied + ' + ' + totaladjustment + ')');
           }, 500);
       }


       function checkdoc(s, e) {
           var transdoc;
           var getalltrans;
           var indicies = gv2.batchEditApi.GetRowVisibleIndices();
           console.log(indicies.length);
           for (var i = 0; i < indicies.length; i++) {
               if (gv2.batchEditApi.IsNewRow(indicies[i])) {
                   transdoc = gv2.batchEditApi.GetCellValue(indicies[i], "TransDocNumber") + ";";
                   getalltrans += transdoc;
               }
               else {
                   var keyB = gv2.GetRowKey(indicies[i]);
                   if (gv2.batchEditApi.IsDeletedRow(keyB))
                       console.log("deleted row " + indicies[i]);
                   else {
                       transdoc = gv2.batchEditApi.GetCellValue(indicies[i], "TransDocNumber") + ";";
                       getalltrans += transdoc;

                   }
               }
           }
           console.log(getalltrans);
           gl.GetGridView().PerformCallback('checkdoc' + '|' + getalltrans + '|' + 'code');
           e.processOnServer = false;
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
                    <dx:ASPxLabel runat="server" Text="Cash Payment Voucher" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="1050px" Height="1240px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="806px" style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" OnLoad="LookupLoad">
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
                                            <dx:LayoutItem Caption="Cash Amount" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <%--<dx:ASPxTextBox ID="txtCashAmount" runat="server" ReadOnly="false" Width="170px" DisplayFormatString="{0:N}" MaxValue="2147483647" ClientInstanceName="txtCashAmount">
                                                            <ClientSideEvents ValueChanged="autocalculate"/>
                                                        </dx:ASPxTextBox>--%>
                                                        <dx:ASPxSpinEdit ID="speHCash" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                            ClientInstanceName ="speHCash" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" OnLoad="SpinEdit_Load">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                             <ClientSideEvents ValueChanged="autocalculate"/>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date:" Name="DocDate" RequiredMarkDisplayMode="Required" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnLoad="Date_Load" Width="170px">
                                                        <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('RefCheck'); }"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Applied" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTotalAppliedAmount" runat="server" ReadOnly="true" Width="170px" ClientInstanceName="txtTotalAppliedAmount" DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>                                                                                        
                                            <dx:LayoutItem Caption="Supplier Code:" Name="SupplierCode" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glSupplierCode" runat="server" DataSourceID="sdsSupplierCode" KeyFieldName="SupplierCode" 
                                                            OnLoad="LookupLoad" TextFormatString="{0}" Width="170px" AutoGenerateColumns="false">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SupplierCode" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="true">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns> 
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function (s, e){ cp.PerformCallback('SupplierCode');  e.processOnServer = false;}"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Adjustment" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxTextBox ID="txtTotalAdjustment" runat="server" ReadOnly="true" Width="170px" ClientInstanceName="txtTotalAdjustment" DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Supplier Name" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSupplierName" runat="server" ReadOnly="false" Width="500px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Variance" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxTextBox ID="txtVariance" runat="server" ReadOnly="true" Width="170px" ClientInstanceName="txtVariance" DisplayFormatString="{0:N}" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="memRemarks" runat="server" Height="150px" Width="500px" OnLoad="Memo_Load">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutGroup Caption="Application Detail" >
                                                <Items>
                                                    <dx:LayoutItem Caption="Reference Numbers:" Name ="RC">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glReferenceChecks" runat="server" AutoGenerateColumns="False" DataSourceID="sdsApplicationDetail" KeyFieldName="RecordID" OnLoad="LookupLoad" SelectionMode="Multiple" TextFormatString="{1}" OnInit="glReferenceChecks_Init">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="RecordID" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransDocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                         <dx:GridViewDataTextColumn FieldName="TransType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn Caption="TransDate" FieldName="TransDate" ShowInCustomizationForm="True" VisibleIndex="4" ReadOnly ="true">
                                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                            <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataDateColumn Caption="DueDate" FieldName="DueDate" ShowInCustomizationForm="True" VisibleIndex="5" ReadOnly ="true">
                                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                            <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                         <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubsidiaryCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransAmount" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="10">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransAppliedAmount" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="11">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents ValueChanged="function(s,e){cp.PerformCallback('Details'); }" />
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="" ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gv2" runat="server" AutoGenerateColumns="False" Width="985px" OnCommandButtonInitialize="gv_CommandButtonInitialize" 
                                                                    OnCellEditorInitialize="gv2_CellEditorInitialize" ClientInstanceName="gv2" OnBatchUpdate="gv2_BatchUpdate" KeyFieldName="DocNumber;LineNumber">
                                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing"/>
                                                                    <SettingsPager Mode="ShowAllRecords"/><SettingsEditing Mode="Batch" />
                                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300" ShowFooter="False" ShowStatusBar="Hidden"/> 
                                                                    <%--<SettingsCommandButton>
                                                                        <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                        <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                        <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                    </SettingsCommandButton>--%>
                                                                    <ClientSideEvents Init="OnInitTrans"></ClientSideEvents>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False" VisibleIndex="0" ReadOnly="true"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True"  ShowNewButtonInHeader="True" VisibleIndex="0" Width="0px">
                                                                            <CustomButtons>
                                                                                <%--<dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>--%>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="true" VisibleIndex="2" Caption="Line" ReadOnly="True" Width="100px"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransDocNumber" VisibleIndex="3" Width="130px" Name="glTransDocNumber" ReadOnly="false">
                                                                             <%--<EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glTransDocNumber" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                                    DataSourceID="sdsApplicationDetail" KeyFieldName="TransDocNumber" ClientInstanceName="gl" TextFormatString="{0}" Width="130px" OnLoad="gvLookupLoad" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="TransDocNumber" ReadOnly="True" VisibleIndex="0" />
                                                                                        <dx:GridViewDataTextColumn FieldName="TransType" ReadOnly="True" VisibleIndex="1" />
                                                                                        <dx:GridViewDataTextColumn FieldName="TransDate" ReadOnly="True" VisibleIndex="2" />
                                                                                        <dx:GridViewDataTextColumn FieldName="DueDate" ReadOnly="True" VisibleIndex="3" />
                                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="4" />
                                                                                        <dx:GridViewDataTextColumn FieldName="SubsidiaryCode" ReadOnly="True" VisibleIndex="5" />
                                                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" ReadOnly="True" VisibleIndex="6" />
                                                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" ReadOnly="True" VisibleIndex="7" />
                                                                                        <dx:GridViewDataTextColumn FieldName="TransAmount" ReadOnly="True" VisibleIndex="8" />
                                                                                        <dx:GridViewDataTextColumn FieldName="TransAppliedAmount" ReadOnly="True" VisibleIndex="9" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="checkdoc" RowClick="function(s,e){
                                                                                         loader.Show();
                                                                                         setTimeout(function(){
                                                                                         gl2.GetGridView().PerformCallback('TransDocNumber' + '|' + gl.GetValue() + '|' + 'ter');
                                                                                         e.processOnServer = false;
                                                                                         valchange = true;
                                                                                        },1000);
                                                                                        }"/>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>--%>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransType" VisibleIndex="4" Width="130px" Caption="TransType" ReadOnly="true">   
                                                                            <%--<EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glTransType" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ReadOnly ="false" 
                                                                                    KeyFieldName="TransType" ClientInstanceName="gl2" TextFormatString="{0}" Width="130px" OnLoad="gvLookupLoad" OnInit="lookup_Init">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="TransType" ReadOnly="True" VisibleIndex="0">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" CloseUp="gridLookup_CloseUp"/>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>--%>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransDate" VisibleIndex="5" Width="130px" Name ="glTransDate" Caption="TransDate" ReadOnly="true" PropertiesTextEdit-ClientInstanceName="gl3" PropertiesTextEdit-DisplayFormatString="MM/dd/yyy">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="DueDate" VisibleIndex="6" Width="130px" Name ="glDueDate" Caption="DueDate" ReadOnly="true" PropertiesTextEdit-ClientInstanceName="gl4" PropertiesTextEdit-DisplayFormatString="MM/dd/yyy">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" VisibleIndex="7" Width="130px" Name="glAccountCode" Caption="AccountCode" ReadOnly="true">
                                                                             <%--<EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glAccountCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init" ReadOnly ="false"
                                                                                KeyFieldName="CheckAmount" ClientInstanceName="gl5" TextFormatString="d" Width="130px" OnLoad="gvLookupLoad">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="0" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                                        DropDown="function dropdown(s, e){
                                                                                        gl5.GetGridView().PerformCallback('AccountCode' + '|' + TransDocNumber + '|' + s.GetInputElement().value);
                                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>--%>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubsidiaryCode" VisibleIndex="8" Width="130px" Name="glSubsidiaryCode" Caption="SubsidiaryCode" ReadOnly="true">
                                                                             <%--<EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glCheckNumber" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init" ReadOnly ="false"
                                                                                KeyFieldName="SubsidiaryCode" ClientInstanceName="gl6" TextFormatString="{0}" Width="130px" OnLoad="gvLookupLoad">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="SubsidiaryCode" ReadOnly="True" VisibleIndex="0" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                                        DropDown="function dropdown(s, e){
                                                                                        gl6.GetGridView().PerformCallback('SubsidiaryCode' + '|' + TransDocNumber + '|' + s.GetInputElement().value);
                                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>--%>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" VisibleIndex="9" Width="130px" Name="glProfitCenterCode" Caption="ProfitCenterCode" ReadOnly="true">
                                                                             <%--<EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glProfitCenterCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init" ReadOnly ="false"
                                                                                KeyFieldName="ProfitCenterCode" ClientInstanceName="gl7" TextFormatString="{0}" Width="130px" OnLoad="gvLookupLoad">
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="SubsidiaryCode" ReadOnly="True" VisibleIndex="0" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                                        DropDown="function dropdown(s, e){
                                                                                        gl7.GetGridView().PerformCallback('ProfitCenterCode' + '|' + TransDocNumber + '|' + s.GetInputElement().value);
                                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>--%>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" VisibleIndex="9" Width="130px" Name="glCostCenterCode" Caption="CostCenterCode" ReadOnly="true">
                                                                             <%--<EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glCostCenterCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                KeyFieldName="CostCenterCode" ClientInstanceName="gl10" TextFormatString="{0}" Width="130px" OnLoad="gvLookupLoad">
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>--%>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="TransAmount" VisibleIndex="11" Width="130px" Caption="TransAmount" ReadOnly="false">   
                                                                             <PropertiesSpinEdit ClientInstanceName="gl8" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0.00" DisplayFormatString="{0:N}">
                                                                             </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="TransAppliedAmount" VisibleIndex="12" Width="130px" Caption="TransAppliedAmount" >   
                                                                             <PropertiesSpinEdit ClientInstanceName="gl9" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00" DisplayFormatString="{0:N}">
                                                                                 <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                 <ClientSideEvents ValueChanged="autocalculate" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="13" FieldName="Field1" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="14" FieldName="Field2" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="15" FieldName="Field3" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="16" FieldName="Field4" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="17" FieldName="Field5" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="18" FieldName="Field6" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="19" FieldName="Field7" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="20" FieldName="Field8" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="21" FieldName="Field9" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="RecordID" Name="RecordID" ShowInCustomizationForm="True" VisibleIndex="22" FieldName="RecordID" UnboundType="String" Width="130px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Adjustment Detail" ColSpan="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="" ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="985px" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                                    OnCellEditorInitialize="gv2_CellEditorInitialize" ClientInstanceName="gv1"  OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber" OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm_2" BatchEditStartEditing="OnStartEditing_2" BatchEditEndEditing="OnEndEditing_2" CustomButtonClick="OnCustomClick_2"/>
                                                                    <SettingsPager Mode="ShowAllRecords"/><SettingsEditing Mode="Batch" />
                                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300" ShowFooter="False" ShowStatusBar="Hidden"/> 
                                                                    <SettingsCommandButton>
                                                                        <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                                        <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                                        <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                                    </SettingsCommandButton>
                                                                    <ClientSideEvents Init="OnInitTrans"></ClientSideEvents>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True"  ShowNewButtonInHeader="True" VisibleIndex="0" Width="50px">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="Delete1">
                                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False" VisibleIndex="0" ReadOnly="true"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="false" VisibleIndex="2" Caption="Line" ReadOnly="True" Width="100px"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" VisibleIndex="3" ReadOnly="true" Width="130px">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glAccountCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                        DataSourceID="sdsCOA" KeyFieldName="AccountCode" ClientInstanceName="glAC" TextFormatString="{0}" Width="130px" OnLoad="gvLookupLoad_2">
                                                                                        <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="OnClick" SettingsPager-PageSize="5">
                                                                                            <SettingsBehavior AllowSelectByRowClick="True" AllowSelectSingleRowOnly="true" 
                                                                                                AllowFocusedRow="true" AllowSort="false"/>
                                                                                        </GridViewProperties>
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="0">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="AccountDescription" ReadOnly="True" VisibleIndex="1">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                        <ClientSideEvents DropDown="lookup_2" KeyPress="gridLookup_KeyPress_2" KeyDown="gridLookup_KeyDown_2" RowClick="function(s,e){
                                                                                         loader.Show();
                                                                                         setTimeout(function(){
                                                                                         glaccountdes.GetGridView().PerformCallback('accountcode' + '|' + glAC.GetValue() + '|' + 'ter');
                                                                                         e.processOnServer = false;
                                                                                         valchange_2 = true;
                                                                                        },1000);
                                                                                        }" ValueChanged="function(){ gv1.batchEditApi.SetCellValue(index, 'SubsidiaryCode', null);
                                                                                                     gv1.batchEditApi.SetCellValue(index, 'SubsidiaryDescription', null);}"/>
                                                                                    </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountDescription" VisibleIndex="4" ReadOnly="true" Width="130px">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup runat="server" OnInit="lookup_Init1" ClientInstanceName="glaccountdes" Width="130px">
                                                                                    <ClientSideEvents EndCallback="GridEnd_2" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubsidiaryCode" VisibleIndex="5" ReadOnly="true" Width="130px">
                                                                        <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glSubsiCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init1" 
                                                                                        DataSourceID="sdsSubsi" KeyFieldName="AccountCode" ClientInstanceName="glSC" TextFormatString="{0}" Width="130px" OnLoad="gvLookupLoad_2">
                                                                                        <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="OnClick" SettingsPager-PageSize="5">
                                                                                            <SettingsBehavior AllowSelectByRowClick="True" AllowFocusedRow="true"
                                                                                                AllowSelectSingleRowOnly="True" />
                                                                                        </GridViewProperties>
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="SubsidiaryCode" ReadOnly="True" VisibleIndex="0">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="1">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="SubsidiaryDescription" ReadOnly="True" VisibleIndex="2">
                                                                                                <Settings AutoFilterCondition="Contains" />
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                        <ClientSideEvents GotFocus="function dropdown(s, e){ 
                                                                                                glSC.GetGridView().PerformCallback('SubsiGetCode' + '|' + accountcode + '|' + glAC.GetValue()); }" 
                                                                                             KeyPress="gridLookup_KeyPress_2" KeyDown="gridLookup_KeyDown_2" RowClick="function(s,e){
                                                                                             loader.Show();
                                                                                             setTimeout(function(){
                                                                                             glaccountdes.GetGridView().PerformCallback('subsicode' + '|' + glSC.GetValue() + '|' + glAC.GetValue());
                                                                                             e.processOnServer = false;
                                                                                             valchange_3 = true;
                                                                                            },1000);
                                                                                            }"/>
                                                                                    </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubsidiaryDescription" ShowInCustomizationForm="True" VisibleIndex="6" UnboundType="Bound" ReadOnly="True" Width="130px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" Name="ProfitCenterCode" ShowInCustomizationForm="True" VisibleIndex="7" Width="130px">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glProfitCenterCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                    DataSourceID="sdsProfitCenterCode" KeyFieldName="ProfitCenterCode" ClientInstanceName="glProfitCenterCode" 
                                                                                    TextFormatString="{0}" Width="130px" OnLoad="gvLookupLoad" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" ReadOnly="True" VisibleIndex="0" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" Name="CostCenterCode" ShowInCustomizationForm="True" VisibleIndex="8" Width="130px">
                                                                            <EditItemTemplate>
                                                                                <dx:ASPxGridLookup ID="glCostCenterCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                    DataSourceID="sdsCostCenterCode" KeyFieldName="CostCenterCode" ClientInstanceName="glCostCenterCode" 
                                                                                    TextFormatString="{0}" Width="130px" OnLoad="gvLookupLoad" >
                                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                                    </GridViewProperties>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" ReadOnly="True" VisibleIndex="0" />
                                                                                    </Columns>
                                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" CloseUp="gridLookup_CloseUp" />
                                                                                </dx:ASPxGridLookup>
                                                                            </EditItemTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="DebitAmount" ShowInCustomizationForm="True" VisibleIndex="9" Width="130px">
                                                                            <PropertiesSpinEdit DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataSpinEditColumn FieldName="CreditAmount" ShowInCustomizationForm="True" VisibleIndex="10" Width="130px">
                                                                            <PropertiesSpinEdit DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                                                <SpinButtons ShowIncrementButtons="False" ></SpinButtons>
                                                                                <ClientSideEvents ValueChanged="autocalculate" />
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
                                    </dx:LayoutGroup>
                           
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field 1:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad">
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
                                                            <%--<ClientSideEvents Validation="function(){isValid = true;}" />--%>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Journal Entries">
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
                                    </dx:LayoutGroup>
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
                                          <dx:LayoutItem Caption="Posted By">
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
                                          </dx:LayoutItem>
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
                                            <dx:LayoutGroup Caption="Reference Detail">
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
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>
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
                            <td>
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                </dx:ASPxButton> 
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Loading..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="gv1">
             <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
    </form>
    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.CashPaymentVoucher" DataObjectTypeName="Entity.CashPaymentVoucher" InsertMethod="InsertData" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:Parameter Name="Conn" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail2" runat="server" SelectMethod="getApplicationDetail" TypeName="Entity.CashPaymentVoucher+CashPaymentVoucherApplication" DataObjectTypeName="Entity.CashPaymentVoucher+CashPaymentVoucherApplication" DeleteMethod="DeleteCashPaymentVoucherApplication" InsertMethod="AddCashPaymentVoucherApplication" UpdateMethod="UpdateCashPaymentVoucherApplication">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getAdjustmentDetail" TypeName="Entity.CashPaymentVoucher+CashPaymentVoucherAdjustment" DataObjectTypeName="Entity.CashPaymentVoucher+CashPaymentVoucherAdjustment" DeleteMethod="DeleteCashPaymentVoucherAdjustment" InsertMethod="AddCashPaymentVoucherAdjustment" UpdateMethod="UpdateCashPaymentVoucherAdjustment">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.CashPaymentVoucher+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.CashPaymentVoucher+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Accounting.CashPaymentVoucherApplication WHERE DocNumber IS NULL" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Accounting.CashPaymentVoucherAdjustment WHERE DocNumber IS NULL" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsApplicationDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT RIGHT('00000'+ CAST(ROW_NUMBER() OVER (ORDER BY DocDate) AS VARCHAR(5)),5) AS LineNumber, DocNumber, DocNumber AS TransDocNumber, TransType, CAST(DocDate AS DATE) AS TransDate, CAST(DueDate AS DATE) AS DueDate, AccountCode, SubsiCode AS SubsidiaryCode, ProfitCenter AS ProfitCenterCode, CostCenter AS CostCenterCode, ISNULL(Amount,0) AS TransAmount, ISNULL(Amount,0) - ISNULL(Applied,0) AS TransAppliedAmount, '' AS Field1, '' AS Field2, '' AS Field3, '' AS Field4, '' AS Field5, '' AS Field6, '' AS Field7, '' AS Field8, '' AS Field9, RecordID FROM Accounting.SubsiLedgerNonInv where (ISNULL(Amount,0) - ISNULL(Applied,0)) !=0 AND ISNULL(CounterDocNumber,'') = ''" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsAdjustmentDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select AccountCode, Description AS AccountDescription, '' AS SubsidiaryCode, '' AS SubsidiaryDescription, '' AS ProfitCenterCode, '' as CostCenterCode, 0 AS DebitAmount, 0 AS CreditAmount, '' AS Field1, '' AS Field2, '' AS Field3, '' AS Field4, '' AS Field5, '' AS Field6, '' AS Field7, '' AS Field8, '' AS Field9 FROM Accounting.ChartOfAccount WHERE ISNULL(IsInactive,0)=0" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsProfitCenterCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DISTINCT ProfitCenterCode, Description from Accounting.ProfitCenter WHERE ISNULL(IsInactive,0)=0" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCostCenterCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DISTINCT CostCenterCode, Description from Accounting.CostCenter WHERE ISNULL(IsInactive,0)=0" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCOA" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select AccountCode,Description AS AccountDescription from Accounting.ChartOfAccount where ISNULL(IsInactive,0) = 0" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSubsi" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select SubsiCode AS SubsidiaryCode,AccountCode,Description AS SubsidiaryDescription from Accounting.GLSubsiCode" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSupplierCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT SupplierCode, Name FROM Masterfile.[BPSupplierInfo] WHERE ISNULL([IsInactive],0) = 0" OnInit = "ConnectionInit_Init"></asp:SqlDataSource>
</body>
</html>
