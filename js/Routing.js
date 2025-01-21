$(document).ready(function () {
    AdjustSize();
});

var index;
var closing;
var itemc; //variable required for lookup
var valchange = false;
var valchange_VAT = false;
var currentColumn = null;
var isSetTextRequired = false;
var linecount = 1;
var editorobj;
var SKUCode;
var isValid = true;
var counterror = 0;
var disabled = 0;

// Header event START

// SKUCode valuechanged event
function UpdateSKUDescription(values) {
    txtDescripton.SetText(values[1]);
    txtLocation.SetText(values[2]);
}

// CustomerCode valuechanged event
function UpdateCustomerName(value) {
    CustomerName.SetText(value);
}
// Header event END

// StepCode valuechanged event
function UpdateStepCode(values) {
    gvStepProcess.batchEditApi.EndEdit();
    gvStepProcess.batchEditApi.SetCellValue(index, "StepCode", values[0]);
    gvStepProcess.batchEditApi.SetCellValue(index, "StepDescription", values[1]);
    gvStepProcess.batchEditApi.SetCellValue(index, "IsBackFlush", values[2]);
}
function UpdateStepCode1(values) {
    gvStepProcess1.batchEditApi.EndEdit();
    gvStepProcess1.batchEditApi.SetCellValue(index, "StepCode", values[0]);
    gvStepProcess1.batchEditApi.SetCellValue(index, "StepDescription", values[1]);
    gvStepProcess1.batchEditApi.SetCellValue(index, "IsBackFlush", values[2]);
}
function UpdateStepCode2(value) {
    gvOtherMaterial.batchEditApi.EndEdit();
    gvOtherMaterial.batchEditApi.SetCellValue(index, "StepCode", value);
}

function OnValidation(s, e) {
    var item = e.value;
    if (item == null || item == "")
        e.isValid = false;
}  

// ItemCode valuechanged event
function UpdateItemCodeBOM(values) {
    gvStepBOM.batchEditApi.EndEdit();
    gvStepBOM.batchEditApi.SetCellValue(index, "ItemCode", values[0]);
    gvStepBOM.batchEditApi.SetCellValue(index, "Description", values[1]);
    gvStepBOM.batchEditApi.SetCellValue(index, "Unit", values[2]);
    gvStepBOM.batchEditApi.SetCellValue(index, "StandardUsage", values[3]);
    gvStepBOM.batchEditApi.SetCellValue(index, "StandardUsageUnit", values[2]);
}

function UpdateItemCodeBOM1(values) {
    gvStepBOM1.batchEditApi.EndEdit();
    gvStepBOM1.batchEditApi.SetCellValue(index, "ItemCode", values[0]);
    gvStepBOM1.batchEditApi.SetCellValue(index, "Description", values[1]);
    gvStepBOM1.batchEditApi.SetCellValue(index, "Unit", values[2]);
    gvStepBOM1.batchEditApi.SetCellValue(index, "StandardUsage", values[3]);
    gvStepBOM1.batchEditApi.SetCellValue(index, "StandardUsageUnit", values[2]);
}

// gvSTEPBOM START
function percentage(s, e) {

    setTimeout(function () {
        var PercentageAllowance = gvStepBOM.batchEditApi.GetCellValue(index, "PercentageAllowance") != "" ? gvStepBOM.batchEditApi.GetCellValue(index, "PercentageAllowance") : 0;
        PercentageAllowance = PercentageAllowance / 100;

        gvStepBOM.batchEditApi.SetCellValue(index, "PercentageAllowance", PercentageAllowance);

        calculate();
    }, 400);
}

