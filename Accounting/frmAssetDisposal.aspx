<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmAssetDisposal.aspx.cs" Inherits="GWL.frmAssetDisposal" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Asset Disposal</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script><%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script><%--NEWADD--%>
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

            autocalculate();
            gv1.batchEditHelper.EndEdit();

            setTimeout(function () {
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
            }, 800);
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
                delete (s.cp_success);
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

            if (s.cp_disposaltype) {
                console.log('dto na')
                Disables();
                ResetDetails();
                autocalculate();
                delete (s.cp_disposaltype);
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
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
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
                if (e.focusedColumn.fieldName === "ItemCode") {
                    glItem.GetInputElement().value = cellInfo.value;
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
                    e.cancel = true;
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
                if (e.focusedColumn.fieldName === "VATCode") {
                    CINVATCode.GetInputElement().value = cellInfo.value;
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
            if (currentColumn.fieldName === "ItemCode") {
                cellInfo.value = glItem.GetValue();
                cellInfo.text = glItem.GetText();
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
            if (currentColumn.fieldName === "VATCode") {
                cellInfo.value = CINVATCode.GetValue();
                cellInfo.text = CINVATCode.GetText();
            }

            //if (valchange) {

            //    valchange = false;
            //    closing = false;
            //    for (var i = 0; i < s.GetColumnsCount() ; i++) {
            //        var column = s.GetColumn(i);
            //        if (column.visible == false || column.fieldName == undefined)
            //            continue;
            //        ProcessCells(0, e, column, s);
            //    }
            //}

        }

        var val;
        var temp;
        function ProcessCells(selectedIndex, e, column, s) {
            console.log(temp + " 3rd!")
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
                console.log(temp[4] + ' temp[4]')
                if (column.fieldName == "ColorCode") {
                    s.batchEditApi.SetCellValue(e, "ColorCode", temp[0]);
                }
                if (column.fieldName == "ClassCode") {
                    s.batchEditApi.SetCellValue(e, "ClassCode", temp[1]);
                }
                if (column.fieldName == "SizeCode") {
                    s.batchEditApi.SetCellValue(e, "SizeCode", temp[2]);
                }
                if (column.fieldName == "ItemCode") {
                    s.batchEditApi.SetCellValue(e, "ItemCode", temp[3]);
                }
                if (column.fieldName == "Qty") {
                    s.batchEditApi.SetCellValue(e, "Qty", temp[4]);
                }
                if (column.fieldName == "OrigQty") {
                    s.batchEditApi.SetCellValue(e, "OrigQty", temp[4]);
                }
                if (column.fieldName == "UnitCost") {
                    s.batchEditApi.SetCellValue(e, "UnitCost", temp[5]);
                }
                if (column.fieldName == "AccumulatedDepreciation") {
                    s.batchEditApi.SetCellValue(e, "AccumulatedDepreciation", temp[6]);
                }
                if (column.fieldName == "PropertyStatus") {
                    s.batchEditApi.SetCellValue(e, "PropertyStatus", temp[7]);
                }
                if (column.fieldName == "IsVat") {
                    if (temp[8] == "True") {
                        s.batchEditApi.SetCellValue(e, "IsVat", CINIsVAT.SetChecked = true);
                    }
                    else {
                        s.batchEditApi.SetCellValue(e, "IsVat", CINIsVAT.SetChecked = false);
                    }
                }
                if (column.fieldName == "VATCode") {
                    s.batchEditApi.SetCellValue(e, "VATCode", temp[9]);
                }
                if (column.fieldName == "Rate") {
                    s.batchEditApi.SetCellValue(e, "Rate", temp[10]);
                }
                //if (column.fieldName == "ColorCode") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
                //}
                //if (column.fieldName == "ClassCode") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
                //}
                //if (column.fieldName == "SizeCode") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
                //}
                //if (column.fieldName == "ItemCode") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
                //}
                //if (column.fieldName == "Qty") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
                //}
                //if (column.fieldName == "OrigQty") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
                //}
                //if (column.fieldName == "UnitCost") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[5]);
                //}
                //if (column.fieldName == "AccumulatedDepreciation") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[6]);
                //}
                //if (column.fieldName == "PropertyStatus") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[7]);
                //}
                //if (column.fieldName == "IsVat") {
                //    if (temp[8] == "True") {
                //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, CINIsVAT.SetChecked = true);
                //    }
                //    else {
                //        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, CINIsVAT.SetChecked = false);
                //    }
                //}
                //if (column.fieldName == "VATCode") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[9]);
                //}
                //if (column.fieldName == "Rate") {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[10]);
                //}
            }
        }

        var identifier;
        function GridEndChoice(s, e) {

            val = "";
            temp = "";

            identifier = s.GetGridView().cp_identifier;
            val = s.GetGridView().cp_codes;
            temp = val.split(';');
            val_VAT = s.GetGridView().cp_codes;
            temp_VAT = val_VAT.split(';');

            //console.log(identifier + " idetifier")
            //console.log(val + " VAL")
            //console.log(val_VAT + " VAL_VAT") 
            if (identifier == "ItemCode") {
                console.log(temp + " 1st!")
                GridEnd();
                gv1.batchEditApi.EndEdit();
            }

            if (identifier == "VAT") {
                GridEnd_VAT();
                gv1.batchEditApi.EndEdit();
                autocalculate();
            }

            delete (s.cp_identifier)
            delete (s.cp_codes)


        }


        function GridEnd(s, e) {

            if (valchange) {

                valchange = false;
                closing = false;
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, index, column, gv1);
                    autocalculate();
                    loader.Hide();
                }
            }

            //if (closing == true) {
            //    var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            //    for (var i = 0; i < indicies.length; i++) {
            //        gv1.batchEditApi.ValidateRow(indicies[i]);
            //        gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("Qty").index);
            //    }
            //    console.log(temp + " 2nd!")
            //    gv1.batchEditApi.EndEdit();
            //    autocalculate();
            //    loader.Hide();
            //}
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
                autocalculate();
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

        function autocalculate(s, e) {
            gv1.batchEditHelper.EndEdit();
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
            var rate = 0.00;

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        qty = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                        unitprice = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
                        unitcost = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                        depreciation = gv1.batchEditApi.GetCellValue(indicies[i], "AccumulatedDepreciation");

                        //Check if input Quanties are Negative
                        //qty = qty < 0 ? 0 : qty;
                        //unitprice = unitprice < 0 ? 0 : unitprice;
                        if (qty < 0) {
                            qty = 0;
                            gv1.batchEditApi.SetCellValue(indicies[i], "Qty", qty.toFixed(2));
                        }
                        if (unitprice < 0) {
                            unitprice = 0;
                            gv1.batchEditApi.SetCellValue(indicies[i], "UnitPrice", unitprice.toFixed(2));
                        }
                        // End Of Negative Checking - LGE (02/03/2016)

                        soldamount = qty * unitprice;
                        costamount = qty * unitcost;
                        depreciationsmount = depreciation * 1;
                        totalamountsold += soldamount;
                        totalcostasset += costamount;
                        totalaccumulateddepreciation += depreciationsmount;
                        netbookvalue = totalcostasset - totalaccumulateddepreciation;
                        totalgainloss = totalamountsold - netbookvalue;

                        var cb = gv1.batchEditApi.GetCellValue(indicies[i], "IsVat");

                        if (cb == true || cb == 'True' || cb == 'true' || cb == 1) {
                            console.log("checkpasok");
                            qtyVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                            unitpriceVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
                            rate = gv1.batchEditApi.GetCellValue(indicies[i], "Rate");
                            console.log(rate + ' r a t e');
                            soldamountVAT = qtyVAT * unitpriceVAT;

                            grossvatableamount += soldamountVAT / (1 + rate);
                        }
                        else {

                            console.log("unchekpasok");
                            qtyNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                            unitpriceNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");

                            soldamountNVAT = qtyNVAT * unitpriceNVAT;
                            totalamountsoldNVAT += soldamountNVAT
                            //console.log(totalamountsoldNVAT + ' totalamountsoldNVAT')

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

                            //Check if input Quanties are Negative
                            if (qty < 0) {
                                qty = 0;
                                gv1.batchEditApi.SetCellValue(indicies[i], "Qty", qty.toFixed(4));
                            }
                            if (unitprice < 0) {
                                unitprice = 0;
                                gv1.batchEditApi.SetCellValue(indicies[i], "UnitPrice", unitprice.toFixed(2));
                            }
                            // End Of Negative Checking - LGE (02/03/2016)

                            soldamount = qty * unitprice;
                            costamount = qty * unitcost;
                            depreciationsmount = depreciation * 1;
                            totalamountsold += soldamount;
                            totalcostasset += costamount;
                            totalaccumulateddepreciation += depreciationsmount;
                            netbookvalue = totalcostasset - totalaccumulateddepreciation;
                            totalgainloss = netbookvalue - totalamountsold;

                            var cb = gv1.batchEditApi.GetCellValue(indicies[i], "IsVat")

                            if (cb == true || cb == 'True' || cb == 'true' || cb == 1) {
                                qtyVAT = gv1.batchEditApi.GetCellValue(indicies[i], "Qty");
                                unitpriceVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitPrice");
                                rate = gv1.batchEditApi.GetCellValue(indicies[i], "Rate");
                                console.log(rate + ' r a t e');
                                soldamountVAT = qtyVAT * unitpriceVAT;

                                grossvatableamount += soldamountVAT / (1 + rate);
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

                CINTotalAmountSold.SetValue(totalamountsold.toFixed(2));
                CINTotalCostAsset.SetValue(totalcostasset.toFixed(2));
                CINTotalAccumulatedDepreciationRecord.SetValue(totalaccumulateddepreciation.toFixed(2));
                CINNetBookValue.SetValue(netbookvalue.toFixed(2));
                CINTotalGainLoss.SetValue(totalgainloss.toFixed(2));
                CINTotalNonGrossVatableAmount.SetValue(totalamountsoldNVAT.toFixed(2));
                CINTotalGrossVatableAmount.SetValue(grossvatableamount.toFixed(2));
            }, 800);
        }

        function ResetDetails(s, e) {

            var iGrid = gv1.batchEditApi.GetRowVisibleIndices();

            for (var i = 0; i < iGrid.length; i++) {
                if (gv1.batchEditApi.IsNewRow(iGrid[i])) {
                    gv1.DeleteRow(iGrid[i]);
                }
                else {
                    var key = gv1.GetRowKey(iGrid[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key)) {
                        gv1.DeleteRow(iGrid[i]);
                    }
                    else {
                        gv1.DeleteRow(iGrid[i]);
                    }
                }
            }
        }

        function textchanged(s, e) {

            if (CINDisposalType.GetValue() == "Sales") {
                cp.PerformCallback('selectsales');
                e.processOnServer = false;
                CINSoldTo.SetEnabled(true);

            }

            else {
                CINSoldTo.SetEnabled(false);
                CINSoldTo.SetText("");
                CINSoldTo.SetValue("");
                cp.PerformCallback('selectretirement');
                e.processOnServer = false;
            }
        }

        function Disables(s, e) {
            setTimeout(function () { //New Rows
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();

                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                        gv1.batchEditApi.SetCellValue(indicies[i], 'UnitPrice', 0);
                        gv1.batchEditApi.SetCellValue(indicies[i], 'SoldAmount', 0);
                        gv1.batchEditApi.SetCellValue(indicies[i], 'IsVat', false);
                        gv1.batchEditApi.SetCellValue(indicies[i], 'VATCode', "NONV");
                        gv1.batchEditApi.SetCellValue(indicies[i], 'Rate', 0);
                    }
                    else { //Existing Rows
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key)) {
                            console.log("deleted row " + indicies[i]);
                            //gv1.batchEditHelper.EndEdit();
                        }
                        else {
                            gv1.batchEditApi.SetCellValue(indicies[i], 'UnitPrice', 0);
                            gv1.batchEditApi.SetCellValue(indicies[i], 'SoldAmount', 0);
                            gv1.batchEditApi.SetCellValue(indicies[i], 'IsVat', false);
                            gv1.batchEditApi.SetCellValue(indicies[i], 'VATCode', "NONV");
                            gv1.batchEditApi.SetCellValue(indicies[i], 'Rate', 0);
                        }
                    }
                }
            }, 500);
        }


        function OnInitTrans(s, e) {

            var BizPartnerCode = CINSoldTo.GetText();

            factbox.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
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
            gvRef.SetWidth(width - 120);
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
                    <dx:ASPxLabel runat="server" Text="Asset Disposal" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
            EnableViewState="False" HeaderText="BizPartner Info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="50"
            ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="910px" ClientInstanceName="cp" OnCallback="cp_Callback">
           <%-- <ClientSideEvents EndCallback="gridView_EndCallback" Init="function(){ if(initgv == 'true'){ cp.PerformCallback('getvat'); initgv = 'false'; }}"></ClientSideEvents>
            --%>
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>            
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup ActiveTabIndex="0">
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>
                                            <dx:LayoutGroup Caption="Information" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Disposal Document Number" Name="DocNumber">
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
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Disposal Document Date" Name="DocDate" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtDocDate" runat="server" Width="170px" OnLoad="Date_Load" OnInit="dtpDocDate_Init" >
                                                                <ClientSideEvents Validation="OnValidation"/>
                                                                    <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True"/>
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Disposal Type:" Name="DisposalType">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox ID="cbDisposalType" Width="170px" ClientInstanceName="CINDisposalType" runat="server" OnLoad="ComboBoxLoad">
                                                                    <ClientSideEvents Validation="OnValidation" SelectedIndexChanged="textchanged" />                                                         
                                                                    <Items>
                                                                        <dx:ListEditItem Text="Retirement" Value="Retirement" />
                                                                        <dx:ListEditItem Text="Sales"      Value="Sales" />
                                                                    </Items>
                                                                    <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True"/>
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                   <%-- <ClientSideEvents ValueChanged="function(s, e) {
                                                                           var grid = glocn.GetGridView();
                                                                            glocn.GetGridView().PerformCallback(s.GetInputElement().value + '|' + glcustomer.GetValue() );
                                                                  
                                                                        }"/>--%>
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>  
                                                    <dx:LayoutItem Caption="Total Amount Sold" Name="TotalAmountSold">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <%--<dx:ASPxTextBox ID="txtTotalAmountSold" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="CINTotalAmountSold">
                                                                </dx:ASPxTextBox>--%>
                                                                <dx:ASPxSpinEdit ID="speTotalAmountSold" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="CINTotalAmountSold" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>  
                                                    <dx:LayoutItem Caption="Sold To">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup AutoGenerateColumns="false" ID="glSoldTo" ClientInstanceName="CINSoldTo" runat="server" Width="170px" DataSourceID="SoldToLookup" 
                                                                    KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                       <%--<ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('getvat');  e.processOnServer = false;}" />--%>
                                                                    <%-- <ClientSideEvents Validation="OnValidation"/>
                                                                    <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True"/>
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>--%>
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSort="false" />
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
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>                                                
                                                    <dx:LayoutItem Caption="Total Gross Vatable Amount" Name="TotalGrossVatableAmount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <%--<dx:ASPxTextBox ID="txtTotalGrossVatableAmount" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="CINTotalGrossVatableAmount">
                                                                </dx:ASPxTextBox>--%>
                                                                <dx:ASPxSpinEdit ID="speTotalGrossVatableAmount" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="CINTotalGrossVatableAmount" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Invoice Document Number" Name="InvoiceDocNumber">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtInvoiceDocNumber" runat="server" Width="170px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>                                    
                                                    <%--<dx:LayoutItem Caption="Sold To" Name="SoldTo">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glSoldTo" AutoGenerateColumns="true" runat="server" DataSourceID="SoldToLookup" KeyFieldName="BizPartnerCode" Width="170px" >
                                                                     <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                    <dx:LayoutItem Caption="Total Non Gross Vatable Amount" Name="TotalNonGrossVatableAmount">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <%--<dx:ASPxTextBox ID="txtTotalNonGrossVatableAmount" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="CINTotalNonGrossVatableAmount">
                                                                </dx:ASPxTextBox>--%>
                                                                <dx:ASPxSpinEdit ID="speTotalNonGrossVatableAmount" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="CINTotalNonGrossVatableAmount" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Remarks" Name="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memRemarks" runat="server" Height="150px" Width="500px" OnLoad="Memo_Load">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>  
                                                    <%--<dx:LayoutItem Caption="" Name="Remarks" ShowCaption="False">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxHiddenField ID="Email" runat="server" ClientInstanceName="hfEmail" />
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Asset Information" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Total Cost Asset" Name="TotalCostAsset">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <%--<dx:ASPxTextBox ID="txtTotalCostAsset" runat="server" Width="170px" ReadOnly="true" ClientInstanceName="CINTotalCostAsset">
                                                                </dx:ASPxTextBox>--%>
                                                                <dx:ASPxSpinEdit ID="speTotalCostAsset" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="CINTotalCostAsset" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Accumulated Depreciation Record" Name="TotalAccumulatedDepreciationRecord">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <%--<dx:ASPxTextBox ID="txtTotalAccumulatedDepreciationRecord" runat="server" Width="170px" ClientInstanceName="CINTotalAccumulatedDepreciationRecord" ReadOnly="true">
                                                                </dx:ASPxTextBox>--%>
                                                                <dx:ASPxSpinEdit ID="speTotalAccumulatedDepreciationRecord" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="CINTotalAccumulatedDepreciationRecord" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Net Book Value" Name="NetBookValue">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <%--<dx:ASPxTextBox ID="txtNetBookValue" runat="server" Width="170px" ClientInstanceName="CINNetBookValue" ReadOnly="true">
                                                                </dx:ASPxTextBox>--%>
                                                                <dx:ASPxSpinEdit ID="speNetBookValue" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="CINNetBookValue" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Total Gain / Loss" Name="TotalGainLoss">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <%--<dx:ASPxTextBox ID="txtTotalGainLoss" runat="server" Width="170px" ClientInstanceName="CINTotalGainLoss" ReadOnly="true">
                                                                </dx:ASPxTextBox>--%>
                                                                <dx:ASPxSpinEdit ID="speTotalGainLoss" runat="server" Width="170px" Number="0.00" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  
                                                                                    ClientInstanceName ="CINTotalGainLoss" DisplayFormatString="{0:N}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel="False" ReadOnly="true">
                                                                    <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                </dx:ASPxSpinEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>                            
                                        </Items>
                                    </dx:LayoutGroup>
                                    <%--<dx:LayoutGroup Caption="Asset Information Tab" ColCount="2">
                                        <Items>
                                        </Items>
                                    </dx:LayoutGroup>--%>
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
                                    <dx:LayoutGroup Caption="Journal Entries">
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
                                            <dx:LayoutItem Caption="CancelledBy By:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date:" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
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
                            <dx:LayoutGroup Caption="Asset Disposal Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="850px" 
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1" 
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnCustomButtonInitialize="gv1_CustomButtonInitialize" >
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                        BatchEditStartEditing="OnStartEditing"  BatchEditEndEditing="OnEndEditing" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        CustomButtonClick="OnCustomClick"/>
                                                    <SettingsPager Mode="ShowAllRecords"/>
                                                    <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="200" ShowFooter="True"  /> 
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False" VisibleIndex="0">
                                                        </dx:GridViewDataTextColumn>                                                        
                                                        <dx:GridViewDataTextColumn FieldName="PropertyNumber" VisibleIndex="1" Width="300px" Name="glPropertyNumber">
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
                                                                    valchange = true;
                                                                    }, 1000);
                                                                  }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <%--ValueChanged="function (s, e){ cp.PerformCallback('PropertyInformation');  e.processOnServer = false;}"--%>
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" Width="0px" Name="glItemCode">
                                                             <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="glItem" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" >
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
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode"  Width="0px" Name="glClassCode" Caption="ClassCode">
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
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode"  Width="0px" Name ="glSizeCode" Caption="SizeCode">
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
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="Qty" Name="Qty" Caption="Quantity" VisibleIndex="3" Width="180px">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CINQty" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents NumberChanged ="autocalculate"/>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="UnitCost" Name="UnitCost" Caption="Unit Cost" VisibleIndex="4" Width="0px">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CINUnitCost" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" DisplayFormatString="{0:N}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
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
                                                                <ClientSideEvents NumberChanged ="autocalculate"/>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn ReadOnly="true" FieldName="SoldAmount" VisibleIndex="7" Width="230px" Caption="SoldAmount">
                                                            <PropertiesTextEdit ClientInstanceName="CINSoldAmount"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <%--<dx:GridViewDataSpinEditColumn FieldName="SoldAmount" Name="SoldAmount" Caption="Sold Amount" VisibleIndex="9" Width="80px">
                                                        <PropertiesSpinEdit Increment="0" ClientInstanceName="CINSoldAmount" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0"  DisplayFormatString="{0:N}">
                                                            
                                                        </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>--%>
                                                        <dx:GridViewDataTextColumn FieldName="PropertyStatus" VisibleIndex="8"  Caption="PropertyStatus" Width="0px">   
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
                                                        </dx:GridViewDataCheckColumn>
                                                        <dx:GridViewDataTextColumn FieldName="VATCode" VisibleIndex="10" Width="80px" Caption="VATCode">   
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
                                                        </dx:GridViewDataSpinEditColumn>
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
                                                        </dx:GridViewDataTextColumn>--%>
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
                                <dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
                                    <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                                </dx:ASPxButton>
                            </td>
                            <td>
                                <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
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
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.AssetDisposal" DataObjectTypeName="Entity.AssetDisposal" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.AssetDisposal+AssetDisposalDetail" DataObjectTypeName="Entity.AssetDisposal+AssetDisposalDetail" DeleteMethod="DeleteAssetDisposalDetail" InsertMethod="AddAssetDisposalDetail" UpdateMethod="UpdateAssetDisposalDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsJournalEntry" runat="server" SelectMethod="getJournalEntry" TypeName="Entity.AssetDisposal+JournalEntry" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.AssetDisposal+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT *, ItemCode AS ClassCode, ItemCode AS SizeCode from Accounting.AssetDisposalDetail WHERE DocNumber IS NULL"
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

    <asp:SqlDataSource ID="SoldToLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode,Name FROM Masterfile.[BPCustomerInfo] WHERE ISNULL([IsInactive],0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <%--<asp:SqlDataSource ID="PropertyNumberLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PropertyNumber,ItemCode FROM Accounting.[AssetInv] WHERE Status IN ('O','F','P','C') and ISNULL(DateRetired,'') = ''"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="AssetAcquisitionLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PropertyNumber,ItemCode,ColorCode,ClassCode,SizeCode,Qty,0 AS UnitPrice,0 AS UnitCost,0 AS SoldAmount,0 AS IsVat,0 AS Rate,Status AS PropertyStatus,'' AS VATCode FROM Accounting.[AssetInv] WHERE Status IN ('O','F','P','C') and ISNULL(DateRetired,'') = ''"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>--%>

    
    <asp:SqlDataSource ID="PropertyNumberLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PropertyNumber,  TransType,  DocNumber,  AI.ItemCode,  I.FullDesc AS Description,  ColorCode,  ClassCode,  SizeCode,  Life,  DepreciationMethod,  
        DateAcquired,  DateRetired,  StartOfDepreciation,  Qty,  UnitCost,  AcquisitionCost,  AmountSold,  SalvageValue,  MonthlyDepreciation,  AccumulatedDepreciation,  BookValue,  OtherCost,  ParentProperty,  AssignedTo,  Department,  Location,  WarehouseCode,  DepreciationAccountCode,  DepreciationSubsiCode,  
        DepreciationProfitCenter, DepreciationCostCenter,  AccumulatedAccountCode,  AccumulatedSubsiCode,  AccumulatedProfitCenter,  AccumulatedCostCenter,  GainLossAccount,  ThisMonth,  Status FROM Accounting.[AssetInv] AI LEFT JOIN Masterfile.Item I ON AI.ItemCode = I.ItemCode WHERE ISNULL(DateRetired,'') = '' AND Status IN ('O','F','P','C')  AND PropertyNumber IN (SELECT DISTINCT PropertyNumber FROM Accounting.AssetInvDetail)"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="AssetAcquisitionLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PropertyNumber,  TransType,  DocNumber,  AI.ItemCode,  I.FullDesc AS Description,  ColorCode,  ClassCode,  SizeCode,  Life,  DepreciationMethod,  
        DateAcquired,  DateRetired,  StartOfDepreciation,  Qty,  UnitCost,  AcquisitionCost,  AmountSold,  SalvageValue,  MonthlyDepreciation,  AccumulatedDepreciation,  BookValue,  OtherCost,  ParentProperty,  AssignedTo,  Department,  Location,  WarehouseCode,  DepreciationAccountCode,  DepreciationSubsiCode,  
        DepreciationProfitCenter, DepreciationCostCenter,  AccumulatedAccountCode,  AccumulatedSubsiCode,  AccumulatedProfitCenter,  AccumulatedCostCenter,  GainLossAccount,  ThisMonth,  Status FROM Accounting.[AssetInv] AI LEFT JOIN Masterfile.Item I ON AI.ItemCode = I.ItemCode"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>


    <asp:SqlDataSource ID="VatCodeLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Rate,TCode,Description FROM Masterfile.Tax WHERE ISNULL(IsInactive,0) = 0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    
    <!--#endregion-->
</body>
</html>


