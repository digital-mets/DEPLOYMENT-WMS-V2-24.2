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

function OnValidation(s, e) {
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
}

function OnUpdateClick(s, e) { //Add/Edit/Close button function
    var btnmode = btn.GetText(); //gets text of button
    if (btnmode == "Delete") {
        cp.PerformCallback("Delete");
    }

    var indicies = gv1.batchEditApi.GetRowVisibleIndices();
    for (var i = 0; i < indicies.length; i++) {
        if (gv1.batchEditApi.IsNewRow(indicies[i])) {
            gv1.batchEditApi.ValidateRow(indicies[i]);
            gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("Field1").index);
            gv1.batchEditApi.EndEdit();
        }
        else {
            var key = gv1.GetRowKey(indicies[i]);
            if (gv1.batchEditApi.IsDeletedRow(key))
                console.log("deleted row " + indicies[i]);
            else {
                gv1.batchEditApi.ValidateRow(indicies[i]);
                gv1.batchEditApi.StartEdit(indicies[i], gv1.GetColumnByField("Field1").index);
                gv1.batchEditApi.EndEdit();
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
        console.log(counterror);
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
        if (s.cp_forceclose) {
            delete (s.cp_forceclose);
            window.close();
        }
        gv1.CancelEdit();

    }

    if (s.cp_close) {
        gv1.CancelEdit();
        if (s.cp_valmsg != null && s.cp_valmsg != "" && s.cp_valmsg != undefined) {
            alert(s.cp_valmsg);
            delete (s.cp_valmsg);
        }
        if (s.cp_message != null) {
            alert(s.cp_message);
            delete (s.cp_message);
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
        //autocalculate();           
    }

    if (s.cp_resetdetail) {
        delete (s.cp_resetdetail);
        deleteRows();
    }

    if (s.cp_unitcost) {
        delete (s.cp_unitcost);
    }

    if (s.cp_vatrate != null) {

        vatrate = s.cp_vatrate;
        delete (s.cp_vatrate);
        vatdetail1 = 1 + parseFloat(vatrate);
    }

}

var index;
var closing;
var itemc;
var itemclr;
var itemcls;
var itemsze;
var itemcN;
var itemclrN;
var itemclsN;
var itemszeN;
var itemunit;
var pcode;
var pcolor;
var psize;
var itemdesc;
var itemstep;
var isbulk;
var loading = false;
var nope = false;
var valchange = false;
var valchange2 = false;
var valchange3 = false;
var currentColumn = null;
var isSetTextRequired = false;
var linecount = 1;
var BOMIndex;
function OnStartEditing(s, e) {//On start edit grid function     
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    BOMIndex = e.visibleIndex;
    //console.log(e.GetRowKey + ' e.GetRowKey');
    itemstep = s.batchEditApi.GetCellValue(e.visibleIndex, "StepCode");
    itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "OldItemCode");
    itemclr = s.batchEditApi.GetCellValue(e.visibleIndex, "OldColorCode");
    itemcls = s.batchEditApi.GetCellValue(e.visibleIndex, "OldClassCode");
    itemsze = s.batchEditApi.GetCellValue(e.visibleIndex, "OldSizeCode");
    itemunit = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
    isbulk = s.batchEditApi.GetCellValue(e.visibleIndex, "IsBulk");

    itemcN = s.batchEditApi.GetCellValue(e.visibleIndex, "NewItemCode");
    itemclrN = s.batchEditApi.GetCellValue(e.visibleIndex, "NewColorCode");
    itemclsN = s.batchEditApi.GetCellValue(e.visibleIndex, "NewClassCode");
    itemszeN = s.batchEditApi.GetCellValue(e.visibleIndex, "NewSizeCode");

    pcode = s.batchEditApi.GetCellValue(e.visibleIndex, "ProductCode");
    pcolor = s.batchEditApi.GetCellValue(e.visibleIndex, "ProductColor");
    psize = s.batchEditApi.GetCellValue(e.visibleIndex, "ProductSize");

    index = e.visibleIndex;
    //console.log(e.visibleIndex + 'e.visibleIndex')
    //var entry = getParameterByName('entry');

    if (entry == "V" || entry == "D") {
        e.cancel = true; //this will made the gridview readonly
    }

    if (aglReferenceJO.GetText() == null || aglReferenceJO.GetText() == "") {
        e.cancel = true;
    }

    //console.log('X' + aglType.GetValue() + 'X');

    if (aglType.GetValue() == "ADD ITEM") {
        //console.log('dumann dito')
        if (isbulk == true) {
            //console.log('bulk1')
            if (e.focusedColumn.fieldName === "LineNumber" || e.focusedColumn.fieldName === "OldItemCode" || e.focusedColumn.fieldName === "OldColorCode" ||
                e.focusedColumn.fieldName === "OldClassCode" || e.focusedColumn.fieldName === "OldSizeCode" || e.focusedColumn.fieldName === "IsExcluded" ||
                e.focusedColumn.fieldName === "PerPieceConsumption" || e.focusedColumn.fieldName === "RequiredQty") {
                e.cancel = true;
            }
        }
        else {
            //console.log('bulk')
            if (e.focusedColumn.fieldName === "LineNumber" || e.focusedColumn.fieldName === "OldItemCode" || e.focusedColumn.fieldName === "OldColorCode" ||
                e.focusedColumn.fieldName === "OldClassCode" || e.focusedColumn.fieldName === "OldSizeCode" || e.focusedColumn.fieldName === "IsExcluded" ||
                e.focusedColumn.fieldName === "Consumption" || e.focusedColumn.fieldName === "RequiredQty") {
                e.cancel = true;
            }
        }
    }
    else if (aglType.GetValue() == "CHANGE CONSUMPTION") {
        //console.log('dito ' + 'test ' + isbulk)
        if (isbulk == true) {
            //console.log('dito true')
            if (e.focusedColumn.fieldName === "UnitCost" ||
                e.focusedColumn.fieldName === "IsMajorMaterial" || e.focusedColumn.fieldName === "IsExcluded" ||
                e.focusedColumn.fieldName === "PerPieceConsumption" || e.focusedColumn.fieldName === "RequiredQty") {
                e.cancel = true;
            }
        }
        else {
            //console.log('dito false')
            if (e.focusedColumn.fieldName !== "StepCode" && e.focusedColumn.fieldName !== "OldItemCode" && e.focusedColumn.fieldName !== "OldColorCode" &&
                e.focusedColumn.fieldName !== "OldClassCode" && e.focusedColumn.fieldName !== "OldSizeCode" && e.focusedColumn.fieldName !== "ProductCode" &&
                e.focusedColumn.fieldName !== "ProductColor" && e.focusedColumn.fieldName !== "ProductSize" && e.focusedColumn.fieldName !== "NewItemCode" &&
                e.focusedColumn.fieldName !== "NewColorCode" && e.focusedColumn.fieldName !== "NewClassCode" && e.focusedColumn.fieldName !== "NewSizeCode" &&
                e.focusedColumn.fieldName !== "Unit" && e.focusedColumn.fieldName !== "PerPieceConsumption" && e.focusedColumn.fieldName !== "Components"
                && e.focusedColumn.fieldName !== "AllowancePerc" && e.focusedColumn.fieldName !== "AllowanceQty" && e.focusedColumn.fieldName !== "IsBulk"
                && e.focusedColumn.fieldName !== "Field1" && e.focusedColumn.fieldName !== "Field2" && e.focusedColumn.fieldName !== "Field3"
                && e.focusedColumn.fieldName !== "Field4" && e.focusedColumn.fieldName !== "Field5" && e.focusedColumn.fieldName !== "Field6"
                && e.focusedColumn.fieldName !== "Field7" && e.focusedColumn.fieldName !== "Field8" && e.focusedColumn.fieldName !== "Field9"
                && e.focusedColumn.fieldName !== "IsRounded") {
                e.cancel = true;
            }

            //if (e.focusedColumn.fieldName === "UnitCost" || e.focusedColumn.fieldName === "Components" ||
            //    e.focusedColumn.fieldName === "IsMajorMaterial" || e.focusedColumn.fieldName === "IsExcluded" ||
            //    e.focusedColumn.fieldName === "Consumption") {
            //    e.cancel = true;
            //}
        }
    }
    else if (aglType.GetValue() == "DELETE ITEM") {
        if (e.focusedColumn.fieldName !== "StepCode" && e.focusedColumn.fieldName !== "OldItemCode" && e.focusedColumn.fieldName !== "OldColorCode" &&
            e.focusedColumn.fieldName !== "OldClassCode" && e.focusedColumn.fieldName !== "OldSizeCode" && e.focusedColumn.fieldName !== "ProductSize"
            && e.focusedColumn.fieldName !== "Field1" && e.focusedColumn.fieldName !== "Field2" && e.focusedColumn.fieldName !== "Field3"
            && e.focusedColumn.fieldName !== "Field4" && e.focusedColumn.fieldName !== "Field5" && e.focusedColumn.fieldName !== "Field6"
            && e.focusedColumn.fieldName !== "Field7" && e.focusedColumn.fieldName !== "Field8" && e.focusedColumn.fieldName !== "Field9"
            && e.focusedColumn.fieldName !== "Components") {
            e.cancel = true;
        }
    }
    else if (aglType.GetValue() == "EXCLUDE ITEM") {
        if (e.focusedColumn.fieldName !== "StepCode" && e.focusedColumn.fieldName !== "OldItemCode" && e.focusedColumn.fieldName !== "OldColorCode" &&
            e.focusedColumn.fieldName !== "OldClassCode" && e.focusedColumn.fieldName !== "OldSizeCode" && e.focusedColumn.fieldName !== "ProductSize"
            && e.focusedColumn.fieldName !== "Field1" && e.focusedColumn.fieldName !== "Field2" && e.focusedColumn.fieldName !== "Field3"
            && e.focusedColumn.fieldName !== "Field4" && e.focusedColumn.fieldName !== "Field5" && e.focusedColumn.fieldName !== "Field6"
            && e.focusedColumn.fieldName !== "Field7" && e.focusedColumn.fieldName !== "Field8" && e.focusedColumn.fieldName !== "Field9"
            && e.focusedColumn.fieldName !== "Components") {
            e.cancel = true;
        }
    }
    else if (aglType.GetValue() == "INCLUDE ITEM") {
        if (e.focusedColumn.fieldName !== "StepCode" && e.focusedColumn.fieldName !== "OldItemCode" && e.focusedColumn.fieldName !== "OldColorCode" &&
            e.focusedColumn.fieldName !== "OldClassCode" && e.focusedColumn.fieldName !== "OldSizeCode" && e.focusedColumn.fieldName !== "ProductSize"
            && e.focusedColumn.fieldName !== "Field1" && e.focusedColumn.fieldName !== "Field2" && e.focusedColumn.fieldName !== "Field3"
            && e.focusedColumn.fieldName !== "Field4" && e.focusedColumn.fieldName !== "Field5" && e.focusedColumn.fieldName !== "Field6"
            && e.focusedColumn.fieldName !== "Field7" && e.focusedColumn.fieldName !== "Field8" && e.focusedColumn.fieldName !== "Field9"
            && e.focusedColumn.fieldName !== "Components") {
            e.cancel = true;
        }
    }
    else if (aglType.GetValue() == "MODIFY ITEM") {
        //if (e.focusedColumn.fieldName !== "StepCode" || e.focusedColumn.fieldName !== "OldItemCode" || e.focusedColumn.fieldName !== "OldColorCode" ||
        //    e.focusedColumn.fieldName !== "OldClassCode" || e.focusedColumn.fieldName !== "OldSizeCode" || e.focusedColumn.fieldName !== "ProductCode" ||
        //    e.focusedColumn.fieldName !== "ProductColor" || e.focusedColumn.fieldName !== "ProductSize" || e.focusedColumn.fieldName !== "NewItemCode" ||
        //    e.focusedColumn.fieldName !== "NewColorCode" || e.focusedColumn.fieldName !== "NewClassCode" || e.focusedColumn.fieldName !== "NewSizeCode" ||
        //    e.focusedColumn.fieldName !== "Unit" || e.focusedColumn.fieldName !== "Components" || e.focusedColumn.fieldName !== "PerPieceConsumption" ||
        //    e.focusedColumn.fieldName !== "Consumption" || e.focusedColumn.fieldName !== "AllowancePerc" || e.focusedColumn.fieldName !== "AllowanceQty" ||
        //    e.focusedColumn.fieldName !== "IsBulk" || e.focusedColumn.fieldName !== "IsMajorMaterial" || e.focusedColumn.fieldName !== "UnitCost"
        //    || e.focusedColumn.fieldName !== "Field1" || e.focusedColumn.fieldName !== "Field2" || e.focusedColumn.fieldName !== "Field3"
        //    || e.focusedColumn.fieldName !== "Field4" || e.focusedColumn.fieldName !== "Field5" || e.focusedColumn.fieldName !== "Field6"
        //    || e.focusedColumn.fieldName !== "Field7" || e.focusedColumn.fieldName !== "Field8" || e.focusedColumn.fieldName !== "Field9") {
        //    e.cancel = true;
        //}
        if (isbulk == true) {
            if (e.focusedColumn.fieldName === "LineNumber" && e.focusedColumn.fieldName === "IsExcluded"
                && e.focusedColumn.fieldName === "PerPieceConsumption" && e.focusedColumn.fieldName === "RequiredQty") {
                e.cancel = true;
            }
        }
        else {
            if (e.focusedColumn.fieldName === "LineNumber" && e.focusedColumn.fieldName === "IsExcluded"
                && e.focusedColumn.fieldName === "Consumption" && e.focusedColumn.fieldName === "RequiredQty") {
                e.cancel = true;
            }
        }
    }
    else if (aglType.GetValue() == "CHANGE UNITCOST") {
        if (e.focusedColumn.fieldName !== "StepCode" && e.focusedColumn.fieldName !== "OldItemCode" && e.focusedColumn.fieldName !== "OldColorCode"
            && e.focusedColumn.fieldName !== "OldClassCode" && e.focusedColumn.fieldName !== "OldSizeCode" && e.focusedColumn.fieldName !== "UnitCost"
            && e.focusedColumn.fieldName !== "ProductCode" && e.focusedColumn.fieldName !== "ProductColor" && e.focusedColumn.fieldName !== "ProductSize"
            && e.focusedColumn.fieldName !== "Field1" && e.focusedColumn.fieldName !== "Field2" && e.focusedColumn.fieldName !== "Field3"
            && e.focusedColumn.fieldName !== "Field4" && e.focusedColumn.fieldName !== "Field5" && e.focusedColumn.fieldName !== "Field6"
            && e.focusedColumn.fieldName !== "Field7" && e.focusedColumn.fieldName !== "Field8" && e.focusedColumn.fieldName !== "Field9"
            && e.focusedColumn.fieldName !== "Components") {
            e.cancel = true;
        }
    }
    else {
        e.cancel = true;
    }

    if (entry != "V") {
        if (e.focusedColumn.fieldName === "StepCode") {
            glStepCode.GetInputElement().value = cellInfo.value;
            isSetTextRequired = true;
            nope = false;
            closing = true;
        }
        if (e.focusedColumn.fieldName === "OldItemCode") {
            gl.GetInputElement().value = cellInfo.value;
            isSetTextRequired = true;
            nope = false;
            closing = true;
        }
        if (e.focusedColumn.fieldName === "OldColorCode") {
            gl2.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "OldClassCode") {
            gl3.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "OldSizeCode") {
            gl4.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "Unit") {
            gl5.GetInputElement().value = cellInfo.value;
        }
        if (e.focusedColumn.fieldName === "ProductCode") {
            glProductCode.GetInputElement().value = cellInfo.value;
        }
        if (e.focusedColumn.fieldName === "ProductColor") {
            glProductColor.GetInputElement().value = cellInfo.value;
        }
        if (e.focusedColumn.fieldName === "ProductSize") {
            glProductSize.GetInputElement().value = cellInfo.value;
        }
        if (e.focusedColumn.fieldName === "NewItemCode") {
            glN.GetInputElement().value = cellInfo.value;
            isSetTextRequired = true;
            nope = false;
            closing = true;
        }
        if (e.focusedColumn.fieldName === "NewColorCode") {
            gl2N.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "NewClassCode") {
            gl3N.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "NewSizeCode") {
            gl4N.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "Components") {
            glComponents.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }

    }
}

function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
    var cellInfo = e.rowValues[currentColumn.index];

    //var entry = getParameterByName('entry');

    if (currentColumn.fieldName === "StepCode") {
        cellInfo.value = glStepCode.GetValue();
        cellInfo.text = glStepCode.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "OldItemCode") {
        cellInfo.value = gl.GetValue();
        cellInfo.text = gl.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "OldColorCode") {
        cellInfo.value = gl2.GetValue();
        cellInfo.text = gl2.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "OldClassCode") {
        cellInfo.value = gl3.GetValue();
        cellInfo.text = gl3.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "OldSizeCode") {
        cellInfo.value = gl4.GetValue();
        cellInfo.text = gl4.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "Unit") {
        cellInfo.value = gl5.GetValue();
        cellInfo.text = gl5.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "ProductCode") {
        cellInfo.value = glProductCode.GetValue();
        cellInfo.text = glProductCode.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "ProductColor") {
        cellInfo.value = glProductColor.GetValue();
        cellInfo.text = glProductColor.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "ProductSize") {
        cellInfo.value = glProductSize.GetValue();
        cellInfo.text = glProductSize.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "NewItemCode") {
        cellInfo.value = glN.GetValue();
        cellInfo.text = glN.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "NewColorCode") {
        cellInfo.value = gl2N.GetValue();
        cellInfo.text = gl2N.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "NewClassCode") {
        cellInfo.value = gl3N.GetValue();
        cellInfo.text = gl3N.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "NewSizeCode") {
        cellInfo.value = gl4N.GetValue();
        cellInfo.text = gl4N.GetText().toUpperCase();
    }
    if (currentColumn.fieldName === "Components") {
        cellInfo.value = glComponents.GetValue();
        cellInfo.text = glComponents.GetText().toUpperCase();
    }
}



