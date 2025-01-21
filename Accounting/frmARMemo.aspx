<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmARMemo.aspx.cs" Inherits="GWL.frmARMemo" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>AR Memo</title>
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
        var taxrate = 0;

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
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
            gvJournal.SetWidth(width - 100);
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

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            var btnmode = btn.GetText(); //gets text of button
            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }
            console.log(isValid + ' ' + counterror);

            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            var cntdetails = indicies.length;

            gv1.batchEditApi.EndEdit();

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


        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

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

            if (s.cp_delete) {
                delete (cp_delete);
                DeleteControl.Show();
            }
            if (s.cp_generated) {
                autocalculate();
                gv1.CancelEdit();
                delete (s.cp_generated);
            }
            if (s.cp_unitcost) {
                delete (s.cp_unitcost);
            }
            if (s.cp_typeeffect) {
                Checktype();
                delete (s.cp_typeeffect);
            }
        }

        var index;
        var closing;
        var itemc; //variable required for lookup
        var valchange = false;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var evn;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "DiscountType");

            evn = e;
            var entry = getParameterByName('entry');

            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }

            if (entry != "V") {
                if (e.focusedColumn.fieldName === "DiscountType") { //Check the column name
                    DiscountType.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                    closing = true;
                }

                var TypeVal = Type.GetText();

                if (TypeVal === "Sales Return") {
                    if (e.focusedColumn.fieldName !== "Qty" && e.focusedColumn.fieldName !== "BulkQty") {
                        e.cancel = true;
                    }
                }
                else {
                    e.cancel = true;
                }

                if (e.focusedColumn.fieldName === "DiscountType") {
                    DiscountType.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName !== "ExpDate" || e.focusedColumn.fieldName !== "MfgDate" ||
                    e.focusedColumn.fieldName !== "Batchno" && e.focusedColumn.fieldName !== "LotNo") {
                    e.cancel = false;
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
            //if (currentColumn.fieldName === "Unit") {
            //    cellInfo.value = gl5.GetValue();
            //    cellInfo.text = gl5.GetText().toUpperCase();
            //}
            //if (currentColumn.fieldName === "BulkUnit") {
            //    cellInfo.value = gl6.GetValue();
            //    cellInfo.text = gl6.GetText().toUpperCase();
            //}
            //if (currentColumn.fieldName === "VATCode") {
            //    cellInfo.value = glVATCode.GetValue();
            //    cellInfo.text = glVATCode.GetText();
            //}
            //if (currentColumn.fieldName === "IsVAT") {
            //    cellInfo.value = glIsVAT.GetValue();
            //}
            if (currentColumn.fieldName === "DiscountType") {
                cellInfo.value = DiscountType.GetValue();
                cellInfo.text = DiscountType.GetText();
            }
            //if (currentColumn.fieldName === "Rate") {
            //    cellInfo.value = Rate.GetValue();
            //    cellInfo.text = Rate.GetText();
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
                if (column.fieldName == "Rate") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
                }
            }
        }


        function GridEnd(s, e) {

            console.log(check_rate);

            console.log("rev");
            if (check_rate == true) {
                val = s.GetGridView().cp_codes;
                console.log(val);
                temp = val.split(";");
                console.log(temp);
                if (closing == true) {
                    for (var i = 0; i > -gv1.GetVisibleRowsOnPage() ; i--) {
                        gv1.batchEditApi.ValidateRow(-1);
                        //gv1.batchEditApi.StartEdit(i, gv1.GetColumnByField("ColorCode").index);
                    }

                    autocalculate();
                    gv1.batchEditApi.EndEdit();
                    check_rate = false;
                }
            }
            else {
                check_rate = true;
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

        var clonenumber = 0;
        var cloneindex;
        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                //var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                //var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                var Warehouse = aglWarehouseCodes.GetText();
                var BizPartnerCode = gsCustomerCode.GetText();

                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&Warehouse=' + Warehouse);

                factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
                console.log(Warehouse);
                console.log(BizPartnerCode);
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
            if (e.buttonID == "CountSheet") {
                if (Type.GetText() == "Sales Return") {
                    CSheet.Show();
                    var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
                    var docnumber = getParameterByName('docnumber');
                    var transtype = getParameterByName('transtype');
                    var refdocnum = s.batchEditApi.GetCellValue(e.visibleIndex, "TransDoc");
                    var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                    var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                    var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                    var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                    var bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "BulkQty");
                    var expdate = s.batchEditApi.GetCellValue(e.visibleIndex, "ExpDate");
                    var mfgdate = s.batchEditApi.GetCellValue(e.visibleIndex, "MfgDate");
                    var batchno = s.batchEditApi.GetCellValue(e.visibleIndex, "BatchNo");
                    var lotno = s.batchEditApi.GetCellValue(e.visibleIndex, "LotNo");
					var docdate = dtpDocDate.GetText();
                    console.log(itemcode);
                    var entry = getParameterByName('entry');
                    
                   
                    var Warehouse = aglWarehouseCode.GetText();
                    CSheet.SetContentUrl('../WMS/frmTRRSetup.aspx?entry=' + entry + '&docnumber=' + docnumber
                        + '&transtype=' + transtype
                        + '&linenumber=' + linenum
                        + '&refdocnum=' + refdocnum
                        + '&itemcode=' + encodeURIComponent(itemcode)
                        + '&colorcode=' + encodeURIComponent(colorcode)
                        + '&classcode=' + encodeURIComponent(classcode)
                        + '&sizecode=' + encodeURIComponent(sizecode)
                        + '&warehouse=' + encodeURIComponent(Warehouse)
                        + '&expdate=' + encodeURIComponent(convertDate(expdate))
                        + '&mfgdate=' + encodeURIComponent(convertDate(mfgdate))
                        + '&batchno=' + encodeURIComponent(batchno)
                        + '&lotno=' + encodeURIComponent(lotno)
                        + '&bulkqty=' + bulkqty
						+ '&docdate=' + encodeURIComponent(convertDate(docdate)));
                }
            }

            if (e.buttonID == "CloneButton") {
                if (!CINClone.GetText()) {
                    alert('Please input a number to Clone textbox!');
                    return;
                }

                cloneloading.Show();
                setTimeout(function () {
                    clonenumber = CINClone.GetText();
                    for (i = 1; i <= clonenumber; i++) {
                        cloneindex = e.visibleIndex;
                        copyFlag = true;
                        gv1.AddNewRow();
                        precopy(gv1, evn);
                    }
                }, 1000);
            }
        }


        function precopy(ss, ee) {
            if (copyFlag) {
                copyFlag = false;

                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCellsClone(0, ee, column, gv1);
                }
            }
        }


        function convertDate(str) {
            var date = new Date(str),
                mnth = ("0" + (date.getMonth() + 1)).slice(-2),
                day = ("0" + date.getDate()).slice(-2);
            return [date.getFullYear(), mnth, day].join("-");
        }


        function ProcessCellsClone(selectedIndex, e, column, s) {//Clone function :D
            if (selectedIndex == 0) {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, s.batchEditApi.GetCellValue(cloneindex, column.fieldName));
                if (column.fieldName == "LineNumber") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "");
                } 
            }
            cloneloading.Hide();
        }


        function precopy(ss, ee) {
            if (copyFlag) {
                copyFlag = false;

                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCellsClone(0, ee, column, gv1);
                }
            }
        }



        function ProcessCellsClone(selectedIndex, e, column, s) {//Clone function :D
            if (selectedIndex == 0) {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, s.batchEditApi.GetCellValue(cloneindex, column.fieldName));
                if (column.fieldName == "LineNumber") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "");
                }
            }
            cloneloading.Hide();
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

        function TaxCodeChange(s, e) {
            cp.PerformCallback('CallbackTaxCode');
            //autocalculate();
        }

        function OnGridFocusedRowChanged() {
            var grid = aglTaxCode.GetGridView();
            grid.GetRowValues(grid.GetFocusedRowIndex(), 'TaxCode;Rate', OnGetRowValues);
        }

        function OnGetRowValues(values) {
            console.log(values[0] + " values[0] " + values[1] + " values[1]")

            if (values[1] == null) {
                Rate.SetText("0.00");
                //Rate.SetValue(Math.abs(0).toFixed(2));
            }
            else {
                Rate.SetText(values[1]);
            }
            if (Rate.GetText() == "" || Rate.GetText() == null) {
                Rate.SetText("0.00");
            }

            //TaxCodeChange();
            Checktype();
            autocalculate();
        }

        function Checktype(s, e) {

            var type = "";
            var taxes = "";

            type = Type.GetText();
            taxes = aglTaxCode.GetText();

            console.log(taxes + "taxes");

            if (type == "Sales Return") {
                //Gross.ClientEnabled = false;
                //GrossNon.ClientEnabled = false;
                //aglWarehouseCode.ClientEnabled = true;
                Gross.GetInputElement().readOnly = true;
                GrossNon.GetInputElement().readOnly = true;
                //aglWarehouseCode.GetInputElement().readOnly = false;
            }

            if (type != "Sales Return") {

                aglSINumber.SetText("");

                if (taxes == "NONV") {
                    //Gross.SetText("0.00");
                    Gross.SetValue(Math.abs(0).toFixed(2))
                    //Gross.ClientEnabled = false;
                    //GrossNon.ClientEnabled = true;
                    Gross.GetInputElement().readOnly = true;
                    GrossNon.GetInputElement().readOnly = false;
                }

                if (taxes != "NONV") {
                    //Gross.ClientEnabled = true;
                    //GrossNon.ClientEnabled = true;
                    Gross.GetInputElement().readOnly = false;
                    GrossNon.GetInputElement().readOnly = false;
                }

                aglWarehouseCode.SetText("");
                //aglWarehouseCode.ClientEnabled = false;
                //aglWarehouseCode.GetInputElement().readOnly = true;
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
            var HGross = 0.00;
            var HGrossNon = 0.00;
            var HVAT = 0.00;
            var HTotal = 0.00;
            var HSum = 0.00;
            var HType = "";
            var HRate = 0.00;

            //for detail
            var DQty = 0.00;
            var DPrice = 0.00;
            var DVAT = ""
            var IsVat = ""


            setTimeout(function () {

                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                HType = Type.GetText();

                if (Rate.GetText() == null || Rate.GetValue() == null) {
                    HRate = 0;
                }
                else {
                    HRate = Rate.GetValue();
                }

                if (HType == "Sales Return") {
                    for (var i = 0; i < indicies.length; i++) {
                        if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                            DQty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                            DPrice = gv1.batchEditApi.GetCellValue(indicies[i], "Price");
                            DVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Vatable");

                            HSum += DQty * DPrice;

                            if (DVAT == true || DVAT == "True") {
                                HGross = HSum;
                            }
                            else {
                                HGrossNon = HSum;
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
                                DVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Vatable");

                                HSum += DQty * DPrice;

                                if (DVAT == true || DVAT == "True") {
                                    HGross = HSum;
                                }
                                else {
                                    HGrossNon = HSum;
                                }
                            }
                        }

                        if (aglTaxCode.GetText() == "NONV") {
                            HGross = 0;
                        }

                        ////Gross.SetText(HGross.format(2, 3, ',', '.'));
                        ////GrossNon.SetText(HGrossNon.format(2, 3, ',', '.'));
                        ////Gross.SetText(HGross.toFixed(2));
                        ////GrossNon.SetText(HGrossNon.toFixed(2));
                        //Gross.SetValue(HGross.toFixed(2));
                        //GrossNon.SetValue(HGrossNon.toFixed(2));
                        //VATAmount.SetText((HGross * HRate).format(2, 3, ',', '.'));
                        //TotalAmount.SetText((HGross + HGrossNon + (HGross * HRate)).format(2, 3, ',', '.'));

                        //6-8-2016  GC  Changed as requested by Kuya Jaboy
                        Gross.SetValue((Math.abs(HGross) * -1).toFixed(2));
                        GrossNon.SetValue((Math.abs(HGrossNon) * -1).toFixed(2));
                        VATAmount.SetText((Math.abs((HGross * HRate)) * -1).format(2, 3, ',', '.'));
                        TotalAmount.SetText((Math.abs((HGross + HGrossNon + (HGross * HRate))) * -1).format(2, 3, ',', '.'));
                    }
                }

                if (HType != "Sales Return") {
                    HGrossNon = Number(GrossNon.GetValue());
                    HGross = Number(Gross.GetValue());

                    if (aglTaxCode.GetText() == "NONV") {
                        HGross = 0;
                    }
                    else {
                        HGross = Number(Gross.GetValue());
                    }

                    if ((Gross.GetText() == "0.00" && HRate == "0.00") || (Gross.GetText() == "0.00" || HRate == "0.00")) {
                        VATAmount.SetText("0.00");
                        TotalAmount.SetText((HGross + HGrossNon).format(2, 3, ',', '.'));
                    }
                    else {
                        console.log(HRate + " rate to")
                        VATAmount.SetText((HGross * HRate).format(2, 3, ',', '.'));
                        TotalAmount.SetText((HGross + HGrossNon + (HGross * HRate)).format(2, 3, ',', '.'));
                    }
                    //console.log(HGross + " gross:" + HGrossNon + " nongross:" + HRate + "Rate")
                    console.log(Gross.GetValue() + " gross:" + GrossNon.GetValue() + " nongross:" + Rate.GetValue() + "Rate")
                }


            }, 100);
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
    <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxLabel runat="server" Text="AR Memo" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
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


    <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="True"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Modal="True" ContentStyle-HorizontalAlign="Center">
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
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" AutoCompleteType="Disabled" Enabled="False" ReadOnly="true" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnInit="dtpDocDate_Init" OnLoad="Date_Load" Width="170px" ClientInstanceName="dtpDocDate">
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
                                                    <dx:LayoutItem Caption="Type" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglType" runat="server" Width="170px" DataSourceID="sdsType" KeyFieldName="Description" OnLoad="LookupLoad" TextFormatString="{0}" ClientInstanceName="Type">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('CallbackType');}" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Customer Code">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglCustomerCode" ClientInstanceName="gsCustomerCode" runat="server" Width="170px" DataSourceID="sdsBizPartnerCus" 
                                                                    KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}" AutoGenerateColumns="False">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns> 
                                                                    <ClientSideEvents  Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('CallbackCustomer');}" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="VAT Code">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglTaxCode" runat="server" AutoGenerateColumns="False" ClientInstanceName="aglTaxCode" 
                                                                        DataSourceID="sdsTaxCode" KeyFieldName="TaxCode" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="TaxCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Rate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <GridViewClientSideEvents FocusedRowChanged ="function(s, e) { gv1.CancelEdit(); OnGridFocusedRowChanged(); }" />
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Name">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtName" runat="server" Width="170px" ReadOnly="True">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Rate">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speRate" runat="server" AllowMouseWheel="False" ClientInstanceName="Rate" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}" ReadOnly="True" Width="170px">
                                                                    <SpinButtons ShowIncrementButtons="False">
                                                                    </SpinButtons>
                                                                </dx:ASPxSpinEdit>
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
                                                    <dx:LayoutItem Caption="Warehouse Code" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglWarehouseCode" runat="server" ClientInstanceName="aglWarehouseCode" DataSourceID="sdsWarehouse" KeyFieldName="WarehouseCode" OnLoad="aglWarehouseCode_Load" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition ="Contains" />
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
                                                    <dx:LayoutItem Caption="Currency" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglCurrency" runat="server" Width="170px" DataSourceID="sdsCurrency" KeyFieldName="Currency" OnLoad="LookupLoad" TextFormatString="{0}" AutoGenerateColumns="False">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Currency" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CurrencyName" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition ="Contains" />
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
                                                    <dx:LayoutItem Caption="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="150px" Width="480px" OnLoad="Memo_Load">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Clone">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="SpinClone" runat="server" Increment="0" NullText="0"  MaxValue="9999999999" MinValue="0" Width="170px" ClientInstanceName="CINClone" SpinButtons-ShowIncrementButtons="false"> 
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Amount" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Gross Vatable Amount" Name="speGross" >
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speGross" runat="server" Width="170px" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00" AllowMouseWheel="False" 
                                                                     ClientInstanceName ="Gross" DisplayFormatString ="{0:N}" SpinButtons-ShowIncrementButtons="false" ReadOnly="true">
                                                                    <ClientSideEvents LostFocus="autocalculate" />
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="VAT Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtVAT" runat="server" Width="170px" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00" ReadOnly="true" AllowMouseWheel="False" 
                                                                    DecimalPlaces="2" MaxValue="9999999999" ClientInstanceName ="VATAmount" DisplayFormatString ="{0:N}" SpinButtons-ShowIncrementButtons="false">                                                                    
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Gross Non-Vatable Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speGrossNon" runat="server" Width="170px" NullDisplayText="0.00" ConvertEmptyStringToNull="False" ReadOnly="true" NullText="0.00" AllowMouseWheel="False" 
                                                                     ClientInstanceName ="GrossNon" DisplayFormatString ="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                                    <ClientSideEvents LostFocus="autocalculate" />
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Amount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtAmount" runat="server" Width="170px" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00" ReadOnly="true" ClientInstanceName ="TotalAmount" AllowMouseWheel="False" DecimalPlaces="2" MaxValue="9999999999" DisplayFormatString ="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                                 
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Reference Invoice" ColCount="1">
                                                <Items>
                                                    <dx:LayoutItem Caption="Sales Invoice No.">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                <dx:ASPxGridLookup ID="aglSINumber" runat="server" AutoGenerateColumns="False" DataSourceID="sdsSINumber" KeyFieldName="RecordNo" 
                                                                     OnLoad="LookupLoad" SelectionMode="Multiple" TextFormatString="{0}:{1}" ClientInstanceName="aglSINumber" OnInit="aglSINumber_Init" Width="900px">
                                                                    <GridViewProperties>                                                                        
                                                                        <SettingsBehavior AllowFocusedRow="True"/>
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="InvoiceNo" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0"  Settings-AutoFilterCondition="Contains">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1"  Settings-AutoFilterCondition="Contains">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="InvoiceDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2"  Settings-AutoFilterCondition="Contains">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransDoc" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3"  Settings-AutoFilterCondition="Contains">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4"  Settings-AutoFilterCondition="Contains">
                                                                                    <PropertiesTextEdit DisplayFormatString="MM/dd/yyyy"></PropertiesTextEdit>
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5"  Settings-AutoFilterCondition="Contains">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6"  Settings-AutoFilterCondition="Contains">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7"  Settings-AutoFilterCondition="Contains">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8"  Settings-AutoFilterCondition="Contains">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Unit" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9"  Settings-AutoFilterCondition="Contains">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Qty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="10"  Settings-AutoFilterCondition="Contains">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:N}"></PropertiesTextEdit>
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Price" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="11"  Settings-AutoFilterCondition="Contains">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:N}"></PropertiesTextEdit>
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="BulkQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="12"  Settings-AutoFilterCondition="Contains">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:N}"></PropertiesTextEdit>
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Remarks" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="13"  Settings-AutoFilterCondition="Contains">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="RecordNo" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="14"  Settings-AutoFilterCondition="Contains" Width="30">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <%--<ClientSideEvents ValueChanged="function(s,e){cp.PerformCallback('Details'); }" />--%>
                                                                </dx:ASPxGridLookup>
                                                                            </td>
                                                                        <td>
                                                                            <dx:ASPxLabel ID="lblSpace" runat="server" Text="" Width="10px">
                                                                            </dx:ASPxLabel>
                                                                        </td>
                                                                        <td>
		                                                                    <dx:ASPxButton ID="btnGenerate" runat="server" ClientInstanceName="btnGenerate" AutoPostBack="False" Width="100px" Theme="MetropolisBlue" Text="Populate Detail" OnLoad="Button_Load">
                                                                                <ClientSideEvents Click="function(s, e) { cp.PerformCallback('Details') }" />
                                                                            </dx:ASPxButton>
                                                                        </td>
                                                                        </tr>
                                                                    </table>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
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
                                    <dx:LayoutGroup Caption="Journal Entries">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvJournal" runat="server" AutoGenerateColumns="False" Width="850px" ClientInstanceName="gvJournal"  KeyFieldName="RTransType;TransType"  >
                                                            <ClientSideEvents Init="function (s, e){ OnInitTrans(); Checktype()}" BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  />
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
																<dx:GridViewDataTextColumn FieldName="Debit" Name="jDebit" ShowInCustomizationForm="True" VisibleIndex="6" Width ="120px" Caption="Debit  Amount" >
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Credit" Name="jCredit" ShowInCustomizationForm="True" VisibleIndex="7" Width ="120px" Caption="Credit Amount" >
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridView>
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
                            <dx:LayoutGroup Caption="AR Memo Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False"  Width="850px"
                                                    ClientInstanceName="gv1" OnBatchUpdate="gv1_BatchUpdate" OnCellEditorInitialize="gv1_CellEditorInitialize"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    OnInit="gv1_Init" OnRowValidating="grid_RowValidating" KeyFieldName ="RecordNo;LineNumber">
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" />                                                    
                                                    <SettingsPager Mode="ShowAllRecords" />  
                                                     <SettingsEditing Mode="Batch"/>
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false"
                                                            VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="70px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Details" >
                                                                   <Image IconID="support_info_16x16" ToolTip="Details"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="CountSheet">
                                                                   <Image IconID="arrange_withtextwrapping_topleft_16x16" ToolTip="Countsheet"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="CloneButton" Text="Copy">
                                                                    <Image IconID="edit_copy_16x16" ToolTip="Clone"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="80px" ReadOnly="true">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="InvoiceNo" Name="glpInvoiceNo" ShowInCustomizationForm="True" VisibleIndex="3" Caption="Invoice No">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="TransDoc" Name="glpTransDoc" ShowInCustomizationForm="True" VisibleIndex="4" Caption="Transaction No">                                                               
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" Name="glpItemCode" ShowInCustomizationForm="True" VisibleIndex="5" Caption="Item">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" Name="glpFullDesc" ShowInCustomizationForm="True" VisibleIndex="6" UnboundType="String" Caption="Item Description">                                                        
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="7" Caption="Color" ReadOnly="True">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ShowInCustomizationForm="True" VisibleIndex="8" Caption="Class">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Name="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9" Caption="Size">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Unit" Name="Unit" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="10" Caption="Unit">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Qty" Name="glpQty" ShowInCustomizationForm="True" UnboundType="Decimal" VisibleIndex="11" Caption="Quantity">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="Qty" AllowMouseWheel="False">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            <ClientSideEvents ValueChanged ="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Price" Name="glpUnitPrice" ShowInCustomizationForm="True" VisibleIndex="12">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="Price" AllowMouseWheel="False">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="BulkQty" Name="glpBulkQty" ShowInCustomizationForm="True" VisibleIndex="13">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" ClientInstanceName ="BulkQty" AllowMouseWheel="False">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataCheckColumn Caption="VAT" FieldName="Vatable" Name="glpVAT" ShowInCustomizationForm="True" VisibleIndex="14">
                                                            <PropertiesCheckEdit ClientInstanceName ="VAT" />
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="BaseQty" Name="glpBaseQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="15">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False">
                                                            <SpinButtons ShowIncrementButtons="False" Enabled="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="StatusCode" Name="glpStatusCode" ShowInCustomizationForm="True" VisibleIndex="16" ReadOnly="True">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BarcodeNo" Name="glpBarcodeNo" ShowInCustomizationForm="True" VisibleIndex="17" ReadOnly="True">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitFactor" Name="glpUnitFactor" ShowInCustomizationForm="True" VisibleIndex="18" Caption="Unit Factor" >
                                                            <PropertiesSpinEdit Increment="0"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" NullText="0.0000" NullDisplayText="0.000">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        
                                                        <dx:GridViewDataDateColumn FieldName="ExpDate" Name="dtpExpDate" ShowInCustomizationForm="True" VisibleIndex="19">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn FieldName="MfgDate" Name="dtpMfgDate" ShowInCustomizationForm="True" VisibleIndex="20">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BatchNo" Name="txtBatchNo" ShowInCustomizationForm="True" VisibleIndex="21">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LotNo" Name="txtLotNo" ShowInCustomizationForm="True" VisibleIndex="22">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" VisibleIndex="23" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" VisibleIndex="24" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" VisibleIndex="25" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" VisibleIndex="26" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" VisibleIndex="27" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" VisibleIndex="29" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="30" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Version" Name="glpVersion" ShowInCustomizationForm="True" VisibleIndex="32" UnboundType="String" Width="0">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="RefTransType" Name="glpRefTransType" ShowInCustomizationForm="True" VisibleIndex="33" UnboundType="String" Width="0">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="RecordNo" Name="glpRecordNo" ShowInCustomizationForm="True" VisibleIndex="34" UnboundType="String" Width="0">
                                                        </dx:GridViewDataTextColumn>
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
                    
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel2" runat="server" Text="Cloning..." ClientInstanceName="cloneloading" ContainerElementID="gv1" Modal="true" ImagePosition="Left">
		    <LoadingDivStyle Opacity="0"></LoadingDivStyle>
	    </dx:ASPxLoadingPanel>
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
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" AutoPostBack="False" UseSubmitBehavior="false">
                                 <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                 </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" AutoPostBack="False" UseSubmitBehavior="false">
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
    
