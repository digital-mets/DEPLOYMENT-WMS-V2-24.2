<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmItemAdjustment.aspx.cs" Inherits="GWL.frmItemAdjustment" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title></title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
        <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
       #form1 {
        height: 750px; /*Change this whenever needed*/
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
           autocalculate();
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
               console.log(this);
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
               alert(s.cp_valmsg);
               alert(s.cp_message);
               delete (s.cp_valmsg);
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

           autocalculate();
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
           var cellInfo = e.rowValues[currentColumn.index];
           if (currentColumn.fieldName === "ItemCode") {
               cellInfo.value = gl.GetValue();
               cellInfo.text = gl.GetText().toUpperCase();
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
                       TotalQuantity1 += qty * 1.00 ;          //Sum of all Quantity
                       console.log(TotalQuantity1)
                   }
                  else {
                       var key = gv1.GetRowKey(indicies[i]);
                       if (gv1.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + indicies[i]);
                       else {
                           qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");

                           TotalQuantity1 += qty * 1.00 ;          //Sum of all Quantity
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
               if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7)  && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
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
           gv1.SetHeight(height - 120);
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
               gvExtract.GetSelectedFieldValues('DocNumber;LineNumber;ItemCode;ColorCode;ClassCode;SizeCode;PalletID;ToPalletID;BulkQty;Qty;FromLoc;ToLoc;StatusCode;UnitBase;UnitBulk;MfgDate;ExpirationDate;BatchNumber', OnGetSelectedFieldValues);
               endcbgrid = false;
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
               gv1.AddNewRow();
               getCol(gv1, editorobj, item);
           }
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
           if (column.fieldName == "DocNumber") {
               console.log('here', item[0])
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[0]);
           }
           if (column.fieldName == "LineNumber") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[1]);
           }
           if (column.fieldName == "ItemCode") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[2]);
           }
           if (column.fieldName == "ColorCode") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[3]);
           }
           if (column.fieldName == "ClassCode") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[4]);
           }
           if (column.fieldName == "SizeCode") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[5]);
           }
           if (column.fieldName == "PalletNumber") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[6] == 'null' ? null : item[6]);
           }
           if (column.fieldName == "BulkQty") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[8] == 'null' ? null : item[8]);
           }
           if (column.fieldName == "Qty") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[9] == 'null' ? null : item[9]);
           }
           if (column.fieldName == "Location") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[10] == 'null' ? null : item[10]);
           }
           if (column.fieldName == "StatusCode") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[12] == 'null' ? null : item[12]);
           }
           if (column.fieldName == "Unit") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[13] == 'null' ? null : item[13]);
           }
           if (column.fieldName == "BulkUnit") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[14] == 'null' ? null : item[14]);
           }
           if (column.fieldName == "Mkfgdate") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[15] == 'null' ? null : new Date(item[15]));
           }
           if (column.fieldName == "ExpiryDate") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[16] == 'null' ? null : new Date(item[16]));
           }
           if (column.fieldName == "BatchNo") {
               s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[17] == 'null' ? null : item[17]);
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
                                <dx:ASPxLabel runat="server" Text="Item Adjustment" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
        <%--<!--#region Region Factbox --> --%>
        <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        </dx:ASPxPopupControl>
        <%--<!--#endregion --> --%>
                  <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents CloseUp="function (s, e) { cp.PerformCallback('refgrid'); e.processOnServer = false;}" />
    </dx:ASPxPopupControl>
  
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px " Style="margin-left: -3px; margin-right: 0px;">
                     <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />

                            <Items>
                            <%--<!--#region Region Header --> --%>
                            
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
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
                                                              <ClientSideEvents Validation="OnValidation" Init="function(s,e){ s.SetDate(new Date());}" />
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip" >
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Adjustment:" Name="TotalAdjustment">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txttotaladjustment" runat="server"  ClientInstanceName="txtTotalQty"  ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                       <dx:LayoutItem Caption="Adjustment Type:" Name="AdjustmentType" ColSpan="2">
                                                  <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxGridLookup ID="txtAdjustmentType"  Width="170px" runat="server" DataSourceID="ItemAdjustment" KeyFieldName="AdjustmentCode" OnLoad="LookupLoad" TextFormatString="{0}" >
                                                           <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Warehouse Code:" Name="WarehouseCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtwarehousecode" runat="server" Width="170px"  DataSourceID="Warehouse" KeyFieldName="WareHouseCode" OnLoad="LookupLoad" 
                                                          ClientInstanceName="aglWarehouseCode" TextFormatString="{0}" >
                                                           <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             <dx:LayoutItem Caption="Customer Code:" Name="StorerKey">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="cmbStorerKey" runat="server" Width="170px" AutoGenerateColumns="False" DataSourceID="StorerKey" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad"  TextFormatString="{0}">
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
                                                            <ClientSideEvents Validation="OnValidation" />
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

                                            <dx:LayoutItem Caption="Remarks:" Name="Remarks" ColSpan="2">
                                                  <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtremarks" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxRoundPanel ID="rpFilter" runat="server" Width="200px" HeaderText="Filter">
                                                            <PanelCollection>
                                                                <dx:PanelContent runat="server">
                                                                    <table>
                                                                        <tr align="left">
                                                                            <td>
                                                                                <dx:ASPxLabel ID="lblCustomer" runat="server" Text="Customer:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="lblItem" runat="server" Text="Item Code:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="lblLocation" runat="server" Text="Location:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                            <%--<td>
                                                                                <dx:ASPxLabel ID="lblLot" runat="server" Text="Lot:">
                                                                                </dx:ASPxLabel>
                                                                            </td>--%>
                                                                            <td>
                                                                                <dx:ASPxLabel ID="lblPallet" runat="server" Text="Pallet:">
                                                                                </dx:ASPxLabel>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <dx:ASPxTextBox ID="txtCustomer" runat="server" Width="170px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxTextBox ID="txtItem" runat="server" Width="170px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                            <td>
                                                                                <dx:ASPxTextBox ID="txtLocation" runat="server" Width="170px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                            <%--<td>
                                                                                <dx:ASPxTextBox ID="txtLot" runat="server" Width="170px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>--%>
                                                                            <td>
                                                                                <dx:ASPxTextBox ID="txtPalletID" runat="server" Width="170px">
                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td colspan="5" align="right">
                                                                                <dx:ASPxButton ID="btnSearch" runat="server" Text="Search" AutoPostBack="false" UseSubmitBehavior="false">
                                                                                   <ClientSideEvents Click="function(s, e) { endcbgrid = true; loader.Show(); loader.SetText('Searching...'); gvExtract.PerformCallback('Pal');}" />
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
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                           
                                            <dx:LayoutItem Caption="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                              
                                            <dx:LayoutItem Caption="Field3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
             
                                            <dx:LayoutItem Caption="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                             
                                            <dx:LayoutItem Caption="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                             <dx:LayoutItem Caption="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                          <dx:LayoutItem Caption="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                  <dx:LayoutItem Caption="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                           <dx:LayoutItem Caption="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
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


                            <dx:LayoutGroup Caption="Item Adjustment Detail">
                                <Items>
                                     <dx:LayoutGroup Caption="Inventory Detail">
                                        <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="747px"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber" >  
                                                    
                                                         <ClientSideEvents Init="OnInitTrans" />
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False"
                                                            VisibleIndex="0">
                                                        </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="100px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                           <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="3" Width="100px" Name="glItemCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="glItemCode_Init"
                                                                    DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
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
                                                                        DropDown="lookup" ValueChanged="function(s,e){
                                                                                            if(itemc != gl.GetValue()){
                                                                                            loader.SetText('Loading...');
                                                                                            loader.Show();
                                                                                            closing = true;
                                                                                            gl2.GetGridView().PerformCallback('ItemCode' + '|' + gl.GetValue() + '|' + 'code' + '|' + bulkqty);
                                                                                            e.processOnServer = false;
                                                                                            valchange2 = true;}
                                                                                          }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn ReadOnly="true" FieldName="FullDesc" VisibleIndex="4" Width="250px" Caption="ItemDesc">
                                                           </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="4" Width="0px" UnboundType="String">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    KeyFieldName="ColorCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" OnInit="lookup_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-AllowSort="false">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function(s, e){
                                                                        gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }"
                                                                         RowClick="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="5" Width="0px" UnboundType="String">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                KeyFieldName="ClassCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                        DropDown="function dropdown(s, e){
                                                                        gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }" RowClick="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="6" FieldName="SizeCode" Width="0px">
                                                                                                                  <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                KeyFieldName="SizeCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                        DropDown="function dropdown(s, e){
                                                                        gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }" RowClick="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="BulkQty" VisibleIndex="7" Width="90px">
                                                                <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="True" NullText="0" DisplayFormatString="{0:N}"
                                                                    ClientInstanceName="gBulkQty" MinValue="0">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    <ClientSideEvents ValueChanged="function(s,e){
                                                                         loader.SetText('Calculating');
                                                                         loader.Show();
                                                                         gl4.GetGridView().PerformCallback('BulkQty' + '|' + itemc + '|' + gBulkQty.GetValue());
                                                                         e.processOnServer = false;
                                                                         valchange = true;}"
                                                                         />
                                                                </PropertiesSpinEdit>
                                                            </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn Caption="Reason" Name="Reason" ShowInCustomizationForm="True" VisibleIndex="12" FieldName="Reason">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BaseQty" Caption="BaseQty" Name="BaseQty" ShowInCustomizationForm="True" VisibleIndex="17" UnboundType="Decimal">
                                                          <PropertiesTextEdit NullDisplayText="0">
                                                         </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="80px">
                                                        <CustomButtons>
                                                            <dx:GridViewCommandColumnCustomButton ID="Details">
                                                               <Image IconID="support_info_16x16"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                            		<dx:GridViewCommandColumnCustomButton ID="CountSheet">
                                                             <Image IconID="arrange_withtextwrapping_topleft_16x16" ToolTip="Countsheet"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                              <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                <Image IconID="actions_cancel_16x16"> </Image>
                                                                
                                                            </dx:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                                   <dx:GridViewDataSpinEditColumn Caption="Adjustment Qty" FieldName="Qty" Name="Qty" ShowInCustomizationForm="True" VisibleIndex="9">
                                                                    <PropertiesSpinEdit Increment="0" ClientInstanceName="txtReturnedQty" ConvertEmptyStringToNull="False" DisplayFormatString="g" NullDisplayText="0" NullText="0">
                                                                        <ClientSideEvents ValueChanged="autocalculate" />
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>

