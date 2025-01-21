
var isValid = true;
var counterror = 0;
var isGross = false;

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
//var changedValues = "";
//function OnValueChanged(s, e) {
//    if (gv1.batchEditApi.HasChanges()) {
//        console.log(gv1.batchEditApi.HasChanges() + ' changes')
//        var topRowIndex = gv1.GetTopVisibleIndex();
//        for (var i = topRowIndex; i < topRowIndex + gv1.GetVisibleRowsOnPage() ; i++) {
//            if (gv1.batchEditApi.HasChanges(i)) {
//                for (var j = 0; j < gv1.GetColumnCount() ; j++) {
//                    if (gv1.batchEditApi.HasChanges(i, j)) {
//                        var fieldName = gv1.GetColumn(j).fieldName;
//                        changedValues += "|" + fieldName + ":" + i + "=" + gv1.batchEditApi.GetCellValue(i, j);
//                    }
//                }
//            }
//        }
//    }

//    console.log(changedValues + ' changedValues')
//   // grid.PerformCallback(changedValues);
//}

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

function isNullOrWhiteSpace(str) {
    return (!str || str.length === 0 || /^\s*$/.test(str))
}

function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)
    if (isNullOrWhiteSpace(s.GetText()) || isNullOrWhiteSpace(e.value) || isNullOrWhiteSpace(e.value) || isNullOrWhiteSpace(s.GetValue()) || isNullOrWhiteSpace(s.GetValue())) {
        counterror++;
        isValid = false
        //console.log(s)
    }
    else {
        isValid = true;
    }
}


function OnUpdateClick(s, e) { //Add/Edit/Close button function
    btn.SetEnabled(false);
    var btnmode = btn.GetText(); //gets text of button

    gv1.batchEditApi.EndEdit();
    gvService.batchEditApi.EndEdit();

    autocalculate();


    setTimeout(function () {
        var indicies = gv1.batchEditApi.GetRowVisibleIndices();
        for (var i = 0; i < indicies.length; i++) {
            var key = gv1.GetRowKey(indicies[i]);
            if (!gv1.batchEditApi.IsDeletedRow(key)) {
                gv1.batchEditApi.ValidateRow(indicies[i]);
                gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("DocNumber").index);
            }
        }
        gv1.batchEditApi.EndEdit();

        if (btnmode === "Delete") {
            cp.PerformCallback("Delete");
        }

        var indicies = gv1.batchEditApi.GetRowVisibleIndices();

        //for (var i = 0; i < indicies.length; i++) {
        //    if (gv1.batchEditApi.IsNewRow(indicies[i])) {
        //        orderqty = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
        //        unitcost = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");



        //        //console.log(gv1.batchEditApi.GetCellValue(indicies[i], "IsVat"));
        //        if (!ASPxClientUtils.IsExists(unitcost) || ASPxClientUtils.Trim(unitcost) == "0" || ASPxClientUtils.Trim(unitcost) == "0.00" || ASPxClientUtils.Trim(unitcost) == null) {
        //            isValid = false
        //        }

        //        else {
        //            isValid = true
        //        }
        //        if (!ASPxClientUtils.IsExists(orderqty) || ASPxClientUtils.Trim(orderqty) == "0" || ASPxClientUtils.Trim(orderqty) == "0.00" || ASPxClientUtils.Trim(orderqty) == null) {
        //            isValid = false
        //        }

        //        else {
        //            isValid = true
        //        }
        //    }
        //    else { //Existing Rows
        //        var key = gv1.GetRowKey(indicies[i]);
        //        if (gv1.batchEditApi.IsDeletedRow(key)) {
        //            console.log("deleted row " + indicies[i]);
        //            //gv1.batchEditHelper.EndEdit();
        //        }
        //        else {
        //            orderqty = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
        //            unitcost = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");
        //            unitfrieght = gv1.batchEditApi.GetCellValue(indicies[i], "UnitFreight");



        //            //console.log(gv1.batchEditApi.GetCellValue(indicies[i], "IsVat"));
        //            if (!ASPxClientUtils.IsExists(unitcost) || ASPxClientUtils.Trim(unitcost) == "0" || ASPxClientUtils.Trim(unitcost) == "0.00" || ASPxClientUtils.Trim(unitcost) == null) {
        //                isValid = false
        //            }

        //            else {
        //                isValid = true
        //            }
        //            if (!ASPxClientUtils.IsExists(orderqty) || ASPxClientUtils.Trim(orderqty) == "0" || ASPxClientUtils.Trim(orderqty) == "0.00" || ASPxClientUtils.Trim(orderqty) == null) {
        //                isValid = false
        //            }

        //            else {
        //                isValid = true
        //            }
        //        }

        //    }
        //}

        if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
            //Sends request to server side
            if (btnmode == "Add") {
                gv1.PerformCallback("Add");
            }
            else if (btnmode == "Update") {
                gv1.PerformCallback("Update");
            }
            else if (btnmode == "Close") {
                cp.PerformCallback("Close");
            }
        }
        else {
            counterror = 0;
            alert('Please check all the fields!');
            btn.SetEnabled(true);
        }
    }, 1000);

            
}

function OnConfirm(s, e) {//function upon saving entry
    console.log(e.requestTriggerID);
    if (e.requestTriggerID === "MainForm_GridForm_gv1" || e.requestTriggerID == undefined)//disables confirmation message upon saving.  
        e.cancel = true;
}