var val;
var temp;
var identifier;
var testinglang;
function GridEnd(s, e) {
    identifier = s.GetGridView().cp_identifier;
    val = s.GetGridView().cp_codes;
    //console.log(val + 'val');
    if (val != null) {
        temp = val.split(';');
        delete (s.GetGridView().cp_codes);
    }
    else {
        val = "";
        delete (s.GetGridView().cp_codes);
    }
    console.log('identifier ' + identifier)

    //if (identifier == 'sku') {

    //    if (s.keyFieldName == 'OldItemCode' && (itemc == null || itemc == '')) {
    //        s.SetText('');
    //    }
    //    else if (s.keyFieldName == 'OldItemCode' && (itemc != null && itemc != '')) {
    //        s.SetText(itemc);
    //    }

    //    if (s.keyFieldName == 'OldColorCode' && (itemclr == null || itemclr == '')) {
    //        s.SetText('');
    //    }
    //    else if (s.keyFieldName == 'OldColorCode' && (itemclr != null && itemclr != '')) {
    //        s.SetText(itemclr);
    //    }

    //    if (s.keyFieldName == 'OldClassCode' && (itemcls == null || itemcls == "")) {
    //        s.SetText('');
    //    }
    //    else if (s.keyFieldName == 'OldClassCode' && (itemcls != null && itemcls != '')) {
    //        s.SetText(itemcls);
    //    }

    //    if (s.keyFieldName == 'OldSizeCode' && (itemsze == null || itemsze == "")) {
    //        s.SetText('');
    //    }
    //    else if (s.keyFieldName == 'OldSizeCode' && (itemsze != null && itemsze != '')) {
    //        s.SetText(itemsze);
    //    }

    //    delete (s.GetGridView().cp_identifier);
    //}

    if (identifier == "skuN") {
        if (s.keyFieldName == 'NewItemCode' && (itemcN == null || itemcN == '')) {
            s.SetText('');
        }
        else if (s.keyFieldName == 'NewItemCode' && (itemcN != null && itemcN != '')) {
            s.SetText(itemcN);
        }

        if (s.keyFieldName == 'NewColorCode' && (itemclrN == null || itemclrN == '')) {
            s.SetText("");
        }
        else if (s.keyFieldName == 'NewColorCode' && (itemclrN != null && itemclrN != '')) {
            s.SetText(itemclrN);
        }

        if (s.keyFieldName == 'NewClassCode' && (itemclsN == null || itemclsN == "")) {
            s.SetText("");
        }
        else if (s.keyFieldName == 'NewClassCode' && (itemclsN != null && itemclsN != '')) {
            s.SetText(itemclsN);
        }

        if (s.keyFieldName == 'NewSizeCode' && (itemszeN == null || itemszeN == "")) {
            s.SetText("");
        }
        else if (s.keyFieldName == 'NewSizeCode' && (itemszeN != null && itemszeN != '')) {
            s.SetText(itemszeN);
        }
    }
    //else {
    //    s.SetText(s.GetInputElement().value);
    //}
    //else {
    //    s.SetText(s.GetInputElement().value);
    //}

    if (s.GetGridView().cp_valch) {
        delete (s.GetGridView().cp_valch);
        for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
            var column = gv1.GetColumn(i);
            if (column.visible == false || column.fieldName == undefined)
                continue;
            ProcessCells(0, e, column, gv1);
            gv1.batchEditApi.EndEdit();
        }
        loading = false;
        loader.Hide();
    }

    if (valchange2 && (val != null && val != 'undefined' && val != '')) {
        for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
            var column = gv1.GetColumn(i);
            if (column.visible == false || column.fieldName == undefined)
                continue;
            ProcessCells2(0, e, column, gv1);
            gv1.batchEditApi.EndEdit();
        }
        loading = false;
        loader.Hide();
    }

    if (valchange3 && (val != null && val != 'undefined' && val != '')) {
        for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
            var column = gv1.GetColumn(i);
            if (column.visible == false || column.fieldName == undefined)
                continue;
            ProcessCells3(0, e, column, gv1);
            gv1.batchEditApi.EndEdit();
        }
        loading = false;
        loader.Hide();
    }
            

    if (s.GetGridView().cp_noitem) {
        delete (s.GetGridView().cp_noitem);
        loading = false;
        loader.Hide();
        //s.batchEditApi.SetCellValue(index, "OldItemCode", null);
    }

    //if (s.GetGridView().cp_closelookup) {
    //    delete (s.GetGridView().cp_closelookup);
    //    console.log('ssss');
    //    gv1.batchEditApi.EndEdit();
    //}
}

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
    if (temp[10] == null) {
        temp[10] = "";
    }
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
    if (temp[16] == null) {
        temp[16] = "";
    }
    if (temp[17] == null) {
        temp[17] = "";
    }
    //console.log(Number(temp[6] == "" ? 0 : temp[6]));
    //console.log('val ' + val);

    if (selectedIndex == 0) {
        if (identifier == "item") {

            if (column.fieldName == "OldColorCode") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
            }
            if (column.fieldName == "OldClassCode") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[1]);
            }
            if (column.fieldName == "OldSizeCode") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[2]);
            }
            if (column.fieldName == "ProductCode") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[3]);
            }
            if (column.fieldName == "ProductColor") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[4]);
            }
            if (column.fieldName == "ProductSize") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[5]);
            }
            if (column.fieldName == "UnitCost") {
                s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[6] == "" ? 0 : temp[6]));
            }
            if (column.fieldName == "Components") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[7]);
            }
            if (column.fieldName == "PerPieceConsumption") {
                s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[8] == "" ? 0 : temp[8]));
            }
            if (column.fieldName == "Consumption") {
                s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[9] == "" ? 0 : temp[9]));
            }
            if (column.fieldName == "Unit") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[10]);
            }
            if (column.fieldName == "AllowancePerc") {
                s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[11] == "" ? 0 : temp[11]));
            }
            if (column.fieldName == "AllowanceQty") {
                s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[12] == "" ? 0 : temp[12]));
            }
            if (column.fieldName == "IsMajorMaterial") {
                console.log("rev");
                if (temp[13] == "True") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, true);
                }
                else {
                    s.batchEditApi.SetCellValue(index, column.fieldName, false);
                }
            }
            if (column.fieldName == "IsBulk") {
                if (temp[14] == "True") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, true);
                }
                else {
                    s.batchEditApi.SetCellValue(index, column.fieldName, false);
                }
            }
            if (column.fieldName == "IsExcluded") {
                if (temp[15] == "True") {
                    s.batchEditApi.SetCellValue(index, column.fieldName, true);
                }
                else {
                    s.batchEditApi.SetCellValue(index, column.fieldName, false);
                }
            }
            if (column.fieldName == "Components") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[16]);
            }
            if (column.fieldName == "RequiredQty") {
                s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[17] == "" ? 0 : temp[17]));
            }
        }

        //if (identifier == "size") {
        //    console.log(identifier)
        //    if (column.fieldName == "ProductCode") {
        //        s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
        //    }
        //    if (column.fieldName == "ProductColor") {
        //        s.batchEditApi.SetCellValue(index, column.fieldName, temp[1]);
        //    }
        //    if (column.fieldName == "ProductSize") {
        //        s.batchEditApi.SetCellValue(index, column.fieldName, temp[2]);
        //    }
        //    if (column.fieldName == "UnitCost") {
        //        s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[3] == "" ? 0 : temp[3]));
        //    }
        //    if (column.fieldName == "Components") {
        //        s.batchEditApi.SetCellValue(index, column.fieldName, temp[4]);
        //    }
        //    if (column.fieldName == "PerPieceConsumption") {
        //        s.batchEditApi.SetCellValue(index, column.fieldName, temp[5]);
        //    }
        //    if (column.fieldName == "Consumption") {
        //        s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[6] == "" ? 0 : temp[6]));
        //    }
        //    if (column.fieldName == "Unit") {
        //        s.batchEditApi.SetCellValue(index, column.fieldName, temp[7]);
        //    }
        //    if (column.fieldName == "AllowancePerc") {
        //        s.batchEditApi.SetCellValue(index, column.fieldName, temp[8]);
        //    }
        //    if (column.fieldName == "AllowanceQty") {
        //        s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[9] == "" ? 0 : temp[9]));
        //    }
        //    if (column.fieldName == "IsMajorMaterial") {
        //        if (temp[10] == "True") {
        //            s.batchEditApi.SetCellValue(index, column.fieldName, glIsMajorMaterial.SetChecked = true);
        //        }
        //        else {
        //            s.batchEditApi.SetCellValue(index, column.fieldName, glIsMajorMaterial.SetChecked = false);
        //        }
        //    }
        //    if (column.fieldName == "IsBulk") {
        //        if (temp[11] == "True") {
        //            s.batchEditApi.SetCellValue(index, column.fieldName, glIsBulk.SetChecked = true);
        //        }
        //        else {
        //            s.batchEditApi.SetCellValue(index, column.fieldName, glIsBulk.SetChecked = false);
        //        }
        //    }
        //    if (column.fieldName == "IsExcluded") {
        //        if (temp[12] == "True") {
        //            s.batchEditApi.SetCellValue(index, column.fieldName, glIsExcluded.SetChecked = true);
        //        }
        //        else {
        //            s.batchEditApi.SetCellValue(index, column.fieldName, glIsExcluded.SetChecked = false);
        //        }
        //    }
        //    if (column.fieldName == "Components") {
        //        s.batchEditApi.SetCellValue(index, column.fieldName, temp[13]);
        //    }
        //    if (column.fieldName == "RequiredQty") {
        //        s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[14] == "" ? 0 : temp[14]));
        //    }
        //}

        if (identifier == "itemN") {

            if (column.fieldName == "NewColorCode") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
            }
            if (column.fieldName == "NewClassCode") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[1]);
            }
            if (column.fieldName == "NewSizeCode") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[2]);
            }
            if (column.fieldName == "Unit") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[3]);
            }
            if (column.fieldName == "UnitCost") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[4]);
            }
            if (column.fieldName == "AllowancePerc") {
                s.batchEditApi.SetCellValue(index, column.fieldName, temp[5]);
            }
        }
        valchange = false;
    }
    //console.log('asd');
}

