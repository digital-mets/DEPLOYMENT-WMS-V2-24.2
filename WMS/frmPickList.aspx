<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmPickList.aspx.cs" Inherits="GWL.frmPickList" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Picklist</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 1050px; /*Change this whenever needed*/
        }

        .Entry {
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
        }

        .dxeButtonEditSys input,
        .dxeTextBoxSys input {
            text-transform: uppercase;
        }

        .pnl-content {
            text-align: right;
        }

        .TotalsLabel {
            padding-left: 110px;
            background-color: #EBEBEB;
            font-weight: bold;
            text-align: right;
            border-top-width: 0px;
            border-left-width: 0px;
        }

        .Totalss {
            padding-left: 20px;
            background-color: #EBEBEB;
            text-align: left;
            border-top-width: 0px;
            border-left-width: 0px;
        }

        #cp_frmlayout1_PC_0_tblTransfer {
            width: 700px !important;
        }

        @media only screen and (max-width: 760px) {
            #cp_frmlayout1_PC_0_tblTransfer {
                margin-left: 0 !important;
                width: 400px !important;
            }
        }
    </style>
    <!--#endregion-->
    <!--#region Region Javascript-->
    <script>
        var isValid = true;
        var counterror = 0;
        var validateIndex = 0;
        //var prevQ = 0; -- remove by SA 5/16/2024
        //var invalidChange = false;
        var deletedLine = [];
        var addedLine = [];
        var newpallet = "";
        var deteledLinenumbers = "";


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
            //console.log("TEST");
            //console.log(deteledLinenumbers);
            if (deteledLinenumbers != "") {
                cp.PerformCallback(`Deletedline|${deteledLinenumbers}`)
            }
            //console.log(deletedLine);
            //gvocn.batchEditApi.EndEdit();

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

            if (e.requestTriggerID === "cp" || e.requestTriggerID === undefined)//disables confirmation message upon saving.
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            if (s.cp_success) {
                alert(s.cp_message);
                //console.log(s.cp_success);
                if (s.cp_message.includes("Successfully")) {
                    //console.log('Success');
                    deteledLinenumbers = "";
                }
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);

                if (deletedLine.length > 0) { //prevent/delete showing the deleted line after an alert message
                    deletedLine.forEach((index) => {
                        gv1.DeleteRow(index);
                    })
                }

                if (s.cp_forceclose) {//NEWADD

                    delete (s.cp_forceclose);
                    window.close();
                }

            }

            if (s.cp_close) {
                if (s.cp_message !== null && s.cp_message !== undefined && s.cp_message.trim() !== '') {
                    alert(s.cp_message);
                    delete (s.cp_message);
                }
                if (s.cp_valmsg !== null && s.cp_valmsg !== undefined && s.cp_valmsg.trim() !== '') {

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

        var evn;
        var index;
        var index1;
        var index2;
        var valchange;
        var valchange2;
        var valchange3;
        var valchange4;
        var val;
        var temp;
        var bulkqty;
        var copyFlag;
        var itemc; //variable required for lookup
        var Cus; //variable required for lookup
        var colorc;
        var sizec;
        var classc;
        var unitc;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        let dataExp;
        var RBulkQty
        var RQty
        var BaseQty
        var Price
        var BarcodeNo
        var Field1
        var Field2
        var Field3
        var Field4
        var Field5
        var Field6
        var Field7
        var Field8
        var Field9
        function OnStartEditing(s, e) {//On start edit grid function     
            if (entry != "V") {
                currentColumn = e.focusedColumn;
                var cellInfo = e.rowValues[e.focusedColumn.index];
                itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
                colorc = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                classc = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                sizec = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                unitc = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "BulkQty");
                RBulkQty = s.batchEditApi.GetCellValue(e.visibleIndex, "RBulkQty");
                index1 = e.visibleIndex;

                console.log("ItemCode:", itemc);
                console.log("ColorCode:", colorc);
                console.log("ClassCode:", classc);
                console.log("SizeCode:", sizec);
                console.log("Unit:", unitc);
                console.log("BulkQty:", bulkqty);
                console.log("Visible Index:", index1);

                if (bulkqty == null) {
                    bulkqty = 0;
                }

                //needed var for all lookups; this is where the lookups vary for
                //if (e.visibleIndex < 0) {//new row
                //    var linenumber = s.GetColumnByField("LineNumber");
                //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
                //}


                if (copyFlag) {
                    copyFlag = false;
                    const columnsToCopy = [
                        'OCNLineNumber',
                        'Customer',
                        'ItemCode',
                        'FullDesc',
                        'BulkQty',
                        'AllocStatus',
                        'Unit',
                        'BulkUnit',
                        'Outlet',
                    ];
                    for (var i = 0; i < s.GetColumnsCount(); i++) {
                        var column = s.GetColumn(i);
                        // console.log(i);
                        //console.log(column.fieldName);
                        if (column.visible == false || column.fieldName == undefined || !columnsToCopy.includes(column.fieldName))
                            continue;
                        //console.log(column.fieldName)
                        ProcessCells(0, e, column, s);
                    }
                }

                if (chckAutoPick.GetChecked() == true) {// Make gridview editing false 
                    if (e.focusedColumn.fieldName !== "Qty" && e.focusedColumn.fieldName !== "BulkQty" && e.focusedColumn.fieldName !== "ToLocation" && e.focusedColumn.fieldName !== "Customer") {
                        e.cancel = true;
                    }
                }

                bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "BulkQty");

                if (bulkqty == null) {
                    bulkqty = 0;
                }

                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
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
                if (e.focusedColumn.fieldName === "BulkQty") {
                    //prevQ = cellInfo.value; -- remove by SA 5/16/2024
                    index = e.visibleIndex;
                }
                if (e.focusedColumn.fieldName === "Customer") { //Check the column name
                    glCus.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                }
                if (e.focusedColumn.fieldName === "ToLocation") {
                    gl6.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName === "BulkUnit") {
                    isSetTextRequired = true;
                    glBulkUnit.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "Unit") {
                    isSetTextRequired = true;
                    glUnit.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "PalletID") {
                    glpallet.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                }

            }
        }


        var itemc; //variable required for lookup
        var Cus; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        function OnStartEditings(s, e) {
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
            Cus = s.batchEditApi.GetCellValue(e.visibleIndex, "Customer");
            if (entry == "V") {
                e.cancel = true; //this will made the gridview readonly
            }
            if (entry != "V") {
                if (e.focusedColumn.fieldName === "OCNNumber") {
                    glocn.GetInputElement().value = cellInfo.value;
                    isSetTextRequired = false;
                }
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
        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup

            if (entry != "V") {
                var cellInfo = e.rowValues[currentColumn.index];
                if (currentColumn.fieldName === "ItemCode") {
                    cellInfo.value = ((gl.GetValue() === null || gl.GetValue() === undefined) && cellInfo.value != null) ? cellInfo.value : gl.GetValue();
                    cellInfo.text = ((gl.GetText() === null || gl.GetText()) === undefined && cellInfo.text != null) ? cellInfo.text : gl.GetText().toUpperCase();
                    setQuantityFromOCN(e.visibleIndex);

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

                if (currentColumn.fieldName === "BulkQty") {


                    setAllocStatus(gBulkQty.GetValue(), e.visibleIndex)
                    //if (cellInfo.value != null) {
                    //    validateMax(index, cellInfo.value)
                    //}
                    index2 = index;
                }
                if (currentColumn.fieldName === "BulkUnit") {
                    cellInfo.value = glBulkUnit.GetValue();
                    cellInfo.text = glBulkUnit.GetText();
                }
                if (currentColumn.fieldName === "Unit") {
                    cellInfo.value = glUnit.GetValue();
                    cellInfo.text = glUnit.GetText();
                }
                if (currentColumn.fieldName === "OCNNumber") {
                    cellInfo.value = glocn.GetValue();
                    cellInfo.text = glocn.GetText().toUpperCase();
                }
                if (currentColumn.fieldName === "Customer") {
                    cellInfo.value = glCus.GetValue();
                    cellInfo.text = glCus.GetText().toUpperCase();
                }
                if (currentColumn.fieldName === "ToLocation") {
                    cellInfo.value = gl6.GetValue();
                    cellInfo.text = gl6.GetText();
                }
                if (currentColumn.fieldName === "PalletID") {

                    if (newpallet != "") {
                        cellInfo.value = newpallet;
                        cellInfo.text = newpallet;
                    } else {
                        cellInfo.value = glpallet.GetValue();
                        cellInfo.text = glpallet.GetText().toUpperCase();
                    }

                }
            }

        }
        function OnEndEditings(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];


            if (currentColumn.fieldName === "OCNNumber") {
                cellInfo.value = glocn.GetValue();
                cellInfo.text = glocn.GetText().toUpperCase();
            }

        }

        function GridEnd(s, e) {
            //console.log('gridend');
            val = s.GetGridView().cp_codes;

            //console.log(val);

            if (val != null) {

                temp = val.split(';');
            }
            if (valchange) {
                valchange = false;
                var column = gv1.GetColumn(6);

                ProcessCells2(0, index2, column, gv1);
            }
            if (valchange3) {
                valchange3 = false;

                var column = gv1.GetColumn(6);

                ProcessCells4(0, index, column, gv1);
            }
            if (valchange4) {
                valchange4 = false;

                var column = gv1.GetColumn(3);

                ProcessCells4(0, index, column, gv1);
            }

            if (valchange2) {
                valchange2 = false;

                for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;

                    ProcessCells3(0, index, column, gv1);
                    //console.log(index);
                }
                gv1.batchEditApi.EndEdit();
            }
            loader.Hide();
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

        function ProcessCells4(selectedIndex, focused, column, s) {//Auto calculate qty function :D
            if (val == null) {
                val = ";";
                temp = val.split(';');
            }

            if (temp[0] == null) {
                temp[0] = 0;
            }
            if (temp[1] == null) {
                temp[1] = 0;
            }


            if (selectedIndex == 0) {
                //console.log(temp);
                s.batchEditApi.SetCellValue(focused, "RQty", temp[0]);
                //s.batchEditApi.SetCellValue(focused, "Qty", temp[0]);
                s.batchEditApi.SetCellValue(focused, "RBulkQty", temp[1]);
                //s.batchEditApi.SetCellValue(focused, "BulkQty", temp[1]);
                s.batchEditApi.SetCellValue(focused, "PalletID", temp[2]);
                //s.batchEditApi.SetCellValue(focused, "Customer", temp[3]);
                s.batchEditApi.SetCellValue(focused, "Location", temp[3]);
                s.batchEditApi.SetCellValue(focused, "BatchNo", temp[4]);


                temp[5] = new Date(temp[5]); // Parse temp[5] into a Date object
                temp[6] = new Date(temp[6]); // Parse temp[6] into a Date object
                temp[7] = new Date(temp[7]); // Parse temp[7] into a Date object

                if (!isNaN(temp[5].getTime())) {

                    s.batchEditApi.SetCellValue(focused, "Mkfgdate", temp[5]);
                } else {

                }

                if (!isNaN(temp[6].getTime())) {

                    s.batchEditApi.SetCellValue(focused, "ExpiryDate", temp[6]);
                } else {

                }

                if (!isNaN(temp[6].getTime())) {

                    s.batchEditApi.SetCellValue(focused, "RRDocdate", temp[7]);
                } else {

                }

                //if (temp[5] === null || isNaN(temp[5]) || temp[5] === 0) { } else {
                //    temp[5] = new Date(temp[5]); // Parse temp[5] into a Date object
                //    s.batchEditApi.SetCellValue(focused, "Mkfgdate", temp[5]);
                //}
                //if (temp[6] === null || isNaN(temp[6]) || temp[6] === 0) { } else {
                //    temp[6] = new Date(temp[6]); // Parse temp[6] into a Date object
                //    s.batchEditApi.SetCellValue(focused, "ExpiryDate", temp[6]);
                //}
                //if (temp[7] === null || isNaN(temp[7]) || temp[7] === 0) { } else {
                //    temp[7] = new Date(temp[7]); // Parse temp[7] into a Date object
                //    s.batchEditApi.SetCellValue(focused, "RRDocdate", temp[7]);
                //}




            }
        }

        function ProcessCells3(selectedIndex, e, column, s) {//Auto Color,class,size,full desc, qty function :D
            if (val == null) {
                val = ";;;;;";
                temp = val.split(';');
            }
            if (temp[0] == null || temp[0] == "") {
                temp[0] = "";
            }
            if (temp[1] == null || temp[1] == "") {
                temp[1] = "";
            }
            if (temp[2] == null || temp[2] == "") {
                temp[2] = "";
            }
            if (temp[3] == null || temp[3] == "") {
                temp[3] = "";
            }
            if (temp[4] == null || temp[4] == "") {
                temp[4] = "";
            }
            if (temp[5] == null || temp[5] == "") {
                temp[5] = "";
            }
            if (temp[6] == null || temp[6] == "") {
                temp[6] = 0;
            }
            if (selectedIndex == 0) {

                if (column.fieldName == "ColorCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                    //console.log(index);
                    //console.log(column.fieldName);
                    //console.log(temp[0]);
                }
                if (column.fieldName == "ClassCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[1]);

                }
                if (column.fieldName == "SizeCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[2]);

                }
                if (column.fieldName == "FullDesc") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[3]);

                }
                if (column.fieldName == "BulkUnit") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[4]);

                }
                if (column.fieldName == "Unit") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[5]);

                }
                if (column.fieldName == "Qty") {

                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[6]);

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
            //if (keyCode == 13)
            gv1.batchEditApi.EndEdit();
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.

            setTimeout(function () {
                gv1.batchEditApi.EndEdit();
            }, 1000);
        }


        function gridLookup_KeyDown2(s, e) { //Allows tabbing between gridlookup on details
            isSetTextRequired = false;
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode !== ASPxKey.Tab) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (gvocn.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
            }
        }

        function gridLookup_KeyPress2(s, e) { //Prevents grid refresh when a user press enter key for every column
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode == ASPxKey.Enter)
                gvocn.batchEditApi.EndEdit();
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp2(s, e) { //Automatically leaves the current cell if an item is selected.
            setTimeout(function () {
                gvocn.batchEditApi.EndEdit();
            }, 1000);
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                var column = s.GetColumn(i);
                if (column.fieldName == "ItemCode" || column.fieldName == "Unit") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    //if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                    if (typeof value === "string" && ASPxClientUtils.IsExists(value) && ASPxClientUtils.Trim(value) === "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
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
            //console.log(e.buttonID);
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                    + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode);
            }
            if (e.buttonID == "CountSheet") {
                CSheet.Show();
                var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
                var docnumber = getParameterByName('docnumber');
                var transtype = getParameterByName('transtype');
                var entry = getParameterByName('entry');
                if (chckAutoPick.GetChecked() == true) {
                    CSheet.SetContentUrl('frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
                        '&linenumber=' + linenum + '&type=Putaway', '_blank');
                }
                else {
                    CSheet.SetContentUrl('frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
                        '&linenumber=' + linenum);
                }
            }
            if (e.buttonID == "CopyButton") {
                var num = clone.GetText();
                //console.log(e.visibleIndex);
                //console.log(num);
                for (i = 1; i <= num; i++) {
                    index = e.visibleIndex;
                    copyFlag = true;
                    //console.log(index);
                    s.AddNewRow();
                    //console.log(s);
                }
            }

            if (e.buttonID == "Delete") {

                //console.log(e.buttonID);
                if (!(deletedLine.includes(e.visibleIndex))) {
                    deletedLine.push(e.visibleIndex)
                }

                //console.log(e.visibleIndex);

                //console.log(gv1.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber"));
                if (gv1.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber") != "") {

                    if (!(deteledLinenumbers.includes(gv1.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber")))) {
                        //console.log('deleted')
                        //console.log(deteledLinenumbers)
                        let liner = "''" + gv1.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber") + "''"
                        deteledLinenumbers = deteledLinenumbers + liner + ","
                    }

                }
                gv1.DeleteRow(e.visibleIndex);
            }
        }
        function OnInitTrans(s, e) {
            AdjustSize();

        }

        function onRowDeleting(s, e) {
            var visibleIndex = e.visibleIndex;
            var keyValue = s.GetRowKey(visibleIndex);

            //console.log(e.visibleIndex)
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
            gv1.SetHeight(height - 290);


        }


        function DeleteDetail(s, e) {
            //console.log(e.index)

            var indicies = gv1.batchEditApi.GetRowVisibleIndices();

            var indicies1 = gvocn.batchEditApi.GetRowVisibleIndices();


            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                    gv1.DeleteRow(indicies[i]);
                }


                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    if (gv1.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else {
                        gv1.DeleteRow(indicies[i]);

                    }
                }
            }
            for (var i = 0; i < indicies1.length; i++) {
                if (gvocn.batchEditHelper.IsNewItem(indicies1[i])) {

                    gvocn.DeleteRow(indicies1[i]);
                }


                else {
                    var key = gvocn.GetRowKey(indicies1[i]);
                    if (gvocn.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies1[i]);
                    else {
                        gvocn.DeleteRow(indicies1[i]);

                    }
                }
            }




        }

        function UpdateLottables(values) {
            if (values != undefined) {
                values[1] = new Date(values[1]); // Parse temp[5] into a Date object
                values[2] = new Date(values[2]); // Parse temp[6] into a Date object
                values[6] = new Date(values[6]); // Parse temp[6] into a Date object

                //console.log(values)
                // Parse the given date string to create a Date object
                const expdate = new Date(values[2]);

                // Create a Date object for the current date and time
                const currentDate = new Date();

                if (currentDate > expdate) {
                    let item = gv1.batchEditApi.GetCellValue(index1, "ItemCode");
                    lblErrorDetails.SetText(`It seems that the pallet <b>${values[0]}</b> with the item <b>${item}</b> is already <b>EXPIRED</b>. Proceed in selecting the Pallet?`);
                    ValidationPop.Show();
                    dataExp = values;
                }
                else {
                    if (!isNaN(values[1].getTime())) {

                        gv1.batchEditApi.SetCellValue(index1, "Mkfgdate", values[1]);
                    }

                    if (!isNaN(values[2].getTime())) {

                        gv1.batchEditApi.SetCellValue(index1, "ExpiryDate", values[2]);
                    }

                    if (!isNaN(values[6].getTime())) {

                        gv1.batchEditApi.SetCellValue(index1, "RRDocdate", values[6]);
                    }

                    const bulkQty = values[5] > parseInt(gv1.batchEditApi.GetCellValue(index1, 'BulkQty'))
                        ? gv1.batchEditApi.GetCellValue(index1, 'BulkQty') : values[5];
                    //console.log(values[0]);
                    newpallet = values[0];
                    //console.log(index1);
                    gv1.batchEditApi.SetCellValue(index1, "PalletID", values[0]);
                    gv1.batchEditApi.SetCellValue(index1, "Mkfgdate", values[1]);
                    gv1.batchEditApi.SetCellValue(index1, "ExpiryDate", values[2]);
                    gv1.batchEditApi.SetCellValue(index1, "BatchNo", values[3]);
                    gv1.batchEditApi.SetCellValue(index1, "Location", values[4]);
                    gv1.batchEditApi.SetCellValue(index1, "BulkQty", bulkQty);
                    gv1.batchEditApi.SetCellValue(index1, "RecordId", values[6]);
                    gv1.batchEditApi.SetCellValue(index1, "RRDocdate", values[7]);
                    gv1.batchEditApi.SetCellValue(index1, "LotID", values[8]);
                    gv1.batchEditApi.SetCellValue(index1, "Qty", bulkQty == values[5] ? values[9] : 0);
                }


                gv1.batchEditApi.EndEdit();

                loader.Hide();
            }
        }



        function validateExp(datae, cond) {

            if (cond == false) {

                gv1.batchEditApi.SetCellValue(index1, "PalletID", null);
                gv1.batchEditApi.SetCellValue(index1, "Mkfgdate", null);
                gv1.batchEditApi.SetCellValue(index1, "ExpiryDate", null);
                gv1.batchEditApi.SetCellValue(index1, "BatchNo", null);
                gv1.batchEditApi.SetCellValue(index1, "Location", null);

                gv1.batchEditApi.SetCellValue(index1, "RecordId", null);
                gv1.batchEditApi.SetCellValue(index1, "RRDocdate", null);
                gv1.batchEditApi.SetCellValue(index1, "LotID", null);

            } else {
                datae[1] = new Date(datae[1]); // Parse temp[5] into a Date object
                datae[2] = new Date(datae[2]); // Parse temp[6] into a Date object
                datae[6] = new Date(datae[6]); // Parse temp[6] into a Date object
                if (!isNaN(datae[1].getTime())) {

                    gv1.batchEditApi.SetCellValue(index1, "Mkfgdate", datae[1]);
                }

                if (!isNaN(datae[2].getTime())) {

                    gv1.batchEditApi.SetCellValue(index1, "ExpiryDate", datae[2]);
                }

                if (!isNaN(datae[6].getTime())) {

                    gv1.batchEditApi.SetCellValue(index1, "RRDocdate", datae[6]);
                }

                //const bulkQty = datae[5] > parseInt(gv1.batchEditApi.GetCellValue(index1, 'BulkQty'))
                //        ? gv1.batchEditApi.GetCellValue(index1, 'BulkQty') : datae[5];

                gv1.batchEditApi.SetCellValue(index1, "PalletID", datae[0]);
                gv1.batchEditApi.SetCellValue(index1, "Mkfgdate", datae[1]);
                gv1.batchEditApi.SetCellValue(index1, "ExpiryDate", datae[2]);
                gv1.batchEditApi.SetCellValue(index1, "BatchNo", datae[3]);
                gv1.batchEditApi.SetCellValue(index1, "Location", datae[4]);
                gv1.batchEditApi.SetCellValue(index1, "BulkQty", datae[5]);
                gv1.batchEditApi.SetCellValue(index1, "RecordId", datae[6]);
                gv1.batchEditApi.SetCellValue(index1, "RRDocdate", datae[7]);
                gv1.batchEditApi.SetCellValue(index1, "LotID", datae[8]);
                gv1.batchEditApi.SetCellValue(index1, "Qty", 0);

            }

            ValidationPop.Hide();
        }
        // remove by SA 5/16/2024
        //async function validateMax(curindex, curvalue) {
        //    var values = {
        //        "ItemCode": gv1.batchEditApi.GetCellValue(curindex, "ItemCode"),
        //        "FullDesc": gv1.batchEditApi.GetCellValue(curindex, "FullDesc"),
        //        "LineNumber": gv1.batchEditApi.GetCellValue(curindex, "LineNumber"),
        //        "DocNumber": docs.GetInputElement().value,
        //        "QtyIn": curvalue,
        //        "PalletID": gv1.batchEditApi.GetCellValue(curindex, "PalletID"),
        //        "Customer": glcustomer.GetInputElement().value
        //    }
        //    var value2 = {
        //        "PrevK": gv1.batchEditApi.GetCellValue(curindex, "Qty"),
        //        "index": curindex
        //    }


        //    var mainVal = []
        //    mainVal.push(values);
        //    var message = ""

        //    var result = await $.ajax({
        //        type: 'POST',
        //        url: "frmPicklist.aspx/ValidateQty",
        //        contentType: "application/json",
        //        data: JSON.stringify({ _changes: mainVal }), // Updated JSON.stringify
        //        dataType: "json"
        //    });

        //    if (result.d != "") {
        //        alert(result.d);
        //        gv1.batchEditApi.SetCellValue(curindex, "BulkQty", prevQ);
        //        //gv1.batchEditApi.SetCellValue(curindex, "Qty", value2["PrevK"]);  
        //        invalidChange = true;

        //    }

        //}
        function setAllocStatus(inputtedqty, curindex) {

            let ocnDetail = JSON.parse(cp.cp_ocnorgidetail).filter((rowline) => rowline['ItemCode'] == gv1.batchEditApi.GetCellValue(curindex, 'ItemCode'))
            let otherIndex = [], totalqty = 0, remainingqty = 0;

            var indices = gv1.batchEditApi.GetRowVisibleIndices();
            totalqty = inputtedqty

            //if theres an itemcode request
            if (ocnDetail.length > 0) {

                var fefo = ocnDetail.filter((rowline) =>
                    !((rowline['BatchNumber'] === null || rowline['BatchNumber'] === '') &&
                        (rowline['MfgDate'] === null || rowline['MfgDate'] === '') &&
                        (rowline['ExpDate'] === null || rowline['ExpDate'] === '') &&
                        (rowline['LotNo'] === null || rowline['LotNo'] === ''))
                );

                //console.log(fefo)
                if (fefo.length > 0) {
                    let values = [], final, condition2, condItem = '', condition = '';
                    ocnDetail.map((val) => {
                        values.push(
                            ['BatchNo', val['BatchNumber'], 'BatchNumber'],
                            ['LotID', val['LotNo'], 'LotNo'],
                            ['Mkfgdate', val['MfgDate'], 'MfgDate'],
                            ['ExpiryDate', val['ExpDate'], 'ExpDate'])
                    })

                    //if input is null with these lottables
                    if ((gv1.batchEditApi.GetCellValue(curindex, 'BatchNo') == null || gv1.batchEditApi.GetCellValue(curindex, 'BatchNo') == "") &&
                        (gv1.batchEditApi.GetCellValue(curindex, 'Mkfgdate') == null || gv1.batchEditApi.GetCellValue(curindex, 'Mkfgdate') == "") &&
                        (gv1.batchEditApi.GetCellValue(curindex, 'ExpiryDate') == null || gv1.batchEditApi.GetCellValue(curindex, 'ExpiryDate') == "") &&
                        (gv1.batchEditApi.GetCellValue(curindex, 'LotID') == null || gv1.batchEditApi.GetCellValue(curindex, 'LotID') == "")
                    ) {

                        //check if there's a not fefo mix in with fefo req with same itemcode
                        var nullVal = ocnDetail.filter((rowline) =>
                            (rowline['BatchNumber'] === null || rowline['BatchNumber'] === '') &&
                            (rowline['MfgDate'] === null || rowline['MfgDate'] === '') &&
                            (rowline['ExpDate'] === null || rowline['ExpDate'] === '') &&
                            (rowline['LotNo'] === null || rowline['LotNo'] === '')
                        );

                        if (nullVal.length > 0) {
                            indices.forEach((index) => {
                                if (index < 0 && deletedLine.includes(index)) {
                                    // if negative value includes in deletedlines means that there's  
                                    //same index was deleted and retry to add again 
                                    deletedLine.splice(deletedLine.indexOf(index), 1);
                                }
                                if (gv1.batchEditApi.GetCellValue(curindex, 'ItemCode') == gv1.batchEditApi.GetCellValue(index, 'ItemCode') && !(deletedLine.includes(index)) && index != curindex) {
                                    totalqty = totalqty + gv1.batchEditApi.GetCellValue(index, 'BulkQty');
                                    // console.log(gv1.batchEditApi.GetCellValue(index, 'ItemCode') + 'index '+index)
                                    //console.log(gv1.batchEditApi.GetCellValue(index, 'BulkQty') + 'value ' + index)
                                    otherIndex.push({ 'index': index, 'bulkqty': gv1.batchEditApi.GetCellValue(index, 'BulkQty') });
                                }

                            })
                            if (totalqty != inputtedqty) {
                                inputtedqty = 0
                            }
                            remainingqty = nullVal[0]['BulkQty'];
                            validateInput(totalqty, remainingqty, curindex, otherIndex, inputtedqty)
                            inputtedqty = 0

                        }
                        else {
                            //dont add the statuscode in there's no request
                            return;
                        }

                    } else {
                        var ocnLinetocheck;

                        final = values.map((val) => val)
                            .filter((lottables) => lottables[1] != '' && lottables[1] != null)
                            .map((lott) => {

                                if (lott[1] != null && lott[1] != "") {

                                    if (condition.length > 0) {
                                        if (lott[0] == 'Mkfgdate' || lott[0] == 'ExpiryDate') {
                                            condition += ` && new Date(gv1.batchEditApi.GetCellValue(index, '${lott[0]}')).toString() == new Date('${lott[1]}').toString()`;
                                            condItem += ` && new Date(rowline['${lott[2]}']).toString() == new Date(gv1.batchEditApi.GetCellValue(${curindex}, '${lott[0]}')).toString()`;
                                        } else {
                                            condition += ` && gv1.batchEditApi.GetCellValue(index, '${lott[0]}') == '${lott[1]}'`;
                                            condItem += ` && rowline['${lott[2]}'] == gv1.batchEditApi.GetCellValue(${curindex}, '${lott[0]}')`;
                                        }
                                    }
                                    else {
                                        if (lott[0] == 'Mkfgdate' || lott[0] == 'ExpiryDate') {
                                            //sample new Date('2025-02-20T00:00:00').toString()
                                            condition += `new Date(gv1.batchEditApi.GetCellValue(index, '${lott[0]}')).toString() == new Date('${lott[1]}').toString()`;
                                            condItem += `rowline['${lott[2]}'] == gv1.batchEditApi.GetCellValue(${curindex}, '${lott[0]}')`;
                                        } else {
                                            condition += `gv1.batchEditApi.GetCellValue(index, '${lott[0]}') == '${lott[1]}'`;
                                            condItem += `rowline['${lott[2]}'] == gv1.batchEditApi.GetCellValue(${curindex}, '${lott[0]}')`;
                                        }

                                    }

                                }
                            })
                        //console.log(ocnDetail);
                        //console.log(condItem);

                        //console.log(gv1.batchEditApi.GetCellValue(-1, 'LotID')+","+gv1.batchEditApi.GetCellValue(-1, 'Mkfgdate')+","+gv1.batchEditApi.GetCellValue(-1, 'ExpiryDate'));
                        ocnLinetocheck = ocnDetail.filter((rowline) => eval(condItem))



                        indices.forEach((index) => {
                            if (index < 0 && deletedLine.includes(index)) {
                                // if negative value includes in deletedlines means that there's  
                                //same index was deleted and retry to add again 
                                deletedLine.splice(deletedLine.indexOf(index), 1);
                            }
                            //console.log(gv1.batchEditApi.GetCellValue(curindex, 'ItemCode'))
                            //console.log(gv1.batchEditApi.GetCellValue(index, 'ItemCode'))
                            //console.log(index != curindex)
                            //console.log(condition.split("index").join(index))
                            //console.log(gv1.batchEditApi.GetCellValue(curindex , 'ItemCode') == gv1.batchEditApi.GetCellValue(index, 'ItemCode') && !(deletedLine.includes(index)) && index != curindex 
                            //    && eval(condition.split("index").join(index)))
                            //console.log(deletedLine)
                            if (gv1.batchEditApi.GetCellValue(curindex, 'ItemCode') == gv1.batchEditApi.GetCellValue(index, 'ItemCode') && !(deletedLine.includes(index)) && index != curindex
                                && eval(condition.split("index").join(`${index}`))
                            ) {
                                totalqty = totalqty + gv1.batchEditApi.GetCellValue(index, 'BulkQty');
                                otherIndex.push({ 'index': index, 'bulkqty': gv1.batchEditApi.GetCellValue(index, 'BulkQty') });
                            }
                            //get the req fefo


                        })
                        //console.log(ocnLinetocheck);
                        remainingqty = ocnLinetocheck.length > 0 ? ocnLinetocheck[0]['BulkQty'] : 0;
                        //console.log(remainingqty);
                        //console.log(totalqty);
                        //console.log(otherIndex);
                        //console.log(curindex);

                        if (totalqty != inputtedqty) {
                            inputtedqty = 0
                        }

                        validateInput(totalqty, remainingqty, curindex, otherIndex, inputtedqty)


                    }

                    inputtedqty = 0

                } else {

                    indices.forEach((index) => {
                        if (index < 0 && deletedLine.includes(index)) {
                            // if negative value includes in deletedlines means that there's  
                            //same index was deleted and retry to add again 
                            deletedLine.splice(deletedLine.indexOf(index), 1);
                        }
                        if (gv1.batchEditApi.GetCellValue(curindex, 'ItemCode') == gv1.batchEditApi.GetCellValue(index, 'ItemCode') && !(deletedLine.includes(index)) && index != curindex) {
                            totalqty = totalqty + gv1.batchEditApi.GetCellValue(index, 'BulkQty');
                            otherIndex.push({ 'index': index, 'bulkqty': gv1.batchEditApi.GetCellValue(index, 'BulkQty') });
                        }

                    })
                    if (totalqty != inputtedqty) {
                        inputtedqty = 0
                    }

                    // console.log('test');
                    //console.log(ocnDetail);
                    // console.log(totalqty);
                    //console.log(remainingqty);
                    remainingqty = ocnDetail[0]['BulkQty'];
                    validateInput(totalqty, remainingqty, curindex, otherIndex, inputtedqty)
                    inputtedqty = 0
                }

            }



        }
        function validateInput(totalqtyV, remainingqtyV, curindexV, otherIndexV, inputtedqtyV) {
            if (totalqtyV != null) {
                //console.log(remainingqtyV + 'V');
                //console.log(totalqtyV+'V2');
                if (totalqtyV > remainingqtyV) {
                    //console.log(otherIndexV)

                    var newlist = otherIndexV.sort((a, b) => a['bulkqty'] - b['bulkqty']);
                    //console.log(totalqtyV);
                    for (var i = 0; i < newlist.length; i++) {
                        if (remainingqtyV < 0) {
                            gv1.batchEditApi.SetCellValue(newlist[i]['index'], 'AllocStatus', 'EXCEEDS');
                            continue;
                        }
                        remainingqtyV = remainingqtyV - newlist[i]['bulkqty'];
                        //console.log(`count ${i}` + remainingqtyV);
                        //console.log(remainingqtyV < 0);
                        switch (true) {
                            case (remainingqtyV < 0):
                                gv1.batchEditApi.SetCellValue(newlist[i]['index'], 'AllocStatus', 'EXCEEDS');
                                break;
                            case (remainingqtyV == 0):
                            case (remainingqtyV >= 1):
                                gv1.batchEditApi.SetCellValue(newlist[i]['index'], 'AllocStatus', 'ALLOTED');
                                break;
                            default:
                                gv1.batchEditApi.SetCellValue(newlist[i]['index'], 'AllocStatus', 'PART-ALLOTED');
                                break;
                        }

                    }

                    gv1.batchEditApi.SetCellValue(curindexV, 'AllocStatus', 'EXCEEDS');

                } else {
                    if (totalqtyV == remainingqtyV) {

                        for (var i = 0; i < otherIndexV.length; i++) {
                            gv1.batchEditApi.SetCellValue(otherIndexV[i]['index'], 'AllocStatus', 'ALLOTED');
                        }
                        gv1.batchEditApi.SetCellValue(curindexV, 'AllocStatus', 'ALLOTED');
                    } else if (totalqtyV == 0 && inputtedqtyV > remainingqtyV && inputtedqtyV != 0) {

                        gv1.batchEditApi.SetCellValue(curindexV, 'AllocStatus', 'EXCEEDS');
                    } else {
                        for (var i = 0; i < otherIndexV.length; i++) {
                            gv1.batchEditApi.SetCellValue(otherIndexV[i]['index'], 'AllocStatus', 'PART-ALLOTED');
                        }
                        gv1.batchEditApi.SetCellValue(curindexV, 'AllocStatus', 'PART-ALLOTED');
                    }
                }
            }
        }
        function setQuantityFromOCN(currentIndex) {
            const ocnDetail = JSON.parse(cp.cp_ocnDetails).find(detail => {
                return detail['ItemCode'] === gl.GetText();
            });

            if (ocnDetail === undefined || ocnDetail === null) return;

            const rowCount = gv1.batchEditApi.GetRowVisibleIndices();
            let itemTotalPicklistQty = 0;

            gv1.batchEditApi.GetRowVisibleIndices().forEach((rowIndex) => {
                const rowItemCode = gv1.batchEditApi.GetCellValue(rowIndex, 'ItemCode', false) != null ?
                    gv1.batchEditApi.GetCellValue(rowIndex, 'ItemCode', false).toString().toLowerCase() : null;
                if (rowItemCode == ocnDetail['ItemCode'].toLowerCase()) {
                    itemTotalPicklistQty += gv1.batchEditApi.GetCellValue(rowIndex, 'BulkQty', false) === null ? 0 : gv1.batchEditApi.GetCellValue(rowIndex, 'BulkQty', false);
                }
            });

            const itemRemainingQty = ocnDetail['Requested Qty'] - itemTotalPicklistQty > 0 ? ocnDetail['Requested Qty'] - itemTotalPicklistQty : 0;

            if (gv1.batchEditApi.GetCellValue(currentIndex, 'BulkQty', false) != null && gv1.batchEditApi.GetCellValue(currentIndex, 'BulkQty', false) != 0) return;

            gv1.batchEditApi.SetCellValue(currentIndex, 'BulkQty', itemRemainingQty);
            setAllocStatus(itemRemainingQty, currentIndex)
        }
    </script>
    <%-- <script>
        function switchTabsToFixAlignment() {

            tabbedLayoutGroup.SetActiveTabIndex(1);

            setTimeout(() => {
                tabbedLayoutGroup.SetActiveTabIndex(0);
            }, 100);
        }

        window.onload = function () {
            switchTabsToFixAlignment();
        };
    </script>--%>

    <%--    <script type="text/javascript">
        function OnEndCallback(s, e) {
            s.AdjustControl(); 
        }
    </script>--%>
    <!--#endregion-->
