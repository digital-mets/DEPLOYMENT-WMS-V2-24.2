<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmProdQueue2.aspx.cs" Inherits="GWL.frmProdQueue2" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Production Batch Queue</title>
    <!--#region Region CSS-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 800px; /*Change this whenever needed*/
        }

        .Entry {
            /*width: 1280px;*/ /*Change this whenever needed*/
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
            /*border-radius: 10px;
            -webkit-border-radius: 10px;
            -moz-border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
            -moz-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
            -webkit-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);*/
        }

        .dxeButtonEditSys input,
        .dxeTextBoxSys input {
        }

        .pnl-content {
            text-align: right;
        }
    </style>
    <!--#endregion-->
    <script>
        var isValid = true;
        var counterror = 0;


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

        $(document).ready(function () {
            PerfStart(module, entry, id);
            gv1.SetHeight(400);


        });


        function Showfields() {
            var proc = document.getElementById('pcwip_cp2_ASPxFormLayout1_wipprocess_I').value;
            
            if (proc == 'Weighing')
            {
                Weighing();
            }

            else if (proc == 'Blast Freezing')
            {
                Blast();
            }

            else if (proc == 'Spiral Freezing')
            {
                Spiral();
            }

         else if (proc == 'Cooking') {
             Cooking();
         }

         else {

             for (var i = 7; i < 46; i++) {
                 console.log(i);
                 //pcwip_cp2_ASPxFormLayout1_[i].style.display = 'none';
                 $('#pcwip_cp2_ASPxFormLayout1_' + i).css("display","none");
             }
        
           
             
           };
        }

        function Weighing() {
            pcwip_cp2_ASPxFormLayout1_7.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_8.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_9.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_10.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_11.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_12.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_13.style.display = 'block'

            pcwip_cp2_ASPxFormLayout1_14.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_15.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_16.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_17.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_18.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_19.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_20.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_21.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_22.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_23.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_24.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_25.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_26.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_27.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_28.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_29.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_30.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_31.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_32.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_33.style.display = 'none'

            pcwip_cp2_ASPxFormLayout1_34.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_35.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_36.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_37.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_38.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_39.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_40.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_41.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_42.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_43.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_44.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_45.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_46.style.display = 'none'

        };

        function Blast() {
            pcwip_cp2_ASPxFormLayout1_14.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_15.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_16.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_17.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_18.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_19.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_30.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_31.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_32.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_33.style.display = 'block'


            pcwip_cp2_ASPxFormLayout1_7.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_8.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_9.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_10.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_11.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_12.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_13.style.display = 'none'

            pcwip_cp2_ASPxFormLayout1_20.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_21.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_22.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_23.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_24.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_25.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_26.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_27.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_28.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_29.style.display = 'none'

            pcwip_cp2_ASPxFormLayout1_34.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_35.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_36.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_37.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_38.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_39.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_40.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_41.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_42.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_43.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_44.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_45.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_46.style.display = 'none'
           

        };
        function Spiral() {
            pcwip_cp2_ASPxFormLayout1_20.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_30.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_17.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_18.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_21.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_22.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_23.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_24.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_25.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_26.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_27.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_28.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_29.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_32.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_33.style.display = 'block'

            pcwip_cp2_ASPxFormLayout1_7.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_8.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_9.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_10.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_11.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_12.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_13.style.display = 'none'


            pcwip_cp2_ASPxFormLayout1_14.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_15.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_16.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_19.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_31.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_32.style.display = 'none'

            pcwip_cp2_ASPxFormLayout1_34.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_35.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_36.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_37.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_38.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_39.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_40.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_41.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_42.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_43.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_44.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_45.style.display = 'none'
            pcwip_cp2_ASPxFormLayout1_46.style.display = 'none'


        };

        function Cooking() {
            for (var i = 7; i < 34; i++) {
                console.log(i);
                //pcwip_cp2_ASPxFormLayout1_[i].style.display = 'none';
                $('#pcwip_cp2_ASPxFormLayout1_' + i).css("display", "none");
            }

            pcwip_cp2_ASPxFormLayout1_34.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_35.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_36.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_37.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_38.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_39.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_40.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_41.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_42.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_43.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_44.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_45.style.display = 'block'
            pcwip_cp2_ASPxFormLayout1_46.style.display = 'block'
           
        
        };



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

        function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {
            //2021-05-26    EMC batch update part2
            if (s.cp_viewsku) {
                delete (s.cp_viewsku);//deletes cache variables' data

                //console.log("rec:" + s.cp_recid);

                pcwip.SetHeaderText("SKU:" + s.cp_sku);
                wipBatch.SetText(s.cp_batchno);
                batchid.SetText(s.cp_recid);
                hskucode.SetText(s.cp_sku);
                wipcurrstep.SetText(s.cp_curstep);
                skudesc.SetText(s.cp_skuname);
                wipprogress.SetText(s.cp_progress);
                Qtywip.SetText(s.cp_ExpectedOutputQty);
                // 2021-11-05   TL  Callback to refresh datasource for Process
                wipSKU.SetText(s.cp_sku);       // update SKU Code as well
                cp2.PerformCallback();
                // 2021-11-05   TL  (End)
                console.log('aw');
                console.log(s.cp_ExpectedOutputQty);

                //wipcurrstep.Text = dtsku5.Rows[0]["CurStep"].ToString();
                //skudesc.Text = dtsku5.Rows[0]["ProductName"].ToString();
                //wipprogress.Text = dtsku5.Rows[0]["CProgress"].ToString();

                delete (s.cp_sku);//deletes cache variables' data
                delete (s.cp_batchno);//deletes cache variables' data
                delete (s.cp_recid);//deletes cache variables' data

                delete (s.cp_curstep);//deletes cache variables' data
                delete (s.cp_skuname);//deletes cache variables' data
                delete (s.cp_progress);//deletes cache variables' data
                delete (s.cp_ExpectedOutputQty);//deletes cache variables' data

                gv1.SetHeight(400);

                pcwip.Show();
            }

            if (s.cp_batch) {
                delete (s.cp_batch);//deletes cache variables' data
                //emc999
                // alert("Status : " + s.cp_batchstatus + " idx " + index);

                gv1.SetHeight(400);
                
                gv1.batchEditApi.SetCellValue(index, curcol, s.cp_progress);

                //gv1.batchEditApi.SetCellValue(index, "Status", s.cp_batchstatus);
                //gv1.batchEditApi.SetCellValue(index, "CurrentStep", s.cp_wipprocess);
                //gv1.batchEditApi.SetCellValue(index, "CProgress", s.cp_progress);

                //delete (s.cp_batchstatus);//deletes cache variables' data
                //delete (s.cp_wipprocess);//deletes cache variables' data

                delete (s.cp_progress);//deletes cache variables' data
            }

            if (s.cp_success) {
                alert(s.cp_message);
                delete (s.cp_success);//deletes cache variables' data
                delete (s.cp_message);
                if (s.cp_forceclose) {//NEWADD
                    delete (s.cp_forceclose);
                    window.close();
                }
            }
            if (s.cp_close) {
                if (s.cp_message != null) {
                    alert(s.cp_message);
                    delete (s.cp_message);
                }
                if (s.cp_valmsg != null && s.cp_valmsg != "" && s.cp_valmsg != undefined) {
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
            gv1.SetHeight(400);
        }

        function ViewSKU(useRecID, UseBatch) {
            //hskucode.SetText(useRecID);
            cp.PerformCallback("viewsku|" + useRecID);

            //cp.PerformCallback("batch|" + recordID1);

            //pcwip.SetHeaderText("Batch No: " + UseBatch);
            //pcwip.Show();

            //var generate = confirm("Continue View BatchNo " + UseBatch + " ?");
            //if (generate) {
            //    //CINJODetails.Show();
            //    //CINgvJODetails.CancelEdit();
            //    //cp.PerformCallback('GetJODetails');
            //    //e.processOnServer = false;

            //    //alert("Record ID " + useRecID);
            //    pcwip.Show();
            //}

        }

        var itemc;
        var index;
        var curcol="";

        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;

        function OnStartEditing(s, e) {//On start edit grid function     
            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "JobOrder"); //needed var for all lookups; this is where the lookups vary for

            index = e.visibleIndex;
            var entry = getParameterByName('entry');

            var useID2=  e.focusedColumn.fieldName;
            var useID = useID2.substr(1);
            var useRecID = s.batchEditApi.GetCellValue(e.visibleIndex, "ID" + useID);
            var BatchNo = s.batchEditApi.GetCellValue(e.visibleIndex, "BatchNo");

            curcol = e.focusedColumn.fieldName;

            if (e.focusedColumn.fieldName === "BatchNo") {
                e.cancel = true;
            }
            else
            {
                //console.log(e.focusedColumn);

                console.log("RecID:" + useRecID + " curcol " + curcol);
                //hskucode.SetText(useRecID);
                ViewSKU(useRecID, BatchNo);

            }


            //if (entry == "V" || entry == "D") {
            //    e.cancel = true; //this will made the gridview readonly
            //}


            //if (e.focusedColumn.fieldName === "ColorCode") {
            //    gl2.GetInputElement().value = cellInfo.value;
            //}
            //if (e.focusedColumn.fieldName === "ClassCode") {
            //    gl3.GetInputElement().value = cellInfo.value;
            //}
     
        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
            var cellInfo = e.rowValues[currentColumn.index];
            //if (currentColumn.fieldName === "ItemCategoryCode") {
            //    cellInfo.value = gl.GetValue();
            //    cellInfo.text = gl.GetText();
            //}
            //if (currentColumn.fieldName === "ColorCode") {
            //    cellInfo.value = gl2.GetValue();
            //    cellInfo.text = gl2.GetText();
            //}
            //if (currentColumn.fieldName === "ClassCode") {
            //    cellInfo.value = gl3.GetValue();
            //    cellInfo.text = gl3.GetText();
            //}
            if (currentColumn.fieldName === "JobOrder") {
                cellInfo.value = gl4.GetValue();
                cellInfo.text = gl4.GetText();
            }
        }

        function lookup(s, e) {
            if (isSetTextRequired) {//Sets the text during lookup for item code
                s.SetText(s.GetInputElement().value);
                isSetTextRequired = false;
            }
        }

        var val;
        var temp;
        function GridEnd(s, e) {

            val = s.GetGridView().cp_codes;

            if (val != null) {
                temp = val.split(';');
                delete (s.GetGridView().cp_codes);
            }
            else {
                val = "";
                delete (s.GetGridView().cp_codes);
            }

            if (valchange && (val != null && val != 'undefined' && val != '')) {
                for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                    var column = gv1.GetColumn(i);
                    if (column.visible == false || column.fieldName == undefined)
                        continue;
                    ProcessCells(0, e, column, gv1);
                    gv1.batchEditApi.EndEdit();
                }
            }
        }

        function ProcessCells(selectedIndex, e, column, s) {
            if (val == null) {
                val = ";;";
                temp = val.split(';');
            }

            if (temp[0] == null) {
                temp[0] = "";
            }

            if (selectedIndex == 0) {
                if (column.fieldName == "ProductOrder") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
                }

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
            if (keyCode == ASPxKey.Enter)
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
                //if (column.fieldName == "ATCCode") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                //    
                //    var cellValidationInfo = e.validationInfo[column.index];
                //    if (!cellValidationInfo) continue;
                //    var value = cellValidationInfo.value;
                //    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                //        cellValidationInfo.isValid = false;
                //        cellValidationInfo.errorText = column.fieldName + " is required";
                //        isValid = false;
                //    }
                //}
                var chckd;

                //else 
                if (column.fieldName == "TransAPAmount") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
                if (column.fieldName == "EWT") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if (ASPxClientUtils.Trim(value) == true) {
                        chckd = true;
                    }
                }
                if (column.fieldName == "ATCCode") {
                    var cellValidationInfo = e.validationInfo[column.index];
                    if (!cellValidationInfo) continue;
                    var value = cellValidationInfo.value;
                    if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") && chckd == true) {
                        cellValidationInfo.isValid = false;
                        cellValidationInfo.errorText = column.fieldName + " is required";
                        isValid = false;
                    }
                }
            }
        }

        function OnFileUploadComplete(s, e) {//Loads the excel file into the grid
            gv1.PerformCallback();
        }
        var index = 0;
        function OnCustomClick(s, e) {
            var transtype0 = "";
            var docnumber0 = "";
            var commandtring0 = "";

            var batch1 = s.batchEditApi.GetCellValue(e.visibleIndex, "BatchNo");
            var status1 = s.batchEditApi.GetCellValue(e.visibleIndex, "Status");
            var sku1 = s.batchEditApi.GetCellValue(e.visibleIndex, "SKUcode");

            var recordID1 = s.batchEditApi.GetCellValue(e.visibleIndex, "RecordID");
            var process1 = s.batchEditApi.GetCellValue(e.visibleIndex, "CurrentStep");

            index = e.visibleIndex;

            //emc999
            wipSKU.SetText(sku1);
            wipBatch.SetText(batch1);
            batchid.SetText(recordID1);
            hskucode.SetText(sku1);
            //wipprocess.SetText(process1);
            wipprocess.SetText(hstep.GetText());

            console.log('pasokdito');
            console.log(hstep);
            gridindex.SetText("" + index);

            chkbackflash.SetValue("false");
            chkbackflash.SetText("");

            if (e.buttonID == "wipin") {
                pcwip.SetHeaderText("WIP-IN");
                wiptype.SetText("WIPIN")

                pcwip.Show();
            }

            //if (e.buttonID == "wipfinal") {
            //    pcwip.SetHeaderText("WIP-FINAL-OUT");
            //    wiptype.SetText("WIPFINAL")
            //    pcwip.Show();
            //}


            if (e.buttonID == "tipin") {
                pcwip.SetHeaderText("TIP-IN");
                wiptype.SetText("TIPIN")

                pcwip.Show();
            }

            if (e.buttonID == "wipout") {
                pcwip.SetHeaderText("WIP-OUT");
                wiptype.SetText("WIPOUT")
                chkbackflash.SetText("BackFlush");

                pcwip.Show();

                //window.open(commandtring0 + '?entry=E&transtype=' + transtype0 + '&parameters=&iswithdetail=true&docnumber=' + docnumber0, '_blank', "", false);

                //console.log('NEWTransaction')

            }

            if (e.buttonID == "Details5") {


                //2021-05-21    EMC
                if (status1 != "START") {

                    //alert( " idx1 " + e.visibleIndex);                    
                    s.batchEditApi.SetCellValue(e.visibleIndex, "CProgress", "1/10");

                    //s.batchEditApi.SetCellValue(e.visibleIndex, "Status", "START");

                    //alert("Record ID :" + recordID1 +" ! ");


                    //cp.PerformCallback("batch|" + recordID1);
                    //emc999
                    //wip.Show();
                    pcLogin.SetHeaderText("WIP TRANS");
                    wipSKU.SetText("AAA");

                    pcLogin.Show();

                }
                else {
                    alert("Batch :" + batch1 + " already started !");
                }



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

        function CloseGridLookup() {
            glInvoice.ConfirmCurrentSelection();
            glInvoice.HideDropDown();
            //glInvoice.Focus();
        }

        function Clear() {
            glInvoice.SetValue(null);
        }

        function autocalculate(s, e) {
            var amount = 0.00;
            var vatrate = 0.00;
            var atcrate = 0.00;
            var totalamount = 0.00;


            setTimeout(function () { //New Rows
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        console.log("new row " + indicies[i]);
                    }
                    else { //Existing Rows
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            amount = gv1.batchEditApi.GetCellValue(indicies[i], "Amount");
                            atcrate = gv1.batchEditApi.GetCellValue(indicies[i], "ATCCode");

                            //console.log(gv1.batchEditApi.GetCellValue(indicies[i], "IsVat"));
                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                                vatrate = gv1.batchEditApi.GetCellValue(indicies[i], "vatrate");
                                vatamount += amount * vatrate;
                                grossvatable += amount;
                            }
                            else {
                                grossnonvatable += amount;
                            }

                            if (gv1.batchEditApi.GetCellValue(indicies[i], "IsEWT") == true) {
                                if (gv1.batchEditApi.GetCellValue(indicies[i], "IsVatable") == true) {
                                    atcrate = gv1.batchEditApi.GetCellValue(indicies[i], "atcrate");
                                    whtaxamount += amount * atcrate;
                                }
                            }
                        }
                    }


                }
                totalamountdue = (grossvatable + grossnonvatable + vatamount) - whtaxamount;
                txtvatamount.SetText(vatamount.toFixed(2));
                txtgrossvatable.SetText(grossvatable.toFixed(2));
                txtgrossnonvatable.SetText(grossnonvatable.toFixed(2));
                txtwhvatamount.SetText(whtaxamount.toFixed(2));
                txtamountdue.SetText(totalamountdue.toFixed(2));
            }, 500);
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

            gvRef.SetWidth(width - 120);
            gv1.SetWidth(width - 120);
        }

    </script>
    <!--#endregion-->
