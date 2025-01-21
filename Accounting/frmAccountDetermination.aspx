<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmAccountDetermination.aspx.cs" Inherits="GWL.frmAccountDetermination" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Account Determination</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>

     <!--#region Region Javascript-->


        <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
#form1 {
height: 580px; /*Change this whenever needed*/
}

.Entry {
/*width: 806px; /*Change this whenever needed*/
/*padding: 30px;
margin: 40px auto;
background: #FFF;
border-radius: 10px;
-webkit-border-radius: 10px;
-moz-border-radius: 10px;
box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
-moz-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
-webkit-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);*/

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

           gv1.batchEditApi.EndEdit();

           var btnmode = btn.GetText(); //gets text of button
           if (btnmode == "Delete") {
               cp.PerformCallback("Delete");
           }

           var indicies = gv1.batchEditApi.GetRowVisibleIndices();
           for (var i = 0; i < indicies.length; i++) {
               if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                   gv1.batchEditApi.ValidateRow(indicies[i]);
                   //gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("Qty").index);
               }
               else {
                   var key = gv1.GetRowKey(indicies[i]);
                   if (gv1.batchEditApi.IsDeletedRow(key))
                       console.log("deleted row " + indicies[i]);
                   else {
                       gv1.batchEditApi.ValidateRow(indicies[i]);
                       // gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("Qty").index);
                   }
               }
           }


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
       }


       function OnConfirm(s, e) {//function upon saving entry
           if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
               e.cancel = true;
       }


       var initgv = 'true';
       var vatrate = 0;
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
               delete (cp_delete);
               DeleteControl.Show();
           }

       }

       var index;
       var closing;
       var valchange = false;
       var itemc; //variable required for lookup
       var currentColumn = null;
       var valchange_VAT = false;
       var isSetTextRequired = false;
       var linecount = 1;
       var VATCode = "";
       var transtype = "";
       function OnStartEditing(s, e) {//On start edit grid function     
           currentColumn = e.focusedColumn;
           var cellInfo = e.rowValues[e.focusedColumn.index];
           transtype = CINTransType.GetValue();
           itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "PropertyNumber"); //needed var for all lookups; this is where the lookups vary for
           //if (e.visibleIndex < 0) {//new row
           //    var linenumber = s.GetColumnByField("LineNumber");
           //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
           //}

           index = e.visibleIndex;
           var entry = getParameterByName('entry');

           if (entry == "V") {
               e.cancel = true; //this will made the gridview readonly
           }

           //if (s.batchEditApi.GetCellValue(e.visibleIndex, "Transtype") === null || s.batchEditApi.GetCellValue(e.visibleIndex, "Transtype") === "") {
           //    s.batchEditApi.SetCellValue(e.visibleIndex, "Transtype", transtype)
           //}
           if (entry == "E") {

               if (e.focusedColumn.fieldName === "TOACode") {
                   e.cancel = true;
               }
               if (e.focusedColumn.fieldName === "TypeofAccount") {
                   e.cancel = true;
               }
           }
           if (entry != "V") {
               if (e.focusedColumn.fieldName === "VATCode") {
                   if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsVat") == false) {
                       e.cancel = true;
                   }
                   else {
                       CINVATCode.GetInputElement().value = cellInfo.value; //Gets the column value
                       isSetTextRequired = true;
                   }
               }

               if (e.focusedColumn.fieldName === "PropertyNumber") { //Check the column name
                   gl.GetInputElement().value = cellInfo.value; //Gets the column value
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
               if (e.focusedColumn.fieldName === "Qty") {
                   CINQty.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "UnitCost") {
                   CINUnitCost.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "AccumulatedDepreciation") {
                   CINAccumulatedDepreciation.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "IsVat") {
                   CINIsVAT.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "AccountCode") {
                   CINAccountCode.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "SubsiCode") {
                   CINSubsiCode.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "Transtype") {
                   e.cancel = true;
               }

           }

       }


       //Kapag umalis ka sa field na yun. hindi mawawala yung value.
       function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
           var cellInfo = e.rowValues[currentColumn.index];
           if (currentColumn.fieldName === "PropertyNumber") {
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
           if (currentColumn.fieldName === "Qty") {
               cellInfo.value = CINQty.GetValue();
               cellInfo.text = CINQty.GetText();
           }
           if (currentColumn.fieldName === "UnitCost") {
               cellInfo.value = CINUnitCost.GetValue();
               cellInfo.text = CINUnitCost.GetText();
           }
           if (currentColumn.fieldName === "AccumulatedDepreciation") {
               cellInfo.value = CINAccumulatedDepreciation.GetValue();
               cellInfo.text = CINAccumulatedDepreciation.GetText();
           }
           if (currentColumn.fieldName === "IsVat") {
               cellInfo.value = CINIsVAT.GetValue();
           }
           if (currentColumn.fieldName === "AccountCode") {
               cellInfo.value = CINAccountCode.GetValue();
               cellInfo.text = CINAccountCode.GetText();
           }
           if (currentColumn.fieldName === "SubsiCode") {
               cellInfo.value = CINSubsiCode.GetValue();
               cellInfo.text = CINSubsiCode.GetText();
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
           var totalcostasset = 0.00;
           if (val == null) {
               val = ";;;;;;;;;;";
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
           if (temp[9] == null) {
               temp[9] = "";
           }
           if (temp[10] == null) {
               temp[10] = "";
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
               if (column.fieldName == "ItemCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
               }
               if (column.fieldName == "Qty") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
               }
               if (column.fieldName == "UnitCost") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
               }
               if (column.fieldName == "AccumulatedDepreciation") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[6]);
               }
               if (column.fieldName == "PropertyStatus") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[7]);
               }
               if (column.fieldName == "IsVat") {
                   if (temp[8] == "True") {
                       s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, CINIsVAT.SetChecked = true);
                   }
                   else {
                       s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, CINIsVAT.SetChecked = false);
                   }
               }
               if (column.fieldName == "VATCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[9]);
               }
               if (column.fieldName == "Rate") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[10]);
               }
               if (column.fieldName == "OrigQty") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
               }




           }
       }

       var identifier;
       function GridEndChoice(s, e) {

           identifier = s.GetGridView().cp_identifier;
           val = s.GetGridView().cp_codes;
           temp = val.split(';');
           val_VAT = s.GetGridView().cp_codes;
           temp_VAT = val_VAT.split(';');

           //console.log(identifier + " idetifier")
           //console.log(val + " VAL")
           //console.log(val_VAT + " VAL_VAT")

           console.log(temp + " ito sila!")
           if (identifier == "ItemCode") {
               GridEnd();
           }

           if (identifier == "VAT") {
               GridEnd_VAT();
               gv1.batchEditApi.EndEdit();
           }
       }


       function GridEnd(s, e) {

           if (closing == true) {
               var indicies = gv1.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indicies.length; i++) {
                   gv1.batchEditApi.ValidateRow(indicies[i]);
                   gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("Qty").index);
               }
               gv1.batchEditApi.EndEdit();
               loader.Hide();
           }
       }


       function GridEnd_VAT(s, e) {
           if (valchange_VAT) {
               valchange_VAT = false;
               var column = gv1.GetColumn(12);
               ProcessCells_VAT(0, index, column, gv1);
           }
       }


       function ProcessCells_VAT(selectedIndex, focused, column, s) {//Auto calculate qty function :D
           console.log("ProcessCells_VAT")
           if (val_VAT == null) {
               val_VAT = ";";
               temp_VAT = val_VAT.split(';');
           }
           if (temp_VAT[0] == null) {
               temp_VAT[0] = 0;
           }
           if (selectedIndex == 0) {
               console.log(temp_VAT[0] + "TEMPVAT")
               s.batchEditApi.SetCellValue(focused, "Rate", temp_VAT[0]);
           }
       }

       //function lookup(s, e) {
       //if (isSetTextRequired) {//Sets the text during lookup for item code
       // s.SetText(s.GetInputElement().value);
       // isSetTextRequired = false;
       //  }
       //   }

       function lookup(s, e) {
           if (isSetTextRequired) {//Sets the text during lookup for item code
               //s.SetText(s.GetInputElement().value);
               var propertynum;
               var getallpropertynum;
               isSetTextRequired = false;
               var indicies = gv1.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indicies.length; i++) {
                   if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                       console.log(indicies)
                       propertynum = gv1.batchEditApi.GetCellValue(indicies[i], "PropertyNumber") + ";";

                       getallpropertynum += propertynum;
                       console.log(getallpropertynum + " ALL")
                   }

                   else {
                       var keyB = gv1.GetRowKey(indicies[i]);
                       if (gv1.batchEditApi.IsDeletedRow(keyB))
                           console.log("deleted row " + indicies[i]);
                       else {
                           propertynum = gv1.batchEditApi.GetCellValue(indicies[i], "PropertyNumber") + ";";
                           getallpropertynum += propertynum;

                       }
                   }

               }
               //gl2.GetGridView().PerformCallback('CheckPropertyNumber' + '|' + getallpropertynum + '|' + 'itemc');
               console.log(gl.GetGridView() + '        gl.GetGridView()');
               gl.GetGridView().PerformCallback('CheckPNumber' + '|' + getallpropertynum + '|' + 'itemc');
               e.processOnServer = false;
           }
       }

       function CheckPropertyNumber(s, e) {
           var propertynum;
           var getallpropertynum;
           var indicies = gv1.batchEditApi.GetRowVisibleIndices();
           for (var i = 0; i < indicies.length; i++) {
               if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                   propertynum = gv1.batchEditApi.GetCellValue(indicies[i], "PropertyNumber") + ";";

                   getallpropertynum += propertynum;
                   console.log(getallpropertynum + " ALL")
               }

               else {
                   var keyB = gv1.GetRowKey(indicies[i]);
                   if (gv1.batchEditApi.IsDeletedRow(keyB))
                       console.log("deleted row " + indicies[i]);
                   else {
                       propertynum = gv1.batchEditApi.GetCellValue(indicies[i], "PropertyNumber") + ";";
                       getallpropertynum += propertynum;

                   }
               }

           }
           console.log('ditopota')
           gl.GetGridView().PerformCallback('CheckPropertyNumber' + '|' + getallpropertynum + '|' + 'itemc');
           e.processOnServer = false;
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
           gv1.batchEditApi.EndEdit();
       }

       //validation
       function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)

           for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
               var column = s.GetColumn(i);
               var chckd;
               var chckd2;
               var bulk;
               var bulk2;

               if (column.fieldName == "IsVat") {
                   //console.log('isvat')
                   var cellValidationInfo = e.validationInfo[column.index];
                   if (!cellValidationInfo) continue;
                   var value = cellValidationInfo.value;

                   //console.log(value + ' IsVat value')
                   if (value == true) {
                       chckd2 = true;
                   }
               }
               if (column.fieldName == "VATCode") {
                   var cellValidationInfo = e.validationInfo[column.index];
                   if (!cellValidationInfo) continue;
                   var value = cellValidationInfo.value;

                   //console.log(value + ' value')

                   //console.log(chckd2 + ' chckd2')
                   if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == "NONV") && chckd2 == true) {
                       cellValidationInfo.isValid = false;
                       cellValidationInfo.errorText = column.fieldName + " is required!";
                       isValid = false;
                   }
               }

               if (column.fieldName == "Qty") {
                   var originalqty = s.batchEditApi.GetCellValue(e.visibleIndex, "OrigQty");
                   var tempqty = s.batchEditApi.GetCellValue(e.visibleIndex, "Qty");

                   var cellValidationInfo = e.validationInfo[column.index];
                   if (!cellValidationInfo) continue;
                   var value = cellValidationInfo.value;
                   if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "0" || ASPxClientUtils.Trim(value) == "0.00" || ASPxClientUtils.Trim(value) == null || ASPxClientUtils.Trim(value) < 1)) {
                       cellValidationInfo.isValid = false;
                       cellValidationInfo.errorText = column.fieldName + " is required!";
                       isValid = false;
                       //console.log(ASPxClientUtils.Trim(value) + ' ASPxClientUtils.Trim(value)')
                   }
                   if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) > originalqty) {
                       cellValidationInfo.isValid = false;
                       cellValidationInfo.errorText = column.fieldName + " exceed the quantity in record!";
                       isValid = false;
                   }
               }
           }
       }


       function OnCustomClick(s, e) {
           if (e.buttonID == "Details") {
               var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "PropertyNumber");
               var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
               var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
               var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
               var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "UnitBase");
               factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
               + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&unitbase=' + unitbase);
           }

           if (e.buttonID == "Delete") {
               gv1.DeleteRow(e.visibleIndex);
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
           //gvJournal.SetWidth(width - 100);
       }


       //#region For future reference JS 

       //Debugging purposes
       //function start(s, e) {
       //    pass = fieldValue;
       //    console.log("start callback " + pass);
       //}

       //function end(s, e) {
       //    console.log("end callback");
       //}
       //function rowclick(s, e) {
       //    s.GetRowValues(e.visibleIndex, 'ItemCode;ColorCode;ClassCode;SizeCode', function (data) {
       //        console.log(data[0], data[1], data[2], data[3]);
       //        //splitter.GetPaneByName("Factbox").SetContentUrl('../FactBox/fbBizPartner.aspx?itemcode=' + data[0]
       //        //+ '&colorcode='+data[1]+'&classcode='+data[2]+'&sizecode='+data[3]);
       //        factbox.SetContentUrl('../FactBox/fbBizPartner.aspx?itemcode=' + data[0]
       //        + '&colorcode=' + data[1] + '&classcode=' + data[2] + '&sizecode=' + data[3]);
       //    });
       //}

       //function getParameterByName(name) {
       //    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
       //    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
       //        results = regex.exec(location.search);
       //    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
       //}

       //function OnControlInitialized(event) {
       //    var entry = getParameterByName('entry');
       //    if (entry == "N") {
       //        splitter.GetPaneByName("Factbox").SetContentUrl('../FactBox/fbBizPartner.aspx');
       //        //splitter.GetPaneByName("Factbox2").SetContentUrl('../FactBox/fbBizPartner.aspx');
       //        //splitter.GetPaneByName("Factbox3").SetContentUrl('../FactBox/fbBizPartner.aspx');
       //        //splitter.GetPaneByName("Factbox4").SetContentUrl('../FactBox/fbBizPartner.aspx');
       //    }
       //}
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
                                <dx:ASPxLabel runat="server" Text="Account Determination" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
           <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="910px" ClientInstanceName="cp" OnCallback="cp_Callback">
           <%-- <ClientSideEvents EndCallback="gridView_EndCallback" Init="function(){ if(initgv == 'true'){ cp.PerformCallback('getvat'); initgv = 'false'; }}"></ClientSideEvents>
            --%><ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -3px">
                         <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                       
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>