var initgv = 'true';
var VATRate = 0;
var ATCRate = 0
var VATCode = "";
var vatdetail1 = 0;
var iswithdetail = "false";
function gridView_EndCallback(s, e) {//End callback function if (s.cp_success) {    
    if (s.cp_success) {
        gv1.CancelEdit();
        if (s.cp_valmsg) {
            alert(s.cp_valmsg);
            delete (s.cp_valmsg);
        }
        if (s.cp_convmes) {
            alert('Warning: ' + s.cp_convmes);
            delete (s.cp_convmes);
        }
        alert(s.cp_message);
        delete (s.cp_success);//deletes cache variables' data
        delete (s.cp_message);

        if (s.cp_forceclose) {
            delete (s.cp_forceclose);
            window.close();
        }

    }
    if (s.cp_close) {
        gv1.CancelEdit();
        if (s.cp_message != null) {
            if (s.cp_message2 != null)
            {
                alert('Item: ' + s.cp_message2 + ' Ordered Quantity is below the Minimum Order Quantity of the item');
            }
            alert(s.cp_message);
            delete (s.cp_message);
            delete (s.cp_message2);
        }
        if (s.cp_convmes) {
            alert('Warning: ' + s.cp_convmes);
            delete (s.cp_convmes);
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
        //gv1.CancelEdit();
        // cp.PerformCallback('vat');
    }

    if (s.cp_unitcost) {
        delete (s.cp_unitcost);
    }

    if (s.cp_vatdetail != null) {
        totalvat = s.cp_vatdetail;
        delete (s.cp_vatdetail);
        CINGrossVATableAmount.SetValue(totalvat);
    }

    if (s.cp_nonvatdetail != null) {
        totalnonvat = s.cp_nonvatdetail;
        delete (s.cp_nonvatdetail);
        CINNonVATableAmount.SetValue(totalnonvat);
    }
    //if (s.cp_vatrate != null) {

    //    vatrate = s.cp_vatrate;
    //    delete (s.cp_vatrate);
    //    vatdetail1 = 1 + parseFloat(vatrate);
    //   // console.log(vatrate + "vatratetry");

                
    //    console.log(vatrate);
    //}
    //if (s.cp_atc != null) {
    //    //var ATCRate = 0.00;
    //    atc = s.cp_atc;
    //    //ATCRate = s.cp_atc;
    //    //txtATCRate.SetText(ATCRate.toFixed(2));
    //    delete (s.cp_atc);
                
    //    console.log('cp_atc');
    //}

    //console.log(s.cp_iswithpr + ' kuya era')
    if (s.cp_iswithpr == "1") {
                
        prnum.SetEnabled(true);
        CINGenerate.SetEnabled(true);
        delete (s.cp_iswithpr)
        //gv1.Columns["LineNumber"].setVisible(true);
    }
    if (s.cp_iswithpr == "0") {
        prnum.SetEnabled(false);
        prnum.SetText('');
        CINGenerate.SetEnabled(false);
        delete (s.cp_iswithpr)
        //gv1.Columns["LineNumber"].setVisible(false);
    }

    if (s.cp_VATAX == "True") {
        VATRate = s.cp_vatrate;
        delete (s.cp_vatrate);
        ATCRate = s.cp_atc;
        delete (s.cp_atc);
        VATCode = s.cp_VATCode;
        delete (s.cp_VATCode);
        setVATAX();
        autocalculate();
        delete (s.cp_VATAX);
        //gv1.Columns["LineNumber"].setVisible(false);
    }

    //if (s.cp_VATAX == "False") {
    //    console.log('Pasok din dito grabe?');
    //    //gv1.Columns["LineNumber"].setVisible(false);
    //}

    if (s.cp_iswithdetail == "True") {
        iswithdetail = s.cp_iswithdetail;
        delete (s.cp_iswithdetail);
        //gv1.Columns["LineNumber"].setVisible(false);
    }

    btn.SetEnabled(true);
}

var index;
var closing;
var itemc; //variable required for lookup
var valchange = false;
var valchange_VAT = false;
var currentColumn = null;
var isSetTextRequired = false;
var linecount = 1;
var editorobj;
function OnStartEditing(s, e) {//On start edit grid function     
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
    index = e.visibleIndex;
    //if (e.visibleIndex < 0) {//new row
    //    var linenumber = s.GetColumnByField("LineNumber");
    //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
    //}
    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsAllowPartial") === null) {
        s.batchEditApi.SetCellValue(e.visibleIndex, "IsAllowPartial", true)
    }

    editorobj = e;

    var entry = getParameterByName('entry');
    if (entry == "V") {
        e.cancel = true; //this will made the gridview readonly
    }
    if (prnum.GetText() != "")
    {
        if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
            e.cancel = true;
        }
        if (e.focusedColumn.fieldName === "ColorCode") {
            e.cancel = true;
        }
        if (e.focusedColumn.fieldName === "ClassCode") {
            e.cancel = true;
        }
        if (e.focusedColumn.fieldName === "SizeCode") {
            e.cancel = true;
        }
    }

    if (entry != "V")
    {
        if (e.focusedColumn.fieldName === "VATCode") {
            if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsVat") == false) {
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
        if (e.focusedColumn.fieldName === "Unit") {
            gl5.GetInputElement().value = cellInfo.value;
        }
        if (e.focusedColumn.fieldName === "VATCode") {
            glVATCode.GetInputElement().value = cellInfo.value;
        }

        if (CINBroker.GetText()=="")
        if (e.focusedColumn.fieldName === "UnitFreight") {
            e.cancel = true;
        }

        if (e.focusedColumn.fieldName === "FullDesc") {
            e.cancel = true;
        }
    }
    keybGrid = s;
    keyboardOnStart(e);
}

var previndex;
function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
    var cellInfo = e.rowValues[currentColumn.index];

    var entry = getParameterByName('entry');

    previndex = e.visibleIndex;
    //if (entry == "N") {
    //Pag ni click mo yung field hindi nawawala yung value. na seset pa din after mo mag click sa ibang field
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
        cellInfo.text = gl5.GetText();
    }
    if (currentColumn.fieldName === "VATCode") {
        cellInfo.value = glVATCode.GetValue();
        cellInfo.text = glVATCode.GetText();
    }
    keyboardOnEnd();
}