function ProcessCells2(selectedIndex, e, column, s) {
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
    if (temp[10] == null) {
        temp[10] = "";
    }
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

    if (selectedIndex == 0) {
        console.log(val + " 2ndto")
        if (column.fieldName == "ProductCode") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
        }
        if (column.fieldName == "ProductColor") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[1]);
        }
        if (column.fieldName == "ProductSize") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[2]);
        }
        if (column.fieldName == "UnitCost") {
            s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[3]));
        }
        if (column.fieldName == "Components") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[4]);
        }
        if (column.fieldName == "PerPieceConsumption") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[5]);
        }
        if (column.fieldName == "Consumption") {
            s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[6]));
        }
        if (column.fieldName == "Unit") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[7]);
        }
        if (column.fieldName == "AllowancePerc") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[8]);
        }
        if (column.fieldName == "AllowanceQty") {
            s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[9]));
        }
        if (column.fieldName == "IsMajorMaterial") {
            if (temp[10] == "True") {
                s.batchEditApi.SetCellValue(index, column.fieldName, true);
            }
            else {
                s.batchEditApi.SetCellValue(index, column.fieldName, false);
            }
        }
        if (column.fieldName == "IsBulk") {
            if (temp[11] == "True") {
                s.batchEditApi.SetCellValue(index, column.fieldName, true);
            }
            else {
                s.batchEditApi.SetCellValue(index, column.fieldName, false);
            }
        }
        if (column.fieldName == "IsExcluded") {
            if (temp[12] == "True") {
                s.batchEditApi.SetCellValue(index, column.fieldName, true);
            }
            else {
                s.batchEditApi.SetCellValue(index, column.fieldName, Sfalse);
            }
        }
        if (column.fieldName == "Components") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[13]);
        }
        if (column.fieldName == "RequiredQty") {
            s.batchEditApi.SetCellValue(index, column.fieldName, Number(temp[14]));
        }

        valchange2 = false;
    }
}

