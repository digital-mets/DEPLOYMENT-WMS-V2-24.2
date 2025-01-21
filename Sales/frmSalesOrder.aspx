<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmSalesOrder.aspx.cs" Inherits="GWL.frmSalesOrder" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Sales Order</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /> 
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script> 
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script> 
    <script src="../js/keyboardNavi.js" type="text/javascript"></script>
    <style type="text/css">
         
        #form1 {
        height: 1000px; 
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
         
        .statusBar a:first-child
        {
            display: none;
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

        function OnInitTrans(s, e) {
            var BizPartnerCode = dsCustomerCode.GetText();
          
            OnInit(s);
            factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);

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
            
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            var cntdetails = indicies.length;
            for (var i = 0; i < indicies.length; i++) {
                var key = gv1.GetRowKey(indicies[i]);
                if (!gv1.batchEditApi.IsDeletedRow(key)) {
                    gv1.batchEditApi.ValidateRow(indicies[i]);
                    gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("ItemCode").index);
                }
            }

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
            }


        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        var vatrate = 0;
        var vatdetail1 = 0;

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            
            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);
                if (s.cp_forceclose) {//NEWADD
                    delete (s.cp_forceclose);
                    window.close();
                }
                gv1.CancelEdit();

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
                gv1.CancelEdit();
                autocalculate();
            }

            if (s.cp_calculateonly) {
                delete (s.cp_calculateonly);
                autocalculate();
            }

            if (s.cp_unitcost) {
                delete (s.cp_unitcost);
            }

            if (s.cp_vatrate != null) {

                vatrate = s.cp_vatrate;
                delete (s.cp_vatrate);
                vatdetail1 = 1 + parseFloat(vatrate);
            }

            if (s.cp_iswithdr == "1") {
                RefQuote.SetEnabled(true);
            }
            else if (s.cp_iswithdr == "0") {
                RefQuote.SetEnabled(false);
                RefQuote.SetText(null);
            }

            //ADDED NEW
            if (s.cp_closeSH) {
                delete (s.cp_closeSH);
                SizeHorizontalPopup.Hide();
                gvSizeHorizontal.CancelEdit();
                gvSizes.CancelEdit(); 
                autocalculate();
                console.log('1');
            }

            if (s.cp_RefreshSizeGrid) {
                delete (s.cp_RefreshSizeGrid);
                PopulateSizes(); 
            }
        }

        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = s.GetColumn(i);
                var chckd;
                var chckd2;
                var bulk;
                var bulk2;

                if (column.fieldName == "IsVAT") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (value == true) {
                        chckd2 = true;
                    }
                }
                if (column.fieldName == "VATCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == "NONV") && chckd2 == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required!";
                        isValid = false;
                    }
                }
                if (column.fieldName == "OrderQty") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "0" || ASPxClientUtils.Trim(value) == "0.00" || ASPxClientUtils.Trim(value) == null)) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required!";
                        isValid = false;
                    }
                }

                if (column.fieldName == "IsByBulk") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;               
                    if (value == true) {
                        bulk2 = true;
                    }
                }
                //if (column.fieldName == "BulkQty") {
                //    var cellValidationInfo = e.validationInfo[column.index];
                //    if (!cellValidationInfo) continue;
                //    var value = cellValidationInfo.value;
                //    if ((!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == null) && bulk2 == true) {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = column.fieldName + " is required";
                //        isValid = false;
                //    }
                //}
                if (column.fieldName == "BulkUnit") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == null) && bulk2 == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
                if (column.fieldName == "ColorCode" || column.fieldName == "ClassCode" || column.fieldName == "SizeCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required!";
                        isValid = false;
                    }
                }

            }
        }

        var index;
        var closing;
        var itemc;

        //ADDED NEW
        var itemclr;
        var itemcls;
        var itemsze;
        var itemdesc;
        var itemunit;
        var itemqty;
        var itemprice;

        var itemVAT;
        var itemIsVAT;
        var itembulk;
        var itemIsBulk;



        var valchange = false;
        var valchange_VAT = false;
        var valchange_Subs = false;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var editorobj;
        var nope = false;
        var itemtab = false;
        var canceledit = false;
        var obje;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            obje = e;

            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
            //ADDED NEW
            itemclr = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
            itemcls = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
            itemsze = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
            itemdesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
            itemunit = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
            itemqty = s.batchEditApi.GetCellValue(e.visibleIndex, "OrderQty");
            itemprice = s.batchEditApi.GetCellValue(e.visibleIndex, "UnitPrice");
            itemVAT = s.batchEditApi.GetCellValue(e.visibleIndex, "VATCode");
            itemIsVAT = s.batchEditApi.GetCellValue(e.visibleIndex, "IsVAT");
            itembulk = s.batchEditApi.GetCellValue(e.visibleIndex, "BulkUnit");
            itemIsBulk = s.batchEditApi.GetCellValue(e.visibleIndex, "IsByBulk");

            index = e.visibleIndex;
            
            obje = e;

            var entry = getParameterByName('entry');

            if (entry == "V" || entry == "D") {
                e.cancel = true; //this will made the gridview readonly
            }

            //ADDED NEW
            editorobj = e; 
            if (canceledit) {
                e.cancel = true;
            }

            
            if (e.focusedColumn.fieldName === "LineNumber" || e.focusedColumn.fieldName === "FullDesc" || e.focusedColumn.fieldName === "DeliveredQty"
                || e.focusedColumn.fieldName === "SubstituteItem" || e.focusedColumn.fieldName === "SubstituteColor" || e.focusedColumn.fieldName === "SubstituteClass" || e.focusedColumn.fieldName === "SubstituteSize"
                || e.focusedColumn.fieldName === "BaseQty" || e.focusedColumn.fieldName === "StatusCode" || e.focusedColumn.fieldName === "BarcodeNo"
                || e.focusedColumn.fieldName === "UnitFactor") {
                e.cancel = true;
            }

            if (e.focusedColumn.fieldName === "DocNumberX" || e.focusedColumn.fieldName === "ItemCodeX" || e.focusedColumn.fieldName === "ColorCodeX"
                || e.focusedColumn.fieldName === "ClassCodeX" || e.focusedColumn.fieldName === "SizeCodeX" || e.focusedColumn.fieldName === "ClassCodeX"
                || e.focusedColumn.fieldName === "OrderQtyX" || e.focusedColumn.fieldName === "UnitPriceX" || e.focusedColumn.fieldName === "FullDescX"
                || e.focusedColumn.fieldName === "BulkUnitX" || e.focusedColumn.fieldName === "IsByBulkX") {
                e.cancel = true;
            }

            if (entry != "V") {
                if (e.focusedColumn.fieldName === "VATCode") {
                    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsVAT") == false) {
                        e.cancel = true;
                    }
                    else {
                        glVATCode.GetInputElement().value = cellInfo.value; //Gets the column value
                        isSetTextRequired = true;
                    }
                }

                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    
                    closing = true;
                }
                if (e.focusedColumn.fieldName === "ColorCode") {
                    gl2.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "ClassCode") {
                    gl3.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "SizeCode") {
                    gl4.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                }
                if (e.focusedColumn.fieldName === "Unit") {
                    gl5.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "BulkUnit") {
                    gl6.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "IsVAT") {
                    glIsVAT.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "IsByBulk") {
                    glIsByBulk.GetInputElement().value = cellInfo.value;
                }
            }

            keybGrid = s;
            keyboardOnStart(e);
        }

        var indexxxx = null;
        function OnEndEditing(s, e) { 
            var cellInfo = e.rowValues[currentColumn.index];
            indexxxx = e.focusedColumn;

            var entry = getParameterByName('entry');

            if (currentColumn.fieldName === "ItemCode") {
                cellInfo.value = gl.GetValue();
                cellInfo.text = gl.GetText().toUpperCase();
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
            if (currentColumn.fieldName === "Unit") {
                cellInfo.value = gl5.GetValue();
                cellInfo.text = gl5.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "BulkUnit") {
                cellInfo.value = gl6.GetValue();
                cellInfo.text = gl6.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "VATCode") {
                cellInfo.value = glVATCode.GetValue();
                cellInfo.text = glVATCode.GetText();
            }
            if (currentColumn.fieldName === "IsVAT") {
                cellInfo.value = glIsVAT.GetValue();
            }
            if (currentColumn.fieldName === "IsByBulk") {
                cellInfo.value = glIsByBulk.GetValue();
            }
            keyboardOnEnd();
        }

        var val;
        var temp;
        var val_VAT;
        var temp_VAT;

        //ADDED NEW
        var val_Subs;
        var temp_Subs;

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
            if (temp[9] == null) {
                temp[9] = "";
            }
            if (temp[10] == null) {
                temp[10] = "";
            }
            //ADDED NEW
            if (temp[11] == null) {
                temp[11] = "";
            }
            if (temp[12] == null) {
                temp[12] = "";
            }
            if (temp[13] == null) {
                temp[13] = "";
            }
            if (temp[14] == null) {
                temp[14] = "";
            }
            if (temp[15] == null) {
                temp[15] = "";
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
                if (column.fieldName == "Unit") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
                }
                if (column.fieldName == "FullDesc") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
                }
                if (column.fieldName == "BulkUnit") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
                }
                if (column.fieldName == "IsByBulk") {
                    if (temp[6] == "True") {
                        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsByBulk.SetChecked = true);
                    }
                    else {
                        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsByBulk.SetChecked = false);
                    }
                }
                if (column.fieldName == "StatusCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[7]);
                }
                if (column.fieldName == "UnitPrice") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[8]);
                }
                //ADDED NEW
                //if (column.fieldName == "VATCode") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[9]);
                //}
                //if (column.fieldName == "IsVAT") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsVAT.SetChecked = false);
                //} 
                if (column.fieldName == "DiscountRate") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[9]);
                }
                if (column.fieldName == "VATCode") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[10]);
                }
                if (column.fieldName == "IsVAT") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsVAT.SetChecked = false);
                }
                if (column.fieldName == "SubstituteItem") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[12]);
                }
                if (column.fieldName == "SubstituteColor") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[13]);
                }
                if (column.fieldName == "SubstituteClass") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[14]);
                }
                if (column.fieldName == "SubstituteSize") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[15]);
                }
            }
        }


        //genrev
        var identifier;
        function GridEndChoice(s, e) {

            identifier = s.GetGridView().cp_identifier;
            val = s.GetGridView().cp_codes;
            temp = val.split(';');
            val_VAT = s.GetGridView().cp_codes;
            temp_VAT = val_VAT.split(';');


             
            if (identifier == "ItemCode") {
                gv1.batchEditApi.EndEdit();
                delete (s.GetGridView().cp_identifier);
                if (s.GetGridView().cp_valch) {
                    delete (s.GetGridView().cp_valch);

                    for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                        var column = gv1.GetColumn(i);
                        if (column.visible == false || column.fieldName == undefined)
                            continue;
                        ProcessCells(0, obje, column, gv1);
                    }

                    var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                    for (var i = 0; i > -gv1.GetVisibleRowsOnPage() ; i--) {
                        gv1.batchEditApi.ValidateRow(-1);
                       
                    }
                    gv1.batchEditApi.EndEdit();
                

                    gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField('ColorCode').index)
                }
                

            }



                if (identifier == 'Subs') {
                    if (s.keyFieldName == 'ItemCode' && (itemc == null || itemc == '')) {
                        s.SetText('');
                    }
                    else if (s.keyFieldName == 'ItemCode' && (itemc != null && itemc != '')) {
                        s.SetText(itemc);
                    }
                    if (s.keyFieldName == 'ColorCode' && (itemclr == null || itemclr == '')) {
                        s.SetText("");
                    }
                    if (s.keyFieldName == 'ClassCode' && (itemcls == null || itemcls == "")) {
                        s.SetText("");
                    }
                    if (s.keyFieldName == 'SizeCode' && (itemsze == null || itemsze == "")) {
                        s.SetText("");
                    }
                    delete (s.GetGridView().cp_identifier);
                }

                if (identifier == "VAT") {
                    GridEnd_VAT();
                    gv1.batchEditApi.EndEdit();
                }
                //ADDED NEW
                if (identifier == "Subs") {
                    GridEnd_Subs(); 
                } 
                loading = false;
                loader.Hide();
        }
        
        //var identifier;
        //function GridEndChoice(s, e) {
        //    identifier = s.GetGridView().cp_identifier;
        //    val = s.GetGridView().cp_codes;
        //    //ADDED NEW
        //    delete (s.GetGridView().cp_identifier);
        //    if (val == null) { val = ";;;;;;;;;;;;;" }

        //    temp = val.split(';');
        //    val_VAT = s.GetGridView().cp_codes;
        //    //ADDED NEW
        //    if (val_VAT == null) { val_VAT = ";" }

        //    temp_VAT = val_VAT.split(';');

        //    //ADDED NEW
        //    val_Subs = s.GetGridView().cp_codes;
        //    if (val_Subs == null) { val_Subs = ";;;" }
        //    temp_Subs = val_Subs.split(';');
        //    delete (s.GetGridView().cp_codes);
             

        //    //if (s.GetGridView().cp_valch) {
        //    //    delete (s.GetGridView().cp_valch);
        //    //    for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
        //    //        var column = gv1.GetColumn(i);
        //    //        if (column.visible == false || column.fieldName == undefined)
        //    //            continue;
        //    //        ProcessCells(0, editorobj, column, gv1);
        //    //    }
        //    //    closing = true;
        //    //}



        //    if (identifier == "ItemCode") {

        //        gv1.batchEditApi.EndEdit();
        //        delete (s.GetGridView().cp_identifier);
        //        console.log(cp_valch);
        //        if (s.GetGridView().cp_valch) {

        //            delete (s.GetGridView().cp_valch);

        //            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
        //                var column = gv1.GetColumn(i);
        //                if (column.visible == false || column.fieldName == undefined)
        //                    continue;
        //                ProcessCells(0, obje, column, gv1);
        //            }

        //            var indicies = gv1.batchEditApi.GetRowVisibleIndices();

        //            for (var i = 0; i > -gv1.GetVisibleRowsOnPage() ; i--) {
        //                gv1.batchEditApi.ValidateRow(-1);
        //            }
        //            gv1.batchEditApi.EndEdit();

        //            gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField('ColorCode').index)
        //        }

        //    }


        //    if (identifier == 'Subs') {
        //        if (s.keyFieldName == 'ItemCode' && (itemc == null || itemc == '')) {
        //            s.SetText('');
        //        }
        //        else if (s.keyFieldName == 'ItemCode' && (itemc != null && itemc != '')) {
        //            s.SetText(itemc);
        //        }
        //        if (s.keyFieldName == 'ColorCode' && (itemclr == null || itemclr == '')) {
        //            s.SetText("");
        //        }
        //        if (s.keyFieldName == 'ClassCode' && (itemcls == null || itemcls == "")) {
        //            s.SetText("");
        //        }
        //        if (s.keyFieldName == 'SizeCode' && (itemsze == null || itemsze == "")) {
        //            s.SetText("");
        //        }
        //        delete (s.GetGridView().cp_identifier);
        //    }

        //    //ADDED NEW
        //    //if (identifier == "ItemCode") {
        //    //    GridEnd();
        //    //} 






        //    //if (identifier == "ItemCode")
        //    //{
        //    //    gv1.batchEditApi.EndEdit();
        //    //    delete (s.GetGridView().cp_identifier);
        //    //    if (s.GetGridView().cp_valch) {
        //    //        delete (s.GetGridView().cp_valch);

        //    //        for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
        //    //            var column = gv1.GetColumn(i);
        //    //            if (column.visible == false || column.fieldName == undefined)
        //    //                continue;
        //    //            ProcessCells(0, obje, column, gv1);
        //    //        }

        //    //        var indicies = gv1.batchEditApi.GetRowVisibleIndices();
        //    //        for (var i = 0; i < indicies.length; i++) {
        //    //            var key = gv1.GetRowKey(indicies[i]);
        //    //            if (!gv1.batchEditApi.IsDeletedRow(key)) {
        //    //                gv1.batchEditApi.ValidateRow(indicies[i]);
        //    //                gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("ItemCode").index);
        //    //            }
        //    //        }

        //    //        gv1.batchEditApi.EndEdit();
        //    //    }
        //    //}

        //    if (identifier == "VAT") {
        //        GridEnd_VAT();
        //        gv1.batchEditApi.EndEdit();
        //    }
        //    //ADDED NEW
        //    if (identifier == "Subs") {
        //        GridEnd_Subs(); 
        //    } 
        //    loading = false;
        //    loader.Hide();
        //}

        //ADDED NEW
        function GridEnd(s, e) {
            if (closing == true) {
                for (var i = 0; i > -gv1.GetVisibleRowsOnPage() ; i--) {
                    gv1.batchEditApi.ValidateRow(-1); 
                } 
                closing = false;
                canceledit = false;
                gv1.batchEditApi.StartEdit(index, gv1.GetColumnByField('ColorCode').index)
            }
        }
        //function GridEnd(s, e) {
        //        for (var i = 0; i > -gv1.GetVisibleRowsOnPage() ; i--) {
        //            gv1.batchEditApi.ValidateRow(-1);
        //            gv1.batchEditApi.StartEdit(i, gv1.GetColumnByField("ColorCode").index);
        //        }
        //        gv1.batchEditApi.EndEdit();
        //}
        
        
        function GridEnd_VAT(s, e) {
            if (valchange_VAT) {
                valchange_VAT = false;
                var column = gv1.GetColumn(6);
                ProcessCells_VAT(0, index, column, gv1);
            }
        }

        //ADDED NEW
        function GridEnd_Subs(s, e) {
            if (valchange_Subs) {
                valchange_Subs = false;
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    ProcessCells_Subs(0, index, column, gv1);
                    gv1.batchEditApi.EndEdit();
                }
            }
        }
        
        function ProcessCells_VAT(selectedIndex, focused, column, s) { 
            if (val_VAT == null) {
                val_VAT = ";";
                temp_VAT = val_VAT.split(';');
            }
            if (temp_VAT[0] == null) {
                temp_VAT[0] = 0;
            }
            if (selectedIndex == 0) { 
                s.batchEditApi.SetCellValue(focused, "Rate", temp_VAT[0]);
                autocalculate();
            }
        }

        //ADDED NEW
        function ProcessCells_Subs(selectedIndex, focused, column, s) {//Auto calculate qty function :D
            if (val_Subs == null) {
                val_Subs = ";;;;";
                temp_Subs = val_Subs.split(';');
            }
            if (temp_Subs[0] == null) {
                temp_Subs[0] = "";
            }
            if (temp_Subs[1] == null) {
                temp_Subs[1] = "";
            }
            if (temp_Subs[2] == null) {
                temp_Subs[2] = "";
            }
            if (temp_Subs[3] == null) {
                temp_Subs[3] = "";
            }
            if (temp_Subs[4] == null) {
                temp_Subs[4] = "";
            }
            if (temp_Subs[5] == null) {
                temp_Subs[5] = "";
            } 
            if (selectedIndex == 0) {
                if (column.fieldName == "UnitPrice") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_Subs[0]);
                }
                if (column.fieldName == "DiscountRate") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_Subs[1]);
                }
                if (column.fieldName == "SubstituteItem") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_Subs[2]);
                }
                if (column.fieldName == "SubstituteColor") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_Subs[3]);
                }
                if (column.fieldName == "SubstituteClass") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_Subs[4]);
                }
                if (column.fieldName == "SubstituteSize") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_Subs[5]);
                }
            } 
        }

        function lookup(s, e) {
            if (isSetTextRequired) {//Sets the text during lookup for item code
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
            }
        }

        //ADDED NEW
        function gridLookup_KeyDown2(s, e) {  
            isSetTextRequired = false;
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode !== 9) return;
            if (itemc != gl.GetValue()) {
                canceledit = true;
            }
            else {
                var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
                if (gv1.batchEditApi[moveActionName]()) {
                    ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);

                }
            }
        } 
        function gridLookup_KeyDown(s, e) {
            isSetTextRequired = false;
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode !== ASPxKey.Tab) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (gv1.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
        }
        //function gridLookup_KeyDown(s, e) { 
        //    isSetTextRequired = false;
        //    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
        //    if (keyCode !== 9) return;
        //    var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
        //    if (gv1.batchEditApi[moveActionName]()) {
        //        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        //    }
        //}

        function gridLookup_KeyPress(s, e) { 
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == 13) {
                gv1.batchEditApi.EndEdit();
            }
        }
     

        function gridLookup_CloseUp(s, e) { 
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
                var Warehouse = ""; 
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&Warehouse=' + Warehouse);
            }
            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate();
                detailautocalculate();
            }
            if (e.buttonID == "ViewTransaction") { 
                var transtype = s.batchEditApi.GetCellValue(e.visibleIndex, "TransType");
                var docnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "DocNumber");
                var commandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "CommandString"); 
                window.open(commandtring + '?entry=V&transtype=' + transtype + '&parameters=&iswithdetail=true&docnumber=' + docnumber, '_blank', "", false);
            }
            if (e.buttonID == "ViewReferenceTransaction") { 
                var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
                var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
                var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
                window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
            }
        }


        function endcp(s, e) {
            var endg = s.GetGridView().cp_endgl1;
            if (endg == true) { 
                sup_cp_Callback.PerformCallback(aglCustomerCode.GetValue().toString());
                e.processOnServer = false;
                endg = null;
            }
        }

        function checkedchanged(s, e) {
            var checkState = cbiswithdr.GetChecked();
            if (checkState == true) {
                cp.PerformCallback('iswithquotetrue');
                e.processOnServer = false;
            }
            else {
                txtVatAmount.SetText("0.00");
                txtTotalQtyU.SetText("0.0000");
                txtTotalAmount.SetText("0.00");
                txtForeignAmount.SetText("0.00");
                txtGrossVATableAmount.SetText("0.00");
                txtnonvat.SetText("0.00");
                cp.PerformCallback('iswithquotefalse'); 
                e.processOnServer = false;
            }
        }

        function Frieght(s, e) {
            detailautocalculate();
            autocalculate();
        }

        var chk = 0;
        function DataSourceCheck(s, e) {
            var entry = getParameterByName('entry');
            console.log(entry)
            if (entry != 'V' || entry != 'D') {
                if (chk == 0) {
                    cp.PerformCallback('CallbackDataSourceCheck');
                    chk = 1;
                }
            }
           // OnInitTrans();
        }

        function VATCheckChange(s, e) { 
            gv1.batchEditApi.EndEdit();

            if(s.GetChecked() == false){
                gv1.batchEditApi.SetCellValue(index, 'VATCode', 'NONV');
                gv1.batchEditApi.SetCellValue(index, 'Rate', '0');
            } 
            autocalculate();
        }

        //ADDED NEW START
        function Trim(x) {
            if (x != null || x != undefined)
                return x.replace(/^\s+|\s+$/gm, '');
            else
                return '';
        }
        function ShowSizeHorizontal(s, e) { 
            var hIndex = gv1.batchEditApi.GetRowVisibleIndices();
            var hLength = hIndex.length;

            var getQty = 0.00;
            var getPrice = 0.00;

            for (var a = 0; a < hLength; a++) {
                var item = '';
                var color = '';
                var cls = '';
                var qty = 0.00;
                var price = 0.00;
                var gvDetail = '';
                var detail = Trim(itemc) + '|' + Trim(itemclr) + '|' + Trim(itemcls);

                item = gv1.batchEditApi.GetCellValue(hIndex[a], "ItemCode");
                color = gv1.batchEditApi.GetCellValue(hIndex[a], "ColorCode");
                cls = gv1.batchEditApi.GetCellValue(hIndex[a], "ClassCode");
                qty = gv1.batchEditApi.GetCellValue(hIndex[a], "OrderQty");
                price = gv1.batchEditApi.GetCellValue(hIndex[a], "UnitPrice");

                gvDetail = Trim(item) + '|' + Trim(color) + '|' + Trim(cls);

                if (gvDetail == detail) {
                    getQty += qty;
                    getPrice += price;
                }
            }
            itemprice = getPrice;
            itemqty = getQty;
             
            if (itemqty == null || isNaN(itemqty) || itemqty == '') {
                itemqty = 0;
            }

            if (itemprice == null || isNaN(itemprice) || itemprice == '') {
                itemprice = 0;
            }

            if (itemIsBulk == null || itemIsBulk == '') {
                itemIsBulk = false;
            }

            SizeHorizontalPopup.Show();
            cp.PerformCallback('CallbackSizeHorizontal|' + itemc + '|' + itemclr + '|' + itemcls + '|' + itemqty + '|' + itemprice + '|' + itemunit + '|' + itemdesc + '|' + itembulk + '|' + itemIsBulk);
            gvSizeHorizontal.CancelEdit();
            e.processOnServer = false;
        }

        function PopulateSizes(s, e) {
            var hIndex = gv1.batchEditApi.GetRowVisibleIndices();
            var hLength = hIndex.length;

            var sIndex = gvSizes.batchEditApi.GetRowVisibleIndices();
            var sLength = sIndex.length;
            var sCol = gvSizes.GetColumnsCount();

            for (var x = 1; x < sCol; x++) {

                var sizex = "";
                var qtyx = 0.00;
                var column = gvSizes.GetColumn(x);
                var detail = Trim(itemc) + '|' + Trim(itemclr) + '|' + Trim(itemcls) + '|' + Trim(column.fieldName)
                var getQty = 0.00;

                for (var a = 0; a < hLength; a++) {

                    var item = '';
                    var color = '';
                    var cls = '';
                    var size = '';
                    var qty = 0.00;
                    var gvDetail = '';

                    item = gv1.batchEditApi.GetCellValue(hIndex[a], "ItemCode");
                    color = gv1.batchEditApi.GetCellValue(hIndex[a], "ColorCode");
                    cls = gv1.batchEditApi.GetCellValue(hIndex[a], "ClassCode");
                    size = gv1.batchEditApi.GetCellValue(hIndex[a], "SizeCode");
                    qty = gv1.batchEditApi.GetCellValue(hIndex[a], "OrderQty");

                    gvDetail = Trim(item) + '|' + Trim(color) + '|' + Trim(cls) + '|' + Trim(size);

                    if (gvDetail == detail) {
                        getQty += qty;
                    }
                }

                gvSizes.batchEditApi.SetCellValue(0, column.fieldName, getQty);
            }
        }

        var arrayGrid = new Array();
        var arrayGrid2 = new Array();
        var arrayGL = new Array();
        var arrayGL2 = new Array();
        var OnConf = false;
        var glText;
        var ValueChanged = false;
        var deleting = false;
        var SizeQty = 0;

        function isInArray(value, array) {
            return array.indexOf(value) > -1;
        }

        function CallbackSize(s, e) {
            var itemx = "";
            var colorx = "";
            var classx = "";
            var descx = "";
            var unitx = "";
            var bulkunitx = "";
            var bybulkx;
            var pricex = 0;
            var query = "";
            var cnt = 0;
            var gvIndex = gv1.batchEditApi.GetRowVisibleIndices();
            var gvLength = gvIndex.length;
            var hIndex = gvSizeHorizontal.batchEditApi.GetRowVisibleIndices();
            var sIndex = gvSizes.batchEditApi.GetRowVisibleIndices();
            var sLength = sIndex.length;
            var sCol = gvSizes.GetColumnsCount();

            itemx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "ItemCodeX");
            descx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "FullDescX");
            colorx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "ColorCodeX");
            classx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "ClassCodeX");
            unitx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "UnitX");
            pricex = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "UnitPriceX");
            bulkunitx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "BulkUnitX");
            bybulkx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "IsByBulkX");

            for (var b = 1; b < sCol; b++) {

                var sizex = "";
                var qtyx = 0.00;
                var column = gvSizes.GetColumn(b);

                qtyx = gvSizes.batchEditApi.GetCellValue(index, column.fieldName);
                sizex = column.fieldName;

                if (qtyx != 0 && qtyx != "0.00" && qtyx != null && qtyx != "" && qtyx != '') {
                    arrayGL.push(itemx + '|' + colorx + '|' + classx + '|' + sizex);
                }
            }

            checkGrid();

            for (i = 1; i < sCol; i++) {
                var s = "";
                var sizex = "";
                var qtyx = 0.00;
                var column = gvSizes.GetColumn(i);
                var item;
                var checkitem;

                qtyx = gvSizes.batchEditApi.GetCellValue(0, column.fieldName);
                sizex = column.fieldName;

                if (qtyx != 0 && qtyx != "0.00" && qtyx != null && qtyx != "" && qtyx != '') {

                    s = itemx + ';' + descx + ';' + colorx + ';' + classx + ';' + sizex + ';' + qtyx + ';' + unitx + ';' + pricex + ';' + bulkunitx + ';' + bybulkx;
                    item = s.split(';');
                    checkitem = item[0] + '|' + item[2] + '|' + item[3] + '|' + item[4];

                    if (isInArray(checkitem, arrayGrid)) {

                        for (var q = 0; q < gvLength; q++) {
                            var exist = "";
                            gItem = gv1.batchEditApi.GetCellValue(gvIndex[q], "ItemCode");
                            gColor = gv1.batchEditApi.GetCellValue(gvIndex[q], "ColorCode");
                            gClass = gv1.batchEditApi.GetCellValue(gvIndex[q], "ClassCode");
                            gSize = gv1.batchEditApi.GetCellValue(gvIndex[q], "SizeCode");
                            exist = gItem + '|' + gColor + '|' + gClass + '|' + gSize;

                            if (exist == checkitem) {
                                gv1.batchEditApi.SetCellValue(gvIndex[q], "OrderQty", qtyx);
                            }
                        }
                    }
                    else {
                        gv1.AddNewRow();
                        getCol(gv1, editorobj, item);
                    }
                }

            }

            arrayGrid = [];
            arrayGL = [];
            cp.PerformCallback('CallbackSize');
            e.processOnServer = false;
            gvSizeHorizontal.CancelEdit();
            gvSizes.CancelEdit(); 
        }

        function checkGrid() {
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            var Keyfield;
            for (var w = 0; w < indicies.length; w++) {
                if (gv1.batchEditApi.IsNewRow(indicies[w])) {
                    Keyfield = gv1.batchEditApi.GetCellValue(indicies[w], "ItemCode") + '|' + gv1.batchEditApi.GetCellValue(indicies[w], "ColorCode") + '|' + gv1.batchEditApi.GetCellValue(indicies[w], "ClassCode") + '|' + gv1.batchEditApi.GetCellValue(indicies[w], "SizeCode");
                    arrayGrid.push(Keyfield)
                    gv1.batchEditApi.ValidateRow(indicies[w]);
                }
                else {
                    var key = gv1.GetRowKey(indicies[w]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        var ss = "";
                    else {
                        Keyfield = gv1.batchEditApi.GetCellValue(indicies[w], "ItemCode") + '|' + gv1.batchEditApi.GetCellValue(indicies[w], "ColorCode") + '|' + gv1.batchEditApi.GetCellValue(indicies[w], "ClassCode") + '|' + gv1.batchEditApi.GetCellValue(indicies[w], "SizeCode");
                        arrayGrid.push(Keyfield)
                        gv1.batchEditApi.ValidateRow(indicies[w]);
                    }
                }
            }
        }

        function getCol(ss, ee, item) {
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = gv1.GetColumn(i);
                if (column.visible == false || column.fieldName == undefined)
                    continue;
                Bindgrid(item, ee, column, gv1);
            }
        }

        function Bindgrid(item, e, column, s) {

            if (column.fieldName == "ItemCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[0]);
            }
            if (column.fieldName == "FullDesc") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[1]);
            }
            if (column.fieldName == "ColorCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[2]);
            }
            if (column.fieldName == "ClassCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[3]);
            }
            if (column.fieldName == "SizeCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[4]);
            }
            if (column.fieldName == "OrderQty") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[5]);
            }
            if (column.fieldName == "Unit") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[6]);
            }
            if (column.fieldName == "UnitPrice") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[7]);
            }
            if (column.fieldName == "BulkUnit") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[8]);
            }
            if (column.fieldName == "IsByBulk") {
                if (item[9] == "True") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsByBulk.SetChecked = true);
                }
                else {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsByBulk.SetChecked = false);
                }
            }
            if (column.fieldName == "VATCode") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "NONV");
            }
            if (column.fieldName == "IsVAT") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsVAT.SetChecked = false);
            }
            if (column.fieldName == "Rate") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "0");
            }
            if (column.fieldName == "DiscountRate") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "0");
            }
            if (column.fieldName == "DeliveredQty") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "0");
            }
        }

        function CalculateSize(s, e) {

            var qty = 0.00;
            var Aqty = 0.00;

            setTimeout(function () {
                var indicies = gvSizes.batchEditApi.GetRowVisibleIndices();
                var col = gvSizes.GetColumnsCount();

                for (var b = 1; b < col; b++) {
                    var column = gvSizes.GetColumn(b);
                    qty = gvSizes.batchEditApi.GetCellValue(index, column.fieldName);

                    Aqty += qty;
                }

                gvSizeHorizontal.batchEditApi.SetCellValue(index, "OrderQtyX", Aqty);

            }, 500);
        }
        //ADDED NEW END

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
                num = this.toFixed(Math.max(0, ~~d));

            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };


        function autocalculate(s, e) {

            console.log('dumaan sa auto')
         //   OnInitTrans();
            detailautocalculate();

            var unitfrieght = 0.00;
            var receivedqty = 0.0000;
            var unitcost = 0.00;
            var receivedqty1 = 0.0000;
            var unitcost1 = 0.00;
            var receivedqty2 = 0.0000;
            var unitcost2 = 0.00;
            var exchangerate = 0.00;
            var freight = 0.00;
            var totalqty = 0.0000
            var discountrate = 0.00;
            var totalfreight = 0.00;
            var TotalQuantity = 0.00;
            var PesoAmount = 0.00;
            var GrossVatamount = 0.00;
            var NonVatAmount = 0.00;
            var ForeignAmount = 0.00;
            var freight = 0.00;
            var vatable = 0.00;
            var VATAmount = 0.00;
            var rate = 0.00;
            var code = "";

            if (speExchangeRate.GetText() == null || speExchangeRate.GetText() == "") {
                exchangerate = 0.00;
            }
            else {
                exchangerate = speExchangeRate.GetText();
            }

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                var temp1 = indicies.length;
                var arrunit = [];
                var arrqty = [];
                var cntr = 0;
                var holder = 0;
                var txt1 = "";

                for (var b = 0; b <= temp1; b++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[b])) {
                        for (var a = 0; a <= temp1; a++) {
                            if (gv1.batchEditApi.GetCellValue(indicies[b], "Unit") == arrunit[a]) {
                                var ter = gv1.batchEditApi.GetCellValue(indicies[b], "OrderQty");

                                if (isNaN(ter) == true) {
                                    ter = 0;
                                }

                                arrqty[a] += +ter; //adds qty with same unit
                                cntr++; //increment if found an existing unit
                            }
                        }
                        if (cntr == 0) {
                            holder++;
                            arrunit[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "Unit"); //add new unit
                            arrqty[holder] = Number(gv1.batchEditApi.GetCellValue(indicies[b], "OrderQty")); //along with qty
                        }
                        else cntr = 0;
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[b]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[b]);
                        else {
                            for (var a = 0; a <= temp1; a++) {
                                if (gv1.batchEditApi.GetCellValue(indicies[b], "Unit") == arrunit[a]) {
                                    var ter = gv1.batchEditApi.GetCellValue(indicies[b], "OrderQty");

                                    if (isNaN(ter) == true) {
                                        ter = 0;
                                    }

                                    arrqty[a] += +ter; //adds qty with same unit
                                    cntr++; //increment if found an existing unit
                                }
                            }
                            if (cntr == 0) {
                                holder++;
                                arrunit[holder] = gv1.batchEditApi.GetCellValue(indicies[b], "Unit"); //add new unit
                                arrqty[holder] = Number(gv1.batchEditApi.GetCellValue(indicies[b], "OrderQty")); //along with qty
                            }
                            else cntr = 0;
                        }
                    }
                }

                for (var c = 0; c <= holder; c++) {
                    if (c == 0 && isNaN(arrqty[0]) == true && c == null)
                        console.log('skip');
                    else {
                        if (arrunit[c] != 0 && arrunit[c] != null)
                        {
                            txt1 += "(" + arrunit[c].toUpperCase() + "|" + arrqty[c].format(4, 5, ',', '.') + ") " + "\n";
                        }
                    }
                }
                //end

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                        receivedqty = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
                        unitcost = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice"); 
                        discountrate = gv1.batchEditApi.GetCellValue(indicies[i], "DiscountRate");
                        rate = gv1.batchEditApi.GetCellValue(indicies[i], "Rate");
                        var discountrate2 = discountrate / 100;

                        TotalQuantity += receivedqty * 1;

                        if (discountrate != 0 || discountrate != null) {
                            PesoAmount += (unitcost * receivedqty) - (unitcost * receivedqty * discountrate2)
                        }
                        else {
                            PesoAmount += unitcost * receivedqty
                        }

                        var cb = gv1.batchEditApi.GetCellValue(indicies[i], "IsVAT")

                        if (cb == true) {
                            receivedqty1 = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
                            unitcost1 = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
                            GrossVatamount += (unitcost1 * receivedqty1) - (unitcost1 * receivedqty1 * discountrate2);
                            VATAmount += ((((unitcost1 * receivedqty1) - (unitcost1 * receivedqty1 * discountrate2)) / (rate + 1)) * rate);
                        }

                        else {
                            receivedqty2 = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
                            unitcost2 = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
                            NonVatAmount += (unitcost2 * receivedqty2) - (unitcost2 * receivedqty2 * discountrate2);
                        }
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) {
                            console.log("deleted row " + indicies[i]);
                        }
                        else {
                            
                            receivedqty = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
                            unitcost = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice"); 
                            discountrate = gv1.batchEditApi.GetCellValue(indicies[i], "DiscountRate");
                            rate = gv1.batchEditApi.GetCellValue(indicies[i], "Rate");
                            var discountrate2 = discountrate / 100;

                            TotalQuantity += receivedqty * 1;

                            if (discountrate != 0 || discountrate != null) {
                                PesoAmount += (unitcost * receivedqty) - (unitcost * receivedqty * discountrate2)
                            }
                            else {
                                PesoAmount += unitcost * receivedqty
                            }

                            var cb = gv1.batchEditApi.GetCellValue(indicies[i], "IsVAT")

                            if (cb == true) {
                                receivedqty1 = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
                                unitcost1 = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
                                GrossVatamount += (unitcost1 * receivedqty1) - (unitcost1 * receivedqty1 * discountrate2);
                                VATAmount += ((((unitcost1 * receivedqty1) - (unitcost1 * receivedqty1 * discountrate2)) / (rate + 1)) * rate);
                            }

                            else {
                                receivedqty2 = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
                                unitcost2 = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
                                NonVatAmount += (unitcost2 * receivedqty2) - (unitcost2 * receivedqty2 * discountrate2);
                            }
                        }
                    }
                }                
                
                txtVatAmount.SetText(VATAmount.format(2, 3, ',', '.'));
                txtGrossVATableAmount.SetText((GrossVatamount).format(2, 3, ',', '.'))
                txtnonvat.SetText((NonVatAmount).format(2, 3, ',', '.'))
                txtTotalAmount.SetText((PesoAmount + freight).format(2, 3, ',', '.'));
                txtForeignAmount.SetText(((PesoAmount / exchangerate) + freight).format(2, 3, ',', '.'));
                txtTotalQtyU.SetText(txt1);

            }, 500);
        }

        function autocalculate1(s, e) { 
            var TotalBulkQty = 0.00; 
            var totalbulkqty = 0.00
            var bulkqty = 0.00;


            setTimeout(function () { //New Rows
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        bulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "BulkQty"); 
                        TotalBulkQty += bulkqty;  
                    } 
                    else { //Existing Rows
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else { 
                            bulkqty = gv1.batchEditApi.GetCellValue(indicies[i], "BulkQty"); 
                            TotalBulkQty += bulkqty; 
                        }
                    } 
                    txtTotalBulkQty.SetText(TotalBulkQty.toFixed(2)); 
                } 
            }, 500);
        }

        var transtype = getParameterByName('transtype');
        //ADDED NEW
        var dnum = getParameterByName('docnumber');

        function onload() {
            fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + dnum + '&transtype=' + transtype);
        }

        function detailautocalculate(s, e) {  
            var freight = 0.00;
            var totalqty = 0.00
            var detailfreight = 0.00; 
            var totalfreight = 0.00; 
            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var a = 0; a < indicies.length; a++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[a])) {
                        receivedqty = gv1.batchEditApi.GetCellValue(indicies[a], "OrderQty");
                        totalqty += receivedqty;
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[a]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            var s;
                        else {
                            receivedqty = gv1.batchEditApi.GetCellValue(indicies[a], "OrderQty");
                            totalqty += receivedqty;
                        }
                    }
                } 
            }, 500); 
        } 

        function skuend(s, e) {
            if (s.GetGridView().cp_finload) {
                delete (s.GetGridView().cp_finload);
                loader.Hide();
            }
            
            if (s.GetGridView().cp_endedit) {
                delete (s.GetGridView().cp_endedit);
                gv1.batchEditApi.EndEdit();
            }
        }
    </script>
    <!--#endregion-->