function calculate(s, e) {
    setTimeout(function () {
        var indicies = gvStepBOM.batchEditApi.GetRowVisibleIndices();

        for (var i = 0; i < indicies.length; i++) {
            if (gvStepBOM.batchEditApi.IsNewRow(indicies[i])) {
                var TotalConsumption = gvStepBOM.batchEditApi.GetCellValue(indicies[i], "TotalConsumption") != "" ? gvStepBOM.batchEditApi.GetCellValue(indicies[i], "TotalConsumption") : 0;
                var PercentageAllowance = gvStepBOM.batchEditApi.GetCellValue(indicies[i], "PercentageAllowance") != "" ? gvStepBOM.batchEditApi.GetCellValue(indicies[i], "PercentageAllowance") : 0;
                var ConsumptionPerProduct = (TotalConsumption != 0 && ExpectedOutputQty.GetValue() != 0) ? (TotalConsumption / (ExpectedOutputQty.GetValue() != "" ? ExpectedOutputQty.GetValue() : 0)) : 0;
                var QtyAllowance = TotalConsumption * PercentageAllowance;
                var StandardUsage = TotalConsumption + QtyAllowance;

                gvStepBOM.batchEditApi.SetCellValue(indicies[i], "ConsumptionPerProduct", ConsumptionPerProduct);
                gvStepBOM.batchEditApi.SetCellValue(indicies[i], "QtyAllowance", QtyAllowance);
                gvStepBOM.batchEditApi.SetCellValue(indicies[i], "StandardUsage", StandardUsage);
            }
            else {
                var TotalConsumption = gvStepBOM.batchEditApi.GetCellValue(indicies[i], "TotalConsumption") != "" ? gvStepBOM.batchEditApi.GetCellValue(indicies[i], "TotalConsumption") : 0;
                var PercentageAllowance = gvStepBOM.batchEditApi.GetCellValue(indicies[i], "PercentageAllowance") != "" ? gvStepBOM.batchEditApi.GetCellValue(indicies[i], "PercentageAllowance") : 0;
                var ConsumptionPerProduct = TotalConsumption / (ExpectedOutputQty.GetValue() != "" ? ExpectedOutputQty.GetValue() : 0);
                var QtyAllowance = TotalConsumption * PercentageAllowance;
                var StandardUsage = TotalConsumption + QtyAllowance;

                gvStepBOM.batchEditApi.SetCellValue(indicies[i], "ConsumptionPerProduct", ConsumptionPerProduct);
                gvStepBOM.batchEditApi.SetCellValue(indicies[i], "QtyAllowance", QtyAllowance);
                gvStepBOM.batchEditApi.SetCellValue(indicies[i], "StandardUsage", StandardUsage);
            }
        }
    }, 500);
}
// gvSTEPBOM END


// gvSTEPBOM1 START
function percentage1(s, e) {
    setTimeout(function () {
        var PercentageAllowance = gvStepBOM1.batchEditApi.GetCellValue(index, "PercentageAllowance") != "" ? gvStepBOM1.batchEditApi.GetCellValue(index, "PercentageAllowance") : 0;
        PercentageAllowance = PercentageAllowance / 100;

        gvStepBOM1.batchEditApi.SetCellValue(index, "PercentageAllowance", PercentageAllowance);

        calculate1();
    }, 400);
}

