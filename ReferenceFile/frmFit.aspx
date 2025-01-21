<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmFit.aspx.cs" Inherits="GWL.frmFit" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>



<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title></title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
#form1 {
height: 300px; /*Change this whenever needed*/
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
               cp.PerformCallback("Delete");
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
               delete (cp_delete);
               DeleteControl.Show();
           }

       }


       var index;
       var closing;
       var valchange;
       var embro;
       var printcode;
       var inkcode;
       var fitcolorcode;
       var pomcode;
       var itemcategorycodestyle
       var productcategorycodestyle
       var itemc; //variable required for lookup
       var currentColumn = null;
       var valchange_EMBROCODE = false;
       var gridendchecker = false;
       var isSetTextRequired = false;
       var linecount = 1;
       var VATCode = "";
       var foclum;

       function OnStartEditing(s, e) {//On start edit grid function     
           currentColumn = e.focusedColumn;
           var cellInfo = e.rowValues[e.focusedColumn.index];
           itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCategoryCode"); //needed var for all lookups; this is where the lookups vary for
           pomcode = s.batchEditApi.GetCellValue(e.visibleIndex, "Code");
           foclum = e.focusedColumn.fieldName;

           index = e.visibleIndex;
           //if (e.visibleIndex < 0) {//new row
           //    var linenumber = s.GetColumnByField("LineNumber");
           //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
           //}
           if (entry == "V" || entry == "D" ) {
               e.cancel = true; //this will made the gridview readonly
           }
           if (e.focusedColumn.fieldName === "ItemCategoryCode") { //Check the column name
               gl.GetInputElement().value = cellInfo.value; //Gets the column value
               isSetTextRequired = true;
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

           if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsMajor") === null) {
               s.batchEditApi.SetCellValue(e.visibleIndex, "IsMajor", false)
           }
           if (e.focusedColumn.fieldName === "Code") {
               CINPOMCode.GetInputElement().value = cellInfo.value;
           }
           //if (entry == "E") {
           //    if (isNaN(e.focusedColumn.fieldName)) {
           //        e.cancel = true;
           //    }
           //    console.log(e.focusedColumn.fieldName);

           //}
           //if (e.focusedColumn.fieldName === "SizeCode" )
           //{
           //    e.cancel = true;
           //}
       
       }

       function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
           var cellInfo = e.rowValues[currentColumn.index];
           if (currentColumn.fieldName === "ItemCategoryCode") {
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
           if (currentColumn.fieldName === "Code") {
               cellInfo.value = CINPOMCode.GetValue();
               cellInfo.text = CINPOMCode.GetText();
           }
       }
       var identifier;
       var val_EMBROCODE;
       var val_ALL;
       
       function GridEndChoice(s, e) {

           identifier = s.GetGridView().cp_identifier;

           val_EMBROCODE = s.GetGridView().cp_codes;
           val_ALL = s.GetGridView().cp_codes;

           console.log(val_ALL);

           if (identifier == "POMCode") {
               delete (s.GetGridView().cp_identifier);
               if (valchange_EMBROCODE) {
                   valchange_EMBROCODE = false;
                   for (var i = 0; i < CINSizeDetail1.GetColumnsCount() ; i++) {
                       var column = CINSizeDetail1.GetColumn(i);
                       if (column.visible == false || column.fieldName == undefined)
                           continue;
                       ProcessCells_POMCODE(0, e.visibleIndex, column, CINSizeDetail1);
                   }
               }
               CINSizeDetail1.batchEditApi.EndEdit();
           }
       }
       function ProcessCells_POMCODE(selectedIndex, focused, column, s) {
           var temp_ALL;
           if (val_EMBROCODE == null) {
               val_EMBROCODE = ";;";
           }
           temp_ALL = val_ALL.split(';');
           if (temp_ALL[0] == null) {
               temp_ALL[0] = "";
           }

           if (selectedIndex == 0) {
               if (column.fieldName == "PointofMeasurement") {

                   s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[0]);
               }
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
           /*for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
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
           }*/
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

           if (e.buttonID == "MeasurementChartDelete") {
               CINSizeDetail1.DeleteRow(e.visibleIndex);
           }

       }
       function computesizesvalue(s, e) {

           var tolerance = 0.00;
           var grade = 0.00;
           var base = CINBaseSize.GetValue();
           var value = 0.00;
           var tot = 0.00;
           var mainbracket = 0;
           var indexbackward = 0;
           var basevalue = 0.00;
           var bracketcounter = 0;    // Reset Bracket Counter Every Row.

           setTimeout(function () {
               if (foclum == base) {
                   console.log(index);
                   grade = CINSizeDetail1.batchEditApi.GetCellValue(index, "Grade");
                   if (!grade)
                       grade = 0.00;
                   mainbracket = CINSizeDetail1.batchEditApi.GetCellValue(index, "Bracket");
                   basevalue = CINSizeDetail1.batchEditApi.GetCellValue(index, base);
                   // Increment Part
                   basevalue += parseFloat(grade);
                   for (var j = 10; j < CINSizeDetail1.GetColumnsCount() ; j++) {
                       var column = CINSizeDetail1.GetColumn(j);
                       if (column.fieldName > base) {
                           CINSizeDetail1.batchEditApi.SetCellValue(index, column.fieldName, basevalue); // WORKING
                           bracketcounter++;
                           if (bracketcounter == mainbracket) {
                               bracketcounter = 0;
                               basevalue += parseFloat(grade);
                           }
                       }
                   }

                   // Decrement Part
                   // reset bracket / index / basevalue 
                   bracketcounter = mainbracket;
                   indexbackward = CINSizeDetail1.GetColumnByField(base).index;
                   basevalue = CINSizeDetail1.batchEditApi.GetCellValue(index, base);
                   for (var g = indexbackward; g > 6 ; g--) {
                       var column = CINSizeDetail1.GetColumn(g);
                       if (column.fieldName <= base) {
                           CINSizeDetail1.batchEditApi.SetCellValue(index, column.fieldName, basevalue); // WORKING
                           bracketcounter--;
                           if (bracketcounter == 0) {
                               bracketcounter = mainbracket;
                               basevalue -= grade;
                           }
                       } // END OF for (var g = indexbackward; g > 6 ; g--)
                   }
               }
           }, 500);
       }


       function resetsizesvalue(s, e) {

           var tolerance = 0.00;
           var grade = 0.00;
           var base = CINBaseSize.GetText();
           console.log(base + 'base');
           var value = 0.00;
           var tot = 0.00;
           var mainbracket = 0;
           var indexbackward = 0;
           var basevalue = 0.00;

           setTimeout(function () { //New Rows
               var indicies = CINSizeDetail1.batchEditApi.GetRowVisibleIndices();
                   for (var i = 0; i < indicies.length; i++) {
                       var bracketcounter = 0;
                       if (CINSizeDetail1.batchEditApi.IsNewRow(indicies[i])) {
                           for (var j = 10; j < CINSizeDetail1.GetColumnsCount() ; j++) {
                               var column = CINSizeDetail1.GetColumn(j);
                               ///stringcolumn = "" + column.fieldName;
                               console.log(column.fieldName)
                               if (column.fieldName > base) {
                                   CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, null); // WORKING
                                   bracketcounter++;
                                   if (bracketcounter == mainbracket) {
                                       bracketcounter = 0;
                                       basevalue += grade;
                                   }
                               }
                           }
                           // reset bracket / index / basevalue 
                           bracketcounter = mainbracket;
                           indexbackward = CINSizeDetail1.GetColumnByField(base).index;
                           for (var g = indexbackward; g > 6 ; g--) {
                               var column = CINSizeDetail1.GetColumn(g);
                               if (column.fieldName <= base) {
                                   CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, null); // WORKING
                                   bracketcounter--;
                                   if (bracketcounter == 0) {
                                       bracketcounter = mainbracket;
                                       basevalue -= grade;
                                   }
                               }
                           }
                       } //END OF IsNewRow indicies


                       else { //Existing Rows
                           var key = CINSizeDetail1.GetRowKey(indicies[i]);
                           if (CINSizeDetail1.batchEditApi.IsDeletedRow(key))
                               console.log("deleted row " + indicies[i]);
                           else {
                               for (var j = 10; j < CINSizeDetail1.GetColumnsCount() ; j++) {
                                   var column = CINSizeDetail1.GetColumn(j);
                                   ///stringcolumn = "" + column.fieldName;
                                   console.log(column.fieldName)
                                   if (column.fieldName > base) {
                                       CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, null); // WORKING
                                       bracketcounter++;
                                       if (bracketcounter == mainbracket) {
                                           bracketcounter = 0;
                                           basevalue += grade;
                                       }
                                   }
                               }
                               // reset bracket / index / basevalue 
                               bracketcounter = mainbracket;
                               indexbackward = CINSizeDetail1.GetColumnByField(base).index;
                               for (var g = indexbackward; g > 6 ; g--) {
                                   var column = CINSizeDetail1.GetColumn(g);
                                   if (column.fieldName <= base) {
                                       CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], column.fieldName, null); // WORKING
                                       bracketcounter--;
                                       if (bracketcounter == 0) {
                                           bracketcounter = mainbracket;
                                           basevalue -= grade;
                                       }
                                   }
                               }
                           }
                       } // END OF ELSE EXISTING ROWS
                   } //END OF FOR LOOP (indicies)
           }, 500);
       }
       function autoTolerance(s, e) {

           var tolerance = 0.00;
           var grade = 0.00;
           var base = CINBaseSize.GetText();
           setTimeout(function () { //New Rows
               var indicies = CINSizeDetail1.batchEditApi.GetRowVisibleIndices();

               for (var i = 0; i < indicies.length; i++) {
                   if (CINSizeDetail1.batchEditApi.IsNewRow(indicies[i])) {
                       grade = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], "Grade");
                       console.log(CINSizeDetail1.GetColumnByField(base).index + ' testing');
                       console.log(CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], 11) + '  visible');
                       tolerance = grade / 2;

                       CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], "Tolerance", tolerance.toFixed(2));

                   } //END OF IsNewRow indicies


                   else { //Existing Rows
                       var key = CINSizeDetail1.GetRowKey(indicies[i]);
                       if (CINSizeDetail1.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + indicies[i]);
                       else {
                           grade = CINSizeDetail1.batchEditApi.GetCellValue(indicies[i], "Grade");



                           tolerance = grade / 2;

                           CINSizeDetail1.batchEditApi.SetCellValue(indicies[i], "Tolerance", tolerance.toFixed(2));
                       }
                   } // END OF ELSE EXISTING ROWS
               } //END OF FOR LOOP (indicies)
           }, 500);
       }
       function typechanged(s, e) {
           var prod = gvProdCat.GetText();
           //console.log(type);
           if (prod == "T" || "B") {
               gvWaist.SetText = "";
               gvSilhouette.SetText = "";
               gvWaist.SetEnabled(true);
               gvSilhouette.SetEnabled(true);
               //glRef.SetValue(null);

           }
           else {
               gvWaist.SetEnabled(false);
               gvSilhouette.SetEnabled(false);
               gvWaist.SetText = "";
               gvSilhouette.SetText = "";
           }
       }
       function OnInitTrans(s, e) {
           AdjustSize();
           isValid = true;
       }

       function OnControlsInitialized(s, e) {
           ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
               AdjustSize();
           });
       }

       function AdjustSize() {
           var width = Math.max(0, document.documentElement.clientWidth);
           //gv1.SetWidth(width - 120);
           CINSizeDetail1.SetWidth(width - 120);
           
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
                                <dx:ASPxLabel runat="server" Text="Fit" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
        
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="FormLayout" runat="server"  Height="558px" Width="850px" style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>

                            <dx:TabbedLayoutGroup>
                                <Items>
                                    
                                    
                                    <dx:LayoutGroup Caption="General">
                                       <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <Items>
                                            <dx:LayoutItem Caption="Brand">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvBrand" runat="server" Width="170px" OnLoad="LookupLoad" AutoGenerateColumns="True"  DataSourceID="sdsBrand" KeyFieldName="BrandCode" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                           <Settings ShowFilterRow="True" />
                                                                 </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="IsInactive">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkIsInactive" runat="server" CheckState="Unchecked" Text=" " OnLoad="CheckBoxLoad">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Gender">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvGender" runat="server" Width="170px" OnLoad="LookupLoad" AutoGenerateColumns="True"  DataSourceID="sdsGender" KeyFieldName="GenderCode" TextFormatString="{0}">
                                                                 <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            <Settings ShowFilterRow="True" />
                                                                 </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Waist/Neckline">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvWaist" runat="server" ClientInstanceName="gvWaist"  Width="170px" OnLoad="LookupLoad" AutoGenerateColumns="True"  DataSourceID="sdsWaist" KeyFieldName="Code" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Product Category">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvProdCat" runat="server" Width="170px" OnLoad="LookupLoad" ClientInstanceName="gvProdCat" AutoGenerateColumns="True"  DataSourceID="sdsProdCat" KeyFieldName="ProductCategoryCode" TextFormatString="{0}">
                                                              <ClientSideEvents  ValueChanged="function(s,e){ cp.PerformCallback('ProdCat'); e.processOnServer = false; typechanged();}" />
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Fit Type">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvFitType" runat="server" Width="170px" OnLoad="LookupLoad" AutoGenerateColumns="True"  DataSourceID="sdsFitType" KeyFieldName="FitTypeCode" TextFormatString="{0}">
                                                        <GridViewProperties>
                                                         <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                                           <Settings ShowFilterRow="True" />
                                                             </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtFitCode" runat="server" Width="170px" OnLoad="TextboxLoad" >
                                                         <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Silhouette/SleeveLength">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvSilhouette" runat="server" Width="170px" OnLoad="LookupLoad" ClientInstanceName="gvSilhouette" AutoGenerateColumns="True"  DataSourceID="sdsSilhouette" KeyFieldName="Code" TextFormatString="{0}">
                                                                <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                            <Settings ShowFilterRow="True" />
                                                                </GridViewProperties>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Fit Name">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtName" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                           <ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Master Pattern">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPattern" runat="server" Width="170px"  OnLoad="TextboxLoad" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Remarks" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" >
                                                        <dx:ASPxMemo ID="txtRemarks" runat="server" Width="170px" Length="500" Heighet="200px">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>

                                     <dx:LayoutGroup Caption="Size List" ColCount="2" Width="100%">
                                        <Items>
                                            <dx:LayoutItem Caption="Size Template" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvSizeTemp" runat="server" Width="170px" OnLoad="LookupLoad" AutoGenerateColumns="True"  DataSourceID="sdsSizeTemp" KeyFieldName="SizeTemplateCode" TextFormatString="{0}">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                             <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('fitcodecase'); e.processOnServer = false; typechanged();}"/>
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
                                            <dx:LayoutItem Caption="Size Card" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSizeCard" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                                 </dx:LayoutItem>
                                            

                                             <dx:LayoutGroup Caption="Sizes" Height="190px" Width="50%">
                                                 <Items>
                                                     <dx:LayoutItem Caption="" ShowCaption="False">
                                                         <LayoutItemNestedControlCollection>
                                                             <dx:LayoutItemNestedControlContainer runat="server">
                                                                 <table>
                                                                     <tr>
                                                                         <td>
                                                                             <dx:ASPxTextBox ID="txtBaseSize" runat="server" Caption="Base Size" ClientInstanceName="CINBaseSize" Width="100px">
                                                                             </dx:ASPxTextBox>
                                                                         </td>
                                                                         <td>
                                                                             <dx:ASPxLabel runat="server" Width="3px">
                                                                             </dx:ASPxLabel>
                                                                         </td>
                                                                         <td>
                                                                             <dx:ASPxButton ID="btnSet" runat="server" AutoPostBack="False" CausesValidation="False" ClientInstanceName="CINSet" Text="Set" Theme="MetropolisBlue" UseSubmitBehavior="False" Width="100px">
                                                                                 <ClientSideEvents Click="function(s,e){ cp.PerformCallback('setcase'); e.processOnServer = false; typechanged(); }" />
                                                                             </dx:ASPxButton>
                                                                         </td>
                                                                         <td>
                                                                             <dx:ASPxLabel runat="server" Width="3px">
                                                                             </dx:ASPxLabel>
                                                                         </td>
                                                                         <td>
                                                                             <dx:ASPxButton ID="btnRefreshGrid" runat="server" AutoPostBack="False" CausesValidation="False" ClientInstanceName="CINRefreshGrid" Text="Refresh Grid" Theme="MetropolisBlue" UseSubmitBehavior="False" Width="150px">
                                                                                <ClientSideEvents Click="resetsizesvalue" />
                                                                             </dx:ASPxButton>
                                                                         </td>
                                                                     </tr>
                                                                 </table>
                                                             </dx:LayoutItemNestedControlContainer>
                                                         </LayoutItemNestedControlCollection>
                                                     </dx:LayoutItem>
                                                 </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Sizes Detail" Width="50%">
                                                <Items>
                                                    <dx:LayoutItem Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvSizeDetail2" runat="server" AutoGenerateColumns="False" DataSourceID ="sdsDetail" ClientInstanceName="CINgvSizeDetail2" KeyFieldName="SizeCode" OnCommandButtonInitialize="gv_CommandButtonInitialize"   OnBatchUpdate="gv1_BatchUpdate" OnRowDataBound="" Width="100%">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                                    <SettingsPager Mode="ShowAllRecords">
                                                                    </SettingsPager>
                                                                    <SettingsEditing Mode="Batch">
                                                                    </SettingsEditing>
                                                                    <Settings  VerticalScrollableHeight="103" VerticalScrollBarMode="Auto" />
                                                                    <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                    <Columns>
                                                                         <dx:GridViewDataTextColumn FieldName="FitCode" ShowInCustomizationForm="True" Visible="false" Width="0px" VisibleIndex="0">
                                                                    </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="SizeCode" FieldName="SizeCode" Name="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="SizeName" FieldName="SizeName" Name="SizeName" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Inseam/Length" FieldName="Length" Name="Length" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn Caption="Sort#" FieldName="SortNumber" Name="SortNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
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
                                           
                                            <dx:LayoutGroup Caption="Measurement Chart" Width="100%"> 
                                                <Items>
                                                   
                                                            <dx:LayoutItem Caption="">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxGridView ID="gvSizeDetail1" runat="server" KeyFieldName="Order" AutoGenerateColumns="False" DataSourceID ="sdsDetail2" ClientInstanceName="CINSizeDetail1" OnBatchUpdate="gvSizeDetail1_BatchUpdate" OnCommandButtonInitialize="gv_CommandButtonInitialize1">
                                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm"  BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating" BatchEditStartEditing="OnStartEditing"  CustomButtonClick="OnCustomClick" Init="OnInitTrans" />
                                                                            <SettingsPager Mode="ShowAllRecords">
                                                                            </SettingsPager>
                                                                            <SettingsEditing Mode="Batch">
                                                                            </SettingsEditing>
                                                                            <Settings HorizontalScrollBarMode="Auto" VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" />
                                                                            <SettingsBehavior AllowSort="False" ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                            
                                                                            <ClientSideEvents Init="OnInitTrans" />
                                                                            <SettingsCommandButton>
                                                                                <NewButton Image-IconID="actions_addfile_16x16"></NewButton>
                                                                            </SettingsCommandButton>
                                                                             <Columns>
                                                                                 <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="60px" ShowNewButtonInHeader="true">
                                                                                    <CustomButtons>
                                                                                        <dx:GridViewCommandColumnCustomButton ID="MeasurementChartDelete">
                                                                                        <Image IconID="actions_cancel_16x16">
                                                                                        </Image>
                                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                                    </CustomButtons>
                                                                                     
                                                                                </dx:GridViewCommandColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="LineNumber" Name="LineNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="1">
                                                                                </dx:GridViewDataTextColumn>
                                                                                <dx:GridViewDataTextColumn FieldName="FitCode" Name="FitCode" ShowInCustomizationForm="True" Visible="False" VisibleIndex="2">
                                                                                </dx:GridViewDataTextColumn>
                                                                               
                                                                                <dx:GridViewDataTextColumn Caption="Order" FieldName="Order" Name="PrintPart" ShowInCustomizationForm="True" VisibleIndex="3" Width="50px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                 <dx:GridViewDataCheckColumn FieldName="IsMajor" Name="IsMajor" Caption="!"  ShowInCustomizationForm="True" VisibleIndex="4" Width="50">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                                <PropertiesCheckEdit ClientInstanceName="CINIsMajor"></PropertiesCheckEdit>
                                                                            </dx:GridViewDataCheckColumn>
                                                                                 <dx:GridViewDataTextColumn FieldName="Code" VisibleIndex="5" Width="100px" Name="Code" Caption="Code">
                                                                                <EditItemTemplate>
                                                                                    <dx:ASPxGridLookup ID="glPOMCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                        KeyFieldName="POMCode" DataSourceID="sdsPOM" ClientInstanceName="CINPOMCode" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad" OnInit="glPOMCode_Init" >
                                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                                        </GridViewProperties>
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="POMCode" ReadOnly="True" VisibleIndex="0">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                                            </dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                        <ClientSideEvents EndCallback="GridEndChoice" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" 
                                                                                                ValueChanged="function(s,e){
                                                                                                if(pomcode != CINPOMCode.GetValue()){
                                                                                                closing = true;
                                                                                                CINPOMCode.GetGridView().PerformCallback('POMCode' + '|' + CINPOMCode.GetValue() + '|' + 's.GetInputElement().value');
                                                                                                e.processOnServer = false;
                                                                                                valchange_EMBROCODE = true
                                                                                                }
                                                                                                }" />
                                                                                    </dx:ASPxGridLookup>
                                                                                </EditItemTemplate>
                                                                                        </dx:GridViewDataTextColumn>
                                                                                           
                                                                                 <dx:GridViewDataTextColumn Caption="Point Of Measurement" FieldName="PointofMeasurement" Name="PrintDescription"  ShowInCustomizationForm="True" VisibleIndex="6" Width="250px">
                                                                                </dx:GridViewDataTextColumn>
                                                                                
                                                                                
                                                                                <dx:GridViewDataSpinEditColumn Caption="Grade" FieldName="Grade" Name="Grade" ShowInCustomizationForm="True" VisibleIndex="7" Width="50px">
                                                                                    <PropertiesSpinEdit ClientInstanceName="CINGrade" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0" NullText="0" NumberFormat="Custom" Width="50px">
                                                                                        <SpinButtons ShowIncrementButtons="False">
                                                                                        </SpinButtons>
                                                                                        <ClientSideEvents NumberChanged="autoTolerance" />
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataSpinEditColumn Caption="Bracket" FieldName="Bracket" Name="Bracket" ShowInCustomizationForm="True" VisibleIndex="8" Width="50px">
                                                                                    <PropertiesSpinEdit ClientInstanceName="CINBracket" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N0}" NullDisplayText="0" NullText="0" NumberFormat="Custom" Width="50px">
                                                                                        <SpinButtons ShowIncrementButtons="False">
                                                                                        </SpinButtons>
                                                                                    </PropertiesSpinEdit>
                                                                                </dx:GridViewDataSpinEditColumn>
                                                                                <dx:GridViewDataTextColumn Caption="+/- Tol" FieldName="Tolerance" Name="Location" ShowInCustomizationForm="True" VisibleIndex="9" Width="50px">
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
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
            <%--<ClientSideEvents CustomButtonClick="OnCustomClick" />--%>
                <dx:ASPxPanel id="BottomPanel" runat="server" fixedposition="WindowBottom" backcolor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                <dx:ASPxCheckBox style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                <dx:ASPxButton ID="updateBtn" runat="server" Text="Add" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
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
            <%--                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False"
                                                            VisibleIndex="0" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Caption="Line" ReadOnly="True" Width="0px" Visible="False">
                                                        </dx:GridViewDataTextColumn>