function ProcessCells3(selectedIndex, e, column, s) {
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


    if (selectedIndex == 0) {
        console.log(val + " 3Rdto")
        if (column.fieldName == "NewColorCode") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[0]);
        }
        if (column.fieldName == "NewClassCode") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[1]);
        }
        if (column.fieldName == "NewSizeCode") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[2]);
        }
        if (column.fieldName == "Unit") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[3]);
        }
        if (column.fieldName == "UnitCost") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[4]);
        }
        if (column.fieldName == "AllowancePerc") {
            s.batchEditApi.SetCellValue(index, column.fieldName, temp[5]);
        }
        valchange3 = false;
    }
}

function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
    for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
        var column = s.GetColumn(i);
        var chckd;
        var chckd2;

        //if (column.fieldName == "IsByBulk") {
        //    var cellValidationInfo = e.validationInfo[column.index];
        //    if (!cellValidationInfo) continue;
        //    var value = cellValidationInfo.value;               
        //    if (value == true) {
        //        chckd2 = true;
        //    }
        //}
        //if (column.fieldName == "IssuedBulkQty") {
        //    var cellValidationInfo = e.validationInfo[column.index];
        //    if (!cellValidationInfo) continue;
        //    var value = cellValidationInfo.value;
        //    //if ((!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == "0" || ASPxClientUtils.Trim(value) == null) && chckd2 == true) {
        //    if ((!ASPxClientUtils.IsExists(value) || value == "" || value == "0" || value == "0.00" || value == null) && chckd2 == true) {
        //        cellValidationInfo.isValid = false;
        //        cellValidationInfo.errorText = column.fieldName + " is required";
        //        isValid = false;
        //    }
        //}
        //console.log(e.cancel + ' ', column.fieldName)
        if (column.fieldName == "Components") {
            //console.log('here')
            var cellValidationInfo = e.validationInfo[column.index];
            if (!cellValidationInfo) continue;
            var value = cellValidationInfo.value;
            if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "" || ASPxClientUtils.Trim(value) == null) {
                cellValidationInfo.isValid = false;
                cellValidationInfo.errorText = column.fieldName + " is required";
                isValid = false;
            }
        }
    }

}

