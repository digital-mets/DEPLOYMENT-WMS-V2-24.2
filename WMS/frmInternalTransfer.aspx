<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmInternalTransfer.aspx.cs" Inherits="GWL.frmInternalTransfer" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Internal Transfer</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
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
       var isValid = false;
       var counterror = 0;


       function getParameterByName(name) {
           name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
           var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
               results = regex.exec(location.search);
           return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
       }

       var entry = getParameterByName('entry');
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
           console.log(counterror);
           console.log(isValid);
           //autocalculate();
           var btnmode = btn.GetText(); //gets text of button
           if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
               //Sends request to server side
               if (btnmode == "Add") {
                   cp.PerformCallback("Add");
               }
               else if (btnmode == "Submit") {
                   cbacker.PerformCallback("Update");
               }
               else if (btnmode == "Close") {
                   cbacker.PerformCallback("Close");
               }
           }
           else {
               //console.log(this);
               counterror = 0;
               alert('Please check all the fields!');
           }

           if (btnmode == "Delete") {
               cp.PerformCallback("Delete");
           }
       }

       var custchanged = true;
       function OnConfirm(s, e) {//function upon saving entry
           //console.log(e.requestTriggerID);
           if (e.requestTriggerID === "callbacker" || e.requestTriggerID === undefined)//disables confirmation message upon saving.
               e.cancel = true;
           else {
               if (custchanged) {
                   e.cancel = true;
                   custchanged = false;
               }
           }
       }

       function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
           if (s.cp_delete) {
               delete (s.cp_delete);
               DeleteControl.Show();
           }


           if (s.cp_success) {
               //alert(s.cp_valmsg);
               alert(s.cp_message);
               if (s.cp_message2 != null) {
                   alert(s.cp_message2);
               }

               delete (s.cp_valmsg);
               delete (s.cp_success);//deletes cache variables' data
               delete (s.cp_message);
               delete (s.cp_message2);
           }

           else {
           
               if (s.cp_close == undefined)
               {
                   alert(s.cp_message);
                   delete (s.cp_success);//deletes cache variables' data
                   delete (s.cp_message);
                   return;
               }
              
           }

         
           if (s.cp_close) {
               console.log('nats');
               if (s.cp_message != null) {
                   alert(s.cp_message);
                   delete (s.cp_message);
               }
               if (s.cp_valmsg != null) {
                   alert(s.cp_valmsg);
                   delete (s.cp_valmsg);
               }
               if (glcheck.GetChecked()) {
                   delete (s.cp_close);
                   window.location.reload();
               }
               else {
                   delete (cp_close);
                   window.close();//close window if callback successful
               }
           }
      
      

           //autocalculate();
       }

       var index;
       var closing;
       var valchange;
       var valchange2;
       var bulkqty;
       var itemc; //variable required for lookup
       var currentColumn = null;
       var isSetTextRequired = false;
       var linecount = 1;
       var editorobj;
       function OnStartEditing(s, e) {//On start edit grid function
           hiddenField.Set('currentRowIndex', e.visibleIndex);
           currentColumn = e.focusedColumn;
           var cellInfo = e.rowValues[e.focusedColumn.index];
           itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
           bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "BulkQty");
           //if (e.visibleIndex < 0) {//new row
           //    var linenumber = s.GetColumnByField("LineNumber");
           //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
           //}
           index = e.visibleIndex;
           editorobj = e;
           if (entry == "V") {
               e.cancel = true; //this will made the gridview readonly
           }

           if (s == gv2) {
               e.cancel = true;
           }

           if (entry != "V") {
               if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                   gl.GetInputElement().value = cellInfo.value; //Gets the column value
                   isSetTextRequired = true;
                   index = e.visibleIndex;
               }
               if (e.focusedColumn.fieldName === "ColorCode") {
                   gl2.GetInputElement().value = cellInfo.value;
                   isSetTextRequired = true;
               }
               if (e.focusedColumn.fieldName === "ClassCode") {
                   gl3.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "SizeCode") {
                   gl4.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "BulkUnit") {
                   e.cancel = true;
                   glBulkUnit.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "Unit") {
                   glUnit.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "Location") {
                   glLocation.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "StorageType") {
                   glStorageType.GetInputElement().value = cellInfo.value;
               }
           }

       }

       function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
           hiddenField.Set('currentRowIndex', -1);
           var cellInfo = e.rowValues[currentColumn.index];
           if (currentColumn.fieldName === "ItemCode") {
               cellInfo.value = gl.GetValue();
               //cellInfo.text = gl.GetText().toUpperCase();
               cellInfo.text = gl.GetText(); // need sa n/a
           }
           if (currentColumn.fieldName === "ColorCode") {
               cellInfo.value = gl2.GetValue();
               cellInfo.text = gl2.GetText().toUpperCase();
           }
           if (currentColumn.fieldName === "ClassCode") {
               cellInfo.value = gl3.GetValue();
               cellInfo.text = gl3.GetText().toUpperCase();
           }
           if (currentColumn.fieldName === "SizeCode") {
               cellInfo.value = gl4.GetValue();
               cellInfo.text = gl4.GetText().toUpperCase();
           }
           if (currentColumn.fieldName === "BulkUnit") {
               cellInfo.value = glBulkUnit.GetValue();
               cellInfo.text = glBulkUnit.GetText();
               isSetTextRequired = true;
           }
           if (currentColumn.fieldName === "Unit") {
               cellInfo.value = glUnit.GetValue();
               cellInfo.text = glUnit.GetText();
               isSetTextRequired = true;
           }

           if (currentColumn.fieldName === "Location") {
               cellInfo.value = glLocation.GetValue();
               cellInfo.text = glLocation.GetText().toUpperCase();

           }

           if (currentColumn.fieldName === "StorageType") {
               cellInfo.value = glStorageType.GetValue();
               cellInfo.text = glStorageType.GetText().toUpperCase();
           }

           if (valchange2) {
               valchange2 = false;
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
           if (temp[3] == null || temp[3] == "") {
               temp[3] = "";
           }
           if (temp[4] == null || temp[4] == "") {
               temp[4] = "";
           }
           if (temp[5] == null || temp[5] == "") {
               temp[5] = 0;
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
               if (column.fieldName == "BulkUnit") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
               }
               if (column.fieldName == "Unit") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
               }
               if (column.fieldName == "Qty") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
               }
           }
       }

       function ProcessCells2(selectedIndex, focused, column, s) {//Auto calculate qty function :D
           if (val == null) {
               val = ";";
               temp = val.split(';');
           }
           if (temp[0] == null) {
               temp[0] = 0;
           }
           if (selectedIndex == 0) {
               s.batchEditApi.SetCellValue(index, "Qty", temp[0]);
           }
       }

       function autocalculate(s, e) {
           //console.log(txtNewUnitCost.GetValue());


           OnInitTrans()
           var TotalQuantity1 = 0.00;

           var qty = 0.00;


           setTimeout(function () {

               var indicies = gv1.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indicies.length; i++) {
                   if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                       qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");

                       console.log(qty)
                       //Total Amount of OrderQty
                       TotalQuantity1 += qty * 1.00;          //Sum of all Quantity
                       console.log(TotalQuantity1)
                   }
                   else {
                       var key = gv1.GetRowKey(indicies[i]);
                       if (gv1.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + indicies[i]);
                       else {
                           qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");

                           TotalQuantity1 += qty * 1.00;          //Sum of all Quantity
                           console.log(TotalQuantity1)
                       }
                   }

               }


               //txtTotalAmount.SetText(TotalAmount.toFixed(2))
               txtTotalQty.SetText(TotalQuantity1.toFixed(2));

           }, 500);
       }

       function GridEnd(s, e) {
           val = s.GetGridView().cp_codes;
           if (val != null) {
               temp = val.split(';');
           }
           if (closing == true) {
               gv1.batchEditApi.EndEdit();
           }

           if (valchange) {
               valchange = false;
               closing = false;
               for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                   var column = gv1.GetColumn(i);
                   if (column.visible == false || column.fieldName == undefined)
                       continue;
                   ProcessCells2(0, index, column, gv1);
               }
           }
           loader.Hide();
       }

       function lookup(s, e) {
           if (isSetTextRequired) {//Sets the text during lookup for item code
               s.SetText(s.GetInputElement().value);
               isSetTextRequired = false;
           }
       }

       function rowclick(s, e) {

       }

       //var preventEndEditOnLostFocus = false;
       function gridLookup_KeyDown(s, e) { //Allows tabbing between gridlookup on details
           isSetTextRequired = false;
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode !== 9) return;
           var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
           if (gv1.batchEditApi[moveActionName]()) {
               ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
           }
       }

       function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
           var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
           if (keyCode == 13)
               gv1.batchEditApi.EndEdit();
           //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
       }

       function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
           setTimeout(function () {
               gv1.batchEditApi.EndEdit();
           }, 1000);
       }

       //validation
       function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
           for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
               var column = s.GetColumn(i);
               if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
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
       //function getParameterByName(name) {
       //    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
       //    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
       //        results = regex.exec(location.search);
       //    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
       //}

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
               if (s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber") == null) {
                   e.cancel = true;
               }
               else {
                   CSheet.Show();
                   var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
                   var docnumber = getParameterByName('docnumber');
                   var transtype = getParameterByName('transtype');
                   var entry = getParameterByName('entry');
                   CSheet.SetContentUrl('frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
                       '&linenumber=' + linenum);
                   console.log('here');
               }
           }
           if (e.buttonID == "Delete") {
               gv1.DeleteRow(e.visibleIndex);
               autocalculate(s, e);

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
           var height = Math.max(0, document.documentElement.clientHeight);
           gv1.SetWidth(width - 120);
           gv1.SetHeight(height - 290);
           gv2.SetWidth(width - 120);
           gv2.SetHeight(height - 290);
       }

       //To real Grid
       var arrayGrid = new Array();
       var arrayGrid2 = new Array();
       var arrayGL = new Array();
       var arrayGL2 = new Array();
       var OnConf = false;
       var glText;
       var ValueChanged = false;
       var deleting = false;
       var endcbgrid = false;
       //Function Autobind to GridEnd
       function isInArray(value, array) {
           return array.indexOf(value) > -1;
       }

       function gvExtract_end(s, e) {
           if (endcbgrid) {
               gvExtract.GetSelectedFieldValues('RecordId;ItemCode;PalletID;Customer;MfgDate;ExpirationDate;BatchNumber', OnGetSelectedFieldValues);
               endcbgrid = false;
           }
       }

       function isInArray(value, array) {
           return array.indexOf(value) > -1;
       }

       var arrayGrid = [];
       function checkGrid() {
           var indicies = gv1.batchEditApi.GetRowVisibleIndices();
           var Keyfield;
           for (var i = 0; i < indicies.length; i++) {
               if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                   Keyfield = gv1.batchEditApi.GetCellValue(indicies[i], "RecordId");
                   arrayGrid.push(Keyfield);
               }
               else {
                   var key = gv1.GetRowKey(indicies[i]);
                   if (gv1.batchEditApi.IsDeletedRow(key))
                       var ss = "";
                   else {
                       Keyfield = gv1.batchEditApi.GetCellValue(indicies[i], "RecordId");
                       arrayGrid.push(Keyfield);
                   }
               }
           }
       }

       function OnGetSelectedFieldValues(selectedValues) {
           //if (selectedValues.length == 0) return;
           //arrayGL.push(glTranslook.GetText().split(';'));
           var item;
           var checkitem;
           for (i = 0; i < selectedValues.length; i++) {
               var s = "";
               for (j = 0; j < selectedValues[i].length; j++) {
                   s = s + selectedValues[i][j] + ";";
               }
               item = s.split(';');
               checkGrid();
               if (isInArray(item[0], arrayGrid))
                   continue;

               gv1.AddNewRow();
               getCol(gv1, editorobj, item);
           }
           arrayGrid = [];
           loader.Hide();
       }

       function getCol(ss, ee, item) {
           for (var i = 0; i < ss.GetColumnsCount() ; i++) {
               var column = ss.GetColumn(i);
               if (column.visible == false || column.fieldName == undefined)
                   continue;
               Bindgrid(item, ee, column, ss);
           }
       }

       function Bindgrid(item, e, column, s) {//Clone function :D
           //if (column.fieldName == "DocNumber") {
           //    console.log('here', item[0])
           //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[0]);
           //}
           if (column.fieldName == "RecordId") {
               console.log(item[0]);
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[0]);
           }
           if (column.fieldName == "ItemCode") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[1]);
           }
           //if (column.fieldName == "ColorCode") {
           //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[3]);
           //}
           //if (column.fieldName == "ClassCode") {
           //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[4]);
           //}
           //if (column.fieldName == "SizeCode") {
           //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[5]);
           //}
           if (column.fieldName == "PalletID") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[2] == 'null' ? null : item[2]);
           }
           //if (column.fieldName == "BulkQty") {
           //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[8] == 'null' ? null : item[8]);
           //}
           //if (column.fieldName == "Qty") {
           //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[9] == 'null' ? null : item[9]);
           //}
           //if (column.fieldName == "Location") {
           //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[10] == 'null' ? null : item[10]);
           //}
           //if (column.fieldName == "StatusCode") {
           //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[12] == 'null' ? null : item[12]);
           //}
           //if (column.fieldName == "Unit") {
           //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[13] == 'null' ? null : item[13]);
           //}
           //if (column.fieldName == "BulkUnit") {
           //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[14] == 'null' ? null : item[14]);
           //}
           if (column.fieldName == "ManufacturingDate") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[4] == 'null' ? null : new Date(item[4]));
           }
           if (column.fieldName == "ExpiryDate") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[5] == 'null' ? null : new Date(item[5]));
           }
           if (column.fieldName == "BatchNumber") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[6] == 'null' ? null : item[6]);
           }
           if (column.fieldName == "NewLotID") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[7] == 'null' ? null : item[7]);
           }


       }

    </script>
    <!--#endregion-->