</head>
<body style="height: 565px">
    <dx:ASPxGlobalEvents ID="ge" runat="server">
        <ClientSideEvents ControlsInitialized="OnControlsInitialized" />
    </dx:ASPxGlobalEvents>
    <form id="form1" runat="server" class="Entry">
        <dx:ASPxPanel ID="toppanel" runat="server" FixedPositionOverlap="true" FixedPosition="WindowTop" BackColor="#2A88AD" Height="30px">
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxLabel runat="server" ID="htitle" Text="Production Batch Queue" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <%--    <dx:ASPxPopupControl ID="popup" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="factbox" CloseAction="None" 
        EnableViewState="False" HeaderText="Item info" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="90"
         ShowCloseButton="False" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>--%><%--    <h1>AP Voucher</h1>--%>
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="850px" Height="565px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">

                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" Style="margin-left: -3px" ClientInstanceName="frmlayout">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>
                            <%--<!--#region Region Header --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General" ColCount="2">
                                        <Items>
                                            <dx:LayoutItem Caption="Document Number:" Name="DocNumber" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocnumber" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Year" ClientVisible="true">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtyear" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Work Week No" ClientVisible="true">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtweek" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Day No">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server" >
                                                        <dx:ASPxComboBox ID="hdayno" runat="server" Width="170px" ClientInstanceName="hdayno" ReadOnly="true">
                                                            <Items>
                                                                <dx:ListEditItem Text="1" Value="1" Selected="true" />
                                                                <dx:ListEditItem Text="2" Value="2" />
                                                                <dx:ListEditItem Text="3" Value="3" />
                                                                <dx:ListEditItem Text="4" Value="4" />
                                                                <dx:ListEditItem Text="5" Value="5" />
                                                                <dx:ListEditItem Text="6" Value="6" />
                                                                <dx:ListEditItem Text="7" Value="7" />

                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:EmptyLayoutItem></dx:EmptyLayoutItem>

                                            <dx:LayoutItem Caption="Doc Date" ClientVisible="true" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtDocDate" runat="server" Width="170px" ReadOnly="true">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="SKU Code"  ClientVisible="false" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="hskucode" ClientInstanceName="hskucode" runat="server"
                                                            DataSourceID="sdsSKU" KeyFieldName="SKUcode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="SKUcode" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>
                                                        </dx:ASPxGridLookup>

                                                        <%-- <dx:ASPxButton ID="btnskucode" runat="server" AutoPostBack="False" Width="100px" Theme="MetropolisBlue" Text="View" UseSubmitBehavior="false">
                                                            <ClientSideEvents Click="function(s, e) { cp.PerformCallback('skucodeview') }" />
                                                        </dx:ASPxButton>--%>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="" Name="Genereatebtn" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxButton ID="Generatebtn" ClientInstanceName="CINGenerate" runat="server" Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False"
                                                            ClientVisible="true" Text="Generate" Theme="MetropolisBlue">
                                                            <ClientSideEvents Click="function(s, e) { cp.PerformCallback('skucodeview') }" />
                                                        </dx:ASPxButton>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Default Process" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="hstep" ClientInstanceName="hstep" runat="server"
                                                            DataSourceID="sdsStep" KeyFieldName="StepCode" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="StepCode" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>
                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Remarks" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtRemarks" runat="server" OnLoad="TextboxLoad" Width="170px">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                        </Items>
                                    </dx:LayoutGroup>


                                    <dx:LayoutGroup Caption="Reference Transaction" Name="ReferenceTransaction" ClientVisible="false">
                                        <Items>
                                            <dx:LayoutItem Caption="">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridView ID="gvRef"  runat="server" AutoGenerateColumns="False" Width="608px" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" ClientInstanceName="gvRef">
                                                            <SettingsBehavior  AllowSort="false" AllowGroup="false" />
                                                            <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" />
                                                            <SettingsPager PageSize="15">
                                                            </SettingsPager>
                                                            <SettingsEditing Mode="Batch">
                                                            </SettingsEditing>
                                                            <ClientSideEvents Init="OnInitTrans" />
                                                            <%--<Settings ColumnMinWidth="120" HorizontalScrollBarMode="Visible" VerticalScrollableHeight="130" VerticalScrollBarMode="Auto" />--%>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="DocNumber" Name="DocNumber" ShowInCustomizationForm="True" VisibleIndex="5" Caption="DocNumber">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="RTransType" Caption="Reference TransType" ShowInCustomizationForm="True" VisibleIndex="1" ReadOnly="True" Name="RTransType">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewCommandColumn ButtonType="Image" ShowInCustomizationForm="True" VisibleIndex="0" Width="90px">
                                                                    <CustomButtons>
                                                                        <dx:GridViewCommandColumnCustomButton ID="ViewReferenceTransaction">
                                                                            <Image IconID="functionlibrary_lookupreference_16x16"></Image>
                                                                        </dx:GridViewCommandColumnCustomButton>
                                                                        <dx:GridViewCommandColumnCustomButton ID="ViewTransaction">
                                                                            <Image IconID="find_find_16x16"></Image>
                                                                        </dx:GridViewCommandColumnCustomButton>

                                                                    </CustomButtons>
                                                                </dx:GridViewCommandColumn>
                                                                <dx:GridViewDataTextColumn FieldName="REFDocNumber" Caption="Reference DocNumber" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                </dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="TransType" ShowInCustomizationForm="True" VisibleIndex="4">
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
                            </dx:TabbedLayoutGroup>

                            <dx:LayoutGroup Caption="Production Batch Queue Details" ColCount="2">
                                <Items>
                                    <dx:LayoutItem ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="747px"                                                       
                                                    DataSourceID="sdsProdQueue"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" OnCellEditorInitialize="gv1_CellEditorInitialize" ClientInstanceName="gv1"
                                                    KeyFieldName="RecordID"  >
                                                    <SettingsBehavior AllowSort="false" AllowGroup="false"  />
                                                    <ClientSideEvents Init="OnInitTrans"  BatchEditConfirmShowing="OnConfirm" BatchEditRowValidating="Grid_BatchEditRowValidating"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" CustomButtonClick="OnCustomClick" />
                                                    <%--<ClientSideEvents CustomButtonClick="OnCustomClick" />--%>
                                                    
                                                    <SettingsPager PageSize="15"  Visible="false" Mode="ShowAllRecords" />
                                                    
                                                    <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="130" />
                                                    <Columns>

                                                        <%-- <dx:GridViewDataTextColumn FieldName="RecordID" ShowInCustomizationForm="True" Visible="False" VisibleIndex="0" >
                                                                </dx:GridViewDataTextColumn>--%>



                                                        <dx:GridViewDataTextColumn Caption="Batch No" FieldName="BatchNo" Name="BatchNo" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="1">
                                                        </dx:GridViewDataTextColumn>
                                                        
                                                        <dx:GridViewDataTextColumn Caption="S1" FieldName="S1" Name="S1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="2" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="S2" FieldName="S2" Name="S2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="3" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="S3" FieldName="S3" Name="S3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="4" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="S4" FieldName="S4" Name="S4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="5" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="S5" FieldName="S5" Name="S5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="6" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="S6" FieldName="S6" Name="S6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="7" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="S7" FieldName="S7" Name="S7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="8" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="S8" FieldName="S8" Name="S8" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="9" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="S9" FieldName="S9" Name="S9" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="10" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="S10" FieldName="S10" Name="S10" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="11" >
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn Caption="ID1" FieldName="ID1" Name="ID1" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="12" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="ID2" FieldName="ID2" Name="ID2" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="13" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="ID3" FieldName="ID3" Name="ID3" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="14" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="ID4" FieldName="ID4" Name="ID4" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="15" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="ID5" FieldName="ID5" Name="ID5" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="16" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="ID6" FieldName="ID6" Name="ID6" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="17" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="ID7" FieldName="ID7" Name="ID7" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="18" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="ID8" FieldName="ID8" Name="ID8" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="19" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="ID9" FieldName="ID9" Name="ID9" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="20" >
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="ID10" FieldName="ID10" Name="ID10" ShowInCustomizationForm="True" UnboundType="String" VisibleIndex="21" >
                                                        </dx:GridViewDataTextColumn>