var servc;
function OnStartEditing2(s, e) {//On start edit grid function     
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    servc = s.batchEditApi.GetCellValue(e.visibleIndex, "ServiceType"); //needed var for all lookups; this is where the lookups vary for
    index = e.visibleIndex;
    //if (e.visibleIndex < 0) {//new row
    //    var linenumber = s.GetColumnByField("LineNumber");
    //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
    //}
    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsAllowProgressBilling") === null) {
        s.batchEditApi.SetCellValue(e.visibleIndex, "IsAllowProgressBilling", false)
    }
    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsVat") === null) {
        s.batchEditApi.SetCellValue(e.visibleIndex, "IsVat", false)
    }
    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsClosed") === null) {
        s.batchEditApi.SetCellValue(e.visibleIndex, "IsClosed", false)
    }
    

    editorobj = e;

    var entry = getParameterByName('entry');
    if (entry === "V") {
        e.cancel = true; //this will made the gridview readonly
    }
    if (prnum.GetText() !== "") {
        if (e.focusedColumn.fieldName === "ServiceType") { //Check the column name
           
            e.cancel = true;
        }
    }

    if (entry !== "V") {
        if (e.focusedColumn.fieldName === "VATCode") {
            if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsVat") == false) {
                e.cancel = true;
            }
            else {
                glVATCode.GetInputElement().value = cellInfo.value; //Gets the column value
                isSetTextRequired = true;
            }
        }
        if (e.focusedColumn.fieldName === "ServiceType") {
            isSetTextRequired = true;
            glService.GetInputElement().value = cellInfo.value;
        }
        if (e.focusedColumn.fieldName === "VATCode") {
            glVATCode2.GetInputElement().value = cellInfo.value;
        }
        if (e.focusedColumn.fieldName === "Unit") {
            glUnit.GetInputElement().value = cellInfo.value;
        }
        if (e.focusedColumn.fieldName === "Description" || e.focusedColumn.fieldName === "TotalCost" || e.focusedColumn.fieldName === "LineNumber") {
            e.cancel = true;
        }
    }
    keybGrid = s;
    keyboardOnStart(e);
}

function OnEndEditing2(s, e) {//end edit grid function, sets text after select/leaving the current lookup
    var cellInfo = e.rowValues[currentColumn.index];

    var entry = getParameterByName('entry');

    //if (entry == "N") {
    //Pag ni click mo yung field hindi nawawala yung value. na seset pa din after mo mag click sa ibang field
    if (currentColumn.fieldName === "Unit") {
        cellInfo.value = glUnit.GetValue();
        cellInfo.text = glUnit.GetText();
    }
    if (currentColumn.fieldName === "ServiceType") {
        cellInfo.value = glService.GetValue();
        cellInfo.text = glService.GetText();
    }
    if (currentColumn.fieldName === "VATCode") {
        cellInfo.value = glVATCode2.GetValue();
        cellInfo.text = glVATCode2.GetText();
    }
    keyboardOnEnd();
}

function setVATAX(s,e)
{
    setTimeout(function () { //New Rows
        var indicies = gv1.batchEditApi.GetRowVisibleIndices();

        for (var i = 0; i < indicies.length; i++) {
            if (gv1.batchEditApi.IsNewRow(indicies[i])) {

                gv1.batchEditApi.SetCellValue(indicies[i], 'VATCode', VATCode);
                gv1.batchEditApi.SetCellValue(indicies[i], 'Rate', VATRate);
                gv1.batchEditApi.SetCellValue(indicies[i], 'ATCRate', ATCRate);

                if(VATCode != 'NONV')
                {
                    gv1.batchEditApi.SetCellValue(indicies[i], 'IsVat', true);

                }
                else
                {

                    gv1.batchEditApi.SetCellValue(indicies[i], 'IsVat', false);
                }

            }


            else { //Existing Rows
                var key = gv1.GetRowKey(indicies[i]);
                if (gv1.batchEditApi.IsDeletedRow(key)) {
                    console.log("deleted row " + indicies[i]);
                    //gv1.batchEditHelper.EndEdit();
                }
                else {
                    gv1.batchEditApi.SetCellValue(indicies[i], 'VATCode', VATCode);
                    gv1.batchEditApi.SetCellValue(indicies[i], 'Rate', VATRate);
                    gv1.batchEditApi.SetCellValue(indicies[i], 'ATCRate', ATCRate);


                    if (VATCode != 'NONV') {
                        if (iswithdetail == "True")
                        {
                            gv1.batchEditApi.SetCellValue(indicies[i], 'IsVat', true);
                        }
                        else
                        {
                            gv1.batchEditApi.SetCellValue(indicies[i], 'IsVat', 1);
                        }
                    }
                    else {
                        if (iswithdetail == "True") {
                            gv1.batchEditApi.SetCellValue(indicies[i], 'IsVat', false);
                        }
                        else {
                            gv1.batchEditApi.SetCellValue(indicies[i], 'IsVat', 0);
                        }
                    }
                }

            }

        }

    }, 500);

}

var Nanprocessor = function (entry) {
    if (isNaN(entry) == true) {
        console.log(entry +"entry")
        return 0;
    } else
        return entry;
}

