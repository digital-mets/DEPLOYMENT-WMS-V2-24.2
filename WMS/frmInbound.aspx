<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmInbound.aspx.cs" Inherits="GWL.frmInbound" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Inbound</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 1100px; /*Change this whenever needed*/
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

        .pnl-content {
            text-align: right;
        }

        #cp_form1_layout_PC_0_tblTransfer {
            width: 700px !important;
            min-width: 400px !important;
            min-width: 700px !important;
            margin-left: 0 !important;
        }
    </style>
    <!--#endregion-->

    <!--#region Region Javascript-->
    <!--#region Region Javascript-->
    <script>
        var isValid = true;
        var counterror = 0;
        //var errorDate = 0;
        //var errorRows = [];
        //var DatelineNumber = '';

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var entry = getParameterByName('entry');

        var module = getParameterByName("transtype");
        var id = getParameterByName("docnumber");
        var entry = getParameterByName("entry");
        var CompleteUnlaod = "";

        $(document).ready(function () {
            PerfStart(module, entry, id);
            var CompletUnloadVal = dtpComplete.GetValue();
            if (CompletUnloadVal) {
                CompleteUnlaod = CompletUnloadVal.toLocaleDateString('en-US', {
                    month: '2-digit',
                    day: '2-digit',
                    year: 'numeric'
                });
            }
            else {
                CompleteUnlaod = "01/01/1900";
            }

        });

        function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)

            if (s.GetText() == "" || e.value == "" || e.value == null) {
                counterror++;
                isValid = false
                //console.log(s);
            }
            else {
                isValid = true;
            }
        }

        function OnUpdateClick(s, e) { //Add/Edit/Close button function
            var btnmode = btn.GetText(); //gets text of button
            var Info = [];
            var indicies = gv1.batchEditApi.GetRowVisibleIndices();
            for (var i = 0; i < indicies.length; i++) {
                if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                    gv1.batchEditApi.ValidateRow(indicies[i]);
                    gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("PalletID").index);
                    gv1.batchEditApi.EndEdit();
                }
                else {
                    var key = gv1.GetRowKey(indicies[i]);
                    var lineNum = key.slice(-5); // Get the last 5 characters
                    var DocNum = key.slice(0, -6); // Remove the last 6 characters
                    if (gv1.batchEditApi.IsDeletedRow(key)) {
                        const jsonData = {
                            "DocNumber": DocNum,
                            "LineNumber": lineNum
                        };
                        Info.push(jsonData);

                        //console.log(Info);

                        //$.ajax({
                        //    type: 'POST',
                        //    url: "frmInbound.aspx/DeleteSubDetails",
                        //    contentType: "application/json",
                        //    data: '{_infos: ' + JSON.stringify(Info) + '}',
                        //    dataType: "json",
                        //    success: function (data) {
                        //        console.log('Success');
                        //        //if (data.d.match(/No Changes*/)) {
                        //        //    Groupings.Hide();
                        //        //    alertMesage("error", "", data.d)
                        //        //}
                        //        //else if (data.d.match("Group Name is Taken")) {
                        //        //    Groupings.Hide();
                        //        //    alertMesage("error", "", data.d)
                        //        //}
                        //        //else {
                        //        //    Groupings.Hide();
                        //        //    alertMesage("success", "", "Saved Successfully")
                        //        //    Groupingsgrid.PerformCallback('Shown');
                        //        //}

                        //    }
                        //});
                    }
                    else {
                        gv1.batchEditApi.ValidateRow(indicies[i]);
                        gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("PalletID").index);
                        gv1.batchEditApi.EndEdit();
                    }
                }
            }

            //MANUFACTURING VS EXPIRY DATE
            //for (var i = 0; i < indicies.length; i++) {
            //    Manu = gv1.batchEditApi.GetCellValue(indicies[i], "ManufacturingDate");
            //    Expi = gv1.batchEditApi.GetCellValue(indicies[i], "ExpiryDate");
            //    line = gv1.batchEditApi.GetCellValue(indicies[i], "LineNumber");
            //    // Format ManufacturingDate
            //    var manuDate = new Date(Manu);
            //    var manuFormatted = (manuDate.getMonth() + 1).toString().padStart(2, '0') + '/' +
            //    manuDate.getDate().toString().padStart(2, '0') + '/' +
            //    manuDate.getFullYear();
            //    // Format ExpiryDate
            //    var expiDate = new Date(Expi);
            //    var expiFormatted = (expiDate.getMonth() + 1).toString().padStart(2, '0') + '/' +
            //    expiDate.getDate().toString().padStart(2, '0') + '/' +
            //        expiDate.getFullYear();

            //    // Compare dates and show alert if ExpiryDate is less than ManufacturingDate
            //    if (expiDate <= manuDate) {
            //        errorDate++;
            //        counterror++;
            //        errorRows.push(line);
            //    }
            //}
            //MANUFACTURING VS EXPIRY DATE
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
                //if (errorDate > 0) {
                //    for (k = 0; k < errorDate.length; k++) {
                //        errorRows++;
                //    }
                //    alert('In LineNumber ' + errorRows + '\nManufacturingDate must be greater than ExpiryDate at least 1 Day');
                //    errorDate = 0;
                //    errorRows = [];
                //}
                //else {
                alert('Please check all the fields!');
                //}
                counterror = 0;
            }

            if (btnmode == "Delete") {
                cp.PerformCallback("Delete");
            }

        }

        function OnConfirm(s, e) {//function upon saving entry
            console.log('test')
            console.log(e.requestTriggerID)
            if (e.requestTriggerID === "cp")//disables confirmation message upon saving.
                e.cancel = true;
        }

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {



            if (s.cp_success) {
                if (s.cp_valmsg != null) {
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                }
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);
                if (s.cp_forceclose) {//NEWADD
                    delete (s.cp_forceclose);
                    window.close();
                }
            }

            if (s.cp_close) {
                var btnmode = btn.GetText();
                if (s.cp_message != null) {
                    alert(s.cp_message);
                    delete (s.cp_message);
                }
                if (s.cp_valmsg != null) {
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                }
                if (glcheck.GetChecked() && btnmode != "Close") {
                    if (getParameterByName('entry') === 'N') {
                        window.open('../WMS/frmInbound.aspx?entry=E&transtype=WMSINB&parameters=' +
                            '&iswithdetail=0&docnumber=' + txtDocNumber.GetText(), '_blank');
                        window.close();
                    }
                    else {
                        window.location.reload();
                    }
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
                autocalculate();

                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                //for (var i = 0; i < indicies.length; i++) {
                //    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                //        gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("ItemCode").index);
                //        gv1.batchEditApi.EndEdit();
                //        gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("PalletID").index);
                //        gv1.batchEditApi.EndEdit();
                //    }
                //    else {
                //        var key = gv1.GetRowKey(indicies[i]);
                //        if (gv1.batchEditHelper.IsDeletedItem(key))
                //            console.log("deleted row " + indicies[i]);
                //        else {
                //            gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("ItemCode").index);
                //            gv1.batchEditApi.EndEdit();
                //            gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("PalletID").index);
                //            gv1.batchEditApi.EndEdit();
                //        }
                //    }
                //}
            }

            if (s.cp_icnclose) {
                delete (s.cp_icnclose);
                loader.Hide();
            }

        }

        var evn;
        var index;
        var index2;
        var valchange;
        var valchange2;
        var val;
        var temp;
        var bulkqty;
        var copyFlag;
        var itemc; //variable required for lookup
        var colorc;
        var sizec;
        var classc;
        var unitc;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var palid;
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
                palid = s.batchEditApi.GetCellValue(e.visibleIndex, "PalletID");

                if (bulkqty == null) {
                    bulkqty = 0;
                }

                if (s.batchEditApi.GetCellValue(e.visibleIndex, "Status") == "S") {
                    e.cancel = true;
                }
                evn = e;
                //if (e.visibleIndex < 0) {//new row
                //    var linenumber = s.GetColumnByField("LineNumber");
                //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
                //}
                if (copyFlag) {
                    copyFlag = false;
                    for (var i = 0; i < s.GetColumnsCount(); i++) {
                        var column = s.GetColumn(i);
                        console.log(column.fieldName);

                        if (column.visible == false || column.fieldName == undefined || i == 1 || i > 6)
                            continue;
                        ProcessCells(0, e, column, s);
                    }
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
                    index = e.visibleIndex;
                }
                if (e.focusedColumn.fieldName === "BulkUnit") {
                    isSetTextRequired = true;

                    glBulkUnit.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "Unit") {
                    isSetTextRequired = true;
                    glUnit.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "ToLocation") { //Check the column name
                    e.cancel = true;
                    //glloc.GetInputElement().value = cellInfo.value; //Gets the column value
                    //isSetTextRequired = true;
                }

                //console.log(gvCustomer.GetValue())
                //if (!palid) {
                //    var palcus;
                //    var currdate = new Date();
                //    //console.log(currdate.getYear() + ' ' + currdate.getMonth())
                //    palcus = gvCustomer.GetText();
                //    var year = String(currdate.getYear());
                //    year = year.slice(1, year.length);
                //    var month = parseInt(currdate.getMonth()) + 1;
                //    month = String(month);
                //    console.log(month)
                //    console.log(palcus)
                //    if (month.length == 1)
                //        month = "0" + month;
                //    //console.log(year + '' + month)
                //    if (PalCharCount == "13")
                //        s.batchEditApi.SetCellValue(e.visibleIndex, 'PalletID', palcus + month + '' + year + '-00001');
                //    else
                //        if (PaltwoCustomer == "1")
                //            s.batchEditApi.SetCellValue(e.visibleIndex, 'PalletID', palcus.substring(0, 2) + month + '' + year + '-00001');
                //        else
                //            s.batchEditApi.SetCellValue(e.visibleIndex, 'PalletID', palcus + month + '' + year + '-0001');
                //}
            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            if (entry != "V") {
                if (CompleteUnlaod == "01/01/1900" || CompleteUnlaod == "" || CompleteUnlaod == null) {
                    var cellInfo = e.rowValues[currentColumn.index];
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
                    if (currentColumn.fieldName === "BulkQty") {
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
                    if (currentColumn.fieldName === "ToLocation") {
                        cellInfo.value = glloc.GetValue();
                        cellInfo.text = glloc.GetText().toUpperCase();
                    }

                }
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
                var column = gv1.GetColumn(6);
                ProcessCells2(0, index2, column, gv1);
            }

            if (valchange2) {
                valchange2 = false;
                for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells3(0, index, column, gv1);
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
                s.batchEditApi.SetCellValue(focused, "ReceivedQty", temp[0]);
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
                if (column.fieldName == "ReceivedQty") {
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
            if (keyCode == 13)
                gv1.batchEditApi.EndEdit();
            //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            setTimeout(function () {
                gv1.batchEditApi.EndEdit();
            }, 500);
        }

        //validation
        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            for (var i = 0; i < gv1.GetColumnsCount(); i++) {
                var column = s.GetColumn(i);
                //if (column.fieldName == "ItemCode" || column.fieldName == "Unit") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                //    var cellValidationInfo = e.validationInfo[column.index];
                //    if (!cellValidationInfo) continue;
                //    var value = cellValidationInfo.value;
                //    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = column.fieldName + " is required";
                //        isValid = false;
                //    }
                //}
                //if (column.fieldName == "PalletID") {
                //    var cellValidationInfo = e.validationInfo[column.index];
                //    console.log(cellValidationInfo);
                //    if (!cellValidationInfo) continue;
                //    var value = cellValidationInfo.value;
                //    if (ASPxClientUtils.Trim(value).length < 12) {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = "check " + column.fieldName + "'s format!";
                //        isValid = false;
                //    }
                //    var palcus;
                //    var palstring = ASPxClientUtils.Trim(value);
                //    palcus = gvCustomer.GetValue();
                //    if (PaltwoCustomer == "1") {



                //        palstring= palstring.substring(3, 0).replace(" ", "")

                //        palstring = palstring.replace(/[0-9]/g, '')


                //        console.log('nats' + palstring.substring(3, 0));
                //        console.log('nats1' + palstring.substring(3, 0).replace(" ", ""));

                //        console.log('nats2' + palstring.substring(3, 0).replace(" ", "").length);

                //        if (palstring.length != 2) {
                //            cellValidationInfo.isValid = false;

                //            cellValidationInfo.errorText = "Wrong pallet name!";
                //            isValid = false;
                //        }

                //        palstring = palstring.substring(2, 0);
                //        palcus = palcus.substring(2, 0);
                //    }

                //    else
                //        palstring = palstring.substring(3, 0);


                //    //if (gvCustomer.GetValue() === 'LFE')
                //    //    palcus = 'PMC';
                //    //else if (gvCustomer.GetValue() === 'MPI')
                //    //    palcus = 'MII';
                //    //else





                //    if (palcus != palstring) {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = "Wrong pallet name!";
                //        isValid = false;
                //    }
                //}
            }
        }

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        var num2;
        var temp;
        var num;
        function OnCustomClick(s, e) {
            if (e.buttonID == "Details") {
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
                    + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode);
            }
            if (e.buttonID == "CountSheet") {
                if (s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber") == null) {
                    e.cancel = true;
                }
                else {
                    CSheet.Show();
                    var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
                    var status = s.batchEditApi.GetCellValue(e.visibleIndex, "Status");
                    var docnumber = getParameterByName('docnumber');
                    var transtype = getParameterByName('transtype');
                    var entry = getParameterByName('entry');
                    CSheet.SetContentUrl('frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
                        '&linenumber=' + linenum + '&status=' + status);
                }
            }
            if (e.buttonID == "Delete") {
                if (s.batchEditApi.GetCellValue(e.visibleIndex, "Status") == 'S') {
                    e.cancel = true;
                }
                else {
                    gv1.DeleteRow(e.visibleIndex);
                }
            }
            if (e.buttonID == "CopyButton") {
                var num = clone.GetText();
                console.log(num);
                for (i = 1; i <= num; i++) {
                    index = e.visibleIndex;
                    console.log(e.visibleIndex);
                    copyFlag = true;

                    s.AddNewRow();
                    //console.log(s);
                }
                //loader.SetText('Cloning...');
                //loader.Show();

                //setTimeout(function () {
                //    num = clone.GetText();
                //    var str = gv1.batchEditApi.GetCellValue(e.visibleIndex, "PalletID");
                //    console.log(str)
                //    //if (str === null) {
                //    //    alert('check pallet ID!');
                //    //    loader.Hide();
                //    //}

                //    //temp = str.split('-');
                //    //num2 = temp[1];
                //    num2++;

                //    console.log(num2);

                //    for (i = 1; i <= num; i++) {
                //        index = e.visibleIndex;
                //        copyFlag = true;
                //        s.AddNewRow();
                //        precopy(s, evn);
                //        getgv();
                //    }
                //    loader.Hide();
                //}, 1000);
            }
        }

        //function getgv(s, e) {
        //    var indicies = gv1.batchEditApi.GetRowVisibleIndices();
        //    for (var i = 0; i < indicies.length; i++) {
        //        if (gv1.batchEditApi.IsNewRow(indicies[i])) {
        //            var str = gv1.batchEditApi.GetCellValue(indicies[i], "PalletID");
        //            temp = str.split('-');
        //            num2 = temp[1];
        //            num2++;
        //            if (i <= num) {
        //                break;
        //            }
        //        }
        //    }
        //}

        //function precopy(ss, ee) {
        //    if (copyFlag) {
        //        copyFlag = false;
        //        for (var i = 0; i < gv1.GetColumnsCount(); i++) {
        //            var column = gv1.GetColumn(i);
        //            if (column.visible == false || column.fieldName == undefined)
        //                continue;
        //            ProcessCells(0, ee, column, gv1);
        //        }
        //    }
        //}

        var PalCharCount;
        var PaltwoCustomer;
        function ProcessCells(selectedIndex, e, column, s) {//Clone function :D
            if (selectedIndex == 0) {
                if (column.fieldName == "PalletID") {
                    var str2 = "" + num2
                    var pad;
                    if (PalCharCount == "13" || PaltwoCustomer == "1")
                        pad = "00000";
                    else
                        pad = "0000";

                    var ans = pad.substring(str2.length) + str2
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0] + "-" + ans);

                }
                else if (column.fieldName == "Status") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "");
                }
                else if (column.fieldName == e.focusedColumn.fieldName)
                    e.rowValues[column.index].value = s.batchEditApi.GetCellValue(index, column.fieldName);
                else
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, s.batchEditApi.GetCellValue(index, column.fieldName));
            }
        }

        function Generate(s, e) {
            //console.log(txtDocNumber.GetText());
            //console.log(gvICN.GetText());
            if (txtDocNumber.GetText() != gvICN.GetText()) {

                alert("Inbound Number not equal to ICN Number !")
            }
            else {
                var generate = confirm("Are you sure that you want to generate this ICN?");
                if (generate) {
                    cp.PerformCallback('Generate');
                }
            }

        }

        function DoProcessEnterKey(htmlEvent, editName) {
            if (htmlEvent.keyCode == 13) {
                //htmlEvent.cancelBubble = true;
                ASPxClientUtils.PreventEventAndBubble(htmlEvent);
                if (editName) {
                    ASPxClientControl.GetControlCollection().GetByName(editName).SetFocus();
                }
            }
        }

        function autocalculate(s, e) {
            //console.log(txtNewUnitCost.GetValue());
            OnInitTrans();

            var TotalQuantity = 0.0000;
            var qty = 0.0000;
            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                        qty = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedQty"));

                        TotalQuantity += qty;          //Sum of all Quantity
                        //console.log(TotalQuantity);
                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            qty = parseFloat(gv1.batchEditApi.GetCellValue(indicies[i], "ReceivedQty"));
                            TotalQuantity += qty;
                            //console.log(TotalQuantity);
                        }
                    }
                }
                //txtTotalAmount.SetText(TotalAmount.toFixed(2))
                txtField2.SetText(TotalQuantity.toFixed(4));

            }, 1000);
        }

        function OnInitTrans(s, e) {
            AdjustSize();
            //if ((DockingTime.GetText() == "" || DockingTime.GetText() == null) && CheckIntExt.GetValue() == false) {
            //    // Make StartUnloading read-only
            //    dtpStart.SetEnabled(false);
            //    dtpStart.SetValue(null);
            //    // Make CompleteUnloading read-only
            //    dtpComplete.SetEnabled(false);
            //    dtpComplete.SetValue(null);
            //}
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
            gv1.SetHeight(height - 120);
        }

        //jQuery(document).ready(function ($) {
        //    var isExpired = false;
        //    setInterval(checkSession, 2000);

        //    function checkSession() {
        //        var zhr = $.ajax({
        //            type: "POST",
        //            url: "checksession.aspx/checkcon",
        //            contentType: "application/json; charset=utf-8",
        //            dataType: "json",
        //            success: function (result) {
        //                if (result.d) {
        //                    gv2.Refresh();
        //                }
        //            }
        //        });
        //    }
        //});

        function onload() {
            callonload.PerformCallback();
        }

        function ChangedPalCount(s, e) {
            if (s.cp_palcharcount != null) {
                PalCharCount = s.cp_palcharcount;
                PaltwoCustomer = s.cp_paltwocustomer;
                delete (s.cp_palcharcount);
                delete (s.cp_paltwocustomer);
                gv1.CancelEdit();

            }
        }
    </script>

    <!--#endregion-->