</head>
<body style="height: 910px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Picklist" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
            EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                </dx:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents CloseUp="function (s, e) { cp.PerformCallback('refgrid') }" />
        </dx:ASPxPopupControl>

        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="805px" Height="641px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <%--<ClientSideEvents EndCallback="function(s, e) { switchTabsToFixAlignment(); }"></ClientSideEvents>--%>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Width="850px" Style="margin-left: -3px; margin-right: 0px;">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />

                        <Items>
                            <%--<!--#region Region Header --> --%>

                            <dx:TabbedLayoutGroup ClientInstanceName="tabbedLayoutGroup">
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutGroup Caption="" ColCount="2" Width="55%">
                                                <Items>
                                                    <dx:LayoutItem Caption="Document Number:" Name="DocNumber">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocnumber" ClientInstanceName="docs" runat="server" Width="150px" ReadOnly="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date:" Name="DocDate" Width="150px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpdocdate" runat="server" Width="150px" OnInit="dtpDocDate_Init" OnLoad="AddOnlyDateLoad">
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxDateEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Documentation Staff:" Name="DocumentationStaff">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocstaff" runat="server" OnLoad="TextboxLoad" Width="150px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Customer" Name="Customer">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="txtCustomercode" ClientInstanceName="glcustomer" Width="150px" runat="server" DataSourceID="Masterfilebizcustomer" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}" OnValueChanged="txtCustomercode_ValueChanged" ClientEnabled="false">

                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" Caption="Customer" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" Caption="Name" Width="200px" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                   //var grid = glocn.GetGridView();
                                                                    //glocn.GetGridView().PerformCallback(glpicktype.GetValue() + '|' + s.GetInputElement().value + '|' + txtwarehousecode.GetValue() + '|' + '' 
                                                                //);
                                                                  //DeleteDetail(s,e);
                                                                        cp.PerformCallback('CustomerChanged');
                                                                        e.processOnServer = false;
                                                                }" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Picklist Type:" Name="PicKlistType">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox ID="cbxPickListType" ClientInstanceName="glpicktype" Width="150px" runat="server" OnLoad="Comboboxload">
                                                                    <Items>
                                                                        <dx:ListEditItem Text="Pick From Reserved" Value="Pick From Reserved" />
                                                                        <dx:ListEditItem Text="Pick From Normal" Value="Pick From Normal" />
                                                                    </Items>
                                                                    <ClientSideEvents ValueChanged="function(s, e) {
                                                                   var grid = glocn.GetGridView();
                                                                    glocn.GetGridView().PerformCallback(s.GetInputElement().value + '|' + glcustomer.GetValue() + '|' + txtwarehousecode.GetValue() + '|' + '');
                                                                  
                                                                }" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Warehouse Code:" Name="WarehouseCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ClientInstanceName="txtwarehousecode" ID="txtwarehousecode" Width="150px" runat="server" DataSourceID="Warehouse" KeyFieldName="WarehouseCode" OnLoad="AddOnlyLookupLoad" TextFormatString="{0}" OnTextChanged="glWarehouseCOde_TextChanged">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <%--<ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {--%>
                                                                    <%--                                                                   var grid = glplant.GetGridView();
                                                                  var grid = glroomcode.GetGridView();
                                                                    glplant.GetGridView().PerformCallback(s.GetInputElement().value);
                                                                
                                                                    glroomcode.GetGridView().PerformCallback(  s.GetInputElement().value + '|' + glplant.GetValue()   );
                                                                }" DropDown="function(s, e) {
                                                                   var grid = glocn.GetGridView();
                                                                    glocn.GetGridView().PerformCallback(glpicktype.GetValue() + '|' + glcustomer.GetValue() + '|' + s.GetInputElement().value + '|' + glplant.GetValue());
                                                                  
                                                                }"/>--%>
                                                                    <ClientSideEvents Validation="OnValidation" DropDown="function(s, e) {
                                                                   var grid = glocn.GetGridView();
                                                                    glocn.GetGridView().PerformCallback(glpicktype.GetValue() + '|' + glcustomer.GetValue() + '|' + s.GetInputElement().value + '|' + '');
                                                                  
                                                                }" />
                                                                    <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
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
                                                    <dx:LayoutItem Caption="Outbound No:" Name="OutboundNo">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtOutboundNo" runat="server" Width="150px" OnLoad="TextboxLoad" Enabled="False" ReadOnly="True">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="StorageType">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glStorageType" runat="server" AutoGenerateColumns="False" ClientInstanceName="glStorageType" DataSourceID="StorageSrc" KeyFieldName="StorageType" OnLoad="LookupLoad" TextFormatString="{0}" Width="150px" ClientEnabled="false">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="StorageType" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="StorageDescription" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Overtime Allowed:" Name="Overtime">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtOvertime" runat="server" OnLoad="TextboxLoad" Width="150px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Additional Manpower:" Name="AddtionalManpower">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtAddtionalManpower" runat="server" OnLoad="AddOnlyTextboxLoad" Width="150px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="To Be Supplied By:" Name="SuppliedBy">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtSuppliedBy" runat="server" OnLoad="AddOnlyTextboxLoad" Width="150px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="No. of Manpower:" Name="NOManpower">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtNOManpower" runat="server" OnLoad="AddOnlyTextboxLoad" Width="150px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Type of Shipment:" Name="ShipmentType">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxComboBox ID="txtShipType" AutoGenerateColumns="False" ClientInstanceName="txtShipType" runat="server" AutoPostBack="false" Width="150px">
                                                                    <Items>
                                                                        <dx:ListEditItem Text="Import" Value="Import" />
                                                                        <dx:ListEditItem Text="Consolidation" Value="Consolidation" />
                                                                        <dx:ListEditItem Text="Local Transfer" Value="Local Transfer" />
                                                                        <dx:ListEditItem Text="Distribution" Value="Distribution" />
                                                                        <dx:ListEditItem Text="Others, please specify" Value="Others, please specify" />
                                                                    </Items>
                                                                    <%--    <ClientSideEvents SelectedIndexChanged="OnComboBoxSelectedIndexChanged" Validation="OnValidation" />--%>
                                                                    <ClientSideEvents Validation="OnValidation" />
                                                                    <ValidationSettings Display="None" ValidateOnLeave="true" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink"></InvalidStyle>
                                                                </dx:ASPxComboBox>

                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Requesting Dept. Company">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtReqCoDept" runat="server" Width="150px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Customer Ref. Document">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtRefDoc" runat="server" Width="150px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Status:" Name="txtstatuscode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtstatuscode" runat="server" Width="150px" Text="NEW" Enabled="False" OnLoad="TextboxLoad">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Remarks:" Name="Remarks" ColumnSpan="2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtremarks" runat="server" OnLoad="TextboxLoad" Width="150px">
                                                                </dx:ASPxTextBox>

                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="AutoPick" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chckAutoPick" ClientInstanceName="chckAutoPick" runat="server" CheckState="Unchecked">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Clone #">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtClone" runat="server" Width="150px" ClientInstanceName="clone">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Internal Transaction">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="InternalTrans" ClientInstanceName="InternalTrans" runat="server">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="DRNumber">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDRNumber" runat="server" OnLoad="TextboxLoad" Width="150px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="PickToLoad">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkPickToLoad" ClientEnabled="false" ClientInstanceName="chkPickToLoad" runat="server" CheckState="Unchecked">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Wave">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtWave" runat="server" OnLoad="TextboxLoad" Width="150px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="SO Note">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtNote" runat="server" OnLoad="TextboxLoad" Width="150px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Replenish">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkreplenish"  ClientInstanceName="chkreplenish" runat="server" CheckState="Unchecked">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="OCN Details" Width="45%" ColCount="1">
                                                <Items>
                                                    <dx:LayoutItem ClientVisible="true" Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gv4" runat="server" ClientInstanceName="gv4" AutoGenerateColumns="true" Width="98%">
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <Settings VerticalScrollBarMode="Visible" ColumnMinWidth="93" VerticalScrollableHeight="215" />
                                                                    <%--KC - 1/16/2025 add ColumnMinWidth--%>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Delivery and Trucking Info" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Consignee:" Name="Consignee">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtConsignee" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Consignee Address:" Name="ConsigneeAddress">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtConsigneeAddress" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- <dx:LayoutItem Caption="Deliver To (Address):">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddress" runat="server" Width="170px" ColCount="1" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Trucker Name:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTruckingCompany" runat="server" OnLoad="TextboxLoad" Width="170px" ColCount="1">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Delivery Date" Name="DeliveryDate" ColSpan="1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpdeliverydate" runat="server" OnLoad="Date_Load" Width="170px">
                                                            <%--                                                            <ClientSideEvents Validation="OnValidation" Init="function(s,e){ s.SetDate(new Date());}" />--%>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Plate Number:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPlateNumber" runat="server" Width="170px" OnLoad="TextboxLoad" ColCount="1">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Truck Type:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtTruckType" runat="server" AutoGenerateColumns="False" DataSourceID="TruckT" KeyFieldName="TruckType" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="TruckType" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Driver:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDriverName" runat="server" Width="170px" OnLoad="TextboxLoad" ColCount="1">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Seal Number:" Name="SealNo">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSealNo" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Truck to be Provided by Mets:" Name="TruckProviderByMets">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTruckProviderByMets" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
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

                                    <dx:LayoutGroup Caption="Audit Trail" ColSpan="1" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Added By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Added Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHAddedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Edited Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHLastEditedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHSubmittedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                        <Items>

                                            <dx:LayoutItem Caption=" Transfers:" ColumnSpan="2"></dx:LayoutItem>
                                            <dx:LayoutItem ClientVisible="true" Caption="" ColumnSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="tblTransfer" runat="server" ClientInstanceName="tblTransfer" AutoGenerateColumns="true">
                                                            <SettingsPager Mode="ShowAllRecords" />

                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                        </Items>
                                    </dx:LayoutGroup>
                                    <%--2024/01/25 M-Jay Adding Variance Tabe--%>
                                    <dx:LayoutGroup Caption="Variance">
                                        <Items>
                                            <dx:LayoutItem Caption=" Table"></dx:LayoutItem>
                                            <dx:LayoutItem ClientVisible="true" Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gv3" runat="server" ClientInstanceName="gv3" AutoGenerateColumns="true">
                                                            <SettingsPager Mode="ShowAllRecords" />
                                                        </dx:ASPxGridView>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <%--2024/01/25 M-Jay Adding Variance Tabe--%>
                                </Items>
                            </dx:TabbedLayoutGroup>
                            <%-- <!--#endregion --> --%>

                            <%--<!--#region Region Details --> --%>


                            <dx:LayoutGroup Caption="Picklist Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="dgvocn" runat="server" AutoGenerateColumns="False" Width="0px" Visible="false"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="dgvocn_CellEditorInitialize" ClientInstanceName="gvocn"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="OCNNumber" OnInit="gv1_Init">
                                                    <ClientSideEvents Init="OnInitTrans" />
                                                    <Columns>

                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="30px">
                                                        </dx:GridViewCommandColumn>

                                                        <dx:GridViewDataTextColumn FieldName="OCNNumber" VisibleIndex="1" Width="130px" Name="glOCNNumber">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glOCNumber" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="DocNumber" ClientInstanceName="glocn" TextFormatString="{0}" Width="130px" OnLoad="gvLookupLoad" OnInit="glOCNumber_Init" IncrementalFilteringMode="Contains">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>




                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents RowClick="gridLookup_CloseUp2" KeyPress="gridLookup_KeyPress2" KeyDown="gridLookup_KeyDown2" DropDown="lookup" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                    </Columns>
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager PageSize="5" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130" />
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm"
                                                        BatchEditStartEditing="OnStartEditings" BatchEditEndEditing="OnEndEditings" />
                                                    <SettingsEditing Mode="Batch" />
                                                </dx:ASPxGridView>

                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="1250px"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber" OnInit="gv1_Init" ClientVisible="true"
                                                    SettingsBehavior-AllowSort="false" OnInitNewRow="gv1_InitNewRow" OnCustomCallback="gv1_CustomCallback">
                                                    <Settings ShowFilterRowMenu="true" ShowFilterRowMenuLikeItem="true" ShowFilterRow="True" />
                                                    <%--KC - 1/16/2025 previous width 747--%>
                                                    <ClientSideEvents Init="OnInitTrans" />
                                                    <Columns>

                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False"
                                                            VisibleIndex="0">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="80px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true">
                                                            <Settings AutoFilterCondition="EndsWith" />
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="OCNLineNumber" Caption="OCNLineNumber" VisibleIndex="3" Visible="true" Width="100px" PropertiesTextEdit-ConvertEmptyStringToNull="true">
                                                            <Settings AutoFilterCondition="EndsWith" />
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Customer" VisibleIndex="4" Width="100px" Name="Customer">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glCus" runat="server" AutoGenerateColumns="True" AutoPostBack="false"
                                                                    DataSourceID="Masterfilebizcustomer" KeyFieldName="BizPartnerCode" ClientInstanceName="glCus" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" Caption="Customer" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" Caption="Name" Width="200px" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s, e) {
                                                                   var grid = glCus.GetGridView();
                                                                    glCus.GetGridView().PerformCallback(glpicktype.GetValue() + '|' + s.GetInputElement().value + '|' + txtwarehousecode.GetValue() + '|' + '' 
                                                                );
                                                                }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

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
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="function(s,e){gl.GetGridView().PerformCallback(itemc); e.processOnServer = false;}"
                                                                        ValueChanged="function(s,e){
                                                                        if(itemc != gl.GetValue()){
                                                                        loader.SetText('Loading...');
                                                                        loader.Show();
                                                                        gl2.GetGridView().PerformCallback('ItemCode' + '|' + gl.GetValue() + '|' + 'code' + '|' + bulkqty);
                                                                        e.processOnServer = false;
                                                                        valchange2 = true;}
                                                                  }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn ReadOnly="true" FieldName="FullDesc" VisibleIndex="6" Width="250px" Caption="Description">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="7" Width="0px" UnboundType="String">



                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="ColorCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad" OnInit="lookup_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }"
                                                                        RowClick="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="8" Width="0px" UnboundType="String">



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
                                                                    <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }"
                                                                        RowClick="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="9" Width="0px" UnboundType="String">



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
                                                                    <ClientSideEvents EndCallback="GridEnd" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }"
                                                                        RowClick="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="RBulkQty" Caption="Remaining Qty" VisibleIndex="6" Width="0px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" ReadOnly="true">
                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}"
                                                                SpinButtons-ShowIncrementButtons="false" ClientInstanceName="gBulkQty" Width="80px">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="BulkQty" Caption="Qty" VisibleIndex="7" Width="80px">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}"
                                                                SpinButtons-ShowIncrementButtons="false" ClientInstanceName="gBulkQty" Width="80px">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="function(s,e){
                                                                  
                                                                         loader.SetText('Calculating');
                                                                         loader.Show();
                                                                         
                                                                         gl4.GetGridView().PerformCallback('BulkQty' + '|' + itemc + '|' + gBulkQty.GetValue());
                                                                 
                                                                         e.processOnServer = false;
                                                                         valchange = true;}" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="100px" Caption="Distribution Unit" FieldName="DistriUnit" Name="DistriUnit" ShowInCustomizationForm="True" VisibleIndex="10" UnboundType="Bound" ReadOnly="true">



                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="InvStatus" Caption="AllocStatus" Name="InvStatus" ShowInCustomizationForm="True" Width="100px" VisibleIndex="10" UnboundType="Bound" ReadOnly="true">
                                                            <Settings AutoFilterCondition="Contains" />
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
                                                                        DropDown="function (s,e){glpallet.GetGridView().PerformCallback( itemc + '|' + colorc + '|' + classc + '|' + sizec + '|' + 'ItemCodeDropDown'  );
                                                                     e.processOnServer = false;                            }"
                                                                        CloseUp="gridLookup_CloseUp" RowClick="function(s,e){ 
                                                                           loader.SetText('Calculating');
                                                                            loader.Show();
                                                                           var g = glpallet.GetGridView();
                                                               
                                                                        g.GetRowValues(e.visibleIndex, 'PalletID;MfgDate;ExpirationDate;BatchNumber;Location;RemainingQty;RecordId;RRdate;LotID;RemainingKilo', UpdateLottables); 
                                                                    }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Location" Name="glLocation" ShowInCustomizationForm="True" VisibleIndex="11">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="False" ShowNewButtonInHeader="true" ShowInCustomizationForm="True" VisibleIndex="1" Width="95px">

                                                            <CustomButtons>

                                                                <dx:GridViewCommandColumnCustomButton ID="Delete" Text="Delete">
                                                                    <Image IconID="actions_cancel_16x16" ToolTip="Delete"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                    <Image IconID="support_info_16x16"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="CountSheet">
                                                                    <Image IconID="arrange_withtextwrapping_topleft_16x16" ToolTip="Countsheet"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="CopyButton" Text="Copy">
                                                                    <Image IconID="edit_copy_16x16" ToolTip="Clone"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>

                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn Caption="Remaining Kilos" Name="RQty" ShowInCustomizationForm="True" VisibleIndex="8" Width="0px" FieldName="RQty" PropertiesTextEdit-NullDisplayText="0" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true" ReadOnly="true">
                                                            <HeaderStyle HorizontalAlign="Center" BackColor="#EBEBEB" Font-Bold="True"></HeaderStyle>
                                                            <PropertiesTextEdit NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N4}">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="AllocStatus" Caption="OCNQtyReqest" Name="AllocStatus" ShowInCustomizationForm="True" Width="100px" VisibleIndex="6" UnboundType="Bound" ReadOnly="true">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="Kilos" Name="Qty" ShowInCustomizationForm="True" VisibleIndex="8" FieldName="Qty">
                                                            <PropertiesTextEdit NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:g}">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="Unit" Name="Unit" ShowInCustomizationForm="True" VisibleIndex="9" Width="80px">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="UnitCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="Unit" KeyFieldName="UnitCode" ClientInstanceName="glUnit" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        ValueChanged="function(s,e){
                                                                        if(unitc != glUnit.GetValue()){
                                                                            gv1.batchEditApi.EndEdit();
                                                                            }}" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ToLocation" VisibleIndex="12" Width="80px" Name="ToLocation">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="ToLocation" runat="server" AutoGenerateColumns="True" AutoPostBack="false" OnInit="gl6_Init"
                                                                    DataSourceID="Location" KeyFieldName="LocationCode" ClientInstanceName="gl6" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" ValueChanged="gridLookup_CloseUp"
                                                                        DropDown="function(s,e){
                                                                        gl6.GetGridView().PerformCallback();
                                                                                                  }"
                                                                        RowClick="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>




                                                        <dx:GridViewDataTextColumn FieldName="PickedQty" Caption="PickedQty" Name="PickedQty" ShowInCustomizationForm="True" Width="100px" VisibleIndex="24" UnboundType="Decimal">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Outlet" Caption="Outlet" Name="Outlet" ShowInCustomizationForm="True" Width="100px" VisibleIndex="24" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DropNo" Caption="DropNo" Name="DropNo" ShowInCustomizationForm="True" Width="100px" VisibleIndex="24" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DeliveryReport" Caption="DeliveryReport" Name="DeliveryReport" ShowInCustomizationForm="True" Width="100px" VisibleIndex="24" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>




                                                        <dx:GridViewDataTextColumn FieldName="BaseQty" Caption="BaseQty" Name="BaseQty" ShowInCustomizationForm="True" Width="0px" VisibleIndex="20" UnboundType="Decimal">
                                                            <PropertiesTextEdit NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N4}">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Price" Caption="Price" Name="Price" ShowInCustomizationForm="True" Width="0px" VisibleIndex="21" UnboundType="Decimal">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BarcodeNo" ShowInCustomizationForm="True" VisibleIndex="23" Width="0px" Caption="Barcode Number">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Caption="Field1" Name="Field1" ShowInCustomizationForm="True" Width="0px" VisibleIndex="24" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Caption="Field2" Name="Field2" ShowInCustomizationForm="True" Width="0px" VisibleIndex="25" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Caption="Field3" Name="Field3" ShowInCustomizationForm="True" Width="0px" VisibleIndex="26" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Caption="Field4" Name="Field4" ShowInCustomizationForm="True" Width="0px" VisibleIndex="27" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Caption="Field5" Name="Field5" ShowInCustomizationForm="True" Width="0px" VisibleIndex="28" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Caption="Field6" Name="Field6" ShowInCustomizationForm="True" Width="0px" VisibleIndex="29" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Caption="Field7" Name="Field7" ShowInCustomizationForm="True" Width="0px" VisibleIndex="30" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Caption="Field8" Name="Field8" ShowInCustomizationForm="True" Width="0px" VisibleIndex="31" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Caption="Field9" Name="Field9" ShowInCustomizationForm="True" Width="0px" VisibleIndex="32" UnboundType="Bound">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BulkUnit" VisibleIndex="7" Name="BulkUnit" PropertiesTextEdit-ClientInstanceName="gbulkunit" Width="80px">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit ClientInstanceName="gbulkunit"></PropertiesTextEdit>
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="BulkUnit" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="Unit" KeyFieldName="UnitCode" ClientInstanceName="glBulkUnit" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
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
                                                        <dx:GridViewDataDateColumn Caption="Manufacturing Date" FieldName="Mkfgdate" ShowInCustomizationForm="True" VisibleIndex="15" UnboundType="String">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn FieldName="BatchNo" Name="BatchNo" ShowInCustomizationForm="True" VisibleIndex="13">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LotID" ShowInCustomizationForm="True" VisibleIndex="14">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn Caption="Expiry Date" FieldName="ExpiryDate" ShowInCustomizationForm="True" VisibleIndex="16">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn Caption="RR Doc Date" FieldName="RRDocdate" ShowInCustomizationForm="True" VisibleIndex="19">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="200px" Caption="SpecialHandlingInstruction" FieldName="SpecialHandlingInstruc" Name="SpecialHandlingInstruc" ShowInCustomizationForm="True" VisibleIndex="25">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Accountcode" Caption="Account Code" Name="Accountcode" ShowInCustomizationForm="True" Width="100px" VisibleIndex="29" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="100px" Caption="RSRW" FieldName="RSRW" Name="RSRW" ShowInCustomizationForm="True" VisibleIndex="30">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="100px" Caption="SO no." FieldName="SONumber" Name="SONumber" ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="120px" Caption="Remarks1" FieldName="MLIRemarks01" Name="Remarks" ShowInCustomizationForm="True" VisibleIndex="32">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="120px" Caption="Remarks2" FieldName="MLIRemarks02" Name="Remarks" ShowInCustomizationForm="True" VisibleIndex="33">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="120px" Caption="RequestQty" FieldName="RBulkQty" Name="RBulkQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="34">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="120px" Caption="OldQty" FieldName="OldBulkQty" Name="OldQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="34">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="120px" Caption="OldKilo" FieldName="OldQty" Name="OldKilo" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="34">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="120px" Caption="PickedPalletID" FieldName="PickedPalletID" ReadOnly="True" Name="PickedPalletID" ShowInCustomizationForm="True" VisibleIndex="34">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="120px" Caption="OldPalletID" FieldName="OldPalletID" Name="OldPalletID" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="34">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                    </Columns>
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsCommandButton>
                                                        <NewButton>
                                                            <Image IconID="actions_addfile_16x16"></Image>
                                                        </NewButton>
                                                        <EditButton>
                                                            <Image IconID="actions_addfile_16x16"></Image>
                                                        </EditButton>
                                                        <%-- <DeleteButton>
                                                            <Image IconID="actions_cancel_16x16"></Image>
 
                                                        </DeleteButton>--%>
                                                    </SettingsCommandButton>
                                                    <SettingsPager Mode="ShowAllRecords" />
                                                    <SettingsBehavior AllowSort="false" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" VerticalScrollableHeight="530" />
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />

                                                    <SettingsEditing Mode="Batch" />
                                                    <%--      <ClientSideEvents EndCallback="OnEndCallback" />--%>
                                                </dx:ASPxGridView>

                                                <table id="TotDate" class="TotDate" style="margin-bottom: 50px;">
                                                    <tr>

                                                        <td style="width: 160px; padding-left: 110px;" class="TotalsLabel">Totals: </td>
                                                        <td style="width: 175px;" id="tdreqQtyName" class="TotalsLabel">Requested Qty:</td>
                                                        <td style="width: 75px;" id="tdreqQty" class="Totalss" runat="server"></td>
                                                        <td style="width: 175px;" id="tdreqKiloName" class="TotalsLabel">Requested Kilo:</td>
                                                        <td style="width: 75px;" id="tdreqKilo" class="Totalss" runat="server"></td>

                                                        <td style="width: 175px;" id="tdpicQtyName" class="TotalsLabel">Picked Qty:</td>
                                                        <td style="width: 75px;" id="tdpicQty" class="Totalss" runat="server"></td>
                                                        <td style="width: 175px;" id="tdpicKiloName" class="TotalsLabel">Picked Kilo:</td>
                                                        <td style="width: 75px;" id="tdpicKilo" class="Totalss" runat="server"></td>
                                                        <td style="width: 190px;" id="fil" class="Totalss" runat="server"></td>


                                                    </tr>

                                                </table>

                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>


                            <%-- <!--#endregion --> --%>
                        </Items>
                    </dx:ASPxFormLayout>
                    <dx:ASPxPanel ID="BottomPanel" runat="server" FixedPosition="WindowBottom" BackColor="#FFFFFF" Height="30px">
                        <PanelCollection>
                            <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                                <div class="pnl-content">
                                    <dx:ASPxCheckBox Style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
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


        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Cloning..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="gv1">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>

    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.PICKLIST+PICKLISTDetail" DataObjectTypeName="Entity.PICKLIST+PICKLISTDetail" DeleteMethod="DeletePICKLISTDetail" UpdateMethod="UpdatePICKLISTDetail" InsertMethod="AddPICKLISTDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="DocNumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  wms.picklistdetail where DocNumber  is null " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsDetail1" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  wms.OCNandPicklistDetail where DocNumber  is null " OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Warehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Description FROM Masterfile.[Warehouse] where isnull(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfilebizcustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,0)=0 and IsCustomer='1'" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="OCN" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber,PickType,StorerKey,WarehouseCode,PlantCode FROM WMS.[OCN] where NOT ISNULL(SubmittedBy,'')='' and  NOT ISNULL(SubmittedDate,'')='' and StatusCode='N' " OnInit="Connection_Init"></asp:SqlDataSource>




    <asp:ObjectDataSource ID="OCNInsert" runat="server" SelectMethod="getdetail" TypeName="Entity.PICKLIST+OCNandPICKLISTDetail" DataObjectTypeName="Entity.PICKLIST+OCNandPICKLISTDetail" UpdateMethod="UpdateOCNandPICKLISTDetail" InsertMethod="AddOCNandPICKLISTDetail" DeleteMethod="DeleteOCNandPICKLISTDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="DocNumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="OCNDETAIL" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Location" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <%--<asp:SqlDataSource ID="Location" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select LocationCode,LocationDescription from masterfile.Location  where isnull(IsInactive,0)= 0" OnInit="Connection_Init"></asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="Unit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.Unit where ISNULL(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsPallet" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="StorageSrc" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.StorageType " OnInit="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="TruckT" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select TruckType from it.TruckType" OnInit="Connection_Init"></asp:SqlDataSource>

    <!--#endregion-->
</body>
</html>