<%--                                            <dx:LayoutItem Caption="Disposal Document Number" Name="DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" OnLoad="TextboxLoad" Enabled="false">
                                                        <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>


                                            <dx:LayoutItem Caption="TransType">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup AutoGenerateColumns="true" ID="glTransType" ClientInstanceName="CINTransType" runat="server" Width="170px" DataSourceID="TransTypeLookup" KeyFieldName="TransType" OnLoad="LookupLoad" TextFormatString="{0}">
                                                               <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('TransTypeCase');  e.processOnServer = false;}" />
                                                                    <ClientSideEvents Validation="OnValidation"/>
                                                                    <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True"/>
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="False" AllowSelectByRowClick="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
								                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="TransType" ReadOnly="true">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Prompt" ReadOnly="true">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Description" Name="Description">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDescription" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                          
                                             
                                            <dx:LayoutItem Caption="ModuleID">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup AutoGenerateColumns="true" ID="glModuleID" ClientInstanceName="CINModuleID" runat="server" Width="170px" DataSourceID="ModuleIDLookup" KeyFieldName="ModuleID" OnLoad="LookupLoad" TextFormatString="{0}">
                                                               <ClientSideEvents Validation="OnValidation"/>
                                                                    <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True"/>
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="False" AllowSelectByRowClick="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
								                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ModuleID" ReadOnly="true">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Prompt" ReadOnly="true">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                        </dx:ASPxGridLookup>
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
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:">
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
                                            <dx:LayoutGroup Caption="General Ledger">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvJournal" runat="server" AutoGenerateColumns="False" ClientInstanceName="gvJournal" KeyFieldName="RTransType;TransType" Width="850px">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" Init="OnInitTrans" />
                                                                    <SettingsPager Mode="ShowAllRecords">
                                                                    </SettingsPager>
                                                                    <SettingsEditing Mode="Batch">
                                                                    </SettingsEditing>
                                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />
                                                                    <SettingsBehavior AllowSort="False" />
                                                                    <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn Caption="Account Code" FieldName="AccountCode" Name="jAccountCode" ShowInCustomizationForm="True" VisibleIndex="0" Width="140px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Account Description" FieldName="AccountDescription" Name="jAccountDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width="250px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Subsidiary Code" FieldName="SubsidiaryCode" Name="jSubsidiaryCode" ShowInCustomizationForm="True" VisibleIndex="2" Width="140px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Subsidiary Description" FieldName="SubsidiaryDescription" Name="jSubsidiaryDescription" ShowInCustomizationForm="True" VisibleIndex="3" Width="140px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Profit Center" FieldName="ProfitCenter" Name="jProfitCenter" ShowInCustomizationForm="True" VisibleIndex="4" Width="140px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Cost Center" FieldName="CostCenter" Name="jCostCenter" ShowInCustomizationForm="True" VisibleIndex="5" Width="140px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Debit  Amount" FieldName="Debit" Name="jDebit" ShowInCustomizationForm="True" VisibleIndex="6" Width="140px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataSpinEditColumn Caption="Credit Amount" FieldName="Credit" Name="jCredit" ShowInCustomizationForm="True" VisibleIndex="7" Width="140px">
                                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CINCredit" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0" NullText="0" NumberFormat="Custom">
                                                                                <SpinButtons ShowIncrementButtons="False">
                                                                                </SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                        </dx:GridViewDataSpinEditColumn>
                                                                        <dx:GridViewDataTextColumn ShowInCustomizationForm="True" VisibleIndex="8" Width="0px">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
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
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                               </dx:LayoutItem> 
                                        </Items>
                                    </dx:LayoutGroup>
                                </Items>
                            </dx:TabbedLayoutGroup>
                            
                            <dx:LayoutGroup Caption="Account Determination Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="850px" 
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnCustomButtonInitialize="gv1_CustomButtonInitialize" SettingsBehavior-AllowSort="False">
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                        BatchEditStartEditing="OnStartEditing"  BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" />
                                                    <SettingsPager Mode="ShowAllRecords"/> 
                                                            <SettingsEditing Mode="Batch" />


                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="200" ShowFooter="True"  /> 
                                                    
                                                        
<SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    
                                                        
                                                    <Columns>



                                                        <dx:GridViewDataTextColumn FieldName="Transtype" Name="TransType" Caption="TransType" ShowInCustomizationForm="True" VisibleIndex="1" Width="80px" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TOACode" Name="TOACode" ShowInCustomizationForm="True" VisibleIndex="2" Width="100px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TypeofAccount" Name="TypeofAccount" ShowInCustomizationForm="True" VisibleIndex="3" Width="300px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" VisibleIndex="4" Width="100px">   
                                                              <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glAccountCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    KeyFieldName="AccountCode" DataSourceID="AccountCodeLookup" ClientInstanceName="CINAccountCode" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSort="false"/>
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubsiCode" VisibleIndex="5" Width="100px">   
                                                              <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSubsiCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    KeyFieldName="SubsiCode" DataSourceID="SubsiCodeLookup" ClientInstanceName="CINSubsiCode" 
                                                                    TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSort="false"/>
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SubsiCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" VisibleIndex="19" Width="100px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" VisibleIndex="20" Width="100px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" VisibleIndex="21" Width="100px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" VisibleIndex="22" Width="100px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" VisibleIndex="23" Width="100px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" VisibleIndex="24" Width="100px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" VisibleIndex="25" Width="100px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="26" Width="100px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="27" Width="100px">
                                                        </dx:GridViewDataTextColumn>

                                                        
                                                        <%--<dx:GridViewDataTextColumn FieldName="PropertyNumber" VisibleIndex="1" Width="300px" Name="glPropertyNumber">
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glPropertyNumber" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    DataSourceID="PropertyNumberLookup" KeyFieldName="PropertyNumber" ClientInstanceName="gl" TextFormatString="{0}" Width="300px" OnLoad="gvLookupLoad" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="PropertyNumber" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents  KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" RowClick="function(s,e){
                                                                    console.log('rowclick');
                                                                    loader.Show();
                                                                    setTimeout(function(){
                                                                    gl2.GetGridView().PerformCallback('PropertyNumber' + '|' + gl.GetValue() + '|' + 'itemc');
                                                                    e.processOnServer = false;
                                                                    valchange = true
                                                                    }, 1000);
                                                                  }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>--%>
                                                        <%--ValueChanged="function (s, e){ cp.PerformCallback('PropertyInformation');  e.processOnServer = false;}"--%>

                                                       <%-- <dx:GridViewDataTextColumn FieldName="ItemCode" Visible="false" Width="100px" Name="glItemCode">
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                       


                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="2" Width="0px" Caption="ColorCode">   
                                                              <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    KeyFieldName="ColorCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="100px" ReadOnly="true" OnInit="lookup_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEndChoice" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" Visible="false" Width="80px" Name="glClassCode" Caption="ClassCode">
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                KeyFieldName="ClassCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Visible="false" Width="80px" Name ="glSizeCode" Caption="SizeCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                KeyFieldName="SizeCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>  
                                                         </dx:GridViewDataTextColumn>--%>

                                                      <%--   <dx:GridViewDataSpinEditColumn FieldName="Qty" Name="Qty" Caption="Quantity" VisibleIndex="3" Width="180px">
                                                        <PropertiesSpinEdit Increment="0" ClientInstanceName="CINQty" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                            <ClientSideEvents NumberChanged ="autocalculate"/>
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>

                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitCost" Name="UnitCost" Caption="Unit Cost" VisibleIndex="4" Width="0px">
                                                        <PropertiesSpinEdit Increment="0" ClientInstanceName="CINUnitCost" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                            <ClientSideEvents NumberChanged="autocalculate" />
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>

                                                        
                                                        <dx:GridViewDataSpinEditColumn FieldName="AccumulatedDepreciation" Name="AccumulatedDepreciation" Caption="Accumulated Deppreciation" VisibleIndex="5" Width="0px">
                                                        <PropertiesSpinEdit Increment="0" ClientInstanceName="CINAccumulatedDepreciation" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>


                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitPrice" ShowInCustomizationForm="True" VisibleIndex="6" Width="180px">
                                                        <PropertiesSpinEdit Increment="0" ClientInstanceName="CINUnitPrice" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                            <ClientSideEvents NumberChanged ="autocalculate"
                                                                    />
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>


                                                        <dx:GridViewDataTextColumn ReadOnly="true" FieldName="SoldAmount" VisibleIndex="7" Width="230px" Caption="SoldAmount">
                                                        <PropertiesTextEdit ClientInstanceName="CINSoldAmount"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>--%>