function calculate1(s, e) {
    setTimeout(function () {
        var indicies = gvStepBOM1.batchEditApi.GetRowVisibleIndices();

        for (var i = 0; i < indicies.length; i++) {
            if (gvStepBOM1.batchEditApi.IsNewRow(indicies[i])) {
                var TotalConsumption = gvStepBOM1.batchEditApi.GetCellValue(indicies[i], "TotalConsumption") != "" ? gvStepBOM1.batchEditApi.GetCellValue(indicies[i], "TotalConsumption") : 0;
                var PercentageAllowance = gvStepBOM1.batchEditApi.GetCellValue(indicies[i], "PercentageAllowance") != "" ? gvStepBOM1.batchEditApi.GetCellValue(indicies[i], "PercentageAllowance") : 0;
                var ConsumptionPerProduct = (TotalConsumption != 0 && ExpectedOutputQty.GetValue() != 0) ? (TotalConsumption / (ExpectedOutputQty.GetValue() != "" ? ExpectedOutputQty.GetValue() : 0)) : 0;
                var QtyAllowance = TotalConsumption * PercentageAllowance;
                var StandardUsage = TotalConsumption + QtyAllowance;

                gvStepBOM1.batchEditApi.SetCellValue(indicies[i], "ConsumptionPerProduct", ConsumptionPerProduct);
                gvStepBOM1.batchEditApi.SetCellValue(indicies[i], "QtyAllowance", QtyAllowance);
                gvStepBOM1.batchEditApi.SetCellValue(indicies[i], "StandardUsage", StandardUsage);
            }
            else {
                var TotalConsumption = gvStepBOM1.batchEditApi.GetCellValue(indicies[i], "TotalConsumption") != "" ? gvStepBOM1.batchEditApi.GetCellValue(indicies[i], "TotalConsumption") : 0;
                var PercentageAllowance = gvStepBOM1.batchEditApi.GetCellValue(indicies[i], "PercentageAllowance") != "" ? gvStepBOM1.batchEditApi.GetCellValue(indicies[i], "PercentageAllowance") : 0;
                var ConsumptionPerProduct = TotalConsumption / (ExpectedOutputQty.GetValue() != "" ? ExpectedOutputQty.GetValue() : 0) || parseFloat(0);
                var QtyAllowance = TotalConsumption * PercentageAllowance;
                var StandardUsage = TotalConsumption + QtyAllowance;

                gvStepBOM1.batchEditApi.SetCellValue(indicies[i], "ConsumptionPerProduct", ConsumptionPerProduct);
                gvStepBOM1.batchEditApi.SetCellValue(indicies[i], "QtyAllowance", QtyAllowance);
                gvStepBOM1.batchEditApi.SetCellValue(indicies[i], "StandardUsage", StandardUsage);
            }
        }
    }, 500);
}
// gvSTEPBOM1 END


// gvOtherMaterial START
function percentage2(s, e) {
    setTimeout(function () {
        var PercentageAllowance = gvOtherMaterial.batchEditApi.GetCellValue(index, "PercentageAllowance") != "" ? gvOtherMaterial.batchEditApi.GetCellValue(index, "PercentageAllowance") : 0;
        PercentageAllowance = PercentageAllowance / 100;

        gvOtherMaterial.batchEditApi.SetCellValue(index, "PercentageAllowance", PercentageAllowance);

        calculate2();
    }, 400);
}