<form id="form2" runat="server" visible="false">
    <!--#region Region Datasource-->
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.ARMemo" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.ARMemo" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.ARMemo+ARMemoDetail" SelectMethod="getdetail" UpdateMethod="UpdateARMemoDetail" TypeName="Entity.ARMemo+ARMemoDetail" DeleteMethod="DeleteARMemoDetail" InsertMethod="AddARMemoDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.ARMemo+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.ARMemo+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <%--<asp:SqlDataSource ID="sdsBizPartnerCus" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT BizPartnerCode, Name FROM Masterfile.BPCustomerInfo WHERE ISNULL(IsInActive,0)=0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Accounting.ARMemoDetail WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item]" OnInit ="Connection_Init"></asp:SqlDataSource>  
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT B.ItemCode, ColorCode, ClassCode,SizeCode,UnitBase AS Unit,FullDesc, UnitBulk AS BulkUnit FROM Masterfile.[Item] A INNER JOIN Masterfile.[ItemDetail] B ON A.ItemCode = B.ItemCode where isnull(A.IsInactive,0)=0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSINumber" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT B.LineNumber, A.DocNumber AS InvoiceNo, A.DocDate AS InvoiceDate, B.TransDoc, B.TransDate, B.ItemCode, B.ColorCode, B.ClassCode, B.SizeCode, B.Unit, Qty, Price, BulkQty, Remarks from Accounting.SalesInvoice A INNER JOIN Accounting.SalesInvoiceDetail B ON A.DocNumber = B.DocNumber WHERE ISNULL(SubmittedBy,'') != '' " OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTransDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT RIGHT('00000'+ CAST(ROW_NUMBER() OVER (ORDER BY A.DocNumber) AS VARCHAR(5)),5) AS LineNumber, A.DocNumber AS InvoiceNo, B.TransDoc, B.ItemCode, C.FullDesc ,B.ColorCode, B.ClassCode, B.SizeCode, B.Unit, Qty, Price, B.BulkQty,
                            Vatable, B.BaseQty, B.StatusCode, B.BarcodeNo, B.UnitFactor, B.Field1, B.Field2, B.Field3, B.Field4, B.Field5, B.Field6, B.Field7, B.Field8, B.Field9, '2' AS Version, B.TransType AS RefTransType from Accounting.SalesInvoice A INNER JOIN Accounting.SalesInvoiceDetail B ON A.DocNumber = B.DocNumber 
                            INNER JOIN Masterfile.Item C ON B.ItemCode = C.ItemCode WHERE ISNULL(A.SubmittedBy,'') != ''" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Description FROM IT.GenericLookup WHERE LookUpKey ='ARMEMOTYP'" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTaxCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TCode AS TaxCode, Description, ISNULL(Rate,0) AS Rate FROM Masterfile.Tax WHERE ISNULL(IsInactive,0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCurrency" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Currency, CurrencyName FROM Masterfile.Currency WHERE ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.Warehouse WHERE ISNULL([IsInactive],0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    --%>
    <asp:SqlDataSource ID="sdsBizPartnerCus" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT BizPartnerCode, Name FROM Masterfile.BPCustomerInfo WHERE ISNULL(IsInActive,0)=0" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Accounting.ARMemoDetail WHERE DocNumber IS NULL" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item]" ></asp:SqlDataSource>  
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT B.ItemCode, ColorCode, ClassCode,SizeCode,UnitBase AS Unit,FullDesc, UnitBulk AS BulkUnit FROM Masterfile.[Item] A INNER JOIN Masterfile.[ItemDetail] B ON A.ItemCode = B.ItemCode where isnull(A.IsInactive,0)=0"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSINumber" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.DocNumber AS InvoiceNo,B.LineNumber, A.DocDate AS InvoiceDate, B.TransDoc, B.TransDate, B.ItemCode, B.ColorCode, B.ClassCode, B.SizeCode, B.Unit, Qty, Price, BulkQty, Remarks, B.RecordNo from Accounting.SalesInvoice A INNER JOIN Accounting.SalesInvoiceDetail B ON A.DocNumber = B.DocNumber WHERE ISNULL(SubmittedBy,'') != '' " ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTransDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT RIGHT('00000'+ CAST(ROW_NUMBER() OVER (ORDER BY A.DocNumber) AS VARCHAR(5)),5) AS LineNumber, A.DocNumber AS InvoiceNo, B.TransDoc, B.ItemCode, C.FullDesc ,B.ColorCode, B.ClassCode, B.SizeCode, B.Unit, Qty, Price, B.BulkQty,
                            Vatable, B.BaseQty, B.StatusCode, B.BarcodeNo, B.UnitFactor, B.Field1, B.Field2, B.Field3, B.Field4, B.Field5, B.Field6, B.Field7, B.Field8, B.Field9, '2' AS Version, B.TransType AS RefTransType, B.RecordNo, CAST(NULL AS Date) AS ExpDate, CAST(NULL AS Date) AS MfgDate, '' AS BatchNo, '' AS LotNo from Accounting.SalesInvoice A INNER JOIN Accounting.SalesInvoiceDetail B ON A.DocNumber = B.DocNumber 
                            INNER JOIN Masterfile.Item C ON B.ItemCode = C.ItemCode WHERE ISNULL(A.SubmittedBy,'') != ''" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Description FROM IT.GenericLookup WHERE LookUpKey ='ARMEMOTYP'" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTaxCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT TCode AS TaxCode, Description, ISNULL(Rate,0) AS Rate FROM Masterfile.Tax WHERE ISNULL(IsInactive,0) = 0" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCurrency" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Currency, CurrencyName FROM Masterfile.Currency WHERE ISNULL(IsInactive,0) = 0"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.Warehouse WHERE ISNULL([IsInactive],0) = 0" ></asp:SqlDataSource>
    <!--#endregion-->
    </form> 
</body>
</html>