<%--                                                        <dx:GridViewDataSpinEditColumn FieldName="SoldAmount" Name="SoldAmount" Caption="Sold Amount" VisibleIndex="9" Width="80px">
                                                        <PropertiesSpinEdit Increment="0" ClientInstanceName="CINSoldAmount" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}">
                                                            
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>--%>

                                                    <%--    <dx:GridViewDataTextColumn FieldName="PropertyStatus" VisibleIndex="8"  Caption="PropertyStatus" Width="0px">   
                                                              <EditItemTemplate>
                                                                <dx:ASPxTextBox ID="txtPropertyStatus" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    ClientInstanceName="CINPropertyStatus" TextFormatString="{0}" Readonly="true">
                                                                </dx:ASPxTextBox>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataCheckColumn Caption="VAT Liable" FieldName="IsVat" Name="glpIsVat" ShowInCustomizationForm="True" VisibleIndex="9">
                                                            <PropertiesCheckEdit ClientInstanceName="CINIsVAT" >
                                                                <ClientSideEvents CheckedChanged="function(s,e){ 
                                                                    gv1.batchEditApi.EndEdit(); 
                                                                    if (s.GetChecked() == false) 
                                                                    {console.log('terence')
                                                                        gv1.batchEditApi.SetCellValue(index, 'VATCode', 'NONV');
                                                                        gv1.batchEditApi.SetCellValue(index, 'Rate', '0');
                                                                    }
                                                                    autocalculate();
                                                                    }" />
                                                            </PropertiesCheckEdit>
              
                                                        </dx:GridViewDataCheckColumn>--%>


                                                        <%--<dx:GridViewDataTextColumn FieldName="VATCode" VisibleIndex="10" Width="80px" Caption="VATCode">   
                                                              <EditItemTemplate>
                                                                  <dx:ASPxGridLookup ID="glVATCode" runat="server" DataSourceID="VatCodeLookup"  AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    KeyFieldName="TCode" ClientInstanceName="CINVATCode" TextFormatString="{0}" Width="80px" OnLoad="LookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                   <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="TCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Rate" ReadOnly="True" VisibleIndex="2" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" RowClick="function(s,e){
                                                                            console.log('rowclick');
                                                                                setTimeout(function(){
                                                                            closing = true;
                                                                            gl2.GetGridView().PerformCallback('VATCode' + '|' + CINVATCode.GetValue() + '|' + 'code');
                                                                            e.processOnServer = false;
                                                                            valchange_VAT = true
                                                                            }, 500);
                                                                          }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataSpinEditColumn FieldName="Rate" Name="Rate" VisibleIndex="11" Width="0px" ReadOnly="true">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CINOrigQty" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>



                                                        <dx:GridViewDataSpinEditColumn FieldName="OrigQty" Name="OrigQty" VisibleIndex="12" Width="0px" ReadOnly="true">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CINOrigQty" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>--%>

                                                        <%--<dx:GridViewDataCheckColumn FieldName="IsVat" Name="IsVat" ShowInCustomizationForm="True" VisibleIndex="9">
                                                            <PropertiesCheckEdit ClientInstanceName="CINIsVat" >
                                                                <ClientSideEvents ValueChanged="function(s,e){ gv1.batchEditApi.EndEdit(); autocalculate();
                                                                    }" />
                                                            </PropertiesCheckEdit>
              
                                                        </dx:GridViewDataCheckColumn>

                                                        <dx:GridViewDataTextColumn FieldName="VATRate" VisibleIndex="10" Caption="VAT Rate">   
                                                              <EditItemTemplate>
                                                                  <dx:ASPxGridLookup ID="glVATRate" runat="server" DataSourceID="VatCodeLookup"  AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    KeyFieldName="Rate" ClientInstanceName="CINVATRate" TextFormatString="{0}" Width="100px" OnLoad="LookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                   <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="TCode" ReadOnly="True" VisibleIndex="2" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Rate" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" RowClick="function(s,e){
                                                                            console.log('rowclick');
                                                                                setTimeout(function(){
                                                                            closing = true;
                                                                            gl2.GetGridView().PerformCallback('VATCode' + '|' + glVATCode.GetValue() + '|' + 'code');
                                                                            e.processOnServer = false;
                                                                            }, 500);
                                                                          }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>--%>


                                                        <%--<dx:GridViewDataTextColumn FieldName="VatRate" Name="VatRate" Caption="Vat Rate" ShowInCustomizationForm="True" VisibleIndex="11">
                                                            <EditItemTemplate>
                                                                <dx:ASPxTextBox ID="txtVatRate" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    ClientInstanceName="CINVatRate" Width="80px" ShowInCustomizationForm="True" ReadOnly="true" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}">
                                                                    
                                                                </dx:ASPxTextBox>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>--%>
   <%--                                                     
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" VisibleIndex="16">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" VisibleIndex="17">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" VisibleIndex="18">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" VisibleIndex="19">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" VisibleIndex="20">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" VisibleIndex="21">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" VisibleIndex="22">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="23">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="24">
                                                        </dx:GridViewDataTextColumn>