function autocalculate(s, e) {
    //console.log('inside autocalculate')
    //OnInitTrans();
    //console.log(txtNewUnitCost.GetValue());
    var unitfrieght = 0.00;
    var receivedqty1 = 0.00;
    var unitcost1 = 0.00;
    var receivedqty2 = 0.00;
    var unitcost2 = 0.00;
    var freight = 0.00;
            
    var totalfreight = 0.00;
    var TotalQuantity = 0.0000;
    var TotalAmount1 = 0.00;
    var TotalAmount2 = 0.00;
    var ForeignAmount = 0.00;
            

    var exchangerate = 0.00;
    var totalqty = 0.00
    var frieght = 0.00;
    var orderqty = 0.00;
    var orderqtyVAT = 0.00;
    var orderqtyNVAT = 0.00;
    var unitcost = 0.00;
    var unitcostVAT = 0.00;
    var unitcostNVAT = 0.00;
    var sumfreight = 0.00;
    var TotalAmount = 0.00;
    var TotalAmountVAT = 0.00;
    var TotalAmountNVAT = 0.00;
    var GrossVat = 0.00;
    var NonVat = 0.00;
    var VATAmount = 0.00;
    var WithHolding = 0.00;
    var PesoAmount = 0.00;
    var CPesoAmount = 0.00;

    var UnitExchangeR = 0.00;
    var Ratedetail = 0.00;
    var ATCDetail = 0.00;
    var TotalVatComputer = 0.00;



    var CosttimeExchange = 0.00;

    //Get and Set Value of Exhange Rate
    if (CINExchangeRate.GetValue() == null || CINExchangeRate.GetValue() == "") {
        exchangerate = 0;
    }
    else {
        exchangerate = CINExchangeRate.GetValue();
    }
    //Get and Set Value of Total Quantity
      
    //Get and Set Value of Total Freight
    if (CINTotalFreight.GetValue() == null || CINTotalFreight.GetValue() == "") {
        freight = 0;
    }
    else {
        freight = CINTotalFreight.GetValue();
    }

    setTimeout(function () { //New Rows
        var indicies = gv1.batchEditApi.GetRowVisibleIndices();

        for (var i = 0; i < indicies.length; i++)
        {
            if (gv1.batchEditApi.IsNewRow(indicies[i]))
            {
                orderqty = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
                unitcost = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                unitfrieght = gv1.batchEditApi.GetCellValue(indicies[i], "UnitFreight");
                PesoAmount = gv1.batchEditApi.SetCellValue(indicies[i], "PesoAmount");

                         
                totalfreight += unitfrieght * orderqty;
                TotalAmount += unitcost * orderqty;  //Total Amount of OrderQty
                TotalQuantity += orderqty;          //Sum of all Quantity
                CosttimeExchange += (unitcost * exchangerate) * orderqty;
                CPesoAmount = CosttimeExchange;

                var cb = gv1.batchEditApi.GetCellValue(indicies[i], "IsVat")
                         


                //console.log(gv1.batchEditApi.GetCellValue(indicies[i], "IsVat"));
                if (cb == true)
                {
                    orderqtyVAT = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
                    unitcostVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                    Ratedetail = gv1.batchEditApi.GetCellValue(indicies[i], "Rate");
                    ATCDetail = gv1.batchEditApi.GetCellValue(indicies[i], "ATCRate");
                    TotalAmountVAT += unitcostVAT * exchangerate;
                    UnitExchangeR += (unitcostVAT * exchangerate) * orderqtyVAT;
                    TotalVatComputer += ((unitcostVAT * exchangerate) * orderqtyVAT) * Ratedetail;
                    GrossVat = TotalAmountVAT * orderqtyVAT;
                    //VATAmount = UnitExchangeR * Ratedetail;
                    VATAmount = TotalVatComputer;
                    //WithHolding = ((GrossVat - VATAmount) * ATCDetail);
                    WithHolding = (GrossVat * ATCDetail); // New Formula From Ate Nes 02-29-2016
                }

                else
                {
                    orderqtyNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
                    unitcostNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                    TotalAmountNVAT += unitcostNVAT * exchangerate;
                    NonVat = TotalAmountNVAT * orderqtyNVAT;
                }
            }
            else
            { //Existing Rows
                var key = gv1.GetRowKey(indicies[i]);
                if (gv1.batchEditApi.IsDeletedRow(key))
                {
                    console.log("deleted row " + indicies[i]);
                    //gv1.batchEditHelper.EndEdit();
                }
                else
                {
                    orderqty = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
                    unitcost = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                    unitfrieght = gv1.batchEditApi.GetCellValue(indicies[i], "UnitFreight");
                    PesoAmount = gv1.batchEditApi.SetCellValue(indicies[i], "PesoAmount");


                    totalfreight += unitfrieght * orderqty;
                    TotalAmount += unitcost * orderqty;  //Total Amount of OrderQty
                    TotalQuantity += orderqty;          //Sum of all Quantity

                    CosttimeExchange += (unitcost * exchangerate) * orderqty;

                    CPesoAmount = CosttimeExchange;

                    var cb = gv1.batchEditApi.GetCellValue(indicies[i], "IsVat")
 
                    if (cb == true)
                    {
                        orderqtyVAT = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
                        unitcostVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                        Ratedetail = gv1.batchEditApi.GetCellValue(indicies[i], "Rate");
                        ATCDetail = gv1.batchEditApi.GetCellValue(indicies[i], "ATCRate");
                        TotalAmountVAT += unitcostVAT * orderqtyVAT;
                        UnitExchangeR += (unitcostVAT * exchangerate) * orderqtyVAT;
                        TotalVatComputer += ((unitcostVAT * exchangerate) * orderqtyVAT) * Ratedetail;  // compute isa isa vatamount bago isalpak.
                        GrossVat = TotalAmountVAT * exchangerate;
                        //VATAmount = TotalAmountVAT * vatrate;
                        VATAmount = TotalVatComputer;
                        //WithHolding = ((GrossVat - VATAmount) * ATCDetail);
                        WithHolding = (GrossVat * ATCDetail); // New Formula From Ate Nes 02-29-2016

                    }
                    else
                    {
                        orderqtyNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "OrderQty");
                        unitcostNVAT = gv1.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                        TotalAmountNVAT += unitcostNVAT * orderqtyNVAT;
                        NonVat = TotalAmountNVAT * exchangerate;
                    }
                }

            }



                       
        }

        indicies = gvService.batchEditApi.GetRowVisibleIndices();

        for (var i = 0; i < indicies.length; i++) {
            if (gvService.batchEditApi.IsNewRow(indicies[i])) {
                orderqty = gvService.batchEditApi.GetCellValue(indicies[i], "ServiceQty");
                unitcost = gvService.batchEditApi.GetCellValue(indicies[i], "UnitCost");

                TotalAmount += unitcost * orderqty;  //Total Amount of OrderQty
                TotalQuantity += orderqty;          //Sum of all Quantity
                CosttimeExchange += (unitcost * exchangerate) * orderqty;
                CPesoAmount = CosttimeExchange;

                var cb = gvService.batchEditApi.GetCellValue(indicies[i], "IsVat")

                //console.log(gvService.batchEditApi.GetCellValue(indicies[i], "IsVat"));
                if (cb == true) {
                    orderqtyVAT = gvService.batchEditApi.GetCellValue(indicies[i], "ServiceQty");
                    unitcostVAT = gvService.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                    Ratedetail = gvService.batchEditApi.GetCellValue(indicies[i], "VATRate");
                    TotalAmountVAT += unitcostVAT * exchangerate;
                    UnitExchangeR += (unitcostVAT * exchangerate) * orderqtyVAT;
                    TotalVatComputer += ((unitcostVAT * exchangerate) * orderqtyVAT) * Ratedetail;
                    GrossVat = TotalAmountVAT * orderqtyVAT;
                    VATAmount = TotalVatComputer;
                }

                else {
                    orderqtyNVAT = gvService.batchEditApi.GetCellValue(indicies[i], "ServiceQty");
                    unitcostNVAT = gvService.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                    TotalAmountNVAT += unitcostNVAT * exchangerate;
                    NonVat = TotalAmountNVAT * orderqtyNVAT;
                }
            }
            else { //Existing Rows
                var key = gvService.GetRowKey(indicies[i]);
                if (gvService.batchEditApi.IsDeletedRow(key)) {
                    console.log("deleted row " + indicies[i]);
                    //gvService.batchEditHelper.EndEdit();
                }
                else {
                    orderqty = gvService.batchEditApi.GetCellValue(indicies[i], "ServiceQty");
                    unitcost = gvService.batchEditApi.GetCellValue(indicies[i], "UnitCost");

                    TotalAmount += unitcost * orderqty;  //Total Amount of OrderQty
                    TotalQuantity += orderqty;          //Sum of all Quantity

                    CosttimeExchange += (unitcost * exchangerate) * orderqty;

                    CPesoAmount = CosttimeExchange;

                    var cb = gvService.batchEditApi.GetCellValue(indicies[i], "IsVat")

                    if (cb == true) {
                        orderqtyVAT = gvService.batchEditApi.GetCellValue(indicies[i], "ServiceQty");
                        unitcostVAT = gvService.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                        Ratedetail = gvService.batchEditApi.GetCellValue(indicies[i], "VATRate");
                        TotalAmountVAT += unitcostVAT * orderqtyVAT;
                        UnitExchangeR += (unitcostVAT * exchangerate) * orderqtyVAT;
                        TotalVatComputer += ((unitcostVAT * exchangerate) * orderqtyVAT) * Ratedetail;  // compute isa isa vatamount bago isalpak.
                        GrossVat = TotalAmountVAT * exchangerate;
                        VATAmount = TotalVatComputer;
                    }
                    else {
                        orderqtyNVAT = gvService.batchEditApi.GetCellValue(indicies[i], "ServiceQty");
                        unitcostNVAT = gvService.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                        TotalAmountNVAT += unitcostNVAT * orderqtyNVAT;
                        NonVat = TotalAmountNVAT * exchangerate;
                    }
                }
            }
        }

        CINTotalFreight.SetValue(totalfreight.toFixed(2));
        CINPesoAmount.SetValue(CPesoAmount.toFixed(2));
        CINForeignAmount.SetValue(TotalAmount.toFixed(2));
        CINTotalQty.SetValue(TotalQuantity.toFixed(4));
        CINGrossVATableAmount.SetValue(GrossVat.toFixed(2));
        CINNonVATableAmount.SetValue(NonVat.toFixed(2));
        CINVATAmount.SetValue(VATAmount.toFixed(2));
        CINWithholdingTax.SetValue(WithHolding.toFixed(2));
        return true;
    }, 500);

}

