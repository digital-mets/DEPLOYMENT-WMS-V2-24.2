<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmCountSheet.aspx.cs" Inherits="GWL.WMS.frmCountSheet" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title></title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 700px; /*Change this whenever needed*/
        }

        .Entry {
            width: 914px; /*Change this whenever needed*/
            padding: 10px;
            margin: 20px auto;
            background: #FFF;
            border-radius: 10px;
            -webkit-border-radius: 10px;
            -moz-border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
            -moz-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
            -webkit-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
        }

        .pnl-content {
            text-align: right;
        }

        .error-cell {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
        }
    </style>
    <!--#endregion-->

    <!--#region Javascript-->
    <script>
        var isValid = false;
        var isValid2 = true;
        var counterror = 0;
        var copyFlag;
        var mainindex;

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        //function calcuinit(s, e) {
        //    autocalculateALL();
        //}

        //function calcuinit2(s, e) {
        //    autocalculateALL2();
        //}

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var index1;
        var BulkQty;
        var item;
        var module = getParameterByName("transtype");
        var id = getParameterByName("docnumber");
        var entry = getParameterByName("entry");
        var warehouse = getParameterByName("warehouse");
        var customer = getParameterByName("customer");
        var StandardQty;
        var StandardKilo;
        var IsStandard;

        $(document).ready(function () {
            PerfStart(module, entry, id, warehouse, item);
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
            cp.PerformCallback("Update");
        }

        function OnConfirm(s, e) {//function upon saving entry
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {
            if (s.cp_message != null) {
                alert(s.cp_message);
                delete (s.cp_message);
                countsheetheader.Refresh();
            }

            if (s.cp_error != null) {
                alert(s.cp_error);
                delete (s.cp_error);
            }

            if (s.cp_gensuccess) {
                if (!alert('Successfully Generated! Please wait while this countsheet reloads...')) {
                    txtFrom.SetText(null);
                    txtTo.SetText(null);
                    txtPallet.SetText(null);
                    txtExpDate.SetText(null);
                    txtMfgDate.SetText(null);
                    txtQty.SetText(null);
                    window.location.reload();
                }
            }

        }

        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            index1 = e.visibleIndex;

            if (s.batchEditApi.GetCellValue(e.visibleIndex, "PutawayDate") != null) {
                e.cancel = true;
            }

            //if (e.focusedColumn.fieldName === "Location") { //Check the column name
            //    //gl.GetInputElement().value = cellInfo.value; //Gets the column value
            //    isSetTextRequired = true;
            //}

            if (copyFlag) {
                copyFlag = false;
                for (var i = 0; i < s.GetColumnsCount(); i++) {
                    var column = s.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined || column.fieldName == "UsedQty" || column.fieldName == "LineNumber" || column.fieldName == "CWeight" || column.fieldName == "RecordId")
                        continue;
                    ProcessCells(0, e, column, s);
                }
            }

            function ProcessCells(selectedIndex, e, column, s) {
                if (selectedIndex == 0) {
                    if (column.fieldName == e.focusedColumn.fieldName)
                        e.rowValues[column.index].value = s.batchEditApi.GetCellValue(index, column.fieldName);
                    else
                        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, s.batchEditApi.GetCellValue(index, column.fieldName));
                }
            }

            //console.log(e.focusedColumn.fieldName);
            if (e.focusedColumn.fieldName === "PalletID" && module === "WMSOUT") {
                //glpallet.GetInputElement().value = cellInfo.value;
                //isSetTextRequired = true;
                if (module == "WMSOUT") {
                    index1 = e.visibleIndex;
                    BulkQty = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "DocBulkQty");
                    item = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "ItemCode");
                }

            }

            if (e.focusedColumn.fieldName === "DocBulkQty" && module === "WMSOUT") {
                //glpallet.GetInputElement().value = cellInfo.value;
                //isSetTextRequired = true;
                index1 = e.visibleIndex;
                //BulkQty = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "DocBulkQty");
                item = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "ItemCode");
                if (module == "WMSOUT") {
                    index1 = e.visibleIndex;
                    //BulkQty = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "DocBulkQty");
                    item = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "ItemCode");
                }
            }

            if (e.focusedColumn.fieldName === "ItemCode" && module === "WMSOUT") {
                //glpallet.GetInputElement().value = cellInfo.value;
                //isSetTextRequired = true;
                index1 = e.visibleIndex;
                //BulkQty = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "DocBulkQty");
                item = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "ItemCode");
                if (module == "WMSOUT") {
                    index1 = e.visibleIndex;
                    //BulkQty = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "DocBulkQty");
                    item = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "ItemCode");
                }
            }
        }

        function OnEndEditing(s, e) {
            var cellInfo = e.rowValues[currentColumn.index];
            var mfgdate;
            var expdate;

            if (currentColumn.fieldName === "CWExpiryDate") {
                expdate = cellInfo.value;
                mfgdate = s.batchEditApi.GetCellValue(e.visibleIndex, "CWManufacturingDate");

                // Validate the dates
                if (new Date(mfgdate) >= new Date(expdate)) {
                    alert("Manufacturing Date cannot be later than Expiration Date.");

                    cellInfo.value = s.batchEditApi.GetCellValue(e.visibleIndex, "CWExpiryDate");
                }
            }

            if (currentColumn.fieldName === "CWManufacturingDate") {
                expdate = s.batchEditApi.GetCellValue(e.visibleIndex, "CWExpiryDate");
                mfgdate = cellInfo.value;

                // Validate the dates
                if (new Date(mfgdate) >= new Date(expdate)) {
                    alert("Manufacturing Date cannot be later than Expiration Date.");

                    cellInfo.value = s.batchEditApi.GetCellValue(e.visibleIndex, "CWManufacturingDate");
                }
            }

            if (currentColumn.fieldName === "CWBulkQty") {
                setTimeout(function () {
                    s.batchEditApi.StartEdit(e.visibleIndex, "CWPalletID");
                }, 0); // Delay to ensure proper focus handling
            }

            if (currentColumn.fieldName === "DocBulkQty") {
                setTimeout(function () {
                    s.batchEditApi.StartEdit(e.visibleIndex, "PalletID");
                }, 0); // Delay to ensure proper focus handling
            }

            if (currentColumn.fieldName === "CWPalletID") {

            }
        }

        function GridEnd(s, e) {
            //console.log('gridend');
            val = s.GetGridView().cp_codes;
            if (val != null) {
                temp = val.split(';');
            }
            if (valchange) {
                valchange = false;
                var column = countsheetsubsi_Out.GetColumn(6);

                ProcessCells2(0, index1, column, countsheetsubsi_Out);
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
                //if (invalidChange != true) {// remove by SA 5/16/2024
                //   
                //}
                //invalidChange = false;
                s.batchEditApi.SetCellValue(focused, "Qty", temp[0]);
            }
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            countsheetsubsi_Out.batchEditApi.EndEdit();
        }

        function Clear(s, e) {
            txtFrom.SetText(null);
            txtTo.SetText(null);
            txtPallet.SetText(null);
            txtExpDate.SetText(null);
            txtMfgDate.SetText(null);
            txtQty.SetText(null);
        }

        function OnGenerate(s, e) {
            if (isValid && counterror < 1 && isValid2) {
                var generate = confirm('Are you sure you want to continue? Note: Changes are committed after generating');
                if (generate) {
                    cp.PerformCallback('Generate');
                }
            }
            else {
                counterror = 0;
                alert('Please check all the fields!');
            }
        }

        function onload() {
            var type = getParameterByName('type');
            var entry = getParameterByName('entry');
            var linenum = getParameterByName('linenumber');
            var warehouse = getParameterByName("warehouse");
            var item = getParameterByName("Item");
            var customer = getParameterByName("customer");
            if (type != null) {
                if (type == "Putaway" || type == "PutawayM") {
                    var g = fl.GetItemByName('LG');
                    var g2 = fl.GetItemByName('Pallet');
                    //g2.SetVisible(!g.GetVisible());
                    g.SetVisible(!g.GetVisible());
                }
            }
            if (linenum == 'null') {
                var g = fl.GetItemByName('LG');
                var inf = fl.GetItemByName('Inf');
                g.SetVisible(!g.GetVisible());
                inf.SetVisible(!inf.GetVisible());
                btnCancel.SetVisible(false);
            }
            // Mjay Disable promping 10/9/2024
            //if (entry != "V") {
            //    alert('Please generate first, if you are going to change multiple values before making any changes to the grid.');
            //}
            //else {
            //    var g = fl.GetItemByName('LG');
            //    g.SetVisible(g.GetVisible());
            //}
        }

        //function SetDifference() {
        //    var diff = CheckDifference();
        //    if (diff > 0) {
        //        clientResult.SetText(diff.toString());
        //    }
        //}

        function CheckDifference() {
            if (txtMfgDate.GetText() != "" && txtExpDate.GetText() != "") {
                console.log('test');
                var startDate = new Date();
                var endDate = new Date();
                var difference = -1;
                startDate = txtMfgDate.GetDate();
                if (startDate != null) {
                    endDate = txtExpDate.GetDate();
                    var startTime = startDate.getTime();
                    var endTime = endDate.getTime();
                    difference = (endTime - startTime) / 86400000;
                }
                if (difference >= 0) {
                    isValid2 = true;
                }
                else {
                    isValid2 = false;
                }
            }
        }

        function checkdate(s, e) {
            CheckDifference()
            e.isValid = isValid2;
        }

        function OnCustomClick(s, e) {
            if (e.buttonID == "CopyButton" || e.buttonID == "CopyButton01" || e.buttonID == "CopyButton02") {
                index = e.visibleIndex;
                copyFlag = true;
                s.AddNewRow();
            }
        }

        function OnCancelClick(s, e) {
            if (countsheetsetup.GetVisible()) {
                countsheetsetup.CancelEdit();
            }
            if (countsheetsubsi.GetVisible()) {
                countsheetsubsi.CancelEdit();
            }
            if (countsheetsubsi_Out.GetVisible()) {
                countsheetsubsi_Out.CancelEdit();
            }
        }
        //var preventEndEditOnLostFocus = false;
        function gridLookup_KeyDown(s, e) { //Allows tabbing between gridlookup on details
            isSetTextRequired = false;
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode !== 9) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (countsheetsubsi_Out.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
        }
        function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            //if (keyCode == 13)
            countsheetsubsi_Out.batchEditApi.EndEdit();
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }
        //function UpdateLottables(values) {
        //    if (values != undefined) {
        //        values[1] = new Date(values[1]); // Parse temp[5] into a Date object
        //        values[2] = new Date(values[2]); // Parse temp[6] into a Date object
        //        values[6] = new Date(values[6]); // Parse temp[6] into a Date object

        //        //console.log(values)
        //        // Parse the given date string to create a Date object
        //        const expdate = new Date(values[2]);

        //        // Create a Date object for the current date and time
        //        const currentDate = new Date();

        //        if (currentDate > expdate) {
        //            let item = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "ItemCode");
        //            lblErrorDetails.SetText(`It seems that the pallet <b>${values[0]}</b> with the item <b>${item}</b> is already <b>EXPIRED</b>. Proceed in selecting the Pallet?`);
        //            ValidationPop.Show();
        //            dataExp = values;
        //        }
        //        else {
        //            for (var i = 0; i < grid.GetVisibleRowsOnPage(); i++) {

        //                var grid = ASPxClientGridView.Cast('countsheetsubsi_Out'); // Replace 'gridID' with your actual grid ID

        //                if (!isNaN(values[1].getTime())) {

        //                    countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "MkfgDate", values[1]);
        //                }

        //                if (!isNaN(values[2].getTime())) {

        //                    countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "ExpiryDate", values[2]);
        //                }

        //                if (!isNaN(values[6].getTime())) {

        //                    countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "RRDocdate", values[6]);
        //                }

        //                ////const bulkQty = values[5] > parseInt(countsheetsubsi_Out.batchEditApi.GetCellValue(index1, 'BulkQty'))
        //                ////        ? countsheetsubsi_Out.batchEditApi.GetCellValue(index1, 'BulkQty') : values[5];
        //                ////console.log(values[0]);
        //                //newpallet = values[0];
        //                ////console.log(index1);
        //                //countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "PalletID", values[0]);
        //                //countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "MkfgDate", values[1]);
        //                //countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "ExpiryDate", values[2]);
        //                //countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "Field1", values[3]);
        //                //countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "Location", values[4]);
        //                ////countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "BulkQty", values[5]);
        //                ////countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "RecordId", values[6]);
        //                //countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "RRdate", values[7]);
        //                //countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "Field3", values[8]);
        //                ////countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "Qty", 0);


        //                // Loop through all rows in the grid
        //                // Set the desired column values for each row
        //                grid.SetRowValues(i, 'PalletID', values[0]);
        //                grid.SetRowValues(i, 'MfgDate', values[1]);
        //                grid.SetRowValues(i, 'ExpirationDate', values[2]);
        //                grid.SetRowValues(i, 'BatchNumber', values[3]);
        //                grid.SetRowValues(i, 'Location', values[4]);
        //                //grid.SetRowValues(i, 'RemainingQty', values[5]);
        //            }

        //        }


        //        countsheetsubsi_Out.batchEditApi.EndEdit();

        //        loader.Hide();
        //    }
        //}

        function UpdateLottables(values) {
            //console.log(values);
            if (values != undefined) {
                values[1] = new Date(values[1]); // Parse MfgDate into a Date object
                values[2] = new Date(values[2]); // Parse ExpirationDate into a Date object
                values[7] = new Date(values[7]); // Parse RRDocdate into a Date object

                // Parse the given ExpirationDate and current date
                const expdate = new Date(values[2]);
                const currentDate = new Date();

                if (currentDate > expdate) {
                    let item = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "ItemCode");
                    lblErrorDetails.SetText(`It seems that the pallet <b>${values[0]}</b> with the item <b>${item}</b> is already <b>EXPIRED</b>. Proceed in selecting the Pallet?`);
                    ValidationPop.Show();
                    dataExp = values;
                }
                else if (index1 > 0) {
                    var grid = ASPxClientGridView.Cast('countsheetsubsi_Out'); // Replace 'countsheetsubsi_Out' with your actual grid ID

                    //console.log(grid.GetVisibleRowsOnPage());
                    //console.log(index1);

                    for (var i = 0; i < grid.GetVisibleRowsOnPage(); i++) {

                        if (!isNaN(values[1].getTime())) {
                            grid.batchEditApi.SetCellValue(i, "MkfgDate", values[1]);
                        }

                        if (!isNaN(values[2].getTime())) {
                            grid.batchEditApi.SetCellValue(i, "ExpiryDate", values[2]);
                        }

                        if (!isNaN(values[7].getTime())) {
                            grid.batchEditApi.SetCellValue(i, "RRdate", values[7]);
                        }

                        grid.batchEditApi.SetCellValue(i, "PalletID", values[0]);
                        grid.batchEditApi.SetCellValue(i, "MkfgDate", values[1]);
                        grid.batchEditApi.SetCellValue(i, "ExpiryDate", values[2]);
                        grid.batchEditApi.SetCellValue(i, "Field1", values[3]);
                        grid.batchEditApi.SetCellValue(i, "Location", values[4]);
                        grid.batchEditApi.SetCellValue(i, "RRdate", values[7]);
                        grid.batchEditApi.SetCellValue(i, "Field3", values[8]);
                    }
                }
                else {
                    var grid = ASPxClientGridView.Cast('countsheetsubsi_Out'); // Replace 'countsheetsubsi_Out' with your actual grid ID

                    console.log(grid.GetVisibleRowsOnPage());
                    console.log(index1);
                    console.log(values[1]);
                    console.log(values[2]);
                    console.log(values[6]);

                    if (!isNaN(values[1].getTime())) {
                        grid.batchEditApi.SetCellValue(index1, "MkfgDate", values[1]);
                    }

                    if (!isNaN(values[2].getTime())) {
                        grid.batchEditApi.SetCellValue(index1, "ExpiryDate", values[2]);
                    }

                    if (!isNaN(values[7].getTime())) {
                        grid.batchEditApi.SetCellValue(index1, "RRdate", values[7]);
                    }

                    grid.batchEditApi.SetCellValue(index1, "PalletID", values[0]);
                    grid.batchEditApi.SetCellValue(index1, "MkfgDate", values[1]);
                    grid.batchEditApi.SetCellValue(index1, "ExpiryDate", values[2]);
                    grid.batchEditApi.SetCellValue(index1, "Field1", values[3]);
                    grid.batchEditApi.SetCellValue(index1, "Location", values[4]);
                    grid.batchEditApi.SetCellValue(index1, "RRdate", values[7]);
                    grid.batchEditApi.SetCellValue(index1, "Field3", values[8]);
                }

                countsheetsubsi_Out.batchEditApi.EndEdit();
                loader.Hide();
            }
        }


        function UpdateItem(values) {
            countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "ItemCode", values);
            countsheetsubsi_Out.batchEditApi.EndEdit();
            loader.Hide();
        }

        function Standard(s, e) {
            var Qty = s.GetValue();
            var LineNumber = getParameterByName('linenumber');
            var DocNumber = getParameterByName('docnumber');

            $.ajax({
                type: 'POST',
                url: "frmCountSheet.aspx/FindStandardItem",
                contentType: "application/json",
                data: '{TransType: ' + JSON.stringify(module) + ', DocNumber: ' + JSON.stringify(DocNumber) + ', LineNumber: ' + JSON.stringify(LineNumber) + '}',
                dataType: "json",
                success: function (data) {
                    if (data.d != '') {
                        let datas = JSON.parse(data.d);
                        datas.forEach(function (obj, i) {

                            IsStandard = obj.Standard;
                            StandardKilo = (obj.StandardQty * Qty);
                            StandardQty = obj.StandardQty;

                            if (IsStandard == true || IsStandard == 1) {
                                if (module == "WMSINB") {
                                    countsheetsetup.batchEditApi.SetCellValue(index1, "CWeight", StandardKilo);
                                } else if (module == "WMSPICK") {
                                    countsheetsubsi.batchEditApi.SetCellValue(index1, "UsedQty", StandardKilo.toString());
                                } else {
                                    countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "UsedQty", StandardKilo.toString());
                                }
                            }
                        });
                    }
                }
            });
        }

        function validateExp(datae, cond) {

            if (cond == false) {

                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "PalletID", null);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "MkfgDate", null);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "ExpiryDate", null);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "Field1", null);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "Location", null);

                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "RecordId", null);
                //countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "RRDocdate", null);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "Field3", null);

            } else {
                datae[1] = new Date(datae[1]); // Parse temp[5] into a Date object
                datae[2] = new Date(datae[2]); // Parse temp[6] into a Date object
                datae[6] = new Date(datae[6]); // Parse temp[6] into a Date object
                console.log(datae[1]);
                console.log(datae[2]);
                if (!isNaN(datae[1].getTime())) {

                    countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "MkfgDate", datae[1]);
                }

                if (!isNaN(datae[2].getTime())) {

                    countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "ExpiryDate", datae[2]);
                }

                //if (!isNaN(datae[6].getTime())) {

                //    countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "RRDocdate", datae[6]);
                //}

                //const bulkQty = datae[5] > parseInt(gv1.batchEditApi.GetCellValue(index1, 'BulkQty'))
                //        ? gv1.batchEditApi.GetCellValue(index1, 'BulkQty') : datae[5];

                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "PalletID", datae[0]);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "MkfgDate", datae[1]);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "ExpiryDate", datae[2]);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "Field1", datae[3]);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "Location", datae[4]);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "BulkQty", datae[5]);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "RecordId", datae[6]);
                //countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "RRDocdate", datae[7]);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "Field3", datae[8]);
                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "Qty", 0);

            }

            ValidationPop.Hide();
        }

        function Validate(s, e) {
            var Kilo = s.GetValue();
            var Qty;
            var LineNumber = getParameterByName('linenumber');
            var DocNumber = getParameterByName('docnumber');

            if (module == "WMSINB") {
                Qty = countsheetsetup.batchEditApi.GetCellValue(index1, "CWBulkQty");
            } else if (module == "WMSPICK") {
                Qty = countsheetsubsi.batchEditApi.GetCellValue(index1, "DocBulkQty");
            } else {
                Qty = countsheetsubsi_Out.batchEditApi.GetCellValue(index1, "CWExpiryDate");
            }

            $.ajax({
                type: 'POST',
                url: "frmCountSheet.aspx/FindStandardItem",
                contentType: "application/json",
                data: '{TransType: ' + JSON.stringify(module) + ', DocNumber: ' + JSON.stringify(DocNumber) + ', LineNumber: ' + JSON.stringify(LineNumber) + '}',
                dataType: "json",
                success: function (data) {
                    if (data.d != '') {
                        let datas = JSON.parse(data.d);
                        datas.forEach(function (obj, i) {

                            IsStandard = obj.Standard;
                            StandardKilo = (obj.StandardQty * Qty);
                            StandardQty = obj.StandardQty;
                        });

                        if (Kilo != StandardKilo && (IsStandard == 1 || IsStandard == true)) {
                            alert("Input Kilo is Invalid based on standard item config");

                            if (module == "WMSINB") {
                                countsheetsetup.batchEditApi.SetCellValue(index1, "CWeight", StandardKilo);
                            } else if (module == "WMSPICK") {
                                countsheetsubsi.batchEditApi.SetCellValue(index1, "UsedQty", StandardKilo);
                            } else {
                                countsheetsubsi_Out.batchEditApi.SetCellValue(index1, "UsedQty", StandardKilo);
                            }
                        }
                    }
                }
            });
        }

        function ValidatePallet(s, e) {
            var Pallet = s.GetValue();
            var OldValue = countsheetsetup.batchEditApi.GetCellValue(e.visibleIndex, "CWPalletID");

            $.ajax({
                type: 'POST',
                url: "frmCountSheet.aspx/ValidatePallet",
                contentType: "application/json",
                data: '{PalletID: ' + JSON.stringify(Pallet) + '}',
                dataType: "json",
                success: function (data) {
                    if (data.d != '') {
                        if (data.d != "Validated") {
                            alert(data.d.toString());
                            countsheetsetup.batchEditApi.SetCellValue(index1, "CWPalletID", OldValue);
                            return;
                        }
                        else {
                            return;
                        }
                    }
                }
            });
        }

    </script>
    <!--#endregion-->