function calculate2(s, e) {
    setTimeout(function () {
        var indicies = gvOtherMaterial.batchEditApi.GetRowVisibleIndices();

        for (var i = 0; i < indicies.length; i++) {
            if (gvOtherMaterial.batchEditApi.IsNewRow(indicies[i])) {
                var TotalConsumption = gvOtherMaterial.batchEditApi.GetCellValue(indicies[i], "TotalConsumption") != "" ? gvOtherMaterial.batchEditApi.GetCellValue(indicies[i], "TotalConsumption") : 0;
                var PercentageAllowance = gvOtherMaterial.batchEditApi.GetCellValue(indicies[i], "PercentageAllowance") != "" ? gvOtherMaterial.batchEditApi.GetCellValue(indicies[i], "PercentageAllowance") : 0;
                var ConsumptionPerProduct = (TotalConsumption != 0 && ExpectedOutputQty.GetValue() != 0) ? (TotalConsumption / (ExpectedOutputQty.GetValue() != "" ? ExpectedOutputQty.GetValue() : 0)) : 0;
                var QtyAllowance = TotalConsumption * PercentageAllowance;
                var StandardUsage = TotalConsumption + QtyAllowance;

                gvOtherMaterial.batchEditApi.SetCellValue(indicies[i], "ConsumptionPerProduct", ConsumptionPerProduct);
                gvOtherMaterial.batchEditApi.SetCellValue(indicies[i], "QtyAllowance", QtyAllowance);
                gvOtherMaterial.batchEditApi.SetCellValue(indicies[i], "StandardUsage", StandardUsage);
            }
            else {
                var TotalConsumption = gvOtherMaterial.batchEditApi.GetCellValue(indicies[i], "TotalConsumption") != "" ? gvOtherMaterial.batchEditApi.GetCellValue(indicies[i], "TotalConsumption") : 0;
                var PercentageAllowance = gvOtherMaterial.batchEditApi.GetCellValue(indicies[i], "PercentageAllowance") != "" ? gvOtherMaterial.batchEditApi.GetCellValue(indicies[i], "PercentageAllowance") : 0;
                var ConsumptionPerProduct = TotalConsumption / (ExpectedOutputQty.GetValue() != "" ? ExpectedOutputQty.GetValue() : 0) || parseFloat(0);
                var QtyAllowance = TotalConsumption * PercentageAllowance;
                var StandardUsage = TotalConsumption + QtyAllowance;

                gvOtherMaterial.batchEditApi.SetCellValue(indicies[i], "ConsumptionPerProduct", ConsumptionPerProduct);
                gvOtherMaterial.batchEditApi.SetCellValue(indicies[i], "QtyAllowance", QtyAllowance);
                gvOtherMaterial.batchEditApi.SetCellValue(indicies[i], "StandardUsage", StandardUsage);
            }
        }
    }, 500);
}
// gvOtherMaterial END

function calculatehead(s, e) {
    calculate();
    calculate1();
    calculate2();
}

function UpdateItemCodeOM(values) {
    gvOtherMaterial.batchEditApi.EndEdit();
    gvOtherMaterial.batchEditApi.SetCellValue(index, "ItemCode", values[0]);
    gvOtherMaterial.batchEditApi.SetCellValue(index, "Description", values[1]);
    gvOtherMaterial.batchEditApi.SetCellValue(index, "Unit", values[2]);
}

// BOMUnitCode valuechanged event
function UpdateUnitCodeOM(value) {
    gvOtherMaterial.batchEditApi.EndEdit();
    gvOtherMaterial.batchEditApi.SetCellValue(index, "Unit", value);
}

// BOMUnitCode valuechanged event
function UpdateUnitCodeBOM(value) {
    gvStepBOM.batchEditApi.EndEdit();
    gvStepBOM.batchEditApi.SetCellValue(index, "Unit", value);
}

function UpdateUnitCodeBOM1(value) {
    gvStepBOM1.batchEditApi.EndEdit();
    gvStepBOM1.batchEditApi.SetCellValue(index, "Unit", value);
}

// BOMStandardUsage valuechanged event
function UpdateStandardUsageBOM(value) {
    gvStepBOM.batchEditApi.EndEdit();
    gvStepBOM.batchEditApi.SetCellValue(index, "StandardUsageUnit", value);
}

function UpdateStandardUsageBOM1(value) {
    gvStepBOM1.batchEditApi.EndEdit();
    gvStepBOM1.batchEditApi.SetCellValue(index, "StandardUsageUnit", value);
}

// OMStandardUsage valuechanged event
function UpdateStandardUsageOM(value) {
    gvOtherMaterial.batchEditApi.EndEdit();
    gvOtherMaterial.batchEditApi.SetCellValue(index, "StandardUsageUnit", value);
}

// Machine MachineType valuechanged event
function UpdateMachineTypeMachine(values) {
    gvStepMachine.batchEditApi.EndEdit();
    gvStepMachine.batchEditApi.SetCellValue(index, "MachineType", values[0]);
    gvStepMachine.batchEditApi.SetCellValue(index, "Location", values[1]);
    gvStepMachine.batchEditApi.SetCellValue(index, "Unit", values[3]);
    gvStepMachine.batchEditApi.SetCellValue(index, "MachineCapacityQty", values[2] || 0);
    gvStepMachine.batchEditApi.SetCellValue(index, "MachineCapacityUnit", values[3]);
}