<%--                                                        <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonType="Image" Caption="WIP-IN" VisibleIndex="100" Width="60px" ShowNewButtonInHeader="true">
                                                            <CustomButtons>

                                                                <dx:GridViewCommandColumnCustomButton ID="wipin">
                                                                    <Image IconID="reports_addfooter_16x16office2013"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>

                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>

                                                        <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonType="Image" Caption="WIP-OUT" VisibleIndex="101" Width="60px" ShowNewButtonInHeader="true">
                                                            <CustomButtons>

                                                                <dx:GridViewCommandColumnCustomButton ID="wipout">
                                                                    <Image IconID="data_addnewdatasource_16x16office2013"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>

                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>


                 
                                                        <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonType="Image" Caption="TIP-IN" VisibleIndex="101" Width="60px" ShowNewButtonInHeader="true">
                                                            <CustomButtons>

                                                                <dx:GridViewCommandColumnCustomButton ID="tipin">
                                                                    <Image IconID="actions_addfile_16x16office2013"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>

                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>--%>


                                       
                                                    </Columns>
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

        <%--COMBATE--%>
        <dx:ASPxPopupControl ID="pcwip" runat="server" Width="320" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcwip" 
            HeaderText="Login" AllowDragging="True" PopupAnimationType="None" EnableViewState="False" AutoUpdatePosition="true">
           <%-- <ClientSideEvents PopUp="function(s, e) { ASPxClientEdit.ClearGroup('entryGroup'); Qtywip.Focus(); }" />--%>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxCallbackPanel ID="cp2" runat="server" ClientInstanceName="cp2" 
                        OnCallback="cp2_Callback" DefaultButton="btOK">
                        <PanelCollection>
                            <dx:PanelContent runat="server">
                                <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout1" Width="100%" Height="100%">
                                    <Items>

                                        <dx:LayoutItem Caption="Description" >
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="skudesc" runat="server" Width="100%" ClientInstanceName="skudesc">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Current Process" >
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="wipcurrstep" runat="server" Width="100%" ClientInstanceName="wipcurrstep">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Progress" >
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="wipprogress" runat="server" Width="100%" ClientInstanceName="wipprogress">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Qty">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="Qtywip" runat="server" Width="100%" ClientInstanceName="Qtywip">
                                                        <ValidationSettings EnableCustomValidation="True" ValidationGroup="entryGroup" SetFocusOnError="True"
                                                            ErrorDisplayMode="Text" ErrorTextPosition="Bottom" CausesValidation="True">
                                                            <RequiredField ErrorText="required" IsRequired="True" />
                                                            <RegularExpression ErrorText="required" />
                                                            <ErrorFrameStyle Font-Size="10px">
                                                                <ErrorTextPaddings PaddingLeft="0px" />
                                                            </ErrorFrameStyle>
                                                        </ValidationSettings>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="SKU">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="wipSKU" runat="server" Width="100%" ClientInstanceName="wipSKU">
                                                       
                                                        <%--                                                    <ValidationSettings EnableCustomValidation="True" ValidationGroup="entryGroup" SetFocusOnError="True"
                                                        ErrorDisplayMode="Text" ErrorTextPosition="Bottom" CausesValidation="True">
                                                        <RequiredField ErrorText="required" IsRequired="True" />
                                                        <RegularExpression ErrorText="required" />
                                                        <ErrorFrameStyle Font-Size="10px">
                                                            <ErrorTextPaddings PaddingLeft="0px" />
                                                        </ErrorFrameStyle>
                                                    </ValidationSettings>--%>
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Batch #">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="wipBatch" runat="server" Width="100%" ClientInstanceName="wipBatch">

                                                        <%-- <ValidationSettings EnableCustomValidation="True" ValidationGroup="entryGroup" SetFocusOnError="True"
                                                        ErrorDisplayMode="Text" ErrorTextPosition="Bottom" CausesValidation="True">
                                                        <RequiredField ErrorText="required" IsRequired="True" />
                                                        <RegularExpression ErrorText="required" />
                                                        <ErrorFrameStyle Font-Size="10px">
                                                            <ErrorTextPaddings PaddingLeft="0px" />
                                                        </ErrorFrameStyle>
                                                    </ValidationSettings>--%>

                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="Process" Name="Process">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>

                                                    <dx:ASPxGridLookup ID="wipprocess" runat="server" DropDownButton-ClientVisible="true" Width="100%" 
                                                        DataSourceID="sdsStep" OnInit="wipprocess_Init" 
                                                        AutoGenerateColumns="False" ClientInstanceName="wipprocess" KeyFieldName="StepCode" >
                                                        <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('ChangeStep');  e.processOnServer = false;
                                                            

                                                            Showfields();

                                                            }" />
                                                        <GridViewProperties>
                                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                            <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                        </GridViewProperties>

                                                        <Columns>

                                                            <dx:GridViewDataTextColumn FieldName="StepCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                <Settings AutoFilterCondition="Contains" />
                                                            </dx:GridViewDataTextColumn>


                                                        </Columns>
                                                      
                                                    </dx:ASPxGridLookup>

                                                          <dx:ASPxLabel Text="Note: Please type Process or Click space to dispaly available process " runat="server" Width="300"> </dx:ASPxLabel>

                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>


                                        <%--WEIGHING--%>

                                           <dx:LayoutItem Caption="Number of Strands per cart " Name="NumStrands" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="NumStrands" runat="server" Width="100%" 
                                                            ReadOnly="false" ClientInstanceName="NumStrands" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                        
                                            <dx:LayoutItem Caption="Stuffing machine Number used  " Name="glStuffingMach" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glStuffingMach" ClientInstanceName="glStuffingMach" runat="server"
                                                          
                                                            DataSourceID="sdsStuffing" KeyFieldName="MachineName" TextFormatString="{0}" Width="100%">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="MachineName" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="Description" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>

                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Weight of smoke cart" name="txtWeightSmokecart" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtWeightSmokecart" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Weight before Cooking" name="txtWeightbefore" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtWeightbefore" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                             <dx:LayoutItem Caption="QC - Stick properly Y/N" Name="cbQCStick"  ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server" >
                                                                <dx:ASPxCheckBox ID="cbQCStick" runat="server" CheckState="Unchecked" Width="100%">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


 

                                            <dx:LayoutItem Caption="QC - Hotdog properly arranged Y/N" Name="cbQCHotdog" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="cbQCHotdog" runat="server" CheckState="Unchecked" Width="100%">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:layoutitem caption="QC -  ff unlink /untwist (y/n)" name="cbQCfreefrom" ClientVisible="false">
                                                        <layoutitemnestedcontrolcollection>
                                                            <dx:layoutitemnestedcontrolcontainer runat="server">
                                                                <dx:aspxcheckbox id="cbQCfreefrom" runat="server" checkstate="unchecked" Width="100%">
                                                                </dx:aspxcheckbox>
                                                            </dx:layoutitemnestedcontrolcontainer>
                                                        </layoutitemnestedcontrolcollection>
                                            </dx:layoutitem>   

                                        

                            <%--Blast Freeze--%>
                                            <dx:LayoutItem Caption="Time Switch On" name="TimeOn"  ClientVisible="false" >
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeOn" runat="server" DateTime="2009/11/01 15:31:34" Width="100%">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Time Switch Off" name="TimeOff" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeOff" runat="server" DateTime="2009/11/01 15:31:34" Width="100%">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Blast Temp (End)" name="txtBlastTemp" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtBlastTemp" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Product Name" name="txtProductName" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtProductName" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="PD" name="txtPD"  ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtPD" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            
                                             <dx:LayoutItem Caption="# of Packs " Name="NumPacks" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="NumPacks" runat="server" Width="100%" 
                                                            ReadOnly="false" ClientInstanceName="NumPacks" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



            <%--    Spiral Freeze--%>

                                            <dx:LayoutItem Caption="Machine Number" Name="glSpiralMach" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glSpiralMach" ClientInstanceName="glSpiral" runat="server"
                                                          
                                                            DataSourceID="sdsSpiral" KeyFieldName="MachineName" TextFormatString="{0}" Width="170px">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="MachineName" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="Description" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>

                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                             <dx:LayoutItem Caption="Qty Packs " Name="QtyPacks" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="QtyPacks" runat="server" Width="100%" 
                                                            ReadOnly="false" ClientInstanceName="QtyPacks" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Loose Packs Qty " Name="QtyLoosePacks" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="QtyLoosePacks" runat="server" Width="100%"
                                                            ReadOnly="false" ClientInstanceName="QtyLoosePacks" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Time Started" name="TimeStarted" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeStarted" runat="server" DateTime="2009/11/01 15:31:34" Width="100%">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                             <dx:LayoutItem Caption="Time Finised" name="TimeFinished" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeFinished" runat="server" DateTime="2009/11/01 15:31:34" Width="100%">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            



                                            <dx:LayoutItem Caption="Internal Temp Prior Loading" Name="IntTempPL" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="IntTempPL" runat="server" Width="100%" 
                                                            ReadOnly="false" ClientInstanceName="IntTempPL" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Std Room Temp" Name="StdRoomTemp" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxSpinEdit ID="StdRoomTemp" runat="server" Width="100%" 
                                                            ReadOnly="false" ClientInstanceName="StdRoomTemp" 
                                                            SpinButtons-ShowIncrementButtons="false" 
                                                            NullDisplayText="0.00" ConvertEmptyStringToNull="False" NullText="0.00"
                                                            DisplayFormatString="{0:N}" AllowMouseWheel="false" HorizontalAlign="Right">
                                                        </dx:ASPxSpinEdit>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>




                                            <dx:LayoutItem Caption="QA Val- Spiral Temp" name="txtQAVSpiral" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtQAVSpiral" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="QA Val- IT Prior Loading" name="txtQAVPLoad" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtQAVPLoad" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="QA Val- Validated By" name="txtQAVValBy" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtQAVValBy" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>






                                            <dx:LayoutItem Caption="Shift" Name="Shift" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="Shift" ClientInstanceName="Shift" runat="server"
                                                           
                                                            DataSourceID="sdsShift" KeyFieldName="ShiftCode" TextFormatString="{0}" Width="100%">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="ShiftCode" Settings-AutoFilterCondition="Contains" />
                                                                <dx:GridViewDataTextColumn FieldName="ShiftName" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>

                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>



                                            
                                            <dx:LayoutItem Caption="Loaded By" name="txtLoadedBy" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtLoadedBy" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            <dx:LayoutItem Caption="Monitored By" name="txtMonitoredBy" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtMonitoredBy" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                             <dx:LayoutItem Caption="Checked By" name="txtCheckedBy" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCheckedBy" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