function detailautocalculate(s, e) {
    //OnInitTrans();
    var freight = 0.00;
    var totalqty = 0.00
    var totalfreight = 0.00;

    if (CINTotalFreight.GetValue() == null || CINTotalFreight.GetValue() == "")
    {
        freight = 0;
    }
    else
    {
        freight = CINTotalFreight.GetValue();
    }
    if (CINTotalQty.GetValue() == null || CINTotalQty.GetValue() == "")
    {
        totalqty = 0;
    }
    else
    {
        totalqty = CINTotalQty.GetValue();
    }

    setTimeout(function () {
        for (var i = 0; i < gv1.GetVisibleRowsOnPage() ; i++) {
            gv1.batchEditApi.SetCellValue(i, "UnitFreight", (freight / totalqty).toFixed(2));
        }
    }, 500);
}
        
function negativecheck(s, e) {
    var unitfreight = CINUnitFreightDetail.GetValue();
    var orderqty = CINOrderQtyDetail.GetValue();
    var unitcost = CINUnitCostDetail.GetValue();

    unitfreight = unitfreight <= 0 ? 0 : unitfreight;
    CINUnitFreightDetail.SetValue(unitfreight);
}

function orderqtynegativecheck(s, e) {
    var orderqty = CINOrderQtyDetail.GetValue();

    orderqty = orderqty <= 0 ? 0 : orderqty;
    CINOrderQtyDetail.SetValue(orderqty);
}

function unitcostnegativecheck(s, e) {
    var unitcost = CINUnitCostDetail.GetValue();

    unitcost = unitcost <= 0 ? 0 : unitcost;
    CINUnitCostDetail.SetValue(unitcost);
}

