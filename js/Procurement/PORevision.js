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
    console.log(counterror  )
}

function OnUpdateClick(s, e) { //Add/Edit/Close button function
    var btnmode = btn.GetText(); //gets text of button
    if (btnmode == "Delete") {
        cp.PerformCallback("Delete");
    }
    if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
        //Sends request to server side
        console.log(counterror, " jasgdajsd");
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
    if (s.cp_success) {
        alert(s.cp_message);
        delete (s.cp_success);//deletes cache variables' data
        delete (s.cp_message);

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
        autocalculate();
    }

}

var itemc; //variable required for lookup
var currentColumn = null;
var isSetTextRequired = false;
var linecount = 1;
var editorobj;
function OnStartEditing(s, e) {//On start edit grid function     
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for
    //if (e.visibleIndex < 0) {//new row
    //    var linenumber = s.GetColumnByField("LineNumber");
    //    e.rowValues[linenumber.index].value = linecount++; // or any other default value
    //}

    if (e.focusedColumn.fieldName == "ItemDescription" || e.focusedColumn.fieldName == "OldOrderQty") {
        e.cancel = true;
    }

    var entry = getParameterByName('entry');
    if (entry == "V") {
        e.cancel = true; //this will made the gridview readonly
    }

    editorobj = e;

    if (entry != "V") {
        if (e.focusedColumn.fieldName === "ItemCode") { //Check the column name
            gl.GetInputElement().value = cellInfo.value; //Gets the column value
            isSetTextRequired = true;
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
        if (e.focusedColumn.fieldName === "ItemCode" || e.focusedColumn.fieldName === "ColorCode" ||
                e.focusedColumn.fieldName === "ClassCode" || e.focusedColumn.fieldName === "SizeCode" ||
                e.focusedColumn.fieldName === "OldUnitCost" || e.focusedColumn.fieldName === "Unit" ||
                e.focusedColumn.fieldName === "BaseQty" || e.focusedColumn.fieldName === "BaseQty" ||
                e.focusedColumn.fieldName === "UnitCost" || e.focusedColumn.fieldName === "OldServiceQty" ||
                e.focusedColumn.fieldName === "IsVat" || e.focusedColumn.fieldName === "VatCode" ||
                e.focusedColumn.fieldName === "ProgressBilling") {
            e.cancel = true;
        }
    }
}

function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
    var cellInfo = e.rowValues[currentColumn.index];
    if (currentColumn.fieldName === "ItemCode") {
        cellInfo.value = gl.GetValue();
        cellInfo.text = gl.GetText();
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
}
function autocalculate(s, e) { 
    OnInitTrans();
    var orderqty = 0;
    var totalqty = 0;
    var orderqty1 = 0;
    var totalqty1 = 0;


    setTimeout(function () {
        for (var i = 0; i < gv1.GetVisibleRowsOnPage() ; i++) {
            orderqty = gv1.batchEditApi.GetCellValue(i, "OrderQty");
            totalqty += orderqty;
        }

        var indicies = gvService.batchEditApi.GetRowVisibleIndices(); 
        for (var i = 0; i < indicies.length; i++) {
            if (gvService.batchEditApi.IsNewRow(indicies[i])) {
                orderqty1 = gvService.batchEditApi.GetCellValue(i, "NewServiceQty");
                totalqty1 += orderqty1;
                console.log()
            }
            else { //Existing Rows
                var key = gvService.GetRowKey(indicies[i]);
                if (gvService.batchEditApi.IsDeletedRow(key)) {
                    var sas;
                }
                else {
                    orderqty1 = gvService.batchEditApi.GetCellValue(i, "NewServiceQty");
                    totalqty1 += orderqty1;
                }
            }
        }  
        txtQty.SetText(totalqty + totalqty1);

    }, 1000);
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
    if (keyCode == ASPxKey.Enter)
        gv1.batchEditApi.EndEdit();
    //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
}

function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
    gv1.batchEditApi.EndEdit();
}

//validation
function Grid_BatchEditRowValidating(s, e) {//Client side validation. Check empty fields. (only visible fields)
    //for (var i = 0; i < gv1.GetColumnsCount() ; i++) {
    //    var column = s.GetColumn(i);
    //    if (column != s.GetColumn(6) && column != s.GetColumn(1) && column != s.GetColumn(7) && column != s.GetColumn(5) && column != s.GetColumn(8) && column != s.GetColumn(9) && column != s.GetColumn(10) && column != s.GetColumn(11) && column != s.GetColumn(12) && column != s.GetColumn(13) && column != s.GetColumn(14) && column != s.GetColumn(15) && column != s.GetColumn(16) && column != s.GetColumn(17) && column != s.GetColumn(18) && column != s.GetColumn(19) && column != s.GetColumn(20) && column != s.GetColumn(21) && column != s.GetColumn(22) && column != s.GetColumn(23) && column != s.GetColumn(24) && column != s.GetColumn(13)) {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
    //        var cellValidationInfo = e.validationInfo[column.index];
    //        if (!cellValidationInfo) continue;
    //        var value = cellValidationInfo.value;
    //        if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) == "") {
    //            cellValidationInfo.isValid = false;
    //            cellValidationInfo.errorText = column.fieldName + " is required";
    //            isValid = false;
    //        }
    //        else {
    //            isValid = true;
    //        }
    //    }
    //}
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
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

    if (e.buttonID == "CountSheet") {
        CSheet.Show();
        var linenum = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
        var docnumber = getParameterByName('docnumber');
        var transtype = getParameterByName('transtype');
        var entry = getParameterByName('entry');
        CSheet.SetContentUrl('../wms/frmCountSheet.aspx?entry=' + entry + '&docnumber=' + docnumber + '&transtype=' + transtype +
             '&linenumber=' + linenum);
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
   
    }
    if (e.buttonID == "ViewReferenceTransaction") {

        var rtranstype = s.batchEditApi.GetCellValue(e.visibleIndex, "RTransType");
        var rdocnumber = s.batchEditApi.GetCellValue(e.visibleIndex, "REFDocNumber");
        var rcommandtring = s.batchEditApi.GetCellValue(e.visibleIndex, "RCommandString");
        window.open(rcommandtring + '?entry=V&transtype=' + rtranstype + '&parameters=&iswithdetail=true&docnumber=' + rdocnumber, '_blank');
      
    }
}
function Generate(s, e) {
    var generate = confirm("Are you sure that you want to generate this PO?");
    if (generate) {
        cp.PerformCallback('Generate');
    }
}