function lookup(s, e) {   
    if (isSetTextRequired) {//Sets the text during lookup for item 
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
        //
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        //gv1.batchEditApi.EndEdit();
    }

}

function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.

    gv1.batchEditApi.EndEdit();

}

function OnCustomClick(s, e) {
    if (e.buttonID == "Details") {
        if (aglType.GetValue() == "ADD ITEM" || aglType.GetValue() == "MODIFY ITEM") {
            var ItemCode = s.batchEditApi.GetCellValue(e.visibleIndex, "NewItemCode");
            var colorcode = s.batchEditApi.GetCellValue(e.visibleIndex, "NewColorCode");
            var ClassCode = s.batchEditApi.GetCellValue(e.visibleIndex, "NewClassCode");
            var SizeCode = s.batchEditApi.GetCellValue(e.visibleIndex, "NewSizeCode");
            var unitbase = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
            var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "");
            factbox.SetContentUrl('../FactBox/fbItem.aspx?ItemCode=' + ItemCode
            + '&colorcode=' + colorcode + '&ClassCode=' + ClassCode + '&SizeCode=' + SizeCode + '&unit=' + unitbase + '&Warehouse=');
        }
        else {
            var ItemCode1 = s.batchEditApi.GetCellValue(e.visibleIndex, "OldItemCode");
            var colorcode1 = s.batchEditApi.GetCellValue(e.visibleIndex, "OldColorCode");
            var ClassCode1 = s.batchEditApi.GetCellValue(e.visibleIndex, "OldClassCode");
            var SizeCode1 = s.batchEditApi.GetCellValue(e.visibleIndex, "OldSizeCode");
            var unitbase1 = s.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
            var fulldesc = s.batchEditApi.GetCellValue(e.visibleIndex, "");
            factbox.SetContentUrl('../FactBox/fbItem.aspx?ItemCode=' + ItemCode1
            + '&colorcode=' + colorcode1 + '&ClassCode=' + ClassCode1 + '&SizeCode=' + SizeCode1 + '&unit=' + unitbase1 + '&Warehouse=');
        }
        //else if (aglType.GetValue() == "CHANGE CONSUMPTION") {
        //}
        //else if (aglType.GetValue() == "DELETE ITEM") {
        //}
        //else if (aglType.GetValue() == "EXCLUDE ITEM") {
        //}
        //else if (aglType.GetValue() == "INCLUDE ITEM") {
        //}
        //else if (aglType.GetValue() == "MODIFY ITEM") {
        //}
        //else if (aglType.GetValue() == "CHANGE UNITCOST") {
        //}
        //else {
        //}
    }
    if (e.buttonID == "Delete") {
        gv1.DeleteRow(e.visibleIndex);
        autocalculate();
    }
    if (e.buttonID == "ViewTransaction") {

        var transtype = s.batchEditApi.GetCellValue(e.visibleIndex, "TransType");
        var docnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "DocNumber");
        var commandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "CommandString");

        window.open(commandtring + '?entry=V&transtype=' + transtype + '&parameters=&iswithdetail=true&docnumber=' + docnumber, '_blank', "", false);
        console.log('ViewTransaction')
    }
    if (e.buttonID == "CountSheet") {
        CSheet.Show();
        var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
        var docnumber = getParameterByName('docnumber');
        var transtype = getParameterByName('transtype');
        var entry = getParameterByName('entry');
        CSheet.SetContentUrl('../WMS/frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
            '&linenumber=' + linenum);
    }

}