</head>
<body style="height: 700px" onload="onload()">
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" ClientInstanceName="fl" runat="server" DataSourceID="" Height="565px" Width="910px" Style="margin-left: -3px" ColCount="2">
                        <Items>
                            <dx:LayoutItem Caption="Transaction Type">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxTextBox ID="txtTransType" runat="server" Width="170px" ReadOnly="true">
                                        </dx:ASPxTextBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Doc No.">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server">
                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" Width="170px" ReadOnly="true">
                                        </dx:ASPxTextBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>

                            <%--       <dx:LayoutGroup Caption="Generate details" ColSpan="2" ColCount="7" Name="LG">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtFrom" ClientInstanceName="txtFrom" runat="server" Width="50px">
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
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxLabel ID="frmlayout1_E9" runat="server" Text="~" Width="10px">
                                                </dx:ASPxLabel>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtTo" ClientInstanceName="txtTo" runat="server" Width="50px">
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
                                    <dx:LayoutItem Caption="Pallet ID" Name="Pallet">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtPallet" ClientInstanceName="txtPallet" runat="server" Width="90px">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Mfg Date">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxDateEdit ID="txtMfgDate" ClientInstanceName="txtMfgDate" runat="server" Width="80px">
                                                </dx:ASPxDateEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Exp. Date">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxDateEdit ID="txtExpDate" ClientInstanceName="txtExpDate" runat="server" Width="80px">
                                                    <ClientSideEvents Validation="checkdate" />
                                                </dx:ASPxDateEdit>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Orig. Base Qty">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxTextBox ID="txtQty" ClientInstanceName="txtQty" runat="server" Width="50px">
                                                </dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:EmptyLayoutItem>
                                    </dx:EmptyLayoutItem>
                                    <dx:EmptyLayoutItem>
                                    </dx:EmptyLayoutItem>
                                    <dx:EmptyLayoutItem>
                                    </dx:EmptyLayoutItem>
                                    <dx:EmptyLayoutItem>
                                    </dx:EmptyLayoutItem>
                                    <dx:EmptyLayoutItem>
                                    </dx:EmptyLayoutItem>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxButton ID="frmlayout1_E6" runat="server" Text="Clear" AutoPostBack="false" UseSubmitBehavior="false">
                                                    <ClientSideEvents Click="Clear" />
                                                </dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxButton ID="genbtn" runat="server" Text="Generate" AutoPostBack="false" UseSubmitBehavior="false">
                                                    <ClientSideEvents Click="OnGenerate" />
                                                </dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>--%>

                            <dx:LayoutGroup Caption="Information" ColSpan="2" Name="Inf">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="header" runat="server" DataSourceID="countsheetheader"
                                                    ClientInstanceName="countsheetheader" KeyFieldName="TransDoc;TransLine" Width="742px" OnCellEditorInitialize="headerline_CellEditorInitialize">
                                                    <Settings HorizontalScrollBarMode="Visible" />
                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                            <dx:LayoutGroup Caption="Details" ColSpan="2">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <div id="loadingcont">
                                                    <%--Inbound Catch Weigth Start--%>
                                                    <dx:ASPxGridView ID="countsheetsetup" runat="server" AutoGenerateColumns="False" ClientInstanceName="countsheetsetup" DataSourceID="countsheetdetailsetup" KeyFieldName="RecordId;CWDocNumber" OnCellEditorInitialize="countsheetsetup_CellEditorInitialize" OnCommandButtonInitialize="gv_CommandButtonInitialize" Visible="False" Width="800px" OnInitNewRow="gridView_InitNewRow">
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" />
                                                        <SettingsEditing Mode="Batch">
                                                        </SettingsEditing>
                                                        <Settings ShowStatusBar="Hidden" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" />
                                                        <Columns>
                                                            <dx:GridViewDataTextColumn FieldName="RecordId" ShowInCustomizationForm="True" UnboundType="String" Visible="False" VisibleIndex="0" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="50px">
                                                                <CustomButtons>
                                                                    <dx:GridViewCommandColumnCustomButton ID="CopyButton01" Text="Copy">
                                                                        <Image IconID="edit_copy_16x16" ToolTip="Clone"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>
                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CWDocNumber" ShowInCustomizationForm="True" UnboundType="String" Visible="False" VisibleIndex="1" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CWLineNumber" ShowInCustomizationForm="True" UnboundType="String" Visible="False" VisibleIndex="2" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CWSubLineNumber" Visible="False" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="3" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CWBulkQty" Caption="Qty" PropertiesTextEdit-NullText="1" PropertiesTextEdit-NullDisplayText="1" UnboundType="String" ShowInCustomizationForm="True" VisibleIndex="4" Width="100px">
                                                                <PropertiesTextEdit>
                                                                    <ClientSideEvents ValueChanged="function(s, e) { Standard(s, e); }" />
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CWeight" Caption="Kilos" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="5" Width="100px">
                                                                <PropertiesTextEdit>
                                                                    <ClientSideEvents ValueChanged="function(s, e) { Validate(s, e); }" />
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CWItemCode" Caption="ItemCode" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="6" Width="80px" ReadOnly="true">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CWPalletID" Caption="PalletID" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7" Width="100px">
                                                                <PropertiesTextEdit>
                                                                    <ClientSideEvents ValueChanged="function(s, e) { ValidatePallet(s, e); }" />
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CWBatchNumber" Caption="BatchNumber" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="8" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field1" Caption="Location" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="9" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field2" Caption="RRDate" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="10" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="11" Width="100px" Visible="false">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="12" Width="100px" Visible="false">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="13" Width="100px" Visible="false">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="14" Width="100px" Visible="false">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="15" Width="100px" Visible="false">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field8" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="16" Width="100px" Visible="false">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field9" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="100px" Visible="false">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CWLotID" ShowInCustomizationForm="True" Caption="LotID" UnboundType="String" VisibleIndex="18" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataDateColumn FieldName="CWExpiryDate" ShowInCustomizationForm="True" UnboundType="String" Caption="Expiry Date" VisibleIndex="20" Width="100px">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataDateColumn FieldName="CWManufacturingDate" ShowInCustomizationForm="True" UnboundType="String" Caption="Manufacturing Date" VisibleIndex="21" Width="100px">
                                                            </dx:GridViewDataDateColumn>
                                                        </Columns>
                                                        <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                        <SettingsCommandButton>
                                                            <NewButton>
                                                                <Image IconID="actions_addfile_16x16"></Image>
                                                            </NewButton>
                                                            <DeleteButton>
                                                                <Image IconID="actions_cancel_16x16"></Image>
                                                            </DeleteButton>
                                                        </SettingsCommandButton>
                                                        <SettingsPager Mode="ShowAllRecords" />
                                                        <SettingsBehavior AllowSort="false" />
                                                    </dx:ASPxGridView>
                                                    <%--Inbound Catch Weigth End--%>

                                                    <%--PickList Catch Weigth Start--%>
                                                    <dx:ASPxGridView ID="countsheetsubsi" runat="server" AutoGenerateColumns="False" ClientInstanceName="countsheetsubsi" DataSourceID="countsheetdetailsubsi" KeyFieldName="TransDoc;TransLine;LineNumber" OnCellEditorInitialize="countsheetsubsi_CellEditorInitialize" OnCommandButtonInitialize="gv_CommandButtonInitialize" Visible="False" Width="742px" OnInitNewRow="gridView_InitNewRow">
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" />
                                                        <SettingsEditing Mode="Batch">
                                                        </SettingsEditing>
                                                        <Settings ShowStatusBar="Hidden" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" />
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="50px">
                                                                <CustomButtons>
                                                                    <dx:GridViewCommandColumnCustomButton ID="CopyButton" Text="Copy">
                                                                        <Image IconID="edit_copy_16x16" ToolTip="Clone"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>
                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" Visible="True" VisibleIndex="0" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransDoc" ShowInCustomizationForm="True" UnboundType="String" Visible="True" VisibleIndex="1" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransLine" ShowInCustomizationForm="True" UnboundType="String" Visible="True" VisibleIndex="2" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="3" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="DocBulkQty" Caption="Qty" PropertiesTextEdit-NullText="1" PropertiesTextEdit-NullDisplayText="1" ShowInCustomizationForm="True" VisibleIndex="4" Width="80px">
                                                                <PropertiesTextEdit>
                                                                    <ClientSideEvents ValueChanged="function(s, e) { Standard(s, e); }" />
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="UsedQty" Caption="Kilos" ShowInCustomizationForm="True" VisibleIndex="5" Width="80px">
                                                                <PropertiesTextEdit>
                                                                    <ClientSideEvents ValueChanged="function(s, e) { Validate(s, e); }" />
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="PalletID" ShowInCustomizationForm="True" VisibleIndex="6" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="ToPalletID" ShowInCustomizationForm="True" VisibleIndex="7" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="SystemQty" ShowInCustomizationForm="True" VisibleIndex="8" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="VarianceQty" ShowInCustomizationForm="True" VisibleIndex="9" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Location" ShowInCustomizationForm="True" VisibleIndex="10" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field1" Caption="BatchNumber" ShowInCustomizationForm="True" VisibleIndex="11" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field3" Caption="Lot ID" ShowInCustomizationForm="True" VisibleIndex="12" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="ToLoc" ShowInCustomizationForm="True" VisibleIndex="13" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataDateColumn FieldName="ExpirationDate" ShowInCustomizationForm="True" VisibleIndex="14" Width="100px">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataDateColumn FieldName="MfgDate" ShowInCustomizationForm="True" VisibleIndex="15" Width="100px">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataDateColumn FieldName="RRdate" ShowInCustomizationForm="True" VisibleIndex="16" Width="100px">
                                                            </dx:GridViewDataDateColumn>
                                                        </Columns>
                                                        <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                        <SettingsCommandButton>
                                                            <NewButton>
                                                                <Image IconID="actions_addfile_16x16"></Image>
                                                            </NewButton>
                                                            <DeleteButton>
                                                                <Image IconID="actions_cancel_16x16"></Image>
                                                            </DeleteButton>
                                                        </SettingsCommandButton>
                                                        <SettingsPager Mode="ShowAllRecords" />
                                                        <SettingsBehavior AllowSort="false" />
                                                    </dx:ASPxGridView>
                                                    <%--PickList Catch Weigth End--%>

                                                    <%--PickList Catch Weigth Start--%>
                                                    <dx:ASPxGridView ID="countsheetsubsi_Out" runat="server" AutoGenerateColumns="False" ClientInstanceName="countsheetsubsi_Out" DataSourceID="countsheetdetailsubsi_Outbound" KeyFieldName="TransDoc;TransLine;LineNumber" OnCellEditorInitialize="countsheetsubsi_CellEditorInitialize" OnCommandButtonInitialize="gv_CommandButtonInitialize" Visible="False" Width="742px">
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" />
                                                        <SettingsEditing Mode="Batch">
                                                        </SettingsEditing>
                                                        <Settings ShowStatusBar="Hidden" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" />
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="50px">
                                                                <CustomButtons>
                                                                    <dx:GridViewCommandColumnCustomButton ID="CopyButton02" Text="Copy">
                                                                        <Image IconID="edit_copy_16x16" ToolTip="Clone"></Image>
                                                                    </dx:GridViewCommandColumnCustomButton>
                                                                </CustomButtons>
                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" Visible="True" VisibleIndex="0" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransDoc" ShowInCustomizationForm="True" UnboundType="String" Visible="True" VisibleIndex="1" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransLine" ShowInCustomizationForm="True" UnboundType="String" Visible="True" VisibleIndex="2" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="3" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <%--<dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="true" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="4" Width="100px">
                                                            </dx:GridViewDataTextColumn>--%>
                                                            <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="5" Width="150px" Name="glItemCode">
                                                                <Settings AutoFilterCondition="Contains" />
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="itemcode_Init"
                                                                        DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="150px" OnLoad="gvLookupLoad">
                                                                        <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" Settings-VerticalScrollBarMode="Visible">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" AllowDragDrop="False" EnableRowHotTrack="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="ItemCode" Width="100px" ReadOnly="True" VisibleIndex="0">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="FullDesc" Width="200px" ReadOnly="True" VisibleIndex="1">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="function(s,e){gl.GetGridView().PerformCallback(item);e.processOnServer = false; }"
                                                                            RowClick="function(s,e){ 
                                                                           loader.SetText('Calculating');
                                                                            loader.Show();
                                                                           var g = gl.GetGridView();
                                                               
                                                                        g.GetRowValues(e.visibleIndex, 'ItemCode', UpdateItem); 
                                                                          }" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="DocBulkQty" Caption="Qty" ShowInCustomizationForm="True" VisibleIndex="5" Width="80px">
                                                                <PropertiesTextEdit NullText="1" NullDisplayText="1">
                                                                    <ClientSideEvents ValueChanged="function(s, e) { Standard(s, e); }" />
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="UsedQty" Caption="Kilos" ShowInCustomizationForm="True" VisibleIndex="6" Width="80px">
                                                                <PropertiesTextEdit>
                                                                    <ClientSideEvents ValueChanged="function(s, e) { Validate(s, e); }" />
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="PalletID" Name="PalletID" ShowInCustomizationForm="True" VisibleIndex="10" FieldName="PalletID">
                                                                <Settings AutoFilterCondition="Contains" />
                                                                <EditItemTemplate>
                                                                    <dx:ASPxGridLookup ID="glpallet" runat="server" AutoGenerateColumns="False" AutoPostBack="false" DataSourceID="sdsPallet" OnInit="glpallet_Init"
                                                                        KeyFieldName="PalletID" ClientInstanceName="glpallet" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                        <GridViewProperties Settings-ShowFilterRow="true">
                                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                                AllowSelectSingleRowOnly="True" />
                                                                        </GridViewProperties>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="PalletID" ReadOnly="true" VisibleIndex="0">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="MfgDate" ReadOnly="true" VisibleIndex="1">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="ExpirationDate" ReadOnly="true" VisibleIndex="2">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="BatchNumber" ReadOnly="true" VisibleIndex="3">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>

                                                                            <dx:GridViewDataTextColumn FieldName="Location" ReadOnly="true" VisibleIndex="4">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="RemainingKilo" ReadOnly="true" VisibleIndex="5">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="RemainingQty" ReadOnly="true" VisibleIndex="6">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="RecordId" ReadOnly="true" VisibleIndex="7" Visible="false">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="RRdate" ReadOnly="true" VisibleIndex="8" Visible="false">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="LotID" ReadOnly="true" VisibleIndex="4">
                                                                                <Settings AutoFilterCondition="Contains" />
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                            DropDown="function (s,e){glpallet.GetGridView().PerformCallback( item + '|' + BulkQty + '|' +'ItemCodeDropDown'  );
                                                                            e.processOnServer = false;                            }"
                                                                            CloseUp="gridLookup_CloseUp" RowClick="function(s,e){ 
                                                                           loader.SetText('Calculating');
                                                                            loader.Show();
                                                                           var g = glpallet.GetGridView();
                                                               
                                                                        g.GetRowValues(e.visibleIndex, 'PalletID;MfgDate;ExpirationDate;BatchNumber;Location;RemainingQty;RecordId;RRdate;LotID', UpdateLottables); 
                                                                    }" />
                                                                    </dx:ASPxGridLookup>
                                                                </EditItemTemplate>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Location" ReadOnly="true" ShowInCustomizationForm="True" VisibleIndex="10" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field1" Caption="BatchNumber" ReadOnly="true" ShowInCustomizationForm="True" VisibleIndex="11" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Field3" Caption="LotID" ReadOnly="true" ShowInCustomizationForm="True" VisibleIndex="12" Width="100px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataDateColumn FieldName="ExpiryDate" ReadOnly="true" ShowInCustomizationForm="True" VisibleIndex="14" Width="100px">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataDateColumn FieldName="MkfgDate" Caption="MfgDate" ReadOnly="true" ShowInCustomizationForm="True" VisibleIndex="15" Width="100px">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataDateColumn FieldName="RRdate" ReadOnly="true" ShowInCustomizationForm="True" VisibleIndex="16" Width="100px">
                                                            </dx:GridViewDataDateColumn>
                                                        </Columns>
                                                        <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                        <SettingsCommandButton>
                                                            <NewButton>
                                                                <Image IconID="actions_addfile_16x16"></Image>
                                                            </NewButton>
                                                            <DeleteButton>
                                                                <Image IconID="actions_cancel_16x16"></Image>
                                                            </DeleteButton>
                                                        </SettingsCommandButton>
                                                        <SettingsPager Mode="ShowAllRecords" />
                                                        <SettingsBehavior AllowSort="false" />
                                                    </dx:ASPxGridView>
                                                    <%--PickList Catch Weigth End--%>

                                                    <dx:ASPxGridView OnDataBound="countsheetsubsi_DataBound" ID="countsheetsubsi2" runat="server" AutoGenerateColumns="False" ClientInstanceName="countsheetsubsi" DataSourceID="countsheetdetailsubsi" KeyFieldName="TransDoc;TransLine;LineNumber" OnCellEditorInitialize="countsheetsubsi_CellEditorInitialize" OnCommandButtonInitialize="gv_CommandButtonInitialize" Visible="False" Width="742px">
                                                        <ClientSideEvents BatchEditConfirmShowing="OnConfirm" />
                                                        <SettingsEditing Mode="Batch">
                                                        </SettingsEditing>
                                                        <Settings ShowStatusBar="Hidden" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" />
                                                        <Columns>
                                                            <dx:GridViewDataTextColumn FieldName="TransType" Caption="TransType" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="0" Width="80px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransDoc" Caption="TransDoc" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="1" Width="80px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TransLine" Caption="TransLine" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="2" Width="80px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="LineNumber" Caption="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="3" Width="80px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="ItemCode" Caption="ItemCode" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="4" Width="80px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="ColorCode" Caption="ColorCode" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="5" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="ClassCode" Caption="ClassCode" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="6" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="SizeCode" Caption="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7" Width="0px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataSpinEditColumn FieldName="DocBulkQty" Caption="Qty" ShowInCustomizationForm="True" VisibleIndex="7" Width="80px">
                                                            </dx:GridViewDataSpinEditColumn>
                                                            <dx:GridViewDataTextColumn FieldName="UsedQty" Caption="Kilos" ShowInCustomizationForm="True" VisibleIndex="8" Width="80px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="Location" Caption="Location" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="10" Width="80px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="PalletID" Caption="PalletID" ShowInCustomizationForm="True" VisibleIndex="11" Width="80px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataDateColumn FieldName="ExpirationDate" Caption="ExpirationDate" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="12" Width="90px">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataDateColumn FieldName="MfgDate" Caption="MfgDate" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="13" Width="90px">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataDateColumn FieldName="RRdate" Caption="RRdate" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="14" Width="80px">
                                                            </dx:GridViewDataDateColumn>
                                                            <dx:GridViewDataTextColumn FieldName="ToLoc" Caption="ToLoc" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="15" Width="80px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="DocDate" Caption="DocDate" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="16" Width="80px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="BatchNo" Caption="BatchNo" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" Width="80px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="LotID" Caption="LotID" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="18" Width="80px">
                                                            </dx:GridViewDataTextColumn>
                                                        </Columns>
                                                        <SettingsPager Mode="ShowAllRecords" />
                                                        <SettingsBehavior AllowSort="false" />
                                                    </dx:ASPxGridView>
                                                </div>
                                                <%-- <dx:ASPxLabel runat="server" Text="Min: " Width="100px" ClientInstanceName="Min"></dx:ASPxLabel>
                                                <dx:ASPxLabel runat="server" Text="Max: " Width="100px" ClientInstanceName="Max"></dx:ASPxLabel>
                                                <dx:ASPxLabel runat="server" Text="Average: " Width="150px" ClientInstanceName="Average"></dx:ASPxLabel>
                                                <dx:ASPxLabel runat="server" Text="Sum: " Width="100px" ClientInstanceName="Sum"></dx:ASPxLabel>
                                                <dx:ASPxLabel runat="server" Text="Sum of BulkQty: " Width="177px" ClientInstanceName="Bulk"></dx:ASPxLabel>
                                                <dx:ASPxButton ID="btnCancel" runat="server" Text="Cancel Changes" ClientInstanceName="btnCancel" CausesValidation="false" AutoPostBack="false" UseSubmitBehavior="false">
                                                    <ClientSideEvents Click="OnCancelClick" />
                                                </dx:ASPxButton>--%>
                                                <dx:ASPxGridViewExporter ID="gridExport" runat="server" ExportedRowType="All" />
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>
                        </Items>
                    </dx:ASPxFormLayout>
                    <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                    <dx:ASPxButton ID="updateBtn" runat="server" Text="Update" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
                                        UseSubmitBehavior="false">
                                        <ClientSideEvents Click="OnUpdateClick" />
                                    </dx:ASPxButton>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
        <dx:ASPxPopupControl ID="ValidationPop" runat="server" HeaderText="Warning!" ClientInstanceName="ValidationPop" ContentStyle-HorizontalAlign="Center" Width="250px" Height="100px"
            ShowCloseButton="false" CloseOnEscape="False" Modal="True" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">

                    <dx:ASPxLabel ID="lblErrorDetails" runat="server" ClientInstanceName="lblErrorDetails"></dx:ASPxLabel>
                    <br />
                    <br />
                    <dx:ASPxButton ID="btnAccept" runat="server" Text="YES" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="true">
                        <ClientSideEvents Click="function (s, e){ 
                                        validateExp(dataExp,true);
                                        
                                        }" />
                    </dx:ASPxButton>


                    <dx:ASPxButton ID="btnClose" runat="server" Text="NO" AutoPostBack="false" CausesValidation="false">
                        <ClientSideEvents Click="function(s, e) { 
                         validateExp(dataExp,false);
                         
                        }" />

                    </dx:ASPxButton>

                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Calculating..."
            ClientInstanceName="loader" ContainerElementID="loadingcont">
        </dx:ASPxLoadingPanel>

    </form>

    <!--#region Region Datasource-->
    <%--    <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="5" Width="80px" UnboundType="String" />
                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="6" Width="80px" UnboundType="String" />
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="7" Width="80px" UnboundType="String" />
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="8" Width="80px" UnboundType="String" />--%>
    <asp:SqlDataSource ID="countsheetheader" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:ObjectDataSource ID="countsheetdetailsubsi_Outbound" runat="server" DataObjectTypeName="Entity.CountSheetSubsi_Outbound" SelectMethod="getdetail" TypeName="Entity.CountSheetSubsi_Outbound" UpdateMethod="UpdateCountSheetSubsi" DeleteMethod="DeleteCountSheetSubsi" InsertMethod="AddCountSheetSubsi">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:QueryStringParameter Name="LineNumber" QueryStringField="linenumber" Type="String" />
            <asp:QueryStringParameter Name="TransType" QueryStringField="transtype" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="countsheetdetailsubsi" runat="server" DataObjectTypeName="Entity.CountSheetSubsi" SelectMethod="getdetail" TypeName="Entity.CountSheetSubsi" UpdateMethod="UpdateCountSheetSubsi" DeleteMethod="DeleteCountSheetSubsi" InsertMethod="AddCountSheetSubsi">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:QueryStringParameter Name="LineNumber" QueryStringField="linenumber" Type="String" />
            <asp:QueryStringParameter Name="TransType" QueryStringField="transtype" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="countsheetdetailsetup" runat="server" DataObjectTypeName="Entity.CountSheetSetup" SelectMethod="getdetail" TypeName="Entity.CountSheetSetup" UpdateMethod="UpdateCountSheetSetup" DeleteMethod="DeleteCountSheetSetup" InsertMethod="AddCountSheetSetup">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:QueryStringParameter Name="LineNumber" QueryStringField="linenumber" Type="String" />
            <asp:QueryStringParameter Name="TransType" QueryStringField="transtype" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="locationsql" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>"
        SelectCommand="Select LocationCode,WarehouseCode,RoomCode from masterfile.location where PlantCode = @Plant" OnInit="Connection_Init">
        <SelectParameters>
            <asp:Parameter Name="Plant" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsPallet" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
</body>
</html>
