<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmAssetDepreciationSetup.aspx.cs" Inherits="GWL.frmAssetDepreciationSetup" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Asset Depreciation Setup</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>

     <!--#region Region Javascript-->


        <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
#form1 {
height: 620px; /*Change this whenever needed*/
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

       var event;
       var copyFlag;
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

           e.cancel = true;

       }


       //Kapag umalis ka sa field na yun. hindi mawawala yung value.
       function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
           var cellInfo = e.rowValues[currentColumn.index];
           //if (currentColumn.fieldName === "PropertyNumber") {
           //    cellInfo.value = gl.GetValue();
           //    cellInfo.text = gl.GetText();
           //    valchange = true;
           //}
           //if (currentColumn.fieldName === "ColorCode") {
           //    cellInfo.value = gl2.GetValue();
           //    cellInfo.text = gl2.GetText();
           //}
           //if (currentColumn.fieldName === "ClassCode") {
           //    cellInfo.value = gl3.GetValue();
           //    cellInfo.text = gl3.GetText();
           //}
           //if (currentColumn.fieldName === "Qty") {
           //    cellInfo.value = CINQty.GetValue();
           //    cellInfo.text = CINQty.GetText();
           //} 
           //if (currentColumn.fieldName === "UnitCost") {
           //    cellInfo.value = CINUnitCost.GetValue();
           //    cellInfo.text = CINUnitCost.GetText();
           //}
           //if (currentColumn.fieldName === "AccumulatedDepreciation") {
           //    cellInfo.value = CINAccumulatedDepreciation.GetValue();
           //    cellInfo.text = CINAccumulatedDepreciation.GetText();
           //}
           //if (currentColumn.fieldName === "IsVat") {
           //    cellInfo.value = CINIsVat.GetValue();
           //}
           //if (currentColumn.fieldName === "VatRate") {
           //    cellInfo.value = CINVatRate.GetValue();
           //    cellInfo.text = CINVatRate.GetText();
           //}

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
           //if (val == null) {
           //    val = ";;;;;;;;";
           //    temp = val.split(';');
           //}
           //if (temp[0] == null) {
           //    temp[0] = "";
           //}
           //if (temp[1] == null) {
           //    temp[1] = "";
           //}
           //if (temp[2] == null) {
           //    temp[2] = "";
           //}
           //if (temp[3] == null) {
           //    temp[3] = "";
           //}
           //if (temp[4] == null) {
           //    temp[4] = "";
           //} 
           //if (temp[5] == null) {
           //    temp[5] = "";
           //}
           //if (temp[6] == null) {
           //    temp[6] = "";
           //}
           //if (temp[7] == null) {
           //    temp[7] = "";
           //}
           //if (selectedIndex == 0) {
           //    if (column.fieldName == "ColorCode") {
           //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
           //    }
           //    if (column.fieldName == "ClassCode") {
           //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
           //    }
           //    if (column.fieldName == "SizeCode") {
           //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
           //    }
           //    if (column.fieldName == "Qty") {
           //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
           //    }
           //    if (column.fieldName == "UnitCost") {
           //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
           //    }
           //    if (column.fieldName == "AccumulatedDepreciation") {
           //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
           //    }
           //    if (column.fieldName == "IsVat") {
           //        if (temp[6] == "True") {
           //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, CINIsVat.SetChecked = true);
           //        }
           //        else {
           //            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, CINIsVat.SetChecked = false);
           //        }
           //    }
           //    if (column.fieldName == "VatRate") {
           //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[7]);
           //    }



           //  }
       }

       function GridEnd(s, e) {
           val = s.GetGridView().cp_codes;
           temp = val.split(';');
           if (closing == true) {
               for (var i = 0; i > -gv1.GetVisibleRowsOnPage() ; i--) {
                   gv1.batchEditApi.ValidateRow(-1);
                   gv1.batchEditApi.StartEdit(i, gv1.GetColumnByField("ColorCode").index);
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
               autocalculate(s, e);
           }

           if (e.buttonID == "ViewTransaction") {
               var transtype = s.batchEditApi.GetCellValue(e.visibleIndex, "TransType");
               var docnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "DocNumber");
               var commandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "CommandString");

               window.open(commandtring + '?entry=V&transtype=' + transtype + '&parameters=&iswithdetail=true&docnumber=' + docnumber, '_blank', "", false);
               console.log('ViewTransaction')
           }
           if (e.buttonID == "ViewReferenceTransaction") {

               var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
               var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
               var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
               window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
               console.log('ViewTransaction')
           }
       }
       Number.prototype.format = function (d, w, s, c) {
           var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
               num = this.toFixed(Math.max(0, ~~d));

           return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
       };


       function autocalculate(s, e) {
           OnInitTrans();
           var propertynumber = CINPropertyNumber.GetValue();

           var monthlydepreciation = CINMonthlyDepreciation.GetValue();
           var runningbookvalue = 0.00;
           var depreciatedamount = 0.00;
           var conrunningbookvalue = 0.00;
           var aclesssal = 0.00;
           var versionval = "2";
           var depreciationmethod = CINDepreciationMethod.GetText();


           var acquisitioncost = CINAcquisitionCost.GetValue();
           var salvagevalue = CINSalvageValue.GetValue();
           var life = CINLifeInMonths.GetValue();

           var bookvalue = 0.00;
           var straightlinedepreciationholder = 0.00;
           var straightlinerunningbook = 0.00;

           var x = 0;
           var y = 2;
           x = y * acquisitioncost;

           //console.log(depreciationmethod + "  depreciationmethod!!")
           //depreciatedamount = life * monthlydepreciation;
           //aclesssal = acquisitioncost - salvagevalue;
           //runningbookvalue = aclesssal - depreciatedamount;
           setTimeout(function () { //New Rows
               bookvalue = acquisitioncost - salvagevalue;
               //---------------------------------------------------------------------------------------------------//
               // Computing Depreciation Amount Using Straight Line Method
               //straightlinedepreciation = bookvalue / life;
               //console.log(toFixed2(straightlinedepreciation,2) + ' ginawa ko')
               // Computing Running Book Value Using Straight Line Method

               var straightlinedepreciation = [life];
               var straightlinerunningvalue = [life];
               for (i = 0; i < life; i++) {
                   if (i == 0) {
                       straightlinedepreciationholder = bookvalue / life;
                       straightlinedepreciation[i] = toFixed2(straightlinedepreciationholder, 2);
                       straightlinerunningvalue[i] = bookvalue - straightlinedepreciation[i];

                   }
                   else {
                       if (i == life - 1) {
                           straightlinedepreciation[i] = straightlinerunningvalue[i - 1]
                           straightlinerunningvalue[i] = straightlinerunningvalue[i - 1] - straightlinedepreciation[i];
                       }
                       else {
                           straightlinedepreciation[i] = straightlinedepreciation[i - 1]
                           straightlinerunningvalue[i] = straightlinerunningvalue[i - 1] - straightlinedepreciation[i];
                       }
                   }
               }
               // End of Running Book Value Computation
               //---------------------------------------------------------------------------------------------------//


               //---------------------------------------------------------------------------------------------------//
               // --- Computing Depreciation Amount Using Double Declining Method ---
               // --- Computing Running Book Value Using Straight Line Method -------
               var doubledecliningrunningvalue = [life];
               var doubledecliningdepreciation = [life];
               for (i = 0; i < life; i++) {
                   if (i == 0) {
                       doubledecliningdepreciation[i] = toFixed2((bookvalue / life) * 2, 2);
                       doubledecliningrunningvalue[i] = bookvalue - doubledecliningdepreciation[i]
                   }
                   else {
                       doubledecliningdepreciation[i] = toFixed2((doubledecliningrunningvalue[i - 1] / (life - i)) * 2, 2);
                       doubledecliningrunningvalue[i] = doubledecliningrunningvalue[i - 1] - doubledecliningdepreciation[i];
                   }
               }
               //---------------------------------------------------------------------------------------------------//


               //---------------------------------------------------------------------------------------------------//
               var sumofyearsrunningvalue = [life];
               var sumofyearsdepreciation = [life];
               var lifeplusone = 0;
               var lifeproduct = 0;
               var lifequotient = 0.00;
               var lifeminus = 0;
               var sy = 0.00;
               for (i = 0; i < life; i++) {
                   if (i == 0) {
                       lifeplusone = +life + 1;
                       lifeproduct = life * lifeplusone;
                       lifequotient = lifeproduct / 2;
                       sy = life / lifequotient

                       sumofyearsdepreciation[i] = bookvalue * sy;
                       sumofyearsrunningvalue[i] = bookvalue - sumofyearsdepreciation[i];

                   }
                   else {
                       lifeminus = life - i
                       sumofyearsdepreciation[i] = (lifeminus / lifequotient) * bookvalue;
                       sumofyearsrunningvalue[i] = sumofyearsrunningvalue[i - 1] - sumofyearsdepreciation[i];

                   }
               }
               //---------------------------------------------------------------------------------------------------//

               //for (i = 0; i < life; i++)
               //{

               // console.log(sumofyearsdepreciation[i] + " sumofyearsdepreciation")
               //  console.log(sumofyearsrunningvalue[i] + " sumofyearsrunningvalue")
               //}


               var indicies = gv1.batchEditApi.GetRowVisibleIndices();
               for (var i = 0; i < indicies.length; i++) {
                   life = i + 1;
                   straightlinerunningbook = bookvalue - straightlinedepreciation;


                   if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                       if (depreciationmethod == "Straight Line Method") {
                           gv1.batchEditApi.SetCellValue(indicies[i], "PropertyNumber", propertynumber);
                           gv1.batchEditApi.SetCellValue(indicies[i], "Month", i + 1);
                           gv1.batchEditApi.SetCellValue(indicies[i], "RunningBookValue", straightlinerunningvalue[i]);
                           gv1.batchEditApi.SetCellValue(indicies[i], "DepreciationAmount", straightlinedepreciation[i]);

                       }

                       else if (depreciationmethod == "Double Declining Balance Method") {
                           gv1.batchEditApi.SetCellValue(indicies[i], "PropertyNumber", propertynumber);
                           gv1.batchEditApi.SetCellValue(indicies[i], "Month", i + 1);
                           gv1.batchEditApi.SetCellValue(indicies[i], "RunningBookValue", doubledecliningrunningvalue[i]);
                           gv1.batchEditApi.SetCellValue(indicies[i], "DepreciationAmount", doubledecliningdepreciation[i]);

                       }

                       else if (depreciationmethod == "Sum of Years Digit Method") {
                           gv1.batchEditApi.SetCellValue(indicies[i], "PropertyNumber", propertynumber);
                           gv1.batchEditApi.SetCellValue(indicies[i], "Month", i + 1);
                           gv1.batchEditApi.SetCellValue(indicies[i], "RunningBookValue", sumofyearsrunningvalue[i]);
                           gv1.batchEditApi.SetCellValue(indicies[i], "DepreciationAmount", sumofyearsdepreciation[i]);

                       }

                       else
                           console.log("No Method For Computation!");

                   } //END OF IsNewRow indicies


                   else { //Existing Rows
                       var key = gv1.GetRowKey(indicies[i]);
                       if (gv1.batchEditApi.IsDeletedRow(key))
                           console.log("deleted row " + indicies[i]);
                       else {
                           console.log("Existing Rows");
                           if (depreciationmethod == "Straight Line Method") {
                               gv1.batchEditApi.SetCellValue(indicies[i], "PropertyNumber", propertynumber);
                               gv1.batchEditApi.SetCellValue(indicies[i], "Month", i + 1);
                               gv1.batchEditApi.SetCellValue(indicies[i], "RunningBookValue", straightlinerunningvalue[i]);
                               gv1.batchEditApi.SetCellValue(indicies[i], "DepreciationAmount", straightlinedepreciation);

                           }

                           else if (depreciationmethod == "Double Declining Balance Method") {
                               gv1.batchEditApi.SetCellValue(indicies[i], "PropertyNumber", propertynumber);
                               gv1.batchEditApi.SetCellValue(indicies[i], "Month", i + 1);
                               gv1.batchEditApi.SetCellValue(indicies[i], "RunningBookValue", doubledecliningrunningvalue[i]);
                               gv1.batchEditApi.SetCellValue(indicies[i], "DepreciationAmount", doubledecliningdepreciation[i]);

                           }

                           else if (depreciationmethod == "Sum of Years Digit Method") {
                               gv1.batchEditApi.SetCellValue(indicies[i], "PropertyNumber", propertynumber);
                               gv1.batchEditApi.SetCellValue(indicies[i], "Month", i + 1);
                               gv1.batchEditApi.SetCellValue(indicies[i], "RunningBookValue", sumofyearsrunningvalue[i]);
                               gv1.batchEditApi.SetCellValue(indicies[i], "DepreciationAmount", sumofyearsdepreciation[i]);

                           }

                       }


                   } // END OF ELSE EXISTING ROWS

               } //END OF FOR LOOP (indicies)

           }, 500);
       }



       function autocompute(s, e) {
           OnInitTrans();
           console.log("INIT YES!");
           var aquisitioncost = 0.00;
           var monthlydepreciation = 0.00;
           var quantity = CINQuantity.GetValue();
           var unitcost = CINUnitCost.GetValue();
           var life = CINLifeInMonths.GetValue();
           var salvagevalue = CINSalvageValue.GetValue();
           var depreciationmethod = CINDepreciationMethod.GetText();
           var bookvalue = 0.00;

           console.log(depreciationmethod + "depreciationmethod");
           //Variables For Sum Of Years
           var x = 0.00;


           setTimeout(function () { //New Rows 
               aquisitioncost = quantity * unitcost;
               bookvalue = aquisitioncost - salvagevalue;
               if (depreciationmethod == "Straight Line Method") {
                   if (life > 0) {
                       monthlydepreciation = bookvalue / life;
                   }


                   else {

                       monthlydepreciation = 0.00;
                       CINLifeInMonths.SetValue(0)
                       console.log("No Computation! Check your inputs!")

                   }
               }

               if (depreciationmethod == "Double Declining Balance Method") {
                   if (life > 0) {
                       monthlydepreciation = (bookvalue / life) * 2;
                   }
                   else {
                       monthlydepreciation = 0.00;
                       CINLifeInMonths.SetValue(0)
                       console.log("No Computation! Check your inputs!")
                   }
               }

               if (depreciationmethod == "Sum of Years Digit Method") {
                   if (life > 0) {
                       console.log(life + " LIFE")
                       console.log(bookvalue + " bookvalue")
                       console.log((life / (((+life + 1) * life) / 2)) + " COMPUTE")
                       monthlydepreciation = (life / (((+life + 1) * life) / 2)) * bookvalue;
                   }
                   else {
                       monthlydepreciation = 0.00;
                       CINLifeInMonths.SetValue(0)
                       console.log("No Computation! Check your inputs!")
                   }
               }

               CINAcquisitionCost.SetValue(aquisitioncost.toFixed(2));
               CINBookValue.SetValue(aquisitioncost.toFixed(2));
               CINMonthlyDepreciation.SetValue(monthlydepreciation.toFixed(2));
           }, 500);
       }


       function Generate(s, e) {

           var generate = confirm("Are you sure you want to generate depreciation?");
           if (generate) {

               gv1.CancelEdit();
               var num = CINLifeInMonths.GetValue();
               console.log(num);
               for (i = 0; i < num; i++) {
                   //console.log(i)
                   index = e.visibleIndex;
                   //gv1.DeleteRow(i);
                   gv1.AddNewRow();
               } // END OF FOR LOOPx`



               var indicies = gv1.batchEditApi.GetRowVisibleIndices();
               //console.log(indicies + " indicies")
               if (indicies.length > num) {
                   for (i = num ; i <= indicies.length; i++) {
                       gv1.DeleteRow(indicies[i]);
                       //console.log("Existed Rows Deleted!");
                       // gv1.CancelEdit();
                   } // end of for(i = num ; i <= indicies.length; i++)
                   autocalculate();
                   gv1.batchEditApi.EndEdit();
               } // end of if(indicies.length > num)
               else {
                   autocalculate();
                   gv1.batchEditApi.EndEdit();
               } //end of else


           } //end of If(generate)


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
           gvRef.SetWidth(width - 120);
       }

       function toFixed2(inputNumber, roundOffTo) {
           var multiplier = Math.pow(10, roundOffTo + 1)
                , wholeNumber = Math.floor(inputNumber * multiplier);
           return (Math.round(wholeNumber / 10) * 10 / multiplier).toFixed(roundOffTo);
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
                                <dx:ASPxLabel runat="server" Text="Asset Depreciation Setup" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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

                                            <%--<dx:LayoutItem Caption="Document Number" Name="DocNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" OnLoad="TextboxLoad" Enabled="false">
                                                       
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Document Date" Name="DocDate" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtDocDate" runat="server" OnLoad="Date_Load" OnInit="dtpDocDate_Init">
                                                        <ClientSideEvents Validation="OnValidation"/>
                                                            <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True"/>
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Property Number" Name="PropertyNumber">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtPropertyNumber" runat="server" Width="170px" ClientInstanceName="CINPropertyNumber" ReadOnly="true">
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

                                            <dx:LayoutItem Caption="Date Acquired" Name="DateAcquired">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtDateAcquired" runat="server" ReadOnly="true" DropDownButton-Enabled="false" Width="170px">
<DropDownButton Enabled="False"></DropDownButton>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Trans Type" Name="TransType">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtTransType" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Date Retired" Name="DateRetired">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtDateRetired" runat="server" ReadOnly="true" DropDownButton-Enabled="false" Width="170px">
<DropDownButton Enabled="False"></DropDownButton>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Document Number" Name="DocNumber">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumberRR" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Start of Depreciation" Name="StartOfDepreciation">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtStartOfDepreciation" runat="server" OnLoad="Date_Load" OnInit="dtpDocDate_Init" Width="170px">
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Item Code" Name="ItemCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtItemCode" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Parent Property" Name="ParentProperty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtParentProperty" runat="server" Width="170px" ReadOnly="true">
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

                                            <dx:LayoutItem Caption="Assigned To" Name="AssignedTo">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtAssignedTo" runat="server" Width="170px" ReadOnly="true">
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

                                            <dx:LayoutItem Caption="Location" Name="Location">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtLocation" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Size Code" Name="SizeCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtSizeCode" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Department" Name="Department">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDepartment" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Description" Name="Description">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDescription" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Warehouse" Name="Warehouse">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtWarehouse" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Unit" Name="Unit">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtUnit" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                           <dx:LayoutItem Caption="Status" Name="Status">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStatus" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Quantity" Name="Qty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="spinQty" ClientInstanceName="CINQuantity" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="false" ReadOnly="true" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                                    <ClientSideEvents ValueChanged="autocompute"/>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                           </dx:LayoutItem>

                                            <dx:LayoutItem Caption="New Depreciation Method" Name="NewDepreciationMethod">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox ID="cbNewDepreciationMethod" ClientInstanceName="CINDepreciationMethod" runat="server" Width="170px" OnLoad="ComboBoxLoad">
                                                                                                                            
                                                                    <Items>
                                                                        <dx:ListEditItem Text="Double Declining Balance Method" Value="Double Declining Balance Method" />
                                                                        <dx:ListEditItem Text="Straight Line Method" Value="Straight Line Method" />
                                                                        <dx:ListEditItem Text="Sum of Years Digit Method" Value="Sum of Years Digit Method" />
                                                                    </Items>
                                                                    <ClientSideEvents ValueChanged ="autocompute"/> 
                                                                   <%-- <ClientSideEvents  ValueChanged="function(){cp.PerformCallback('GetUsedLife'); autodepreciate();}"/>--%>
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Unit Cost" Name="UnitCost">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="spinUnitCost" ClientInstanceName="CINUnitCost" runat="server" Width="170px" SpinButtons-ShowIncrementButtons="false" ReadOnly="true" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" 
                                                                    AllowMouseWheel="false" HorizontalAlign="Right">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                                    <ClientSideEvents ValueChanged="autocompute"/>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                           </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Life in Months" Name="LifeInMonths" FieldName="LifeInMonths">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                        <dx:ASPxSpinEdit ID="spinLifeInMonths" ClientInstanceName="CINLifeInMonths" runat="server" Width="100px" SpinButtons-ShowIncrementButtons="false" OnLoad="SpinEdit_Load" >
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                                            <ClientSideEvents ValueChanged="autocompute"/>
                                                                        </dx:ASPxSpinEdit>
                                                                        </td>
                                                                        <td>
                                                                        <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="" Width="20">
                                                                        </dx:ASPxLabel>
                                                                        <dx:ASPxLabel ID="lbl" runat="server" Text="Parent SetUp" Width="70">
                                                                        </dx:ASPxLabel>
                                                                        <dx:ASPxCheckBox ID="chkParentSetup" runat="server" CheckState="Unchecked" ClientInstanceName="chkParentSetup" OnLoad="CheckBoxLoad">
                                                                        </dx:ASPxCheckBox>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Parent SetUp">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkParentSetup" runat="server" CheckState="Unchecked" ClientInstanceName="chkParentSetup">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutGroup Caption="GL" ColCount="1" ColSpan="2">
                                                <Items>

                                                    <dx:LayoutItem Caption="Accumulated Account Code" Name="AccumulatedAccountCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glAccumulatedAccountCode" runat="server" Width="170px"  DataSourceID="AccumulatedGLCodeLookup" 
                                                                    KeyFieldName="AccountCode" TextFormatString="{0}" OnLoad="LookupLoad" AutoGenerateColumns="false">
                                                                   <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('AccumulatedSetSubsi');  e.processOnServer = false;}" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Accumulated Subsi Code" Name="AccumulatedSubsiCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glAccumulatedSubsiCode" runat="server" Width="170px" DataSourceID="AccumulatedGLSubsiCode" 
                                                                    KeyFieldName="SubsiCode" TextFormatString="{0}" OnLoad="LookupLoad" AutoGenerateColumns="false">
                                                                   <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SubsiCode" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Accumulated Profit Center" Name="AccumulatedProfitCenter">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glAccumulatedProfitCenter" DataSourceID="ProfitCenterCodeLookup" KeyFieldName="ProfitCenterCode" 
                                                                    runat="server" Width="170px" TextFormatString="{0}" OnLoad="LookupLoad" AutoGenerateColumns="false">
                                                                   <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Accumulated Cost Center" Name="AccumulatedCostCenter">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glAccumulatedCostCenter" DataSourceID="CostCenterCodeLookup" KeyFieldName="CostCenterCode" 
                                                                    runat="server" Width="170px" TextFormatString="{0}" OnLoad="LookupLoad" AutoGenerateColumns="false">
                                                                   <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Depreciation Account Code" Name="DepreciationAccountCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glDepreciationAccountCode" runat="server" Width="170px" DataSourceID="DepreciationGLCodeLookup" 
                                                                    KeyFieldName="AccountCode" TextFormatString="{0}" OnLoad="LookupLoad">
                                                                    <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('AccumulatedSetSubsi');  e.processOnServer = false;}" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Depreciation Subsi Code" Name="DepreciationSubsiCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glDepreciationSubsiCode" runat="server" Width="170px"  DataSourceID="DepreciatedGLSubsiCode" 
                                                                    KeyFieldName="SubsiCode" TextFormatString="{0}" OnLoad="LookupLoad">
                                                                   <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SubsiCode" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Depreciation Profit Center" Name="DepreciationProfitCenter">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glDepreciationProfitCenter" DataSourceID="ProfitCenterCodeLookup" KeyFieldName="ProfitCenterCode" runat="server" 
                                                                    Width="170px" TextFormatString="{0}" OnLoad="LookupLoad">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ProfitCenterCode" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Depreciation Cost Center" Name="DepreciationCostCenter">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glDepreciationCostCenter" DataSourceID="CostCenterCodeLookup" KeyFieldName="CostCenterCode" runat="server" Width="170px" TextFormatString="{0}" OnLoad="LookupLoad">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Gain/Loss Account" Name="GainLossAccount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glGainLossAccount" DataSourceID="GainLossAccount" KeyFieldName="AccountCode" runat="server" 
                                                                    Width="170px" TextFormatString="{0}" OnLoad="LookupLoad">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="AccountCode" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    
                                                    
                                                </Items>
                                            </dx:LayoutGroup>


                                            <dx:LayoutGroup Caption="Amounts" ColCount="1" ColSpan="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Acquisition Cost" Name="AcquisitionCost">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtAcquisitionCost" ClientInstanceName="CINAcquisitionCost"  runat="server" Width="170px" ReadOnly="true" DisplayFormatString="{0:N}"
                                                                    HorizontalAlign="Right">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Salvage Value" Name="SalvageValue">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="txtSalvageValue" ClientInstanceName="CINSalvageValue"  runat="server" Width="170px" SpinButtons-ShowIncrementButtons="false" OnLoad="SpinEdit_Load" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}"
                                                                     AllowMouseWheel="false" HorizontalAlign="Right">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>

                                                                    <ClientSideEvents ValueChanged="autocompute"/>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Amount Sold" Name="AmountSold">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="spinAmountSold" ClientInstanceName="CINAmountSold"  runat="server" Width="170px" SpinButtons-ShowIncrementButtons="false" ReadOnly="true" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}"
                                                                    AllowMouseWheel="false" HorizontalAlign="Right">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Accumulated Depreciation" Name="AccumulatedDepreciation">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="spinAccumulatedDepreciation" ClientInstanceName="CINAccumulatedDepreciation"  runat="server" Width="170px" SpinButtons-ShowIncrementButtons="false" ReadOnly="true" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}"
                                                                    AllowMouseWheel="false" HorizontalAlign="Right">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Book Value" Name="BookValue">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtBookValue" ClientInstanceName="CINBookValue"  runat="server" Width="170px" ReadOnly="true" DisplayFormatString="{0:N}"
                                                                    HorizontalAlign="Right">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Monthly Depreciation" Name="MonthlyDepreciation">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtMonthlyDepreciation" ClientInstanceName="CINMonthlyDepreciation"  runat="server" Width="170px" ReadOnly="true" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}"
                                                                    HorizontalAlign="Right">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                </Items>
                                            </dx:LayoutGroup>
                                            
                                         </Items>
                                    </dx:LayoutGroup>




                                    <dx:LayoutGroup Caption="Asset Information Tab" ColCount="2">
                                        <Items>

                                            
                                            <dx:LayoutItem Caption="Compute Depreciation" Name="Genereatebtn">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxButton ID="Generatebtn" runat="server" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False"  ClientVisible="true" Text="Generate" Theme="MetropolisBlue"  onload="Generate_Btn" Width="170px">
                                                                    <ClientSideEvents Click="Generate" />
                                                        </dx:ASPxButton>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:EmptyLayoutItem></dx:EmptyLayoutItem>

                                            <%-------------------%>
                                            <%--Detail Grid View Start Here--%>
                                            <%-------------------%>
                                             <dx:LayoutGroup Caption="Asset Depreciation Schedule">
                                                    <Items>

                                                        <dx:LayoutItem Caption="">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="850px" 
                                                                        OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                                        OnBatchUpdate="gv1_BatchUpdate" OnCustomButtonInitialize="gv1_CustomButtonInitialize" SettingsBehavior-AllowSort="False">
                                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" 
                                                                            
                                                                            BatchEditStartEditing="OnStartEditing"  BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick"/>
                                                                        <SettingsPager Mode="ShowAllRecords"/> 
                                                                                <SettingsEditing Mode="Batch" />

                                                                        <%--Init="autocompute"  02-08-2017  KMM Para di magautocompute agad dapat during change lang--%>
                                                                        <Settings  HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="400" ShowFooter="True"  ShowStatusBar="Hidden"/> 
                                                    
<SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                                        <Columns>
                                                                           <%-- <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False" VisibleIndex="0">
                                                                            </dx:GridViewDataTextColumn>--%>
                                                        
                                                                            <dx:GridViewDataTextColumn FieldName="PropertyNumber" VisibleIndex="3" Width="250px" Name="glPropertyNumber">
                                                                                 <EditItemTemplate>
                                                                                    <dx:ASPxTextBox ID="glPropertyNumber" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                                        ClientInstanceName="CINPropertyNumberDetail" TextFormatString="{0}" Width="250px">
                                                                                        
                                                                                    </dx:ASPxTextBox>
                                                                                </EditItemTemplate>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="0px" ReadOnly="true">
                                                                            </dx:GridViewDataTextColumn>

                                                                            <%--<dx:GridViewDataTextColumn FieldName="PropertyNumber" Name="PropertyNumber" VisibleIndex="2" Width="150px">
                                                                                <PropertiesTextEdit ClientInstanceName="CINPropertyNumberDetail"></PropertiesTextEdit>
                                                                            </dx:GridViewDataTextColumn>--%>


                                                                             <dx:GridViewDataSpinEditColumn FieldName="Month" Name="Month" Caption="Month" VisibleIndex="4" Width="100px">
                                                                                <PropertiesSpinEdit Increment="0" ClientInstanceName="CINMonth" SpinButtons-ShowIncrementButtons="false">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                                </PropertiesSpinEdit>
                                                                            </dx:GridViewDataSpinEditColumn>

                                                                            <dx:GridViewDataSpinEditColumn FieldName="RunningBookValue" Name="RunningBookValue" Caption="Running Book Value" VisibleIndex="5" Width="200px">
                                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CINDepreciatedAmount" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                            </dx:GridViewDataSpinEditColumn>

                                                        
                                                                            <dx:GridViewDataSpinEditColumn FieldName="DepreciationAmount" Name="DepreciatedAmount" Caption="Depreciation Amount" VisibleIndex="6" Width="200px">
                                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CINDepreciatedAmount" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}">
<SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                            </PropertiesSpinEdit>
                                                                            </dx:GridViewDataSpinEditColumn>

                                                                            <dx:GridViewDataTextColumn FieldName="PostedDate" VisibleIndex="7" Width="200px" Caption="Posted Date">
                                                                                <PropertiesTextEdit ClientInstanceName="CINPostedDate"></PropertiesTextEdit>
                                                                            </dx:GridViewDataTextColumn>

                                                                             <dx:GridViewDataTextColumn FieldName="JournalVoucherNumber" VisibleIndex="8" Width="250px" Caption="Journal Voucher Number">
                                                                                <PropertiesTextEdit ClientInstanceName="CINJournalVoucherNumber"></PropertiesTextEdit>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="Version" VisibleIndex="9" Width="0px" Caption="Version">
                                                                                <PropertiesTextEdit ClientInstanceName="CINVersion"></PropertiesTextEdit>
                                                                            </dx:GridViewDataTextColumn>

                                                                            

                                                                            <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="0px">
                                                                                <CustomButtons>
                                                                                    <%--<dx:GridViewCommandColumnCustomButton ID="Details">
                                                                                        <Image IconID="support_info_16x16"></Image>
                                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                                    <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                                        <Image IconID="actions_cancel_16x16"> </Image>
                                                                                    </dx:GridViewCommandColumnCustomButton>--%>
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
                                  <%--<dx:LayoutItem Caption="Submitted By:" >
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
                                               </dx:LayoutItem> --%>
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
                                                                        <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" ReadOnly="True">
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
                                                                        <%--<dx:GridViewDataTextColumn Caption="Reference DocNumber" FieldName="REFDocNumber" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True">
                                                                        </dx:GridViewDataTextColumn>--%>
                                                                        <dx:GridViewDataTextColumn Caption="Reference PropertyNumber" FieldName="REFDocNumber" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4" ReadOnly="True">
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
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.AssetDepreciationSetup" DataObjectTypeName="Entity.AssetDepreciationSetup" InsertMethod="InsertData" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="PropertyNumber" QueryStringField="docnumber" Type="String" />

        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.AssetDepreciationSetup+AssetDepreciationSetupDetail" DataObjectTypeName="Entity.AssetDepreciationSetup+AssetDepreciationSetupDetail" DeleteMethod="DeleteAssetDepreciationSetupDetail" InsertMethod="AddAssetDepreciationSetupDetail" UpdateMethod="UpdateAssetDepreciationSetupDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="PropertyNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.AssetDepreciationSetup+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Accounting.AssetInvDetail where PropertyNumber  is null "
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

    <asp:SqlDataSource ID="PropertyNumberLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PropertyNumber,ItemCode FROM Accounting.[AssetAcquisition]"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="AssetAcquisitionLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PropertyNumber, LineNumber ,Month,RunningBookValue,DepreciatedAmount,PostedDate, JournalVoucherNumber FROM Accounting.[AssetInvDetail]"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>


    <asp:SqlDataSource ID="DepreciationGLCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AccountCode, Description FROM Accounting.ChartOfAccount WHERE ISNULL(IsInactive,0)=0 AND ISNULL(AllowJV,0)=1"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="AccumulatedGLCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AccountCode, Description FROM Accounting.ChartOfAccount WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="AccumulatedGLSubsiCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT SubsiCode, Description FROM Accounting.GLSubsiCode WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

        <asp:SqlDataSource ID="DepreciatedGLSubsiCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT SubsiCode, Description FROM Accounting.GLSubsiCode WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="ProfitCenterCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ProfitCenterCode, Description FROM Accounting.ProfitCenter WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="CostCenterCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT CostCenterCode, Description FROM Accounting.CostCenter WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="GainLossAccount" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT AccountCode, Description FROM Accounting.ChartOfAccount WHERE ISNULL(IsInactive,0)=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <!--#endregion-->
</body>
</html>


