<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmSalesInvoice.aspx.cs" Inherits="GWL.frmSalesInvoice" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Sales Invoice</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
        height: 710px; /*Change this whenever needed*/
        }

        .Entry {
        padding: 20px;
        margin: 10px auto;
        background: #FFF;
        }

        /*.dxeButtonEditSys input,
        .dxeTextBoxSys input{
            text-transform:uppercase;
        }*/

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
                console.log(s);
                console.log(e);
            }
            else {
                isValid = true;
            }
        }

        function OnInitTrans(s, e) {

            var BizPartnerCode = gvSup.GetText();

            factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode)
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
            gvJournal.SetWidth(width - 120);
        }

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            setTimeout(function () {
				var btnmode = btn.GetText(); //gets text of button

				if (btnmode == "Delete") {
					cp.PerformCallback("Delete");
				}


				var indicies = gv1.batchEditApi.GetRowVisibleIndices();
				var cntdetails = indicies.length;
				for (var i = 0; i < indicies.length; i++) {
					if (gv1.batchEditApi.IsNewRow(indicies[i])) {
						gv1.batchEditApi.ValidateRow(indicies[i]);
						gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("ItemCode").index);
					}
					else {
						var key = gv1.GetRowKey(indicies[i]);
						if (gv1.batchEditApi.IsDeletedRow(key))
							console.log("deleted row " + indicies[i]);
						else {
							gv1.batchEditApi.ValidateRow(indicies[i]);
							gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("ItemCode").index);
						}
					}
				}

				gv1.batchEditApi.EndEdit(); 
				autocalculate();

				if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
					//Sends request to server side
					if (btnmode == "Add") {
						if (cntdetails == 0) {
							cp.PerformCallback("AddZeroDetail");
						}
						else {
							cp.PerformCallback("Add");
						}
					}
					else if (btnmode == "Update") {
						if (cntdetails == 0) {
							cp.PerformCallback("UpdateZeroDetail");
						}
						else {
							cp.PerformCallback("Update");
						}
					}
					else if (btnmode == "Close") {
						cp.PerformCallback("Close");
					}
				}
				else {
					counterror = 0;
					alert('Please check all the fields!');
					console.log(counterror);
				}
            }, 1000);
        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        var vatrate = 0;
        var vatdetail1 = 0;
        var RPWD = 0;
        var RSC = 0
        var RDIP = 0;

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                gv1.CancelEdit();
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);
                if (s.cp_forceclose) {
                    delete (s.cp_forceclose);
                    window.close();
                }

            }

            if (s.cp_close) {
                if (s.cp_message != null) {
                    gv1.CancelEdit();
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
                    gv1.CancelEdit();
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
                gv1.CancelEdit();
                autocalculate();
            }
            if (s.cp_unitcost) {
                delete (s.cp_unitcost);
            }

            if (s.cp_vatrate != null) {

                vatrate = Number(s.cp_vatrate);
                delete (s.cp_vatrate);
                //vatdetail1 = 1 + parseFloat(vatrate);
            }

            if (s.cp_PWD != null) {
                RPWD = Number(s.cp_PWD);
                delete (s.cp_PWD);
            }

            if (s.cp_SC != null) {
                RSC = Number(s.cp_SC);
                delete (s.cp_SC);
            }

            if (s.cp_DIP != null) {
                RDIP = Number(s.cp_DIP);
                delete (s.cp_DIP);
            }

            if (s.cp_iswithdr == "1") {
                //prnum.SetEnabled(true);
            }
            else if (s.cp_iswithdr == "0") {
                //prnum.SetEnabled(false);
                //prnum.SetText(null);
            }

            if (s.cp_disctype != null) {
                delete (s.cp_disctype);
                DefaultType();
            }

            if (s.cp_countdetails != null) {
                delete (s.cp_countdetails);
            }
        }



        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)

            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                var chckd;

                if (column.fieldName == "Quantity") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == null) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required!";
                        isValid = false;
                    }
                }

                //if (column.fieldName == "Price") {
                //    var cellValidationInfo = e.validationInfo[column.index];
                //    if (!cellValidationInfo) continue;
                //    var value = cellValidationInfo.value;
                //    if (!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == null) {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = column.fieldName + " is required!";
                //        isValid = false;
                //    }
                //}

                if (column.fieldName == "VTaxCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || value == "NONV" || value == "" || value == null) && checkval == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = "Tax Code is required!";
                        isValid = false;
                    }
                }

            }
        }

        var index;
        var closing;
        var itemc; //variable required for lookup
        var valchange = false;
        var valchange_VAT = false;
        var valchange_Disc = false;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "DiscountType");

            index = e.visibleIndex;

            var entry = getParameterByName('entry');
            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }

            if (e.focusedColumn.fieldName !== "Price" && e.focusedColumn.fieldName !== "DiscountAmount"
                && e.focusedColumn.fieldName !== "DiscountType"
                && e.focusedColumn.fieldName !== "Field1" && e.focusedColumn.fieldName !== "Field2" && e.focusedColumn.fieldName !== "Field3"
                 && e.focusedColumn.fieldName !== "Field4" && e.focusedColumn.fieldName !== "Field5" && e.focusedColumn.fieldName !== "Field6"
                 && e.focusedColumn.fieldName !== "Field7" && e.focusedColumn.fieldName !== "Field8" && e.focusedColumn.fieldName !== "Field9") {
                e.cancel = true;
            }


            if (chkVatable.GetChecked()) {
                if (e.focusedColumn.fieldName == "VTaxCode") {
                    e.cancel = false;
                }
            }
            else {
                if (e.focusedColumn.fieldName == "VTaxCode") {
                    e.cancel = true;
                }
            }


            if (entry != "V") {
                //if (e.focusedColumn.fieldName === "DiscountType") { //Check the column name
                //    DiscountType.GetInputElement().value = cellInfo.value; //Gets the column value
                //    isSetTextRequired = true;
                //    closing = true;
                //}
                //if (e.focusedColumn.fieldName === "DiscountType") {
                //    DiscountType.GetInputElement().value = cellInfo.value;
                //}
                if (e.focusedColumn.fieldName === "Unit") {
                    Unit.GetInputElement().value = cellInfo.value;
                }
            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];

            var entry = getParameterByName('entry');

            //if (currentColumn.fieldName === "ItemCode") {
            //    cellInfo.value = gl.GetValue();
            //    cellInfo.text = gl.GetText().toUpperCase();
            //}
            //if (currentColumn.fieldName === "ColorCode") {
            //    cellInfo.value = gl2.GetValue();
            //    cellInfo.text = gl2.GetText().toUpperCase();
            //}
            //if (currentColumn.fieldName === "ClassCode") {
            //    cellInfo.value = gl3.GetValue();
            //    cellInfo.text = gl3.GetText().toUpperCase();
            //}
            //if (currentColumn.fieldName === "SizeCode") {
            //    cellInfo.value = gl4.GetValue();
            //    cellInfo.text = gl4.GetText().toUpperCase();
            //}
            if (currentColumn.fieldName === "Unit") {
                cellInfo.value = Unit.GetValue();
                cellInfo.text = Unit.GetText().toUpperCase();
            }
            //if (currentColumn.fieldName === "BulkUnit") {
            //    cellInfo.value = gl6.GetValue();
            //    cellInfo.text = gl6.GetText().toUpperCase();
            //}
            if (currentColumn.fieldName === "VTaxCode") {
                cellInfo.value = glVATCode.GetValue();
                cellInfo.text = glVATCode.GetText();
            }
            //if (currentColumn.fieldName === "IsVAT") {
            //    cellInfo.value = glIsVAT.GetValue();
            //}
            if (currentColumn.fieldName === "DiscountType") {
                cellInfo.value = glDiscountType.GetValue();
                cellInfo.text = glDiscountType.GetText();
            }
            if (currentColumn.fieldName === "Rate") {
                cellInfo.value = Rate.GetValue();
                cellInfo.text = Rate.GetText();
            }
            //if (currentColumn.fieldName === "SDRate") {
            //    cellInfo.value = glpSDRate.GetValue();
            //    cellInfo.text = glpSDRate.GetText();
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
        var check_rate = false;
        var val_VAT;
        var temp_VAT;
        var val_Disc;
        var temp_Disc;
        var identifier = "";
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

            if (selectedIndex == 0) {
                //if (column.fieldName == "ColorCode") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
                //}
                //if (column.fieldName == "ClassCode") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
                //}
                //if (column.fieldName == "SizeCode") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
                //}
                //if (column.fieldName == "Unit") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
                //}
                //if (column.fieldName == "BulkUnit") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
                //}
                //if (column.fieldName == "FullDesc") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
                //}
                //if (column.fieldName == "VATCode") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[6]);
                //}
                //if (column.fieldName == "IsVAT") {
                //    if (temp[7] == "True") {
                //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsVAT.SetChecked = true);
                //    }
                //    else {
                //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsVAT.SetChecked = false);
                //    }
                //}
                //if (column.fieldName == "DiscountType") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[8]);
                //}
                //if (column.fieldName == "Rate") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
                //}
            }
        }


        function GridEnd(s, e) {

            identifier = s.GetGridView().cp_identifier;
            //temp_VAT = val_VAT.split(';');
            console.log(identifier + 'hi')
            delete (s.cp_identifier)

            if (identifier == "vat") {
                temp_VAT = s.GetGridView().cp_codes;
                GridEnd_VAT();
            }

            if (identifier == "discount") {
                temp_Disc = s.GetGridView().cp_codes;
                GridEnd_Disc();
            }

            delete (s.cp_codes)
            gv1.batchEditApi.EndEdit();

            //console.log(check_rate);

            //console.log("rev");
            //if (check_rate == true) {
            //    val = s.GetGridView().cp_codes;
            //    console.log(val);
            //    temp = val.split(";");
            //    console.log(temp);

            //    if (closing == true) {
            //        for (var i = 0; i > -gv1.GetVisibleRowsOnPage() ; i--) {
            //            gv1.batchEditApi.ValidateRow(-1);
            //            //gv1.batchEditApi.StartEdit(i, gv1.GetColumnByField("ColorCode").index);
            //        }

            //        autocalculate();
            //        gv1.batchEditApi.EndEdit();
            //        check_rate = false;
            //    }
            //}
            //else {
            //    check_rate = true;
            //}

        }

        function GridEnd_VAT(s, e) {
            if (valchange_VAT) {
                valchange_VAT = false;
                var column = gv1.GetColumn()
                ProcessCells_VAT(0, index, column, gv1);
            }
        }

        function GridEnd_Disc(s, e) {
            if (valchange_Disc) {
                valchange_Disc = false;
                var column = gv1.GetColumn()
                ProcessCells_Disc(0, index, column, gv1);
            }
        }
        //dito na ko
        function ProcessCells_VAT(selectedIndex, focused, column, s) {
            console.log("ProcessCells_VAT")
            if (temp_VAT == null) {
                temp_VAT = 0;
            }
            if (selectedIndex == 0) {
                console.log(temp_VAT + "TEMPVAT")
                s.batchEditApi.SetCellValue(focused, "Rate", temp_VAT);
                autocalculate();
            }
        }
        function ProcessCells_Disc(selectedIndex, focused, column, s) {
            console.log("ProcessCells_Disc")
            if (temp_Disc == null) {
                temp_Disc = 0;
            }
            if (selectedIndex == 0) {
                console.log(temp_Disc + "TEMPDISC")
                s.batchEditApi.SetCellValue(focused, "SDRate", temp_Disc);
                autocalculate();
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

        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&unit=' + unitbase + '&fulldesc=' + fulldesc);
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


        function endcp(s, e) {
            var endg = s.GetGridView().cp_endgl1;
            if (endg == true) {
                console.log(endg);
                sup_cp_Callback.PerformCallback(aglCustomerCode.GetValue().toString());
                e.processOnServer = false;
                endg = null;
            }
        }

        function checkedchanged(s, e) {
            var checkState = cbiswithdr.GetChecked();
            if (checkState == true) {
                cp.PerformCallback('WithSO');
                e.processOnServer = false;
            }
            else {
                cp.PerformCallback('WithoutSO');
                e.processOnServer = false;
            }
        }

        function DefaultType(s, e) {

            //var indicies = gv1.batchEditApi.GetRowVisibleIndices();

            //for (var i = 0; i < indicies.length; i++) {

            //    gv1.batchEditApi.SetCellValue(indicies[i], "DiscountType", "NoDiscount");
            //    gv1.batchEditApi.SetCellValue(indicies[i], "Field1", "");
            //    gv1.batchEditApi.SetCellValue(indicies[i], "Field2", "");
            //    gv1.batchEditApi.SetCellValue(indicies[i], "Field3", "");
            //    gv1.batchEditApi.SetCellValue(indicies[i], "Field4", "");
            //    gv1.batchEditApi.SetCellValue(indicies[i], "Field5", "");
            //    gv1.batchEditApi.SetCellValue(indicies[i], "Field6", "");
            //    gv1.batchEditApi.SetCellValue(indicies[i], "Field7", "");
            //    gv1.batchEditApi.SetCellValue(indicies[i], "Field8", "");
            //    gv1.batchEditApi.SetCellValue(indicies[i], "Field9", "");


            //}
        }


        var checkval;
        function VATChecking(s, e) {
            if (chkVatable.GetChecked() == true) {
                checkval = true;
            }
            else {
                checkval = false;
            }
        }

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
                num = this.toFixed(Math.max(0, ~~d));

            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };

        function autocalculate(s, e) {

            OnInitTrans();

            console.log('auto')
            //for header
            var HDiscount = 0.00;
            var HDPW = 0.00;
            var HDSC = 0.00;
            var HDiplomat = 0.00;
            var HVATBefore = 0.00;
            var HNVATBefore = 0.00;
            var HVATAfter = 0.00;
            var HNVATAfter = 0.00;
            var HVat = 0.00;
            var HAmountDue = 0.00;
            //var HVat;

            //for detail
            var DQty = 0.00;
            var DPrice = 0.00;
            var DAmountBefore = 0.00;
            var DDiscount = 0.00;
            var DRate = 0.00;
            var DDType = "";
            var DSpecial = 0.00;
            var DSDRate = 0.00;
            var DQtyPri = 0.00;

            setTimeout(function () {


                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                        DQty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                        DPrice = gv1.batchEditApi.GetCellValue(indicies[i], "Price");
                        DSDRate = gv1.batchEditApi.GetCellValue(indicies[i], "SDRate");

                        if (DQty == null || isNaN(DQty) == true) {
                            DQty = 0;
                        }

                        if (DPrice == null || isNaN(DPrice) == true) {
                            DPrice = 0;
                        }

                        DQtyPri = (DQty * DPrice);

                        gv1.batchEditApi.SetCellValue(indicies[i], "AmountBeforeDisc", DQtyPri.toFixed(2));
                        gv1.batchEditApi.SetCellValue(indicies[i], "SDComputedAmt", (DQtyPri * DSDRate).toFixed(2));

                        if (chkVatable.GetChecked() == false) {
                            gv1.batchEditApi.SetCellValue(indicies[i], "Rate", 0);
                            gv1.batchEditApi.SetCellValue(indicies[i], "VTaxCode", "NONV");
                        }
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {

                            DQty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                            DPrice = gv1.batchEditApi.GetCellValue(indicies[i], "Price");
                            DSDRate = gv1.batchEditApi.GetCellValue(indicies[i], "SDRate");

                            if (DQty == null || isNaN(DQty) == true) {
                                DQty = 0;
                            }

                            if (DPrice == null || isNaN(DPrice) == true) {
                                DPrice = 0;
                            }

                            DQtyPri = (DQty * DPrice);

                            gv1.batchEditApi.SetCellValue(indicies[i], "AmountBeforeDisc", DQtyPri.toFixed(2));
                            gv1.batchEditApi.SetCellValue(indicies[i], "SDComputedAmt", (DQtyPri * DSDRate).toFixed(2));

                            if (chkVatable.GetChecked() == false) {
                                gv1.batchEditApi.SetCellValue(indicies[i], "Rate", 0);
                                gv1.batchEditApi.SetCellValue(indicies[i], "VTaxCode", "NONV");
                            }
                        }
                    }
                }

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                        DQty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                        DPrice = gv1.batchEditApi.GetCellValue(indicies[i], "Price");
                        DDiscount = gv1.batchEditApi.GetCellValue(indicies[i], "DiscountAmount");
                        DDType = gv1.batchEditApi.GetCellValue(indicies[i], "DiscountType");
                        DRate = gv1.batchEditApi.GetCellValue(indicies[i], "Rate");
                        DSDRate = gv1.batchEditApi.GetCellValue(indicies[i], "SDRate");

                        DAmountBefore += DQty * DPrice;
                        HDiscount += DDiscount;
                        DSpecial = DQty * DPrice;
                        HVat += (DQty * DPrice) * DRate;
                        //if (DDType == "PWD") {
                        //    HDPW += DSpecial * RPWD;
                        //}
                        //if (DDType == "SeniorCitizen") {
                        //    HDSC += DSpecial * RSC;
                        //}
                        //if (DDType == "Diplomat") {
                        //    HDiplomat += DSpecial * RDIP;
                        //}

                        if (DDType == "PWD") {
                            HDPW += DSpecial * DSDRate;
                        }
                        if (DDType == "SeniorCitizen") {
                            HDSC += DSpecial * DSDRate;
                        }
                        if (DDType == "Diplomat") {
                            HDiplomat += DSpecial * DSDRate;
                        }

                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) {
                            console.log("deleted row " + indicies[i]);
                        }
                        else {
                            DQty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                            DPrice = gv1.batchEditApi.GetCellValue(indicies[i], "Price");
                            DDiscount = gv1.batchEditApi.GetCellValue(indicies[i], "DiscountAmount");
                            DDType = gv1.batchEditApi.GetCellValue(indicies[i], "DiscountType");
                            DRate = gv1.batchEditApi.GetCellValue(indicies[i], "Rate");
                            DSDRate = gv1.batchEditApi.GetCellValue(indicies[i], "SDRate");

                            DAmountBefore += DQty * DPrice;
                            HDiscount += DDiscount;
                            DSpecial = DQty * DPrice;
                            HVat += (DQty * DPrice) * DRate;

                            //if (DDType == "PWD") {
                            //    HDPW += DSpecial * RPWD;
                            //}
                            //if (DDType == "SeniorCitizen") {
                            //    HDSC += DSpecial * RSC;
                            //}
                            //if (DDType == "Diplomat") {
                            //    HDiplomat += DSpecial * RDIP;
                            //}

                            if (DDType == "PWD") {
                                HDPW += DSpecial * DSDRate;
                            }
                            if (DDType == "SeniorCitizen") {
                                HDSC += DSpecial * DSDRate;
                            }
                            if (DDType == "Diplomat") {
                                HDiplomat += DSpecial * DSDRate;
                            }
                        }
                    }
                }


                if (chkVatable.GetChecked()) {

                    HVATAfter = DAmountBefore - (HDPW + HDSC + HDiplomat + HDiscount);
                    TotalVATBef.SetText(DAmountBefore.format(2, 3, ',', '.'));
                    TotalNVATBef.SetText(HNVATBefore.format(2, 3, ',', '.'));

                    TotalVATAft.SetText(HVATAfter.format(2, 3, ',', '.'));
                    TotalNVATAft.SetText(HNVATAfter.format(2, 3, ',', '.'));

                    //TotalAmountDue.SetText(HVATAfter.format(2, 3, ',', '.'));
                    //TotalVAT.SetText((HVATAfter * vatrate).format(2, 3, ',', '.'));
                    TotalVAT.SetText(HVat.format(2, 3, ',', '.'));
                }
                else {
                    HNVATAfter = DAmountBefore - HDPW - HDSC - HDiplomat - HDiscount;
                    TotalNVATBef.SetText(DAmountBefore.format(2, 3, ',', '.'));
                    TotalVATBef.SetText(HVATBefore.format(2, 3, ',', '.'));

                    TotalNVATAft.SetText(HNVATAfter.format(2, 3, ',', '.'));
                    TotalVATAft.SetText(HVATAfter.format(2, 3, ',', '.'));

                    //TotalAmountDue.SetText(HNVATAfter.format(2, 3, ',', '.'));
                    TotalVAT.SetText((0).format(2, 3, ',', '.'));
                }

                TotalPWD.SetText(HDPW.format(2, 3, ',', '.'));
                TotalSC.SetText(HDSC.format(2, 3, ',', '.'));
                TotalDiplomat.SetText(HDiplomat.format(2, 3, ',', '.'));
                TotalDiscount.SetText(HDiscount.format(2, 3, ',', '.'));
                TotalAmountDue.SetText((HVATAfter + HNVATAfter + HVat).format(2, 3, ',', '.'));

            }, 500);
        }

        function detailautocalculate(s, e) {

            var qty = 0.00;
            var price = 0.00

            var amountbefore = 0.00;

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                        qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                        price = gv1.batchEditApi.GetCellValue(indicies[i], "Price");

                        gv1.batchEditApi.SetCellValue(indicies[i], "AmountBeforeDisc", (qty * price).toFixed(2));
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                            price = gv1.batchEditApi.GetCellValue(indicies[i], "Price");

                            gv1.batchEditApi.SetCellValue(indicies[i], "AmountBeforeDisc", (qty * price).toFixed(2));
                        }
                    }
                }


            }, 500);


        }

    </script>
    <!--#endregion-->