</head>
<body style="height: 910px" onload="onload()">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" Text="Inbound" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
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
        <dx:ASPxCallback runat="server" ID="callonload" OnCallback="callonload_Callback" ClientInstanceName="callonload">
            <ClientSideEvents EndCallback="ChangedPalCount" />
        </dx:ASPxCallback>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="716px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxFormLayout ID="form1_layout" runat="server" Height="900px" Width="850px" Style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocNumber" runat="server" ReadOnly="true" AutoCompleteType="Disabled" Width="170px"
                                                            ClientInstanceName="txtDocNumber">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%-- <dx:LayoutItem Caption="AWB" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAWB" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Customer">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvCustomer" runat="server" Width="170px" AutoGenerateColumns="False" DataSourceID="sdsBizPartner" KeyFieldName="BizPartnerCode" OnLoad="LookupLoad" TextFormatString="{0}"
                                                            OnValueChanged="gvCustomer_ValueChanged" ClientInstanceName="gvCustomer" ClientEnabled="false">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation" />
                                                            <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('CustomerICN');  e.processOnServer = false;
                                                                callonload.PerformCallback();
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
                                            <dx:LayoutItem Caption="Documentation Staff">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStaff" runat="server" ReadOnly="true" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Warehouse Code">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvWarehouse" runat="server" Width="170px" ClientInstanceName="gvWarehouse" AutoGenerateColumns="False" DataSourceID="sdsWarehouse" KeyFieldName="WarehouseCode" OnLoad="LookupLoad" TextFormatString="{0}"
                                                            OnValueChanged="gvWarehouse_ValueChanged">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <ClientSideEvents ValueChanged="function(s,e){cp.PerformCallback('WH');}" />
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="1">
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
                                            <dx:LayoutItem Caption="Warehouse Checker">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtChecker" ReadOnly="true" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Document Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit Width="170px" ID="dtpDocDate" runat="server" OnLoad="Date_Load" OnInit="dtpDocDate_Init">
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
                                            <%--<dx:LayoutItem Caption="Guard On Duty">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtGuard" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <%--<dx:LayoutItem Caption="Customer Representative" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRep" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>

                                            <dx:LayoutItem Caption="Plant">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvPlant" Width="170px" runat="server" ClientInstanceName="gvplant" AutoGenerateColumns="False" DataSourceID="Plant" KeyFieldName="Plantcode">
                                                            <GridViewProperties Settings-ShowFilterRow="true">
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />

                                                                <Settings ShowFilterRow="True"></Settings>
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="Plantcode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents Validation="OnValidation" ValueChanged="function (s, e){ glAssignLoc.SetText(null);}" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="DRNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDRNo" runat="server" OnLoad="TextboxLoad" Width="170px" MaxLength="20">
                                                            <%--<ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>--%>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--                                            <dx:LayoutItem Caption="ContainerNo">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtContainerNo" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Start Unloading">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpStart" runat="server" Width="170px" ClientInstanceName="dtpStart" EditFormatString="MM/dd/yyyy hh:mm tt" UseMaskBehavior="True" TimeSectionProperties-Visible="True" ClientEnabled="true">
                                                            <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Contacting Dept" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtConDept" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>    
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Complete Unloading">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="dtpComplete" runat="server" Width="170px" ClientInstanceName="dtpComplete" EditFormatString="MM/dd/yyyy hh:mm tt" UseMaskBehavior="True" TimeSectionProperties-Visible="True" ClientEnabled="true">
                                                            <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="InvoiceNo">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtInvoice" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <%--<dx:LayoutItem Caption="Container Temperature">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTemp" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <%--<dx:LayoutItem Caption="Packing" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPacking" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="StorageType">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glStorageType" runat="server" AutoGenerateColumns="False" ClientInstanceName="glStorageType" DataSourceID="StorageSrc" KeyFieldName="StorageType" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
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
                                            <dx:LayoutItem Caption="Prod #">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtProdNo" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Receiving Location">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glAssignLoc" runat="server" DataSourceID="Location" KeyFieldName="LocationCode" OnLoad="LookupLoad" TextFormatString="{1}" Width="170px"
                                                            ClientInstanceName="glAssignLoc">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <ClientSideEvents DropDown="function(s,e){
                                                                                                    s.SetText(s.GetInputElement().value);
                                                                                                  }" />
                                                            <%--<ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>--%>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="ICN Number" Name="ICNNumber">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="gvICN" runat="server" AutoGenerateColumns="False" ClientEnabled="False" ClientInstanceName="gvICN" DataSourceID="ICNNumber" KeyFieldName="DocNumber" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumber" ShowInCustomizationForm="True" VisibleIndex="1" Width="50px">
                                                                    <Settings AutoFilterCondition="Contains" />
                                                                </dx:GridViewDataTextColumn>
                                                            </Columns>
                                                            <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('ICN');  e.processOnServer = false;}" />
                                                            <%--<ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>--%>
                                                        </dx:ASPxGridLookup>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Overtime Allowed">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtOvertime" runat="server" ReadOnly="true" AutoCompleteType="Disabled" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Requesting Department Company">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtReqDept" runat="server" ReadOnly="true" AutoCompleteType="Disabled" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Additional Manpower">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAddManpower" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Type of Shipment">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtShipmentType" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="No. of Manpower">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtManpowerNo" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Customer Reference Document">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRefDoc" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="To Be Supplied By">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTBSB" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="TransType">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTranType" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Status">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStatus" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Week #">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtWeekNo" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="IsNoCharge">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="chkIsNoCharge" runat="server" CheckState="Unchecked" OnLoad="CheckboxLoad" Text=" ">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <%--<dx:LayoutItem Caption="Truck No">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTruckNo" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Approving Officer">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtofficer" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Internal Transaction">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="CheckIntExt" runat="server" ClientInstanceName="CheckIntExt" CheckState="Unchecked" OnLoad="CheckboxLoad" Text=" ">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>





                                            <dx:LayoutItem Caption="ICN Total Quantity" ClientVisible="False" Name="ICNTotalQty">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="spinICNTotalQty" runat="server" ClientInstanceName="CINICNTotalQty" OnLoad="SpinEdit_Load" Width="170px">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Handling In Pallet">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="txtHandlingInPt" runat="server" ClientInstanceName="txtHandlingInPt" OnLoad="SpinEdit_Load" Width="170px" MaxValue="999999999">
                                                            <SpinButtons ShowIncrementButtons="False">
                                                            </SpinButtons>
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Normal Receiving">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxCheckBox ID="CheckBlastReq" runat="server" ClientEnabled="false" CheckState="Unchecked" OnLoad="CheckboxLoad" Text=" ">
                                                        </dx:ASPxCheckBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            
                                            <dx:LayoutItem Caption="Clone #">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtClone" runat="server" ClientInstanceName="clone" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="" Name="Genereatebtn">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxButton ID="Generatebtn" runat="server" AutoPostBack="False" CausesValidation="False" ClientVisible="False" Text="Generate" UseSubmitBehavior="False" Width="170px">
                                                            <ClientSideEvents Click="Generate" />
                                                        </dx:ASPxButton>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Customer Trucking Details" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Consignee">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtConsignee" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Consignee Address">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtConAddress" runat="server" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Trucker Name">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTruckName" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <%--<dx:LayoutItem Caption="Delivery Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit ID="txtDelivery" runat="server" Width="170px" EditFormatString="MM/dd/yyyy hh:mm tt" UseMaskBehavior="True" TimeSectionProperties-Visible="True">
                                                            <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>


                                            <dx:LayoutItem Caption="Delivery Date">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxDateEdit Width="170px" ID="txtDelivery" runat="server" OnLoad="Date_Load" OnInit="dtpDocDate_Init">
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


                                            <dx:LayoutItem Caption="Plate Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPlate" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Truck Type">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTruckType" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>

                                            <dx:LayoutItem Caption="Truck Type:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="txtTruckType" runat="server" AutoGenerateColumns="False" DataSourceID="TruckType" KeyFieldName="TruckType" Width="170px">
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








                                            <dx:LayoutItem Caption="Driver">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDriver" ClientInstanceName="txtDriver" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                            <%--<ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>--%>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Seal Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ClientInstanceName="txtSealNo" ID="txtSealNo" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                            <%--<ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>--%>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Container Number">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtContainerNo" ClientInstanceName="txtContainerNo" runat="server" Width="170px" OnLoad="TextboxLoad" ReadOnly="True">
                                                            <%--<ClientSideEvents Validation="OnValidation" />
                                                            <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                <RequiredField IsRequired="True" />
                                                            </ValidationSettings>
                                                            <InvalidStyle BackColor="Pink">
                                                            </InvalidStyle>--%>
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Trucker">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtTrucker" runat="server" Width="170px" OnPreRender="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>
                                            <dx:LayoutItem Caption="Truck to be Provided by METS">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtProv" runat="server" Width="170px" ReadOnly="True">
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
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field6">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server" Width="170px" ClientInstanceName="txtField2" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field7">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="AWB">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field8">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field4">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field9">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Checkers">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCheckers" runat="server" ReadOnly="True" Width="170px" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Guard On Duty">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtGuard" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Client Representative">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRep" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Trucker Representative">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="truckerRepresentativeTxtbox" runat="server" Width="170px" ReadOnly="False" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="remarksTxtBox" runat="server" Width="170px" ReadOnly="False" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="Audit Trail" ColSpan="2" ColCount="2">

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

                                            <dx:LayoutItem Caption="Accepted By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAcceptedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Accepted Date and Time:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtAcceptedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                        </Items>
                                        <Items>

                                            <dx:LayoutItem ClientVisible="true" Caption="Transfers:">
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


                                    <%--2023/09/18 M-Jay Adding Variance Tabe--%>
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
                                    <%--2023/09/18 M-Jay Adding Variance Tabe--%>
                                    <%--2023/11/20 JAF Adding Truck Transactions Tabe--%>
                                    <dx:LayoutGroup Caption="Truck Transactions" ColSpan="2" ColCount="3">
                                        <Items>
                                            <dx:LayoutItem Caption="Arrival Time:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <%--<dx:ASPxTextBox ID="ArrivalTime" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>--%>
                                                        <dx:ASPxDateEdit ID="ArrivalTime1" runat="server" Width="170px" ClientInstanceName="ArrivalTime" EditFormatString="MM/dd/yyyy hh:mm tt" UseMaskBehavior="True" TimeSectionProperties-Visible="True" ClientEnabled="true">
                                                            <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                                        </dx:ASPxDateEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Start Checking Time:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="CheckingStart" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Hold Status:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="HoldStatus" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Docking Door:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="DockingDoor" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Docking Time:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="DockingTime" runat="server" Width="170px" ClientInstanceName="DockingTime" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="End Checking Time:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="CheckingEnd" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Hold Reason:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="HoldReason" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Start Unloading Time:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="StartUnloading" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Departure Time:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="DepartureTime" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Hold Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="HoldDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="End Unloading Time:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="CompleteUnloading" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Dwell Time:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="DwellTime" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Hold Remarks:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="HoldRemarks" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Start RR Processing Time:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="StartProcessing" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="CancelledDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Hold Duration:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="HoldDuration" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="End RR Processing Time:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="EndProcessing" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="CancelledBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Unhold Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="UnHoldDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Status:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="Status" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Caption="VQMILC">
                                        <Items>
                                            <dx:LayoutItem Caption="Batch:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtBatch" runat="server" Width="170px" Enabled="false" ColCount="1" ReadOnly="True">
                                                            <DisabledStyle BackColor="#F9F9F9" />
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Consignee:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCon" runat="server" Width="170px" ColCount="1" OnLoad="TextboxLoad">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                        <Items>
                                            <dx:LayoutGroup Caption="Item Summary">
                                                <Items>
                                                    <dx:LayoutItem Caption=""></dx:LayoutItem>
                                                    <dx:LayoutItem ClientVisible="true" Caption="">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gv4" runat="server" ClientInstanceName="gv4" AutoGenerateColumns="true">
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <%--2023/11/20 JAF Adding Truck Transactions Tabe--%>
                                </Items>
                            </dx:TabbedLayoutGroup>
                            <dx:LayoutGroup Caption="Inbound Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">

                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="850px"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    OnInit="gv1_Init" OnBatchUpdate="gv1_BatchUpdate" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    StylesEditors-Native="true">
                                                    <ClientSideEvents Init="autocalculate" />
                                                    <Settings ShowFilterRowMenu="true" ShowFilterRowMenuLikeItem="true" ShowFilterRow="True" />

                                                    <StylesEditors Native="True"></StylesEditors>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="False" PropertiesTextEdit-Native="true"
                                                            VisibleIndex="0">
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" Visible="true" Width="100px" PropertiesTextEdit-ConvertEmptyStringToNull="true" ReadOnly="true">
                                                            <Settings AutoFilterCondition="EndsWith" />
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False" Native="true">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="3" Width="100px" Name="glItemCode" PropertiesTextEdit-Native="true">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="itemcode_Init" GridViewStylesEditors-Native="true"
                                                                    DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="100px" OnLoad="gvLookupLoad">
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
                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" Caption="ItemDesc" VisibleIndex="4" Width="250px" PropertiesTextEdit-Native="true" ReadOnly="true">
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            <Settings AutoFilterCondition="Contains" />
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="5" Width="0" PropertiesTextEdit-Native="true" UnboundType="String">
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" GridViewStylesEditors-Native="true"
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
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="6" Width="0px" PropertiesTextEdit-Native="true" UnboundType="String">
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init" GridViewStylesEditors-Native="true"
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
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="7" Width="0px" PropertiesTextEdit-Native="true" UnboundType="String">
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init" GridViewStylesEditors-Native="true"
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
                                                        <dx:GridViewDataSpinEditColumn FieldName="BulkQty" Caption="Qty" VisibleIndex="8" Width="80px">
                                                            <PropertiesSpinEdit NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}"
                                                                SpinButtons-ShowIncrementButtons="false" ClientInstanceName="gBulkQty">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="function(s,e){
                                                                         loader.SetText('Calculating');
                                                                         loader.Show();
                                                                         gl4.GetGridView().PerformCallback('BulkQty' + '|' + itemc + '|' + gBulkQty.GetValue());
                                                                         e.processOnServer = false;
                                                                         valchange = true;}" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>


                                                        <dx:GridViewDataTextColumn Name="PalletID" ShowInCustomizationForm="True" Width="120px" VisibleIndex="12" FieldName="PalletID" PropertiesTextEdit-Native="true">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="1" Width="95px" ShowNewButtonInHeader="True">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                    <Image IconID="actions_cancel_16x16"></Image>
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
                                                        <dx:GridViewDataTextColumn Name="ReceivedQty" Caption="Kilos" ShowInCustomizationForm="True" VisibleIndex="10" FieldName="ReceivedQty" PropertiesTextEdit-Native="true">
                                                            <PropertiesTextEdit NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N4}">
                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Unit" Name="Unit" ShowInCustomizationForm="True" VisibleIndex="11">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="UnitCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" GridViewStylesEditors-Native="true"
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
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Name="ToLocation" ShowInCustomizationForm="True" VisibleIndex="18" FieldName="ToLocation" ReadOnly="true">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                            <%--<EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glLocation" runat="server" AutoGenerateColumns="True" AutoPostBack="false" ClientInstanceName="glloc" DataSourceID="ToLocation" KeyFieldName="LocationCode" TextFormatString="{0}" Width="80px"
                                                                 OnInit="LocationCode_Init" GridViewStylesEditors-Native="true">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <ClientSideEvents DropDown="function(s,e){glloc.GetGridView().PerformCallback(); e.processOnServer = false;}" RowClick="function(s,e){
                                                                     setTimeout(function(){
                                                                        gv1.batchEditApi.EndEdit();
                                                                    }, 500);
                                                                  }"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>--%>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="BulkUnit" VisibleIndex="9" Name="BulkUnit" PropertiesTextEdit-ClientInstanceName="gbulkunit">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit ClientInstanceName="gbulkunit"></PropertiesTextEdit>
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="BulkUnit" runat="server" AutoGenerateColumns="False" AutoPostBack="false" GridViewStylesEditors-Native="true"
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
                                                        <dx:GridViewDataDateColumn Caption="MfgDate" FieldName="ManufacturingDate" PropertiesDateEdit-CalendarProperties-ShowTodayButton="false" ShowInCustomizationForm="True" VisibleIndex="15">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="BatchNumber" Name="BatchNumber" ShowInCustomizationForm="True" VisibleIndex="13">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="LotID" ShowInCustomizationForm="True" VisibleIndex="14" Name="LotID">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn FieldName="ExpiryDate" PropertiesDateEdit-CalendarProperties-ShowTodayButton="false" ShowInCustomizationForm="True" VisibleIndex="16" Name="dtpExpiryDate">
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field2" Caption="Client Name" Name="Field2" ShowInCustomizationForm="True" VisibleIndex="19" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn Caption="RRDocDate" FieldName="RRDocDate" ShowInCustomizationForm="True" VisibleIndex="17" Name="dtpRRDocDate" PropertiesDateEdit-DropDownButton-Enabled="false" ReadOnly="true">
                                                            <PropertiesDateEdit>
                                                                <DropDownButton Enabled="False"></DropDownButton>
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="PickedQty" Name="PickedQty" ShowInCustomizationForm="True" Width="0px" VisibleIndex="19" ReadOnly="true">
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Remarks" Name="Remarks" ShowInCustomizationForm="True" VisibleIndex="20">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Status" ShowInCustomizationForm="True" VisibleIndex="21" Width="80px">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="BaseQty" Name="BaseQty" ShowInCustomizationForm="True" VisibleIndex="22" UnboundType="Decimal" ReadOnly="true">
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="ICNQty" Name="ICNQty" ShowInCustomizationForm="True" VisibleIndex="23" Width="80px">
                                                            <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:N}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="StatusCode" ShowInCustomizationForm="True" VisibleIndex="24">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="BarcodeNo" ShowInCustomizationForm="True" VisibleIndex="25" Caption="Barcode Number">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field1" Caption="Field1" Name="Field1" ShowInCustomizationForm="True" VisibleIndex="26" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" Width="150px" Caption="SpecialHandlingInstruction" FieldName="SpecialHandlingInstruc" Name="SpecialHandlingInstruc" ShowInCustomizationForm="True" VisibleIndex="27">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field3" Caption="Field3" Name="Field3" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field4" Caption="Field4" Name="Field4" ShowInCustomizationForm="True" VisibleIndex="29" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field5" Caption="Field5" Name="Field5" ShowInCustomizationForm="True" VisibleIndex="30" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field6" Caption="Field6" Name="Field6" ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field7" Caption="Field7" Name="Field7" ShowInCustomizationForm="True" VisibleIndex="32" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field8" Caption="Field8" Name="Field8" ShowInCustomizationForm="True" VisibleIndex="33" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="Field9" Caption="Field9" Name="Field9" ShowInCustomizationForm="True" VisibleIndex="33" UnboundType="Bound">
                                                            <Settings AutoFilterCondition="Contains" />
                                                            <PropertiesTextEdit Native="True"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn PropertiesTextEdit-Native="true" FieldName="NCRRemarks" Name="NCRRemarks" ShowInCustomizationForm="True" VisibleIndex="34">
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
                                                        <DeleteButton>
                                                            <Image IconID="actions_cancel_16x16"></Image>
                                                        </DeleteButton>
                                                    </SettingsCommandButton>
                                                    <SettingsPager Mode="ShowAllRecords" />
                                                    <SettingsBehavior AllowSort="false" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" VerticalScrollableHeight="530" />
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <SettingsEditing Mode="Batch" />
                                                </dx:ASPxGridView>
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
                                    <dx:ASPxCheckBox Style="display: inline-block;" ID="glcheck" runat="server" ClientInstanceName="glcheck" TextAlign="Left" Text="Prevent auto-close upon update" Width="200px"></dx:ASPxCheckBox>
                                    <dx:ASPxButton ID="updateBtn" runat="server" Text="Add" AutoPostBack="False" CssClass="btn" ClientInstanceName="btn"
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
        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Cloning..." Modal="true"
            ClientInstanceName="loader" ContainerElementID="gv1">
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


        <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.Inbound" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.Inbound" UpdateMethod="UpdateData">
            <SelectParameters>
                <asp:SessionParameter DefaultValue="" Name="DocNumber" SessionField="DocNumber" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.Inbound+InboundDetail" SelectMethod="getdetail" UpdateMethod="UpdateInboundDetail" TypeName="Entity.Inbound+InboundDetail" DeleteMethod="DeleteInboundDetail" InsertMethod="AddInboundDetail">
            <SelectParameters>
                <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
                <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  wms.InboundDetail where DocNumber  is null " OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="sdsBizPartner" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [BizPartnerCode], [Name] FROM Masterfile.[BizPartner] WHERE ISNULL([IsInactive],0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [WarehouseCode], [Description] FROM Masterfile.[Warehouse] WHERE ISNULL([IsInactive],0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>

        <asp:SqlDataSource ID="ICNNumber" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select A.DocNumber from WMS.ICN A LEFT JOIN WMS.Inbound B ON A.DocNumber = B.ICNNumber where ISNULL(A.SubmittedBy,'')!='' and (ISNULL(InboundDocNumber,'')='' or A.Field8 = 'CP_RECEIVED') and (B.DocNumber is null
        or b.DocNumber = @docnumber)"
            OnInit="Connection_Init">
            <SelectParameters>
                <asp:QueryStringParameter Name="docnumber" QueryStringField="docnumber" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="TranType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="" OnInit="Connection_Init"></asp:SqlDataSource>
        <%--    <asp:SqlDataSource ID="Masterfilebiz" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,'')=0" OnInit ="Connection_Init"></asp:SqlDataSource>--%>
        <%--   <asp:SqlDataSource ID="Masterfilebizcustomer" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode, Name FROM Masterfile.[BizPartner] where isnull(IsInactive,'')=0 and IsCustomer='1'" OnInit ="Connection_Init"></asp:SqlDataSource>--%>
        <asp:SqlDataSource ID="Unit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.Unit where ISNULL(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="PutAwayStrategy" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT Code,Description FROM IT.GenericLookup WHERE LookUpKey = 'PTSTR'" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="Location" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT PlantCode,LocationCode from Masterfile.Location where LocationType != 'N' AND ISNULL(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
        <%--<asp:SqlDataSource ID="ToLocation" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT LocationCode,WarehouseCode,RoomCode from Masterfile.Location" OnInit ="Connection_Init"></asp:SqlDataSource>--%>
        <asp:SqlDataSource ID="Plant" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode,Plantcode from Masterfile.Plant WHERE ISNULL(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="TruckType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select TruckType from IT.TruckType" OnInit="Connection_Init"></asp:SqlDataSource>
        <%--<asp:SqlDataSource ID="sdsICNDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.DocNumber,A.LineNumber,A.ItemCode,A.ColorCode,A.ClassCode,A.SizeCode,A.BulkQty,C.BulkUnit,InputBaseQty as ReceivedQty,A.Unit,c.ExpiryDate,c.BatchNumber,c.ManufacturingDate,c.ToLocation,c.PalletID,c.LotID,c.RRDocDate,c.PickedQty,c.Remarks,A.BaseQty,A.StatusCode,A.BarcodeNo,A.Field1,A.Field2,A.Field3,A.Field4,A.Field5,A.Field6,A.Field7,A.Field8,A.Field9 FROM WMS.ICNDetail A INNER JOIN WMS.ICN B ON A.DocNumber = B.DocNumber CROSS JOIN wms.inbounddetail C WHERE ISNULL(InboundDocNumber,'')=''">--%>
        <asp:SqlDataSource ID="sdsICNDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.DocNumber,A.LineNumber,a.ItemCode,FullDesc,a.ColorCode,a.ClassCode,a.SizeCode,BulkQty,BulkUnit,InputBaseQty as ReceivedQty,Unit,A.ExpiryDateICN as ExpiryDate,A.BatchNumberICN as BatchNumber,A.ManufacturingDateICN as ManufacturingDate,'' as ToLocation,'' as PalletID,'' as LotID,GETDATE() as RRDocDate,0 as PickedQty,'' as Remarks,'' as Status,BaseQty,'' AS ICNQty,StatusCode,BarcodeNo,A.Field1,A.Field2,A.Field3,A.Field4,A.Field5,A.Field6,A.Field7,A.Field8,A.Field9,A.SpecialHandlingInstruc, '' AS NCRRemarks
           FROM WMS.ICNDetail A INNER JOIN WMS.ICN B ON A.DocNumber = B.DocNumber left join masterfile.item c on a.itemcode = c.itemcode  and b.CustomerCode = c.Customer WHERE ISNULL(InboundDocNumber,'')='' group by  A.DocNumber,A.LineNumber,a.ItemCode,FullDesc,a.ColorCode,a.ClassCode,a.SizeCode,BulkQty,BulkUnit,InputBaseQty,Unit,BaseQty,StatusCode,BarcodeNo,A.Field1,A.Field2,A.Field3,A.Field4,A.Field5,A.Field6,A.Field7,A.Field8,A.Field9,A.SpecialHandlingInstruc,A.BatchNumberICN,A.ManufacturingDateICN,A.ExpiryDateICN  order by a.linenumber"
            OnInit="Connection_Init"></asp:SqlDataSource>
        <asp:SqlDataSource ID="StorageSrc" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Masterfile.StorageType " OnInit="Connection_Init"></asp:SqlDataSource>
    </form>
</body>
</html>


