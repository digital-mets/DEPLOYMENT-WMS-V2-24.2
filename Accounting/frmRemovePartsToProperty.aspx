<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmRemovePartsToProperty.aspx.cs" Inherits="GWL.frmRemovePartsToProperty" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Remove Parts To Property</title>
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
           if (btnmode == "Delete") {
               cp.PerformCallback("Delete");
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
               else if (btnmode == "Assign") {
                   cp.PerformCallback("Assign");
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

           if (s.cp_generated) {
               delete (s.cp_generated);
           }

           if (s.cp_vatrate != null) {

               vatrate = s.cp_vatrate;
               delete (s.cp_vatrate);
              
               //vatdetail1 = 1 + parseFloat(vatrate);

               //alert(vatrate + "  VATRATE");

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
           itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "PropertyNumber"); //needed var for all lookups; this is where the lookups vary for
           //if (e.visibleIndex < 0) {//new row
           //    var linenumber = s.GetColumnByField("LineNumber");
           //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
           //}

           var entry = getParameterByName('entry');
           if (entry == "V") {
               e.cancel = true; //this will made the gridview readonly
           }

           if (entry != "V") {
               if (e.focusedColumn.fieldName === "PropertyNumber") { //Check the column name
                   gl.GetInputElement().value = cellInfo.value; //Gets the column value
                   isSetTextRequired = true;
                   index = e.visibleIndex;
                   closing = true;
               }
               if (e.focusedColumn.fieldName === "ItemCode") {
                   CINItemCode.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "Description") {
                   CINDescription.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "ColorCode") {
                   CINColorCode.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "ClassCode") {
                   CINClassCode.GetInputElement().value = cellInfo.value;
               }
               if (e.focusedColumn.fieldName === "SizeCode") {
                   CINSizeCode.GetInputElement().value = cellInfo.value;
               }
           }
       }


       //Kapag umalis ka sa field na yun. hindi mawawala yung value.
       function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
           var cellInfo = e.rowValues[currentColumn.index];
           if (currentColumn.fieldName === "PropertyNumber") {
               cellInfo.value = gl.GetValue();
               cellInfo.text = gl.GetText();
               valchange = true;
           }
           if (currentColumn.fieldName === "ItemCode") {
               cellInfo.value = CINItemCode.GetValue();
               cellInfo.text = CINItemCode.GetText();
           }
           if (currentColumn.fieldName === "Description") {
               cellInfo.value = CINDescription.GetValue();
               cellInfo.text = CINDescription.GetText();
           }
           if (currentColumn.fieldName === "ColorCode") {
               cellInfo.value = CINColorCode.GetValue();
               cellInfo.text = CINColorCode.GetText();
           } 
           if (currentColumn.fieldName === "ClassCode") {
               cellInfo.value = CINClassCode.GetValue();
               cellInfo.text = CINClassCode.GetText();
           }
           if (currentColumn.fieldName === "SizeCode") {
               cellInfo.value = CINSizeCode.GetValue();
               cellInfo.text = CINSizeCode.GetText();
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
               val = ";;;;;";
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
           if (selectedIndex == 0) {
               if (column.fieldName == "ItemCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
               }
               if (column.fieldName == "Description") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
               }
               if (column.fieldName == "ColorCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
               }
               if (column.fieldName == "ClassCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
               }
               if (column.fieldName == "SizeCode") {
                   s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
               }
           }
       }

       function GridEnd(s, e) {
           val = s.GetGridView().cp_codes;
           temp = val.split(';');
           if (closing == true) {
               for (var i = 0; i > -gv1.GetVisibleRowsOnPage() ; i--) {
                   gv1.batchEditApi.ValidateRow(-1);
                   gv1.batchEditApi.StartEdit(i, gv1.GetColumnByField("ItemCode").index);
                   console.log(temp)
               }
               gv1.batchEditApi.EndEdit();
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
       //function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
       //    for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
       //        var column = s.GetColumn(i);
       //        if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(5) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
       //            var cellValidationInfo = e.validationInfo[column.index];
       //            if (!cellValidationInfo) continue;
       //            var value = cellValidationInfo.value;
       //            if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
       //                cellValidationInfo.isValid = false;
       //                cellValidationInfo.errorText = column.fieldName + " is required";
       //                isValid = false;
       //            }
       //            else {
       //                isValid = true;
       //            }
       //        }
       //    }
       //}

       function OnCustomClick(s, e) {
           //if (e.buttonID == "Details") {
           //    var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "PropertyNumber");
           //    var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
           //    var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
           //    var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
           //    var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "UnitBase");
           //    factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
           //    + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&unitbase=' + unitbase);
           //}

           if (e.buttonID == "Delete") {
               gv1.DeleteRow(e.visibleIndex);
           }
       }


       function autocalculate(s, e) {
           OnInitTrans();

           var qty = 0.00;
           var unitprice = 0.00;
           var unitcost = 0.00;
           var depreciation = 0.00;
           var soldamount = 0.00;
           var costamount = 0.00;
           var depreciationsmount = 0.00;

           var qtyVAT = 0.00;
           var unitpriceVAT = 0.00;
           var soldamountVAT = 0.00;
           var qtyNVAT = 0.00;
           var unitpriceNVAT = 0.00;
           var soldamountNVAT = 0.00;
           var totalamountsoldNVAT = 0.00;

           var totalamountsold = 0.00;
           var totalcostasset = 0.00;
           var totalaccumulateddepreciation = 0.00;
           var netbookvalue = 0.00;
           var totalgainloss = 0.00;
           var grossnonvatableamount = 0.00;
           var grossvatableamount = 0.00;


           setTimeout(function () { //New Rows
               var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                   for (var i = 0; i < indicies.length; i++)
                   {
                       if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                           qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                           unitprice = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
                           unitcost = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                           depreciation = gv1.batchEditApi.GetCellValue(indicies[i], "AccumulatedDepreciation");
                           


                           soldamount = qty * unitprice;
                           costamount = qty * unitcost;
                           depreciationsmount = depreciation * 1;
                           totalamountsold += soldamount;
                           totalcostasset += costamount;
                           totalaccumulateddepreciation += depreciationsmount;
                           netbookvalue = totalcostasset - totalaccumulateddepreciation;
                           totalgainloss = netbookvalue - totalamountsold;

                           var cb = gv1.batchEditApi.GetCellValue(indicies[i], "IsVat");

                           if (cb == true)
                           {

                               console.log("checkpasok");
                               qtyVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                               unitpriceVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");

                               soldamountVAT = qtyVAT * unitpriceVAT;

                               grossvatableamount += soldamountVAT * vatrate;
                           }
                           else
                           {

                               console.log("unchekpasok");
                               qtyNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                               unitpriceNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");

                               soldamountNVAT += qtyNVAT * unitpriceNVAT;
                               totalamountsoldNVAT += soldamountNVAT

                           }

                           gv1.batchEditApi.SetCellValue(indicies[i], "SoldAmount", soldamount.toFixed(2));

                       } //END OF IsNewRow indicies


                       else { //Existing Rows
                           var key = gv1.GetRowKey(indicies[i]);
                           if (gv1.batchEditApi.IsDeletedRow(key))
                               console.log("deleted row " + indicies[i]);
                           else {
                               qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                               unitprice = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
                               unitcost = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                               depreciation = gv1.batchEditApi.GetCellValue(indicies[i], "AccumulatedDepreciation");


                               soldamount = qty * unitprice;
                               costamount = qty * unitcost;
                               depreciationsmount = depreciation * 1;
                               totalamountsold += soldamount;
                               totalcostasset += costamount;
                               totalaccumulateddepreciation += depreciationsmount;
                               netbookvalue = totalcostasset - totalaccumulateddepreciation;
                               totalgainloss = netbookvalue - totalamountsold;

                               var cb = gv1.batchEditApi.GetCellValue(indicies[i], "IsVat")
                               
                               if (cb == true) {
                                   qtyVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                                   unitpriceVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");

                                   soldamountVAT = qtyVAT * unitpriceVAT;

                                   grossvatableamount += soldamountVAT * vatrate;
                               }
                               else {
                                   qtyNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                                   unitpriceNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");

                                   soldamountNVAT = qtyNVAT * unitpriceNVAT;
                                   totalamountsoldNVAT += soldamountNVAT

                                   
                               }
                               gv1.batchEditApi.SetCellValue(indicies[i], "SoldAmount", soldamount.toFixed(2));
                           }


                       } // END OF ELSE EXISTING ROWS

                   } //END OF FOR LOOP (indicies)
               
                   CINTotalAmountSold.SetText(totalamountsold.toFixed(2));
                   CINTotalCostAsset.SetText(totalcostasset.toFixed(2));
                   CINTotalAccumulatedDepreciationRecord.SetText(totalaccumulateddepreciation.toFixed(2));
                   CINNetBookValue.SetText(netbookvalue.toFixed(2));
                   CINTotalGainLoss.SetText(totalgainloss.toFixed(2));
                   CINTotalNonGrossVatableAmount.SetText(totalamountsoldNVAT.toFixed(2));
                   CINTotalGrossVatableAmount.SetText(grossvatableamount.toFixed(2));
                   //console.log(CINTotalAmountSold.GetValue() + " FINAL TotalAmountSold")
                   //console.log(CINSoldAmount.GetValue() + "  FINAL")
                   //console.log(CINTotalCostAsset.GetValue() + "  FINAL TotalCostAsset")


           }, 500);
       }


       function textchanged(s, e)
       {
           if(CINDisposalType.GetValue() == "Sales")
           {
               CINSoldTo.SetEnabled(true);
           }

           else
           {
               CINSoldTo.SetEnabled(false);
               CINSoldTo.SetText("");
           }
       }

       function Generate(s, e) {
           var generate = confirm("Are you sure you want to generate details?");
           if (generate) {
               gv1.CancelEdit();
               cp.PerformCallback('Generate');
               e.processOnServer = false;
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
                                <dx:ASPxLabel runat="server" Text="Remove Parts To Property" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="910px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -3px">
                         <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                       
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>

                                            <dx:LayoutItem Caption="Property Number" Name="PropertyNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPropertyNumber" runat="server" Width="170px" Readonly="true">
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

                                            <dx:LayoutItem Caption="Color Code" Name="ColorCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtColorCode" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                            
                                            <dx:LayoutItem Caption="ItemCode" Name="ItemCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtItemCode" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Class Code" Name="ClassCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtClassCode" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Description" Name="Description">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="memodescription" runat="server" Width="500px" Height="150" ReadOnly="true">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem> 
                                                    
                                            <dx:LayoutItem Caption="Size Code" Name="SizeCode">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        
                                                        <table>
                                                            <tr>
                                                                <dx:ASPxTextBox ID="txtSizeCode" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </tr>  
                                                            <tr>   
                                                                <dx:ASPxLabel ID="lblSpace" runat="server" Text="" Height="30px">
                                                                </dx:ASPxLabel>
                                                            </tr> 
                                                            <tr>
                                                                <dx:ASPxButton ID="Generatebtn" runat="server" Width="164px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" ClientVisible="true" Text="Generate" Theme="MetropolisBlue" ToolTip="hahaha">
                                                                    <ClientSideEvents Click="Generate" />
                                                                </dx:ASPxButton>
                                                                
                                                            </tr>
                                                        </table>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>         

                                        </Items>
                                    </dx:LayoutGroup>

                                </Items>
                            </dx:TabbedLayoutGroup>
                            
                            <dx:LayoutGroup Caption="Asset Property Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="850px" 
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnCustomButtonInitialize="gv1_CustomButtonInitialize" SettingsBehavior-AllowSort="False">
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                        BatchEditStartEditing="OnStartEditing"  BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick"/>
                                                    <SettingsPager Mode="ShowAllRecords"/> 
                                                            <SettingsEditing Mode="Batch" />


                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300" ShowFooter="True" ShowStatusBar="Hidden"/> 
                                                    
                                                        
                                                    <Columns>
                                                        
                                                        <dx:GridViewDataTextColumn FieldName="PropertyNumber" Caption="PropertyNumber" ReadOnly="true" VisibleIndex="2" Width="200px" >
                                                        <PropertiesTextEdit ClientInstanceName="CINPropertyNumber"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <%--ValueChanged="function (s, e){ cp.PerformCallback('PropertyInformation');  e.processOnServer = false;}"--%>

                                                   
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" Caption="ItemCode" ReadOnly="true" VisibleIndex="3" Width="200px" >
                                                        <PropertiesTextEdit ClientInstanceName="CINItemCode"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="Description" Caption="Description" ReadOnly="true" VisibleIndex="4" Width="250px" >
                                                        <PropertiesTextEdit ClientInstanceName="CINDescription"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" Caption="ColorCode" ReadOnly="true" VisibleIndex="5" Width="200" >
                                                        <PropertiesTextEdit ClientInstanceName="CINColorCode"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" Caption="ClassCode" ReadOnly="true" VisibleIndex="6" Width="150px" >
                                                        <PropertiesTextEdit ClientInstanceName="CINClassCode"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Caption="SizeCode" ReadOnly="true" VisibleIndex="7" Width="150px" >
                                                        <PropertiesTextEdit ClientInstanceName="CINSizeCode"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>


                                                
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="50px">
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
                             </dx:ASPxButton></td>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                             <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                             </dx:ASPxButton></td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.AddPartsToProperty" DataObjectTypeName="Entity.AddPartsToProperty" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="PropertyNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.RemovePartsToProperty+RemovePartsToPropertyDetail" DataObjectTypeName="Entity.RemovePartsToProperty+RemovePartsToPropertyDetail" DeleteMethod="DeleteRemovePartsToPropertyDetail" InsertMethod="AddRemovePartsToPropertyDetail" UpdateMethod="UpdateRemovePartsToPropertyDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="PropertyNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Accounting.AssetInv where PropertyNumber  is null"
         OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item] where isnull(IsInactive,'')=0"
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



    <asp:SqlDataSource ID="SoldToLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode,Name FROM Masterfile.[BPCustomerInfo] WHERE ISNULL([IsInactive],0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="PropertyNumberLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PropertyNumber,ItemCode FROM Accounting.[AssetInv] WHERE Status='F' AND ParentProperty IS NULL"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="RemovePartsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select PropertyNumber, ItemCode, Description, ColorCode, ClassCode, SizeCode FROM Accounting.AssetInv"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    
    <!--#endregion-->
</body>
</html>