function UpdateMachineTypeMachine1(values) {
    gvStepMachine1.batchEditApi.EndEdit();
    gvStepMachine1.batchEditApi.SetCellValue(index, "MachineType", values[0]);
    gvStepMachine1.batchEditApi.SetCellValue(index, "Location", values[1]);
    gvStepMachine1.batchEditApi.SetCellValue(index, "Unit", values[3]);
    gvStepMachine1.batchEditApi.SetCellValue(index, "MachineCapacityQty", values[2]);
    gvStepMachine1.batchEditApi.SetCellValue(index, "MachineCapacityUnit", values[3]);
}

// Machine Unit valuechanged event
function UpdateUnitMachine(value) {
    gvStepMachine.batchEditApi.EndEdit();
    gvStepMachine.batchEditApi.SetCellValue(index, "Unit", value);
}

function UpdateUnitMachine1(value) {
    gvStepMachine1.batchEditApi.EndEdit();
    gvStepMachine1.batchEditApi.SetCellValue(index, "Unit", value);
}

// Designation valuechanged event
function UpdateDesignationManpower(values) {
    gvStepManpower.batchEditApi.EndEdit();
    gvStepManpower.batchEditApi.SetCellValue(index, "Designation", values[0]);
    gvStepManpower.batchEditApi.SetCellValue(index, "StandardRate", values[1]);
    gvStepManpower.batchEditApi.SetCellValue(index, "StandardRateUnit", values[2]);
}

function UpdateDesignationManpower1(values) {
    gvStepManpower1.batchEditApi.EndEdit();
    gvStepManpower1.batchEditApi.SetCellValue(index, "Designation", values[0]);
    gvStepManpower1.batchEditApi.SetCellValue(index, "StandardRate", values[1]);
    gvStepManpower1.batchEditApi.SetCellValue(index, "StandardRateUnit", values[2]);
}

// Designation valuechanged event
function ManpowerNoHourUpdate(s, e) {
    gvStepManpower.batchEditApi.EndEdit();
    gvStepManpower.batchEditApi.SetCellValue(index, "NoHour", values[0]);

}

// OMUnitCode valuechanged event
function UpdateUnitCode(value) {
    gvOtherMaterial.batchEditApi.EndEdit();
    gvOtherMaterial.batchEditApi.SetCellValue(index, "UnitCode", value);
}

// Size event
function OnControlsInitialized(s, e) {
    ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
        AdjustSize();
    });
}

// Adjusting Size
function AdjustSize() {
    var width = Math.max(0, document.documentElement.clientWidth);
    gvStepProcess.SetWidth(width - 120);
    gvStepProcess1.SetWidth(width - 120);
    //gvStepBOM.SetWidth(width - 120);
    //gvStepMachine.SetWidth(width - 120);
    //gvStepManpower.SetWidth(width - 120);
    gvOtherMaterial.SetWidth(width - 120);
}

var itemc; //variable required for lookup

// Function StepProcess_OnStartEditing, Enable/Disable editing
function OnStartEditing(s, e) {
    index = e.visibleIndex;
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    var entry = getParameterByName('entry');

    e.cancel = (entry == "V") ? true : false; //this will made the gridview readonly
    itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode"); //needed var for all lookups; this is where the lookups vary for

    if (entry != "V") {
        if (e.focusedColumn.fieldName === "EstimatedUnitCost") { //Check the column name

            if (s.globalName == "gvStepBOM") {
                e.cancel = gvStepBOM.batchEditApi.GetCellValue(index, "ClientSuppliedMaterial") ? true : false;
                return;
            }

            if (s.globalName == "gvStepBOM1") {
                e.cancel = gvStepBOM1.batchEditApi.GetCellValue(index, "ClientSuppliedMaterial") ? true : false;
                return;
            }

            if (s.globalName == "gvOtherMaterial") {
                e.cancel = gvOtherMaterial.batchEditApi.GetCellValue(index, "ClientSuppliedMaterial") ? true : false;
                return;
            }
        }
    }
}