--%>&nbsp;<asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Masterfile.FitSizeDetail where FitCode  is null " OnInit = "Connection_Init" >
    </asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsDetail2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT FitCode, POMCode, SizeCode, Value, Tolerance, Bracket, Grade, Sorting AS [Order], IsMajor, LineNumber FROM  Masterfile.MeasurementChartTemplate where FitCode  is null " OnInit = "Connection_Init" >
    </asp:SqlDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.Fit+FitSizeDetail" DataObjectTypeName="Entity.Fit+FitSizeDetail" DeleteMethod="DeleteFitSizeDetail" InsertMethod="AddFitSizeDetail" UpdateMethod="UpdateFitSizeDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="docnumber" QueryStringField="docnumber" Type="String" />
                   <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
             
             </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail2" runat="server" SelectMethod="getdetail" TypeName="Entity.Fit+MeasurementChartTemplate" DataObjectTypeName="Entity.Fit+MeasurementChartTemplate" DeleteMethod="DeleteMeasurementChartTemplate" InsertMethod="AddMeasurementChartTemplate" UpdateMethod="UpdateMeasurementChartTemplate">
        <SelectParameters>
     <asp:QueryStringParameter Name="docnumber" QueryStringField="docnumber" Type="String" />
                   <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
             
             </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsBrand" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select BrandCode,BrandName,Mnemonics from Masterfile.Brand where ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsGender" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select GenderCode,Description from Masterfile.Gender where ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsProdCat" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select ProductCategoryCode,Description,HaveSubCategory,Mnemonics,IsForForecast from Masterfile.ProductCategory where ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
     <asp:SqlDataSource ID="sdsWaist" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select WaistCode as Code,Description from Masterfile.Waist where ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
         <asp:SqlDataSource ID="sdsNeckline" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select NeckLineCode as Code,Description from Masterfile.NeckLine where ISNULL(IsInactive,0)= 0 " OnInit = "Connection_Init"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sdsFitType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select FitTypeCode,Description from Masterfile.FitType where ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sdsSilhouette" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select SilhouetteCode as Code,Description from Masterfile.Silhouette where ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
             <asp:SqlDataSource ID="sdsSleeve" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select SleeveLengthCode as Code,Description from Masterfile.SleeveLength where ISNULL(IsInactive,0)= 0" OnInit = "Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsSizeTemp" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select SizeTemplateCode,Description,SizeType from Masterfile.SizeTemplate where ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
               <asp:SqlDataSource ID="sdsPOM" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select POMCode,Description from Masterfile.POM where ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
                     <asp:SqlDataSource ID="sdsSizeCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select SizeCode,Description from Masterfile.Size where ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
                  <asp:SqlDataSource ID="sdsSizeTempDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT '' as FitCode,A.SizeCode,A.SizeName,A.Length,A.SortNumber,A.Field1,A.Field2,A.Field3,A.Field4,A.Field5,A.Field6,A.Field7,A.Field8,A.Field9, A.SizeTemplateCode FROM Masterfile.SizeTemplateDetail A  INNER JOIN Masterfile.SizeTemplate B ON A.SizeTemplateCode = B.SizeTemplateCode where ISNULL(IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
        
                <asp:SqlDataSource ID="SizeDetail2DataSource" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select '' as FitCode,SizeCode, SizeName, Length AS Length, SortNumber from masterfile.SizeTemplate"
                 OnInit = "Connection_Init">
                 </asp:SqlDataSource>
            
    </form>

     <!--#endregion-->
</body>
</html>


