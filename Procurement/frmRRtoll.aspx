<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmRRtoll.aspx.cs" Inherits="GWL.frmRRtoll" %>

<%@ Register Assembly="DevExpress.Web.v24.2, Version=24.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
    <script src="../js/PerfSender.js" type="text/javascript"></script>
    <title>Receiving Report</title>
    <link rel="Stylesheet" type="text/css" href="~/css/styles.css" />
    <%--Link to global stylesheet--%>
    <script src="../js/jquery-1.6.1.min.js" type="text/javascript"></script>
    <%--NEWADD--%>
    <script src="../js/jquery-ui.min.js" type="text/javascript"></script>
    <%--NEWADD--%>

    <!--#region Region Javascript-->
    <style type="text/css">
        /*Stylesheet for separate forms (All those which has comments are the ones that can only be changed)*/
        #form1 {
            height: 580px; /*Change this whenever needed*/
        }

        .Entry {
            padding: 20px;
            margin: 10px auto;
            background: #FFF;
        }

        .pnl-content {
            text-align: right;
        }

        .statusBar a:first-child {
            display: none;
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

        //       function getParameterByName(name) {
        //    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        //    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        //        results = regex.exec(location.search);
        //    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        //}

        var module = getParameterByName("transtype");
        var id = getParameterByName("docnumber");
        var entry = getParameterByName("entry");
        var useparam = getParameterByName("parameters");
        var itemc;

        $(document).ready(function () {
            //emc999
            //console.log("REQUEST TYPE : " + useparam);

            autocalculate();

            PerfStart(module, entry, id);

        });

        function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)
            // var DocDate = CINDocDate.GetText();
            // var TargetDate = CINTargetDate.GetText();
            // console.log(DocDate + ' DOcDate')

            // console.log(TargetDate + ' TargetDate')
            // if (TargetDate < DocDate)
            // {
            //     console.log('TargetDate < DocDate');
            //     e.isValid = false;
            // }

            if (s.GetText() == "" || e.value == "" || e.value == null) {

                counterror++;
                isValid = false
            }
            else {
                isValid = true;
            }
        }


        //emc2021
        function CheckRefDocFound(useDoc,colName, gridUsed) {

            var RRref2 = hrrrefdoc2.GetText();

            var indicies = gridUsed.batchEditApi.GetRowVisibleIndices();
            var TempDoc = "";
            for (var i = 0; i < indicies.length; i++) {
                if (gridUsed.batchEditApi.IsNewRow(indicies[i])) {
                    TempDoc = gridUsed.batchEditApi.GetCellValue(indicies[i], colName);

                    if (TempDoc === useDoc)
                    {
                        return true;
                    }
                }
                else {
                    var key = gridUsed.GetRowKey(indicies[i]);
                    if (gridUsed.batchEditApi.IsDeletedRow(key))
                        console.log("deleted row " + indicies[i]);
                    else {
                        TempDoc = gridUsed.batchEditApi.GetCellValue(indicies[i], colName);

                        if (TempDoc === useDoc)
                        {
                            return true;
                        }

                    }
                }
            }


            return false;
        }

        //emc888
        function autocalculate(s, e) {
            var retqty = 0.00;
            var totretqty = 0.00;

            //console.log("TotQty: " + totretqty);

            // console.log("TotQty: " );

            setTimeout(function () {
                var indicies = gv1.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
                        retqty = gv1.batchEditApi.GetCellValue(indicies[i], "RRQty");
                        totretqty += retqty;


                    }
                    else {
                        var key = gv1.GetRowKey(indicies[i]);
                        if (gv1.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            retqty = gv1.batchEditApi.GetCellValue(indicies[i], "RRQty");
                            totretqty += retqty;
                        }
                    }
                }

                //For Service Grid

                indicies = gvService.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gvService.batchEditApi.IsNewRow(indicies[i])) {
                        retqty = gvService.batchEditApi.GetCellValue(indicies[i], "RRQty2");
                        totretqty += retqty;


                    }
                    else {
                        var key = gvService.GetRowKey(indicies[i]);
                        if (gvService.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            retqty = gvService.batchEditApi.GetCellValue(indicies[i], "RRQty2");
                            totretqty += retqty;
                        }
                    }
                }

                //For Scrap Grid

                indicies = gvScrap.batchEditApi.GetRowVisibleIndices();
                for (var i = 0; i < indicies.length; i++) {
                    if (gvScrap.batchEditApi.IsNewRow(indicies[i])) {
                        retqty = gvScrap.batchEditApi.GetCellValue(indicies[i], "RRQty3");
                        totretqty += retqty;


                    }
                    else {
                        var key = gvScrap.GetRowKey(indicies[i]);
                        if (gvScrap.batchEditApi.IsDeletedRow(key))
                            console.log("deleted row " + indicies[i]);
                        else {
                            retqty = gvScrap.batchEditApi.GetCellValue(indicies[i], "RRQty3");
                            totretqty += retqty;
                        }
                    }
                }



                //txtTotalQty.SetText(totretqty.format(4, 5, ',', '.'));
                txtTotalQty.SetText("" + totretqty);
                //console.log("TotQty: " + totretqty);
            }, 500);
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
            //if (s.cp_success) {
            //    if (s.cp_valmsg != null || s.cp_valmsg != '') {
            //        alert(s.cp_valmsg);
            //    }
            //    if(s.cp_message != null) {
            //        alert(s.cp_message);
            //    }
            //    delete (s.cp_valmsg);
            //    delete (s.cp_success);//deletes cache variables' data
            //    delete (s.cp_message);
            //}


            if (s.cp_close) {
                if (s.cp_message != null) {
                    alert(s.cp_message);
                    delete (s.cp_message);
                }
                if (s.cp_valmsg) {
                    alert(s.cp_valmsg);
                    delete (s.cp_valmsg);
                }
                if (glcheck.GetChecked()) {
                    delete (cp_close);
                    window.location.reload();
                }
                else {
                    console.log('aw');
                    delete (cp_close);
                    window.close();//close window if callback successful
                }
            }

            if (s.cp_delete) {
                delete (cp_delete);
                DeleteControl.Show();
            }

            if (s.cp_forceclose) {//NEWADD
                delete (s.cp_forceclose);
                window.close();
            }

            if (s.cp_generated)
            {
                delete (s.cp_generated);


                //CheckRefDocFound(useDoc, colName, gridUsed)
                var rrRefDoc2 = hrrrefdoc2.GetText();

                if (hreftype.GetValue() === 'RM')
                {
                    if (CheckRefDocFound(rrRefDoc2, 'RefRawMatCode', gv1))
                    {
                        alert("Raw Material Reference Doc " + rrRefDoc2 + " already Exists !");
                        return;
                    }
                }
                else if (hreftype.GetValue() === 'SP')
                {
                    if (CheckRefDocFound(rrRefDoc2, 'RefSpiCode', gvService)) {
                        alert("Spices Reference Doc " + rrRefDoc2 + " already Exists !");
                        return;
                    }

                }


                //emc2021
                var _refindices = gv2.batchEditApi.GetRowVisibleIndices();

                //alert("Data Count : " + _refindices.length + " type: " + hreftype.GetValue());

                var _indices = 0;

                for (var i = 0; i < _refindices.length; i++) {

                    if (hreftype.GetValue() === 'RM')
                    {
                        gv1.AddNewRow();
                        _indices = gv1.batchEditApi.GetRowVisibleIndices();
                        gv1.batchEditApi.SetCellValue(_indices[0], 'RefRawMatCode', gv2.batchEditApi.GetCellValue(_refindices[i], 'DocNumber'));
                        gv1.batchEditApi.SetCellValue(_indices[0], 'WarehouseCode', gv2.batchEditApi.GetCellValue(_refindices[i], 'WarehouseCode'));
                        gv1.batchEditApi.SetCellValue(_indices[0], 'ItemCode', gv2.batchEditApi.GetCellValue(_refindices[i], 'ItemCode'));
                        gv1.batchEditApi.SetCellValue(_indices[0], 'FullDesc', gv2.batchEditApi.GetCellValue(_refindices[i], 'FullDesc'));
                        gv1.batchEditApi.SetCellValue(_indices[0], 'RequestQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'RequestQty'));
                        gv1.batchEditApi.SetCellValue(_indices[0], 'UOMReq', gv2.batchEditApi.GetCellValue(_refindices[i], 'UOM_Rq'));
                        gv1.batchEditApi.SetCellValue(_indices[0], 'UnitBase', gv2.batchEditApi.GetCellValue(_refindices[i], 'UOM_Rq'));
                        gv1.batchEditApi.SetCellValue(_indices[0], 'Field2', gv2.batchEditApi.GetCellValue(_refindices[i], 'BatchNo'));
                        gv1.batchEditApi.SetCellValue(_indices[0], 'RRQty', gv2.batchEditApi.GetCellValue(_refindices[i], 'RequestQty'));
                       
                    }
                    else if (hreftype.GetValue() === 'SP')
                    {
                        
                        gvService.AddNewRow();
                        _indices = gvService.batchEditApi.GetRowVisibleIndices();
                        gvService.batchEditApi.SetCellValue(_indices[0], 'RefSpiCode', gv2.batchEditApi.GetCellValue(_refindices[i], 'DocNumber'));
                        gvService.batchEditApi.SetCellValue(_indices[0], 'CustomerCode', gv2.batchEditApi.GetCellValue(_refindices[i], 'CustomerCode'));
                        gvService.batchEditApi.SetCellValue(_indices[0], 'ItemCode2', gv2.batchEditApi.GetCellValue(_refindices[i], 'ItemCode'));
                        gvService.batchEditApi.SetCellValue(_indices[0], 'Description', gv2.batchEditApi.GetCellValue(_refindices[i], 'FullDesc'));
                        gvService.batchEditApi.SetCellValue(_indices[0], 'ReqQty2', gv2.batchEditApi.GetCellValue(_refindices[i], 'RequestQty'));
                        gvService.batchEditApi.SetCellValue(_indices[0], 'UOMreq2', gv2.batchEditApi.GetCellValue(_refindices[i], 'UOM_Rq'));
                        gvService.batchEditApi.SetCellValue(_indices[0], 'UOMrr2', gv2.batchEditApi.GetCellValue(_refindices[i], 'UOM_Rq'));
                        gvService.batchEditApi.SetCellValue(_indices[0], 'Field2', gv2.batchEditApi.GetCellValue(_refindices[i], 'BatchNo'));
                        gvService.batchEditApi.SetCellValue(_indices[0], 'RRQty2', gv2.batchEditApi.GetCellValue(_refindices[i], 'RequestQty'));

                    }
                    //else if (hreftype.GetValue() === 'SC')
                    //{

                    //}




                    //alert("item : " + gv2.batchEditApi.GetCellValue(_refindices[i], 'ItemCode'));

                    autocalculate();
                }


            }
        }

        var generateAction = 0;
        var index;
        var closing;
        var valchange = false;
        var itemc; //variable required for lookup
        var currentColumn = null;
        var isSetTextRequired = false;
        var linecount = 1;
        var curr;

        var customerload;
        var itemcodeload;
        var unitc;
        var unitc2;
        function OnStartEditing(s, e) {//On start edit grid function     


            currentColumn = e.focusedColumn;
            var cellInfo = e.rowValues[e.focusedColumn.index];
            itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
            unitc = s.batchEditApi.GetCellValue(e.visibleIndex, "UnitBase");
            unitc2 = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
            //if (e.visibleIndex < 0) {//new row
            //    var linenumber = s.GetColumnByField("LineNumber");
            //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
            //}
            curr = e;
            index = e.visibleIndex;
            if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsAllowPartial") === null) {
                s.batchEditApi.SetCellValue(e.visibleIndex, "IsAllowPartial", true)
            }


            var entry = getParameterByName('entry');


            if (entry == "V" || entry == "D") {
                e.cancel = true; //this will made the gridview readonly
            }

            if (entry != "V") {

                //console.log("START col: " + PutColName + " idx:" + PutValueIndex + " e: " + e.focusedColumn.name );
              //  console.log("GRID START col: " + PutColName + " CurCol: " + currentColumn.fieldName + " Cell Value: " + cellInfo.value + " idx: " + index + " grid: " + s.name + " action : " + generateAction);

                if (e.focusedColumn.fieldName === "RequestQty") {
                    e.cancel = true; //this will made the gridview readonly
                }
                

                if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
                    gl.GetInputElement().value = cellInfo.value; //Gets the column value
                    isSetTextRequired = true;
                    index = e.visibleIndex;
                    closing = true;
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
                if (e.focusedColumn.fieldName === "UnitBase") {
                    isSetTextRequired = true;
                    gl5.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "ServiceType") {
                    glService.GetInputElement().value = cellInfo.value;
                }
                if (e.focusedColumn.fieldName === "Unit") {
                    isSetTextRequired = true;
                    glUnit.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName === "RefSpiCode") {
                    glrefSPcode.GetInputElement().value = cellInfo.value;
                }


                if (e.focusedColumn.fieldName === "WarehouseCode") {
                    d1wh.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName === "RefRawMatCode") {
                    d1refcode.GetInputElement().value = cellInfo.value;
                }

                if (e.focusedColumn.fieldName === "UOMReq") {
                    d1uomreq.GetInputElement().value = cellInfo.value;
                }



                if (e.focusedColumn.fieldName === "CustomerCode") {


                    //console.log(" Customer objName: " + PutObj + "col: " + PutColName + " idx:" + PutValueIndex );

                    d2customer.GetInputElement().value = cellInfo.value;

                }


                if (e.focusedColumn.fieldName === "SCustomer") {
                    d3customer.GetInputElement().value = cellInfo.value;
                }


                if (e.focusedColumn.fieldName === "ItemCode2") { //Check the column name
                    d2itemcode.GetInputElement().value = cellInfo.value; //Gets the column value
                }

                if (e.focusedColumn.fieldName === "SItemCode") { //Check the column name
                    d3itemcode.GetInputElement().value = cellInfo.value; //Gets the column value
                }

                if (e.focusedColumn.fieldName === "UOMreq2") { //Check the column name
                    d2uomreq2.GetInputElement().value = cellInfo.value; //Gets the column value
                }

                if (e.focusedColumn.fieldName === "UOMreq3") { //Check the column name
                    d3uomreq3.GetInputElement().value = cellInfo.value; //Gets the column value
                }

                if (e.focusedColumn.fieldName === "UOMrr2") { //Check the column name
                    d2uomrr2.GetInputElement().value = cellInfo.value; //Gets the column value
                }

                if (e.focusedColumn.fieldName === "UOMrr3") { //Check the column name
                    d3uomrr3.GetInputElement().value = cellInfo.value; //Gets the column value
                }

                if (e.focusedColumn.fieldName === "RefScrapCode") { //Check the column name
                    d3refcode.GetInputElement().value = cellInfo.value; //Gets the column value
                }




                //if (e.focusedColumn.fieldName === "Field3") {
                //    console.log("start grid : " + s.name);

                //    if (s.name === "cp_frmlayout1_gv1") {
                //        console.log("start gv1 field3 > " + cellInfo.value);
                //    }
                //    else {
                //        console.log("start other field 3 ");
                //    }

                //}

            }


        }

        function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup

            //console.log("END col: " + PutColName + " idx:" + PutValueIndex );


            //emc888
            autocalculate();

            var cellInfo = e.rowValues[currentColumn.index];

            console.log("GRID END col: " + PutColName + " CellValue " + cellInfo.text);


            if (currentColumn.fieldName === "ItemCode") {
                cellInfo.value = gl.GetValue();
                cellInfo.text = gl.GetText();
                valchange = true;
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
            if (currentColumn.fieldName === "UnitBase") {
                cellInfo.value = gl5.GetValue();
                cellInfo.text = gl5.GetText();
               
            }


            if (currentColumn.fieldName === "Unit") {
                cellInfo.value = glUnit.GetValue();
                cellInfo.text = glUnit.GetText();

            }
            if (currentColumn.fieldName === "ServiceType") {
                cellInfo.value = glService.GetValue();
                cellInfo.text = glService.GetText();
            }

            if (currentColumn.fieldName === "RefSpiCode") {
                cellInfo.value = glrefSPcode.GetValue();
                cellInfo.text = glrefSPcode.GetText();
            }

            if (currentColumn.fieldName === "WarehouseCode") {
                cellInfo.value = d1wh.GetValue();
                cellInfo.text = d1wh.GetText();
            }

            if (currentColumn.fieldName === "RefRawMatCode") {
                cellInfo.value = d1refcode.GetValue();
                cellInfo.text = d1refcode.GetText();
            }

            if (currentColumn.fieldName === "UOMReq") {
                cellInfo.value = d1uomreq.GetValue();
                cellInfo.text = d1uomreq.GetText();
            }


            if (currentColumn.fieldName === "CustomerCode") {
                cellInfo.value = d2customer.GetValue();
                cellInfo.text = d2customer.GetText();
            }

            if (currentColumn.fieldName === "SCustomer") {
                cellInfo.value = d3customer.GetValue();
                cellInfo.text = d3customer.GetText();
            }

            if (currentColumn.fieldName === "ItemCode2") {
                cellInfo.value = d2itemcode.GetValue();
                cellInfo.text = d2itemcode.GetText();
            }

            if (currentColumn.fieldName === "SItemCode") {
                cellInfo.value = d3itemcode.GetValue();
                cellInfo.text = d3itemcode.GetText();
            }

            if (currentColumn.fieldName === "UOMreq2") {
                cellInfo.value = d2uomreq2.GetValue();
                cellInfo.text = d2uomreq2.GetText();
            }

            if (currentColumn.fieldName === "UOMreq3") {
                cellInfo.value = d3uomreq3.GetValue();
                cellInfo.text = d3uomreq3.GetText();
            }

            if (currentColumn.fieldName === "UOMrr2") {
                cellInfo.value = d2uomrr2.GetValue();
                cellInfo.text = d2uomrr2.GetText();
            }

            if (currentColumn.fieldName === "UOMrr3") {
                cellInfo.value = d3uomrr3.GetValue();
                cellInfo.text = d3uomrr3.GetText();
            }

            if (currentColumn.fieldName === "RefScrapCode") {
                cellInfo.value = d3refcode.GetValue();
                cellInfo.text = d3refcode.GetText();
            }

            //emc888
            //if (currentColumn.fieldName === "Field3") {

            //    if (s.name === "cp_frmlayout1_gv1") {
            //        console.log("gv1 field3 " + glpDField3.GetText() + " data " + glpDField3.GetValue());

            //        cellInfo.value =  glpDField3.GetValue();
            //        cellInfo.text = glpDField3.GetText();

            //    }
            //    else {
            //        console.log("other field 3 ");
            //    }

            //}

            //console.log("grid name : " + s.name+ ' e : '+e.name);


            console.log("GRID 2 END  CellValue " + cellInfo.text);

          

        }
        // Unit valuechanged event
        function UpdateUnit(values) {
            gv1.batchEditApi.EndEdit();
            gv1.batchEditApi.SetCellValue(index, "UnitBase", values);
        }


        var identifier;
        var val_ALL;
        function GridEndChoice(s, e) {

            identifier = s.GetGridView().cp_identifier;
            val_ALL = s.GetGridView().cp_codes;

            console.log(identifier)
            console.log(val_ALL + " ito sila!")
            if (identifier == "ItemCode") {
                delete (s.GetGridView().cp_identifier);
                if (s.GetGridView().cp_valch) {
                    delete (s.GetGridView().cp_valch);
                    for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                        //console.log('anoto')
                        var column = gv1.GetColumn(i);
                        if (column.visible == false || column.fieldName == undefined)
                            continue;
                        ProcessCells_ItemCode(0, e.visibleIndex, column, gv1);
                    }
                }
                gv1.batchEditApi.EndEdit();
            }
        }


        function ProcessCells_ItemCode(selectedIndex, e, column, s) {
            var temp_ALL;
            if (temp_ALL == null) {
                temp_ALL = ";;;;;";
            }
            temp_ALL = val_ALL.split(';');
            if (temp_ALL[0] == null) {
                temp_ALL[0] = "";
            }
            if (temp_ALL[1] == null) {
                temp_ALL[1] = "";
            }
            if (temp_ALL[2] == null) {
                temp_ALL[2] = "";
            }
            if (temp_ALL[3] == null) {
                temp_ALL[3] = "";
            }
            if (temp_ALL[4] == null) {
                temp_ALL[4] = "";
            }
            if (selectedIndex == 0) {
                if (column.fieldName == "ColorCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[0]);
                }
                if (column.fieldName == "ClassCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[1]);
                }
                if (column.fieldName == "SizeCode") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[2]);
                }
                if (column.fieldName == "UnitBase") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[3]);
                }
                if (column.fieldName == "FullDesc") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[4]);
                }
            }
            loader.Hide();
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
                //gv1.batchEditApi.EndEdit();
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }

        function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
            gv1.batchEditApi.EndEdit();
            gvService.batchEditApi.EndEdit();
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

            //if (e.buttonID == "Details") {
            //    var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
            //    var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
            //    var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
            //    var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
            //    var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
            //    var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
            //    var Warehouse = "";
            //    var BizPartnerCode = clBizPartnerCode.GetText();
            //    factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
            //        + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&Warehouse=' + Warehouse);

            //    factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);


            //}



            if (e.buttonID == "Details") {
                var RefRawMatCode = s.batchEditApi.GetCellValue(e.visibleIndex, "RefRawMatCode");
                var WarehouseCode = s.batchEditApi.GetCellValue(e.visibleIndex, "WarehouseCode");
                var ItemCode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
                var FullDesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
                var RawMatType = s.batchEditApi.GetCellValue(e.visibleIndex, "RawMatType");
                var RequestQty = s.batchEditApi.GetCellValue(e.visibleIndex, "RequestQty");
                var UOMReq = s.batchEditApi.GetCellValue(e.visibleIndex, "UOMReq");
                var RRQty = s.batchEditApi.GetCellValue(e.visibleIndex, "RRQty");
                var UnitBase = s.batchEditApi.GetCellValue(e.visibleIndex, "UnitBase");
                var OrderQty = s.batchEditApi.GetCellValue(e.visibleIndex, "OrderQty");
                var IsAllowPartial = s.batchEditApi.GetCellValue(e.visibleIndex, "IsAllowPartial");
                var ExpDate = s.batchEditApi.GetCellValue(e.visibleIndex, "ExpDate");
                var ColorCode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
                var ClassCode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
                var SizeCode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
           

          

                var BizPartnerCode = clBizPartnerCode.GetText();
                factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + ItemCode
                    + '&colorcode=' + 'N/A' + '&classcode=' + 'N/A' + '&sizecode=' + 'N/A' + '&Warehouse=' + WarehouseCode);
                console.log('../FactBox/fbItem.aspx?itemcode=' + ItemCode
                    + '&colorcode=' + 'N/A' + '&classcode=' + 'N/A' + '&sizecode=' + 'N/A' + '&Warehouse=' + WarehouseCode);
                factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
                conso


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

        function negativecheck(s, e) {
            var requestqty = CINRequestQty.GetValue();
            requestqty = requestqty <= 0 ? 0 : requestqty;

            CINRequestQty.SetText('' + requestqty);

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
            gvService.SetWidth(width - 120);
        }


        function GetJODetails(s, e) {
            var generate = confirm("Generate multiple item using selected Job Order Number?");
            if (generate) {
                CINJODetails.Show();
                CINgvJODetails.CancelEdit();
                cp.PerformCallback('GetJODetails');
                e.processOnServer = false;
            }
            //CINMultiplePR.SetEnabled(true);
        }

        function POPUPGetJODetail(s, e) {
            var generate = confirm("Generate multiple item using selected Job Order Number?");
            if (generate) {
                CINJODetails.Hide();
                var str = CINgvJODetails.GetSelectedKeysOnPage();
                console.log(str);
                //for(var i = 0; i < str.length; i++)
                //{
                //    var str2 = str[i].split("|");
                //    gv1.AddNewRow();
                //    getCol(gv1, curr, str2);
                //}
                if (str != null) {
                    for (var i = 0; i < str.length; i++) {
                        var str2 = str[i].split("|");
                        console.log(str.length);
                        gv1.AddNewRow();
                        getCol(gv1, curr, str2);
                    }
                }
            }
            //CINMultiplePR.SetEnabled(true);
        }

        function getCol(ss, ee, item) {
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                var column = gv1.GetColumn(i);
                if (column.visible == false || column.fieldName == undefined)
                    continue;
                Bindgrid(item, ee, column, gv1);
            }
        }

        function Bindgrid(item, e, column, s) {//Clone function :D
            if (column.fieldName == "ItemCode") {
                console.log(item[1] + 'pasok');
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
            if (column.fieldName == "RequestQty") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, Math.abs(item[5]));
            }
            if (column.fieldName == "UnitBase") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[6]);
            }
        }

        var PutDetailIdx = 0;
        var PutObj;
        var PutGridUse;
        var PutColName;
        var PutValueIndex;

        //emc909
        function PutGridCol_OLD(selectedValues) {

            console.log("PUT func col: " + PutColName);

            //console.log("objName: " + PutObj.name + "col: " + PutColName + " idx:" + PutValueIndex + " value: " + selectedValues[0]);

            //var idx1 = 0
            //for (idx1 = 0; idx1 < PutColName.length; idx1++) {
            //    console.log("idx " + idx1 + " ColName " + PutColName[idx1] + " idx: " + PutValueIndex[idx1] + " value: " + selectedValues[PutValueIndex[idx1]]);

            //    PutGridUse.batchEditApi.EndEdit();
            //    PutGridUse.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);
            //}

            PutGridUse.batchEditApi.EndEdit();

            if (PutColName.length === 1) {
                PutGridUse.batchEditApi.SetCellValue(index, PutColName[0], selectedValues[PutValueIndex[0]]);
            }
            else if (PutColName.length === 2) {
                PutGridUse.batchEditApi.SetCellValue(index, PutColName[0], selectedValues[PutValueIndex[0]]);
                PutGridUse.batchEditApi.SetCellValue(index, PutColName[1], selectedValues[PutValueIndex[1]]);

            }


        }

        function PutGridCol(selectedValues) {

            //console.log("PutDetailIdx : " + PutDetailIdx);

            var idx1 = 0
            switch (PutDetailIdx) {
                case 1:
                    //gv1 Raw Material detail
                    gv1.batchEditApi.EndEdit();
                    for (idx1 = 0; idx1 < PutColName.length; idx1++) {
                        //console.log("idx " + idx1 + " ColName " + PutColName[idx1] + " idx: " + PutValueIndex[idx1] + " value: " + selectedValues[PutValueIndex[idx1]]);
                        gv1.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);
                    }

                    break;
                case 2:
                    //gvservice Spices Detail
                    gvService.batchEditApi.EndEdit();
                    for (idx1 = 0; idx1 < PutColName.length; idx1++) {
                        //console.log("idx " + idx1 + " ColName " + PutColName[idx1] + " idx: " + PutValueIndex[idx1] + " value: " + selectedValues[PutValueIndex[idx1]]);
                        gvService.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);
                    }

                    break;
                case 3:
                    //gvscrap Scrap Detail
                    gvScrap.batchEditApi.EndEdit();
                    for (idx1 = 0; idx1 < PutColName.length; idx1++) {
                        //console.log("idx " + idx1 + " ColName " + PutColName[idx1] + " idx: " + PutValueIndex[idx1] + " value: " + selectedValues[PutValueIndex[idx1]]);
                        gvScrap.batchEditApi.SetCellValue(index, PutColName[idx1], selectedValues[PutValueIndex[idx1]]);
                    }

                    break;

            }
            //PutGridUse.batchEditApi.SetCellValue(index, PutColName, selectedValues[PutValueIndex]);
            //gvService.batchEditApi.SetCellValue(index, "CustomerCode", selectedValues[0]);
        }


        function PutDesc(selectedValues) {
            gvService.batchEditApi.EndEdit();
            gvService.batchEditApi.SetCellValue(index, "Description", selectedValues[1]);

            //gvService.batchEditApi.SetCellValue(index, "RawMatType2", selectedValues[1]);

            //gvService.batchEditApi.SetCellValue(index, "IsAllowProgressBilling", selectedValues[2]);

            //var grid = d3itemcode.GetGridView();
            //d3itemcode.GetGridView().g
            //grid.GetRowValues(grid.GetFocusedRowIndex(), 'ItemCode;FullDesc', PutDesc3);

        }



        function PutDesc3(selectedValues) {
            gvScrap.batchEditApi.EndEdit();
            gvScrap.batchEditApi.SetCellValue(index, "ItemDesc", selectedValues[1]);
            //gvService.batchEditApi.SetCellValue(index, "IsAllowProgressBilling", selectedValues[2]);
        }


        var transtype = getParameterByName('transtype');
        function onload() {
            setTimeout(function () {
                var BizPartnerCode = clBizPartnerCode.GetText();
                factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
                fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + txtDocnumber.GetText() + '&transtype=' + transtype);
            }, 500);
        }

        function Generate(s, e) {

            var generate = confirm("Are you sure you want to generate detail ?");


            if (generate) {
                generateAction = 1;

                cp.PerformCallback('Generate');
                e.processOnServer = false;

                //gv1.AddNewRow();
            }
            else {
                alert("Abort Generation !");
            }
            //if (generate) {
            //    cp.PerformCallback('Generate');
            //    e.processOnServer = false;
            //}

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
                    <dx:ASPxLabel runat="server" ID="FormTitle" Text="Receiving Report" Font-Bold="true" ForeColor="White" Font-Size="X-Large"></dx:ASPxLabel>
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
        <dx:ASPxPopupControl ID="notes" runat="server" AllowDragging="True" AllowResize="True" ClientInstanceName="fbnotes" CloseAction="None"
            EnableViewState="False" HeaderText="Notes" Height="207px" Width="245px" PopupHorizontalOffset="1085" PopupVerticalOffset="470"
            ShowCloseButton="False" Collapsed="true" ShowCollapseButton="True" ShowOnPageLoad="True" ShowPinButton="True" ShowShadow="True">
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
        <dx:ASPxCallbackPanel ID="cp" runat="server" Width="806px" Height="910px" ClientInstanceName="cp" OnCallback="cp_Callback">
            <ClientSideEvents EndCallback="gridView_EndCallback"></ClientSideEvents>
            <PanelCollection>
                <dx:PanelContent runat="server" SupportsDisabledAttribute="True">
                    <dx:ASPxPopupControl ID="JODetails" Theme="Aqua" runat="server" AllowDragging="True" ClientInstanceName="CINJODetails" CloseAction="CloseButton" CloseOnEscape="true"
                        EnableViewState="False" HeaderImage-Height="10px" HeaderText="" Height="400px" ShowHeader="true" Width="950px" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                        ShowCloseButton="true" ShowOnPageLoad="false" ShowShadow="True" Modal="true" ContentStyle-HorizontalAlign="Center">

                        <HeaderImage Height="10px"></HeaderImage>

                        <ContentStyle HorizontalAlign="Center"></ContentStyle>

                        <ContentCollection>
                            <dx:PopupControlContentControl runat="server">
                                <dx:ASPxGridView ID="gvJODetails" runat="server" AutoGenerateColumns="False" Width="900px" OnInit="gvJODetails_Init"
                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="CINgvJODetails"
                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" OnCustomButtonInitialize="gv1_CustomButtonInitialize">
                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm"
                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                    <SettingsPager Mode="ShowAllRecords" />
                                    <SettingsEditing Mode="Batch" />
                                    <Settings VerticalScrollableHeight="250" VerticalScrollBarMode="Auto" ShowStatusBar="Hidden" />
                                    <SettingsBehavior AllowSelectSingleRowOnly="false" />

                                    <Columns>
                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" ButtonType="Image" Width="50px" SelectAllCheckboxMode="Page">
                                        </dx:GridViewCommandColumn>
                                        <dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumber" Name="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1" Width="0px">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Item" FieldName="ItemCode" Name="ItemCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2" Width="200">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Color" FieldName="ColorCode" Name="ColorCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3" Width="150">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Class" FieldName="ClassCode" Name="ClassCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="4" Width="150">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="Size" FieldName="SizeCode" Name="SizeCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="5" Width="150">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataSpinEditColumn Caption="RequestQty" FieldName="RequestQty" Name="RequestQty" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="6" PropertiesSpinEdit-DisplayFormatString="{0:#,0.0000;(#,0.0000);}" PropertiesSpinEdit-AllowMouseWheel="False">
                                            <PropertiesSpinEdit SpinButtons-ShowIncrementButtons="False">
                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                            </PropertiesSpinEdit>
                                        </dx:GridViewDataSpinEditColumn>
                                        <dx:GridViewDataTextColumn Caption="UnitBase" FieldName="UnitBase" Name="UnitBase" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="7" Width="0">
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                </dx:ASPxGridView>
                                <dx:ASPxButton ID="btn" ClientInstanceName="POPUPGetJODetailbtn" runat="server" Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" OnLoad="ButtonLoad" ClientVisible="true" Text="Get JO Details" Theme="MetropolisBlue">
                                    <ClientSideEvents Click="POPUPGetJODetail" />
                                </dx:ASPxButton>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>


                    <dx:ASPxFormLayout ID="frmlayout1" runat="server" Height="565px" Width="850px" Style="margin-left: -3px">
                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                        <Items>

                            <%--<!--#region Region Header --> --%>
                            <%-- <!--#endregion --> --%>

                            <%--<!--#region Region Details --> --%>

                            <%-- <!--#endregion --> --%>
                            <dx:TabbedLayoutGroup>
                                <Items>
                                    <dx:LayoutGroup Caption="General">
                                        <Items>

                                            <dx:LayoutGroup Caption="Information" ColCount="2" RowSpan="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="Document Number" Name="DocNumber">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDocnumber" runat="server" ClientInstanceName="txtDocnumber" ReadOnly="true" Width="170px">
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
                                                    <dx:LayoutItem Caption="Document Date" Name="DocDate" RequiredMarkDisplayMode="Required">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtDocDate" runat="server" ClientInstanceName="CINDocDate" Width="170px">
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

                                                    <dx:LayoutItem Caption="Year" Name="Year" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtYear" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="WorkWeek" Name="WorkWeek" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtWorkWeek" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Day No" Name="DayNo" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtDayNo" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Req Dept. Company:" Name="ReqDeptComp" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtReqDept" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Warehouse Code" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="aglWarehouseCode" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <%--  <dx:LayoutItem Caption="Warehouse Code" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="aglWarehouseCode" ClientInstanceName="aglWarehouseCode" runat="server" DataSourceID="sdsWarehouse" KeyFieldName="WarehouseCode" TextFormatString="{0}" Width="170px">
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
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="WarehouseCode" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>--%>


                                                    <dx:LayoutItem Caption="Customer" Name="CustomerCode">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glCustomerCode" runat="server" ClientInstanceName="clBizPartnerCode" DataSourceID="CustomerCodelookup" KeyFieldName="BizPartnerCode" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>

                                                                     <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('RRref');}"/>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                    <dx:LayoutItem Caption="Consignee" Name="Consignee" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtConsignee" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Consignee Address " Name="ConsigneeAddress" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtConsigneeaddress" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Required Loading Time:" Name="RequiredLoadingTime" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtReqloadtime" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Type of Shipment:" Name="TypeofShipment" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtTypeshipment" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Target Delivery Date" Name="TargetDate" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxDateEdit ID="dtTargetDate" runat="server" ClientInstanceName="CINTargetDate" Width="170px">
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


                                                    <dx:LayoutItem Caption="Stock Number" Name="StockNumber" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="ASPxGridLookup1" runat="server" ClientInstanceName="CINStockNumber" DataSourceID="StockNumberLookup"
                                                                    KeyFieldName="ItemCode" TextFormatString="{0}" Width="170px" OnInit="glStockNumber_Init">
                                                                    <ClientSideEvents DropDown="function(){CINStockNumber.GetGridView().PerformCallback();}" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ShortDesc" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Cost Center" Name="CostCenter" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glCostCenter" runat="server" DataSourceID="CostCenterlookup" KeyFieldName="CostCenterCode" TextFormatString="{0}" Width="170px">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="CostCenterCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>



                                                    <dx:LayoutItem Caption="OCN Request No.: " Name="OCNReqNo" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtOCNreq" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>



                                                    <dx:LayoutItem Caption="DR DocNumber" Name="PODocNumber">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtPODocNumber" runat="server" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Allow Partial" Name="IsPartial" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsPartial" runat="server" CheckState="Unchecked">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Status" Name="Status" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtStatus" runat="server" ReadOnly="True" Width="170px">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="Printed" Name="IsPrinted" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsPrinted" runat="server" CheckState="Unchecked" ReadOnly="True">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                    <dx:LayoutItem Caption="Total Qty">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtTotalQty" runat="server" Width="170px" ReadOnly="true" DisplayFormatString="{0:#,0.0000;(#,0.0000);}" ClientInstanceName="txtTotalQty">
                                                                    <ClientSideEvents ValueChanged="autocalculate" />
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                    <dx:LayoutItem Caption="Remarks" Name="Remarks">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxMemo ID="memoRemarks" runat="server" Width="170px" Height="71px">
                                                                </dx:ASPxMemo>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                    <dx:LayoutItem Caption="Reference Type">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                                <dx:ASPxComboBox ID="hreftype" runat="server" Width="170px" ClientInstanceName="hreftype">
                                                                    <Items>
                                                                        <dx:ListEditItem Text="RAW-MAT" Value="RM" />
                                                                        <dx:ListEditItem Text="SPICES" Value="SP" />
                                                                        <dx:ListEditItem Text="SCRAP" Value="SC" />

                                                                    </Items>

                                                                    <ClientSideEvents ValueChanged="function (s, e){ cp.PerformCallback('RRref');  e.processOnServer = false; loader.Hide();}" />
                                                                </dx:ASPxComboBox>

                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                    <dx:EmptyLayoutItem></dx:EmptyLayoutItem>


                                                    <dx:LayoutItem Caption="Reference Doc" Name="RRrefDoc2">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="hrrrefdoc2" runat="server" ClientInstanceName="hrrrefdoc2" DataSourceID="sdsRRref" KeyFieldName="DocNumber" TextFormatString="{0}" Width="170px" OnInit="hrrrefdoc2init">
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                       
                                                                    </Columns>

                                                           
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                    <dx:EmptyLayoutItem></dx:EmptyLayoutItem>

                                                    <dx:LayoutItem Caption="" Name="Genereatebtn">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxButton ID="Generatebtn" ClientInstanceName="CINGenerate" runat="server" Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" OnLoad="Generate_Btn"
                                                                    ClientVisible="true" Text="Generate" Theme="MetropolisBlue">
                                                                    <ClientSideEvents Click="Generate" />
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>





                                                    <dx:LayoutItem Caption="Stock Number" Name="StockNumber" ClientVisible="false">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glStockNumber" runat="server" ClientInstanceName="CINStockNumber" DataSourceID="StockNumberLookup"
                                                                    KeyFieldName="ItemCode" TextFormatString="{0}" Width="170px" OnInit="glStockNumber_Init">
                                                                    <ClientSideEvents DropDown="function(){CINStockNumber.GetGridView().PerformCallback();}" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True" />
                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ShortDesc" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                </Items>
                                            </dx:LayoutGroup>

                                            <dx:LayoutGroup Caption="Job Order" ColCount="2" ClientVisible="false">
                                                <Items>
                                                    <dx:LayoutItem Caption="JO Number:">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridLookup ID="glJONumber" runat="server" Width="170px" DataSourceID="JobOrderNumberLookup" AutoGenerateColumns="False" KeyFieldName="DocNumber" SelectionMode="Multiple" TextFormatString="{0}"
                                                                    ClientInstanceName="CINJONumber" OnInit="glJONumber_Init">
                                                                    <ClientSideEvents DropDown="function(){CINJONumber.GetGridView().PerformCallback();}" />
                                                                    <GridViewProperties>
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                        <Settings ColumnMinWidth="50" ShowFilterRow="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowInCustomizationForm="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="10%">
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn Caption="JO Number" FieldName="DocNumber" ShowInCustomizationForm="True" VisibleIndex="1" Width="90%"
                                                                            Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                </dx:ASPxGridLookup>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                    <dx:LayoutItem Caption="" Name="GetJODetailsbtn">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxButton ID="GetJODetailsbtn" ClientInstanceName="CINGetJODetailsbtn" runat="server" Width="170px" ValidateInvisibleEditors="false" CausesValidation="false" UseSubmitBehavior="false" AutoPostBack="False" OnLoad="ButtonLoad" ClientVisible="true" Text="Get JO Details" Theme="MetropolisBlue">
                                                                    <ClientSideEvents Click="GetJODetails" />
                                                                </dx:ASPxButton>
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
                                                        <dx:ASPxTextBox ID="txtHField1" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 2:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField6" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 3:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField2" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 4:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField7" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 5:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField3" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 6:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField8" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 7:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField4" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 8:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField9" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Field 9:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtHField5" runat="server">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>
                                    <dx:LayoutGroup Name="Audit" Caption="Audit Trail" ColSpan="2" ColCount="2">
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
                                            <dx:LayoutItem Caption="Approved By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtApprovedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Approved Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtApprovedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cancelled Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtCancelledDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--<dx:LayoutItem Caption="Manual Closed By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtForceClosedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Manual Closed Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtForceClosedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>--%>


                                            <dx:LayoutItem Caption="Submitted By:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSubmittedBy" runat="server" Width="170px" ColCount="1" ReadOnly="True">
                                                        </dx:ASPxTextBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Submitted Date:">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxTextBox ID="txtSubmittedDate" runat="server" Width="170px" ColCount="1" ReadOnly="True">
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
                                                                <dx:ASPxGridView ID="gvRef" runat="server" AutoGenerateColumns="False" KeyFieldName="RTransType;REFDocNumber;TransType;DocNumber" Width="860px" ClientInstanceName="gvRef" OnCommandButtonInitialize="gv_CommandButtonInitialize" SettingsBehavior-AllowSort="False">
                                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" CustomButtonClick="OnCustomClick" Init="OnInitTrans" />

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
                                                                        <dx:GridViewDataTextColumn Caption="Reference DocNumber" FieldName="REFDocNumber" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="True">
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


                                                    <dx:LayoutItem Caption="Temp Data" ClientVisible="true">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxGridView ID="gv2" runat="server" ClientInstanceName="gv2" AutoGenerateColumns="true" BatchEditStartEditing="OnStartEditing">
                                                                    <SettingsEditing Mode="Batch" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
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


                            <dx:LayoutGroup Caption="Raw Material Detail" Name="PRdetail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gv1" runat="server" AutoGenerateColumns="False" Width="1500px"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gv1" OnInitNewRow="gv1_InitNewRow"
                                                    OnRowValidating="grid_RowValidating" OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber" SettingsBehavior-AllowSort="False"
                                                    Settings-ShowStatusBar="Hidden">
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager Mode="ShowAllRecords" />
                                                    <SettingsEditing Mode="Batch" />


                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="200" ShowFooter="True" />
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

                                                    <Columns>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" Width="0px">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn Caption="LineNumber" FieldName="LineNumber" Name="LineNumber" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="2">
                                                        </dx:GridViewDataTextColumn>

                                                        <%--                                                        <dx:GridViewDataTextColumn FieldName="RefRawMatCode" VisibleIndex="2" Width="150px" Caption="Ref RawMat Code">
                                                        </dx:GridViewDataTextColumn>--%>

                                                        <dx:GridViewDataTextColumn FieldName="RefRawMatCode" Caption="Ref. RawMat" VisibleIndex="2" Width="100px" Name="d1refcode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="d1refcode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="sdsReq_RM" KeyFieldName="DocNumber;ItemCode" ClientInstanceName="d1refcode" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="ItemType" Caption="Material Type" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="RequestQty" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="UOM_Rq" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="BatchNo" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="ItemType" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                         <dx:GridViewDataTextColumn FieldName="UOM_Rq" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />

                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        ValueChanged="function(){

                                                                                PutDetailIdx = 1;
                                                                                PutObj = d1refcode;
                                                                                PutGridUse=PutObj.GetGridView(); 
                                                                                PutColName = ['RefRawMatCode','WarehouseCode','ItemCode','FullDesc','RequestQty','UOMReq','UnitBase','Field2','RawMatType','UnitBase'];
                                                                                PutValueIndex = [0,1,2,3,4,5,5,6,7,8];

                                                                                PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'DocNumber;WarehouseCode;ItemCode;FullDesc;RequestQty;UOM_Rq;BatchNo;ItemType;UOM_Rq', PutGridCol);
                                                                                }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="WarehouseCode" Caption="Warehouse" VisibleIndex="2" Width="150px" Name="d1wh">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="d1wh" ClientInstanceName="d1wh" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="sdsWarehouse" KeyFieldName="WarehouseCode" TextFormatString="{0}" Width="150px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="WarehouseCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        ValueChanged="function(){

                                                                                PutDetailIdx = 1;
                                                                                PutObj = d1wh;
                                                                                PutGridUse=PutObj.GetGridView(); 
                                                                                PutColName = ['WarehouseCode'];
                                                                                PutValueIndex = [0];

                                                                                PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'WarehouseCode;WarehouseCode', PutGridCol);
                                                                                }" />

                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <%--emc888--%>

                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="2" Width="150px" Name="glItemCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="MasterfileitemRawMat" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="150px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                         <dx:GridViewDataTextColumn FieldName="MaterialType" ReadOnly="True" VisibleIndex="2" Settings-AutoFilterCondition="Contains" />
                                                                         <dx:GridViewDataTextColumn FieldName="UnitBase" ReadOnly="True" VisibleIndex="3" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        ValueChanged="function(){

                                                                                PutDetailIdx = 1;
                                                                                PutObj = gl;
                                                                                PutGridUse=PutObj.GetGridView(); 
                                                                                PutColName = ['ItemCode','FullDesc','RawMatType','UnitBase'];
                                                                                PutValueIndex = [0,1,2,3];

                                                                                PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'ItemCode;FullDesc;MaterialType;UnitBase', PutGridCol);
                                                                                }" />

                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <%--                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" VisibleIndex="2" Width="150px" Name="glItemCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glItemCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="glItemCode_Init"
                                                                    DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="gl" TextFormatString="{0}" Width="150px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        EndCallback="GridEndChoice" />

                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>--%>

                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" VisibleIndex="2" Width="200px" Caption="Item Description">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="RawMatType" VisibleIndex="3" Width="100px" Caption="Material Type">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" VisibleIndex="3" Width="100px" Caption="ColorCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glColorCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="ColorCode" ClientInstanceName="gl2" TextFormatString="{0}" Width="100px" OnInit="lookup_Init">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ColorCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents EndCallback="GridEndChoice" KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl2.GetGridView().PerformCallback('ColorCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }"
                                                                        CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" VisibleIndex="4" Width="100px" Name="glClassCode" Caption="ClassCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glClassCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    KeyFieldName="ClassCode" ClientInstanceName="gl3" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ClassCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl3.GetGridView().PerformCallback('ClassCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }"
                                                                        CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" VisibleIndex="5" Width="100px" Name="glSizeCode" Caption="SizeCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glSizeCode" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    KeyFieldName="SizeCode" ClientInstanceName="gl4" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SizeCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl4.GetGridView().PerformCallback('SizeCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        }"
                                                                        CloseUp="gridLookup_CloseUp" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataSpinEditColumn FieldName="RequestQty" VisibleIndex="6" Width="100px" Caption="Request Qty">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CINRequestQty" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents NumberChanged="negativecheck" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>


                                                        <dx:GridViewDataTextColumn FieldName="UOMReq" VisibleIndex="6" Width="100px" Caption="UOM-Request">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="d1uomreq" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="UnitCode" DataSourceID="UnitLookup" ClientInstanceName="d1uomreq" TextFormatString="{0}" Width="100px"
                                                                     OnInit="lookup_Init" 
                                                                    >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                   
                                                                 <%--   <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        ValueChanged="function(s,e){
                                                                        console.log(unitc, s.GetValue())
                                                                        if(unitc != s.GetValue())
                                                                        gv1.batchEditApi.EndEdit();
                                                                        }" />--%>
                                                                      <ClientSideEvents CloseUp="gridLookup_CloseUp" Dropdown="function dropdown(s, e){
                                                                         console.log(itemc+'daren');
                                                                d1uomreq.GetGridView().PerformCallback('UnitCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }" KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataSpinEditColumn FieldName="RRQty" VisibleIndex="6" Width="100px" Caption="Received Qty">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="CNRRQty" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents NumberChanged="negativecheck" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>





                                                        <%--<dx:GridViewDataTextColumn FieldName="UnitBase" VisibleIndex="7" Width="100px" Caption="Unit">   
                                                              <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false" OnInit="lookup_Init"
                                                                    KeyFieldName="UnitBase" ClientInstanceName="gl5" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"  />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitBase" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains"  >
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        DropDown="function dropdown(s, e){
                                                                        gl5.GetGridView().PerformCallback('UnitBase' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                        e.processOnServer = false;
                                                                        }" CloseUp="gridLookup_CloseUp"/>
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>--%>


                                                        <dx:GridViewDataTextColumn FieldName="UnitBase" VisibleIndex="7" Width="100px" Caption="UOM-RR">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="UnitCode" DataSourceID="UnitLookup" ClientInstanceName="gl5" TextFormatString="{0}" Width="100px"
                                                                    OnInit="lookup_Init" >
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <%--<ClientSideEvents DropDown="lookup" />
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" ValueChanged="function(s,e){
                                                                        console.log(unitc, s.GetValue())
                                                                        if(unitc != s.GetValue())
                                                                        gv1.batchEditApi.EndEdit();
                                                                        }" />--%>

                                                                    <ClientSideEvents CloseUp="gridLookup_CloseUp" Dropdown="function dropdown(s, e){
                                                                         console.log(itemc+'daren');
                                                                gl5.GetGridView().PerformCallback('UnitCode' + '|' + itemc + '|' + s.GetInputElement().value);
                                                                }"  KeyDown="gridLookup_KeyDown" KeyPress="gridLookup_KeyPress"
                                                                        
                                                                        ValueChanged="function(s,e){ 
                                                                                                    var g = gl5.GetGridView();
                                                                                                    g.GetRowValues(g.GetFocusedRowIndex(), 'UnitCode', UpdateUnit)}" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataSpinEditColumn FieldName="OrderQty" Name="OrderQty" VisibleIndex="8" Width="0" Caption="OrderQty" ReadOnly="true">
                                                            <PropertiesSpinEdit Increment="0" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>

                                                        <dx:GridViewDataCheckColumn FieldName="IsAllowPartial" Name="IsAllowPartial" Caption="Partial Delivery" ShowInCustomizationForm="True" VisibleIndex="9" Width="0">
                                                            <PropertiesCheckEdit ClientInstanceName="chkIsAllowPartial"></PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>

                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField1" Caption="Pallet No" ShowInCustomizationForm="True" VisibleIndex="10">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField2" Caption="Batch No" ShowInCustomizationForm="True" VisibleIndex="11">
                                                        </dx:GridViewDataTextColumn>

                                                        <%--                                                          <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField3" Caption="Expiration Date" ShowInCustomizationForm="True" VisibleIndex="12">
                                                          <PropertiesTextEdit DisplayFormatString="MM/dd/yyyy" >
                                                          </PropertiesTextEdit>
                                                          </dx:GridViewDataTextColumn>--%>

                                                        <%--emc888--%>

                                                        <dx:GridViewDataDateColumn FieldName="ExpDate" Name="d1expdate" Caption="Expiration Date" ShowInCustomizationForm="True" VisibleIndex="12" Width="100px">
                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" EditFormatString="yyyy-MM-dd" ClientInstanceName="d1expdate" AllowNull="true">
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>



                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField4" Caption="App/Form/Size" ShowInCustomizationForm="True" VisibleIndex="13">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField5" Caption="Disposition" ShowInCustomizationForm="True" VisibleIndex="14">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField6" Caption="Spl. Hand. Inst." ShowInCustomizationForm="True" VisibleIndex="15">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField7" Caption="Remarks" ShowInCustomizationForm="True" VisibleIndex="16">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField8" ShowInCustomizationForm="True" VisibleIndex="17" Width="0">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField9" ShowInCustomizationForm="True" VisibleIndex="18" Width="0">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="60px">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="Details">
                                                                    <Image IconID="support_info_16x16"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                    </Columns>

                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>

                            <dx:LayoutGroup Caption="Ingredients and Spices Detail">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gvService" runat="server" AutoGenerateColumns="False" Width="1500px" OnInitNewRow="gvService_InitNewRow"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gvService"
                                                    OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber" SettingsBehavior-AllowSort="False"
                                                    Settings-ShowStatusBar="Hidden">
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager Mode="ShowAllRecords" />
                                                    <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="200" ShowFooter="True" />
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
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="60px">
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" Width="0px">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="true" Width="100px" VisibleIndex="1" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>

                                                        <%--emc888--%>
                                                        <dx:GridViewDataTextColumn FieldName="RefSpiCode" Caption="Ref Spices Code" VisibleIndex="2" Width="100px" Name="glrefSPcode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glrefSPcode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="sdsReq_SP" KeyFieldName="DocNumber;ItemCode" ClientInstanceName="glrefSPcode" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="CustomerCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="RequestQty" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="UOM_Rq" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="BatchNo" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />

                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        ValueChanged="function(){

                                                                                PutDetailIdx = 2;
                                                                                PutObj = glrefSPcode;
                                                                                PutGridUse=PutObj.GetGridView(); 
                                                                                PutColName = ['RefRawMatCode','CustomerCode','ItemCode2','Description','ReqQty2','UOMreq2','UOMrr2','Field2'];
                                                                                PutValueIndex = [0,1,2,3,4,5,5,6];

                                                                                PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'DocNumber;CustomerCode;ItemCode;FullDesc;RequestQty;UOM_Rq;BatchNo', PutGridCol);
                                                                                }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <%--emc909--%>

                                                        <dx:GridViewDataTextColumn FieldName="CustomerCode" Caption="Customer" VisibleIndex="2" Width="100px" Name="d2customer">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="d2customer" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="CustomerCodelookup" KeyFieldName="BizPartnerCode" ClientInstanceName="d2customer" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>

                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        ValueChanged="function(){

                                                                                PutDetailIdx = 2;
                                                                                PutObj = d2customer;
                                                                                PutGridUse=d2customer.GetGridView(); 
                                                                                PutColName = ['CustomerCode'];
                                                                                PutValueIndex = [0,1];

                                                                                PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'BizPartnerCode;BizPartnerCode', PutGridCol);
                                                                                }" />


                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="ItemCode2" Caption="Item" VisibleIndex="2" Width="100" Name="d2itemcode2">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="d2itemcode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="MasterfileitemIngSpi" KeyFieldName="ItemCode" ClientInstanceName="d2itemcode" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="UnitBase" ReadOnly="True" VisibleIndex="2" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        ValueChanged="function(){

                                                                                PutDetailIdx = 2;
                                                                                PutObj = d2itemcode;
                                                                                PutGridUse=PutObj.GetGridView(); 
                                                                                PutColName = ['ItemCode2','Description','UOMrr2'];
                                                                                PutValueIndex = [0,1,2];

                                                                                PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'ItemCode;FullDesc;UnitBase', PutGridCol);
                                                                                }" />

                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn Caption="Service" FieldName="ServiceType" VisibleIndex="2" Width="0" Name="glItemCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glService" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="ServiceLookup" KeyFieldName="ServiceCode" ClientInstanceName="glService" TextFormatString="{0}" Width="150px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ServiceCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="Description" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="IsAllowBilling" ReadOnly="True" VisibleIndex="2" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        ValueChanged="function(){
                                                                                 var grid = glService.GetGridView();
                                                                                grid.GetRowValues(grid.GetFocusedRowIndex(), 'ServiceCode;Description;IsAllowBilling', PutDesc);
                                                                                }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="2" ReadOnly="true">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="RawMatType2" Caption="Material Type" Visible="true" Width="100px" VisibleIndex="3">
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataSpinEditColumn FieldName="ReqQty2" Caption="RequestQty" VisibleIndex="3" Width="100px">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="Qty" MinValue="0.99999" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents NumberChanged="negativecheck" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>


                                                        <dx:GridViewDataTextColumn FieldName="UOMreq2" VisibleIndex="4" Width="100px" Caption="UOM-Req">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="d2uomreq2" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="UnitCode" DataSourceID="UnitLookup" ClientInstanceName="d2uomreq2" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" />
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        ValueChanged="function(s,e){
                                                                        if(unitc2 != s.GetValue())
                                                                        gvService.batchEditApi.EndEdit();
                                                                        }" 
                                                                        />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>



                                                        <dx:GridViewDataSpinEditColumn FieldName="RRQty2" Caption="RR Qty" VisibleIndex="5" Width="100px">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="Qty" MinValue="0.99999" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents NumberChanged="negativecheck" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>

                                                        <dx:GridViewDataTextColumn FieldName="UOMrr2" VisibleIndex="6" Width="100px" Caption="UOM-RR">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="d2uomrr2" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="UnitCode" DataSourceID="UnitLookup" ClientInstanceName="d2uomrr2" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" />
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        ValueChanged="function(s,e){
                                                                        if(unitc2 != s.GetValue())
                                                                        gvService.batchEditApi.EndEdit();
                                                                        }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataCheckColumn FieldName="IsAllowProgressBilling" Caption="Progress Billing" ShowInCustomizationForm="True" VisibleIndex="5" Width="0">
                                                            <PropertiesCheckEdit ClientInstanceName="chkIsAllowProgress">
                                                                <ClientSideEvents CheckedChanged="function(){gvService.batchEditApi.EndEdit()}" />
                                                            </PropertiesCheckEdit>
                                                        </dx:GridViewDataCheckColumn>

                                                        <dx:GridViewDataSpinEditColumn FieldName="ServicePOQty" VisibleIndex="6" Width="0" Caption="ServicePOQty" ReadOnly="true">
                                                            <PropertiesSpinEdit Increment="0" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>

                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField12" Caption="Pallet No" ShowInCustomizationForm="True" VisibleIndex="10">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField22" Caption="Batch No" ShowInCustomizationForm="True" VisibleIndex="11">
                                                        </dx:GridViewDataTextColumn>

                                                        <%-- <dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField32" Caption="Expiration Date" ShowInCustomizationForm="True" VisibleIndex="12">
                                                        </dx:GridViewDataTextColumn>--%>

                                                        <dx:GridViewDataDateColumn FieldName="ExpDate" Name="d2expdate" Caption="Expiration Date" ShowInCustomizationForm="True" VisibleIndex="12" Width="100px" PropertiesDateEdit-AllowNull="true">
                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" ClientInstanceName="d2expdate">
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>


                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField42" Caption="App/Form/Size" ShowInCustomizationForm="True" VisibleIndex="13">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField52" Caption="Disposition" ShowInCustomizationForm="True" VisibleIndex="14">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField62" Caption="Spl. Hand. Inst." ShowInCustomizationForm="True" VisibleIndex="15">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField72" Caption="Remarks" ShowInCustomizationForm="True" VisibleIndex="16">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField82" ShowInCustomizationForm="True" VisibleIndex="17" Width="0">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField92" ShowInCustomizationForm="True" VisibleIndex="18" Width="0">
                                                        </dx:GridViewDataTextColumn>

                                                    </Columns>



                                                </dx:ASPxGridView>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:LayoutGroup>




                            <dx:LayoutGroup Caption="Scrap Details">
                                <Items>
                                    <dx:LayoutItem Caption="">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                <dx:ASPxGridView ID="gvScrap" runat="server" AutoGenerateColumns="False" Width="1500px" OnInitNewRow="gvScrap_InitNewRow"
                                                    OnCommandButtonInitialize="gv_CommandButtonInitialize" ClientInstanceName="gvScrap"
                                                    OnBatchUpdate="gv1_BatchUpdate" KeyFieldName="DocNumber;LineNumber" SettingsBehavior-AllowSort="False"
                                                    Settings-ShowStatusBar="Hidden">
                                                    <ClientSideEvents BatchEditConfirmShowing="OnConfirm" Init="OnInitTrans"
                                                        BatchEditStartEditing="OnStartEditing" BatchEditEndEditing="OnEndEditing" />
                                                    <ClientSideEvents CustomButtonClick="OnCustomClick" />
                                                    <SettingsPager Mode="ShowAllRecords" />
                                                    <SettingsEditing Mode="Batch" />
                                                    <Settings HorizontalScrollBarMode="Visible" VerticalScrollBarMode="Auto" ColumnMinWidth="120" VerticalScrollableHeight="200" ShowFooter="True" />
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
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ButtonType="Image" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" VisibleIndex="1" Width="60px">
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" Visible="true" Width="0px">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="LineNumber" Visible="true" ReadOnly="true" VisibleIndex="1">
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="RefScrapCode" Caption="Ref Spices Code" VisibleIndex="2" Width="100px" Name="glRefScrapCode">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="d3refcode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="sdsReq_SC" KeyFieldName="DocNumber;ItemCode" ClientInstanceName="d3refcode" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="DocNumber" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="CustomerCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="RequestQty" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="UOM_Rq" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="BatchNo" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />

                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        ValueChanged="function(){

                                                                                PutDetailIdx = 3;
                                                                                PutObj = d3refcode;
                                                                                PutGridUse=PutObj.GetGridView(); 
                                                                                PutColName = ['RefScrapCode','SCustomer','SItemCode','ItemDesc','ReqQty3','UOMReq3','UOMrr3','Field2'];
                                                                                PutValueIndex = [0,1,2,3,4,5,5,6];

                                                                                PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'DocNumber;CustomerCode;ItemCode;FullDesc;RequestQty;UOM_Rq;BatchNo', PutGridCol);
                                                                                }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="SCustomer" Caption="Customer" VisibleIndex="2" Width="100px" Name="d3customer">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="d3customer" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="CustomerCodelookup" KeyFieldName="BizPartnerCode" ClientInstanceName="d3customer" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="BizPartnerCode" ReadOnly="True" VisibleIndex="0">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="True" VisibleIndex="1">
                                                                            <Settings AutoFilterCondition="Contains" />
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>



                                                        <%--                                                        <dx:GridViewDataTextColumn FieldName="SItemCode" ShowInCustomizationForm="True" VisibleIndex="4">
                                                        </dx:GridViewDataTextColumn>--%>


                                                        <dx:GridViewDataTextColumn FieldName="SItemCode" Caption="Item" VisibleIndex="2" Width="100" Name="d3itemcode2">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="d3itemcode" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    DataSourceID="Masterfileitem" KeyFieldName="ItemCode" ClientInstanceName="d3itemcode" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True"
                                                                            AllowSelectSingleRowOnly="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ItemCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains" />
                                                                        <dx:GridViewDataTextColumn FieldName="FullDesc" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                         <dx:GridViewDataTextColumn FieldName="UnitBase" ReadOnly="True" VisibleIndex="1" Settings-AutoFilterCondition="Contains" />
                                                                    </Columns>
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown" DropDown="lookup"
                                                                        ValueChanged="function(){

                                                                                PutDetailIdx = 3;
                                                                                PutObj = d3itemcode;
                                                                                PutGridUse=PutObj.GetGridView(); 
                                                                                PutColName = ['SItemCode','ItemDesc','UOMrr3'];
                                                                                PutValueIndex = [0,1];

                                                                                PutGridUse.GetRowValues(PutGridUse.GetFocusedRowIndex(), 'ItemCode;FullDesc;UnitBase', PutGridCol);
                                                                                }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>



                                                        <dx:GridViewDataTextColumn FieldName="ItemDesc" ShowInCustomizationForm="True" VisibleIndex="5">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataTextColumn FieldName="RawMatType3" Caption="Material Type" ShowInCustomizationForm="True" VisibleIndex="6">
                                                        </dx:GridViewDataTextColumn>

                                                        <dx:GridViewDataSpinEditColumn FieldName="ReqQty3" Caption="Request Qty" VisibleIndex="7" Width="100px">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="Qty" MinValue="0.99999" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents NumberChanged="negativecheck" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>

                                                        <dx:GridViewDataTextColumn FieldName="UOMreq3" Caption="UOM-Req" VisibleIndex="8" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="d3uomreq3" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="UnitCode" DataSourceID="UnitLookup" ClientInstanceName="d3uomreq3" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" />
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        ValueChanged="function(s,e){
                                                                        if(unitc2 != s.GetValue())
                                                                        gvService.batchEditApi.EndEdit();
                                                                        }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataSpinEditColumn FieldName="RRQty3" Caption="RR Qty" VisibleIndex="9" Width="100px">
                                                            <PropertiesSpinEdit Increment="0" ClientInstanceName="Qty" MinValue="0.99999" MaxValue="999999999" SpinButtons-ShowIncrementButtons="false" NullDisplayText="0" ConvertEmptyStringToNull="False" NullText="0" DisplayFormatString="{0:#,0.0000;(#,0.0000);}">
                                                                <SpinButtons ShowIncrementButtons="False"></SpinButtons>
                                                                <ClientSideEvents NumberChanged="negativecheck" />
                                                            </PropertiesSpinEdit>
                                                        </dx:GridViewDataSpinEditColumn>

                                                        <dx:GridViewDataTextColumn FieldName="UOMrr3" Caption="UOM-RR" VisibleIndex="10" Width="100px">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="d3uomrr3" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="UnitCode" DataSourceID="UnitLookup" ClientInstanceName="d3uomrr3" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" />
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        ValueChanged="function(s,e){
                                                                        if(unitc2 != s.GetValue())
                                                                        gvService.batchEditApi.EndEdit();
                                                                        }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>


                                                        <dx:GridViewDataTextColumn FieldName="UOM" VisibleIndex="7" Width="0">
                                                            <EditItemTemplate>
                                                                <dx:ASPxGridLookup ID="glUnitBase2" runat="server" AutoGenerateColumns="False" AutoPostBack="false"
                                                                    KeyFieldName="UnitCode" DataSourceID="UnitLookup" ClientInstanceName="glUnit2" TextFormatString="{0}" Width="100px">
                                                                    <GridViewProperties Settings-ShowFilterRow="true">
                                                                        <SettingsBehavior AllowFocusedRow="True" AllowSelectByRowClick="True" />
                                                                    </GridViewProperties>
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UnitCode" ReadOnly="True" VisibleIndex="0" Settings-AutoFilterCondition="Contains">
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <ClientSideEvents DropDown="lookup" />
                                                                    <ClientSideEvents KeyPress="gridLookup_KeyPress" KeyDown="gridLookup_KeyDown"
                                                                        ValueChanged="function(s,e){
                                                                        if(unitc2 != s.GetValue())
                                                                        gvService.batchEditApi.EndEdit();
                                                                        }" />
                                                                </dx:ASPxGridLookup>
                                                            </EditItemTemplate>
                                                        </dx:GridViewDataTextColumn>




                                                        <%--                                                        <dx:GridViewDataTextColumn FieldName="BatchNumber" Name="gl3BatchNumber" ShowInCustomizationForm="True" VisibleIndex="10">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Step" Name="gl3Step" ShowInCustomizationForm="True" VisibleIndex="11">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="ExpDate" Name="gl3ExpDate" ShowInCustomizationForm="True" VisibleIndex="12">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Appearance" Name="gl3Appearance" ShowInCustomizationForm="True" VisibleIndex="13">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Disposition" Name="gl3Disposition" ShowInCustomizationForm="True" VisibleIndex="14">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="HandInst" Name="gl3HandInst" ShowInCustomizationForm="True" VisibleIndex="15">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="SRemarks" Name="gl3SRemarks" ShowInCustomizationForm="True" VisibleIndex="16">
                                                        </dx:GridViewDataTextColumn>--%>

                                                        <dx:GridViewDataTextColumn FieldName="Field1" Name="glpDField13" Caption="Pallet No" ShowInCustomizationForm="True" VisibleIndex="10">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field2" Name="glpDField23" Caption="Batch No" ShowInCustomizationForm="True" VisibleIndex="11">
                                                        </dx:GridViewDataTextColumn>

                                                        <%--<dx:GridViewDataTextColumn FieldName="Field3" Name="glpDField33" Caption="Expiration Date" ShowInCustomizationForm="True" VisibleIndex="12">
                                                        </dx:GridViewDataTextColumn>--%>

                                                        <dx:GridViewDataDateColumn FieldName="ExpDate" Name="d3expdate" Caption="Expiration Date" ShowInCustomizationForm="True" VisibleIndex="12" Width="100px" PropertiesDateEdit-AllowNull="true">
                                                            <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy" ClientInstanceName="d3expdate">
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>

                                                        <dx:GridViewDataTextColumn FieldName="Field4" Name="glpDField43" Caption="App/Form/Size" ShowInCustomizationForm="True" VisibleIndex="13">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field5" Name="glpDField53" Caption="Disposition" ShowInCustomizationForm="True" VisibleIndex="14">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field6" Name="glpDField63" Caption="Spl. Hand. Inst." ShowInCustomizationForm="True" VisibleIndex="15">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field7" Name="glpDField73" Caption="Remarks" ShowInCustomizationForm="True" VisibleIndex="16">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field8" Name="glpDField83" ShowInCustomizationForm="True" VisibleIndex="17" Width="0">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="Field9" Name="glpDField93" ShowInCustomizationForm="True" VisibleIndex="18" Width="0">
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

                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>
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

        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel1" runat="server" Text="Calculating..."
            ClientInstanceName="loader" ContainerElementID="gv1" Modal="true">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>

        <dx:ASPxLoadingPanel ID="ASPxLoadingPanel2" runat="server" Text="loading..."
            ClientInstanceName="loader2" ContainerElementID="gv1" Modal="true">
            <LoadingDivStyle Opacity="0"></LoadingDivStyle>
        </dx:ASPxLoadingPanel>
    </form>

    <!--#region Region Datasource-->
    <%--<!--#region Region Header --> --%>
    <asp:ObjectDataSource ID="odsHeader" runat="server" SelectMethod="getdata" TypeName="Entity.RRtoll" DataObjectTypeName="Entity.RRtoll" InsertMethod="InsertData" UpdateMethod="UpdateData">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="" Name="DocNumber" QueryStringField="docnumber" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail" runat="server" SelectMethod="getdetail" TypeName="Entity.RRtoll+RRtollDetail" DataObjectTypeName="Entity.RRtoll+RRtollDetail" DeleteMethod="DeleteRRtollDetail" InsertMethod="AddRRtollDetail" UpdateMethod="UpdateRRtollDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsDetail2" runat="server" SelectMethod="getdetail" TypeName="Entity.RRtoll+RRtollService" DataObjectTypeName="Entity.RRtoll+RRtollService" DeleteMethod="DeleteRRtollDetail" InsertMethod="AddRRtollDetail" UpdateMethod="UpdateRRtollDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsDetail3" runat="server" SelectMethod="getdetail" TypeName="Entity.RRtoll+RRtollScrap" DataObjectTypeName="Entity.RRtoll+RRtollScrap" DeleteMethod="DeleteRRtollDetail" InsertMethod="AddRRtollDetail" UpdateMethod="UpdateRRtollDetail">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsReference" runat="server" SelectMethod="getreftransaction" TypeName="Entity.RRtoll+RefTransaction">
        <SelectParameters>
            <asp:QueryStringParameter Name="DocNumber" QueryStringField="docnumber" Type="String" />
            <asp:SessionParameter Name="Conn" SessionField="ConnString" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="sdsDetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Procurement.RRtollDetail where DocNumber  is null "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsDetail2" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Procurement.RRtollService where DocNumber  is null "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsDetail3" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM  Procurement.RRtollScrap where DocNumber  is null "
        OnInit="Connection_Init"></asp:SqlDataSource>

    <%-- Scrap Code --%>
    <%-- <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ItemCode,FullDesc,UnitBase FROM Masterfile.Item WHERE ISNULL(IsInactive,0)=0 "
        OnInit="Connection_Init"></asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="Masterfileitem" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ItemCode,FullDesc,UnitBase FROM Masterfile.Item WHERE ISNULL(IsInactive,0)=0 AND CHARINDEX(ItemCategoryCode,(SELECT VALUE FROM IT.SystemSettings WHERE Code='ScrapCatRR'))>0"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <%-- Raw Material Item Code --%>
    <%-- <asp:SqlDataSource ID="MasterfileitemRawMat" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ItemCode,FullDesc,ItemType AS MaterialType,UnitBase FROM Masterfile.Item WHERE ISNULL(IsInactive,0)=0 AND ItemCategoryCode not in ('003','100','005') "
        OnInit="Connection_Init"></asp:SqlDataSource>--%>
    <asp:SqlDataSource ID="MasterfileitemRawMat" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ItemCode,FullDesc,ItemType AS MaterialType,UnitBase FROM Masterfile.Item WHERE ISNULL(IsInactive,0)=0 AND CHARINDEX(ItemCategoryCode,(SELECT VALUE FROM IT.SystemSettings WHERE Code='RawMatRR'))>0"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <%-- Ingredients and Spices Item Code --%>
    <%--<asp:SqlDataSource ID="MasterfileitemIngSpi" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ItemCode,FullDesc,ItemType AS MaterialType,UnitBase FROM Masterfile.Item WHERE ISNULL(IsInactive,0)=0 AND ItemCategoryCode in ('005', '006') "
        OnInit="Connection_Init"></asp:SqlDataSource>--%>
     <asp:SqlDataSource ID="MasterfileitemIngSpi" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT ItemCode,FullDesc,MaterialType,UnitBase FROM Masterfile.Item WHERE ISNULL(IsInactive,0)=0 AND CHARINDEX(ItemCategoryCode,(SELECT VALUE FROM IT.SystemSettings WHERE Code='IngrAndSpiceRR'))>0"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>
    <%--<asp:SqlDataSource ID="Masterfileitemdetail" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT B.ItemCode, ColorCode, ClassCode,SizeCode,UnitBase FROM Masterfile.[Item] A INNER JOIN Masterfile.[ItemDetail] B ON A.ItemCode = B.ItemCode where isnull(A.IsInactive,'')=0"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>--%>
    <%------------SQL DataSource------------%>

    <%--Customer Code Look Up--%>
    <asp:SqlDataSource ID="CustomerCodelookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT BizPartnerCode,Name FROM Masterfile.[BPCustomerInfo] WHERE ISNULL([IsInactive],0) = 0 Order By BizPartnerCode"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <%--Cost Center Look Up--%>
    <asp:SqlDataSource ID="CostCenterlookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT CostCenterCode,Description FROM Accounting.[CostCenter] WHERE ISNULL([IsInactive],0) = 0"
        OnInit="Connection_Init"></asp:SqlDataSource>
    <%--Job Order Look Up--%>
    <asp:SqlDataSource ID="JobOrderNumberLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>

    <%--Job Order Details Datasource--%>
    <asp:SqlDataSource ID="JODetailsds" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT * FROM Production.JOBillOfMaterial where DocNumber is null"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <%-- Stock Number Lookup Datasource--%>
    <asp:SqlDataSource ID="StockNumberLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=""
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="ServiceLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="Select ServiceCode,Description,Type,IsVatable,IsAllowBilling from Masterfile.Service where ISNULL(IsInactive, 0)=0
        and Type = 'EXPENSE' and isnull(IsCore,0)=0"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="UnitLookup" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT DISTINCT UnitCode,Description FROM Masterfile.Unit where isnull(IsInactive,0)=0"
        OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsWarehouse" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT WarehouseCode, [Description] FROM Masterfile.[Warehouse] WHERE ISNULL([IsInactive],0) = 0" OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsReq_SP" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" EXEC dbo.sp_RRtollRefData 'SP',' '  " OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsReq_RM" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" EXEC dbo.sp_RRtollRefData 'RM',' '  " OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsReq_SC" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand=" EXEC dbo.sp_RRtollRefData 'SC',' '  " OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsRRref" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="   " OnInit="Connection_Init"></asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsRefdata" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="   " OnInit="Connection_Init"></asp:SqlDataSource>


    <asp:SqlDataSource ID="sdsRM" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.DocNumber FROM Procurement.PurchaseRequest A WHERE ISNULL(A.SubmittedBy,'') != '' AND A.RequestType = 'RM'"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="sdsSP" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.DocNumber FROM Procurement.PurchaseRequest A WHERE ISNULL(A.SubmittedBy,'') != '' AND A.RequestType = 'SP'"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="sdsSC" runat="server" ConnectionString="<%$ ConnectionStrings:GEARS-METSITConnectionString %>" SelectCommand="SELECT A.DocNumber FROM Procurement.PurchaseRequest A WHERE ISNULL(A.SubmittedBy,'') != '' AND A.RequestType = 'SC'"
        OnInit = "Connection_Init">
    </asp:SqlDataSource>


</body>
</html>