// Check if there's a same value
function OnKeyUp(s, e) {
    if (s.globalName == "cp_frmLayoutRouting_PC_0_gvStepProcess_DXEditor4") {
        var indicies = gvStepProcess.batchEditApi.GetRowVisibleIndices();
        var stepVal;
        var ispass = true;

        setTimeout(function () {
            for (var i = 0; i < indicies.length; i++) {
                if (gvStepProcess.batchEditApi.IsNewRow(indicies[i])) {
                    stepVal = gvStepProcess.batchEditApi.GetCellValue(indicies[i], "StepSequence");
                }
                else {
                    if (stepVal == gvStepProcess.batchEditApi.GetCellValue(indicies[i], "StepSequence")) {
                        ispass = false;
                    }
                }
            }

            if (!ispass) {
                for (var i = 0; i < indicies.length; i++) {
                    if (gvStepProcess.batchEditApi.IsNewRow(indicies[i])) {
                        alert("Step Sequence duplicate is not allowed.");
                        stepVal = gvStepProcess.batchEditApi.SetCellValue(indicies[i], "StepSequence", null);
                    }
                }
            }
        }, 500);
    }

    else {
        var indicies = gvStepProcess1.batchEditApi.GetRowVisibleIndices();
        var stepVal;
        var ispass = true;
        setTimeout(function () {
            for (var i = 0; i < indicies.length; i++) {
                if (gvStepProcess1.batchEditApi.IsNewRow(indicies[i])) {
                    stepVal = gvStepProcess1.batchEditApi.GetCellValue(indicies[i], "StepSequence");
                }
                else {
                    if (stepVal == gvStepProcess1.batchEditApi.GetCellValue(indicies[i], "StepSequence")) {
                        ispass = false;
                    }
                }
            }

            if (!ispass) {
                for (var i = 0; i < indicies.length; i++) {
                    if (gvStepProcess1.batchEditApi.IsNewRow(indicies[i])) {
                        alert("Step Sequence duplicate is not allowed.");
                        stepVal = gvStepProcess1.batchEditApi.SetCellValue(indicies[i], "StepSequence", null);
                    }
                }
            }
        }, 500);
    }
}  

var previndex;
function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
    var cellInfo = e.rowValues[currentColumn.index];

    var entry = getParameterByName('entry');

    previndex = e.visibleIndex;

    if (currentColumn.fieldName === "SKUCode") {
        cellInfo.value = glStepCode.GetValue();
        cellInfo.text = glStepCode.GetText();
    }
}

function PutDescription(selectedValues) {
    StepProcess.batchEditApi.EndEdit();
    StepProcess.batchEditApi.SetCellValue(index, "Rate", selectedValues);
}

function StepCode_OnChange(s, e) {
    //grid.GetEditor('StepCode').SetValue("asda");
    //grid.GetEditor('SequenceDay').SetValue("2");
    //var grid = glStepCode.GetGridView();
    //grid.GetRowValues(grid.GetFocusedRowIndex(), "StepCode;StepDescription", OnGetSelectedFieldValues);
}

function OnGetSelectedFieldValues(selectedValues) {
    // alert(selectedValues);
    cbCUTY.SetValue(selectedValues[0]);
    tbCYNO.SetValue(selectedValues[1]);
    tbADDR.SetValue(selectedValues[2]);
    StepProcess.batchEditApi.SetCellValue('-' + tableid.split("Table")[1], "BOMCount", $('#' + tableid + " .tbody tr").length);
}