function OnInitTrans(s, e) { 
    var BizPartnerCode = glSupplierCode.GetText(); 
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
    gvService.SetWidth(width - 120);
}

//function AdjustSize(s, e) {
//    setTimeout(function () { 
//        var indicies = gvService.batchEditApi.GetRowVisibleIndices();
//        for (var i = 0; i < indicies.length; i++) { 
//            gvService.DeleteRow(indicies[i]); 
//        } 
//    }, 500); 

//    gvService.SelectAllRowsOnPage();
//    var str = gvService.GetSelectedKeysOnPage();
    
//    for (var i = 0; i < str.length; i++) {
//        var str2 = str[i].split("|");
//        gvService.AddNewRow();
//        getCol(gvService, editorobj, str2);
//    }
//    //calccost();
//    //CINMultiplePR.SetEnabled(true);
//}

//function getCol(ss, ee, item) {
//    for (var i = 0; i < gvService.GetColumnsCount() ; i++) {
//        var column = gvService.GetColumn(i);
//        if (column.visible == false || column.fieldName == undefined)
//            continue;
//        Bindgrid(item, ee, column, ss);
//    }
//}

//function Bindgrid(item, e, column, s) { 
//    if (column.fieldName == "LineNumber") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[1]);
//    }
//    if (column.fieldName == "Service") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[2]);
//    }
//    if (column.fieldName == "OldServiceQty") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, Math.abs(item[4]));
//    }
//    if (column.fieldName == "NewServiceQty") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, Math.abs(item[5]));
//    }
//    if (column.fieldName == "Unit") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[6]);
//    }
//    if (column.fieldName == "OldUnitCost") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, Math.abs(item[7]));
//    }
//    if (column.fieldName == "NewUnitCost") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, Math.abs(item[8]));
//    }
//    if (column.fieldName == "OldTotalCost") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, Math.abs(item[9]));
//    }
//    if (column.fieldName == "NewTotalCost") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, Math.abs(item[10]));
//    }
//    if (column.fieldName == "AllowProgressBilling") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[11] == "False" ? false : true);
//    }
//    if (column.fieldName == "VatLiable") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[12] == "False" ? false : true);
//    }
//    if (column.fieldName == "VatCode") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[13]);
//    }
//    if (column.fieldName == "Field1") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[14]);
//    }
//    if (column.fieldName == "Field2") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[15]);
//    }
//    if (column.fieldName == "Field3") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[16]);
//    }
//    if (column.fieldName == "Field4") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[17]);
//    }
//    if (column.fieldName == "Field5") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[18]);
//    }
//    if (column.fieldName == "Field6") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[19]);
//    }
//    if (column.fieldName == "Field7") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[20]);
//    }
//    if (column.fieldName == "Field8") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[21]);
//    }
//    if (column.fieldName == "Field9") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[22]);
//    }
//    if (column.fieldName == "Description") {
//        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[3]);
//    }
//}

function calccost(s, e) {
    var sQty;
    var unitcost;
    //var exchangerate = CINExchangeRate.GetText();
    //exchangerate = exchangerate == null ? 0 : exchangerate;
    var totalqty = 0;
    //

    setTimeout(function () { //New Rows
        var indicies = gvService.batchEditApi.GetRowVisibleIndices();

        for (var i = 0; i < indicies.length; i++) {
            if (gvService.batchEditApi.IsNewRow(indicies[i])) {
                sQty = gvService.batchEditApi.GetCellValue(indicies[i], "NewServiceQty");
                sQty = sQty == null ? 0 : sQty;
                unitcost = gvService.batchEditApi.GetCellValue(indicies[i], "NewUnitCost");
                unitcost = unitcost == null ? 0 : unitcost;
                totalqty = sQty * (unitcost * 1);
                gvService.batchEditApi.SetCellValue(indicies[i], "NewTotalCost", totalqty);
            }
            else { //Existing Rows
                var key = gvService.GetRowKey(indicies[i]);
                if (gvService.batchEditApi.IsDeletedRow(key)) {
                    var sas;
                }
                else {
                    sQty = gvService.batchEditApi.GetCellValue(indicies[i], "NewServiceQty");
                    sQty = sQty == null ? 0 : sQty;
                    unitcost = gvService.batchEditApi.GetCellValue(indicies[i], "NewUnitCost");
                    unitcost = unitcost == null ? 0 : unitcost;

                    totalqty = (sQty * (unitcost * 1));
                    gvService.batchEditApi.SetCellValue(indicies[i], "NewTotalCost", totalqty);
                }
            }
        }

        autocalculate();
    }, 500); 
}

var transtype = getParameterByName('transtype');
function onload() {
    fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + txtDocnumber.GetText() + '&transtype=' + transtype);
}