<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDepositSlip.aspx.cs" Inherits="GWL.frmDepositSlip" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Deposit Slip</title>
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

            if (s.cp_delete) {
                //console.log('here');
                //delete (s.cp_delete);

            }

            if (s.cp_refdel != null) {
                gv2.CancelEdit();
                console.log('bebeloves');
                delete (s.cp_refdel);
                autocalculate();
            }
            if (s.cp_generated != null) {
                autocalculate();
                delete (s.cp_generated);
            }
            if (s.cp_forceclose) {
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
           code = s.batchEditApi.GetCellValue(e.visibleIndex, "RefDocNumber");
           var entry = getParameterByName('entry');

           if (entry != "V" && entry != "D") {
               if (e.focusedColumn.fieldName != "RefDocNumber" && e.focusedColumn.fieldName != "Field1" && e.focusedColumn.fieldName != "Field2" && e.focusedColumn.fieldName != "Field3" && e.focusedColumn.fieldName != "Field4" && e.focusedColumn.fieldName != "Field5" && e.focusedColumn.fieldName != "Field6" && e.focusedColumn.fieldName != "Field7" && e.focusedColumn.fieldName != "Field8" && e.focusedColumn.fieldName != "Field9") {
                   e.cancel = true;
               }
           }
           else e.cancel = true;

           if (e.focusedColumn.fieldName === "RefDocNumber") { //Check the column name
               gl.GetInputElement().value = cellInfo.value; //Gets the column value
               isSetTextRequired = true;
               index = e.visibleIndex;
               closing = true;
           }
           if (e.focusedColumn.fieldName === "BankCode") {
               gl2.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "BankBranch") {
               gl3.GetInputElement().value = cellInfo.value;
           }
           //if (e.focusedColumn.fieldName === "CheckDate") {
           //gl4.GetInputElement().value = cellInfo.value;
           //}
           if (e.focusedColumn.fieldName === "CheckAmount") {
               gl5.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "CheckNumber") {
               gl6.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "BPCode") {
               glBPCode.GetInputElement().value = cellInfo.value;
           }
           if (e.focusedColumn.fieldName === "BPName") {
               glBPName.GetInputElement().value = cellInfo.value;
           }

       }

       function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
           var cellInfo = e.rowValues[currentColumn.index];
           if (currentColumn.fieldName === "RefDocNumber") {
               cellInfo.value = gl.GetValue();
               cellInfo.text = gl.GetText();
               //valchange = true;
           }
           if (currentColumn.fieldName === "BankCode") {
               cellInfo.value = gl2.GetValue();
               cellInfo.text = gl2.GetText();
           }
           if (currentColumn.fieldName === "BankBranch") {
               cellInfo.value = gl3.GetValue();
               cellInfo.text = gl3.GetText();
           }
           //if (currentColumn.fieldName === "CheckDate") {
           //cellInfo.value = gl4.GetValue();
           //cellInfo.text = gl4.GetText();
           //}
           if (currentColumn.fieldName === "CheckAmount") {
               cellInfo.value = gl5.GetValue();
               cellInfo.text = gl5.GetText();
           }
           if (currentColumn.fieldName === "CheckNumber") {
               cellInfo.value = gl6.GetValue();
               cellInfo.text = gl6.GetText();
           }
           if (currentColumn.fieldName === "BPCode") {
               cellInfo.value = glBPCode.GetValue();
               cellInfo.text = glBPCode.GetText();
           }
           if (currentColumn.fieldName === "BPName") {
               cellInfo.value = glBPName.GetValue();
               cellInfo.text = glBPName.GetText();
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

           console.log(val);
           if (val == null) {
               val = ";;;;;;";
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
           if (selectedIndex == 0) {
               if (column.fieldName == "BankCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
               }
               if (column.fieldName == "BankBranch") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
               }
               if (column.fieldName == "CheckDate") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
               }
               if (column.fieldName == "CheckAmount") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
               }
               if (column.fieldName == "CheckNumber") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
               }
               if (column.fieldName == "BPCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
               }
               if (column.fieldName == "BPName") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[6]);
               }
           }
       }

       function GridEnd(s, e) {
           val = s.GetGridView().cp_codes;
           temp = val.split(';');
           if (closing == true) {
               gv2.batchEditApi.EndEdit();
               autocalculate();
           }
           //if (s.cp_refdoc) {
           //    delete (s.cp_refdoc);
           //    var refdoc = gv2.batchEditApi.GetCellValue(index, "RefDocNumber");
           //    var ref = refdoc.split(',');
           //    gv2.batchEditApi.SetCellValue(index, 'RefDocNumber', ref[0]);
           //}
           loader.Hide();
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
           gv2.batchEditApi.EndEdit();
       }

       function OnCustomClick(s, e) {
           if (e.buttonID == "Delete") {
               gv2.DeleteRow(e.visibleIndex);
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

       function lookup_2(s, e) {
           //if (isSetTextRequired) {//Sets the text during lookup for item code
           //    s.SetText(s.GetInputElement().value);
           //    isSetTextRequired = false;
           //}
       }




       ///////////////////////////////////////////////////////////////////////////////////////2nd grid's functions
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
       var valchange_2;

       var itemc_2; //variable required for lookup
       var currentColumn_2 = null;
       var isSetTextRequired_2 = false;
       var linecount_2 = 1;
       function OnStartEditing_2(s, e) {//On start edit grid function     
           currentColumn_2 = e.focusedColumn;
           var cellInfo1 = e.rowValues[e.focusedColumn.index];
           code1 = s.batchEditApi.GetCellValue(e.visibleIndex, "RefDocNum");
           var entry1 = getParameterByName('entry');

           if (entry1 != "V" && entry1 != "D") {
               if (e.focusedColumn.fieldName != "RefDocNum" && e.focusedColumn.fieldName != "Field1"
                   && e.focusedColumn.fieldName != "Field2" && e.focusedColumn.fieldName != "Field3"
                   && e.focusedColumn.fieldName != "Field4" && e.focusedColumn.fieldName != "Field5"
                   && e.focusedColumn.fieldName != "Field6" && e.focusedColumn.fieldName != "Field7"
                   && e.focusedColumn.fieldName != "Field8" && e.focusedColumn.fieldName != "Field9")
                   e.cancel = true;
           }
           else
               e.cancel = true;

           if (e.focusedColumn.fieldName === "RefDocNum") { //Check the column name
               gl_2.GetInputElement().value = cellInfo1.value; //Gets the column value
               isSetTextRequired_2 = true;
               index_2 = e.visibleIndex;
               closing_2 = true;
           }
           //if (e.focusedColumn.fieldName === "Amount") {
           //gl2_2.GetInputElement().value = cellInfo1.value;
           //}
       }

       var val_2;
       var temp_2;
       function ProcessCells_2(selectedIndex, e, column, s) {

           if (val_2 == null) {
               val_2 = ";;;;";
               console.log("pumasok sa null");
               temp_2 = val_2.split(';');
           }
           if (temp_2[0] == null) {
               temp_2[0] = "";
           }
           if (temp_2[1] == null) {
               temp_2[1] = "";
           }
           if (temp_2[2] == null) {
               temp_2[2] = "";
           }

           if (selectedIndex == 0) {
               if (column.fieldName == "Amount") {
                   s.batchEditApi.SetCellValue(index_2, column.fieldName, temp_2[0]);
               }
               if (column.fieldName == "CustomerCode") {
                   s.batchEditApi.SetCellValue(index_2, column.fieldName, temp_2[1]);
               }
               if (column.fieldName == "CustomerName") {
                   s.batchEditApi.SetCellValue(index_2, column.fieldName, temp_2[2]);
               }
           }
       }

       function OnEndEditing_2(s, e) {//end edit grid function, sets text after select/leaving the current lookup
           var cellInfo1 = e.rowValues[currentColumn_2.index];
           if (currentColumn_2.fieldName === "RefDocNum") {
               cellInfo1.value = gl_2.GetValue();
               cellInfo1.text = gl_2.GetText();
               //valchange_2 = true;
           }
           //if (currentColumn_2.fieldName === "Amount") {
           //cellInfo1.value = gl2_2.GetValue();
           //cellInfo1.text = gl2_2.GetText();
           //}
       }

       function GridEnd_2(s, e) {
           val_2 = s.GetGridView().cp_codes1;
           temp_2 = val_2.split(';');

           autocalculate();
           if (valchange_2) {
               valchange_2 = false;
               closing_2 = false;
               for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                   var column = gv1.GetColumn(i);
                   if (column.visible == false || column.fieldName == undefined)
                       continue;
                   ProcessCells_2(0, index_2, column, gv1);
               }
           }
           loader.Hide();
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
           if (keyCode == ASPxKey.Enter)
               gv1.batchEditApi.EndEdit();
       }

       Number.prototype.format = function (d, w, s, c) {
           var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
               num = this.toFixed(Math.max(0, ~~d));

           return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
       };

       function autocalculate(s, e) {
           var cash = 0.00;
           var check = 0.00;
           var totalcash = 0.00;
           var totalcheck = 0.00;
           var totalamount = 0.00;
           setTimeout(function () {
               var indiciesA = gv2.batchEditApi.GetRowVisibleIndices();
               var indiciesB = gv1.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indiciesB.length; i++) {
                   if (gv1.batchEditApi.IsNewRow(indiciesB[i])) {
                       cash = gv1.batchEditApi.GetCellValue(indiciesB[i], "Amount");
                       totalcash += +cash;
                   }
                   else {
                       var keyB = gv1.GetRowKey(indiciesB[i]);
                       if (gv1.batchEditApi.IsDeletedRow(keyB))
                           console.log("deleted row " + indiciesB[i]);
                       else {
                           cash = gv1.batchEditApi.GetCellValue(indiciesB[i], "Amount");
                           totalcash += +cash;
                       }
                   }
               }
               txtTotalCashAmount.SetText(totalcash.toFixed(2));
               for (var i = 0; i < indiciesA.length; i++) {
                   if (gv2.batchEditApi.IsNewRow(indiciesA[i])) {
                       check = gv2.batchEditApi.GetCellValue(indiciesA[i], "CheckAmount");
                       totalcheck += +check;
                   }
                   else {
                       var keyA = gv2.GetRowKey(indiciesA[i]);
                       if (gv2.batchEditApi.IsDeletedRow(keyA))
                           console.log("deleted row " + indiciesA[i]);
                       else {
                           check = gv2.batchEditApi.GetCellValue(indiciesA[i], "CheckAmount");
                           totalcheck += +check;
                       }
                   }
               }
               txtTotalCheckAmount.SetText(totalcheck.format(2, 3, ',', '.'));
               totalamount = totalcash + totalcheck;
               txtTotalAmount.SetText(totalamount.format(2, 3, ',', '.'));
           }, 500);
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

       //Function to get all reference docnumber and filter when already on grid
       function checkdoc(s, e) {
           var refdocnumber;
           var getalltrans;
           var indicies = gv2.batchEditApi.GetRowVisibleIndices();
           console.log(indicies.length);
           for (var i = 0; i < indicies.length; i++) {
               if (gv2.batchEditApi.IsNewRow(indicies[i])) {
                   refdocnumber = gv2.batchEditApi.GetCellValue(indicies[i], "RefDocNumber") + ";"; // + "," + gv2.batchEditApi.GetCellValue(indicies[i], "CheckNumber") + ";";
                   getalltrans += refdocnumber;
               }
               else {
                   var keyB = gv2.GetRowKey(indicies[i]);
                   if (gv2.batchEditApi.IsDeletedRow(keyB))
                       console.log("deleted row " + indicies[i]);
                   else {
                       refdocnumber = gv2.batchEditApi.GetCellValue(indicies[i], "RefDocNumber") + ";"; //+ "," + gv2.batchEditApi.GetCellValue(indicies[i], "CheckNumber") + ";";
                       getalltrans += refdocnumber;
                   }
               }
           }
           console.log(getalltrans);
           gl.GetGridView().PerformCallback('checkdoc' + '|' + getalltrans + '|' + 'code');
           e.processOnServer = false;
       }

       function CloseGridLookup() {
           glCollection.ConfirmCurrentSelection();
           glCollection.HideDropDown();
           //glInvoice.Focus();
       }

       function Clear() {
           glCollection.SetValue(null);
       }

       //Function to get all reference docnumber and filter when already on grid
       function cashdoc(s, e) {
           var refdocnum;
           var getallref;
           var indicies = gv1.batchEditApi.GetRowVisibleIndices();
           console.log(indicies.length);
           for (var i = 0; i < indicies.length; i++) {
               if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                   refdocnum = gv1.batchEditApi.GetCellValue(indicies[i], "RefDocNum") + ";";
                   getallref += refdocnum;
               }
               else {
                   var keyB = gv1.GetRowKey(indicies[i]);
                   if (gv1.batchEditApi.IsDeletedRow(keyB))
                       console.log("deleted row " + indicies[i]);
                   else {
                       refdocnum = gv1.batchEditApi.GetCellValue(indicies[i], "RefDocNum") + ";";
                       getallref += refdocnum;
                   }
               }
           }
           console.log(getallref);
           gl_2.GetGridView().PerformCallback('cashdoc' + '|' + getallref + '|' + 'code1');
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
                    <dx:ASPxLabel runat="server" Text="Deposit Slip" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <%--<dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
        ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>--%>
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
                                            <dx:LayoutItem Caption="Total Check Amount:" Name="TotalCheckAmount" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTotalCheckAmount" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="txtTotalCheckAmount" DisplayFormatString="{0:N}">
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                        </dx:ASPxTextBox>
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
                                            <dx:LayoutItem Caption="Total Cash Amount:" Name="TotalCashAmount" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTotalCashAmount" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="txtTotalCashAmount" DisplayFormatString="{0:N}">
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Bank Account Code:" Name="BankAccountCode" >
                                                 <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glBankAccountCode" runat="server" DataSourceID="sdsBankAccount" KeyFieldName="BankAccountCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="false" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="BankAccountCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition ="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition ="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Amount:" Name="TotalAmount" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTotalAmount" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="txtTotalAmount" DisplayFormatString="{0:N}">
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                           
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2" >
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
                            <dx:LayoutGroup Caption="Check Detail">
                                <Items>
                                    <dx:LayoutItem Caption="Reference Checks:" Name ="RC">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridLookup ID="glReferenceChecks" runat="server" AutoGenerateColumns="False" DataSourceID="sdsCheckDetail" KeyFieldName="RecordID" 
                                                    OnLoad="LookupLoad" SelectionMode="Multiple" TextFormatString="{3}" Width="800px"  OnInit="glReferenceChecks_Init">
                                                    <GridViewProperties>
                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSort="false"/>
                                                        <Settings ShowFilterRow="True" />
                                                    </GridViewProperties>
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="RefDocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="BankCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CheckNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BankBranch" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn Caption="CheckDate" FieldName="CheckDate" ShowInCustomizationForm="True" VisibleIndex="5" ReadOnly ="true">
                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                            <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                            </PropertiesDateEdit>
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="CheckAmount" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="BPCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Caption="BizPartner">
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="BPName" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8" Caption="BizName">
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="RecordID" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9">
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                    <ClientSideEvents ValueChanged="function(s,e){console.log('terencio.');cp.PerformCallback('Details'); }" />
                                                </dx:ASPxGridLookup>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="" ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv2" runat="server" AutoGenerateColumns="False" Width="850px" OnCommandButtonInitialize="gv_CommandButtonInitialize"
                                                    OnCellEditorInitialize="gv2_CellEditorInitialize" ClientInstanceName="gv2" OnBatchUpdate="gv2_BatchUpdate" KeyFieldName="DocNumber;LineNumber">
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing"/>
                                                    <SettingsPager Mode="ShowAllRecords"/><SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="250" ShowFooter="True"  /> 
                                                    <Settings ShowStatusBar="Hidden" />
                                                    
                                                    <%--<SettingsCommandButton>
                                                        <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                        <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                        <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                    </SettingsCommandButton>--%>
                                                    <ClientSideEvents Init="OnInitTrans"></ClientSideEvents>
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True"  ShowNewButtonInHeader="True" VisibleIndex="0" Width="50px">
                                                            <CustomButtons>
                                                                <%--<dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>--%>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False" VisibleIndex="0" ReadOnly="true"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="true" VisibleIndex="2" Caption="Line" ReadOnly="True" Width="100px"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="RefDocNumber" VisibleIndex="2" Width="150px" Name="glRefDocNumber" ReadOnly="false" Caption="RefDocNumber">
                                                             <%--<EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glRefDocNumber" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init" TextFormatString="{0}"
                                                                    DataSourceID="sdsCheckDetail" KeyFieldName="RefDocNumber" ClientInstanceName="gl" Width="150px" OnLoad="gvLookupLoad" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true" >
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="RefDocNumber" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="BankCode" ReadOnly="True" VisibleIndex="1" />
                                                                        <dx:GridViewDataTextColumn FieldName="CheckNumber" ReadOnly="True" VisibleIndex="2" />
                                                                        <dx:GridViewDataTextColumn FieldName="BankBranch" ReadOnly="True" VisibleIndex="3" />
                                                                        <dx:GridViewDataTextColumn FieldName="CheckDate" ReadOnly="True" VisibleIndex="4" />
                                                                        <dx:GridViewDataTextColumn FieldName="CheckAmount" ReadOnly="True" VisibleIndex="5" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="checkdoc" 
                                                                      RowClick="function(s,e){
                                                                        loader.Show();
                                                                        setTimeout(function(){
                                                                        gl2.GetGridView().PerformCallback('RefDocNumber' + '|' + gl.GetValue() + '|' + 'code');
                                                                        e.processOnServer = false;
                                                                        valchange = true;
                                                                    },1000);
                                                                    }"
                                                                        /> 
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>--%>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BankCode" VisibleIndex="6" Width="150px" Caption="BankCode" ReadOnly="true">   
                                                           <%-- <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glBankCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ReadOnly ="false"
                                                                    KeyFieldName="BankCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad" OnInit="lookup_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BankCode" ReadOnly="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl2.GetGridView().PerformCallback('BankCode' + '|' + RefDocNumber + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>--%>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BankBranch" VisibleIndex="8" Width="150px" Name="glBankBranch" Caption="BankBranch" ReadOnly="true">
                                                             <%--<EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glBankBranch" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init" ReadOnly ="false"
                                                                    KeyFieldName="BankBranch" ClientInstanceName="gl3" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BankBranch" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                        DropDown="function dropdown(s, e){
                                                                        gl3.GetGridView().PerformCallback('BankBranch' + '|' + RefDocNumber + '|' + s.GetInputElement().value);
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>--%>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="CheckAmount" VisibleIndex="10" Width="150px" Caption="CheckAmount" ReadOnly="false" Name="glCheckAmount">
                                                            <PropertiesSpinEdit DisplayFormatString="{0:N}" ClientInstanceName="gl5"></PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="CheckNumber" VisibleIndex="6" Width="150px" Name="glCheckNumber" Caption="CheckNumber" ReadOnly="true">
                                                             <%--<EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glCheckNumber" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init" ReadOnly ="false"
                                                                KeyFieldName="CheckNumber" ClientInstanceName="gl6" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="CheckNumber" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                        DropDown="function dropdown(s, e){
                                                                        gl6.GetGridView().PerformCallback('CheckNumber' + '|' + RefDocNumber + '|' + s.GetInputElement().value);
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>--%>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="CheckDate" VisibleIndex="9" Width="150px" Name ="glCheckDate" Caption="CheckDate" ReadOnly="true" PropertiesTextEdit-ClientInstanceName="gl6" PropertiesTextEdit-DisplayFormatString="MM/dd/yyy">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BPCode" VisibleIndex="10" Width="150px" Name ="glBPCode" Caption="BizPartner" ReadOnly="true" PropertiesTextEdit-ClientInstanceName="glBPCode">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BPName" VisibleIndex="11" Width="200px" Name ="glBPName" Caption="BizPartner Name" ReadOnly="true" PropertiesTextEdit-ClientInstanceName="glBPName">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="12" FieldName="Field1" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="13" FieldName="Field2" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="14" FieldName="Field3" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="15" FieldName="Field4" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="16" FieldName="Field5" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="17" FieldName="Field6" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="18" FieldName="Field7" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="19" FieldName="Field8" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="20" FieldName="Field9" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Version" Name="glpVersion" Caption="Version" ShowInCustomizationForm="True" VisibleIndex="29" Width="0px" UnboundType="String"></dx:GridViewDataTextColumn>
                                                    </Columns>
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                            <dx:LayoutGroup Caption="Cash Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="850px" OnCellEditorInitialize="gv2_CellEditorInitialize"
                                                     ClientInstanceName="gv1"  OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber" OnCustomButtonInitialize="gv1_CustomButtonInitialize" OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                    <ClientSideEvents Init="OnInitTrans" CustomButtonClick="OnCustomClick_2" BatchEditConfirmShowing="OnConfirm_2" BatchEditStartEditing="OnStartEditing_2" BatchEditEndEditing="OnEndEditing_2"/>
                                                    <SettingsPager Mode="ShowAllRecords"/><SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="250" ShowFooter="True"  /> 
                                                    <Settings ShowStatusBar="Hidden" />
                                                    <SettingsCommandButton>
                                                        <NewButton><Image IconID="actions_addfile_16x16"></Image></NewButton>
                                                        <EditButton><Image IconID="actions_addfile_16x16"></Image></EditButton>
                                                        <DeleteButton><Image IconID="actions_cancel_16x16"></Image></DeleteButton>
                                                    </SettingsCommandButton>
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
                                                        <dx:GridViewDataTextColumn FieldName="RefDocNum" VisibleIndex="2" Name="glRefDocNum" Caption="RefDocNumber" Width="150px" ReadOnly="false">
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glRefDocNum" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init1" 
                                                                    DataSourceID="sdsCashDetail" KeyFieldName="RefDocNum" ClientInstanceName="gl_2" TextFormatString="{0}" Width="149px" OnLoad="gvLookupLoad_2" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="RefDocNum" ReadOnly="True" VisibleIndex="0" Width="120px" >
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Amount" ReadOnly="True" VisibleIndex="1" PropertiesTextEdit-DisplayFormatString="#,0.00" Width="120px">
                                                                             <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="DocDate" ReadOnly="True" VisibleIndex="2" Width="120px" >
                                                                             <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CustomerCode" ReadOnly="True" VisibleIndex="3" Width="120px" >
                                                                             <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" Caption="Customer Name" ReadOnly="True" VisibleIndex="4" Width="120px" >
                                                                             <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                   
                                                                     <ClientSideEvents CloseUp="function(s,e)
                                                                         {
                                                                            loader.Show(); 
                                                                            setTimeout(function()
                                                                            { 
                                                                                closing_2 = true; 
                                                                                gl_2.GetGridView().PerformCallback('RefDocNum' + '|' + gl_2.GetValue() + '|' + 'code1');
                                                                                e.processOnServer = false; 
                                                                                valchange_2 = true;
                                                                                console.log('test');
                                                                            }, 500); 
                                                                         }" 
                                                                        RowClick="function(s,e){ setTimeout(function(){ gv1.batchEditApi.EndEdit();},300);}" 
                                                                        EndCallback="GridEnd_2" KeyDown="gridLookup_KeyDown_2" 
                                                                        KeyPress="gridLookup_KeyPress_2" DropDown="cashdoc"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Amount" VisibleIndex="3" Width="150px" Caption="Amount" ReadOnly="false" Name="Amount">
                                                            <PropertiesSpinEdit Increment="0" DisplayFormatString="{0:N}" ClientInstanceName="gl2_2">
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn Caption="Customer" Name="CustomerCode" ShowInCustomizationForm="True" VisibleIndex="4" FieldName="CustomerCode" UnboundType="String" Width="150px" ReadOnly="true"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Customer Name" Name="CustomerName" ShowInCustomizationForm="True" VisibleIndex="5" FieldName="CustomerName" UnboundType="String" Width="250px" ReadOnly="true"></dx:GridViewDataTextColumn>                                                    
                                                        <dx:GridViewDataTextColumn Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="11" FieldName="Field1" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field2" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="12" FieldName="Field2" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="13" FieldName="Field3" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="14" FieldName="Field4" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="15" FieldName="Field5" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="16" FieldName="Field6" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="17" FieldName="Field7" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="18" FieldName="Field8" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="19" FieldName="Field9" UnboundType="String" Width="150px" ReadOnly="false"></dx:GridViewDataTextColumn>
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
                            <td>
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="False">
                                <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="False">
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
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.DepositSlip" DataObjectTypeName="Entity.DepositSlip" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getCashDetail" TypeName="Entity.DepositSlip+DepositSlipCash" DataObjectTypeName="Entity.DepositSlip+DepositSlipCash" DeleteMethod="DeleteDepositSlipCash" InsertMethod="AddDepositSlipCash" UpdateMethod="UpdateDepositSlipCash">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail2" runat="server" SelectMethod="getCheckDetail" TypeName="Entity.DepositSlip+DepositSlipCheck" DataObjectTypeName="Entity.DepositSlip+DepositSlipCheck" DeleteMethod="DeleteDepositSlipCheck" InsertMethod="AddDepositSlipCheck" UpdateMethod="UpdateDepositSlipCheck">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.DepositSlip+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.DepositSlip+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters> 
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.*, CASE WHEN ISNULL(B.CustomerCode,'') != '' THEN B.CustomerCode ELSE B.BizAccount END AS CustomerCode, RTRIM(LTRIM(C.Name)) AS CustomerName FROM Accounting.DepositSlipCash A LEFT JOIN Accounting.Collection B ON A.RefDocNum = B.DocNumber LEFT JOIN Masterfile.BPCustomerInfo C ON CASE WHEN ISNULL(B.CustomerCode,'') != '' THEN B.CustomerCode ELSE B.BizAccount END = C.BizPartnerCode WHERE A.DocNumber IS NULL" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Accounting.DepositSlipCheck where DocNumber IS NULL" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBankAccount" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BankAccountCode, Description FROM Masterfile.BankAccount WHERE ISNULL([IsInactive],0) = 0" OnInit="ConnectionInit_Init"></asp:SqlDataSource>
    <%--<asp:SqlDataSource ID="sdsRefDocNumber" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber AS RefDocNumber FROM Accounting.Collection" OnInit="ConnectionInit_Init"></asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="sdsCheckDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="
        SELECT RIGHT('00000'+ CAST(ROW_NUMBER() OVER (ORDER BY CheckDate) AS VARCHAR(5)),5) AS LineNumber,
               *, '' AS Field1, '' AS Field2, '' AS Field3, '' AS Field4, '' AS Field5, '' AS Field6, '' AS Field7, '' AS Field8, '' AS Field9
          FROM (
               SELECT A.DocNumber, A.DocNumber AS RefDocNumber, A.Bank AS BankCode, A.CheckNumber, 
                      A.Branch AS BankBranch, CAST(A.CheckDate AS DATE) AS CheckDate, A.CheckAmount, CONVERT(varchar(MAX),A.RecID) + 'C' AS RecordID
                      ,CASE WHEN ISNULL(B.BizAccount,'') = '' THEN B.CustomerCode ELSE B.BizAccount END AS BPCode, RTRIM(LTRIM(LEFT(C.Name,20))) AS BPName 
                 FROM Accounting.CollectionChecks A 
                      INNER JOIN Accounting.Collection B ON A.DocNumber = B.DocNumber
                      LEFT JOIN Masterfile.BPCustomerInfo C ON (CASE WHEN ISNULL(B.BizAccount,'') = '' THEN B.CustomerCode ELSE B.BizAccount END) = C.BizPartnerCode
                WHERE (B.ReceiptType = 'C' OR ISNULL(A.CollReceiptNum,'') != '') AND 
                       ISNULL(B.SubmittedBy,'') != '' AND 
                       A.DepositedDate IS NULL AND ISNULL(A.CancelledCheckDocNum,'') = ''
               UNION ALL
	           SELECT A.DocNumber, A.DocNumber AS RefDocNumber, A.Bank AS BankCode, A.CheckNumber, 
                      A.Branch AS BankBranch, CAST(A.CheckDate AS DATE) AS CheckDate, A.CheckAmount, CONVERT(varchar(MAX),A.RecordID) + 'F'
                      ,ISNULL(B.SupplierCode,'') AS BPCode, RTRIM(LTRIM(LEFT(C.Name,20))) AS BPName  
                 FROM Accounting.CheckVoucherDetail A 
					  INNER JOIN Accounting.CheckVoucher B ON A.DocNumber = B.DocNumber
                      LEFT JOIN Masterfile.BizPartner C ON B.SupplierCode = C.BizPartnerCode
                WHERE B.TransType = 'Fund Transfer' AND ISNULL(B.SubmittedBy,'') != '' AND 
                      A.ReleasedDate IS NULL AND ISNULL(A.CancelledCheckDocNum,'') = ''
               ) A"
        OnInit="ConnectionInit_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCashDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="SELECT DocNumber, DocNumber AS RefDocNum, ISNULL(CashAmount,0) AS Amount, B.Name, DocDate, CASE WHEN ISNULL(A.CustomerCode,'') != '' THEN A.CustomerCode ELSE A.BizAccount END AS CustomerCode, A.Field1, A.Field2, A.Field3, A.Field4, A.Field5, A.Field6, A.Field7, A.Field8, A.Field9 FROM Accounting.Collection A LEFT JOIN Masterfile.BPCustomerInfo B ON  (CASE WHEN ISNULL(A.CustomerCode,'') != '' THEN A.CustomerCode ELSE A.BizAccount END) = B.BizPartnerCode WHERE ISNULL(IsForDeposit,0) = 1 AND DepositedDate IS NULL AND CashAmount != 0 AND A.DocDate <= @CashDate" OnInit="ConnectionInit_Init">
        <SelectParameters>
            <asp:SessionParameter SessionField="ACTDESCashDate" Name="CashDate" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!--#endregion-->
</body>
</html>