function OnInitTrans(s, e) {

    //var BizPartnerCode = aglCustomerCode.GetText();

    //if (BizPartnerCode != null && BizPartnerCode != "" && BizPartnerCode != '') {
    //    factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
    //}

    AdjustSize();

    //if (s == gvProductOrder && postback) {
    //    if (gvProductOrder.GetVisibleRowsOnPage() > 0)
    //        cbacker.PerformCallback('update|' + gvProductOrder.batchEditApi.GetCellValue(0, 'ItemCode'));
    //    postback = false;
    //}
}

// Function upon saving entry 
function OnConfirm(s, e) {
    e.cancel = true;
}

function OnBatchEditRowValidating(s, e) { }

// Gridview Button Event
function OnCustomClick(s, e) {
    // Delte Gridview row
    if (e.buttonID == "StepProcessRemove") gvStepProcess.DeleteRow(e.visibleIndex);
    if (e.buttonID == "StepProcessRemove1") gvStepProcess1.DeleteRow(e.visibleIndex);
    if (e.buttonID == "BOMDelete") gvStepBOM.DeleteRow(e.visibleIndex);
    if (e.buttonID == "BOMDelete1") gvStepBOM1.DeleteRow(e.visibleIndex);
    if (e.buttonID == "MachineDelete") gvStepMachine.DeleteRow(e.visibleIndex);
    if (e.buttonID == "MachineDelete1") gvStepMachine1.DeleteRow(e.visibleIndex);
    if (e.buttonID == "ManpowerDelete") gvStepManpower.DeleteRow(e.visibleIndex);
    if (e.buttonID == "ManpowerDelete1") gvStepManpower1.DeleteRow(e.visibleIndex);
    if (e.buttonID == "MaterialDelete") gvOtherMaterial.DeleteRow(e.visibleIndex);
}

function OnCustomButtonClick(s, e) {
    index = e.visibleIndex;
    s.ExpandDetailRow(index);
}

function EndCallBack1(s, e) {
    cp.PerformCallback('|run');
}

function OnEndCallback(s, e) {
    if (s.cp_redirect == "error") {
        errorlabel.SetText(s.cp_errormes);
        errorpop.Show();
        delete (s.cp_errormes);
        delete (s.cp_redirect);
    }
    else if (s.cp_redirect == "success") {
        successlabel.SetText(s.cp_successmes);
        successpop.Show();
        delete (s.cp_successmes);
        delete (s.cp_redirect);
    }
    else {
        if (index != -1) {
            var i = index;
            index = -1;
            s.PerformCallback("AddDetail|" + i);
        }
    }
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function gvStepProcess_KeyDown(s, e) { //Allows tabbing between gridlookup on details
    isSetTextRequired = false;
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode !== 9) return;
    var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
    if (StepProcess.batchEditApi[moveActionName]()) {
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    }
}

var val;
var temp;
function GridEnd(s, e) {

    val = s.GetGridView().cp_codes;
    if (val != null) {
        temp = val.split(';');
    }
    delete (s.GetGridView().cp_codes);

    if (val != null && val != 'undefined' && val != '') {
        for (var i = 0; i < StepProcess.GetColumnsCount() ; i++) {
            var column = StepProcess.GetColumn(i);
            if (column.visible == false || column.fieldName == undefined)
                continue;
            ProcessCells(0, editorobj, column, StepProcess);
            StepProcess.batchEditApi.EndEdit();
        }
        //validateRow();
    }
}

// Gridlookup Event START
function gridLookup_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode == ASPxKey.Enter)
        gv1.batchEditApi.EndEdit();
    //ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
}

function gridLookup_CloseUp(s, e) { //Automatically leaves the current cell if an item is selected.
    gv1.batchEditApi.EndEdit();
}

function gridLookup_KeyDown(s, e) { //Allows tabbing between gridlookup on details
    isSetTextRequired = false;
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode !== ASPxKey.Tab) return;
    var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
    if (gv1.batchEditApi[moveActionName]()) {
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    }
}