--%>

                                                
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="0" Width="60px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                    <Image IconID="support_info_16x16"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
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
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Loading..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="gv1">
             <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.AccountDetermination" DataObjectTypeName="Entity.AccountDetermination" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.AccountDetermination+AccountDeterminationDetail" DataObjectTypeName="Entity.AccountDetermination+AccountDeterminationDetail" DeleteMethod="DeleteAccountDeterminationDetail" InsertMethod="AddAccountDeterminationDetail" UpdateMethod="UpdateAccountDeterminationDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="Trans" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.AssetDisposal+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Accounting.AccountDeterminationDetail where Transtype is null"
         OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ItemCode,FullDesc,ShortDesc FROM Masterfile.[Item] where isnull(IsInactive,'')=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT B.ItemCode, ColorCode, ClassCode,SizeCode,UnitBase FROM Masterfile.[Item] A INNER JOIN Masterfile.[ItemDetail] B ON A.ItemCode = B.ItemCode where isnull(A.IsInactive,'')=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    


    <%------------SQL DataSource------------%>


    <%--Receiving Warehouse Code Look Up--%>
    <asp:SqlDataSource ID="ReceivingWarehouselookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode FROM Masterfile.[Warehouse] WHERE ISNULL([IsInactive],0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>


     <%--Customer Code Look Up--%>
    <asp:SqlDataSource ID="CustomerCodelookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode,Name FROM Masterfile.[BPCustomerInfo] WHERE ISNULL([IsInactive],0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>


    <%--Cost Center Look Up--%>
    <asp:SqlDataSource ID="CostCenterlookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT CostCenterCode,Description FROM Accounting.[CostCenter] WHERE ISNULL([IsInactive],0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>



    <asp:SqlDataSource ID="TransTypeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select TransType, Prompt FROM IT.MainMenu WHERE ISNULL(ModuleID,'')!='' AND ISNULL(TransType,'')!='' ORDER BY TransType"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="ModuleIDLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select ModuleID, Prompt FROM IT.MainMenu WHERE ISNULL(ModuleID,'')!='' AND ISNULL(TransType,'')!=''"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="PropertyNumberLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PropertyNumber,ItemCode FROM Accounting.[AssetInv] WHERE Status IN ('O','F')"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="AssetAcquisitionLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select Transtype,TOACode,TypeofAccount,AccountCode,Field1,Field2,Field3,Field4,Field5,Field6,Field7,Field8,Field9 from  Accounting.AccountDeterminationDetail"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>


    <asp:SqlDataSource ID="AccountCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select AccountCode,Description from Accounting.ChartOfAccount WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SubsiCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select DISTINCT SubsiCode,Description from Accounting.GLSubsiCode WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    
    <!--#endregion-->
</body>
</html>