function lookup(s, e) {
    console.log(s.GetInputElement().value);
    if (isSetTextRequired) {//Sets the text during lookup for item code
        console.log(s.GetInputElement().value);
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
    if (keyCode == 13) {
        gv1.batchEditApi.EndEdit();
    }
    //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
}

function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
    //setTimeout(function () {
    gv1.batchEditApi.EndEdit();
    gvService.batchEditApi.EndEdit();
    //}, 1000);
}

//validation
//function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields/index 0 is from the commandcolumn)
//    for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
//        var column = s.GetColumn(i);
//        if (column != s.GetColumn(1) && column != s.GetColumn(2) && column != s.GetColumn(3)
//            && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15)
//            && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18)
//            && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21)
//            && column != s.GetColumn(22) && column != s.GetColumn(23)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
//            var cellValidationInfo = e.validationInfo[column.index];
//            if (!cellValidationInfo) continue;
//            var value = cellValidationInfo.value;
//            if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
//                cellValidationInfo.isValid = false;
//                cellValidationInfo.errorText = column.fieldName + " is required";
//                isValid = false;
//                console.log(column);
//            }
//            else {
//                isValid = true;
//            }
//        }
//    }
//}

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

        if (column.fieldName == "UnitCost") {
            var cellValidationInfo = e.validationInfo[column.index];
            if (!cellValidationInfo) continue;
            var value = cellValidationInfo.value;
            if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "0" || ASPxClientUtils.Trim(value) == "0.0000" || ASPxClientUtils.Trim(value) == null)) {
                cellValidationInfo.isValid = false;
                cellValidationInfo.errorText = column.fieldName + " is required!";
                isValid = false;
            }
        }

        if (column.fieldName == "UnitFreight") {
            var cellValidationInfo = e.validationInfo[column.index];
            if (!cellValidationInfo) continue;
            var value = cellValidationInfo.value;
            if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "0" || ASPxClientUtils.Trim(value) == "0.0000" || ASPxClientUtils.Trim(value) == null) && (CINBroker.GetText() != '' || CINBroker.GetValue() != null)) {
                cellValidationInfo.isValid = false;
                cellValidationInfo.errorText = column.fieldName + " is required!";
                isValid = false;
            }
        }
    }
}


function OnCustomClick(s, e)
{

    if (e.buttonID == "Details") {
        var itemcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
        var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
        var classcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
        var sizecode = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
        var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
        var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
        var Warehouse = CINReceivingWarehouse.GetText();
              
        console.log(sizecode)
        factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + encodeURIComponent(itemcode)
        + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&Warehouse=' + Warehouse);

    }

    if (e.buttonID == "Delete") {
        gv1.DeleteRow(e.visibleIndex);
        //gv1.Refresh();
        autocalculate(s, e);
        CheckDetail();
    }

    if (e.buttonID == "Delete2") {
        gvService.DeleteRow(e.visibleIndex);
        //gv1.Refresh();
        autocalculate(s, e);
        CheckDetail();
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


    //if (e.buttonID == "CountSheet") {
    //    CSheet.Show();
    //    var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
    //    var docnumber = getParameterByName('docnumber');
    //    var transtype = getParameterByName('transtype');
    //    var entry = getParameterByName('entry');
    //    CSheet.SetContentUrl('frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
    //        '&linenumber=' + linenum);
    //}
}

function Generate(s, e) {
    if (isNullOrWhiteSpace(prnum.GetText())) { alert('No PR Number!'); return; }
    var generate = confirm("Are you sure you want to generate the Purchase Request Number(s)?");
    if (generate) {
        gv1.CancelEdit();
        gv1.PerformCallback('Generate');
        gvPRDetails.PerformCallback();
        cp.PerformCallback('setmemo');
        e.processOnServer = false;
    }
}


function checkedchanged(s, e) {
    var checkState = cbiswithpr.GetChecked();
    if (checkState == true) {
        gv1.PerformCallback('iswithprtrue');
        gvService.PerformCallback('iswithprtrue');
        e.processOnServer = false;
    }
    else {
        gv1.PerformCallback('iswithprfalse');
        gvService.PerformCallback('iswithprfalse');
        
        e.processOnServer = false;
    }

}

var identifier;
var val_ALL;
function GridEndChoice(s, e) {

    identifier = s.GetGridView().cp_identifier;
    val = s.GetGridView().cp_codes;
    val_ALL = s.GetGridView().cp_codes;
            

    val_VAT = s.GetGridView().cp_codes;
    if (val_VAT != undefined)
    temp_VAT = val_VAT.split(';');

    //console.log(identifier + " idetifier")
    //console.log(val + " VAL")
    //console.log(val_VAT + " VAL_VAT")

    if (identifier == "ItemCode") {
        gv1.batchEditApi.EndEdit();
        delete (s.GetGridView().cp_identifier);
        if (s.GetGridView().cp_valch) {
            delete (s.GetGridView().cp_valch);
            for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
                //console.log('anoto')
                var column = gv1.GetColumn(i);
                if (column.visible == false || column.fieldName == undefined)
                    continue;
                ProcessCells_ItemCode(0, editorobj, column, gv1);
            }
            gv1.batchEditApi.EndEdit();
            gv1.batchEditApi.StartEdit(previndex, gv1.GetColumnByField(currentColumn.fieldName).index);
        }
       
      
    }

    if (identifier == "VAT") {
        GridEnd_VAT();
        console.log('2')
        gv1.batchEditApi.EndEdit();
        gv1.batchEditApi.StartEdit(previndex, gv1.GetColumnByField(currentColumn.fieldName).index);
    }
    

    loader.Hide();
}