function lookup(s, e) {
    if (isSetTextRequired) {//Sets the text during lookup for item code
        s.SetText(s.GetInputElement().value);
        isSetTextRequired = false;
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

    if (identifier == "ItemCode") {
        gvStepProcess.batchEditApi.EndEdit();
        delete (s.GetGridView().cp_identifier);
        if (s.GetGridView().cp_valch) {
            delete (s.GetGridView().cp_valch);
            for (var i = 0; i < gvStepProcess.GetColumnsCount() ; i++) {
                var column = gvStepProcess.GetColumn(i);
                if (column.visible == false || column.fieldName == undefined)
                    continue;
                ProcessCells_ItemCode(0, editorobj, column, gvStepProcess);
            }
            gvStepProcess.batchEditApi.StartEdit(previndex, gvStepProcess.GetColumnByField(currentColumn.fieldName).index);
        }

        gvStepProcess.batchEditApi.EndEdit();
    }

    if (identifier == "VAT") {
        GridEnd_VAT();
        gvStepProcess.batchEditApi.EndEdit();
        gvStepProcess.batchEditApi.StartEdit(previndex, gvStepProcess.GetColumnByField(currentColumn.fieldName).index);
    }


    //loader.Hide();
}
// Gridlookup Event END

// Function UpdateDescription, Update SKU Descrption Field
function UpdateDescription(s, e) {
    cp.PerformCallback('UpdateDescription');
}

function gridView_EndCallback(s, e) { //End callback function if (s.cp_success) 
    if (s.cp_success) {
        alert(s.cp_message);
        delete (s.cp_success);//deletes cache variables' data
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
            window.close();
        }
    }

    if (s.cp_delete) {
        delete (cp_delete);
        DeleteControl.Show();
    }
    if (s.cp_generated) {
        delete (s.cp_generated);
        calculations();
    }


    //Size Horizontal
    if (s.cp_closeSH) {
        delete (s.cp_closeSH);
        SizeHorizontalPopup.Hide();
        gvSizeHorizontal.CancelEdit();
        gvSizes.CancelEdit();
        //resetsizesvalue();
        calculate_header();
    }

    if (s.cp_RefreshSizeGrid) {
        delete (s.cp_RefreshSizeGrid);
        PopulateSizes();
        //resetsizesvalue();
    }

    //OnLoaderHide();
} //


// Function OnUpdateClick, Add/Edit/Close button function
function OnUpdateClick(s, e) {
    btn.SetEnabled(false);
    var btnmode = btn.GetText(); //gets text of button

    gvStepProcess.batchEditApi.EndEdit();
    //gvService.batchEditApi.EndEdit();

    // autocalculate();


    setTimeout(function () {
        //var indicies = gvStepProcess.batchEditHelper.GetDataRowIndices();
        //for (var i = 0; i < indicies.length; i++) {
        //    var key = gvStepProcess.GetRowKey(indicies[i]);
        //    if (!gvStepProcess.batchEditHelper.IsDeletedRow(key)) {
        //        gvStepProcess.batchEditApi.ValidateRow(indicies[i]);
        //        gvStepProcess.batchEditApi.StartEdit(indicies[i], gvStepProcess.GetColumnByField("SKUCode").index);
        //    }
        //}
        gvStepProcess.batchEditApi.EndEdit();

        if (btnmode === "Delete") {
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
            btn.SetEnabled(true);
        }
    }, 1000);
}

function OnShown() {
    var time = 1;
    startTimer(time);
};

function startTimer(duration) {
    var timer = duration, minutes, seconds;
    var show = setInterval(function () {
        //minutes = parseInt(timer / 60, 10);
        seconds = parseInt(timer % 60, 10);

        //minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        if (--timer < 0) {
            clearInterval(show);
            successpop.Hide();
        }
    }, 1000);
} 