</head>
<body style="height: 200px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="Internal Transfer" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
        <%--<!--#region Region Factbox --> --%>
<%--        <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        </dx:ASPxPopupControl>--%>
        <%--<!--#endregion --> --%>
        <%--          <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents CloseUp="function (s, e) { cp.PerformCallback('refgrid'); e.processOnServer = false;}" />
    </dx:ASPxPopupControl>--%>
  
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="200px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="200px" Width="850px " Style="margin-left: -3px; margin-right: 0px;">
                     <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                            <Items>
                            <%--<!--#region Region Header --> --%>
                            
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="Inventory Inquiry" ColCount="3">
                                        <Items>
                                            <dx:LayoutItem Caption="Warehouse Code:" Name="WarehouseCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glWarehouseCode" runat="server" AutoGenerateColumns="True" Width="170px" DataSourceID="Warehouse" OnLoad="LookupLoad" TextFormatString="{0}" KeyFieldName="WarehouseCode">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            <Settings ShowFilterRow="True"></Settings>
                                                                 </GridViewProperties>
                                                                 <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <ErrorImage ToolTip="Supplier is required">
                                                                </ErrorImage>
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date:" Name="DocDate" ColSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpdocdate" runat="server" Width="170px"  OnLoad="Date_Load">
                                                              <ClientSideEvents Validation="OnValidation"   />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip" >
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxRoundPanel ID="rpFilter" runat="server" Width="500px" ShowHeader="false"  OnLoad="rpFilter_Load">
                                                            <PanelCollection>
                                                                <dx:PanelContent runat="server">
                                                                    <table>
                                                                        <tr align="left">
                                                                            <td></td>
                                                                            <td style="padding-left:7px">
                                                                                <dx:ASPxLabel ID="lblCustomer" runat="server" Text="Customer:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td style="padding-left:7px">
                                                                                <dx:ASPxLabel ID="lblRR" runat="server" Text="RR Doc:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td style="padding-left:7px">
                                                                                <dx:ASPxLabel ID="lblItem" runat="server" Text="Item Code:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td style="padding-left:7px">
                                                                                <dx:ASPxLabel ID="lblLocation" runat="server" Text="Location:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <%--<td>
                                                                                <dx:ASPxLabel ID="lblLot" runat="server" Text="Lot:">
                                                                                </dx:ASPxLabel>
                                                                            </td>--%>
                                                                            <td style="padding-left:7px">
                                                                                <dx:ASPxLabel ID="lblPallet" runat="server" Text="Pallet:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>Filter:</td>
                                                                            <td style="padding-left:7px">
                                                                                <dx:ASPxGridLookup ID="txtCustomer" runat="server" Width="170px" AutoGenerateColumns="False" DataSourceID="StorerKey" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad"  TextFormatString="{0}">
                                                                                <GridViewProperties>
                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                    <Settings ShowFilterRow="True"></Settings>
                                                                                </GridViewProperties>
                                                                                <Columns>
                                                                                    <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                                    </dx:GridViewDataTextColumn>
                                                         
                                                                                </Columns>
                                                                                <ClientSideEvents ValueChanged="function(){txtRR.SetValue(null); 
                                                                                    gv1.PerformCallback('CustChanged');
                                                                                    custchanged = true;
                                                                                     }" />
                                                                            </dx:ASPxGridLookup>
                                                                                <%--<dx:ASPxTextBox ID="txtCustomer" runat="server" Width="170px">
                                                                                </dx:ASPxTextBox>--%>
                                                                            </td>
                                                                            <td style="padding-left:7px">
                                                                                <dx:ASPxGridLookup ID="txtRR" runat="server" Width="170px" AutoGenerateColumns="False" ClientInstanceName="txtRR" DataSourceID="RRNum" KeyFieldName="DocNumber" OnLoad="LookupLoad"  TextFormatString="{0}">
                                                                                <GridViewProperties>
                                                                                    <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                                    <Settings ShowFilterRow="True"></Settings>
                                                                                </GridViewProperties>
                                                                                <Columns>
                                                                                    <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                    <Settings AutoFilterCondition="Contains" />
                                                                                    </dx:GridViewDataTextColumn>
                                                                                    <dx:GridViewDataTextColumn FieldName="CustomerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                                        </dx:GridViewDataTextColumn>
                                                                                </Columns>
                                                                                <ClientSideEvents DropDown="function(s,e){
                                                                                                    s.SetText(s.GetInputElement().value);
                                                                                                  }" />
                                                                            </dx:ASPxGridLookup>
                                                                            </td>
                                                                            <td style="padding-left:7px">
                                                                                <dx:ASPxTextBox ID="txtItem" runat="server" Width="170px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                           <td style="padding-left:7px">
                                                                                <dx:ASPxTextBox ID="txtLocation" runat="server" Width="170px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                            <%--<td>
                                                                                <dx:ASPxTextBox ID="txtLot" runat="server" Width="170px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>--%>
                                                                           <td style="padding-left:7px">
                                                                                <dx:ASPxTextBox ID="txtPalletID" runat="server" Width="170px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                            <td colspan="5" style="padding-left:7px">
                                                                                <dx:ASPxButton ID="btnSearch" runat="server" Text="Search" AutoPostBack="false" UseSubmitBehavior="false" backcolor="CornflowerBlue" ForeColor="White">
                                                                                   <ClientSideEvents Click="function(s, e) { endcbgrid = true; //loader.Show(); 
                                                                                       loader.SetText('Searching...'); 
                                                                                       //gvExtract.PerformCallback('Pal');
                                                                                       gv1.PerformCallback('bind');
                                                                                       }" />
                                                                                </dx:ASPxButton>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </dx:PanelContent>
                                                            </PanelCollection>
                                                        </dx:ASPxRoundPanel>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutGroup Caption="Inventory Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxHiddenField ID="hiddenField" ClientInstanceName="hiddenField" runat="server"></dx:ASPxHiddenField>
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="747px"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gv1"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="RecordId"
                                                    OnCustomCallback="gv1_CustomCallback" SettingsBehavior-AllowSort="false">  
                                                    <ClientSideEvents Init="OnInitTrans" />
                                                    <Columns> 
                                                        <dx:GridViewDataTextColumn FieldName="TransType"   Width="0"
                                                            VisibleIndex="0">
                                                            <%--<HeaderStyle CssClass="hidden-column" />
                                                            <FilterCellStyle CssClass="hidden-column" />
                                                            <CellStyle CssClass="hidden-column" />--%>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Width="0"
                                                            VisibleIndex="0">
                                                            <%--<HeaderStyle CssClass="hidden-column" />
                                                            <FilterCellStyle CssClass="hidden-column" />
                                                            <CellStyle CssClass="hidden-column" />--%>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="RecordId" VisibleIndex="2" Width="0" ReadOnly="true">
                                                            <%--<HeaderStyle CssClass="hidden-column" /> 
                                                            <FilterCellStyle CssClass="hidden-column" />
                                                            <CellStyle CssClass="hidden-column" /> --%>
                                                        </dx:GridViewDataTextColumn>
                                                         <dx:GridViewDataTextColumn FieldName="LineNumber" Width="0"
                                                            VisibleIndex="0">
                                                            <%-- <HeaderStyle CssClass="hidden-column" />
                                                            <FilterCellStyle CssClass="hidden-column" />
                                                            <CellStyle CssClass="hidden-column" />--%>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="CustomerCode" Width="130px"
                                                            VisibleIndex="1">
                                                        </dx:GridViewDataTextColumn>
                                                         <dx:GridViewDataTextColumn FieldName="OldItemCode" VisibleIndex="3" Visible="true" Width="130px" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                           <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="3" Width="130px" Name="glItemCode">
                                                               <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="129px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" Settings-VerticalScrollBarMode="Visible"> 
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" AllowDragDrop="False" EnableRowHotTrack="True"/>

                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                        DropDown="lookup" ValueChanged="function(){
                                                                        if(itemc != gl.GetValue())
                                                                        gv1.batchEditApi.EndEdit();}"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="OldPalletID" ShowInCustomizationForm="True" VisibleIndex="16"  Caption="Old Pallet ID" ReadOnly="true" >
                                                        </dx:GridViewDataTextColumn> 
                                                        <dx:GridViewDataTextColumn FieldName="PalletID" ShowInCustomizationForm="True" VisibleIndex="16" Name="PalletID" Caption="Pallet ID" >
                                                        </dx:GridViewDataTextColumn>     
                                                        <dx:GridViewDataTextColumn FieldName="OldBatchNumber" ShowInCustomizationForm="True" VisibleIndex="11" Width="149px" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>     
                                                        <dx:GridViewDataTextColumn FieldName="BatchNumber" Name="BatchNumber" ShowInCustomizationForm="True" VisibleIndex="11" Width="149px">
                                                        </dx:GridViewDataTextColumn>    
                                                        <dx:GridViewDataDateColumn   Caption="Old Manufacturing Date" FieldName="OldManufacturingDate" ShowInCustomizationForm="True" Width="140px" VisibleIndex="11" ReadOnly="true">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn   Caption="Manufacturing Date" FieldName="ManufacturingDate" ShowInCustomizationForm="True" VisibleIndex="11" Width="125px">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn Caption="Old Expiry Date" FieldName="OldExpiryDate" ShowInCustomizationForm="True" VisibleIndex="11" ReadOnly="true">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn Caption="Expiry Date" FieldName="ExpiryDate" ShowInCustomizationForm="True" VisibleIndex="11">
                                                         </dx:GridViewDataDateColumn>   
                                                        <dx:GridViewDataTextColumn Caption="Old Client Name" FieldName="OldClientName" ShowInCustomizationForm="True" VisibleIndex="16" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Client Name" FieldName="ClientName" ShowInCustomizationForm="True" VisibleIndex="16">
                                                        </dx:GridViewDataTextColumn>
                                                         <dx:GridViewDataTextColumn Caption="Old Lot ID" FieldName="OldLotID" ShowInCustomizationForm="True" VisibleIndex="17" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Lot ID" FieldName="NewLotID" ShowInCustomizationForm="True" VisibleIndex="18">
                                                        </dx:GridViewDataTextColumn>
                                                       
                                                        <dx:GridViewDataSpinEditColumn Caption="Qty" FieldName="Qty" Name="Qty" ShowInCustomizationForm="True" VisibleIndex="19" ReadOnly="true" Width="0">
                                                                    <PropertiesSpinEdit Increment="0" ConvertEmptyStringToNull="False" DisplayFormatString="g" NullDisplayText="0.0000" NullText="0.0000">
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="BulkQty" FieldName="BulkQty" Name="BulkQty" ShowInCustomizationForm="True" VisibleIndex="20" ReadOnly="true" Width="0">
                                                                    <PropertiesSpinEdit Increment="0" ConvertEmptyStringToNull="False" DisplayFormatString="g" NullDisplayText="0.00" NullText="0.00">
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                        <%--<dx:GridViewDataDateColumn Caption="Qty" FieldName="Qty" ShowInCustomizationForm="True" VisibleIndex="12">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn Caption="BulkQty" FieldName="BulkQty" ShowInCustomizationForm="True" VisibleIndex="13">
                                                        </dx:GridViewDataDateColumn>--%>
                                                        <%--<dx:GridViewDataTextColumn FieldName="Field1"  Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="20" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Caption="Field2"  Name="Field2" ShowInCustomizationForm="True" VisibleIndex="21" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Caption="Field3"  Name="Field3" ShowInCustomizationForm="True" VisibleIndex="22" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Caption="Field4"  Name="Field4" ShowInCustomizationForm="True" VisibleIndex="23" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Caption="Field5"  Name="Field5" ShowInCustomizationForm="True" VisibleIndex="24" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Caption="Field6"  Name="Field6" ShowInCustomizationForm="True" VisibleIndex="25" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Caption="Field7"  Name="Field7" ShowInCustomizationForm="True" VisibleIndex="26" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8"  Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="27" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9"  Caption="Field9"  Name="Field9" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>--%>                              
                                                    </Columns>
                                                            <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager Mode="ShowAllRecords"/> 
                                                    <Settings HorizontalScrollBarMode="Visible"  VerticalScrollableHeight="0" VerticalScrollBarMode="Visible"  /> 
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" 
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                            <SettingsEditing Mode="Batch" />
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Transaction Detail" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem ShowCaption="False">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer>
                                                        <dx:ASPxGridView ID="gvTran" runat="server" AutoGenerateColumns="False" Width="747px"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gv2" DataSourceID="odsDetail"
                                                    OnRowValidating="grid_RowValidating" KeyFieldName="DocNumber;LineNumber;RecordId" SettingsBehavior-AllowSort="false"
                                                    Settings-ShowStatusBar="Hidden">  
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditStartEditing="OnStartEditing" />
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" visible="false"
                                                            VisibleIndex="0"> 
                                                        </dx:GridViewDataTextColumn>
                                                         <dx:GridViewDataTextColumn FieldName="TransType" visible="false"
                                                            VisibleIndex="0"> 
                                                        </dx:GridViewDataTextColumn>
                                                         <dx:GridViewDataTextColumn FieldName="LineNumber" Caption="Line #" Width="50"
                                                            VisibleIndex="0"> 
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="RecordId" VisibleIndex="1" Visible="true" Width="60px" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="CustomerCode" Caption="Customer Code" Width="100px"
                                                            VisibleIndex="2"> 
                                                        </dx:GridViewDataTextColumn>
                                                         <dx:GridViewDataTextColumn FieldName="OldItemCode" VisibleIndex="3" Visible="true" Width="150px" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                           <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="3" Width="150px" Name="glItemCode">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="OldPalletID" ShowInCustomizationForm="True" VisibleIndex="16"   Caption="Old Pallet ID" ReadOnly="true" >
                                                        </dx:GridViewDataTextColumn> 
                                                        <dx:GridViewDataTextColumn FieldName="PalletID" ShowInCustomizationForm="True" VisibleIndex="16" Name="PalletID" Caption="Pallet ID"  >
                                                        </dx:GridViewDataTextColumn>     
                                                        <dx:GridViewDataTextColumn FieldName="OldBatchNumber"   ShowInCustomizationForm="True" VisibleIndex="11" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>     
                                                        <dx:GridViewDataTextColumn FieldName="BatchNumber" Name="BatchNumber" ShowInCustomizationForm="True" VisibleIndex="11">
                                                        </dx:GridViewDataTextColumn>    
                                                        <dx:GridViewDataDateColumn   Caption="Old Manufacturing Date" FieldName="OldManufacturingDate" ShowInCustomizationForm="True" VisibleIndex="11" ReadOnly="true">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn   Caption="Manufacturing Date" FieldName="ManufacturingDate" ShowInCustomizationForm="True" VisibleIndex="11">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn Caption="Old Expiry Date" FieldName="OldExpiryDate" ShowInCustomizationForm="True" VisibleIndex="11" ReadOnly="true">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn Caption="Expiry Date" FieldName="ExpiryDate" ShowInCustomizationForm="True" VisibleIndex="11">
                                                        </dx:GridViewDataDateColumn>
                                                              <dx:GridViewDataTextColumn Caption="Old Client Name" FieldName="OldClientName" ShowInCustomizationForm="True" VisibleIndex="16" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Client Name" FieldName="ClientName" ShowInCustomizationForm="True" VisibleIndex="16">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Old Lot ID" FieldName="OldLotID" ShowInCustomizationForm="True" VisibleIndex="19" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Lot ID" FieldName="NewLotID" ShowInCustomizationForm="True" VisibleIndex="20">
                                                        </dx:GridViewDataTextColumn>
                                                       
                                                        <%--<dx:GridViewDataTextColumn FieldName="Field1"  Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="20" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Caption="Field2"  Name="Field2" ShowInCustomizationForm="True" VisibleIndex="21" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Caption="Field3"  Name="Field3" ShowInCustomizationForm="True" VisibleIndex="22" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Caption="Field4"  Name="Field4" ShowInCustomizationForm="True" VisibleIndex="23" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Caption="Field5"  Name="Field5" ShowInCustomizationForm="True" VisibleIndex="24" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Caption="Field6"  Name="Field6" ShowInCustomizationForm="True" VisibleIndex="25" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Caption="Field7"  Name="Field7" ShowInCustomizationForm="True" VisibleIndex="26" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8"  Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="27" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9"  Caption="Field9"  Name="Field9" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>--%>                              
                                                    </Columns>
                                                    <SettingsPager PageSize="10"/> 
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="530"  /> 
                                                            <SettingsEditing Mode="Batch" />
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
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>
                            <%-- <!--#endregion --> --%>

                            <%--<!--#region Region Details --> --%>
                            
                            <%-- <!--#endregion --> --%>
                        </Items>
                    </dx:ASPxFormLayout>
                    <dx:ASPxCallback ID="callbacker" runat="server" OnCallback="callbacker_Callback" ClientInstanceName="cbacker">
                        <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
                    </dx:ASPxCallback>
                     <dx:ASPxPopupControl ID="ExportCSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="ExportCSheet" CloseAction="CloseButton" CloseOnEscape="true"
                        EnableViewState="False" HeaderImage-Height="10px" Opacity="0" HeaderText="" Height="0px" ShowHeader="true" Width="0px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
                         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" 
                            ContentStyle-HorizontalAlign="Center" SettingsLoadingPanel-Enabled="true">