function ProcessCells_ItemCode(selectedIndex, e, column, s) {
    var temp_ALL;
    if (temp_ALL == null) {
        temp_ALL = ";;;;;;;;;;";
    }
    temp_ALL = val_ALL.split(';');
    if (!temp_ALL[0] == null) {
        temp_ALL[0] = "";
    }
    if (!temp_ALL[1] == null) {
        temp_ALL[1] = "";
    }
    if (!temp_ALL[2] == null) {
        temp_ALL[2] = "";
    }
    if (!temp_ALL[3] == null) {
        temp_ALL[3] = "";
    }
    if (!temp_ALL[4] == null) {
        temp_ALL[4] = "";
    }
    if (!temp_ALL[5] == null) {
        temp_ALL[5] = "";
    }
    if (!temp_ALL[6] == null) {
        temp_ALL[6] = "";
    }
    if (!temp_ALL[7] == null) {
        temp_ALL[7] = "";
    }
    if (!temp_ALL[8] == null) {
        temp_ALL[8] = "";
    }
    if (!temp_ALL[9] == null) {
        temp_ALL[9] = "";
    }
    if (!temp_ALL[10] == null) {
        temp_ALL[10] = "";
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
        if (column.fieldName == "Unit") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[3]);
        }
        if (column.fieldName == "FullDesc") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[4]);
        }
        if (column.fieldName == "VATCode") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[5]);
        }
        if (column.fieldName == "IsVat") {
            if (temp_ALL[6] == "True") {
                s.batchEditApi.SetCellValue(index, column.fieldName, true);
            }
            else {
                s.batchEditApi.SetCellValue(index, column.fieldName, false);
            }
        }
        if (column.fieldName == "Rate") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[7]);
        }
        if (column.fieldName == "ATCRate") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[8]);
        }
        if (column.fieldName == "UnitCost") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[9]);
        }
        if (column.fieldName == "ItemCode") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp_ALL[10]);
        }
    }
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

function OnInitTrans(s, e) { 

    var BizPartnerCode = clBizPartnerCode.GetText();
    OnInit(s);
    factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
    autocalculate();
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

function CheckDetail(s, e) {
    //if (prnum.GetText() != "") {
    //    if (gv1.GetVisibleRowsOnPage() == 0) {
    //        prnum.SetEnabled(true);
    //        cbiswithpr.SetEnabled(true);
    //        CINGenerate.SetEnabled(true);
                    
    //    }
    //}

    var checkState = cbiswithpr.GetChecked();
    if (checkState == true) {
        if (gv1.GetVisibleRowsOnPage() == 0 && gvService.GetVisibleRowsOnPage() == 0) {
            prnum.SetEnabled(true);
            cbiswithpr.SetEnabled(true);
            CINGenerate.SetEnabled(true);

        }
    }
    else {
        if (gv1.GetVisibleRowsOnPage() == 0 && gvService.GetVisibleRowsOnPage() == 0) {
            //prnum.SetEnabled(true);
            cbiswithpr.SetEnabled(true);
            CINGenerate.SetEnabled(true);

        }
    }
}


//var fck = 0
//function DataSourceChecker(s, e) {
//    console.log('Grid Init')
//    if (fck == 0)
//   { 
//        console.log('DataSourceChecker')
//        cp.PerformCallback('datasourceset');
//        e.processOnServer = false;
//        fck = 1;
//    }

//    autocalculate();
//} 

function SetDefaultCommitment(s, e) {
    //console.log('Inside SetDefaultCommitment() Function.')
    var days = 7;
    var targetdeliverydate = CINTargetDeliveryDate.GetDate();

    var commitmentdate = new Date(targetdeliverydate);

    //cancellationdate.setTime(cancellationdate.getTime() + (days * 24 * 60 * 60 * 1000));;

    var commitmentmonth = commitmentdate.getMonth() + 1; //months from 1-12
    var commitmentday = commitmentdate.getDate();
    var commitmentyear = commitmentdate.getFullYear();

    var defaultdate = commitmentmonth + '/' + commitmentday + '/' + commitmentyear;
    CINCommitmentDate.SetText(defaultdate);


    var cancellationdate = new Date(targetdeliverydate);
    cancellationdate.setTime(cancellationdate.getTime() + (days * 24 * 60 * 60 * 1000));

    var cancellationmonth = cancellationdate.getMonth() + 1; //months from 1-12
    var cancellationday = cancellationdate.getDate();
    var cancellationyear = cancellationdate.getFullYear();

    var defaultdate = cancellationmonth + '/' + cancellationday + '/' + cancellationyear;
    CINCancellationDate.SetText(defaultdate);
}

function SetDefaultCancellation(s, e) {
    var days = 7;
    var commitmentdate = CINCommitmentDate.GetDate();
    var cancellationdate = new Date(commitmentdate);
    cancellationdate.setTime(cancellationdate.getTime() +(days * 24 * 60 * 60 * 1000));;

    var commitmentmonth = commitmentdate.getMonth() + 1; //months from 1-12
    var commitmentday = commitmentdate.getDate();
    var commitmentyear = commitmentdate.getFullYear();

    var cancellationmonth = cancellationdate.getMonth() + 1; //months from 1-12
    var cancellationday = cancellationdate.getDate();
    var cancellationyear = cancellationdate.getFullYear();


    //console.log(commitmentmonth + '/' + commitmentday + '/' + commitmentyear);
    //console.log(cancellationmonth + '/' + cancellationday + '/' + cancellationyear);

    var defaultdate = cancellationmonth + '/' + cancellationday + '/' + cancellationyear;
    CINCancellationDate.SetText(defaultdate);
}


function SetDefaultTargetDate(s, e) {
    var days = CINTerms.GetValue();
    if (days > 0)
    {
        var docdate = CINDocDate.GetDate();
        var targetdate = new Date(docdate);
        targetdate.setTime(targetdate.getTime() + (days * 24 * 60 * 60 * 1000));;

        var targetmonth = targetdate.getMonth() + 1; //months from 1-12
        var targetday = targetdate.getDate();
        var targetyear = targetdate.getFullYear();

        var defaultdate = targetmonth + '/' + targetday + '/' + targetyear;
        CINTargetDeliveryDate.SetText(defaultdate);
    }
}

function PutDesc(selectedValues) {
    gvService.batchEditApi.EndEdit();
    gvService.batchEditApi.SetCellValue(index, "Description", selectedValues[1]);
    gvService.batchEditApi.SetCellValue(index, "IsAllowProgressBilling", selectedValues[2]);
}

function PutDesc2(selectedValues) {
    gvService.batchEditApi.EndEdit();
    gvService.batchEditApi.SetCellValue(index, "VATRate", selectedValues);
}

function PutRate(selectedValues) {
    console.log('here')
    gv1.batchEditApi.EndEdit();
    gv1.batchEditApi.SetCellValue(index, "Rate", selectedValues);
    autocalculate();
}

function POPUPGetJODetail(s, e) {
    gvPRDetails.SelectAllRowsOnPage();
        var str = gvPRDetails.GetSelectedKeysOnPage();
        //console.log(str);
        for (var i = 0; i < str.length; i++) {
            var str2 = str[i].split("|");
            gvService.AddNewRow();
            getCol(gvService, editorobj, str2);
        }
        calccost();
    //CINMultiplePR.SetEnabled(true);
}

function getCol(ss, ee, item) {
    for (var i = 0; i < gvService.GetColumnsCount() ; i++) {
        var column = gvService.GetColumn(i);
        if (column.visible == false || column.fieldName == undefined)
            continue;
        Bindgrid(item, ee, column, ss);
    }
}

function Bindgrid(item, e, column, s) {//Clone function :D
    //console.log(item)
    if (column.fieldName == "PRNumber") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[2]);
    }
    if (column.fieldName == "ServiceType") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[3]);
    }
    
    if (column.fieldName == "ServiceQty") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, Math.abs(item[5]));
    }
    if (column.fieldName == "Unit") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[6]);
    }
    if (column.fieldName == "IsAllowProgressBilling") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[9] == "False" ? false : true );
    }
    if (column.fieldName == "IsVat") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[10] == "False" ? false : true);
    }
    if (column.fieldName == "VATCode") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[11]);
    }
    if (column.fieldName == "VATRate") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[12]);
    }
    if (column.fieldName == "Field1") {
        if (item[17]) {
            if (item[17].includes("~Xtra#Base64"))
                item[17] = null;

            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[17]);
        }
    }
    if (column.fieldName == "Field2") {
        if (item[18]) {
            if (item[18].includes("~Xtra#Base64"))
                item[18] = null;

            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[18]);
        }
    }
    if (column.fieldName == "Field3") {
        if (item[19]) {
            if (item[19].includes("~Xtra#Base64"))
                item[19] = null;

            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[19]);
        }
    }
    if (column.fieldName == "Field4") {
        if (item[20]) {
            if (item[20].includes("~Xtra#Base64"))
                item[20] = null;

            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[20]);
        }
    }
    if (column.fieldName == "Field5") {
        if (item[21]) {
            if (item[21].includes("~Xtra#Base64"))
                item[21] = null;

            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[21]);
        }
    }
    if (column.fieldName == "Field6") {
        if (item[22]) {
            if (item[22].includes("~Xtra#Base64"))
                item[22] = null;

            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[22]);
        }
    }
    if (column.fieldName == "Field7") {
        if (item[23]) {
            if (item[23].includes("~Xtra#Base64"))
                item[23] = null;

            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[23]);
        }
    }
    if (column.fieldName == "Field8") {
        if (item[24]) {
            if (item[24].includes("~Xtra#Base64"))
                item[24] = null;

            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[24]);
        }
    }
    if (column.fieldName == "Field9") {
        if (item[25]) {
            if (item[25].includes("~Xtra#Base64"))
                item[25] = null;

            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[25]);
        }
    }
    if (column.fieldName == "Description") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[4]);
    }
}