</head>
<body style="height: 910px;" onload="onload()">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel id="toppanel" runat="server" FixedPositionOverlap="true" fixedposition="WindowTop" backcolor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Sales Order" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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

        <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
            EnableViewState="False" HeaderText="Notes" Height="370px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="469"
            ShowCloseButton="False" Collapsed="true" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" />
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
      <%--  <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">--%>
         <dx:ASPxCallbackPanel ID="cp" runat="server" Width="820px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback" SettingsLoadingPanel-Enabled="true" SettingsLoadingPanel-Delay="3000" Images-LoadingPanel-Url="..\images\loadinggear.gif" Images-LoadingPanel-Height="30px" Styles-LoadingPanel-BackColor="Transparent" Styles-LoadingPanel-Border-BorderStyle="None" SettingsLoadingPanel-Text="" SettingsLoadingPanel-ShowImage="true" >
    
        <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <%--ADDED NEW--%>
                    <dx:ASPxPopupControl ID="v" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="SizeHorizontalPopup" CloseAction="CloseButton" CloseOnEscape="true"
                        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="400px" ShowHeader="true" Width="600px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
                        ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
                    <HeaderImage Height="10px"></HeaderImage>
                    <ContentStyle HorizontalAlign="Center"></ContentStyle>
                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                                <dx:ASPxFormLayout ID="Special" runat="server" Height="300px" Width="800px" style="margin-left: -20px" >
                                    <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                                    <Items>
                                        <dx:LayoutGroup Caption="Item Detail">
                                            <Items>
                                                <dx:LayoutItem Caption="" HorizontalAlign ="Center">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server" >
                                                            <dx:ASPxGridView ID="gvSizeHorizontal" runat="server" AutoGenerateColumns="False" Width="800px" KeyFieldName="DocNumberX"
                                                                OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gvSizeHorizontal" 
                                                                OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnCustomButtonInitialize="gv1_CustomButtonInitialize">                             
                                                                <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"
                                                                    BatchEditStartEditing="OnStartEditing"  BatchEditEndEditing="OnEndEditing" />
                                                                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                <Settings ColumnMinWidth="60" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="50" VerticalScrollBarMode="Auto" />
                                                                <SettingsBehavior AllowSort="False" AllowSelectSingleRowOnly="false" />
                                                                <SettingsCommandButton>
                                                                        <NewButton>
                                                                        <Image IconID="actions_addfile_16x16"></Image>
                                                                        </NewButton>
                                                                        <EditButton>
                                                                        <Image IconID="actions_addfile_16x16"></Image>
                                                                        </EditButton>
                                                                        <DeleteButton>
                                                                        <Image IconID="actions_cancel_16x16"></Image>
                                                                        </DeleteButton>
                                                                    </SettingsCommandButton>
                                                                <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                                <Columns>
                                                                    <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumberX" Name="DocNumberX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="0px">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="Item" FieldName="ItemCodeX" Name="ItemCodeX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="100">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="Item Description" FieldName="FullDescX" Name="FullDescX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3" Width="150">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="Color" FieldName="ColorCodeX" Name="ColorCodeX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4" Width="100">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="Class" FieldName="ClassCodeX" Name="ClassCodeX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5" Width="100">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="Unit" FieldName="UnitX" Name="UnitX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6" Width="70">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataSpinEditColumn Caption="Order Qty" FieldName="OrderQtyX" Name="OrderQtyX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" PropertiesSpinEdit-DisplayFormatString="{0:N}">
                                                                        <PropertiesSpinEdit DisplayFormatString="{0:N}"></PropertiesSpinEdit>
                                                                    </dx:GridViewDataSpinEditColumn>  
                                                                    <dx:GridViewDataSpinEditColumn Caption="Unit Price" FieldName="UnitPriceX" Name="UnitPriceX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="8" PropertiesSpinEdit-DisplayFormatString="{0:N}">
                                                                        <PropertiesSpinEdit DisplayFormatString="{0:N}"></PropertiesSpinEdit>
                                                                    </dx:GridViewDataSpinEditColumn> 
                                                                    <dx:GridViewDataTextColumn Caption="BulkUnit" FieldName="BulkUnitX" Name="BulkUnitX" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="9" Width="0">
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataCheckColumn Caption="IsByBulk" FieldName="IsByBulkX" Name="IsByBulkX" ShowInCustomizationForm="True" VisibleIndex="10" Width="0px">
                                                                        <PropertiesCheckEdit ClientInstanceName="glIsByBulkX">
                                                                        </PropertiesCheckEdit>
                                                                    </dx:GridViewDataCheckColumn>
                                                                </Columns>
                                                            </dx:ASPxGridView>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                            </Items>
                                        </dx:LayoutGroup>
                                        <dx:LayoutGroup Caption="Sizes">
                                            <Items>
                                                <dx:LayoutItem Caption="" HorizontalAlign ="Center">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxGridView ID="gvSizes" runat="server" AutoGenerateColumns="False" Width="800px" KeyFieldName="DocNumberX"
                                                                OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gvSizes" 
                                                                OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnCustomButtonInitialize="gv1_CustomButtonInitialize">                             
                                                                <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditStartEditing="OnStartEditing"  BatchEditEndEditing="OnEndEditing" />
                                                                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                                <SettingsEditing Mode="Batch"></SettingsEditing>
                                                                <Settings ColumnMinWidth="60" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="50" VerticalScrollBarMode="Auto" />
                                                                <SettingsBehavior AllowSort="False" AllowSelectSingleRowOnly="false" />
                                                                <SettingsCommandButton>
                                                                        <NewButton>
                                                                        <Image IconID="actions_addfile_16x16"></Image>
                                                                        </NewButton>
                                                                        <EditButton>
                                                                        <Image IconID="actions_addfile_16x16"></Image>
                                                                        </EditButton>
                                                                        <DeleteButton>
                                                                        <Image IconID="actions_cancel_16x16"></Image>
                                                                        </DeleteButton>
                                                                    </SettingsCommandButton>
                                                                <Styles>
                                                                        <StatusBar CssClass="statusBar">
                                                                        </StatusBar>
                                                                    </Styles>
                                                                <Columns>
                                                                    <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumberX" Name="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="0px">
                                                                    </dx:GridViewDataTextColumn>
                                                                </Columns>
                                                            </dx:ASPxGridView>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                </dx:LayoutItem>
                                            </Items>
                                        </dx:LayoutGroup>
                                        <dx:LayoutItem Caption="" HorizontalAlign="Center" ShowCaption="False" VerticalAlign="Middle">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                    <dx:ASPxButton ID="btnSizeHorizontalExec" ClientInstanceName="btnSizeHorizontalExec" runat="server" Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" 
                                                        AutoPostBack="False" onload="ButtonLoad" ClientVisible="true" Text="Save" Theme="MetropolisBlue">                                                       
                                                        <ClientSideEvents Click="CallbackSize" />
                                                    </dx:ASPxButton>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:ASPxFormLayout>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>



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
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" AutoCompleteType="Disabled" Enabled="False">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" Width="170px" OnInit="dtpDocDate_Init"  >
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('DocDate');}" /> 
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Customer Code">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglCustomerCode" runat="server" ClientInstanceName="dsCustomerCode" DataSourceID="sdsBizPartnerCus" Width="170px" KeyFieldName="BizPartnerCode"  TextFormatString="{0}"
                                                                    GridViewProperties-SettingsLoadingPanel-Text="" GridViewImages-LoadingPanel-Url="..\images\loadinggear.gif"  GridViewImages-LoadingPanel-Height="30px" GridViewStyles-LoadingPanel-BackColor="Transparent" GridViewProperties-SettingsLoadingPanel-ShowImage="true" GridViewProperties-SettingsLoadingPanel-Delay="3000" GridViewStyles-LoadingPanel-Border-BorderColor="Transparent" 
                                                                      OnInit="aglCustomerCode_Init">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('FilterQuote');}"
                                                                        DropDown="function(s,e){dsCustomerCode.GetGridView().PerformCallback();}"/>
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0" Caption ="Code">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Caption ="Description" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Target Delivery Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpTargetDate" ClientInstanceName="dtpTargetDate" runat="server" Width="170px"   OnInit ="dtpTargetDelivery_Init">
                                                                    <ClientSideEvents Validation="OnValidation"  ValueChanged="function(s,e){cp.PerformCallback('TargetDelivery');}" />
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
                                                    <dx:LayoutItem Caption="Status">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtStatus" runat="server" Width="170px" ReadOnly ="True">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Date Completed">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDateCompleted" runat="server" Width="170px" ReadOnly ="True">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="CustomerPONo">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtCustomerPONo" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Procurement Doc">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglProcurementDoc" runat="server" Width="170px" TextFormatString="{1}" DataSourceID="sdsProcurement" KeyFieldName ="Code">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Code" ReadOnly="True" Visible="false" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Quote">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglQuote" runat="server" Width="170px" ClientInstanceName="RefQuote" DataSourceID="sdsQuotation" 
                                                                     KeyFieldName="DocNumber" TextFormatString="{0}" OnInit="aglQuote_Init">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <ClientSideEvents DropDown="function(s,e){dsCustomerCode.GetGridView().PerformCallback();}"/>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="DocDate" ShowInCustomizationForm="True" VisibleIndex="1" Width="100px" ReadOnly ="true">
                                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                            <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CustomerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Status" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TotalQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4">
                                                                            <PropertiesTextEdit DisplayFormatString="{0:N}" />
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="Validity" ShowInCustomizationForm="True" VisibleIndex="5" Width="100px" ReadOnly ="true">
                                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                            <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataDateColumn FieldName="TargetDeliveryDate" ShowInCustomizationForm="True" VisibleIndex="6" Width="100px" ReadOnly ="true">
                                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" AllowMouseWheel="false" DropDownButton-Enabled="false" DropDownButton-ClientVisible ="false">
                                                                            <DropDownButton Enabled="False" ClientVisible="False"></DropDownButton>
                                                                            </PropertiesDateEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataDateColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Remarks" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Width ="100px">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents ValueChanged="function(s,e){cp.PerformCallback('QuoteDetails');}" />
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="With Quote">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxCheckBox ID="chkIsWithQuote" runat="server" Width="170px" CheckState="Unchecked" ClientInstanceName="cbiswithdr" >
                                                                <ClientSideEvents CheckedChanged="checkedchanged" />
                                                            </dx:ASPxCheckBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" Width="170px" >
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Vatable">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkVatable" runat="server" CheckState="Unchecked" ClientInstanceName="chkVatable" >
                                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Amount" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Exchange Rate">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="speExchangeRate" runat="server" Width="170px" ClientInstanceName="speExchangeRate" NullText ="0.00" DisplayFormatString="{0:N4}"  MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="4" >
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Peso Amount" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPesoAmount" runat="server" Width="170px" ClientInstanceName="txtTotalAmount" ReadOnly="true" NullText ="0.00" DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                 <dx:LayoutItem Caption="Currency" RequiredMarkDisplayMode="Required">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="aglCurrency" runat="server" DataSourceID="sdsCurrency" Width="170px" KeyFieldName="Currency" TextFormatString="{0}">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
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
                                                    <dx:LayoutItem Caption="Foreign Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtForeignAmount" runat="server" Width="170px" ReadOnly="True" ClientInstanceName="txtForeignAmount" NullText ="0.00" DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Terms">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxSpinEdit ID="speTerms" runat="server" Width="170px" NullText ="0.00"  MinValue="0" MaxValue="999999999"  AllowMouseWheel="False"  SpinButtons-ShowIncrementButtons="false"  DecimalPlaces="0" >
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Gross Vatable Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtGross" runat="server" Width="170px" ReadOnly="True" ClientInstanceName="txtGrossVATableAmount" NullText ="0.00" DisplayFormatString="{0:N}" >
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="VAT Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtVatAmount" runat="server" Width="170px" ReadOnly="True" ClientInstanceName="txtVatAmount" NullText ="0.00" DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Non Vatable Amount">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtNonVatable" runat="server" Width="170px" ReadOnly="True" ClientInstanceName="txtnonvat" NullText ="0.00" DisplayFormatString="{0:N}">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Total Quantity">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxMemo ID="memTotalQty" runat="server" Height="80px" Width="170px" ClientInstanceName="txtTotalQtyU" ReadOnly ="true">
                                                        </dx:ASPxMemo>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Bulk Qty">
                                                    <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTotalBulkQty" runat="server" ClientInstanceName="txtTotalBulkQty" ReadOnly="True" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                                 </dx:LayoutItem>
                                                    <%--<dx:LayoutItem Caption="Total Freight">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTotalFreight" runat="server" Width="170px" ClientInstanceName="txtTotalFreight" NullText ="0.00" DisplayFormatString="{0:N}">
                                                            <ClientSideEvents ValueChanged="Frieght" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>                                                    
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                    <dx:EmptyLayoutItem>
                                                    </dx:EmptyLayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="User Defined" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Field1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field3">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server">
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
                                            <dx:LayoutItem Caption="Cancelled By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHCancelledDate" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Manual Closed By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtForcedClosedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Manual Closed Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtForcedClosedDate" runat="server" Width="170px" ReadOnly="True">
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
                                                        <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" Width="850px" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Settings-ShowStatusBar="Hidden">

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
                            <dx:LayoutGroup Caption="Sales Order Detail">
                                <Items>
                                    <%--ADDED NEW--%>
                                    <dx:LayoutItem Caption="SizeHorizontal" ShowCaption="False" HorizontalAlign="Left">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxButton ID="btnSizeHorizontal" runat="server" Text="Size Horizontal" Width="170px" OnLoad="ButtonLoad"
                                                     AutoPostBack="false" UseSubmitBehavior="false">
                                                    <ClientSideEvents Click="ShowSizeHorizontal" />
                                                </dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False"  Width="850px"
                                                    ClientInstanceName="gv1" OnBatchUpdate="gv1_BatchUpdate" OnCellEditorInitialize="gv1_CellEditorInitialize"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    OnInit="gv1_Init" OnRowValidating="grid_RowValidating">
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" 
                                                        BatchEditStartEditing="OnStartEditing" CustomButtonClick="OnCustomClick" BatchEditRowValidating="Grid_BatchEditRowValidating" />
                                                    <SettingsPager Mode="ShowAllRecords" />  
                                                     <SettingsEditing Mode="Batch"/>
                                                    <Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" VerticalScrollableHeight="300"  /> 
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior> 
                                                    <SettingsCommandButton>
                                                        <NewButton>
                                                            <Image IconID="actions_addfile_16x16"></Image>
                                                        </NewButton>
                                                        <EditButton>
                                                            <Image IconID="actions_addfile_16x16"></Image>
                                                        </EditButton>
                                                        <DeleteButton>
                                                            <Image IconID="actions_cancel_16x16"></Image>
                                                        </DeleteButton>
                                                    </SettingsCommandButton>
                                                    <Styles>
                                                        <StatusBar CssClass="statusBar" />
                                                    </Styles> 
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ShowInCustomizationForm="True" VisibleIndex="0" Width="0px">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="60px">
                                                                <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Details" >
                                                                   <Image IconID="support_info_16x16" ToolTip="Details"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="80px">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <%--<dx:GridViewDataTextColumn FieldName="ItemCode" Name="glpItemCode" ShowInCustomizationForm="True" VisibleIndex="3" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="glItemCode_Init"
                                                                    DataSourceID="sdsItem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition ="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition ="Contains"/>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" 
                                                                            EndCallback="GridEndChoice" /> 
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                           <dx:GridViewDataTextColumn FieldName="FullDesc" Name="FullDesc" VisibleIndex="4" Width="120px" Caption="ItemDesc" ReadOnly="true">
                                                           </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" Name="ColorCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" KeyFieldName="ColorCode" OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSort="false" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition ="Contains"/>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="skuend" GotFocus="function dropdown(s, e){
                                                                        loader.Show();
                                                                gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value + '|' + 'DDown');
                                                                }" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ShowInCustomizationForm="True" VisibleIndex="6" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl3" KeyFieldName="ClassCode" OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" AllowSort="false" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition ="Contains"/>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="skuend" GotFocus="function dropdown(s, e){
                                                                        loader.Show();
                                                                        gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" CloseUp="gridLookup_CloseUp"
                                                                        />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Name="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl4" KeyFieldName="SizeCode" OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" AllowSort="false" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition ="Contains"/>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="skuend" CloseUp="gridLookup_CloseUp" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        GotFocus="function dropdown(s, e){
                                                                        loader.Show();
                                                                        gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value + '|' + 'DDown');
                                                                        }" /> 
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>--%>
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" Name="glpItemCode" ShowInCustomizationForm="True" VisibleIndex="3" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl" 
                                                                    KeyFieldName="ItemCode" TextFormatString="{0}" Width="80px"
                                                                    GridViewProperties-SettingsLoadingPanel-Text="" GridViewImages-LoadingPanel-Url="..\images\loadinggear.gif"  GridViewImages-LoadingPanel-Height="30px" GridViewStyles-LoadingPanel-BackColor="Transparent" GridViewProperties-SettingsLoadingPanel-ShowImage="true" GridViewProperties-SettingsLoadingPanel-Delay="3000" GridViewStyles-LoadingPanel-Border-BorderColor="Transparent" 
                                                                     OnInit="glItemCode_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" EnableRowHotTrack="true" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" Settings-AutoFilterCondition="Contains" VisibleIndex="0" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" Settings-AutoFilterCondition="Contains" VisibleIndex="1" />
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEndChoice" DropDown="lookup" KeyDown="gridLookup_KeyDown2" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="ItemDesc" FieldName="FullDesc" Name="FullDesc" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4" Width="120px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" Name="ColorCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" KeyFieldName="ColorCode" OnInit="lookup_Init" TextFormatString="{0}" Width="80px"
                                                                    GridViewProperties-SettingsLoadingPanel-Text="Loading Lookup...">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" Settings-AutoFilterCondition="Contains" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" 
                                                                        DropDown="function (s, e){
                                                                            nope = true;
                                                                       
                                                                            gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value + '|' + 'code' + '|' + 'code' + '|' + 'code');
                                                                        }"
                                                                        ValueChanged="function(s,e){
                                                                        if(itemclr!=gl2.GetValue()&&gl2.GetValue()!=null){
                                                                                setTimeout(function(){
                                                                          
                                                                                    gl2.GetGridView().PerformCallback('Subs' + '|' + itemc + '|' + 'code' + '|' + gl2.GetValue() + '|' + itemcls + '|' + itemsze + '|' + 'item');
                                                                                    e.processOnServer = false;
                                                                                    valchange_Subs = true;   
                                                                                }, 500); 
                                                                            }
                                                                        }"  EndCallback="GridEndChoice"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ShowInCustomizationForm="True" VisibleIndex="6" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl3" KeyFieldName="ClassCode" OnInit="lookup_Init" TextFormatString="{0}" Width="80px"
                                                                    GridViewProperties-SettingsLoadingPanel-Text="Loading Lookup...">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" Settings-AutoFilterCondition="Contains" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" CloseUp="gridLookup_CloseUp"
                                                                        DropDown="function(s,e){
                                                                                nope = true;
                                                                          
                                                                                gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value + '|' + 'code' + '|' + 'code' + '|' + 'code');
                                                                        }"
                                                                        ValueChanged="function(s,e){
                                                                            if(itemcls!=gl3.GetValue() && gl3.GetValue()!=null){
                                                                                setTimeout(function(){
                                                                    
                                                                                    gl3.GetGridView().PerformCallback('Subs' + '|' + itemc + '|' + 'code' + '|' + itemclr + '|' + gl3.GetValue() + '|' + itemsze + '|' + 'item');
                                                                                    e.processOnServer = false;
                                                                                    valchange_Subs = true;    
                                                                                }, 500);
                                                                            }
                                                                        }"  EndCallback="GridEndChoice"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Name="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl4" KeyFieldName="SizeCode" OnInit="lookup_Init" TextFormatString="{0}" Width="80px"
                                                                   GridViewProperties-SettingsLoadingPanel-Text="Loading Lookup..." >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition ="Contains"/>
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" 
                                                                        DropDown="function(s,e){
                                                                                nope = true;
                                                                  
                                                                                gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value + '|' + 'code' + '|' + 'code' + '|' + 'code');
                                                                        }"
                                                                        ValueChanged="function(s,e){
                                                                            if(itemsze!=gl4.GetValue() && gl4.GetValue()!=null){
                                                                                setTimeout(function(){
                                                                        
                                                                                    gl4.GetGridView().PerformCallback('Subs' + '|' + itemc + '|' + 'code' + '|' + itemclr + '|' + itemcls + '|' + gl4.GetValue() + '|' + 'item');
                                                                                    e.processOnServer = false;
                                                                                    valchange_Subs = true;  
                                                                                }, 500);  
                                                                            }
                                                                        }"  EndCallback="GridEndChoice"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataSpinEditColumn FieldName="OrderQty" Name="glpOrderQty" ShowInCustomizationForm="True" UnboundType="Decimal" PropertiesSpinEdit-LargeIncrement="0" VisibleIndex="8">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" NumberFormat="Custom" SpinButtons-ShowIncrementButtons="false" MinValue ="0" MaxValue="9999999999">
                                                            <SpinButtons ShowIncrementButtons="False" ></SpinButtons>
                                                                <ClientSideEvents ValueChanged ="autocalculate"/>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn> 

                                                          <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit" ShowInCustomizationForm="True" VisibleIndex="9" Width="80px">
                                                                    <EditItemTemplate>
                                                                        <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl5" DataSourceID="sdsUnit" KeyFieldName="Unit" TextFormatString="{0}" Width="80px">
                                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                            </GridViewProperties>
                                                                            <Columns>
                                                                                <dx:GridViewDataTextColumn FieldName="Unit" ReadOnly="True" VisibleIndex="0">
                                                                                </dx:GridViewDataTextColumn>
                                                                            </Columns>
                                                                            
                                                                            <ClientSideEvents CloseUp="gridLookup_CloseUp" DropDown="function dropdown(s, e){
                                                                                gl5.GetGridView().PerformCallback('Unit' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                                e.processOnServer = false;
                                                                                }" EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" ValueChanged="autocalculate" />
                                                                            <%--<ClientSideEvents ValueChanged="autocalculate" CloseUp="gridLookup_CloseUp" DropDown="function dropdown(s, e){
                                                                        gl5.GetGridView().PerformCallback('Unit' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }" EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />--%>
                                                                        </dx:ASPxGridLookup>
                                                                    </EditItemTemplate>
                                                                </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsByBulk" Name="glpIsByBulk" ShowInCustomizationForm="True" VisibleIndex="36" Caption="IsByBulk" Width="0px">
                                                            <PropertiesCheckEdit ClientInstanceName="glIsByBulk" >
                                                            </PropertiesCheckEdit>              
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="BulkQty" Name="glpBulkQty" ShowInCustomizationForm="True" PropertiesSpinEdit-LargeIncrement="0" UnboundType="Decimal" VisibleIndex="10" Width="80px">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" NumberFormat="Custom" SpinButtons-ShowIncrementButtons="false" MinValue ="0" MaxValue="9999999999">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate1" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn> 
                                                        <dx:GridViewDataTextColumn Caption="BulkUnit" FieldName="BulkUnit" ShowInCustomizationForm="True" VisibleIndex="11" Width="80px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glBulkUnit" runat="server" AutoGenerateColumns="False" AutoPostBack="false"  ClientInstanceName="gl6" DataSourceID="sdsBulkUnit" KeyFieldName="BulkUnit" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BulkUnit" ReadOnly="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp" DropDown="function dropdown(s, e){
                                                                gl6.GetGridView().PerformCallback('BulkUnit' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                e.processOnServer = false;
                                                                }" EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitPrice" Name="glpUnitPrice" PropertiesSpinEdit-LargeIncrement="0" ShowInCustomizationForm="True" VisibleIndex="12">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" MinValue ="0" MaxValue="9999999999">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataCheckColumn FieldName="IsVAT" Name="glpIsVAT" ShowInCustomizationForm="True" VisibleIndex="14" Caption="Vatable">
                                                            <PropertiesCheckEdit ClientInstanceName="glIsVAT" >
                                                                <ClientSideEvents CheckedChanged="VATCheckChange" />
                                                            </PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>
                                                         <dx:GridViewDataTextColumn FieldName="VATCode" Name="glpVATCode" ShowInCustomizationForm="True" VisibleIndex="15">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="VATCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" 
                                                                    DataSourceID="sdsTaxCode" KeyFieldName="TCode" ClientInstanceName="glVATCode" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="TCode" ReadOnly="True" VisibleIndex="0" Caption="Tax Code"/>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" />
                                                                    </Columns>
                                                                    
                                                                    <ClientSideEvents DropDown="lookup" KeyDown="gridLookup_KeyDown" ValueChanged="gridLookup_CloseUp" KeyPress="gridLookup_KeyPress" RowClick="function(s,e){
                                                                        setTimeout(function(){
                                                                        closing = true;
                                                                        gl2.GetGridView().PerformCallback('VATCode' + '|' + glVATCode.GetValue() + '|' + 'code' + '|' + 'code' + '|' + 'code' + '|' + 'code');
                                                                        e.processOnServer = false;
                                                                        valchange_VAT = true
                                                                        }, 500); 
                                                                    }" />
                                                                    <%--<ClientSideEvents DropDown="lookup" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" RowClick="function(s,e){
                                                                    console.log('rowclick');
                                                                        setTimeout(function(){
                                                                    closing = true;
                                                                    gl2.GetGridView().PerformCallback('VATCode' + '|' + glVATCode.GetValue() + '|' + 'code');
                                                                    e.processOnServer = false;
                                                                    valchange_VAT = true
                                                                    }, 500);
                                                                  }" />--%>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="DiscountRate" Name="glpDiscountRate" PropertiesSpinEdit-LargeIncrement="0" ShowInCustomizationForm="True" VisibleIndex="16">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="DiscountRate" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00" MinValue="0" MaxValue="100"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                            <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="DeliveredQty" Name="glpDeliveredQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="17" >
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" SpinButtons-ShowIncrementButtons="false">
                                                            <SpinButtons ShowIncrementButtons="False" Enabled="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubstituteItem" Name="glpSubstituteItem" ShowInCustomizationForm="True" VisibleIndex="18">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubstituteColor" Name="glpSubstituteColor" ShowInCustomizationForm="True" VisibleIndex="19">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubstituteClass" Name="glpSubstituteClass" ShowInCustomizationForm="True" VisibleIndex="20">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SubstituteSize" Name="glpSubstituteSize" ShowInCustomizationForm="True" VisibleIndex="21">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="BaseQty" Name="glpBaseQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="21">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" SpinButtons-ShowIncrementButtons="false">
                                                            <SpinButtons ShowIncrementButtons="False" Enabled="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                         <dx:GridViewDataTextColumn FieldName="StatusCode" Name="glpStatusCode" ShowInCustomizationForm="True" VisibleIndex="22" ReadOnly="True">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BarcodeNo" Name="glpBarcodeNo" ShowInCustomizationForm="True" VisibleIndex="23" ReadOnly="True">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitFactor" Name="glpUnitFactor" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="24">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                            <SpinButtons ShowIncrementButtons="False" Enabled="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" ShowInCustomizationForm="True" VisibleIndex="25" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" ShowInCustomizationForm="True" VisibleIndex="26" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" ShowInCustomizationForm="True" VisibleIndex="27" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" ShowInCustomizationForm="True" VisibleIndex="29" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" ShowInCustomizationForm="True" VisibleIndex="30" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="32" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="33" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Version" Name="glpVersion" ShowInCustomizationForm="True" VisibleIndex="34" UnboundType="String" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Rate" Name="glpRate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="35" Width="0px">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false">
                                                            <SpinButtons ShowIncrementButtons="False" Enabled="False"></SpinButtons>
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
                                     <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" AutoPostBack="False" UseSubmitBehavior="false">
                                         <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                         </dx:ASPxButton>
                                     <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel">
                                         <ClientSideEvents Click="function (s,e){ DeleteControl.Hide(); }" />
                                         </dx:ASPxButton> 
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
   <%-- <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Loading Lookup..."
        ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
        <LoadingDivStyle Opacity="0"></LoadingDivStyle>
   </dx:ASPxLoadingPanel>--%>
          <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server"  Text=""   Image-Url="..\images\loadinggear.gif" Image-Height="30px" Image-Width="30px" Height="30px" Width="30px" Enabled="true" ShowImage="true" BackColor="Transparent" Border-BorderStyle="None" 
            ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
        <LoadingDivStyle Opacity="0"></LoadingDivStyle>
   </dx:ASPxLoadingPanel>