</head>
<body style="height: 910px;">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
<form id="form1" runat="server" class="Entry">

     <dx:ASPxPopupControl ID="ASPxPopupControl1" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox2" CloseAction="None" 
        EnableViewState="False" HeaderText="BizPartner info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="50"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>


    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
        <PanelCollection>
            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                <dx:ASPxLabel runat="server" Text="Sales Invoice" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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
    <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents CloseUp="function (s, e) { window.location.reload(); }" />
    </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -20px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Document Number">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" OnLoad="TextboxLoad" Width="170px" AutoCompleteType="Disabled" Enabled="False">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Customer">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglCustomerCode" runat="server" ClientInstanceName="gvSup" DataSourceID="sdsBizPartnerCus" 
                                                                    KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px" AutoGenerateColumns="false">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="true">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="true">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('FilterSO');}" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnInit="dtpDocDate_Init" OnLoad="Date_Load" Width="170px">
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Name">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtName" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Currency" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglCurrency" runat="server" DataSourceID="sdsCurrency" KeyFieldName="Currency" 
                                                                    OnLoad="LookupLoad" TextFormatString="{0}" Width="170px" AutoGenerateColumns="false">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Currency" ReadOnly="true">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CurrencyName" ReadOnly="true">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Address">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtAddress" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Reference">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtReference" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="TIN">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtTIN" runat="server" ReadOnly="True" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="With Sales Order">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsWithSO" runat="server" CheckState="Unchecked" ClientInstanceName="cbiswithdr" OnLoad="CheckBoxLoad">
                                                                    <ClientSideEvents CheckedChanged="checkedchanged" />
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Vatable">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxCheckBox ID="chkVatable" runat="server" CheckState="Unchecked" ClientInstanceName="chkVatable" OnLoad="CheckBoxLoad">
                                                                <ClientSideEvents ValueChanged="function (s, e){autocalculate(); VATChecking(); }" />
                                                            </dx:ASPxCheckBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <%--<dx:LayoutItem Caption="Sales Order No">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglSONumber" runat="server" AutoGenerateColumns="False" ClientInstanceName="prnum" DataSourceID="sdsSONumber" KeyFieldName="DocNumber" OnLoad="LookupLoad" SelectionMode="Multiple" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents ValueChanged="function(s,e){cp.PerformCallback('Filter');}" />
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Discounts" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Total Discount Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDiscount" runat="server" Width="170px" ClientInstanceName="TotalDiscount" ReadOnly="true" 
                                                            ConvertEmptyStringToNull="False" DisplayFormatString ="{0:N}" NullDisplayText="0.00" NullText="0.00">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total PWD Discount" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPWDDisc" runat="server" Width="170px" ClientInstanceName="TotalPWD" ReadOnly="true" 
                                                            ConvertEmptyStringToNull="False" DisplayFormatString ="{0:N}" NullDisplayText="0.00" NullText="0.00">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                 <dx:LayoutItem Caption="Total Senior Citizen Discount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSCDisc" runat="server" Width="170px" ClientInstanceName="TotalSC" ReadOnly="true" 
                                                            ConvertEmptyStringToNull="False" DisplayFormatString ="{0:N}" NullDisplayText="0.00" NullText="0.00">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Diplomat Discount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDiplomatDisc" runat="server" Width="170px" ClientInstanceName="TotalDiplomat" ReadOnly="true" 
                                                            ConvertEmptyStringToNull="False" DisplayFormatString ="{0:N}" NullDisplayText="0.00" NullText="0.00">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Amount">
                                                <Items>
                                                    <dx:LayoutGroup Caption="Before Discounts">
                                                        <Items>
                                                            <dx:LayoutItem Caption="Total Vatable Before Discount">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtVATBefore" runat="server" ClientInstanceName="TotalVATBef" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" ReadOnly="True" Width="170px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Total Non-Vatable Before Discount">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtNonVATBefore" runat="server" ClientInstanceName="TotalNVATBef" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" ReadOnly="True" Width="170px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutGroup Caption="After Discounts">
                                                        <Items>
                                                            <dx:LayoutItem Caption="Total Vatable After Discount">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtVATAfter" runat="server" ClientInstanceName="TotalVATAft" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" ReadOnly="True" Width="170px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                            <dx:LayoutItem Caption="Total Non-Vatable After Discount">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtNonVATAfter" runat="server" ClientInstanceName="TotalNVATAft" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" ReadOnly="True" Width="170px">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutGroup Caption="VAT Amount">
                                                        <Items>
                                                            <dx:LayoutItem Caption="Total VAT Amount">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtVATAmount" runat="server" ClientInstanceName="TotalVAT" Width="170px" ReadOnly="true" 
                                                                        ConvertEmptyStringToNull="False" DisplayFormatString ="{0:N}" NullDisplayText="0.00" NullText="0.00">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                    <dx:LayoutGroup Caption="Total Receivables">
                                                        <Items>
                                                            <dx:LayoutItem Caption="Total Amount Due">
                                                                <LayoutItemNestedControlCollection>
                                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                                        <dx:ASPxTextBox ID="txtAmountDue" runat="server" Width="170px" ClientInstanceName="TotalAmountDue" ReadOnly="true" 
                                                                        ConvertEmptyStringToNull="False" DisplayFormatString ="{0:N}" NullDisplayText="0.00" NullText="0.00">
                                                                        </dx:ASPxTextBox>
                                                                    </dx:LayoutItemNestedControlContainer>
                                                                </LayoutItemNestedControlCollection>
                                                            </dx:LayoutItem>
                                                        </Items>
                                                    </dx:LayoutGroup>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    
                                    <dx:LayoutGroup Caption="Audit Trail" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ReadOnly="True">
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
                                            <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledDate" runat="server" Width="170px" ReadOnly="True">
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
                                                            <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="200"  /> 
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
                                                                <dx:GridViewDataSpinEditColumn FieldName="Debit" Name="jDebit" ShowInCustomizationForm="True" VisibleIndex="6" Width="120px" Caption="Debit Amount" >
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>                                                                
                                                                <dx:GridViewDataSpinEditColumn FieldName="Credit" Name="jCredit" ShowInCustomizationForm="True" VisibleIndex="7" Width="120px" Caption="Credit Amount" >
                                                                    <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                    </PropertiesSpinEdit>
                                                                </dx:GridViewDataSpinEditColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
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
                                                      <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="608px"  KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Settings-ShowStatusBar="Hidden">