<HeaderImage Height="10px"></HeaderImage>

<ContentStyle HorizontalAlign="Center"></ContentStyle>
                            <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                                                                <dx:ASPxGridView ID="gvExtract" runat="server" ClientInstanceName="gvExtract" align="center" Visible="true"
                                                                     OnCustomCallback="gvExtract_CustomCallback" KeyFieldName="RecordId;Customer;PalletID" >
                                                                    <ClientSideEvents EndCallback="gvExtract_end" />
                                                                    <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                  <SettingsEditing Mode="Batch" />
                                                                </dx:ASPxGridView>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                    <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                <dx:ASPxButton ID="updateBtn" runat="server" Text="Submit" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
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
                                         </dx:ASPxButton>
                                     <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                         <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                         </dx:ASPxButton> 
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Calculating..."
            ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdata" TypeName="Entity.InternalTransfer+InternalTransferDetail" DataObjectTypeName="Entity.InternalTransfer+InternalTransferDetail" InsertMethod="InsertDataDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="Code" QueryStringField="docnumber" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  wms.InternalTransferDetail where RecordId  is null " OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="StorerKey" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name, Address, ContactPerson, TIN, ContactNumber, EmailAddress, BusinessAccountCode, AddedDate, AddedBy, LastEditedDate, LastEditedBy, IsInactive, IsCustomer, ActivatedBy, ActivatedDate, DeactivatedBy, DeactivatedDate, Field1, Field2, Field3, Field4, Field5, Field6, Field7, Field8, Field9 FROM Masterfile.BizPartner WHERE (ISNULL(IsInactive, 0) = '0') AND (IsCustomer = '1')" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="RRNum" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber,CustomerCode FROM WMS.Inbound WHERE ISNULL(SubmittedBy, '') != ''" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
     <!--#endregion-->
</body>
</html>