<%--                                             <dx:LayoutItem Caption="Remarks">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="ASPxTextBox1" runat="server" OnLoad="TextboxLoad" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            --%>



                        <%--Cooking--%>
                                        <dx:LayoutItem Caption="Smokehouse Number (HS No.) " Name ="glSmokehouse" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxGridLookup ID="glSmokehouse" ClientInstanceName="txtSmokehouse" runat="server"
                                                       
                                                            DataSourceID="sdsStep" KeyFieldName="StepCode" TextFormatString="{0}" Width="100%">
                                                            <GridViewProperties>
                                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                <Settings ShowFilterRow="True" />
                                                            </GridViewProperties>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="StepCode" Settings-AutoFilterCondition="Contains" />
                                                            </Columns>
<%--                                                            <ClientSideEvents
                                                                DropDown="function(){ 
                                                                               
                                                                              gl_objName = 'txtStepCode';
                                                                              gl_sdsName = 'sdsStep';
                                                                              gl_sqlcmd = 'SELECT StepCode FROM Masterfile.Step';
                                                                             
                                                                              gridLookup_Data();

                                                                              }" />--%>

                                                        </dx:ASPxGridLookup>

                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                              <dx:LayoutItem Caption="Time (Standard cooking time Per stage) " name="TimeStandard" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeStandard" runat="server" DateTime="2009/11/01 15:31:34" Width="100%">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Time Start" name="TimeStart" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeStart" runat="server" DateTime="2009/11/01 15:31:34" Width="100%" EditFormat="Time">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                             <dx:LayoutItem Caption="Time End" name="TimeEnd" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxTimeEdit ID="TimeEnd" runat="server" DateTime="2009/11/01 15:31:34" Width="100%">
                                                            <ClearButton DisplayMode="OnHover"></ClearButton>
                                                            <ValidationSettings ErrorDisplayMode="None" />
                                                        </dx:ASPxTimeEdit>

                                               </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                      

                                            <dx:LayoutItem Caption="Stove Temp - STD" name="txtStoveTemp" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStoveTemp" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Stove Temp - Actual" name="txtStoveTempAct" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtStoveTempAct" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                             <dx:LayoutItem Caption="Humidity - STD" name="txtHumiditySTD" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHumiditySTD" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Humidity - Actual" name="txtHumidityAct" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHumidityAct" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Steam Pressure" name="txtSteam" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSteam" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>

                                            
                                            <dx:LayoutItem Caption="Internal Temp After Cooking" name="txtInternal" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtInternal" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Weighing After Cooking" name="TxtWeighingAC" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="TxtWeighingAC" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>


                                            <dx:LayoutItem Caption="Validated by QA - IT" name="txtValidated" ClientVisible="false">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtValidated" runat="server" Width="100%">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>






                                        <dx:LayoutItem Caption="BackFlush" ClientVisible="false">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxCheckBox ID="chkbackflash" runat="server" ClientInstanceName="chkbackflash">
                                                    </dx:ASPxCheckBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="RecordID" ClientVisible="false">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="batchid" runat="server" Width="100%" ClientInstanceName="batchid">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="GridIndex" ClientVisible="false">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="gridindex" runat="server" Width="100%" ClientInstanceName="gridindex">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="TransType" ClientVisible="false">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="wiptype" runat="server" Width="100%" ClientInstanceName="wiptype">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem Caption="User ID" ClientVisible="false">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxTextBox ID="wipuserid" runat="server" Width="100%" ClientInstanceName="wipuserid">
                                                    </dx:ASPxTextBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>

                                        <dx:LayoutItem ShowCaption="False" Paddings-PaddingTop="19" >
                                            <LayoutItemNestedControlCollection >
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxButton ID="btOK" runat="server" Text="Start Process" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                        <ClientSideEvents Click="function(s, e) { if(ASPxClientEdit.ValidateGroup('entryGroup')){ cp.PerformCallback('batch|WIPIN' ); pcwip.Hide(); } }" />
                                                    </dx:ASPxButton>
                                                    
                                                    <dx:ASPxButton ID="btWipOut" runat="server" Text="WIP Out" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                        <ClientSideEvents Click="function(s, e) { if(ASPxClientEdit.ValidateGroup('entryGroup')){ cp.PerformCallback('batch|WIPOUT' ); pcwip.Hide(); } }" />
                                                    </dx:ASPxButton>

                                                    <dx:ASPxButton ID="btTipIn" runat="server" Text="TIP In" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                        <ClientSideEvents Click="function(s, e) { if(ASPxClientEdit.ValidateGroup('entryGroup')){ cp.PerformCallback('batch|TIPIN' ); pcwip.Hide(); } }" />
                                                    </dx:ASPxButton>


                                                    <dx:ASPxButton ID="btCancel" runat="server" Text="Cancel" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px" Visible ="false">
                                                        <ClientSideEvents Click="function(s, e) { pcwip.Hide(); }" />
                                                    </dx:ASPxButton>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:ASPxFormLayout>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxCallbackPanel>
                </dx:PopupControlContentControl>
            </ContentCollection>
            <ContentStyle>
                <Paddings PaddingBottom="5px" />
            </ContentStyle>
        </dx:ASPxPopupControl>
        <%--COMBATE--%>

        <%--EDWIN--%>

        <dx:ASPxPopupControl ID="pcwip2" runat="server" ClientInstanceName="pcwip2"
            CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            HeaderText="WIP" AllowDragging="True" PopupAnimationType="None" EnableViewState="False">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxPanel ID="ASPxPanel7" runat="server">
                        <PanelCollection>
                            <dx:PanelContent runat="server">
                                <table>
                                    <tr>
                                        <td />
                                        <dx:ASPxLabel runat="server" Text="Qty: "></dx:ASPxLabel>
                                        <td />
                                        <dx:ASPxTextBox ID="wipqty" ClientInstanceName="wipqty" runat="server" Width="170px">
                                        </dx:ASPxTextBox>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;
                                        </td>
                                    </tr>


                                    <tr>
                                        <td />
                                        <td />
                                        <dx:ASPxButton ID="wipqtybtn" runat="server" Text="Submit2" AutoPostBack="False">
                                            <ClientSideEvents Click="function(s, e) {
                                                                cp.PerformCallback('RSetWeightSub');
                                                                pcwip.Hide();
                                                                }" />
                                        </dx:ASPxButton>
                                    </tr>
                                </table>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <%--EDWIN--%>

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
                                <td>
                                    <dx:ASPxButton ID="Cancel" runat="server" Text="Cancel" UseSubmitBehavior="false" AutoPostBack="false" CausesValidation="false">
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


    <asp:SqlDataSource ID="sdsProdQueue" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="




"
        OnInit="Connection_Init"></asp:SqlDataSource>


      <asp:SqlDataSource ID="sdsStuffing" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="    select MachineID as MachineName,Description from masterfile.Machinemaster where MachineCategory = 'STUFFING' "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsSpiral" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="    select MachineID as MachineName,Description from masterfile.Machinemaster where MachineCategory = 'SPIRAL FREEZER' "
        OnInit="Connection_Init"></asp:SqlDataSource>


       <asp:SqlDataSource ID="sdsShift" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" 
        SelectCommand="select ShiftCode,ShiftName from masterfile.Shift  "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsStep" runat="server" 
        SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsSKU" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="

SELECT SKUcode
FROM Production.BatchQueue
GROUP BY SKUcode


  "
        OnInit="Connection_Init"></asp:SqlDataSource>



</body>
</html>