<Settings ShowStatusBar="Hidden"></Settings>

                                                        <SettingsBehavior FilterRowMode="OnClick" ColumnResizeMode="NextColumn" />
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
                                                        <SettingsPager PageSize="5">
                                                        </SettingsPager>
                                                        <SettingsEditing Mode="Batch">
                                                        </SettingsEditing>
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ButtonType="Image"  ShowInCustomizationForm="True" VisibleIndex="0" Width="90px" >            
                                                                <CustomButtons>
                                                                    <dx:GridViewCommandColumnCustomButton ID="ViewReferenceTransaction">
                                                                    <Image IconID="functionlibrary_lookupreference_16x16"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                    <dx:GridViewCommandColumnCustomButton ID="ViewTransaction">
                                                                    <Image IconID="find_find_16x16"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>
                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="RTransType" Caption="Reference TransType" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly="True"  Name="RTransType">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="REFDocNumber" Caption="Reference DocNumber" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="True" >
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4" ReadOnly="True">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Caption="DocNumber"  ReadOnly="True">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6"   ReadOnly="True">
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
                            <dx:LayoutGroup Caption="Sales Invoice Detail">
                                <Items>
                                    <dx:LayoutItem Caption="Transaction No.">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridLookup ID="aglTransNo" runat="server" AutoGenerateColumns="False" DataSourceID="sdsRefTrans" KeyFieldName="DocNumber" 
                                                        OnLoad="LookupLoad" SelectionMode="Multiple" TextFormatString="{0}" OnInit="aglTransNo_Init">
                                                    <GridViewProperties>
                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                        <Settings ShowFilterRow="True" />
                                                    </GridViewProperties>
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn Caption="DocDate" FieldName="DocDate" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly ="true">
                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                            <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                            </PropertiesDateEdit>
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="CustomerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                            <Settings AutoFilterCondition ="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Remarks" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6">
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
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" ClientInstanceName="gv1" KeyFieldName="LineNumber;SONumber;TransType;TransDoc" OnBatchUpdate="gv1_BatchUpdate" 
                                                    OnCellEditorInitialize="gv1_CellEditorInitialize" OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize" OnInit="gv1_Init" 
                                                    Width="850px">
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" 
                                                        BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" Init="OnInitTrans" 
                                                        BatchEditRowValidating="Grid_BatchEditRowValidating"/>
                                                    <SettingsPager Mode="ShowAllRecords">
                                                    </SettingsPager>
                                                    <SettingsEditing Mode="Batch">
                                                    </SettingsEditing>
                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" />
                                                    <SettingsBehavior AllowSort="False" />
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                    <Image IconID="support_info_16x16" ToolTip="Details">
                                                                    </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Sales Order" FieldName="SONumber" Name="glpSONo" ShowInCustomizationForm="True" VisibleIndex="3" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="TransType" FieldName="TransType" Name="glpTransType" ShowInCustomizationForm="True" VisibleIndex="4" Width="70px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Transaction No" FieldName="TransDoc" Name="glpTransDoc" ShowInCustomizationForm="True" VisibleIndex="5">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn Caption="Transaction Date" FieldName="TransDate" Name="glpTransDate" ShowInCustomizationForm="True" VisibleIndex="6">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn Caption="Item" FieldName="ItemCode" Name="glpItemCode" ShowInCustomizationForm="True" VisibleIndex="7" Width="100px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Color" FieldName="ColorCode" Name="ColorCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Class" FieldName="ClassCode" ShowInCustomizationForm="True" VisibleIndex="9" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Size" FieldName="SizeCode" Name="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="10" Width="80px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Quantity" FieldName="Qty" Name="glpQty" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="11">
                                                            <PropertiesSpinEdit Increment="0" AllowMouseWheel="False" ClientInstanceName="Qty" ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0.0000" NullText="0" NumberFormat="Custom">
                                                                <SpinButtons ShowIncrementButtons="False">
                                                                </SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Bulk Qty" FieldName="BulkQty" Name="glpQty" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="12">
                                                            <PropertiesSpinEdit Increment="0" AllowMouseWheel="False" ClientInstanceName="BulkQty" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0" NumberFormat="Custom">
                                                                <SpinButtons ShowIncrementButtons="False">
                                                                </SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit" ShowInCustomizationForm="True" VisibleIndex="13" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnit" runat="server" AutoGenerateColumns="False" AutoPostBack="False" ClientInstanceName="Unit" DataSourceID="sdsUnit" KeyFieldName="Unit" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Unit" ReadOnly="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Price" Name="glpUnitPrice" ShowInCustomizationForm="True" VisibleIndex="14" Width="80px">
                                                            <PropertiesSpinEdit Increment="0" AllowMouseWheel="False" ClientInstanceName="Price" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                <SpinButtons ShowIncrementButtons="False">
                                                                </SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Amount Before Discount" FieldName="AmountBeforeDisc" Name="glpAmount" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="15" Width="140px">
                                                            <PropertiesSpinEdit Increment="0" AllowMouseWheel="False" ClientInstanceName="AmountBeforeDisc" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                <SpinButtons ShowIncrementButtons="False">
                                                                </SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Discount Amount" FieldName="DiscountAmount" Name="glpDiscountAmount" ShowInCustomizationForm="True" VisibleIndex="16" Width="110px">
                                                            <PropertiesSpinEdit Increment="0" AllowMouseWheel="False" ClientInstanceName="Discount" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                <SpinButtons ShowIncrementButtons="False">
                                                                </SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn Caption="Tax Code" FieldName="VTaxCode" Name="glpVATCode" ShowInCustomizationForm="True" VisibleIndex="17" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glVATCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" ClientInstanceName="glVATCode" DataSourceID="sdsTaxCode" KeyFieldName="TCode" 
                                                                    OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn Caption="Tax Code" FieldName="TCode" ReadOnly="True" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" RowClick="function(s,e){
                                                                    console.log('rowclick');
                                                                        setTimeout(function(){
                                                                    closing = true;
                                                                    glVATCode.GetGridView().PerformCallback('VATCode' + '|' + glVATCode.GetValue() + '|' + 'code');
                                                                    e.processOnServer = false;
                                                                    valchange_VAT = true
                                                                    }, 500);
                                                                  }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Discount Type" FieldName="DiscountType" Name="glpDiscountType" ShowInCustomizationForm="True" VisibleIndex="18" Width="90px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glDiscountType" runat="server" AutoGenerateColumns="false" AutoPostBack="false" ClientInstanceName="glDiscountType" DataSourceID="sdsDiscount" KeyFieldName="DiscountType" 
                                                                    OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="90px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DiscountType" ReadOnly="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" RowClick="function(s,e){
                                                                    console.log('rowclick');
                                                                        setTimeout(function(){
                                                                    closing = true;
                                                                    glDiscountType.GetGridView().PerformCallback('DiscountType' + '|' + glDiscountType.GetValue() + '|' + 'code');
                                                                    e.processOnServer = false;
                                                                    valchange_Disc = true
                                                                    }, 500);
                                                                  }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="BaseQty" Name="glpBaseQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="19">
                                                            <PropertiesSpinEdit Increment="0" AllowMouseWheel="False" ConvertEmptyStringToNull="False" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NullDisplayText="0.0000" NullText="0.0000" NumberFormat="Custom">
                                                                <SpinButtons Enabled="False" ShowIncrementButtons="False">
                                                                </SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="StatusCode" Name="glpStatusCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="20">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BarcodeNo" Name="glpBarcodeNo" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="21">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn Caption="Unit Factor" FieldName="UnitFactor" Name="glpUnitFactor" ShowInCustomizationForm="True" VisibleIndex="22">
                                                            <PropertiesSpinEdit Increment="0" AllowMouseWheel="False" DisplayFormatString="{0:N}" NullDisplayText="0.000" NumberFormat="Custom">
                                                                <SpinButtons ShowIncrementButtons="False">
                                                                </SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="23">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="24">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="25">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="26">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="27">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="28">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="29">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="30">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="31">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Version" Name="glpVersion" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="32" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Rate" Name="glpRate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="35" Width="0px">
                                                            <PropertiesSpinEdit Increment="0" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                <SpinButtons Enabled="False" ShowIncrementButtons="False">
                                                                </SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="SDRate" Name="glpSDRate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="36" Width="0px">
                                                            <PropertiesSpinEdit Increment="0" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                <SpinButtons Enabled="False" ShowIncrementButtons="False">
                                                                </SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="SDComputedAmt" Name="glpSDComputedAmt" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="37" Width="0px">
                                                            <PropertiesSpinEdit Increment="0" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                <SpinButtons Enabled="False" ShowIncrementButtons="False">
                                                                </SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="AverageCost" Name="glpAverageCost" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="38" Width="0px">
                                                            <PropertiesSpinEdit Increment="0" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                <SpinButtons Enabled="False" ShowIncrementButtons="False">
                                                                </SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitCost" Name="glpUnitCost" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="39" Width="0px">
                                                            <PropertiesSpinEdit Increment="0" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" NullDisplayText="0.00" NullText="0.00" NumberFormat="Custom">
                                                                <SpinButtons Enabled="False" ShowIncrementButtons="False">
                                                                </SpinButtons>
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
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false">
                                <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false">
                                <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                </dx:ASPxButton> 
                             </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
    </form>
    <!--#region Region Datasource-->
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.SalesInvoice" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.SalesInvoice" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.SalesInvoice+SalesInvoiceDetail" SelectMethod="getdetail" UpdateMethod="UpdateSalesInvoiceDetail" TypeName="Entity.SalesInvoice+SalesInvoiceDetail" DeleteMethod="DeleteSalesInvoiceDetail" InsertMethod="AddSalesInvoiceDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.SalesInvoice+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.SalesInvoice+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsBizPartnerCus" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT BizPartnerCode, Name FROM Masterfile.BPCustomerInfo WHERE ISNULL(IsInActive,0)=0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Accounting.SalesInvoiceDetail WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item]" OnInit ="Connection_Init"></asp:SqlDataSource>  
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT B.ItemCode, ColorCode, ClassCode,SizeCode,UnitBase AS Unit,FullDesc, UnitBulk AS BulkUnit FROM Masterfile.[Item] A INNER JOIN Masterfile.[ItemDetail] B ON A.ItemCode = B.ItemCode where isnull(A.IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSONumber" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber FROM Sales.SalesOrder WHERE ISNULL([SubmittedBy], '') != '' AND Status IN ('N','P') " OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsRefTrans" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber, DocDate, CustomerCode, Remarks FROM Sales.DeliveryReceipt WHERE ISNULL(SubmittedBy,'') != '' AND ISNULL(InvoiceDocNum,'') = '' UNION ALL SELECT A.DocNumber, A.DocDate, A.CustomerCode, A.Remarks FROM Sales.SalesReturn A INNER JOIN Sales.DeliveryReceipt B ON A.ReferenceDRNo = B.DocNumber WHERE ISNULL(A.SubmittedBy,'') != ''" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTransDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT RIGHT('00000'+ CAST(ROW_NUMBER() OVER (ORDER BY A.DocNumber) AS VARCHAR(5)),5) AS LineNumber, 
        B.SONumber AS SONumber,'' AS TransType, A.DocNumber AS TransDoc, A.DocDate AS TransDate,B.ItemCode, B.ColorCode, B.ClassCode, B.SizeCode, SUM(B.DeliveredQty) AS Qty, SUM(B.BulkQty) AS BulkQty, MAX(B.Unit) AS Unit, 
        MAX(C.UnitPrice) AS Price, SUM(B.DeliveredQty)* MAX(C.UnitPrice) AS AmountBeforeDisc,0.00 AS DiscountAmount,MAX(ISNULL(C.VATCode,'NONV')) AS VTaxCode,'NoDiscount' AS DiscountType,
        SUM(ISNULL(B.BaseQty,0)) BaseQty,MAX(B.StatusCode) StatusCode,MAX(B.BarcodeNo) BarcodeNo,MAX(ISNULL(B.UnitFactor,0)) UnitFactor,MAX(B.Field1) AS Field1,MAX(B.Field2) AS Field2,
        MAX(B.Field3) AS Field3,MAX(B.Field4) AS Field4,MAX(B.Field5) AS Field5,MAX(B.Field6) AS Field6,MAX(B.Field7) AS Field7,MAX(B.Field8) AS Field8,MAX(B.Field9) AS Field9, ISNULL(B.AverageCost,0) AS AverageCost, ISNULL(B.UnitCost,0) AS UnitCost, '0' AS Version, 0.00 AS Rate, 0.00 AS SDRate, 0.00 AS SDComputedAmt FROM Sales.DeliveryReceipt A
        INNER JOIN Sales.DeliveryReceiptDetail B ON A.DocNumber = B.DocNumber INNER JOIN Sales.SalesOrderDetail C ON B.SONumber = C.DocNumber AND B.ItemCode = C.ItemCode AND B.ColorCode = C.ColorCode AND B.ClassCode = C.ClassCode AND B.SizeCode = C.SizeCode 
        GROUP BY B.SONumber, A.DocNumber, A.DocDate,B.ItemCode, B.ColorCode, B.ClassCode, B.SizeCode, B.AverageCost, B.UnitCost" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDiscount" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Description AS DiscountType, Code,  ROW_NUMBER() OVER (PARTITION BY LEN(Description) ORDER BY Description) Ord FROM IT.SystemSettings WHERE Code LIKE 'DISC_%' AND SequenceNumber = 6" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UnitCode AS Unit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCurrency" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Currency, CurrencyName FROM Masterfile.Currency WHERE ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTaxCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.Tax WHERE ISNULL(IsInactive,0) = 0 AND TCode != 'NONV'" OnInit="Connection_Init"></asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>