function endcp(s, e) {
    var endg = s.GetGridView().cp_endgl1;
    if (endg == true) {
        console.log(endg);
        e.processOnServer = false;
        endg = null;
    }
}

Number.prototype.format = function (d, w, s, c) {
    var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
        num = this.toFixed(Math.max(0, ~~d));

    return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
};


function autocalculate(s, e) {
    //console.log('autocalculate')
    OnInitTrans();

    setTimeout(function () {

        var iBOM = gv1.batchEditApi.GetRowVisibleIndices();
        var cnt = iBOM.length;
        var BIndex = BOMIndex;
        var PrIsRounded;

        if (gv1.batchEditApi.IsNewRow(BIndex)) {
            var aCons = 0.000000;
            var aPerc = 0.000000;
            var aReq;

            PrIsRounded = gv1.batchEditApi.GetCellValue(BIndex, "IsRounded");
            if (PrIsRounded == true) {
                aCons = gv1.batchEditApi.GetCellValue(BIndex, "Consumption");
                aCons = Math.ceil(aCons);
                gv1.batchEditApi.SetCellValue(BIndex, "Consumption", aCons);
            }
            else {
                aCons = gv1.batchEditApi.GetCellValue(BIndex, "Consumption");
            }
            
            aPerc = gv1.batchEditApi.GetCellValue(BIndex, "AllowancePerc");
            aCons = aCons == null ? 0 : aCons;
            aPerc = aPerc == null ? 0 : aPerc;
            //aReq = Number(aCons) + Number(aCons * (aPerc * 0.01))
            aCons = parseFloat(aCons);
            aCons = aCons.toFixed(6);
            //aReq = parseFloat(aReq);
            if (PrIsRounded == true) {
                gv1.batchEditApi.SetCellValue(BIndex, "AllowanceQty", Math.ceil((parseFloat(aCons) * (aPerc * 0.01)).toFixed(6)));
            }
            else {
                gv1.batchEditApi.SetCellValue(BIndex, "AllowanceQty", (parseFloat(aCons) * (aPerc * 0.01)).toFixed(6));
            }

            aReq = gv1.batchEditApi.GetCellValue(BIndex, "AllowanceQty");
            aReq = aReq == null ? 0 : aReq;
            aReq = parseFloat(aReq);
            aReq = aReq.toFixed(6);
            console.log(parseFloat(aCons) + parseFloat(aReq));
            gv1.batchEditApi.SetCellValue(BIndex, "RequiredQty", (parseFloat(aCons) + parseFloat(aReq)).toFixed(6));
        }
        else {
            var key = gv1.GetRowKey(BIndex);
            if (gv1.batchEditApi.IsDeletedRow(key)) {
                console.log("deleted row " + BIndex);
            }
            else {
                var aCons = 0.000000;
                var aPerc = 0.000000;
                var aReq = 0.000000;


                PrIsRounded = gv1.batchEditApi.GetCellValue(BIndex, "IsRounded");
                console.log(BIndex)
                if (PrIsRounded == true) {
                    aCons = gv1.batchEditApi.GetCellValue(BIndex, "Consumption");
                    aCons = Math.ceil(aCons);
                    aCons = parseFloat(aCons);
                    gv1.batchEditApi.SetCellValue(BIndex, "Consumption", aCons);
                }
                else {
                    aCons = gv1.batchEditApi.GetCellValue(BIndex, "Consumption");
                    aCons = parseFloat(aCons);
                }
                aPerc = gv1.batchEditApi.GetCellValue(BIndex, "AllowancePerc");
                aCons = aCons == null ? 0 : aCons;
                aPerc = aPerc == null ? 0 : aPerc;
                //aReq = Number(aCons) + Number(aCons * (aPerc * 0.01))
                aCons = parseFloat(aCons);
                aCons = aCons.toFixed(6);

                //if (PrIsRounded == true) {
                //    gv1.batchEditApi.SetCellValue(BIndex, "AllowanceQty", Math.ceil((aCons * (aPerc * 0.01)).toFixed(6)));
                //}
                //else {
                //    gv1.batchEditApi.SetCellValue(BIndex, "AllowanceQty", (aCons * (aPerc * 0.01)).toFixed(6));
                //}
                if (PrIsRounded == true) {
                    gv1.batchEditApi.SetCellValue(BIndex, "AllowanceQty", Math.ceil((parseFloat(aCons) * (aPerc * 0.01)).toFixed(6)));
                }
                else {
                    gv1.batchEditApi.SetCellValue(BIndex, "AllowanceQty", (parseFloat(aCons) * (aPerc * 0.01)).toFixed(6));
                }
                
                aReq = gv1.batchEditApi.GetCellValue(BIndex, "AllowanceQty");
                aReq = aReq == null ? 0 : aReq;
                aReq = parseFloat(aReq);
                aReq = aReq.toFixed(6);
                console.log(parseFloat(aCons) + parseFloat(aReq));
                gv1.batchEditApi.SetCellValue(BIndex, "RequiredQty", (parseFloat(aCons) + parseFloat(aReq)).toFixed(6));
            }
        }

    }, 500);
}

