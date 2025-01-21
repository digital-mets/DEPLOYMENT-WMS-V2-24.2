    <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmIssuance.aspx.cs" Inherits="GWL.frmIssuance" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Issuance</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" /><%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
        height: 680px; /*Change this whenever needed*/
        }To

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
            }
            else {
                isValid = true;
            }
        }

        function OnInitTrans(s, e) {
            var transtayp = getParameterByName('transtype');
            if (transtayp != "INVJOI") {
                var BizPartnerCode = aglIssuedTo.GetText();
            }

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
         
        var x = 0;
        function OnUpdateClick(s, e) { //Add/Edit/Close button function
         
                btn.SetEnabled(false);
                //var btnmode = btn.GetText(); //gets text of button
                //if (btnmode == "Delete") {
                //    cp.PerformCallback("Delete");
                //}

                //if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
                //    //Sends request to server side
                //    if (btnmode == "Add") {
                //        cp.PerformCallback("Add");
                //    }
                //    else if (btnmode == "Update") {
                //        cp.PerformCallback("Update");
                //    }
                //    else if (btnmode == "Close") {
                //        cp.PerformCallback("Close");
                //    }
                //}
                //else {
                //    counterror = 0;
                //    alert('Please check all the fields!');
                //    console.log(counterror);
                //} 
                var btnmode = btn.GetText(); //gets text of button
                if (btnmode == "Delete") {
                    cp.PerformCallback("Delete");
                }


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
                        x++;
                    }
                    else if (btnmode == "Update") {
                        if (cntdetails == 0) {
                            cp.PerformCallback("UpdateZeroDetail");
                        }
                        else {
                            cp.PerformCallback("Update");
                        }
                        x++;
                    }
                    else if (btnmode == "Close") {
                        cp.PerformCallback("Close");
                    }
                }
                else {
                    counterror = 0;
                    alert('Please check all the fields!'); 
                } 

                btn.SetEnabled(true);
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
                delete (s.cp_success);
                delete (s.cp_message);
                if (s.cp_forceclose) {
                    delete (s.cp_forceclose);
                    window.close();
                }
                gv1.CancelEdit();

            }

            if (s.cp_close) {
                gv1.CancelEdit();
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
                //delete (s.cp_generated);
                //gv1.CancelEdit();

                if (s.cp_generated == "Reload") {
                    delete (s.cp_generated);
                    gv1.CancelEdit();
                }
                else {

                    delete (s.cp_generated);
                    //gv1.CancelEdit();

                    var _indices = gv1.batchEditApi.GetRowVisibleIndices();
               
                        for (var i = 0; i < _indices.length; i++) {
                            gv1.DeleteRow(_indices[i]);
                        }
                    

                    //gv1.AddNewRow();
                    var _refindices = gvRefC.batchEditApi.GetRowVisibleIndices();

                    setTimeout(function () {
                        for (var i = 0; i < _refindices.length; i++) {

                            gv1.AddNewRow();
                            _indices = gv1.batchEditApi.GetRowVisibleIndices();
                            //alert('ter', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'LineNumber'))

                            gv1.batchEditApi.SetCellValue(_indices[0], 'LineNumber', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'LineNumber'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'ItemCode', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ItemCode'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'FullDesc', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'FullDesc'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'ColorCode', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ColorCode'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'ClassCode', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ClassCode'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'SizeCode', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'SizeCode'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'IssuedQty', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'IssuedQty'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'RequestedQty', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'RequestedQty'));

                            gv1.batchEditApi.SetCellValue(_indices[0], 'BatchNo', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'BatchNo'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'ShiftSched', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'ShiftSched'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'MtlType', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'MtlType'));
                            gv1.batchEditApi.SetCellValue(_indices[0], 'Unit', gvRefC.batchEditApi.GetCellValue(_refindices[i], 'Unit'));
                        }
                    }, 500);
                    gv1.batchEditApi.EndEdit();
                    //gv1.DeleteRow(-1);     // First added dummy record


                    autocalculate();
                  
                }
            }

            if (s.cp_cusgenerated) {
                delete (s.cp_cusgenerated);
                //gv1.CancelEdit();
                autocalculate();
            }

            if (s.cp_clear) {
                gv1.CancelEdit();
                delete (s.cp_clear);
            }

            if (s.cp_vatrate != null) {

                vatrate = s.cp_vatrate;
                delete (s.cp_vatrate);
                vatdetail1 = 1 + parseFloat(vatrate);
            }

            if (s.cp_refdel != null) {
                //gv1.CancelEdit();
                delete (s.cp_refdel);
            }
            //if (s.cp_CallAgain != null) {
            //    cp.PerformCallback('callagain');
            //    delete (s.cp_CallAgain);
            //}
        }

        var index;
        var closing;
        var itemc; //variable required for lookup
        var valchange = false;
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var evn;
        var materialtype;
        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            editorobj = e;
            evn = e;
            var entry = getParameterByName('entry');
            var transtayp = getParameterByName('transtype');
          
        
                if (entry == "V" || entry == "D") {
                    e.cancel = true;
                }  
                
   

                if (chkIsWithRef.GetChecked() == true || chkIsWithRef.GetChecked() == "true") {
                    if (e.focusedColumn.fieldName == "SerialNumber" ||
                        e.focusedColumn.fieldName == "AssetTag")
                        e.cancel = true;
                }


             
            if (e.focusedColumn.fieldName == "MfgDate" || e.focusedColumn.fieldName == "ExpDate" ||
                e.focusedColumn.fieldName == "BatchNo" || e.focusedColumn.fieldName == "LotNo") {
                e.cancel = false;
            }

            if (entry != "V") {
                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                    closing = true;
                }
                if (e.focusedColumn.fieldName === "ColorCode") {
                    gl2.GetInputElement().value = cellInfo.value;
                    //isSetTextRequired = true;
                    //index = e.visibleIndex;
                    //closing = true;
                }
                if (e.focusedColumn.fieldName === "ClassCode") {
                    gl3.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "SizeCode") {
                    gl4.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "Unit") {
                    gl5.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "ShiftSched") {
                    glShift.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "IsByBulk") {
                    glIsByBulk.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName === "MtlType") {
                    glMasterialType.GetInputElement().value = cellInfo.value;
                }

                
            }
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];

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
            if (currentColumn.fieldName === "ShiftSched") {
                cellInfo.value = glShift.GetValue();
                cellInfo.text = glShift.GetText().toUpperCase();
            }
            if (currentColumn.fieldName === "IsByBulk") {
                cellInfo.value = glIsByBulk.GetValue();
            }

            if (currentColumn.fieldName === "MtlType") {
                cellInfo.value = glMasterialType.GetValue();
                cellInfo.text = glMasterialType.GetText().toUpperCase();
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

            console.log(temp);

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
                if (column.fieldName == "IssuedBulkUnit") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
                }
                if (column.fieldName == "FullDesc") {
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
                if (column.fieldName == "MtlType") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[7]);
                }
            }

        }


        function GridEnd(s, e) {

            val = s.GetGridView().cp_codes;
            if (val == null || val == "") {
                val = ";;;;;;;;;";
            }
            temp = val.split(';'); 
            //temp = val.split(';');

            delete (s.GetGridView().cp_identifier);
            if (s.GetGridView().cp_valch) {
                delete (s.GetGridView().cp_valch);
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, editorobj, column, gv1);
                }
                gv1.batchEditApi.EndEdit();
            }

        }

        //function GridEndChoice(s, e) {

        //    identifier = s.GetGridView().cp_identifier;
        //    val = s.GetGridView().cp_codes;
        //    val_ALL = s.GetGridView().cp_codes;

        //    val_VAT = s.GetGridView().cp_codes;
        //    temp_VAT = val_VAT.split(';');

        //    console.log(identifier)
        //    console.log(val_ALL + " ito sila!")
        //    if (identifier == "ItemCode") {
        //        delete (s.GetGridView().cp_identifier);
        //        if (valchange) {
        //            valchange = false;
        //            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
        //                //console.log('anoto')
        //                var column = gv1.GetColumn(i);
        //                if (column.visible == false || column.fieldName == undefined)
        //                    continue;
        //                ProcessCells_ItemCode(0, e.visibleIndex, column, gv1);
        //            }
        //        }
        //        gv1.batchEditApi.EndEdit();
        //    }

        //    if (identifier == "VAT") {
        //        GridEnd_VAT();
        //        gv1.batchEditApi.EndEdit();
        //    }


        //    loader.Hide();
        //}

        function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
            
            //for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                //var column = s.GetColumn(i);
                //var chckd;
                //var chckd2;

                //if (column.fieldName == "IsByBulk") {
                    //var cellValidationInfo = e.validationInfo[column.index];
                    //if (!cellValidationInfo) continue;
                    //var value = cellValidationInfo.value;               
                    //if (value == true) {
                        //chckd2 = true;
                    //}
                //}
                //if (column.fieldName == "IssuedBulkQty") {
                    //var cellValidationInfo = e.validationInfo[column.index];
                    //if (!cellValidationInfo) continue;
                    //var value = cellValidationInfo.value;
                    //if ((!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == null) && chckd2 == true) {
                        //cellValidationInfo.isValid = false;
                        //cellValidationInfo.errorText = column.fieldName + " is required";
                        //isValid = false;
                    //}
                //}
                //if (column.fieldName == "IssuedBulkUnit") {
                    //var cellValidationInfo = e.validationInfo[column.index];
                    //if (!cellValidationInfo) continue;
                    //var value = cellValidationInfo.value;
                    //if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == null) && chckd2 == true) {
                        //cellValidationInfo.isValid = false;
                        //cellValidationInfo.errorText = column.fieldName + " is required";
                        //isValid = false;
                    //}
                //}

                //if (column.fieldName == "IssuedQty") {
                    //var cellValidationInfo = e.validationInfo[column.index];
                    //if (!cellValidationInfo) continue;
                    //var value = cellValidationInfo.value;
                    //if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "0" || ASPxClientUtils.Trim(value) == "0.00" || ASPxClientUtils.Trim(value) == null)) {
                        //cellValidationInfo.isValid = false;
                        //cellValidationInfo.errorText = column.fieldName + " is required!";
                        //isValid = false;
                    //}
                //}
            //}

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

        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.

            gv1.batchEditApi.EndEdit();

        }


        var clonenumber = 0;
        var cloneindex;
        function OnCustomClick(s, e)
        {
            if (e.buttonID == "Details") {
                //var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                //var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                //var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                //var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                //var unit = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                //var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");


                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
                var unitbulk = s.batchEditApi.GetCellValue(e.visibleIndex, "UnitBulk")
                var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                var Warehouse = CINWarehouseCode.GetText();
               
                 
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + encodeURIComponent(itemcode)
                 + '&colorcode=' + encodeURIComponent(colorcode) + '&classcode=' + encodeURIComponent(classcode) + '&sizecode=' + encodeURIComponent(sizecode) + '&Warehouse=' + encodeURIComponent(Warehouse));

     


            }
            if (e.buttonID == "Delete") {
                gv1.DeleteRow(e.visibleIndex);
                autocalculate(s,e);
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
            if (e.buttonID == "CountSheet") {
                CSheet.Show();
                var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
                var docnumber = getParameterByName('docnumber');
                var transtype = getParameterByName('transtype');
                var refdocnum = refno.GetText();
                var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
                var bulkqty = s.batchEditApi.GetCellValue(e.visibleIndex, "IssuedBulkQty");

                var expdate = s.batchEditApi.GetCellValue(e.visibleIndex, "ExpDate");
                var mfgdate = s.batchEditApi.GetCellValue(e.visibleIndex, "MfgDate");
                var batchno = s.batchEditApi.GetCellValue(e.visibleIndex, "BatchNo");
                var lotno = s.batchEditApi.GetCellValue(e.visibleIndex, "LotNo");
				var docdate = dtpDocDate.GetText(); 
                var entry = getParameterByName('entry');

                var Warehouse = CINWarehouseCode.GetText();
                CSheet.SetContentUrl('../WMS/frmTRRSetup.aspx?entry=' + entry + '&docnumber=' + docnumber
                   + '&transtype=' + transtype
                   + '&linenumber=' + linenum
                   + '&refdocnum=' + encodeURIComponent(refdocnum)
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


        function endcp(s, e) {
            var endg = s.GetGridView().cp_endgl1;
            if (endg == true) { 
                e.processOnServer = false;
                endg = null;
            }
        }

        function RefSO(s, e) {
            cp.PerformCallback('CallbackRefSO');
        }

        function ReferenceEffect(s, e) {
            
            cp.PerformCallback('CallbackWithReference')

        }

        Number.prototype.format = function (d, w, s, c) {
            var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
                num = this.toFixed(Math.max(0, ~~d));

            return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
        };

        function autocalculate(s, e) {

            OnInitTrans();

            var DQty = 0.00;
            var SQty = 0.00;

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                        DQty = gv1.batchEditApi.GetCellValue(indicies[i], "IssuedQty") || 0;
                        SQty += DQty;

                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            
                            DQty = gv1.batchEditApi.GetCellValue(indicies[i], "IssuedQty") || 0;
                               SQty += DQty;

                        }
                    }
                }

                txtTotalQty.SetText(SQty.format(4, 5, ',', '.'));

            }, 500);
        }
         function ChargeEvent(s, e) {
            var checkState = cbxIsCharge.GetChecked();
            if (checkState == false)
            {
                txtForeignAmount.SetText(0);
                txtPesoAmount.SetText(0);
            }
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
                <dx:ASPxLabel ID="HeaderText" runat="server" Text="Material Issuance" Font-Bold="true" ForeColor="White"  Font-Size="X-Large"></dx:ASPxLabel>
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
    <dx:ASPxPopupControl ID="CSheet" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CSheet" CloseAction="CloseButton" CloseOnEscape="true"
        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="600px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" 
         ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Init="function (s, e) { cp.PerformCallback('Reload'); e.processOnServer = false; }" />
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
                                                    <%--<dx:LayoutItem Caption="Is Printed">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsPrinted" runat="server" CheckState="Unchecked" ReadOnly="true">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>bulk
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>
                                                    <dx:LayoutItem Caption="Document Number">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocNumber" runat="server" OnLoad="TextboxLoad" Width="170px" AutoCompleteType="Disabled" Enabled="False" ReadOnly ="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Document Date">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtpDocDate" runat="server" OnInit="dtpDocDate_Init" Width="170px" OnLoad="Date_Load" ClientInstanceName="dtpDocDate">
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
                                              
                                                    <dx:LayoutItem Caption="Issued To" RequiredMarkDisplayMode="Required" Name="IssuedTo">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglIssuedTo" runat="server" ClientInstanceName="aglIssuedTo" DataSourceID="sdsIssuedTo" AutoGenerateColumns="False" KeyFieldName="Code" OnLoad="LookupLoad" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties >
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Code" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition ="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
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
                                                    <dx:LayoutItem Caption="Type" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtTransType" runat="server" Width="170px" ReadOnly ="true">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="Warehouse Code" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglWarehouseCode" runat="server" ClientInstanceName="CINWarehouseCode" Width="170px" DataSourceID="sdsWarehouse" AutoGenerateColumns="false" KeyFieldName="WarehouseCode" OnLoad="LookupLoad" TextFormatString="{0}">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
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
                                                   
                                                    <dx:LayoutItem Caption="Total Quantity">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTextBox ID="txtTotalQty" runat="server" Width="170px" ClientInstanceName="txtTotalQty" ReadOnly="True" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.0000"
                                                            DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                            </dx:ASPxTextBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                          <dx:LayoutItem Caption="Remarks">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxMemo ID="memRemarks" runat="server" Height="71px" OnLoad="MemoLoad" Width="170px">
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
                                                    <dx:LayoutItem Caption="With Reference">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsWithRef" runat="server" Checked="True" CheckState="Checked" ClientInstanceName="chkIsWithRef">
                                                                    <ClientSideEvents CheckedChanged="ReferenceEffect" />
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gvRefC" runat="server" ClientInstanceName="gvRefC" AutoGenerateColumns="true" BatchEditStartEditing="OnStartEditing">
                                                                    <SettingsEditing Mode="Batch" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem> 
                                                </Items>
                                            </dx:LayoutGroup>
                                            <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTrans" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Reference Number" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglRefNum" runat="server" DataSourceID="sdsReference" AutoGenerateColumns="False" KeyFieldName="DocNumber" 
                                                                    OnLoad="LookupLoad" TextFormatString="{0}" Width="170px" OnInit ="aglRefNum_Init"  ClientInstanceName="refno">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0" Caption ="Document Number">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="DocDate" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Caption ="Document Date" PropertiesTextEdit-DisplayFormatString="MM/dd/yyyy">
                                                                            <PropertiesTextEdit DisplayFormatString="MM/dd/yyyy"></PropertiesTextEdit>
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="IssuedTo" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Caption ="Issued To">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        
                                                                        <dx:GridViewDataTextColumn FieldName="Remarks" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4" Width="200px">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents Validation="OnValidation" ValueChanged="function(s,e){cp.PerformCallback('CallbackReference');}" />
                                                                    <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip">
                                                                        <RequiredField IsRequired="True" />
                                                                    </ValidationSettings>
                                                                    <InvalidStyle BackColor="Pink">
                                                                    </InvalidStyle>
                                                                </dx:ASPxGridLookup>
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
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server" OnLoad="TextboxLoad" >
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
                                             <dx:LayoutItem Caption="Posted By" Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="PostedBy" runat="server" Width="170px" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Posted Date"  Visible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="PostedDate" runat="server" Width="170px" ReadOnly="True">
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
                                                                <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Width="1200px" ClientInstanceName="gvRef" OnCommandButtonInitialize="gv_CommandButtonInitialize">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick"  Init="OnInitTrans" />
                                                                    
                                                                    <SettingsPager PageSize="5">
                                                                    </SettingsPager>
                                                                    <SettingsEditing Mode="Batch">
                                                                    </SettingsEditing>
                                                                    <SettingsBehavior ColumnResizeMode="NextColumn" FilterRowMode="OnClick" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn Caption="DocNumber" FieldName="DocNumber" ReadOnly="True" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5">
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
                                                                        <dx:GridViewDataTextColumn Caption="Reference DocNumber" FieldName="REFDocNumber" ReadOnly="True"  ShowInCustomizationForm="True" VisibleIndex="2">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" ReadOnly="True" VisibleIndex="4">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="RCommandString" ShowInCustomizationForm="True" VisibleIndex="3" ReadOnly="True" Width="0px">
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="CommandString" ShowInCustomizationForm="True" VisibleIndex="6" ReadOnly="True" Width="0px">
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
                            <dx:LayoutGroup Caption="Issuance Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False"  Width="850px"
                                                    ClientInstanceName="gv1" OnBatchUpdate="gv1_BatchUpdate" OnCellEditorInitialize="gv1_CellEditorInitialize"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCustomButtonInitialize="gv1_CustomButtonInitialize"
                                                    OnInit="gv1_Init" OnRowValidating="grid_RowValidating">
                                                    <ClientSideEvents Init="OnInitTrans" BatchEditConfirmShowing="OnConfirm" BatchEditEndEditing="OnEndEditing" BatchEditStartEditing="OnStartEditing" 
                                                        CustomButtonClick="OnCustomClick" BatchEditRowValidating="Grid_BatchEditRowValidating"/>
                                                    <SettingsPager Mode="ShowAllRecords" />  
                                                     <SettingsEditing Mode="Batch"/>
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="300"  /> 
                                                    <SettingsBehavior AllowSort="False"></SettingsBehavior>
                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="false" VisibleIndex="0">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="90px">
                                                            <CustomButtons>
                                                            <dx:GridViewCommandColumnCustomButton ID="Details" >
                                                                <Image IconID="support_info_16x16" ToolTip="Details"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="CountSheet">
                                                                   <Image IconID="arrange_withtextwrapping_topleft_16x16" ToolTip="Countsheet"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="Delete">
                                                                    <Image IconID="actions_cancel_16x16"> </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="CloneButton" Text="Copy">
                                                                    <Image IconID="edit_copy_16x16" ToolTip="Clone"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" VisibleIndex="2" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Visible="true" Width="80px" ReadOnly="true" UnboundType="String" HeaderStyle-BackColor="#EBEBEB"  HeaderStyle-Font-Bold="true">
                                                            <PropertiesTextEdit ConvertEmptyStringToNull="False">
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                  <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="3" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Name="glpItemCode" Width="80px" UnboundType="String" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-Font-Bold="true">                                                           
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="false" AutoPostBack="false" OnInit="glItemCode_Init" 
                                                                    DataSourceID="sdsItem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="80px" OnLoad="gvLookupLoad">
                                                                   <GridViewProperties Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto" Settings-VerticalScrollableHeight="150" Settings-VerticalScrollBarMode="Visible"> 
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True"/> 
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  DropDown="lookup" 
                                                                        EndCallback="GridEnd"/>
                                                                    <%--<ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"  
                                                                        DropDown="lookup"
                                                                         ValueChanged="function(s,e){
                                                                        if(itemc != gl.GetValue()){
                                                                        gl2.GetGridView().PerformCallback('ItemCode' + '|' + gl.GetValue() + '|' + 'code');
                                                                        e.processOnServer = false;
                                                                        valchange = true;}}" />--%>
                                                                </dx:ASPxGridLookup><%--DropDown="function(s,e){gl.GetGridView().PerformCallback(); e.processOnServer = false;}"--%>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" VisibleIndex="4" Width="120px" Name="FullDesc" Caption="ItemDesc" ReadOnly="True" UnboundType="String"  HeaderStyle-BackColor="#EBEBEB"  HeaderStyle-Font-Bold="true">
                                                        </dx:GridViewDataTextColumn>
                                                       
                                                   
                                                        <dx:GridViewDataTextColumn Caption="Material Type" FieldName="MtlType" Name="MtlType" ShowInCustomizationForm="True" VisibleIndex="5" Width="150px" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                        <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glMasterialType" runat="server" AutoGenerateColumns="False" AutoPostBack="false" 
                                                                    DataSourceID="sdsMaterialType" KeyFieldName="RawMaterialTypeCode" ClientInstanceName="glMasterialType" TextFormatString="{0}" Width="140px"  >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="RawMaterialTypeCode" ReadOnly="True" VisibleIndex="0"/>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>

                                                                    </Columns>
                                                                    
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" ValueChanged="function(s,e){
                                                                     
                                                                        if(materialtype != s.GetValue())
                                                                        gv1.batchEditApi.EndEdit();
                                                                        }"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn Caption="Batch Number" FieldName="BatchNo" Name="BatchNo" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="5" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                                </dx:GridViewDataTextColumn>
                                    
                                                        
                                                         <dx:GridViewDataTextColumn FieldName="ColorCode" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Name="ColorCode" ShowInCustomizationForm="True" VisibleIndex="5" Width="0px" UnboundType="String" HeaderStyle-BackColor="#EBEBEB"  HeaderStyle-Font-Bold="true">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl2" KeyFieldName="ColorCode" OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <%--<ClientSideEvents EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        GotFocus="function dropdown(s, e){
                                                                        gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }"
                                                                        DropDown="lookup" 
                                                                   
                                                                          />--%>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                            <%--     DropDown="function dropdown(s, e){
                                                                gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" --%>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" Name="ClassCode" HeaderStyle-Wrap="True" ShowInCustomizationForm="True" VisibleIndex="6" Width="0px" UnboundType="String" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl3" KeyFieldName="ClassCode" OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0"  >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="function dropdown(s, e){
                                                                gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" CloseUp="gridLookup_CloseUp"  />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" Name="SizeCode" HeaderStyle-Wrap="True" ShowInCustomizationForm="True" VisibleIndex="7" Width="0px" UnboundType="String" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Font-Bold="true">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl4" KeyFieldName="SizeCode" OnInit="lookup_Init" OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0"  >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="function dropdown(s, e){
                                                                gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" CloseUp="gridLookup_CloseUp" />
                                                                    <%--<ClientSideEvents KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" GotFocus="function dropdown(s, e){
                                                                gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }"  DropDown="lookup" />--%>
                                                                </dx:ASPxGridLookup>
                                                               
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                       
                                                       
                                                        <dx:GridViewDataSpinEditColumn FieldName="RequestedQty" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" Name="glpRequestedQty" Caption="Requested Qty" ShowInCustomizationForm="True" VisibleIndex="9" ReadOnly="True" UnboundType="Decimal" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-Font-Bold="true">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.0000" ConvertEmptyStringToNull="False" NullText="0.0000"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false">
                                                                <SpinButtons ShowIncrementButtons="False" Enabled="False"></SpinButtons>
                                                                </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataSpinEditColumn FieldName="IssuedQty" Name="glpIssuedQty"  HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" ShowInCustomizationForm="True" VisibleIndex="9" Caption="Issued Qty" UnboundType="Decimal" HeaderStyle-BackColor="#EBEBEB"  HeaderStyle-Font-Bold="true">
                                                            <PropertiesSpinEdit Increment="0" NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"  DisplayFormatString="{0:#,0.0000;(#,0.0000);}" 
                                                                SpinButtons-ShowIncrementButtons="false" AllowMouseWheel ="false" MinValue ="0" MaxValue="9999999999" >
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents ValueChanged="autocalculate" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>
                                                        <dx:GridViewDataTextColumn Caption="Unit" FieldName="Unit"  HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" ShowInCustomizationForm="True" VisibleIndex="10" Width="80px" UnboundType="String" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-Font-Bold="true">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="gl5" DataSourceID="sdsUnit" KeyFieldName="Unit"  OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px" UnboundType="String" OnInit="lookup_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="Unit" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp" DropDown="function dropdown(s, e){
                                                                gl5.GetGridView().PerformCallback('Unit' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                e.processOnServer = false;
                                                                }" EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                   <dx:GridViewDataTextColumn Caption="Shift" FieldName="ShiftSched"  HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" ShowInCustomizationForm="True" VisibleIndex="10" Width="80px" UnboundType="String" HeaderStyle-BackColor="#EBEBEB" HeaderStyle-Font-Bold="true">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glShift" runat="server" AutoGenerateColumns="False" AutoPostBack="false" ClientInstanceName="glShift" DataSourceID="sdsShift" KeyFieldName="ShiftCode"  OnLoad="gvLookupLoad" TextFormatString="{0}" Width="80px" UnboundType="String">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ShiftCode" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                         <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="0" >
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                         </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp"  EndCallback="GridEnd" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>
                                                       
                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" ShowInCustomizationForm="True" VisibleIndex="27" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" ShowInCustomizationForm="True" VisibleIndex="28" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" ShowInCustomizationForm="True" VisibleIndex="29" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" ShowInCustomizationForm="True" VisibleIndex="30" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False"  ShowInCustomizationForm="True" VisibleIndex="31" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" ShowInCustomizationForm="True" VisibleIndex="32" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" ShowInCustomizationForm="True" VisibleIndex="33" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" ShowInCustomizationForm="True" VisibleIndex="34" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" HeaderStyle-Wrap="True" HeaderStyle-VerticalAlign="Middle" HeaderStyle-HorizontalAlign="Center" Settings-AllowSort="False" ShowInCustomizationForm="True" VisibleIndex="35" UnboundType="String">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Version" Name="glpVersion" Caption="Version" ShowInCustomizationForm="True" VisibleIndex="36" Width="0px" UnboundType="String">
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
                         <td><dx:ASPxButton ID="Ok" runat="server" Text="Ok" UseSubmitBehavior="false" AutoPostBack="False">
                             <ClientSideEvents Click="function (s, e){ cp.PerformCallback('ConfDelete');  e.processOnServer = false;}" />
                             </dx:ASPxButton>
                         <td><dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="False">
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
</form>
    <!--#region Region Datasource-->
    <asp:ObjectDataSource ID="odsHeader" runat="server" DataObjectTypeName="Entity.Issuance" InsertMethod="InsertData" SelectMethod="getdata" TypeName="Entity.Issuance" UpdateMethod="UpdateData" DeleteMethod="DeleteData">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" DataObjectTypeName="Entity.Issuance+IssuanceDetail" SelectMethod="getdetail" UpdateMethod="UpdateIssuanceDetail" TypeName="Entity.Issuance+IssuanceDetail" DeleteMethod="DeleteIssuanceDetail" InsertMethod="AddIssuanceDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String"/>
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String"/> 
        </SelectParameters>
    </asp:ObjectDataSource>
     <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.Request+RefTransaction" >
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
            <asp:QueryStringParameter Name="TransType" QueryStringField="transtype" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Inventory.IssuanceDetail WHERE DocNumber IS NULL" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT [ItemCode], [FullDesc], [ShortDesc] FROM Masterfile.[Item]" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsItemDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT [ItemCode], [ColorCode], [ClassCode], [SizeCode] FROM Masterfile.[ItemDetail] WHERE ISNULL(IsInactive,0)=0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsReference" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DocNumber, CONVERT(Date,DocDate,101) AS DocDate, CostCenter as IssuedTo, Remarks FROM Procurement.PurchaseRequest WHERE ( ISNULL(Submitted,'') != '' AND RequestType IN ('RM','SC','SP'))" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsIssuedTo" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT StepCode AS Code, Description AS Name FROM Masterfile.Step WHERE ISNULL(IsInactive,0)=0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, Description FROM Masterfile.Warehouse WHERE ISNULL([IsInactive],0) = 0" OnInit ="Connection_Init"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sdsUnit" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UnitCode AS Unit  FROM Masterfile.Unit WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
     <asp:SqlDataSource ID="sdsShift" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT ShiftCode,ShiftName AS Description  FROM Masterfile.[Shift] WHERE ISNULL(IsInactive,0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>
   
      <asp:SqlDataSource ID="sdsMaterialType" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="select RawMaterialTypeCode,Description from Masterfile.RawMaterialsType WHERE ISNULL(IsInactive,0)=0" OnInit="Connection_Init"></asp:SqlDataSource>
   
    
    <!--#endregion-->
</body>
</html>