<%--                                                        <dx:GridViewDataTextColumn Caption="Adjustment Qty" Name="Qty" ShowInCustomizationForm="True" VisibleIndex="9" FieldName="Qty" >
                                                         <PropertiesTextEdit NullDisplayText="0">
                                                                 <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesTextEdit>--%>
                                                   <%--     </dx:GridViewDataTextColumn>--%>
                                                        <dx:GridViewDataTextColumn FieldName="Unit" Caption="Unit" Name="Unit" ShowInCustomizationForm="True" VisibleIndex="10">
                                                               <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="Unit" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    DataSourceID="UnitBase" KeyFieldName="UnitCode" ClientInstanceName="glUnit" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" />
                                                                        
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" RowClick="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Name="Location" ShowInCustomizationForm="True" VisibleIndex="11" FieldName="Location"  UnboundType="String">
                                                              <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glLocation" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init2" 
                                                                    DataSourceID="Location" KeyFieldName="LocationCode" ClientInstanceName="glLocation" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="LocationCode" ReadOnly="True" VisibleIndex="0" />
                                                                        
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" 
                                                                        DropDown="function dropdown(s, e){
                                                                        glLocation.GetGridView().PerformCallback('LocationCode' + '|' + aglWarehouseCode.GetValue() + '|' + s.GetInputElement().value);
                                                                        }" RowClick="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                         </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BatchNo" Name="BatchNo" ShowInCustomizationForm="True" VisibleIndex="11">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LotNo" Name="Lot" ShowInCustomizationForm="True" VisibleIndex="10">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn Caption="Expiry Date" FieldName="ExpiryDate" ShowInCustomizationForm="True" VisibleIndex="11">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn   Caption="Manufacturing Date" FieldName="Mkfgdate" ShowInCustomizationForm="True" VisibleIndex="11">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1"  Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="20" UnboundType="Bound">
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
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BulkUnit" VisibleIndex="8" Name="BulkUnit">
                                                         <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="BulkUnit" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    DataSourceID="Unit" KeyFieldName="UnitCode" ClientInstanceName="glBulkUnit" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" />
                                                                        
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" RowClick="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="StorageType" Name="StorageType" ShowInCustomizationForm="True" VisibleIndex="13" >
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="StorageType" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    DataSourceID="StoragesType" KeyFieldName="StorageType" ClientInstanceName="glStorageType" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="StorageType" ReadOnly="True" VisibleIndex="0" />
                                                                        
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" ValueChanged="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="PalletNumber" ShowInCustomizationForm="True" VisibleIndex="16" Name="PalletNumber" Caption="Pallet ID">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="StatusCode" ShowInCustomizationForm="True" VisibleIndex="18">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BarcodeNo" ShowInCustomizationForm="True" VisibleIndex="19" Caption="Barcode Number">
                                                        </dx:GridViewDataTextColumn>
                                                     
                                                    </Columns>
                                                            <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager PageSize="5"/> 
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="530"  /> 
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
                            <%-- <!--#endregion --> --%>
                        </Items>
                    </dx:ASPxFormLayout>
                     <dx:ASPxPopupControl ID="ExportCSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="ExportCSheet" CloseAction="CloseButton" CloseOnEscape="true"
                        EnableViewState="False" HeaderImage-Height="10px" Opacity="0" HeaderText="" Height="0px" ShowHeader="true" Width="0px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
                         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" 
                            ContentStyle-HorizontalAlign="Center" SettingsLoadingPanel-Enabled="true">
                            <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                                                                <dx:ASPxGridView ID="gvExtract" runat="server" ClientInstanceName="gvExtract" align="center" Visible="true"
                                                                     OnCustomCallback="gvExtract_CustomCallback" KeyFieldName="DocNumber;LineNumber" >
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
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.ItemAdjustment" DataObjectTypeName="Entity.ItemAdjustment" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.ItemAdjustment+ItemAdjustmentDetail" DataObjectTypeName="Entity.ItemAdjustment+ItemAdjustmentDetail" DeleteMethod="DeleteItemAdjustmentDetail" InsertMethod="AddItemAdjustmentDetail" UpdateMethod="UpdateItemAdjustmentDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="DocNumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  wms.ItemAdjustmentDetail where DocNumber  is null " OnInit = "Connection_Init">
  
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsColor" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsClass" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSize" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WareHouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,'')=0" OnInit = "Connection_Init"></asp:SqlDataSource>
   <asp:SqlDataSource ID="ItemAdjustment" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AdjustmentCode,TransType FROM Masterfile.[AdjustmentType]" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,'')=0" OnInit = "Connection_Init"></asp:SqlDataSource>
       <asp:SqlDataSource ID="Unit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.Unit where ISNULL(IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
     <asp:SqlDataSource ID="UnitBase" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.Unit where ISNULL(IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
     <asp:SqlDataSource ID="sdsLocation" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select LocationCode,LocationDescription,WarehouseCode from masterfile.Location  where isnull(IsInactive,'')=0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="StoragesType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT StorageType,StorageDescription FROM masterfile.StorageType " OnInit = "Connection_Init"></asp:SqlDataSource>
     <asp:SqlDataSource ID="StorerKey" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name, Address, ContactPerson, TIN, ContactNumber, EmailAddress, BusinessAccountCode, AddedDate, AddedBy, LastEditedDate, LastEditedBy, IsInactive, IsCustomer, ActivatedBy, ActivatedDate, DeactivatedBy, DeactivatedDate, Field1, Field2, Field3, Field4, Field5, Field6, Field7, Field8, Field9 FROM Masterfile.BizPartner WHERE (ISNULL(IsInactive, 0) = '0') AND (IsCustomer = '1')" OnInit="Connection_Init"></asp:SqlDataSource>
  
     <!--#endregion-->
</body>
</html>