function autocalculate_req(s, e) {
    console.log('autocalculate')
    OnInitTrans();

    var Cons = 0.00;
    var AllowQty = 0.00;
    var Required = 0.00;

    setTimeout(function () {
        var indicies = gv1.batchEditApi.GetRowVisibleIndices();
        var cnt = indicies.length;
        var BIndex = BOMIndex + cnt;

        if (aglType.GetValue() == "ADD ITEM" || aglType.GetValue() == "CHANGE CONSUMPTION" || aglType.GetValue() == "MODIFY ITEM") {
            if (gv1.batchEditApi.IsNewRow(indicies[BIndex])) {

                Cons = gv1.batchEditApi.GetCellValue(indicies[BIndex], "Consumption");
                AllowQty = gv1.batchEditApi.GetCellValue(indicies[BIndex], "AllowanceQty");
                Required = Number(Cons) + Number(AllowQty);

                gv1.batchEditApi.SetCellValue(indicies[BIndex], "RequiredQty", (Required).toFixed(6));

            }
            else {
                var key = gv1.GetRowKey(indicies[BIndex]);
                if (gv1.batchEditApi.IsDeletedRow(key)) {
                    console.log("deleted row " + indicies[BIndex]);
                }
                else {
                    Cons = gv1.batchEditApi.GetCellValue(indicies[BIndex], "Consumption");
                    AllowQty = gv1.batchEditApi.GetCellValue(indicies[BIndex], "AllowanceQty");
                    Required = Number(Cons) + Number(AllowQty);

                    gv1.batchEditApi.SetCellValue(indicies[BIndex], "RequiredQty", (Required).toFixed(6));
                }
            }
        }

    }, 500);
}