function calccost(s, e) {
    var sQty;
    var unitcost;
    var exchangerate = CINExchangeRate.GetText();
    exchangerate = exchangerate == null ? 0 : exchangerate;
    var totalqty = 0;
    //

    setTimeout(function () { //New Rows
        var indicies = gvService.batchEditApi.GetRowVisibleIndices();

        for (var i = 0; i < indicies.length; i++) {
            if (gvService.batchEditApi.IsNewRow(indicies[i])) {
                sQty = gvService.batchEditApi.GetCellValue(indicies[i], "ServiceQty");
                sQty = sQty == null ? 0 : sQty;
                unitcost = gvService.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                unitcost = unitcost == null ? 0 : unitcost;
                totalqty = sQty * (unitcost * exchangerate);
                gvService.batchEditApi.SetCellValue(indicies[i], "TotalCost", totalqty);
            }
            else { //Existing Rows
                var key = gvService.GetRowKey(indicies[i]);
                if (gvService.batchEditApi.IsDeletedRow(key)) {
                    var sas;
                }
                else {
                    sQty = gvService.batchEditApi.GetCellValue(indicies[i], "ServiceQty");
                    sQty = sQty == null ? 0 : sQty;
                    unitcost = gvService.batchEditApi.GetCellValue(indicies[i], "UnitCost");
                    unitcost = unitcost == null ? 0 : unitcost;
                    
                    totalqty = (sQty * (unitcost * exchangerate));
                    gvService.batchEditApi.SetCellValue(indicies[i], "TotalCost", totalqty);
                }
            }
        }

        autocalculate();
    }, 500);

    //console.log(totalqty)
}

var transtype = getParameterByName('transtype');
function onload() {
    setTimeout(function(){
        fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + txtDocNumber.GetText() + '&transtype=' + transtype);
    }, 500);

    //if (clBizPartnerCode.GetText()) {
    //    cp.PerformCallback('SupplierCodeCase|' + clBizPartnerCode.GetText());
    //}
}

function setCode(s, e) {
    if (s.cp_codes) {
        gv1.batchEditApi.SetCellValue(index, 'UnitCost', s.cp_codes);
        delete (s.cp_codes);
    }
}