</form>
    <!--#region Region Datasource-->
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.SalesOrder" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.SalesOrder" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.SalesOrder+SalesOrderDetail" SelectMethod="getdetail" UpdateMethod="UpdateSalesOrderDetail" TypeName="Entity.SalesOrder+SalesOrderDetail" DeleteMethod="DeleteSalesOrderDetail" InsertMethod="AddSalesOrderDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.SalesOrder+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" /> 
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from Sales.SalesOrderdetail where DocNumber is null" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSizeHorizontal" runat="server" SelectCommand="SELECT DISTINCT CONVERT(varchar(MAX),'') AS DocNumberX, CONVERT(varchar(MAX),'') AS ItemCodeX, CONVERT(varchar(MAX),'') AS ColorCodeX, CONVERT(varchar(MAX),'') AS ClassCodeX, CONVERT(varchar(MAX),'') AS UnitX, CONVERT(decimal(15,2), 0) AS OrderQtyX, CONVERT(decimal(15,2), 0) AS UnitPriceX, CONVERT(varchar(MAX),'') AS FullDescX, CONVERT(varchar(MAX),'') AS BulkUnitX, CONVERT(bit,'false') AS IsByBulkX FROM Sales.SalesOrderDetail WHERE DocNumber IS NULL" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsSizes" runat="server" SelectCommand="SELECT DocNumber AS DocNumberX FROM Sales.SalesOrderDetail WHERE DocNumber IS NULL" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>  
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit = "Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBizPartnerCus" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsQuotation" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.DocNumber, DocDate, CustomerCode, Status, SUM(ISNULL(B.Qty,0)) AS TotalQty, Validity, TargetDeliveryDate, Remarks FROM Sales.Quotation A LEFT JOIN Sales.QuotationDetail B ON A.DocNumber = B.DocNumber 
                          WHERE ISNULL([SubmittedBy], '') != '' GROUP BY A.DocNumber, DocDate, CustomerCode, Status, Validity, TargetDeliveryDate, Remarks " OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsQuotationDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber, A.LineNumber, A.ItemCode as ItemCode, FullDesc, A.ColorCode, A.SizeCode, A.ClassCode, Qty AS OrderQty, Unit, BulkUnit, BulkQty, UnitPrice, ISNULL(IsVAT,0) AS IsVAT, A.TaxCode AS VATCode, DiscountRate, 0.00 AS DeliveredQty, '' AS SubstituteItem, 
        '' AS SubstituteColor, '' AS SubstituteClass,'' AS SubstituteSize, 0.00 AS BaseQty, ISNULL(D.StatusCode,'') AS StatusCode, '' AS BarcodeNo, 0.0000 AS UnitFactor, A.Field1, A.Field2, A.Field3, A.Field4, A.Field5, A.Field6, A.Field7, A.Field8, A.Field9, '2' AS Version, ISNULL(C.Rate,0) Rate, ISNULL(IsByBulk,0) IsByBulk FROM Sales.QuotationDetail A LEFT JOIN Masterfile.Item B ON A.ItemCode = B.ItemCode 
        LEFT JOIN Masterfile.Tax C ON A.TaxCode = C.TCode LEFT JOIN Masterfile.ItemDetail D ON A.ItemCode = D.ItemCode AND A.ColorCode = D.ColorCode AND A.SizeCode = D.SizeCode AND A.ClassCode = D.ClassCodeSELECT DocNumber, A.LineNumber, A.ItemCode as ItemCode, FullDesc, A.ColorCode, A.SizeCode, A.ClassCode, Qty AS OrderQty, Unit, BulkUnit, BulkQty, UnitPrice, ISNULL(IsVAT,0) AS IsVAT, TaxCode AS VATCode, DiscountRate, 0.00 AS DeliveredQty, '' AS SubstituteItem, 
        '' AS SubstituteColor, '' AS SubstituteClass,'' AS SubstituteSize, 0.00 AS BaseQty, ISNULL(D.StatusCode,'') AS StatusCode, '' AS BarcodeNo, 0.0000 AS UnitFactor, A.Field1, A.Field2, A.Field3, A.Field4, A.Field5, A.Field6, A.Field7, A.Field8, A.Field9, '2' AS Version, ISNULL(C.Rate,0) Rate, ISNULL(IsByBulk,0) IsByBulk FROM Sales.QuotationDetail A LEFT JOIN Masterfile.Item B ON A.ItemCode = B.ItemCode 
        LEFT JOIN Masterfile.Tax C ON A.TaxCode = C.TCode LEFT JOIN Masterfile.ItemDetail D ON A.ItemCode = D.ItemCode AND A.ColorCode = D.ColorCode AND A.SizeCode = D.SizeCode AND A.ClassCode = D.ClassCode " OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsProcurement" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Code, Description FROM IT.GenericLookup WHERE LookUpKey ='SOPRDOC'" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsTaxCode" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select * from masterfile.Tax where ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UnitCode AS Unit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsBulkUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UnitCode AS BulkUnit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsCurrency" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Currency, CurrencyName FROM Masterfile.Currency WHERE ISNULL(IsInactive,0) = 0" OnInit = "Connection_Init"> </asp:SqlDataSource>
    <!--#endregion-->
</body>
</html>