function autocalculate3(s,e) {
    console.log(s.cp_qty);
    var aqty = s.cp_qty;
    gv1.batchEditApi.SetCellValue(BOMIndex, 'Consumption', (gv1.batchEditApi.GetCellValue(BOMIndex, 'PerPieceConsumption') * aqty));
    delete (s.cp_qty);
    autocalculate();
}

function OnGetRowValues(values) {
    console.log(values);
}

function deleteRows() {
    var indicies = gv1.batchEditApi.GetRowVisibleIndices();
    for (var w = 0; w < indicies.length; w++) {
        gv1.DeleteRow(indicies[w]);
    }
}

function resetbomdetail() {
    gv1.batchEditApi.EndEdit();
    gv1.batchEditApi.SetCellValue(index, 'OldItemCode', null);
    gv1.batchEditApi.SetCellValue(index, 'OldColorCode', null);
    gv1.batchEditApi.SetCellValue(index, 'OldClassCode', null);
    gv1.batchEditApi.SetCellValue(index, 'OldSizeCode', null);
    gv1.batchEditApi.SetCellValue(index, 'ProductCode', null);
    gv1.batchEditApi.SetCellValue(index, 'ProductColor', null);
    gv1.batchEditApi.SetCellValue(index, 'ProductSize', null);
    gv1.batchEditApi.SetCellValue(index, 'NewItemCode', null);
    gv1.batchEditApi.SetCellValue(index, 'NewColorCode', null);
    gv1.batchEditApi.SetCellValue(index, 'NewClassCode', null);
    gv1.batchEditApi.SetCellValue(index, 'NewSizeCode', null);
    gv1.batchEditApi.SetCellValue(index, 'Unit', null);
    gv1.batchEditApi.SetCellValue(index, 'Components', null);
    gv1.batchEditApi.SetCellValue(index, 'PerPieceConsumption', null);
    gv1.batchEditApi.SetCellValue(index, 'Consumption', null);
    gv1.batchEditApi.SetCellValue(index, 'AllowancePerc', null);
    gv1.batchEditApi.SetCellValue(index, 'AllowanceQty', null);
    gv1.batchEditApi.SetCellValue(index, 'RequiredQty', null);
    //gv1.batchEditApi.SetCellValue(index, 'IsBulk', false);
    //gv1.batchEditApi.SetCellValue(index, 'IsMajorMaterial', false);
    //gv1.batchEditApi.SetCellValue(index, 'IsExcluded', false);
    //gv1.batchEditApi.SetCellValue(index, 'IsRounded', false);
    gv1.batchEditApi.SetCellValue(index, 'UnitCost', null);
}