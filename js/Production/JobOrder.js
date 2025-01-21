var isValid = true;
var counterror = 0;
var JOisprinted;
var JOSPStep = "";
var JOisprinted1;
var JOSPWorkCntr = "";
var JOLineNumberA = "";
var JOLineNumberB = "";
var SP_identifier = "";
var dropdown = false;

function isNullOrWhiteSpace(str) {
    return (!str || str.length === 0 || /^\s*$/.test(str))
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

var transtype = getParameterByName('transtype');
function onload() {
    window.setTimeout(function () {
        fbnotes.SetContentUrl('../FactBox/fbNotes.aspx?docnumber=' + txtDocNumber.GetText() + '&transtype=' + transtype);
    },500);
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

var postback = true;
function OnInitTrans(s, e) {

    var BizPartnerCode = aglCustomerCode.GetText();

    if (BizPartnerCode != null && BizPartnerCode != "" && BizPartnerCode != '') {
        factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
    }

    AdjustSize();

    if (s == gvProductOrder && postback) {
        if (gvProductOrder.GetVisibleRowsOnPage() > 0)
            cbacker.PerformCallback('update|' + gvProductOrder.batchEditApi.GetCellValue(0, 'ItemCode'));
        postback = false;
    }
}

function OnControlsInitialized(s, e) {
    ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
        AdjustSize();
    });
}

function AdjustSize() {
    var width = Math.max(0, document.documentElement.clientWidth);
    gvProductOrder.SetWidth(width - 120);
    gvBOM.SetWidth(width - 120);
    gvSteps.SetWidth(width - 120);
    gvStepPlanning.SetWidth(width - 120);
    gvClass.SetWidth(width - 120);
    gvSize.SetWidth(width - 120);
    gvMaterial.SetWidth(width - 120);

}

function myTrim(x) {
    return x.replace(/^\s+|\s+$/gm, '');
}

function OnLoaderShow(s, e) {
    ProductLoader.Show();
    BOMLoader.Show();
    PlanLoader.Show();
    //ClassLoader.Show();
    //SizeLoader.Show();
    MatLoader.Show();
}

function OnLoaderHide(s, e) {
    ProductLoader.Hide();
    BOMLoader.Hide();
    PlanLoader.Hide();
    //ClassLoader.Hide();
    //SizeLoader.Hide();
    MatLoader.Hide();
}

var boolvalstep = false;
var x = 0;
function OnUpdateClick(s, e) { //Add/Edit/Close button function
    if (x == 0) {
        OnLoaderShow();
        var btnmode = btn.GetText(); //gets text of button
        var indicies = gvProductOrder.batchEditApi.GetRowVisibleIndices();
        boolvalstep = true;
        for (var i = 0; i < indicies.length; i++) {
            if (gvProductOrder.batchEditApi.IsNewRow(indicies[i])) {
                gvProductOrder.batchEditApi.ValidateRow(indicies[i]);
                gvProductOrder.batchEditApi.StartEdit(indicies[i], gvProductOrder.GetColumnByField("ItemCode").index);
            }
            else {
                var key = gvProductOrder.GetRowKey(indicies[i]);
                if (gvProductOrder.batchEditApi.IsDeletedRow(key))
                    var aa;
                else {
                    gvProductOrder.batchEditApi.ValidateRow(indicies[i]);
                    gvProductOrder.batchEditApi.StartEdit(indicies[i], gvProductOrder.GetColumnByField("ItemCode").index);
                }
            }
        }

        indicies = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
        for (var i = 0; i < indicies.length; i++) {
            var key = gvStepPlanning.GetRowKey(indicies[i]);
            if (!gvStepPlanning.batchEditApi.IsDeletedRow(key)) {
                gvStepPlanning.batchEditApi.ValidateRow(indicies[i]);
                gvStepPlanning.batchEditApi.StartEdit(indicies[i], gvStepPlanning.GetColumnByField("DocNumber").index);
            }
        }

        if (btnmode == "Delete") {
            cp.PerformCallback("Delete");
        }

        checkGrid();

        if ((Okay && isValid && counterror < 1 && gvprodvalid) || btnmode == "Close") { //check if there's no error then proceed to callback
            if (!ValidateStepSequence()) {
                counterror = 0;
                alert('Please check step sequence!');
                OnLoaderHide();
                return;
            }
            //Sends request to server side
            if (btnmode == "Add" && x == 0) {
                //calculations();
                x++;
                cp.PerformCallback("Add");
            }
            else if (btnmode == "Update" && x == 0) {
                //calculations();
                x++;
                cp.PerformCallback("Update");
            }
            else if (btnmode == "Close") {
                cp.PerformCallback("Close");
            }
        }
        else {
            counterror = 0;
            alert('Please check all the fields!');
            OnLoaderHide();
        }
        boolvalstep = false;
    }
    else {
        alert('Updating, please wait!');
    }
}

function OnConfirm(s, e) {//function upon saving entry 
    //if (e.requestTriggerID === "cp" || e.requestTriggerID === "cp_frmlayout1_PC_0_gvBOM")//disables confirmation message upon saving.
        e.cancel = true;
}

function gvStepPlanning_EndCallback(s, e) {
    if (s.cp_JO) {
        JOisprinted = s.cp_JOisprinted;
        JOSPStep = s.cp_JOStep;
        JOLineNumberA = s.cp_JOLineA;
        delete (s.cp_JO);
        delete (s.cp_JOStep);
        delete (s.cp_JOLineA);
        delete (s.cp_JOisprinted);
        ShowPrintWOPrint();
    }

    if (s.cp_JOMul) {
        JOisprinted1 = s.cp_JOisprinted1;
        JOSPWorkCntr = s.cp_JOWorkCntr;
        JOLineNumberB = s.cp_JOLineB;
        delete (s.cp_JOMul);
        delete (s.cp_JOWorkCntr);
        delete (s.cp_JOLineB);
        delete (s.cp_JOisprinted1);
        ShowPrintWOPrintMul();
    }

    if (s.cp_JOMulSing) {
        JOisprinted2 = s.cp_JOisprinted2;
        JOSPStep2 = s.cp_JOSPStep2;
        JOLineNumber2 = s.cp_JOLineNumber2;
        delete (s.cp_JOMulSing);
        delete (s.cp_JOisprinted2);
        delete (s.cp_JOSPStep2);
        delete (s.cp_JOLineNumber2);
        ShowPrintWOPrintMulStep();
    }

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
        console.log('1');
    }

    if (s.cp_RefreshSizeGrid) {
        delete (s.cp_RefreshSizeGrid);
        PopulateSizes();
        //resetsizesvalue();
    }

    OnLoaderHide();
}

function gvBOM_EndCallback(s, e) { 
    if (s.cp_generated) {
        delete (s.cp_generated);
        calculations();
    }
    if (s.cp_JOSign) { 
        aglDesigner.SetText(s.cp_JODesigner);
        speLeadtime.SetText(s.cp_JOLeadVal)
        delete (s.cp_JOSign)
        delete (s.cp_JODesigner)
        delete (s.cp_JOLeadVal)
    }

    if (s.cp_StepCascade) {
        delete s.cp_StepCascade;
        gvStepPlanning.PerformCallback('GenerateStepTemplatePIS');
        aglStepTemplate.SetText("");
    }
}

var index;
var closing;
var account;
var valchange = false;
var currentColumn = null;
var isSetTextRequired = false;
var linecount = 1;
var nope = false;

function OnStartEditing(s, e) {//On start edit grid function     
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    account = s.batchEditApi.GetCellValue(e.visibleIndex, "AccountCode");

    var entry = getParameterByName('entry');

    if (entry == "V") {
        e.cancel = true;
    }
             

    if (entry != "V") {
        if (e.focusedColumn.fieldName === "DiscountType") { //Check the column name
            DiscountType.GetInputElement().value = cellInfo.value; //Gets the column value
            isSetTextRequired = true;
            index = e.visibleIndex;
            closing = true;
        }

        if (e.focusedColumn.fieldName === "DiscountType") {
            DiscountType.GetInputElement().value = cellInfo.value;
        }
    }
}

var PItem;
var PColor;
var PClass;
var PSize;
var editorobj;
var gvProdindex;
function gvProductOrder_OnStartEditing(s, e) {
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    PItem = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
    PColor = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
    PClass = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
    PSize = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");

    itemc = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
    itemclr = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
    itemcls = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
    itemsze = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
    itemdesc = s.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
    itemunit = '';
    itemqty = s.batchEditApi.GetCellValue(e.visibleIndex, "JOQty");
    itemprice = 0;
    itemVAT = 0;
    itemIsVAT = 0;
    itembulk = 0;
    itemIsBulk = 0;
    var entry = getParameterByName('entry');
    var auto = chkIsAutoJO.GetChecked();

            

    if (entry == "V") {
        e.cancel = true;
    }

    gvProdindex = e.visibleIndex;

    editorobj = e;
    //As per Ate Nes, editable yung JO Qty regardless if Auto JO or not. 7/1//2016
    if (entry != "V" && entry != "D") {
                

        if (txtHAllocSubmittedBy.GetText() != "" && txtHAllocSubmittedBy.GetText() != null) {

            e.cancel = true;
        }
        else {
            if (chkIsAutoJO.GetChecked() == true) {
                if (e.focusedColumn.fieldName !== "SOQty" &&
                    e.focusedColumn.fieldName !== "INQty" && e.focusedColumn.fieldName !== "FinalQty") {
                    e.cancel = false;
                }
                else {
                    e.cancel = true;
                }
            }
            else {
                if (e.focusedColumn.fieldName !== "SOQty" &&
                    e.focusedColumn.fieldName !== "INQty" && e.focusedColumn.fieldName !== "FinalQty") {
                    e.cancel = false;
                }
                else {
                    e.cancel = true;
                }
            }
        }
    }

    if (e.focusedColumn.fieldName === "ItemCode") {
        var refso = s.batchEditApi.GetCellValue(e.visibleIndex, "ReferenceSO")
        if (refso != null) {
            console.log(refso)
            e.cancel = true;
        }
    }

    if (e.focusedColumn.fieldName === "ReferenceSO") {
        e.cancel = true;
    }

    if (entry != "V") {
        if (e.focusedColumn.fieldName === "ItemCode") {
            gl.GetInputElement().value = cellInfo.value;
            isSetTextRequired = true;
            nope = false;
            closing = true;
        }
        if (e.focusedColumn.fieldName === "ColorCode") {
            gl2.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "ClassCode") {
            gl3.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "SizeCode") {
            gl4.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
    } 
}

var BOMclosing;
var BOMvalchange = false;
var linecount = 1;
var BOMnope = false;
var BItem;
var BColor;
var BClass;
var BSize;
var ProdItem;
var ProdColor;
var ProdSize;
var BIsByBulk;
var BIndex;
        
function gvBOM_OnStartEditing(s, e) {
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    BIndex = e.visibleIndex;

    BItem = s.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
    BColor = s.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
    BClass = s.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
    BSize = s.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");

    ProdItem = s.batchEditApi.GetCellValue(e.visibleIndex, "ProductCode");
    ProdColor = s.batchEditApi.GetCellValue(e.visibleIndex, "ProductColor");
    ProdSize = s.batchEditApi.GetCellValue(e.visibleIndex, "ProductSize");

    BIsByBulk = s.batchEditApi.GetCellValue(e.visibleIndex, "IsBulk");

    editorobj = e;

    if (BIsByBulk == true) {
        if (e.focusedColumn.fieldName === "PerPieceConsumption") {
            e.cancel = true;
        }
    }
    else {
        if (e.focusedColumn.fieldName === "Consumption") {
            e.cancel = true;
        }
    }

    if (e.focusedColumn.fieldName === "RequiredQty") {
        e.cancel = true;
    }

    var entry = getParameterByName('entry');

    if (entry == "V") {
        e.cancel = true;
    }

    if (txtHAllocSubmittedBy.GetText() != "" && txtHAllocSubmittedBy.GetText() != null) {
        e.cancel = true;
    }

    if (entry != "V") {
        if (e.focusedColumn.fieldName === "Components") {
            bComponents.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "StepCode") {
            bStepCode.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "ProductCode") {
            bProductCode.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "ProductColor") {
            bProductColor.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "ProductSize") {
            bProductSize.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "ItemCode") {
            BOMgl.GetInputElement().value = cellInfo.value;
            isSetTextRequired = true;
            nope = false;
            closing = true;
        }
        if (e.focusedColumn.fieldName === "ColorCode") {
            BOMgl2.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "ClassCode") {
            BOMgl3.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "SizeCode") {
            BOMgl4.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
        if (e.focusedColumn.fieldName === "Unit") {
            BOMgl5.GetInputElement().value = cellInfo.value;
            nope = false;
            isSetTextRequired = true;
        }
    }
}

function gvSteps_OnStartEditing(s, e) {
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];

    var entry = getParameterByName('entry');

    if (e.focusedColumn.fieldName !== "Field1" && e.focusedColumn.fieldName !== "Field2" && e.focusedColumn.fieldName !== "Field3"
        && e.focusedColumn.fieldName !== "Field4" && e.focusedColumn.fieldName !== "Field5" && e.focusedColumn.fieldName !== "Field6" && e.focusedColumn.fieldName !== "Field7"
        && e.focusedColumn.fieldName !== "Field8" && e.focusedColumn.fieldName !== "Field9")
    e.cancel = true; //this will made the gridview readonly


}

var SPclosing;
var SPvalchange = false;
var SPnope = false;
var SPStep;
var SPWorkCenter;
var SPLineNumber = "";
var gvStepPlanIndex;
var indexSP;
function gvStepPlanning_OnStartEditing(s, e) {
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    indexSP = e.visibleIndex;
    SPStep = s.batchEditApi.GetCellValue(e.visibleIndex, "StepCode");
    SPWorkCenter = s.batchEditApi.GetCellValue(e.visibleIndex, "WorkCenter");
    SPLineNumber = s.batchEditApi.GetCellValue(e.visibleIndex, "LineNumber");
    SPOverhead = s.batchEditApi.GetCellValue(e.visibleIndex, "Overhead");
    gvStepPlanIndex = e.visibleIndex;

    var entry = getParameterByName('entry');

    if (entry == "V") {
        e.cancel = true;
    }

    //if (e.focusedColumn.fieldName === "Overhead") {
    //    e.cancel = true;
    //}

    //Based on Ate Nes -- Columns not there are uneditable -- 8/22/2016 
    if (e.focusedColumn.fieldName !== "Sequence" && e.focusedColumn.fieldName !== "StepCode" && e.focusedColumn.fieldName !== "Instruction" &&
        e.focusedColumn.fieldName !== "EstWorkOrderPrice" && e.focusedColumn.fieldName !== "WorkOrderPrice" && e.focusedColumn.fieldName !== "WorkOrderDate" &&
        e.focusedColumn.fieldName !== "WorkOrderQty" && e.focusedColumn.fieldName !== "DateCommitted" && e.focusedColumn.fieldName !== "TargetDateIn" && e.focusedColumn.fieldName !== "TargetDateOut"
        && e.focusedColumn.fieldName !== "DocNumber" && e.focusedColumn.fieldName !== "Field1" && e.focusedColumn.fieldName !== "Field2" && e.focusedColumn.fieldName !== "Field3"
        && e.focusedColumn.fieldName !== "Field4" && e.focusedColumn.fieldName !== "Field5" && e.focusedColumn.fieldName !== "Field6" && e.focusedColumn.fieldName !== "Field7"
        && e.focusedColumn.fieldName !== "Field8" && e.focusedColumn.fieldName !== "Field9") {
        e.cancel = true;
    }



    var today = new Date();
    if (s.batchEditApi.GetCellValue(e.visibleIndex, "TargetDateIn") === null || s.batchEditApi.GetCellValue(e.visibleIndex, "TargetDateIn") === "") {
        s.batchEditApi.SetCellValue(e.visibleIndex, "TargetDateIn", today)
    }
    if (s.batchEditApi.GetCellValue(e.visibleIndex, "TargetDateOut") === null || s.batchEditApi.GetCellValue(e.visibleIndex, "TargetDateOut") === "") {
        s.batchEditApi.SetCellValue(e.visibleIndex, "TargetDateOut", today)
    }
    if (s.batchEditApi.GetCellValue(e.visibleIndex, "WorkOrderDate") === null || s.batchEditApi.GetCellValue(e.visibleIndex, "WorkOrderDate") === "") {
        s.batchEditApi.SetCellValue(e.visibleIndex, "WorkOrderDate", today)
    }
    if (s.batchEditApi.GetCellValue(e.visibleIndex, "DateCommitted") === null || s.batchEditApi.GetCellValue(e.visibleIndex, "DateCommitted") === "") {
        s.batchEditApi.SetCellValue(e.visibleIndex, "DateCommitted", today)
    } 
    if (s.batchEditApi.GetCellValue(e.visibleIndex, "WorkOrderQty") === null || s.batchEditApi.GetCellValue(e.visibleIndex, "WorkOrderQty") === "" || s.batchEditApi.GetCellValue(e.visibleIndex, "WorkOrderQty") === 0) {
        s.batchEditApi.SetCellValue(e.visibleIndex, "WorkOrderQty", speTotalJO.GetValue())
    }

	
	if (chkIsAutoJO.GetChecked() == true) {
        if (e.focusedColumn.fieldName == "WorkCenter") { 
            e.cancel = true;
        } 
    }
    else {
        if (e.focusedColumn.fieldName == "WorkCenter") { 
            e.cancel = false;
        } 
	}
    
	if (e.focusedColumn.fieldName == "IsInhouse") {
	    e.cancel = false;
	}
	if (e.focusedColumn.fieldName == "Overhead") { 
	    if (s.batchEditApi.GetCellValue(e.visibleIndex, "IsInhouse"))
	        e.cancel = false; 
	    else  
	        e.cancel = true;
	}

    //Sequence, Stepcode, Instruction, Estimated Work Order Price, Work Order Price, Work Order Date, 
    //Work Order Qty, Date Committed, Target Date In, Target Date Out

    //console.log(e.focusedColumn.fieldName + " sdlasda ter")
    //if (e.focusedColumn.fieldName === "WOPrint") {
    //    if (entry != "N") {
    //        console.log(SPLineNumber + "  SPLineNumber ter")
    //        if (SPLineNumber != null && SPLineNumber != "") {
    //            gvStepPlanning.PerformCallback('WOPrintClick|' + SPStep + '|' + SPLineNumber);
    //        }
    //    }
    //    e.cancel = true;
    //}

    //if (e.focusedColumn.fieldName === "WOPrint1") {
    //    if (entry != "N") {
    //        console.log(SPLineNumber + "  SPLineNumber ver")
    //        if (SPLineNumber != null && SPLineNumber != "") {
    //            gvStepPlanning.PerformCallback('WOPrintMultiple|' + SPWorkCenter + '|' + SPLineNumber);
    //        }
    //    }
    //    e.cancel = true;
    //}

    if (entry != "V") {
        if (e.focusedColumn.fieldName === "StepCode") {
            dStepCode.GetInputElement().value = cellInfo.value;
            isSetTextRequired = true;
            nope = false;
            closing = true;
        }
        //if (e.focusedColumn.fieldName === "Overhead") {
        //    dOverhead.GetInputElement().value = cellInfo.value;
        //    isSetTextRequired = true;
        //    nope = false;
        //    closing = true;
        //}
    }
}

function IsInhouseChanged(s, e) {
    gvStepPlanning.batchEditApi.EndEdit();
    if (!gvStepPlanning.batchEditApi.GetCellValue(gvStepPlanIndex, "IsInhouse")) {
        gvStepPlanning.batchEditApi.SetCellValue(gvStepPlanIndex, "Overhead", null);
        gvStepPlanning.batchEditApi.SetCellValue(gvStepPlanIndex, "OHRate", null);
        gvStepPlanning.batchEditApi.SetCellValue(gvStepPlanIndex, "OHType", null);
    }
}

function PrintoutPrintSingle(s, e) {

    //if (e.focusedColumn.fieldName === "WOPrint") {
    if (entry != "N") {
        console.log(SPLineNumber + "  SPLineNumber ter")
        if (SPLineNumber != null && SPLineNumber != "") {
            gvStepPlanning.PerformCallback('WOPrintClick|' + SPStep + '|' + SPLineNumber);
        }
    }
    e.cancel = true;
    //}
}
function PrintoutPrintMulti(s, e) {
    //if (e.focusedColumn.fieldName === "WOPrint1") {
        if (entry != "N") {
            console.log(SPLineNumber + "  SPLineNumber ver")
            if (SPLineNumber != null && SPLineNumber != "") {
                gvStepPlanning.PerformCallback('WOPrintMultiple|' + SPWorkCenter + '|' + SPLineNumber);
            }
        }
        e.cancel = true;
    //}
}

function gvClass_OnStartEditing(s, e) {
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    account = s.batchEditApi.GetCellValue(e.visibleIndex, "AccountCode");

    var entry = getParameterByName('entry');

    //if (entry == "V") {
    e.cancel = true; //this will made the gridview readonly
    //}
}

function gvSize_OnStartEditing(s, e) {
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    account = s.batchEditApi.GetCellValue(e.visibleIndex, "AccountCode");

    var entry = getParameterByName('entry');

    editorobj = e;
    //if (entry == "V") {
    e.cancel = true; //this will made the gridview readonly
    //}
}

function gvMaterial_OnStartEditing(s, e) {
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    account = s.batchEditApi.GetCellValue(e.visibleIndex, "AccountCode");

    var entry = getParameterByName('entry');

    if (entry == "V") {
        e.cancel = true; //this will made the gridview readonly
    }
}

function OnEndEditing(s, e) {
    var cellInfo = e.rowValues[currentColumn.index];

    var entry = getParameterByName('entry');

    if (currentColumn.fieldName === "Bank") {
        cellInfo.value = colBank.GetValue();
        cellInfo.text = colBank.GetText();
    }
    if (currentColumn.fieldName === "Branch") {
        cellInfo.value = colBranch.GetValue();
        cellInfo.text = colBranch.GetText();
    }
    if (currentColumn.fieldName === "ProfitCenter") {
        cellInfo.value = colProfitCenter.GetValue();
        cellInfo.text = colProfitCenter.GetText();
    }
    if (currentColumn.fieldName === "AccountCode") {
        cellInfo.value = colAccountCode.GetValue();
        cellInfo.text = colAccountCode.GetText();
    }
    if (currentColumn.fieldName === "BizPartnerCode") {
        cellInfo.value = colBizPartner.GetValue();
        cellInfo.text = colBizPartner.GetText();
    }
    if (currentColumn.fieldName === "CostCenter") {
        cellInfo.value = colCostCenter.GetValue();
        cellInfo.text = colCostCenter.GetText();
    }
    if (currentColumn.fieldName === "BankAccountCode") {
        cellInfo.value = colBankAccount.GetValue();
        cellInfo.text = colBankAccount.GetText();
    }
    if (currentColumn.fieldName === "SubsidiaryCode") {
        cellInfo.value = colSubsiCode.GetValue();
        cellInfo.text = colSubsiCode.GetText();
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

function gvProductOrder_OnEndEditing(s, e) {
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


    if (valchange) {
        valchange = false;
        closing = false;
        for (var i = 0; i < s.GetColumnsCount() ; i++) {
            var column = s.GetColumn(i);
            if (column.visible == false || column.fieldName == undefined)
                continue;
            ProcessCells(0, e, column, s);
        }
        console.log('ssss')
    }

    //if (!gvprodvalid && gvProdindex != gverrindex) {
    //    gvProductOrder.batchEditApi.StartEdit(gverrindex, gvProductOrder.GetColumnByField("ItemCode").index);
    //    alert('Please edit this row before making any other changes!');
    //}
        
}

var curindex;
function gvBOM_OnEndEditing(s, e) {
    var cellInfo = e.rowValues[currentColumn.index];
    curindex = e.visibleIndex;

    if (currentColumn.fieldName === "Components") {
        cellInfo.value = bComponents.GetValue();
        cellInfo.text = bComponents.GetText();
    }
    if (currentColumn.fieldName === "StepCode") {
        cellInfo.value = bStepCode.GetValue();
        cellInfo.text = bStepCode.GetText();
    }
    if (currentColumn.fieldName === "ProductCode") {
        cellInfo.value = bProductCode.GetValue();
        cellInfo.text = bProductCode.GetText();
    }
    if (currentColumn.fieldName === "ProductColor") {
        cellInfo.value = bProductColor.GetValue();
        cellInfo.text = bProductColor.GetText();
    }
    if (currentColumn.fieldName === "ProductSize") {
        cellInfo.value = bProductSize.GetValue();
        cellInfo.text = bProductSize.GetText();
    }
    if (currentColumn.fieldName === "ItemCode") {
        cellInfo.value = BOMgl.GetValue();
        cellInfo.text = BOMgl.GetText();
    }
    if (currentColumn.fieldName === "ColorCode") {
        cellInfo.value = BOMgl2.GetValue();
        cellInfo.text = BOMgl2.GetText();
    }
    if (currentColumn.fieldName === "ClassCode") {
        cellInfo.value = BOMgl3.GetValue();
        cellInfo.text = BOMgl3.GetText();
    }
    if (currentColumn.fieldName === "SizeCode") {
        cellInfo.value = BOMgl4.GetValue();
        cellInfo.text = BOMgl4.GetText();
    }
    if (currentColumn.fieldName === "Unit") {
        cellInfo.value = BOMgl5.GetValue();
        cellInfo.text = BOMgl5.GetText();
    }


    if (BOMvalchange) {
        BOMvalchange = false;
        BOMclosing = false;
        for (var i = 0; i < s.GetColumnsCount() ; i++) {
            var column = s.GetColumn(i);
            if (column.visible == false || column.fieldName == undefined)
                continue;
            BOM_ProcessCells(0, e, column, s);
        }
    }

    //calculations();
}



function gvSteps_OnEndEditing(s, e) {
    var cellInfo = e.rowValues[currentColumn.index];

    var entry = getParameterByName('entry');

    if (currentColumn.fieldName === "Bank") {
        cellInfo.value = colBank.GetValue();
        cellInfo.text = colBank.GetText();
    }
    if (currentColumn.fieldName === "Branch") {
        cellInfo.value = colBranch.GetValue();
        cellInfo.text = colBranch.GetText();
    }
    if (currentColumn.fieldName === "ProfitCenter") {
        cellInfo.value = colProfitCenter.GetValue();
        cellInfo.text = colProfitCenter.GetText();
    }
    if (currentColumn.fieldName === "AccountCode") {
        cellInfo.value = colAccountCode.GetValue();
        cellInfo.text = colAccountCode.GetText();
    }
    if (currentColumn.fieldName === "BizPartnerCode") {
        cellInfo.value = colBizPartner.GetValue();
        cellInfo.text = colBizPartner.GetText();
    }
    if (currentColumn.fieldName === "CostCenter") {
        cellInfo.value = colCostCenter.GetValue();
        cellInfo.text = colCostCenter.GetText();
    }
    if (currentColumn.fieldName === "BankAccountCode") {
        cellInfo.value = colBankAccount.GetValue();
        cellInfo.text = colBankAccount.GetText();
    }
    if (currentColumn.fieldName === "SubsidiaryCode") {
        cellInfo.value = colSubsiCode.GetValue();
        cellInfo.text = colSubsiCode.GetText();
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

function gvStepPlanning_OnEndEditing(s, e) {
    var cellInfo = e.rowValues[currentColumn.index];

    var entry = getParameterByName('entry');

    if (currentColumn.fieldName === "StepCode") {
        cellInfo.value = dStepCode.GetValue();
        cellInfo.text = dStepCode.GetText();
    }
    if (currentColumn.fieldName === "Overhead") {
        cellInfo.value = dOverhead.GetValue();
        cellInfo.text = dOverhead.GetText();
    } 
    if (currentColumn.fieldName === "WorkCenter") {
        cellInfo.value = dWorkCenter.GetValue();
        cellInfo.text = dWorkCenter.GetText();
    }

    if (SPvalchange) {
        SPvalchange = false;
        SPclosing = false;
        for (var i = 0; i < s.GetColumnsCount() ; i++) {
            var column = s.GetColumn(i);
            if (column.visible == false || column.fieldName == undefined)
                continue;
            SP_ProcessCells(0, e, column, s);
        }
    }
}

function gvClass_OnEndEditing(s, e) {
    var cellInfo = e.rowValues[currentColumn.index];

    var entry = getParameterByName('entry');

    if (currentColumn.fieldName === "Bank") {
        cellInfo.value = colBank.GetValue();
        cellInfo.text = colBank.GetText();
    }
    if (currentColumn.fieldName === "Branch") {
        cellInfo.value = colBranch.GetValue();
        cellInfo.text = colBranch.GetText();
    }
    if (currentColumn.fieldName === "ProfitCenter") {
        cellInfo.value = colProfitCenter.GetValue();
        cellInfo.text = colProfitCenter.GetText();
    }
    if (currentColumn.fieldName === "AccountCode") {
        cellInfo.value = colAccountCode.GetValue();
        cellInfo.text = colAccountCode.GetText();
    }
    if (currentColumn.fieldName === "BizPartnerCode") {
        cellInfo.value = colBizPartner.GetValue();
        cellInfo.text = colBizPartner.GetText();
    }
    if (currentColumn.fieldName === "CostCenter") {
        cellInfo.value = colCostCenter.GetValue();
        cellInfo.text = colCostCenter.GetText();
    }
    if (currentColumn.fieldName === "BankAccountCode") {
        cellInfo.value = colBankAccount.GetValue();
        cellInfo.text = colBankAccount.GetText();
    }
    if (currentColumn.fieldName === "SubsidiaryCode") {
        cellInfo.value = colSubsiCode.GetValue();
        cellInfo.text = colSubsiCode.GetText();
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

function gvSize_OnEndEditing(s, e) {
    var cellInfo = e.rowValues[currentColumn.index];

    var entry = getParameterByName('entry');

    if (currentColumn.fieldName === "Bank") {
        cellInfo.value = colBank.GetValue();
        cellInfo.text = colBank.GetText();
    }
    if (currentColumn.fieldName === "Branch") {
        cellInfo.value = colBranch.GetValue();
        cellInfo.text = colBranch.GetText();
    }
    if (currentColumn.fieldName === "ProfitCenter") {
        cellInfo.value = colProfitCenter.GetValue();
        cellInfo.text = colProfitCenter.GetText();
    }
    if (currentColumn.fieldName === "AccountCode") {
        cellInfo.value = colAccountCode.GetValue();
        cellInfo.text = colAccountCode.GetText();
    }
    if (currentColumn.fieldName === "BizPartnerCode") {
        cellInfo.value = colBizPartner.GetValue();
        cellInfo.text = colBizPartner.GetText();
    }
    if (currentColumn.fieldName === "CostCenter") {
        cellInfo.value = colCostCenter.GetValue();
        cellInfo.text = colCostCenter.GetText();
    }
    if (currentColumn.fieldName === "BankAccountCode") {
        cellInfo.value = colBankAccount.GetValue();
        cellInfo.text = colBankAccount.GetText();
    }
    if (currentColumn.fieldName === "SubsidiaryCode") {
        cellInfo.value = colSubsiCode.GetValue();
        cellInfo.text = colSubsiCode.GetText();
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

function gvMaterial_OnEndEditing(s, e) {
    var cellInfo = e.rowValues[currentColumn.index];

    var entry = getParameterByName('entry');

    if (currentColumn.fieldName === "Bank") {
        cellInfo.value = colBank.GetValue();
        cellInfo.text = colBank.GetText();
    }
    if (currentColumn.fieldName === "Branch") {
        cellInfo.value = colBranch.GetValue();
        cellInfo.text = colBranch.GetText();
    }
    if (currentColumn.fieldName === "ProfitCenter") {
        cellInfo.value = colProfitCenter.GetValue();
        cellInfo.text = colProfitCenter.GetText();
    }
    if (currentColumn.fieldName === "AccountCode") {
        cellInfo.value = colAccountCode.GetValue();
        cellInfo.text = colAccountCode.GetText();
    }
    if (currentColumn.fieldName === "BizPartnerCode") {
        cellInfo.value = colBizPartner.GetValue();
        cellInfo.text = colBizPartner.GetText();
    }
    if (currentColumn.fieldName === "CostCenter") {
        cellInfo.value = colCostCenter.GetValue();
        cellInfo.text = colCostCenter.GetText();
    }
    if (currentColumn.fieldName === "BankAccountCode") {
        cellInfo.value = colBankAccount.GetValue();
        cellInfo.text = colBankAccount.GetText();
    }
    if (currentColumn.fieldName === "SubsidiaryCode") {
        cellInfo.value = colSubsiCode.GetValue();
        cellInfo.text = colSubsiCode.GetText();
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
function GridEnd(s, e) {
    val = s.GetGridView().cp_codes;
    console.log(val);
    if (val != null) {
        temp = val.split(';');
    }
    delete (s.GetGridView().cp_codes);

    if (val != null && val != 'undefined' && val != '') {
        for (var i = 0; i < gvProductOrder.GetColumnsCount() ; i++) {
            var column = gvProductOrder.GetColumn(i);
            if (column.visible == false || column.fieldName == undefined)
                continue;
            ProcessCells(0, editorobj, column, gvProductOrder);
            gvProductOrder.batchEditApi.EndEdit();
        }
        validateRow();
    }
}

var BOM_val;
var BOM_temp;
function BOM_GridEnd(s, e) {

    BOM_val = s.GetGridView().cp_BOMcodes;
    if (BOM_val != null) {
        BOM_temp = BOM_val.split(';');
    }
    delete (s.GetGridView().cp_BOMcodes);

    if (BOM_val != null && BOM_val != 'undefined' && BOM_val != '') {
        for (var i = 0; i < gvBOM.GetColumnsCount() ; i++) {
            var column = gvBOM.GetColumn(i);
            if (column.visible == false || column.fieldName == undefined)
                continue;
            BOM_ProcessCells(0, editorobj, column, gvBOM);
            gvBOM.batchEditApi.EndEdit();
        }
    }
    //
}

var SP_val;
var SP_temp;
function SP_GridEnd(s, e) {

    SP_val = s.GetGridView().cp_SPcodes;
    SP_identifier = s.GetGridView().cp_SPidentifier;
    if (SP_val != null) {
        SP_temp = SP_val.split(';');
    }
    delete (s.GetGridView().cp_SPcodes);
    delete (s.GetGridView().cp_SPidentifier);

    if (SPvalchange && (SP_val != null && SP_val != 'undefined' && SP_val != '')) {
        for (var i = 0; i < gvStepPlanning.GetColumnsCount() ; i++) {
            var column = gvStepPlanning.GetColumn(i);
            if (column.visible == false || column.fieldName == undefined)
                continue;
            SP_ProcessCells(0, e, column, gvStepPlanning);
            gvStepPlanning.batchEditApi.EndEdit();  
        }
    }
}

function ProcessCells(selectedIndex, e, column, s) {

    //console.log(val + " processcells");

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
        if (column.fieldName == "ColorCode") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[0]);
        }
        if (column.fieldName == "ClassCode") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[1]);
        }
        if (column.fieldName == "SizeCode") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[2]);
        }
        if (column.fieldName == "FullDesc") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[3]);
        }
        if (column.fieldName == "ItemCode") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, temp[4]);
        }
    }
}

function BOM_ProcessCells(selectedIndex, e, column, s) {

    console.log(BOM_val + " BOM_processcells")

    if (BOM_val == null) {
        BOM_val = ";;;;;;;";
        BOM_temp = BOM_val.split(';');
    }

    if (BOM_temp[0] == null) {
        BOM_temp[0] = "";
    }
    if (BOM_temp[1] == null) {
        BOM_temp[1] = "";
    }
    if (BOM_temp[2] == null) {
        BOM_temp[2] = "";
    }
    if (BOM_temp[3] == null) {
        BOM_temp[3] = "";
    }
    if (BOM_temp[4] == null) {
        BOM_temp[4] = "";
    }
    if (BOM_temp[5] == null) {
        BOM_temp[5] = "";
    }
    if (BOM_temp[6] == null) {
        BOM_temp[6] = "";
    }
            
    if (selectedIndex == 0) {
        if (column.fieldName == "ColorCode") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, BOM_temp[0]);
        }
        if (column.fieldName == "ClassCode") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, BOM_temp[1]);
        }
        if (column.fieldName == "SizeCode") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, BOM_temp[2]);
        }
        if (column.fieldName == "FullDesc") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, BOM_temp[3]);
        }
        if (column.fieldName == "Unit") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, BOM_temp[4]);
        }
        if (column.fieldName == "AllowancePerc") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, BOM_temp[5]);
        }
        if (column.fieldName == "UnitCost") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, BOM_temp[6]);
        }
    }
}

function SP_ProcessCells(selectedIndex, e, column, s) {
    //console.log(SP_val + " SP_ProcessCells")

    if (SP_val == null) {
        SP_val = ";;;;;;";
        SP_temp = SP_val.split(';');
    }
    if (SP_temp[0] == null) {
        SP_temp[0] = "";
    }
    if (SP_temp[1] == null) {
        SP_temp[1] = "";
    }
    if (SP_temp[2] == null) {
        SP_temp[2] = "";
    }
    if (SP_temp[3] == null) {
        SP_temp[3] = "";
    }
    if (SP_temp[4] == null) {
        SP_temp[4] = "";
    }
    if (SP_temp[5] == null) {
        SP_temp[5] = "";
    }
    if (SP_temp[6] == null) {
        SP_temp[6] = "";
    }
    if (SP_temp[7] == null) {
        SP_temp[7] = "";
    }

    if (selectedIndex == 0) {
        //console.log(SP_identifier)
        if (SP_identifier == "stepcode") {
            if (column.fieldName == "IsInhouse") {
                if (SP_temp[0] == "True") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, dIsInhouse.SetChecked = true);
                }
                else {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, dIsInhouse.SetChecked = false);
                }
            }
            if (column.fieldName == "Overhead") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, SP_temp[1]);
            } 
            if (column.fieldName == "WorkOrderPrice" || column.fieldName == "EstWorkOrderPrice") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, SP_temp[2]);
            }
            if (column.fieldName == "PreProd") {
                if (SP_temp[3] == "True") {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, dPreProd.SetChecked = true);
                }
                else {
                    s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, dPreProd.SetChecked = false);
                }
            }
            if (column.fieldName == "OHRate") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, SP_temp[4]);
            }
            if (column.fieldName == "OHType") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, SP_temp[5]);
            }
            if (column.fieldName == "MinPrice") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, SP_temp[6]);
            }
            if (column.fieldName == "MaxPrice") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, SP_temp[7]);
            }
        }
        if (SP_identifier == "overhead") {

            console.log(SP_temp[0] + " " + SP_temp[1])
            if (column.fieldName == "OHRate") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, SP_temp[0]);
            }
            if (column.fieldName == "OHType") {
                s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, SP_temp[1]);
            }
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


function gvProductOrder_KeyDown(s, e) { //Allows tabbing between gridlookup on details
    isSetTextRequired = false;
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode !== 9) return;
    var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
    if (gvProductOrder.batchEditApi[moveActionName]()) {
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    }
}

function gvBOM_KeyDown(s, e) { //Allows tabbing between gridlookup on details
    isSetTextRequired = false;
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode !== 9) return;
    var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
    if (gvBOM.batchEditApi[moveActionName]()) {
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    }
}

function gvSteps_KeyDown(s, e) { //Allows tabbing between gridlookup on details
    isSetTextRequired = false;
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode !== 9) return;
    var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
    if (gvSteps.batchEditApi[moveActionName]()) {
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    }
}

function gvStepPlanning_KeyDown(s, e) { //Allows tabbing between gridlookup on details
    isSetTextRequired = false;
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode !== 9) return;
    var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
    if (gvStepPlanning.batchEditApi[moveActionName]()) {
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    }
}

function gvClass_KeyDown(s, e) { //Allows tabbing between gridlookup on details
    isSetTextRequired = false;
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode !== 9) return;
    var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
    if (gvClass.batchEditApi[moveActionName]()) {
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    }
}

function gvSize_KeyDown(s, e) { //Allows tabbing between gridlookup on details
    isSetTextRequired = false;
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode !== 9) return;
    var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
    if (gvSize.batchEditApi[moveActionName]()) {
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    }
}

function gvMaterial_KeyDown(s, e) { //Allows tabbing between gridlookup on details
    isSetTextRequired = false;
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode !== 9) return;
    var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
    if (gvMaterial.batchEditApi[moveActionName]()) {
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    }
}


function gvProductOrder_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode == 13) {
        gvProductOrder.batchEditApi.EndEdit();
    }
}

function gvBOM_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode == 13) {
        gvBOM.batchEditApi.EndEdit();
    }
}

function gvSteps_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode == 13) {
        gvSteps.batchEditApi.EndEdit();
    }
}

function gvStepPlanning_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode == 13) {
        //gvStepPlanning.batchEditApi.EndEdit();
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    }
}

function gvClass_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode == 13) {
        gvClass.batchEditApi.EndEdit();
    }
}

function gvSize_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode == 13) {
        gvSize.batchEditApi.EndEdit();
    }
}

function gvMaterial_KeyPress(s, e) { //Prevents grid refresh when a user press enter key for every column
    var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
    if (keyCode == 13) {
        gvMaterial.batchEditApi.EndEdit();
    }
}


function gvProductOrder_CloseUp(s, e) {
    gvProductOrder.batchEditApi.EndEdit();
}

function gvBOM_CloseUp(s, e) {
    gvBOM.batchEditApi.EndEdit();
}

function gvSteps_CloseUp(s, e) {
    gvSteps.batchEditApi.EndEdit();
}

function gvStepPlanning_CloseUp(s, e) {
    gvStepPlanning.batchEditApi.EndEdit();
}

function gvClass_CloseUp(s, e) {
    gvBOM.batchEditApi.EndEdit();
}

function gvSize_CloseUp(s, e) {
    gvSteps.batchEditApi.EndEdit();
}

function gvMaterial_CloseUp(s, e) {
    gvStepPlanning.batchEditApi.EndEdit();
}

function PISEnabled(s, e) {
    if (aglPISNumber.GetText() == "" || aglPISNumber.GetText() == null) {
        btnPISDetail.SetEnabled(true);
    }
}


var itemclr;
var itemcls;
var itemsze;
var itemdesc;
var itemunit;
var itemqty;
var itemprice;

var itemVAT;
var itemIsVAT;
var itembulk;
var itemIsBulk;
function OnCustomClick(s, e) {
    if (e.buttonID == "ProductDetails") {
        var itemcode = gvProductOrder.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
        var colorcode = gvProductOrder.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
        var classcode = gvProductOrder.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
        var sizecode = gvProductOrder.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
        var fulldesc = gvProductOrder.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
        factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode
        + '&colorcode=' + colorcode + '&classcode=' + classcode + '&sizecode=' + sizecode + '&unit=&Warehouse=')
        
    }
    if (e.buttonID == "BOMDetails") {
        var itemcode1 = gvBOM.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
        var colorcode1 = gvBOM.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
        var classcode1 = gvBOM.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
        var sizecode1 = gvBOM.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
        var unitbase1 = gvBOM.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
        var fulldesc1 = gvBOM.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
        factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode1
        + '&colorcode=' + colorcode1 + '&classcode=' + classcode1 + '&sizecode=' + sizecode1 + '&unit=' + unitbase1 + '&Warehouse=');
    }
    if (e.buttonID == "MatDetails") {
        var itemcode2 = gvMaterial.batchEditApi.GetCellValue(e.visibleIndex, "ItemCode");
        var colorcode2 = gvMaterial.batchEditApi.GetCellValue(e.visibleIndex, "ColorCode");
        var classcode2 = gvMaterial.batchEditApi.GetCellValue(e.visibleIndex, "ClassCode");
        var sizecode2 = gvMaterial.batchEditApi.GetCellValue(e.visibleIndex, "SizeCode");
        var unitbase2 = gvMaterial.batchEditApi.GetCellValue(e.visibleIndex, "Unit");
        var fulldesc2 = gvMaterial.batchEditApi.GetCellValue(e.visibleIndex, "FullDesc");
        factbox.SetContentUrl('../FactBox/fbItem.aspx?itemcode=' + itemcode2
        + '&colorcode=' + colorcode2 + '&classcode=' + classcode2 + '&sizecode=' + sizecode2 + '&unit=' + unitbase2 + '&Warehouse=');
    }

    if (e.buttonID == "BOMDelete") {
        gvBOM.DeleteRow(e.visibleIndex);
        calculations();
    }

    if (e.buttonID == "PlanDelete") {
        var DateOut = gvStepPlanning.batchEditApi.GetCellValue(e.visibleIndex, "ActualDateOut");
        var PProd = gvStepPlanning.batchEditApi.GetCellValue(e.visibleIndex, "PreProd");

        if ((DateOut != null && DateOut != "" && DateOut != '') && PProd == true) {
            console.log(PProd + ' ' + DateOut)
        }
        else {
            gvStepPlanning.DeleteRow(e.visibleIndex);
            calculations();
        }
    }

    if (e.buttonID == "ProductDelete") {      
        gvProductOrder.DeleteRow(e.visibleIndex);
        if (gvProductOrder.GetVisibleRowsOnPage() == 0) {
            cbacker.PerformCallback('clear|')
        }
        calculations();
        getSize();
        gvProdindex = null;
        //validateRow();
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

function ProductColorFilter(s, e) {
    if (ProdItem != null || ProdItem != "") {
        bProductColor.GetGridView().PerformCallback('ColorCode' + '|' + ProdItem + '|' + s.GetInputElement().value + '|' + 'withitem');
    }
    else {
        bProductColor.GetGridView().PerformCallback('ColorCode' + '|' + 'noitem' + '|' + s.GetInputElement().value + '|' + 'noitem');
    }
}

function ProductSizeFilter(s, e) {
    if (ProdItem != null || ProdItem != "") {
        console.log('as')
        bProductSize.GetGridView().PerformCallback('SizeCode' + '|' + ProdItem + '|' + s.GetInputElement().value + '|' + 'withitem');
    }
    else {
        console.log('as2')
        bProductSize.GetGridView().PerformCallback('SizeCode' + '|' + 'noitem' + '|' + s.GetInputElement().value + '|' + 'noitem');
    }
}

Number.prototype.format = function (d, w, s, c) {
    var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
        num = this.toFixed(Math.max(0, ~~d));

    return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
};

function calculations(s, e) {
    OnInitTrans();
    calculate_header();
    calculate_BOM();
    calculate_allowance();
    calculate_AccCost();
    calculate_UnitCost();
}

function calculations_specific(s, e) {
    OnInitTrans();
    calculate_header();
    calculate_BOM_Specific();
    calculate_allowance_specific();
    calculate_AccCost();
    calculate_UnitCost();
}
        
function calculate_header(s, e) {

    //OnInitTrans();
    console.log('auto')

    //for header
    var HJOQty = 0.00;
    var HSOQty = 0.00;
    var HStdOHCost = 0.00;

    //for detail
    var DJOQty = 0.00;
    var DSOQty = 0.00;
    var DStdOHCost = 0.00;
    var DStdOHType = "";
    var DWorkOrdPrice = 0.00;
    var DNStdOHCost = 0.00;

            
    setTimeout(function () {

        var iSizes = gvSize.batchEditApi.GetRowVisibleIndices();
        var iPlanning = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
        var iProduct = gvProductOrder.batchEditApi.GetRowVisibleIndices();

        ////Total JO Qty
        //for (var i = 0; i < iSizes.length; i++) {
        //    if (gvSize.batchEditApi.IsNewRow(iSizes[i])) {

        //        DJOQty = gvSize.batchEditApi.GetCellValue(iSizes[i], "JOQty");

        //        HJOQty += DJOQty;
        //    }
        //    else {
        //        var key = gvSize.GetRowKey(iSizes[i]);
        //        if (gvSize.batchEditApi.IsDeletedRow(key)) {
        //            console.log("deleted row " + iSizes[i]);
        //        }
        //        else {
        //            DJOQty = gvSize.batchEditApi.GetCellValue(iSizes[i], "JOQty");

        //            HJOQty += DJOQty;
        //        }
        //    }
        //}

        //speTotalJO.SetValue(HJOQty);
        ////end

        //Total SO Qty
        for (var i = 0; i < iProduct.length; i++) {
            if (gvProductOrder.batchEditApi.IsNewRow(iProduct[i])) {

                DSOQty = gvProductOrder.batchEditApi.GetCellValue(iProduct[i], "SOQty");
                DJOQty = gvProductOrder.batchEditApi.GetCellValue(iProduct[i], "JOQty");

                HSOQty += DSOQty;
                HJOQty += DJOQty;
            }
            else {
                var key = gvProductOrder.GetRowKey(iProduct[i]);
                if (gvProductOrder.batchEditApi.IsDeletedRow(key)) {
                    console.log("deleted row " + iProduct[i]);
                }
                else {
                    DSOQty = gvProductOrder.batchEditApi.GetCellValue(iProduct[i], "SOQty");
                    DJOQty = gvProductOrder.batchEditApi.GetCellValue(iProduct[i], "JOQty");

                    HSOQty += DSOQty;
                    HJOQty += DJOQty;
                }
            }
        }

        speTotalSO.SetValue(HSOQty);
        speTotalJO.SetValue(HJOQty);
        //end


        //Std OH Cost
        for (var i = 0; i < iPlanning.length; i++) {
            if (gvStepPlanning.batchEditApi.IsNewRow(iPlanning[i])) {

                DStdOHCost = gvStepPlanning.batchEditApi.GetCellValue(iPlanning[i], "OHRate");
                DStdOHType = gvStepPlanning.batchEditApi.GetCellValue(iPlanning[i], "OHType");
                DWorkOrdPrice = gvStepPlanning.batchEditApi.GetCellValue(iPlanning[i], "WorkOrderPrice");

                if (DStdOHType == "A") {
                    HStdOHCost += DStdOHCost;
                }
                else if (DStdOHType == "P") {
                    DStdOHCost = (DStdOHCost * 0.01) * DWorkOrdPrice;
                    HStdOHCost += DStdOHCost;
                }


            }
            else {
                var key = gvStepPlanning.GetRowKey(iPlanning[i]);
                if (gvStepPlanning.batchEditApi.IsDeletedRow(key)) {
                    console.log("deleted row " + iPlanning[i]);
                }
                else {
                    DStdOHCost = gvStepPlanning.batchEditApi.GetCellValue(iPlanning[i], "OHRate");
                    DStdOHType = gvStepPlanning.batchEditApi.GetCellValue(iPlanning[i], "OHType");
                    DWorkOrdPrice = gvStepPlanning.batchEditApi.GetCellValue(iPlanning[i], "WorkOrderPrice");

                    if (DStdOHType == "A") {
                        HStdOHCost += DStdOHCost;
                    }
                    else if (DStdOHType == "P") {
                        DStdOHCost = (DStdOHCost * 0.01) * DWorkOrdPrice;
                        HStdOHCost += DStdOHCost;
                    }
                }
            }
        }

        speStdOHCost.SetValue(HStdOHCost);
        //end

        //speTotalOH = speStdOHCost * speTotalJO
        speTotalOH.SetValue(HStdOHCost * HJOQty);
        //end                              

    }, 500);
}

function calculate_BOM(s, e) {

    //OnInitTrans();
    console.log('BOM COnsumption')

    setTimeout(function () {

        var iSizes = gvSize.batchEditApi.GetRowVisibleIndices();
        var iPlanning = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
        var iBOM = gvBOM.batchEditApi.GetRowVisibleIndices();
        var iStepPlan = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
        var iProd = gvProductOrder.batchEditApi.GetRowVisibleIndices();

        var PrCode = "";
        var PrColor = "";
        var PrSize = "";
        var PrPPCons = 0.00;
        var PrCons = 0.00;
        var PrByBulk;
        var PrIsRounded;
        var HJOQty = 0;

        if (speTotalJO.GetValue() == "" || speTotalJO.GetValue() == '' || isNaN(speTotalJO.GetValue()) || speTotalJO.GetValue() == null) {
            HJOQty = 0;
        }
        else {
            HJOQty = speTotalJO.GetValue();
        }

        //for BOM Consumption
        for (var f = 0; f < iBOM.length; f++) {

            PrCode = gvBOM.batchEditApi.GetCellValue(iBOM[f], "ProductCode");
            PrColor = gvBOM.batchEditApi.GetCellValue(iBOM[f], "ProductColor");
            PrSize = gvBOM.batchEditApi.GetCellValue(iBOM[f], "ProductSize");
            PrPPCons = gvBOM.batchEditApi.GetCellValue(iBOM[f], "PerPieceConsumption");
            PrCons = gvBOM.batchEditApi.GetCellValue(iBOM[f], "Consumption");
            PrByBulk = gvBOM.batchEditApi.GetCellValue(iBOM[f], "IsBulk");
            PrIsRounded = gvBOM.batchEditApi.GetCellValue(iBOM[f], "IsRounded");



            if (PrCode == null) {
                PrCode = "";
            }

            if (PrColor == null) {
                PrColor = "";
            }

            if (PrSize == null) {
                PrSize = "";
            }

            var key = gvBOM.GetRowKey(iBOM[f]);
            if (gvBOM.batchEditApi.IsNewRow(key)) {

                if (PrPPCons == "" || PrPPCons == '' || isNaN(PrPPCons) || PrPPCons == null) {
                    PrPPCons = 0;
                }

                if (PrCons == "" || PrCons == '' || isNaN(PrCons) || PrCons == null) {
                    PrCons = 0;
                }

                //SIZE Only
                if ((PrCode == null || PrCode == "") && (PrColor == null || PrColor == "") && (PrSize != null || PrSize != "")) {

                    var SzSize = "";
                    var SzQty = 0.00;
                    var DSzQty = 0.00;
                    var Szcheck = 0;

                    for (var x = 0; x < iSizes.length; x++) {

                        SzSize = gvSize.batchEditApi.GetCellValue(iSizes[x], "StockSize");
                        SzQty = gvSize.batchEditApi.GetCellValue(iSizes[x], "JOQty");

                        if (SzSize == null) {
                            SzSize = "";
                        }

                        if (myTrim(SzSize) == myTrim(PrSize)) {
                            if (SzQty == 0 || SzQty == null || isNaN(SzQty)) {
                                SzQty = 0;
                            }
                            Szcheck = 1;
                            DSzQty = SzQty;
                        }
                    }

                    if ((DSzQty == 0 || DSzQty == '0.00' || DSzQty == "0.00" || DSzQty == "0" || DSzQty == 0.00) && (Szcheck != 1)) {
                        DSzQty = HJOQty;
                    }

                    if (PrByBulk == true) {
                        if (PrIsRounded == true) {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.00000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / DSzQty).toFixed(6));
                            }
                        }
                        else {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / DSzQty).toFixed(6));
                            }
                        }
                    }
                    else {
                        if (PrIsRounded == true) {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * DSzQty).toFixed(6));
                        }
                        else {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * DSzQty).toFixed(6));
                        }
                    }
                }
                    //end
                    //CODE Only
                else if ((PrCode != null || PrCode != "") && (PrColor == null || PrColor == "") && (PrSize == null || PrSize == "")) {

                    var OrCode = "";
                    var OrColor = "";
                    var OrQty = 0.00;
                    var AOrQty = 0.00;
                    var Orcheck = 0;

                    for (var y = 0; y < iProd.length; y++) {

                        OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
                        OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                        if (OrCode == null) {
                            OrCode = "";
                        }

                        if (myTrim(OrCode) == myTrim(PrCode)) {

                            if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                                OrQty = 0;
                            }

                            Orcheck = 1;
                            AOrQty = AOrQty + OrQty;
                            //AOrQty += OrQty;
                        }
                    }

                    if ((AOrQty == 0 || AOrQty == '0.00' || AOrQty == "0.00" || AOrQty == "0" || AOrQty == 0.00) && (Orcheck != 1)) {
                        AOrQty = HJOQty;
                    }

                    if (PrByBulk == true) {
                        if (PrIsRounded == true) {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / AOrQty).toFixed(6));
                            }
                        }
                        else {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / AOrQty).toFixed(6));
                            }
                        }
                    }
                    else {
                        if (PrIsRounded == true) {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * AOrQty).toFixed(6));
                        }
                        else {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * AOrQty).toFixed(6));
                        }
                    }
                }
                    //end
                    //COLOR Only
                else if ((PrCode == null || PrCode == "") && (PrColor != null || PrColor != "") && (PrSize == null || PrSize == "")) {

                    var OrCode = "";
                    var OrColor = "";
                    var OrQty = 0.00;
                    var BOrQty = 0.00;
                    var BOrcheck = 0;

                    for (var y = 0; y < iProd.length; y++) {

                        OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
                        OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                        if (OrColor == null) {
                            OrColor = "";
                        }

                        if (myTrim(OrColor) == myTrim(PrColor)) {

                            if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                                OrQty = 0;
                            }

                            BOrcheck = 1;
                            BOrQty = BOrQty + OrQty;
                            //BOrQty += OrQty;
                        }
                    }

                    if ((BOrQty == 0 || BOrQty == '0.00' || BOrQty == "0.00" || BOrQty == "0" || BOrQty == 0.00) && (BOrcheck != 1)) {
                        BOrQty = HJOQty;
                    }

                    if (PrByBulk == true) {
                        if (PrIsRounded == true) {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / BOrQty).toFixed(6));
                            }
                        }
                        else {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / BOrQty).toFixed(6));
                            }
                        }
                    }
                    else {
                        if (PrIsRounded == true) {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * BOrQty).toFixed(6));
                        }
                        else {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * BOrQty).toFixed(6));
                        }
                    }
                }
                    //end
                    //CODE and COLOR Only
                else if ((PrCode != null || PrCode != "") && (PrColor != null || PrColor != "") && (PrSize == null || PrSize == "")) {

                    var OrCode = "";
                    var OrColor = "";
                    var OrQty = 0.00;
                    var COrQty = 0.00;
                    var COrcheck = 0;

                    for (var y = 0; y < iProd.length; y++) {

                        OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
                        OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
                        OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                        if (OrCode == null) {
                            OrCode = "";
                        }

                        if (OrColor == null) {
                            OrColor = "";
                        }

                        if (myTrim(OrCode) == myTrim(PrCode) && myTrim(OrColor) == myTrim(PrColor)) {

                            if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                                OrQty = 0;
                            }

                            COrcheck = 1;
                            COrQty = COrQty + OrQty;
                            //COrQty += OrQty;
                        }
                    }

                    if ((COrQty == 0 || COrQty == '0.00' || COrQty == "0.00" || COrQty == "0" || COrQty == 0.00) && (COrcheck != 1)) {
                        COrQty = HJOQty;
                    }

                    if (PrByBulk == true) {
                        if (PrIsRounded == true) {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / COrQty).toFixed(6));
                            }
                        }
                        else {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / COrQty).toFixed(6));
                            }
                        }
                    }
                    else {
                        if (PrIsRounded == true) {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * COrQty).toFixed(6));
                        }
                        else {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * COrQty).toFixed(6));
                        }
                    }
                }
                    //end
                    //CODE and SIZE Only
                else if ((PrCode != null || PrCode != "") && (PrColor == null || PrColor == "") && (PrSize != null || PrSize != "")) {

                    var OrCode = "";
                    var OrSize = "";
                    var OrQty = 0.00;
                    var DOrQty = 0.00;
                    var DOrcheck = 0;

                    for (var y = 0; y < iProd.length; y++) {

                        OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
                        OrSize = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "SizeCode");
                        OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                        if (OrCode == null) {
                            OrCode = "";
                        }

                        if (OrSize == null) {
                            OrSize = "";
                        }

                        if (myTrim(OrCode) == myTrim(PrCode) && myTrim(OrSize) == myTrim(PrSize)) {

                            if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                                OrQty = 0;
                            }

                            DOrcheck = 1;
                            DOrQty = DOrQty + OrQty;
                            //DOrQty += OrQty;
                        }
                    }

                    if ((DOrQty == 0 || DOrQty == '0.00' || DOrQty == "0.00" || DOrQty == "0" || DOrQty == 0.00) && (DOrcheck != 1)) {
                        DOrQty = HJOQty;
                    }

                    if (PrByBulk == true) {
                        if (PrIsRounded == true) {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / DOrQty).toFixed(6));
                            }
                        }
                        else {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / DOrQty).toFixed(6));
                            }
                        }
                    }
                    else {
                        if (PrIsRounded == true) {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * DOrQty).toFixed(6));
                        }
                        else {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * DOrQty).toFixed(6));
                        }
                    }
                }
                    //end
                    //COLOR and SIZE Only
                else if ((PrCode == null || PrCode == "") && (PrColor != null || PrColor != "") && (PrSize != null || PrSize != "")) {

                    var OrColor = "";
                    var OrSize = "";
                    var OrQty = 0.00;
                    var EOrQty = 0.00;
                    var EOrcheck = 0;

                    for (var y = 0; y < iProd.length; y++) {

                        OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
                        OrSize = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "SizeCode");
                        OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                        if (OrColor == null) {
                            OrColor = "";
                        }

                        if (OrSize == null) {
                            OrSize = "";
                        }

                        if (myTrim(OrSize) == myTrim(PrSize) && myTrim(OrColor) == myTrim(PrColor)) {

                            if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                                OrQty = 0;
                            }

                            //EOrQty = EOrQty + OrQty;
                            EOrcheck = 1;
                            EOrQty += OrQty;
                        }
                    }

                    if ((EOrQty == 0 || EOrQty == '0.00' || EOrQty == "0.00" || EOrQty == "0" || EOrQty == 0.00) && (EOrcheck != 1)) {
                        EOrQty = HJOQty;
                    }

                    if (PrByBulk == true) {
                        if (PrIsRounded == true) {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / EOrQty).toFixed(6));
                            }
                        }
                        else {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / EOrQty).toFixed(6));
                            }
                        }
                    }
                    else {
                        if (PrIsRounded == true) {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * EOrQty).toFixed(6));
                        }
                        else {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * EOrQty).toFixed(6));
                        }
                    }
                }
                    //end
                    //CODE, COLOR and SIZE Only
                else if ((PrCode != null || PrCode != "") && (PrColor != null || PrColor != "") && (PrSize != null || PrSize != "")) {
                    console.log('here');
                    var OrCode = "";
                    var OrColor = "";
                    var OrSize = "";
                    var OrQty = 0.00;
                    var FOrQty = 0.00;
                    var FOrcheck = 0;

                    for (var y = 0; y < iProd.length; y++) {

                        OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
                        OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
                        OrSize = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "SizeCode");
                        OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                        if (OrCode == null) {
                            OrCode = "";
                        }

                        if (OrColor == null) {
                            OrColor = "";
                        }

                        if (OrSize == null) {
                            OrSize = "";
                        }

                        if (myTrim(OrSize) == myTrim(PrSize) && myTrim(OrColor) == myTrim(PrColor) && myTrim(OrCode) == myTrim(PrCode)) {

                            if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                                OrQty = 0;
                            }

                            //FOrQty = FOrQty + OrQty;
                            FOrcheck = 1;
                            FOrQty += OrQty;
                        }
                    }

                    if ((FOrQty == 0 || FOrQty == '0.00' || FOrQty == "0.00" || FOrQty == "0" || FOrQty == 0.00) && (FOrcheck != 1)) {
                        FOrQty = HJOQty;
                    }

                    if (PrByBulk == true) {
                        if (PrIsRounded == true) {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / FOrQty).toFixed(6));
                            }
                        }
                        else {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / FOrQty).toFixed(6));
                            }
                        }
                    }
                    else {
                        if (PrIsRounded == true) {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * FOrQty).toFixed(6));
                        }
                        else {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * FOrQty).toFixed(6));
                        }
                    }
                }
                    //end
                    //NO CODE, COLOR and SIZE 
                else if ((PrCode == null || PrCode == "") && (PrColor == null || PrColor == "") && (PrSize == null || PrSize == "")) {

                    if (PrByBulk == true) {
                        if (PrIsRounded == true) {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / HJOQty).toFixed(6));
                            }
                        }
                        else {
                            if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / HJOQty).toFixed(6));
                            }
                        }
                    }
                    else {
                        if (PrIsRounded == true) {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * HJOQty).toFixed(6));
                        }
                        else {
                            gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * HJOQty).toFixed(6));
                        }
                    }
                }
                //end

            }
            else {
                var key = gvBOM.GetRowKey(iBOM[f]);
                if (gvBOM.batchEditApi.IsDeletedRow(key)) {
                    console.log("deleted row " + iBOM[f]);
                }
                else {

                    if (PrPPCons == "" || PrPPCons == '' || isNaN(PrPPCons) || PrPPCons == null) {
                        PrPPCons = 0;
                    }

                    if (PrCons == "" || PrCons == '' || isNaN(PrCons) || PrCons == null) {
                        PrCons = 0;
                    }

                    //SIZE Only
                    if ((PrCode == null || PrCode == "") && (PrColor == null || PrColor == "") && (PrSize != null || PrSize != "")) {
                        var SzSize = "";
                        var SzQty = 0.00;
                        var DSzQty = 0.00;
                        var Szcheck = 0;

                        for (var x = 0; x < iSizes.length; x++) {

                            SzSize = gvSize.batchEditApi.GetCellValue(iSizes[x], "StockSize");
                            SzQty = gvSize.batchEditApi.GetCellValue(iSizes[x], "JOQty");

                            if (SzSize == null) {
                                SzSize = "";
                            }

                            if (myTrim(SzSize) == myTrim(PrSize)) {
                                if (SzQty == 0 || SzQty == null || isNaN(SzQty)) {
                                    SzQty = 0;
                                }
                                Szcheck = 1;
                                DSzQty = SzQty;
                            }
                        }

                        if ((DSzQty == 0 || DSzQty == '0.00' || DSzQty == "0.00" || DSzQty == "0" || DSzQty == 0.00) && (Szcheck != 1)) {
                            DSzQty = HJOQty;
                        }

                        if (PrByBulk == true) {
                            if (PrIsRounded == true) {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.00000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / DSzQty).toFixed(6));
                                }
                            }
                            else {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / DSzQty).toFixed(6));
                                }
                            }
                        }
                        else {
                            if (PrIsRounded == true) {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * DSzQty).toFixed(6));
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * DSzQty).toFixed(6));
                            }
                        }
                    }
                        //end
                        //CODE Only
                    else if ((PrCode != null || PrCode != "") && (PrColor == null || PrColor == "") && (PrSize == null || PrSize == "")) {

                        var OrCode = "";
                        var OrColor = "";
                        var OrQty = 0.00;
                        var AOrQty = 0.00;
                        var Orcheck = 0;

                        for (var y = 0; y < iProd.length; y++) {

                            OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
                            OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                            if (OrCode == null) {
                                OrCode = "";
                            }

                            if (myTrim(OrCode) == myTrim(PrCode)) {

                                if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                                    OrQty = 0;
                                }

                                Orcheck = 1;
                                AOrQty = AOrQty + OrQty;
                                //AOrQty += OrQty;
                            }
                        }

                        if ((AOrQty == 0 || AOrQty == '0.00' || AOrQty == "0.00" || AOrQty == "0" || AOrQty == 0.00) && (Orcheck != 1)) {
                            AOrQty = HJOQty;
                        }

                        if (PrByBulk == true) {
                            if (PrIsRounded == true) {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / AOrQty).toFixed(6));
                                }
                            }
                            else {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / AOrQty).toFixed(6));
                                }
                            }
                        }
                        else {
                            if (PrIsRounded == true) {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * AOrQty).toFixed(6));
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * AOrQty).toFixed(6));
                            }
                        }
                    }
                        //end
                        //COLOR Only
                    else if ((PrCode == null || PrCode == "") && (PrColor != null || PrColor != "") && (PrSize == null || PrSize == "")) {

                        var OrCode = "";
                        var OrColor = "";
                        var OrQty = 0.00;
                        var BOrQty = 0.00;
                        var BOrcheck = 0;

                        for (var y = 0; y < iProd.length; y++) {

                            OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
                            OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                            if (OrColor == null) {
                                OrColor = "";
                            }

                            if (myTrim(OrColor) == myTrim(PrColor)) {

                                if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                                    OrQty = 0;
                                }

                                BOrcheck = 1;
                                BOrQty = BOrQty + OrQty;
                                //BOrQty += OrQty;
                            }
                        }

                        if ((BOrQty == 0 || BOrQty == '0.00' || BOrQty == "0.00" || BOrQty == "0" || BOrQty == 0.00) && (BOrcheck != 1)) {
                            BOrQty = HJOQty;
                        }

                        if (PrByBulk == true) {
                            if (PrIsRounded == true) {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / BOrQty).toFixed(6));
                                }
                            }
                            else {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / BOrQty).toFixed(6));
                                }
                            }
                        }
                        else {
                            if (PrIsRounded == true) {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * BOrQty).toFixed(6));
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * BOrQty).toFixed(6));
                            }
                        }
                    }
                        //end
                        //CODE and COLOR Only
                    else if ((PrCode != null || PrCode != "") && (PrColor != null || PrColor != "") && (PrSize == null || PrSize == "")) {

                        var OrCode = "";
                        var OrColor = "";
                        var OrQty = 0.00;
                        var COrQty = 0.00;
                        var COrcheck = 0;

                        for (var y = 0; y < iProd.length; y++) {

                            OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
                            OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
                            OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                            if (OrCode == null) {
                                OrCode = "";
                            }

                            if (OrColor == null) {
                                OrColor = "";
                            }

                            if (myTrim(OrCode) == myTrim(PrCode) && myTrim(OrColor) == myTrim(PrColor)) {

                                if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                                    OrQty = 0;
                                }

                                COrcheck = 1;
                                COrQty = COrQty + OrQty;
                                //COrQty += OrQty;
                            }
                        }

                        if ((COrQty == 0 || COrQty == '0.00' || COrQty == "0.00" || COrQty == "0" || COrQty == 0.00) && (COrcheck != 1)) {
                            COrQty = HJOQty;
                        }

                        if (PrByBulk == true) {
                            if (PrIsRounded == true) {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / COrQty).toFixed(6));
                                }
                            }
                            else {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / COrQty).toFixed(6));
                                }
                            }
                        }
                        else {
                            if (PrIsRounded == true) {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * COrQty).toFixed(6));
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * COrQty).toFixed(6));
                            }
                        }
                    }
                        //end
                        //CODE and SIZE Only
                    else if ((PrCode != null || PrCode != "") && (PrColor == null || PrColor == "") && (PrSize != null || PrSize != "")) {

                        var OrCode = "";
                        var OrSize = "";
                        var OrQty = 0.00;
                        var DOrQty = 0.00;
                        var DOrcheck = 0;

                        for (var y = 0; y < iProd.length; y++) {

                            OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
                            OrSize = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "SizeCode");
                            OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                            if (OrCode == null) {
                                OrCode = "";
                            }

                            if (OrSize == null) {
                                OrSize = "";
                            }

                            if (myTrim(OrCode) == myTrim(PrCode) && myTrim(OrSize) == myTrim(PrSize)) {

                                if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                                    OrQty = 0;
                                }

                                DOrcheck = 1;
                                DOrQty = DOrQty + OrQty;
                                //DOrQty += OrQty;
                            }
                        }

                        if ((DOrQty == 0 || DOrQty == '0.00' || DOrQty == "0.00" || DOrQty == "0" || DOrQty == 0.00) && (DOrcheck != 1)) {
                            DOrQty = HJOQty;
                        }

                        if (PrByBulk == true) {
                            if (PrIsRounded == true) {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / DOrQty).toFixed(6));
                                }
                            }
                            else {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / DOrQty).toFixed(6));
                                }
                            }
                        }
                        else {
                            if (PrIsRounded == true) {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * DOrQty).toFixed(6));
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * DOrQty).toFixed(6));
                            }
                        }
                    }
                        //end
                        //COLOR and SIZE Only
                    else if ((PrCode == null || PrCode == "") && (PrColor != null || PrColor != "") && (PrSize != null || PrSize != "")) {

                        var OrColor = "";
                        var OrSize = "";
                        var OrQty = 0.00;
                        var EOrQty = 0.00;
                        var EOrcheck = 0;

                        for (var y = 0; y < iProd.length; y++) {

                            OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
                            OrSize = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "SizeCode");
                            OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                            if (OrColor == null) {
                                OrColor = "";
                            }

                            if (OrSize == null) {
                                OrSize = "";
                            }

                            if (myTrim(OrSize) == myTrim(PrSize) && myTrim(OrColor) == myTrim(PrColor)) {

                                if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                                    OrQty = 0;
                                }

                                //EOrQty = EOrQty + OrQty;
                                EOrcheck = 1;
                                EOrQty += OrQty;
                            }
                        }

                        if ((EOrQty == 0 || EOrQty == '0.00' || EOrQty == "0.00" || EOrQty == "0" || EOrQty == 0.00) && (EOrcheck != 1)) {
                            EOrQty = HJOQty;
                        }

                        if (PrByBulk == true) {
                            if (PrIsRounded == true) {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / EOrQty).toFixed(6));
                                }
                            }
                            else {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / EOrQty).toFixed(6));
                                }
                            }
                        }
                        else {
                            if (PrIsRounded == true) {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * EOrQty).toFixed(6));
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * EOrQty).toFixed(6));
                            }
                        }
                    }
                        //end
                        //CODE, COLOR and SIZE Only
                    else if ((PrCode != null || PrCode != "") && (PrColor != null || PrColor != "") && (PrSize != null || PrSize != "")) {
                        var OrCode = "";
                        var OrColor = "";
                        var OrSize = "";
                        var OrQty = 0.00;
                        var FOrQty = 0.00;
                        var FOrcheck = 0;

                        for (var y = 0; y < iProd.length; y++) {

                            OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
                            OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
                            OrSize = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "SizeCode");
                            OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                            if (OrCode == null) {
                                OrCode = "";
                            }

                            if (OrColor == null) {
                                OrColor = "";
                            }

                            if (OrSize == null) {
                                OrSize = "";
                            }

                            if (myTrim(OrSize) == myTrim(PrSize) && myTrim(OrColor) == myTrim(PrColor) && myTrim(OrCode) == myTrim(PrCode)) {

                                if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                                    OrQty = 0;
                                }

                                //FOrQty = FOrQty + OrQty;
                                FOrcheck = 1;
                                FOrQty += OrQty;
                            }
                        }

                        if ((FOrQty == 0 || FOrQty == '0.00' || FOrQty == "0.00" || FOrQty == "0" || FOrQty == 0.00) && (FOrcheck != 1)) {
                            FOrQty = HJOQty;
                        }

                        if (PrByBulk == true) {
                            if (PrIsRounded == true) {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / FOrQty).toFixed(6));
                                }
                            }
                            else {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / FOrQty).toFixed(6));
                                }
                            }
                        }
                        else {
                            if (PrIsRounded == true) {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * FOrQty).toFixed(6));
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * FOrQty).toFixed(6));
                            }
                        }
                    }
                        //end
                        //NO CODE, COLOR and SIZE 
                    else if ((PrCode == null || PrCode == "") && (PrColor == null || PrColor == "") && (PrSize == null || PrSize == "")) {

                        if (PrByBulk == true) {
                            if (PrIsRounded == true) {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / HJOQty).toFixed(6));
                                }
                            }
                            else {
                                if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", "0.000000");
                                }
                                else {
                                    gvBOM.batchEditApi.SetCellValue(iBOM[f], "PerPieceConsumption", (PrCons / HJOQty).toFixed(6));
                                }
                            }
                        }
                        else {
                            if (PrIsRounded == true) {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", Math.ceil(PrPPCons * HJOQty).toFixed(6));
                            }
                            else {
                                gvBOM.batchEditApi.SetCellValue(iBOM[f], "Consumption", (PrPPCons * HJOQty).toFixed(6));
                            }
                        }
                    }
                    //end
                }
            }
        }
        //end

    }, 500);
}

function calculate_BOM_Specific(s, e) {

    //OnInitTrans();
    console.log('BOM Specific')

    setTimeout(function () {

        var iSizes = gvSize.batchEditApi.GetRowVisibleIndices();
        var iPlanning = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
        var iBOM = gvBOM.batchEditApi.GetRowVisibleIndices();
        var iStepPlan = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
        var iProd = gvProductOrder.batchEditApi.GetRowVisibleIndices();

        var PrCode = "";
        var PrColor = "";
        var PrSize = "";
        var PrPPCons = 0.00;
        var PrCons = 0.00;
        var PrByBulk;
        var PrIsRounded;
        var HJOQty = 0;

        if (speTotalJO.GetValue() == "" || speTotalJO.GetValue() == '' || isNaN(speTotalJO.GetValue()) || speTotalJO.GetValue() == null) {
            HJOQty = 0;
        }
        else {
            HJOQty = speTotalJO.GetValue();
        }

        //for BOM Consumption
        //for (var f = 0; f < iBOM.length; f++) {

        PrCode = gvBOM.batchEditApi.GetCellValue(curindex, "ProductCode");
        PrColor = gvBOM.batchEditApi.GetCellValue(curindex, "ProductColor");
        PrSize = gvBOM.batchEditApi.GetCellValue(curindex, "ProductSize");
        PrPPCons = gvBOM.batchEditApi.GetCellValue(curindex, "PerPieceConsumption");
        PrCons = gvBOM.batchEditApi.GetCellValue(curindex, "Consumption");
        PrByBulk = gvBOM.batchEditApi.GetCellValue(curindex, "IsBulk");
        PrIsRounded = gvBOM.batchEditApi.GetCellValue(curindex, "IsRounded");



        if (PrCode == null) {
            PrCode = "";
        }

        if (PrColor == null) {
            PrColor = "";
        }

        if (PrSize == null) {
            PrSize = "";
        }

        var key = gvBOM.GetRowKey(0);
        //console.log(key, BIndex, iBOM[BIndex]);
        //if (gvBOM.batchEditApi.IsNewRow(key)) {

        if (PrPPCons == "" || PrPPCons == '' || isNaN(PrPPCons) || PrPPCons == null) {
            PrPPCons = 0;
        }

        if (PrCons == "" || PrCons == '' || isNaN(PrCons) || PrCons == null) {
            PrCons = 0;
        }
        //console.log('con')
        //SIZE Only
        if ((PrCode == null || PrCode == "") && (PrColor == null || PrColor == "") && (PrSize != null || PrSize != "")) {
            //console.log('con')
            var SzSize = "";
            var SzQty = 0.00;
            var DSzQty = 0.00;
            var Szcheck = 0;

            for (var x = 0; x < iSizes.length; x++) {

                SzSize = gvSize.batchEditApi.GetCellValue(iSizes[x], "StockSize");
                SzQty = gvSize.batchEditApi.GetCellValue(iSizes[x], "JOQty");

                if (SzSize == null) {
                    SzSize = "";
                }

                if (myTrim(SzSize) == myTrim(PrSize)) {
                    if (SzQty == 0 || SzQty == null || isNaN(SzQty)) {
                        SzQty = 0;
                    }
                    Szcheck = 1;
                    DSzQty = SzQty;
                }
            }

            if ((DSzQty == 0 || DSzQty == '0.00' || DSzQty == "0.00" || DSzQty == "0" || DSzQty == 0.00) && (Szcheck != 1)) {
                DSzQty = HJOQty;
            }
            //console.log(DSzQty, 'DSzQty')

            if (PrByBulk == true) {
                if (PrIsRounded == true) {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.00000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", Math.ceil((PrCons / DSzQty).toFixed(6)));
                    }
                }
                else {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", (PrCons / DSzQty).toFixed(6));
                    }
                }
            }
            else {
                if (PrIsRounded == true) {
                    console.log(PrPPCons, DSzQty)
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", Math.ceil(PrPPCons * DSzQty).toFixed(6));
                }
                else {

                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", (PrPPCons * DSzQty).toFixed(6));
                }
            }
        }
            //end
            //CODE Only
        else if ((PrCode != null || PrCode != "") && (PrColor == null || PrColor == "") && (PrSize == null || PrSize == "")) {

            var OrCode = "";
            var OrColor = "";
            var OrQty = 0.00;
            var AOrQty = 0.00;
            var Orcheck = 0;

            for (var y = 0; y < iProd.length; y++) {

                OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
                OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                if (OrCode == null) {
                    OrCode = "";
                }

                if (myTrim(OrCode) == myTrim(PrCode)) {

                    if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                        OrQty = 0;
                    }

                    Orcheck = 1;
                    AOrQty = AOrQty + OrQty;
                    //AOrQty += OrQty;
                }
            }

            if ((AOrQty == 0 || AOrQty == '0.00' || AOrQty == "0.00" || AOrQty == "0" || AOrQty == 0.00) && (Orcheck != 1)) {
                AOrQty = HJOQty;
            }

            if (PrByBulk == true) {
                if (PrIsRounded == true) {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", Math.ceil((PrCons / AOrQty).toFixed(6)));
                    }
                }
                else {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", (PrCons / AOrQty).toFixed(6));
                    }
                }
            }
            else {
                if (PrIsRounded == true) {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", Math.ceil(PrPPCons * AOrQty).toFixed(6));
                }
                else {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", (PrPPCons * AOrQty).toFixed(6));
                }
            }
        }
            //end
            //COLOR Only
        else if ((PrCode == null || PrCode == "") && (PrColor != null || PrColor != "") && (PrSize == null || PrSize == "")) {

            var OrCode = "";
            var OrColor = "";
            var OrQty = 0.00;
            var BOrQty = 0.00;
            var BOrcheck = 0;

            for (var y = 0; y < iProd.length; y++) {

                OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
                OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                if (OrColor == null) {
                    OrColor = "";
                }

                if (myTrim(OrColor) == myTrim(PrColor)) {

                    if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                        OrQty = 0;
                    }

                    BOrcheck = 1;
                    BOrQty = BOrQty + OrQty;
                    //BOrQty += OrQty;
                }
            }

            if ((BOrQty == 0 || BOrQty == '0.00' || BOrQty == "0.00" || BOrQty == "0" || BOrQty == 0.00) && (BOrcheck != 1)) {
                BOrQty = HJOQty;
            }

            if (PrByBulk == true) {
                if (PrIsRounded == true) {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", Math.ceil((PrCons / BOrQty).toFixed(6)));
                    }
                }
                else {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", (PrCons / BOrQty).toFixed(6));
                    }
                }
            }
            else {
                if (PrIsRounded == true) {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", Math.ceil(PrPPCons * BOrQty).toFixed(6));
                }
                else {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", (PrPPCons * BOrQty).toFixed(6));
                }
            }
        }
            //end
            //CODE and COLOR Only
        else if ((PrCode != null || PrCode != "") && (PrColor != null || PrColor != "") && (PrSize == null || PrSize == "")) {

            var OrCode = "";
            var OrColor = "";
            var OrQty = 0.00;
            var COrQty = 0.00;
            var COrcheck = 0;

            for (var y = 0; y < iProd.length; y++) {

                OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
                OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
                OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                if (OrCode == null) {
                    OrCode = "";
                }

                if (OrColor == null) {
                    OrColor = "";
                }

                if (myTrim(OrCode) == myTrim(PrCode) && myTrim(OrColor) == myTrim(PrColor)) {

                    if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                        OrQty = 0;
                    }

                    COrcheck = 1;
                    COrQty = COrQty + OrQty;
                    //COrQty += OrQty;
                }
            }

            if ((COrQty == 0 || COrQty == '0.00' || COrQty == "0.00" || COrQty == "0" || COrQty == 0.00) && (COrcheck != 1)) {
                COrQty = HJOQty;
            }

            if (PrByBulk == true) {
                if (PrIsRounded == true) {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", Math.ceil((PrCons / COrQty).toFixed(6)));
                    }
                }
                else {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", (PrCons / COrQty).toFixed(6));
                    }
                }
            }
            else {
                if (PrIsRounded == true) {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", Math.ceil(PrPPCons * COrQty).toFixed(6));
                }
                else {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", (PrPPCons * COrQty).toFixed(6));
                }
            }
        }
            //end
            //CODE and SIZE Only
        else if ((PrCode != null || PrCode != "") && (PrColor == null || PrColor == "") && (PrSize != null || PrSize != "")) {

            var OrCode = "";
            var OrSize = "";
            var OrQty = 0.00;
            var DOrQty = 0.00;
            var DOrcheck = 0;

            for (var y = 0; y < iProd.length; y++) {

                OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
                OrSize = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "SizeCode");
                OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                if (OrCode == null) {
                    OrCode = "";
                }

                if (OrSize == null) {
                    OrSize = "";
                }

                if (myTrim(OrCode) == myTrim(PrCode) && myTrim(OrSize) == myTrim(PrSize)) {

                    if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                        OrQty = 0;
                    }

                    DOrcheck = 1;
                    DOrQty = DOrQty + OrQty;
                    //DOrQty += OrQty;
                }
            }

            if ((DOrQty == 0 || DOrQty == '0.00' || DOrQty == "0.00" || DOrQty == "0" || DOrQty == 0.00) && (DOrcheck != 1)) {
                DOrQty = HJOQty;
            }

            if (PrByBulk == true) {
                if (PrIsRounded == true) {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", Math.ceil((PrCons / DOrQty).toFixed(6)));
                    }
                }
                else {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", (PrCons / DOrQty).toFixed(6));
                    }
                }
            }
            else {
                if (PrIsRounded == true) {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", Math.ceil(PrPPCons * DOrQty).toFixed(6));
                }
                else {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", (PrPPCons * DOrQty).toFixed(6));
                }
            }
        }
            //end
            //COLOR and SIZE Only
        else if ((PrCode == null || PrCode == "") && (PrColor != null || PrColor != "") && (PrSize != null || PrSize != "")) {

            var OrColor = "";
            var OrSize = "";
            var OrQty = 0.00;
            var EOrQty = 0.00;
            var EOrcheck = 0;

            for (var y = 0; y < iProd.length; y++) {

                OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
                OrSize = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "SizeCode");
                OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                if (OrColor == null) {
                    OrColor = "";
                }

                if (OrSize == null) {
                    OrSize = "";
                }

                if (myTrim(OrSize) == myTrim(PrSize) && myTrim(OrColor) == myTrim(PrColor)) {

                    if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                        OrQty = 0;
                    }

                    //EOrQty = EOrQty + OrQty;
                    EOrcheck = 1;
                    EOrQty += OrQty;
                }
            }

            if ((EOrQty == 0 || EOrQty == '0.00' || EOrQty == "0.00" || EOrQty == "0" || EOrQty == 0.00) && (EOrcheck != 1)) {
                EOrQty = HJOQty;
            }

            if (PrByBulk == true) {
                if (PrIsRounded == true) {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", Math.ceil((PrCons / EOrQty).toFixed(6)));
                    }
                }
                else {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", (PrCons / EOrQty).toFixed(6));
                    }
                }
            }
            else {
                if (PrIsRounded == true) {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", Math.ceil(PrPPCons * EOrQty).toFixed(6));
                }
                else {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", (PrPPCons * EOrQty).toFixed(6));
                }
            }
        }
            //end
            //CODE, COLOR and SIZE Only
        else if ((PrCode != null || PrCode != "") && (PrColor != null || PrColor != "") && (PrSize != null || PrSize != "")) {

            var OrCode = "";
            var OrColor = "";
            var OrSize = "";
            var OrQty = 0.00;
            var FOrQty = 0.00;
            var FOrcheck = 0;

            for (var y = 0; y < iProd.length; y++) {

                OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
                OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
                OrSize = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "SizeCode");
                OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

                if (OrCode == null) {
                    OrCode = "";
                }

                if (OrColor == null) {
                    OrColor = "";
                }

                if (OrSize == null) {
                    OrSize = "";
                }

                if (myTrim(OrSize) == myTrim(PrSize) && myTrim(OrColor) == myTrim(PrColor) && myTrim(OrCode) == myTrim(PrCode)) {

                    if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
                        OrQty = 0;
                    }

                    //FOrQty = FOrQty + OrQty;
                    FOrcheck = 1;
                    FOrQty += OrQty;
                }
            }

            if ((FOrQty == 0 || FOrQty == '0.00' || FOrQty == "0.00" || FOrQty == "0" || FOrQty == 0.00) && (FOrcheck != 1)) {
                FOrQty = HJOQty;
            }

            if (PrByBulk == true) {
                if (PrIsRounded == true) {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", Math.ceil((PrCons / FOrQty).toFixed(6)));
                    }
                }
                else {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", (PrCons / FOrQty).toFixed(6));
                    }
                }
            }
            else {
                if (PrIsRounded == true) {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", Math.ceil(PrPPCons * FOrQty).toFixed(6));
                }
                else {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", (PrPPCons * FOrQty).toFixed(6));
                }
            }
        }
            //end
            //NO CODE, COLOR and SIZE 
        else if ((PrCode == null || PrCode == "") && (PrColor == null || PrColor == "") && (PrSize == null || PrSize == "")) {

            if (PrByBulk == true) {
                if (PrIsRounded == true) {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", Math.ceil((PrCons / HJOQty).toFixed(6)));
                    }
                }
                else {
                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", "0.000000");
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(curindex, "PerPieceConsumption", (PrCons / HJOQty).toFixed(6));
                    }
                }
            }
            else {
                if (PrIsRounded == true) {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", Math.ceil(PrPPCons * HJOQty).toFixed(6));
                }
                else {
                    gvBOM.batchEditApi.SetCellValue(curindex, "Consumption", (PrPPCons * HJOQty).toFixed(6));
                }
            }
        }
        //end

        //}
        //else {
        //    var key = gvBOM.GetRowKey(iBOM[BIndex]);
        //    if (gvBOM.batchEditApi.IsDeletedRow(key)) {
        //        console.log("deleted row " + iBOM[BIndex]);
        //    }
        //    else {

        //        if (PrPPCons == "" || PrPPCons == '' || isNaN(PrPPCons) || PrPPCons == null) {
        //            PrPPCons = 0;
        //        }

        //        if (PrCons == "" || PrCons == '' || isNaN(PrCons) || PrCons == null) {
        //            PrCons = 0;
        //        }

        //        //SIZE Only
        //        if ((PrCode == null || PrCode == "") && (PrColor == null || PrColor == "") && (PrSize != null || PrSize != "")) {

        //            var SzSize = "";
        //            var SzQty = 0.00;
        //            var DSzQty = 0.00;
        //            var Szcheck = 0;

        //            for (var x = 0; x < iSizes.length; x++) {

        //                SzSize = gvSize.batchEditApi.GetCellValue(iSizes[x], "StockSize");
        //                SzQty = gvSize.batchEditApi.GetCellValue(iSizes[x], "JOQty");

        //                if (SzSize == null) {
        //                    SzSize = "";
        //                }

        //                if (myTrim(SzSize) == myTrim(PrSize)) {
        //                    if (SzQty == 0 || SzQty == null || isNaN(SzQty)) {
        //                        SzQty = 0;
        //                    }
        //                    Szcheck = 1;
        //                    DSzQty = SzQty;
        //                }
        //            }

        //            if ((DSzQty == 0 || DSzQty == '0.00' || DSzQty == "0.00" || DSzQty == "0" || DSzQty == 0.00) && (Szcheck != 1)) {
        //                DSzQty = HJOQty;
        //            }

        //            if (PrByBulk == true) {
        //                if (PrIsRounded == true) {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.00000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", Math.ceil(PrCons / DSzQty).toFixed(6));
        //                    }
        //                }
        //                else {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", (PrCons / DSzQty).toFixed(6));
        //                    }
        //                }
        //            }
        //            else {
        //                if (PrIsRounded == true) {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", Math.ceil(PrPPCons * DSzQty).toFixed(6));
        //                }
        //                else {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", (PrPPCons * DSzQty).toFixed(6));
        //                }
        //            }
        //        }
        //            //end
        //            //CODE Only
        //        else if ((PrCode != null || PrCode != "") && (PrColor == null || PrColor == "") && (PrSize == null || PrSize == "")) {

        //            var OrCode = "";
        //            var OrColor = "";
        //            var OrQty = 0.00;
        //            var AOrQty = 0.00;
        //            var Orcheck = 0;

        //            for (var y = 0; y < iProd.length; y++) {

        //                OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
        //                OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

        //                if (OrCode == null) {
        //                    OrCode = "";
        //                }

        //                if (myTrim(OrCode) == myTrim(PrCode)) {

        //                    if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
        //                        OrQty = 0;
        //                    }

        //                    Orcheck = 1;
        //                    AOrQty = AOrQty + OrQty;
        //                    //AOrQty += OrQty;
        //                }
        //            }

        //            if ((AOrQty == 0 || AOrQty == '0.00' || AOrQty == "0.00" || AOrQty == "0" || AOrQty == 0.00) && (Orcheck != 1)) {
        //                AOrQty = HJOQty;
        //            }

        //            if (PrByBulk == true) {
        //                if (PrIsRounded == true) {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", Math.ceil(PrCons / AOrQty).toFixed(6));
        //                    }
        //                }
        //                else {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", (PrCons / AOrQty).toFixed(6));
        //                    }
        //                }
        //            }
        //            else {
        //                if (PrIsRounded == true) {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", Math.ceil(PrPPCons * AOrQty).toFixed(6));
        //                }
        //                else {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", (PrPPCons * AOrQty).toFixed(6));
        //                }
        //            }
        //        }
        //            //end
        //            //COLOR Only
        //        else if ((PrCode == null || PrCode == "") && (PrColor != null || PrColor != "") && (PrSize == null || PrSize == "")) {

        //            var OrCode = "";
        //            var OrColor = "";
        //            var OrQty = 0.00;
        //            var BOrQty = 0.00;
        //            var BOrcheck = 0;

        //            for (var y = 0; y < iProd.length; y++) {

        //                OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
        //                OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

        //                if (OrColor == null) {
        //                    OrColor = "";
        //                }

        //                if (myTrim(OrColor) == myTrim(PrColor)) {

        //                    if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
        //                        OrQty = 0;
        //                    }

        //                    BOrcheck = 1;
        //                    BOrQty = BOrQty + OrQty;
        //                    //BOrQty += OrQty;
        //                }
        //            }

        //            if ((BOrQty == 0 || BOrQty == '0.00' || BOrQty == "0.00" || BOrQty == "0" || BOrQty == 0.00) && (BOrcheck != 1)) {
        //                BOrQty = HJOQty;
        //            }

        //            if (PrByBulk == true) {
        //                if (PrIsRounded == true) {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", Math.ceil(PrCons / BOrQty).toFixed(6));
        //                    }
        //                }
        //                else {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", (PrCons / BOrQty).toFixed(6));
        //                    }
        //                }
        //            }
        //            else {
        //                if (PrIsRounded == true) {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", Math.ceil(PrPPCons * BOrQty).toFixed(6));
        //                }
        //                else {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", (PrPPCons * BOrQty).toFixed(6));
        //                }
        //            }
        //        }
        //            //end
        //            //CODE and COLOR Only
        //        else if ((PrCode != null || PrCode != "") && (PrColor != null || PrColor != "") && (PrSize == null || PrSize == "")) {

        //            var OrCode = "";
        //            var OrColor = "";
        //            var OrQty = 0.00;
        //            var COrQty = 0.00;
        //            var COrcheck = 0;

        //            for (var y = 0; y < iProd.length; y++) {

        //                OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
        //                OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
        //                OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

        //                if (OrCode == null) {
        //                    OrCode = "";
        //                }

        //                if (OrColor == null) {
        //                    OrColor = "";
        //                }

        //                if (myTrim(OrCode) == myTrim(PrCode) && myTrim(OrColor) == myTrim(PrColor)) {

        //                    if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
        //                        OrQty = 0;
        //                    }

        //                    COrcheck = 1;
        //                    COrQty = COrQty + OrQty;
        //                    //COrQty += OrQty;
        //                }
        //            }

        //            if ((COrQty == 0 || COrQty == '0.00' || COrQty == "0.00" || COrQty == "0" || COrQty == 0.00) && (COrcheck != 1)) {
        //                COrQty = HJOQty;
        //            }

        //            if (PrByBulk == true) {
        //                if (PrIsRounded == true) {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", Math.ceil(PrCons / COrQty).toFixed(6));
        //                    }
        //                }
        //                else {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", (PrCons / COrQty).toFixed(6));
        //                    }
        //                }
        //            }
        //            else {
        //                if (PrIsRounded == true) {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", Math.ceil(PrPPCons * COrQty).toFixed(6));
        //                }
        //                else {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", (PrPPCons * COrQty).toFixed(6));
        //                }
        //            }
        //        }
        //            //end
        //            //CODE and SIZE Only
        //        else if ((PrCode != null || PrCode != "") && (PrColor == null || PrColor == "") && (PrSize != null || PrSize != "")) {

        //            var OrCode = "";
        //            var OrSize = "";
        //            var OrQty = 0.00;
        //            var DOrQty = 0.00;
        //            var DOrcheck = 0;

        //            for (var y = 0; y < iProd.length; y++) {

        //                OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
        //                OrSize = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "SizeCode");
        //                OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

        //                if (OrCode == null) {
        //                    OrCode = "";
        //                }

        //                if (OrSize == null) {
        //                    OrSize = "";
        //                }

        //                if (myTrim(OrCode) == myTrim(PrCode) && myTrim(OrSize) == myTrim(PrSize)) {

        //                    if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
        //                        OrQty = 0;
        //                    }

        //                    DOrcheck = 1;
        //                    DOrQty = DOrQty + OrQty;
        //                    //DOrQty += OrQty;
        //                }
        //            }

        //            if ((DOrQty == 0 || DOrQty == '0.00' || DOrQty == "0.00" || DOrQty == "0" || DOrQty == 0.00) && (DOrcheck != 1)) {
        //                DOrQty = HJOQty;
        //            }

        //            if (PrByBulk == true) {
        //                if (PrIsRounded == true) {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", Math.ceil(PrCons / DOrQty).toFixed(6));
        //                    }
        //                }
        //                else {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", (PrCons / DOrQty).toFixed(6));
        //                    }
        //                }
        //            }
        //            else {
        //                if (PrIsRounded == true) {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", Math.ceil(PrPPCons * DOrQty).toFixed(6));
        //                }
        //                else {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", (PrPPCons * DOrQty).toFixed(6));
        //                }
        //            }
        //        }
        //            //end
        //            //COLOR and SIZE Only
        //        else if ((PrCode == null || PrCode == "") && (PrColor != null || PrColor != "") && (PrSize != null || PrSize != "")) {

        //            var OrColor = "";
        //            var OrSize = "";
        //            var OrQty = 0.00;
        //            var EOrQty = 0.00;
        //            var EOrcheck = 0;

        //            for (var y = 0; y < iProd.length; y++) {

        //                OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
        //                OrSize = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "SizeCode");
        //                OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

        //                if (OrColor == null) {
        //                    OrColor = "";
        //                }

        //                if (OrSize == null) {
        //                    OrSize = "";
        //                }

        //                if (myTrim(OrSize) == myTrim(PrSize) && myTrim(OrColor) == myTrim(PrColor)) {

        //                    if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
        //                        OrQty = 0;
        //                    }

        //                    //EOrQty = EOrQty + OrQty;
        //                    EOrcheck = 1;
        //                    EOrQty += OrQty;
        //                }
        //            }

        //            if ((EOrQty == 0 || EOrQty == '0.00' || EOrQty == "0.00" || EOrQty == "0" || EOrQty == 0.00) && (EOrcheck != 1)) {
        //                EOrQty = HJOQty;
        //            }

        //            if (PrByBulk == true) {
        //                if (PrIsRounded == true) {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", Math.ceil(PrCons / EOrQty).toFixed(6));
        //                    }
        //                }
        //                else {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", (PrCons / EOrQty).toFixed(6));
        //                    }
        //                }
        //            }
        //            else {
        //                if (PrIsRounded == true) {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", Math.ceil(PrPPCons * EOrQty).toFixed(6));
        //                }
        //                else {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", (PrPPCons * EOrQty).toFixed(6));
        //                }
        //            }
        //        }
        //            //end
        //            //CODE, COLOR and SIZE Only
        //        else if ((PrCode != null || PrCode != "") && (PrColor != null || PrColor != "") && (PrSize != null || PrSize != "")) {

        //            var OrCode = "";
        //            var OrColor = "";
        //            var OrSize = "";
        //            var OrQty = 0.00;
        //            var FOrQty = 0.00;
        //            var FOrcheck = 0;

        //            for (var y = 0; y < iProd.length; y++) {

        //                OrCode = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ItemCode");
        //                OrColor = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "ColorCode");
        //                OrSize = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "SizeCode");
        //                OrQty = gvProductOrder.batchEditApi.GetCellValue(iProd[y], "JOQty");

        //                if (OrCode == null) {
        //                    OrCode = "";
        //                }

        //                if (OrColor == null) {
        //                    OrColor = "";
        //                }

        //                if (OrSize == null) {
        //                    OrSize = "";
        //                }

        //                if (myTrim(OrSize) == myTrim(PrSize) && myTrim(OrColor) == myTrim(PrColor) && myTrim(OrCode) == myTrim(PrCode)) {

        //                    if (OrQty == 0 || OrQty == null || isNaN(OrQty)) {
        //                        OrQty = 0;
        //                    }

        //                    //FOrQty = FOrQty + OrQty;
        //                    FOrcheck = 1;
        //                    FOrQty += OrQty;
        //                }
        //            }

        //            if ((FOrQty == 0 || FOrQty == '0.00' || FOrQty == "0.00" || FOrQty == "0" || FOrQty == 0.00) && (FOrcheck != 1)) {
        //                FOrQty = HJOQty;
        //            }

        //            if (PrByBulk == true) {
        //                if (PrIsRounded == true) {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", Math.ceil(PrCons / FOrQty).toFixed(6));
        //                    }
        //                }
        //                else {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", (PrCons / FOrQty).toFixed(6));
        //                    }
        //                }
        //            }
        //            else {
        //                if (PrIsRounded == true) {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", Math.ceil(PrPPCons * FOrQty).toFixed(6));
        //                }
        //                else {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", (PrPPCons * FOrQty).toFixed(6));
        //                }
        //            }
        //        }
        //            //end
        //            //NO CODE, COLOR and SIZE 
        //        else if ((PrCode == null || PrCode == "") && (PrColor == null || PrColor == "") && (PrSize == null || PrSize == "")) {

        //            if (PrByBulk == true) {
        //                if (PrIsRounded == true) {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", Math.ceil(PrCons / HJOQty).toFixed(6));
        //                    }
        //                }
        //                else {
        //                    if (PrCons == "0" || PrCons == '0' || isNaN(PrCons) || PrCons == null || PrCons == "0.00" || PrCons == '0.00') {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", "0.000000");
        //                    }
        //                    else {
        //                        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "PerPieceConsumption", (PrCons / HJOQty).toFixed(6));
        //                    }
        //                }
        //            }
        //            else {
        //                if (PrIsRounded == true) {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", Math.ceil(PrPPCons * HJOQty).toFixed(6));
        //                }
        //                else {
        //                    gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "Consumption", (PrPPCons * HJOQty).toFixed(6));
        //                }
        //            }
        //        }
        //        //end
        //    }
        //}
        //}
        //end

    }, 500);
}

function calculate_allowance(s, e) {

    //OnInitTrans();
    //console.log('calculate_allowance')

    setTimeout(function () {

        var iBOM = gvBOM.batchEditApi.GetRowVisibleIndices();

        //Allowance Qty Update
        for (var g = 0; g < iBOM.length; g++) {
            if (gvBOM.batchEditApi.IsNewRow(iBOM[g])) {

                var aCons = 0.000000;
                var aPerc = 0.000000;
                var aReq;

                var PrIsRounded = gvBOM.batchEditApi.GetCellValue(iBOM[g], "IsRounded");
                aCons = gvBOM.batchEditApi.GetCellValue(iBOM[g], "Consumption");
                aPerc = gvBOM.batchEditApi.GetCellValue(iBOM[g], "AllowancePerc");
                aReq = Number(aCons) + Number(aCons * (aPerc * 0.01))

                //gvBOM.batchEditApi.SetCellValue(iBOM[g], "AllowanceQty", Math.ceil(aCons * (aPerc * 0.01)).toFixed(6));
                //gvBOM.batchEditApi.SetCellValue(iBOM[g], "RequiredQty", Math.ceil(aReq).toFixed(6));

                if (PrIsRounded == true) {
                    gvBOM.batchEditApi.SetCellValue(iBOM[g], "AllowanceQty", Math.ceil(aCons * (aPerc * 0.01)).toFixed(6));
                    gvBOM.batchEditApi.SetCellValue(iBOM[g], "RequiredQty", Math.ceil(aReq).toFixed(6));
                }
                else {
                    gvBOM.batchEditApi.SetCellValue(iBOM[g], "AllowanceQty", (aCons * (aPerc * 0.01)).toFixed(6));
                    gvBOM.batchEditApi.SetCellValue(iBOM[g], "RequiredQty", (aReq).toFixed(6));
                }
            }
            else {
                var PrIsRounded = gvBOM.batchEditApi.GetCellValue(iBOM[g], "IsRounded");
                var key = gvBOM.GetRowKey(iBOM[g]);
                if (gvBOM.batchEditApi.IsDeletedRow(key)) {
                    console.log("deleted row " + iBOM[g]);
                }
                else {

                    var aCons = 0.000000;
                    var aPerc = 0.000000;
                    var aReq;

                    aCons = gvBOM.batchEditApi.GetCellValue(iBOM[g], "Consumption");
                    aPerc = gvBOM.batchEditApi.GetCellValue(iBOM[g], "AllowancePerc");
                    aReq = Number(aCons) + Number(aCons * (aPerc * 0.01))

                    if (PrIsRounded == true) {
                        gvBOM.batchEditApi.SetCellValue(iBOM[g], "AllowanceQty", Math.ceil(aCons * (aPerc * 0.01)).toFixed(6));
                        gvBOM.batchEditApi.SetCellValue(iBOM[g], "RequiredQty", Math.ceil(aReq).toFixed(6));
                    }
                    else {
                        gvBOM.batchEditApi.SetCellValue(iBOM[g], "AllowanceQty", (aCons * (aPerc * 0.01)).toFixed(6));
                        gvBOM.batchEditApi.SetCellValue(iBOM[g], "RequiredQty", (aReq).toFixed(6));
                    }
                }
            }
        }
        //end

    }, 500);
}

        
function calculate_allowance_specific(s, e) {

    //OnInitTrans();
    console.log('calculate_allowance ', curindex)

    setTimeout(function () {

        var iBOM = gvBOM.batchEditApi.GetRowVisibleIndices();
        var PrIsRounded = gvBOM.batchEditApi.GetCellValue(curindex, "IsRounded");
        //Allowance Qty Update
        //for (var g = 0; g < iBOM.length; g++) {
        //if (gvBOM.batchEditApi.IsNewRow(iBOM[BIndex])) {

        var aCons = 0.000000;
        var aPerc = 0.000000;
        var aReq;
                    
        aCons = gvBOM.batchEditApi.GetCellValue(curindex, "Consumption");
        aPerc = gvBOM.batchEditApi.GetCellValue(curindex, "AllowancePerc");
        aReq = Number(aCons) + Number(aCons * (aPerc * 0.01))

        if (PrIsRounded == true) {
            gvBOM.batchEditApi.SetCellValue(curindex, "AllowanceQty", Math.ceil(aCons * (aPerc * 0.01)).toFixed(6));
            gvBOM.batchEditApi.SetCellValue(curindex, "RequiredQty", Math.ceil(aReq).toFixed(6));
        }
        else {
            gvBOM.batchEditApi.SetCellValue(curindex, "AllowanceQty", (aCons * (aPerc * 0.01)).toFixed(6));
            gvBOM.batchEditApi.SetCellValue(curindex, "RequiredQty", (aReq).toFixed(6));
        }
        //}
        //else {
        //    var key = gvBOM.GetRowKey(iBOM[BIndex]);
        //    if (gvBOM.batchEditApi.IsDeletedRow(key)) {
        //        console.log("deleted row " + iBOM[BIndex]);
        //    }
        //    else {

        //        var aCons = 0.000000;
        //        var aPerc = 0.000000;
        //        var aReq;

        //        aCons = gvBOM.batchEditApi.GetCellValue(iBOM[BIndex], "Consumption");
        //        aPerc = gvBOM.batchEditApi.GetCellValue(iBOM[BIndex], "AllowancePerc");
        //        aReq = Number(aCons) + Number(aCons * (aPerc * 0.01))

        //        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "AllowanceQty", (aCons * (aPerc * 0.01)).toFixed(6));
        //        gvBOM.batchEditApi.SetCellValue(iBOM[BIndex], "RequiredQty", (aReq).toFixed(6));
        //    }
        //}
        //}
        //end

    }, 500);
}

function calculate_allowance_specific2(s, e) {

    //OnInitTrans();
    console.log('calculate_allowance')

    setTimeout(function () {

        var iBOM = gvBOM.batchEditApi.GetRowVisibleIndices();
        var PrIsRounded = gvBOM.batchEditApi.GetCellValue(curindex, "IsRounded");
        //Allowance Qty Update
        //for (var g = 0; g < iBOM.length; g++) {
        //if (gvBOM.batchEditApi.IsNewRow(iBOM[BIndex])) {

        var aCons = 0.000000;
        var aQty = 0.000000;
        var aReq;

        aCons = gvBOM.batchEditApi.GetCellValue(curindex, "Consumption");
        aQty = gvBOM.batchEditApi.GetCellValue(curindex, "AllowanceQty");
        //aReq = Number(aCons) + Number(aCons * (aQty * 0.01))
        aReq = Number(aCons) + Number(aQty);
        console.log(aCons, Number(aCons * (aQty * 0.01)))
        //gvBOM.batchEditApi.SetCellValue(curindex, "AllowanceQty", (aCons * (aQty * 0.01)).toFixed(6));
        if (PrIsRounded == true)
            gvBOM.batchEditApi.SetCellValue(curindex, "RequiredQty", Math.ceil(aReq).toFixed(6));
        else
            gvBOM.batchEditApi.SetCellValue(curindex, "RequiredQty", (aReq).toFixed(6));
    }, 500);
}

function calculate_AccCost(s, e) {

    //OnInitTrans();
    console.log('calculate_AccCost')

    //for EstAccCost
    var WordOrderPrice = 0.00;
    var HEstUnitCost = 0.00;
    var HEstAccCost = 0.00;
    var ItemCode = [];
    var ColorCode = [];
    var DCost = [];
    var Count = [];

    setTimeout(function () {

        var iSizes = gvSize.batchEditApi.GetRowVisibleIndices();
        var iPlanning = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
        var iBOM = gvBOM.batchEditApi.GetRowVisibleIndices();
        var iStepPlan = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
        var iProd = gvProductOrder.batchEditApi.GetRowVisibleIndices();

        //Est Accessories Cost
        for (var i = 0; i < iBOM.length; i++) {
            if (gvBOM.batchEditApi.IsNewRow(iBOM[i])) {

                var pasok = false;
                var count = 0;
                item = gvBOM.batchEditApi.GetCellValue(iBOM[i], "ItemCode");
                color = gvBOM.batchEditApi.GetCellValue(iBOM[i], "ColorCode");
                qty = gvBOM.batchEditApi.GetCellValue(iBOM[i], "PerPieceConsumption");
                cost = gvBOM.batchEditApi.GetCellValue(iBOM[i], "UnitCost");
                major = gvBOM.batchEditApi.GetCellValue(iBOM[i], "IsMajorMaterial");


                if (qty == "" || qty == '' || isNaN(qty) || qty == null) {
                    qty = 0;
                }

                if (cost == "" || cost == '' || isNaN(cost) || cost == null) {
                    cost = 0;
                }

                if (major != true) {
                    if (ItemCode.length == 0) {
                        var temptotalcost = qty * cost;
                        ItemCode.push(item);
                        ColorCode.push(color);
                        DCost.push(temptotalcost);
                        Count.push(1);
                        pasok = true;
                    }
                    else {
                        for (var y = 0; y < ItemCode.length; y++) {
                            if (ItemCode[y] == item) {

                                if (ColorCode[y] == color) {
                                    var temptotalcost = qty * cost;
                                    DCost[y] += temptotalcost;
                                    Count[y] += 1;
                                    pasok = true;
                                }
                            }
                        }
                    }



                    if (pasok == false) {
                        var temptotalcost = qty * cost;
                        ItemCode.push(item);
                        ColorCode.push(color);
                        DCost.push(temptotalcost);
                        Count.push(1);
                    }
                }
            }
            else {
                var key = gvBOM.GetRowKey(iBOM[i]);
                if (gvBOM.batchEditApi.IsDeletedRow(key)) {
                    console.log("deleted row " + iBOM[i]);
                }
                else {
                    var pasok = false;
                    var count = 0;
                    item = gvBOM.batchEditApi.GetCellValue(iBOM[i], "ItemCode");
                    color = gvBOM.batchEditApi.GetCellValue(iBOM[i], "ColorCode");
                    qty = gvBOM.batchEditApi.GetCellValue(iBOM[i], "PerPieceConsumption");
                    cost = gvBOM.batchEditApi.GetCellValue(iBOM[i], "UnitCost");
                    major = gvBOM.batchEditApi.GetCellValue(iBOM[i], "IsMajorMaterial");


                    if (qty == "" || qty == '' || isNaN(qty) || qty == null) {
                        qty = 0;
                    }

                    if (cost == "" || cost == '' || isNaN(cost) || cost == null) {
                        cost = 0;
                    }

                    if (major != true) {
                        if (ItemCode.length == 0) {
                            var temptotalcost = qty * cost;
                            ItemCode.push(item);
                            ColorCode.push(color);
                            DCost.push(temptotalcost);
                            Count.push(1);
                            pasok = true;
                        }
                        else {

                            for (var y = 0; y < ItemCode.length; y++) {
                                if (ItemCode[y] == item) {

                                    if (ColorCode[y] == color) {
                                        var temptotalcost = qty * cost;
                                        DCost[y] += temptotalcost;
                                        Count[y] += 1;
                                        pasok = true;
                                    }
                                }
                            }
                        }



                        if (pasok == false) {
                            var temptotalcost = qty * cost;
                            ItemCode.push(item);
                            ColorCode.push(color);
                            DCost.push(temptotalcost);
                            Count.push(1);
                        }
                    }
                }
            }
        }

        for (var i = 0; i < ItemCode.length; i++) {
            HEstAccCost += DCost[i] / Count[i]
        }
        speEstAccCost.SetValue(HEstAccCost);
        //end

    }, 500);
}

function calculate_UnitCost(s, e) {

    //OnInitTrans();
    console.log('calculate_UnitCost')

    var HEstUnitCost1 = 0.00;
    var HEstAccCost1 = 0.00;
    var HPool = 0.00;
    var HPool1 = 0.00;
    var ItemCode1 = [];
    var ColorCode1 = [];
    var DCost1 = [];
    var Count1 = [];

    setTimeout(function () {

        var iSizes = gvSize.batchEditApi.GetRowVisibleIndices();
        var iPlanning = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
        var iBOM = gvBOM.batchEditApi.GetRowVisibleIndices();
        var iStepPlan = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
        var iProd = gvProductOrder.batchEditApi.GetRowVisibleIndices();

        //To get all bill of material
        for (var h = 0; h < iBOM.length; h++) {
            if (gvBOM.batchEditApi.IsNewRow(iBOM[h])) {

                var pasok1 = false;
                var count1 = 0;

                item1 = gvBOM.batchEditApi.GetCellValue(iBOM[h], "ItemCode");
                color1 = gvBOM.batchEditApi.GetCellValue(iBOM[h], "ColorCode");
                qty1 = gvBOM.batchEditApi.GetCellValue(iBOM[h], "PerPieceConsumption");
                cost1 = gvBOM.batchEditApi.GetCellValue(iBOM[h], "UnitCost");
                major1 = gvBOM.batchEditApi.GetCellValue(iBOM[h], "IsMajorMaterial");

                if (ItemCode1.length == 0) {
                    var temptotalcost1 = qty1 * cost1;
                    ItemCode1.push(item);
                    ColorCode1.push(color);
                    DCost1.push(temptotalcost1);
                    Count1.push(1);
                    pasok1 = true;
                }
                else {
                    for (var y = 0; y < ItemCode1.length; y++) {
                        if (ItemCode1[y] == item1) {
                            if (ColorCode1[y] == color1) {
                                var temptotalcost1 = qty1 * cost1;
                                DCost1[y] += temptotalcost1;
                                Count1[y] += 1;
                                pasok1 = true;
                            }
                        }
                    }
                }

                if (pasok1 == false) {
                    var temptotalcost1 = qty1 * cost1;
                    ItemCode1.push(item1);
                    ColorCode1.push(color1);
                    DCost1.push(temptotalcost1);
                    Count1.push(1);
                }

            }
            else {
                var key = gvBOM.GetRowKey(iBOM[h]);
                if (gvBOM.batchEditApi.IsDeletedRow(key)) {
                }
                else {
                    var pasok1 = false;
                    var count1 = 0;

                    item1 = gvBOM.batchEditApi.GetCellValue(iBOM[h], "ItemCode");
                    color1 = gvBOM.batchEditApi.GetCellValue(iBOM[h], "ColorCode");
                    qty1 = gvBOM.batchEditApi.GetCellValue(iBOM[h], "PerPieceConsumption");
                    cost1 = gvBOM.batchEditApi.GetCellValue(iBOM[h], "UnitCost");
                    major1 = gvBOM.batchEditApi.GetCellValue(iBOM[h], "IsMajorMaterial");

                    if (ItemCode1.length == 0) {
                        var temptotalcost1 = qty1 * cost1;
                        ItemCode1.push(item);
                        ColorCode1.push(color);
                        DCost1.push(temptotalcost1);
                        Count1.push(1);
                        pasok1 = true;
                    }
                    else {
                        for (var y = 0; y < ItemCode1.length; y++) {
                            if (ItemCode1[y] == item1) {

                                if (ColorCode1[y] == color1) {
                                    var temptotalcost1 = qty1 * cost1;
                                    DCost1[y] += temptotalcost1;
                                    Count1[y] += 1;
                                    pasok1 = true;
                                }
                            }
                        }
                    }

                    if (pasok1 == false) {
                        var temptotalcost1 = qty1 * cost1;
                        ItemCode1.push(item1);
                        ColorCode1.push(color1);
                        DCost1.push(temptotalcost1);
                        Count1.push(1);
                    }
                }
            }
        }

        for (var i = 0; i < ItemCode1.length; i++) {
            HPool += DCost1[i] / Count1[i]
        }
        HPool1 = HPool;
        //end

        var WordOrderPrice1 = 0.00;

        //Est Unit Cost
        if (iStepPlan.length != 0) {
            for (var q = 0; q < iStepPlan.length; q++) {
                if (gvStepPlanning.batchEditApi.IsNewRow(iStepPlan[q])) {

                    WordOrderPrice1 = gvStepPlanning.batchEditApi.GetCellValue(iStepPlan[q], "EstWorkOrderPrice");

                    if (WordOrderPrice1 == "" || WordOrderPrice1 == '' || isNaN(WordOrderPrice1) || WordOrderPrice1 == null) {
                        WordOrderPrice1 = 0;
                    }

                    HEstUnitCost1 += WordOrderPrice1 * 1;

                }
                else {
                    var key = gvStepPlanning.GetRowKey(iStepPlan[q]);
                    if (gvStepPlanning.batchEditApi.IsDeletedRow(key)) {
                        console.log("deleted row " + iStepPlan[q]);
                    }
                    else {

                        WordOrderPrice1 = gvStepPlanning.batchEditApi.GetCellValue(iStepPlan[q], "EstWorkOrderPrice");

                        if (WordOrderPrice1 == "" || WordOrderPrice1 == '' || isNaN(WordOrderPrice1) || WordOrderPrice1 == null) {
                            WordOrderPrice1 = 0;
                        }

                        HEstUnitCost1 += WordOrderPrice1 * 1;

                    }
                }
            }
        }
        speEstUnitCost.SetValue(HPool1 + HEstUnitCost1);
        //end

    }, 500);
}

function OnGridFocusedRowChanged() {
    var grid = aglCustomerCode.GetGridView();
    grid.GetRowValues(grid.GetFocusedRowIndex(), "BizPartnerCode;Name;Currency", OnGetRowValues);
}

function OnGetRowValues(values) {

    if (values[2] == null) {
        aglCurrency.SetText("PHP");
    }
    else {
        aglCurrency.SetText(values[2]);
    }
    if (aglCurrency.GetText() == "" || aglCurrency.GetText() == null) {
        aglCurrency.SetText("PHP");
    }

}

function CustomerCodeEffect(s, e) {
    var g = aglCustomerCode.GetGridView();
    var val = g.GetRowKey(g.GetFocusedRowIndex());
    var temp = val.split('|');
    //alert(temp[1]);
    aglCurrency.SetText(temp[1]);

}

function Grid_BatchEditRowValidating(s, e) {
    var arraysteps = new Array(100);
    var cntsteps = 0;
    var cntmaystep = 0;

    var indicies = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
    for (var b = 0; b < indicies.length; b++) {
        var key = gvStepPlanning.GetRowKey(indicies[b]);
        if (!gvStepPlanning.batchEditApi.IsDeletedRow(key)) {
            arraysteps[b] = gvStepPlanning.batchEditApi.GetCellValue(indicies[b], "StepCode");
            cntsteps++;
        } 
    }

    for (var i = 0; i < gvBOM.GetColumnsCount() ; i++) {
        var column = s.GetColumn(i);
        if (column.fieldName == "StepCode") {
            var cellValidationInfo = e.validationInfo[column.index];
            if (!cellValidationInfo) continue;
            var value = cellValidationInfo.value;
            //alert(cntsteps);
            for (var c = 0; c < cntsteps; c++) {
                //alert(value + ' asdasd ' + arraysteps[c]);
                if (value.toLowerCase() == arraysteps[c].toLowerCase()) {
                    cntmaystep++;
                }
            }

            if (cntmaystep == 0) {
                cellValidationInfo.isValid = false;
                cellValidationInfo.errorText = "Step Code not found in JO Step Planning!";
                isValid = false; counterror++;
            }
            cntmaystep = 0;
        } 
    }
}

function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)
    if (s.GetText() == "" || e.value == "" || e.value == null) {
        counterror++;
        isValid = false
        //console.log(s);
        //console.log(e);
    }
    else {
        isValid = true;
    }
}

function CheckDocDate(s, e) {
    if (chkIsAutoJO.GetChecked()) {
        console.log('getchek')
    }
    else {
        if ((dtpBookdate.GetText() != null && dtpBookdate.GetText() != '') &&
            (dtpDocDate.GetText() != null && dtpDocDate.GetText() != '')) {
            var Start = new Date();
            var End = new Date();

            Start = dtpBookdate.GetDate();
            End = dtpDocDate.GetDate();

            var StartTime = Start.getTime();
            var EndTime = End.getTime();
             
            if (EndTime < StartTime) {
                alert('Transaction is part of the closed period!');
                counterror++;
                isValid = false
                console.log(s);
                console.log(e);
            }
            else {
                isValid = true;
            }
        }
    }
}

function CheckDueDate(s, e) {

    if ((dtpDueDate.GetText() != null && dtpDueDate.GetText() != '')) {
        var DueDate = new Date();
        var DocDate = new Date();
        var ProdDate = new Date();
        DueDate = dtpDueDate.GetDate();
        //console.log(DueDate + 'DueDate')
        var DueDateTime = DueDate.getTime();

        if ((dtpDocDate.GetText() != null && dtpDocDate.GetText() != '')) {
            DocDate = dtpDocDate.GetDate();
            var DocDateTime = DocDate.getTime(); 
            if (DueDateTime < DocDateTime) {
                alert('JO Duedate must be greater than Document Date!');
                counterror++;
                isValid = false
                console.log(s);
                console.log(e);
            }
            else {
                isValid = true;
            }
        }

        if ((dtpProdDate.GetText() != null && dtpProdDate.GetText() != '')) {
            ProdDate = dtpProdDate.GetDate();
            var ProdDateTime = ProdDate.getTime();

            if (DueDateTime < ProdDateTime) {
                alert('JO Duedate must be greater than or equal to Production Date!');
                counterror++;
                isValid = false
                console.log(s);
                console.log(e);
            }
            else {
                isValid = true;
            }
        }
    }
}

function CheckProdDate(s, e) {

    if (dtpProdDate.GetText() != null && dtpProdDate.GetText() != '') {
        var DueDate1 = new Date();
        var DocDate1 = new Date();
        var ProdDate1 = new Date();

        ProdDate1 = dtpProdDate.GetDate();
        var ProdDateTime1 = ProdDate1.getTime();

        if ((dtpDocDate.GetText() != null && dtpDocDate.GetText() != '')) {

            DocDate1 = dtpDocDate.GetDate();
            var DocDateTime1 = DocDate1.getTime();

            if (ProdDateTime1 < DocDateTime1) {
                alert('Production date must be greater than Document Date!');
                counterror++;
                isValid = false
                console.log(s);
                console.log(e);
            }
            else {
                isValid = true;
            }
        }

        //if ((dtpDueDate.GetText() != null && dtpDueDate.GetText() != '')) {
        //    DueDate1 = dtpDueDate.GetDate();
        //    var DueDateTime1 = DueDate1.getTime();
        //    if (ProdDateTime1 > DueDateTime1) {
        //        alert('Production date must be less than Due Date!');
        //        counterror++;
        //        isValid = false
        //        console.log(s);
        //        console.log(e);
        //    }
        //    else {
        //        isValid = true;
        //    }
        //}
    }
}

function ShowPrintWOPrint(s, e) {
    var docnum = txtDocNumber.GetText() + '|' + JOSPStep + '|' + JOLineNumberA;
    window.open("../WebReports/ReportViewer.aspx?val=~GEARS_Printout.P_WorkOrderSingle&transtype=PRDJOB3&docnumber=" + docnum + '&tag=' + JOisprinted);
}

function ShowPrintWOPrintMul(s, e) {
    var docnum = txtDocNumber.GetText() + '|' + JOSPWorkCntr + '|' + JOLineNumberB;
    window.open("../WebReports/ReportViewer.aspx?val=~GEARS_Printout.P_WorkOrderMultiple&transtype=PRDJOB4&docnumber=" + docnum + '&tag=' + JOisprinted1);
}

function ShowPrintWOPrintMulStep(s, e) {
    var docnum = txtDocNumber.GetText() + '|' + JOSPStep2 + '|' + JOLineNumber2;
    window.open("../WebReports/ReportViewer.aspx?val=~GEARS_Printout.P_WorkOrderSingle&transtype=PRDJOB3&docnumber=" + docnum + '&tag=' + JOisprinted2);
}

function isInArray(value, array) {
    for (var i = 0; i < array.length; i++) {
        if (array[i][0] == value) {
            return true;
            break;
        }
    }
}

function isInArray2(value, array) {
    return array.indexOf(value) > -1;
}

function findIndexArr(value, array) {
    for (var i = 0; i < array.length; i++) {
        if (array[i][0] == value) {
            return i;
            break;
        }
    }
}

function getSize(s, e) {
    var sizeArr = [];

    var igv1 = gvProductOrder.batchEditApi.GetRowVisibleIndices();

    for (var g = 0; g < igv1.length; g++) {
        if (gvProductOrder.batchEditApi.IsNewRow(igv1[g])) {
            if (sizeArr.length == 0) {
                sizeArr.push([gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode"), gvProductOrder.batchEditApi.GetCellValue(igv1[g], "JOQty")]);
            }
            else {
                if (isInArray(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode"), sizeArr)) {
                    sizeArr[findIndexArr(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode"), sizeArr)][1] += gvProductOrder.batchEditApi.GetCellValue(igv1[g], "JOQty");
                }
                else {
                    sizeArr.push([gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode"), gvProductOrder.batchEditApi.GetCellValue(igv1[g], "JOQty")]);
                }
            }
        }
        else {
            var key = gvProductOrder.GetRowKey(igv1[g]);
            if (gvProductOrder.batchEditApi.IsDeletedRow(key)) {
                console.log("deleted row " + igv1[g]);
            }
            else {
                if (sizeArr.length == 0) {
                    sizeArr.push([gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode"), gvProductOrder.batchEditApi.GetCellValue(igv1[g], "JOQty")]);
                }
                else {
                    if (isInArray(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode"), sizeArr)) {
                        sizeArr[findIndexArr(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode"), sizeArr)][1] += gvProductOrder.batchEditApi.GetCellValue(igv1[g], "JOQty");
                    }
                    else {
                        sizeArr.push([gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode"), gvProductOrder.batchEditApi.GetCellValue(igv1[g], "JOQty")]);
                    }
                }
            }
        }
    }
    //console.log(sizeArr);
    updSize(sizeArr)
}

function updSize(array) {
    var igv1 = gvSize.batchEditApi.GetRowVisibleIndices();
    var sizeArr = [];

    for (var g = 0; g < igv1.length; g++) {
        if (gvSize.batchEditApi.IsNewRow(igv1[g])) {
            if (isInArray(gvSize.batchEditApi.GetCellValue(igv1[g], "StockSize"), array)) {
                var arrindex = findIndexArr(gvSize.batchEditApi.GetCellValue(igv1[g], "StockSize"), array);
                gvSize.batchEditApi.SetCellValue(igv1[g], "JOQty", array[arrindex][1]);
                sizeArr.push(gvSize.batchEditApi.GetCellValue(igv1[g], "StockSize"));
            }
            else {
                gvSize.DeleteRow(igv1[g]);
            }
        }
        else {
            var key = gvProductOrder.GetRowKey(igv1[g]);
            if (gvSize.batchEditApi.IsDeletedRow(key)) {
                console.log("deleted row " + igv1[g]);
            }
            else {
                if (isInArray(gvSize.batchEditApi.GetCellValue(igv1[g], "StockSize"), array)) {
                    var arrindex = findIndexArr(gvSize.batchEditApi.GetCellValue(igv1[g], "StockSize"), array);
                    gvSize.batchEditApi.SetCellValue(igv1[g], "JOQty", array[arrindex][1]);
                    sizeArr.push(gvSize.batchEditApi.GetCellValue(igv1[g], "StockSize"));
                }
                else {
                    gvSize.DeleteRow(igv1[g]);
                }
            }
        }
    }

    addSize(sizeArr);
}

function addSize(array) {
    var igv1 = gvProductOrder.batchEditApi.GetRowVisibleIndices();
    var items = [];

    for (var g = 0; g < igv1.length; g++) {
        if (gvProductOrder.batchEditApi.IsNewRow(igv1[g])) {
            if (!isInArray2(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode"), array)) {
                gvSize.AddNewRow();
                items.push(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode"));
                items.push(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SOQty"))
                items.push(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "JOQty"))
                items.push(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "INQty"))
                items.push(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "FinalQty"))
                getCol(gvSize, editorobj, items);
            }
        }
        else {
            var key = gvProductOrder.GetRowKey(igv1[g]);
            if (gvProductOrder.batchEditApi.IsDeletedRow(key)) {
                console.log("deleted row " + igv1[g]);
            }
            else {
                if (!isInArray2(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode"), array)) {
                    gvSize.AddNewRow();
                    items.push(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode"));
                    items.push(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SOQty"))
                    items.push(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "JOQty"))
                    items.push(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "INQty"))
                    items.push(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "FinalQty"))
                    getCol(gvSize, editorobj, items);
                }
            }
        }
    }
}

function getCol(ss, ee, item) {
    for (var i = 0; i < ss.GetColumnsCount() ; i++) {
        var column = ss.GetColumn(i);
        if (column.visible == false || column.fieldName == undefined)
            continue;
        Bindgrid(item, ee, column, ss);
    }
}

function Bindgrid(item, e, column, s) {//Clone function :D
    if (column.fieldName == "StockSize") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[0]);
    }
    if (column.fieldName == "SOQty") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[1]);
    }
    if (column.fieldName == "JOQty") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[2]);
    }
    if (column.fieldName == "INQty") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[3]);
    }
    if (column.fieldName == "FinalQty") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[4]);
    }
}

function checkItem(s, e) {
    if (gvProductOrder.GetVisibleRowsOnPage() == 1 && PItem != gl.GetValue())
        cbacker.PerformCallback('update|' + s.GetInputElement().value);

}

var gvprodvalid = true;
var gverrindex;
function gvProductRow(s, e) {
    var isproductvalid = validateRow();
    if (gvProductOrder.batchEditApi.GetCellValue(gvProdindex, "ReferenceSO") == null || gvProductOrder.batchEditApi.GetCellValue(gvProdindex, "ReferenceSO") == '')
        for (var i = 0; i < gvProductOrder.GetColumnsCount() ; i++) {
            var column = s.GetColumn(i);
            if (column.fieldName == "ItemCode" || column.fieldName == "ColorCode" || column.fieldName == "ClassCode" || column.fieldName == "SizeCode") {
                var cellValidationInfo = e.validationInfo[column.index];
                if (!cellValidationInfo) continue;

                if (isproductvalid) {
                    cellValidationInfo.isValid = false;
                    cellValidationInfo.errorText = "Duplicate";
                    isValid = false;
                }
            }
        }
}

function validateRow() {
    //setTimeout(function() {
        var igv1 = gvProductOrder.batchEditApi.GetRowVisibleIndices();
        var skuarr = [];

        for (var g = 0; g < igv1.length; g++) {
            if (igv1[g] != gvProdindex)
            if (gvProductOrder.batchEditApi.IsNewRow(igv1[g])) {
                if (gvProductOrder.batchEditApi.GetCellValue(igv1[g], "ReferenceSO") != null)
                    skuarr.push(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "ItemCode").trim() + ';'
                           + gvProductOrder.batchEditApi.GetCellValue(igv1[g], "ColorCode").trim() + ';' + gvProductOrder.batchEditApi.GetCellValue(igv1[g], "ClassCode").trim() + ';'
                           + gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode").trim() + ';')
            }
            else {
                var key = gvProductOrder.GetRowKey(igv1[g]);
                if (gvProductOrder.batchEditApi.IsDeletedRow(key)) {
                    console.log("deleted row " + igv1[g]);
                }
                else {
                    if (gvProductOrder.batchEditApi.GetCellValue(igv1[g], "ReferenceSO") != null)
                        skuarr.push(gvProductOrder.batchEditApi.GetCellValue(igv1[g], "ItemCode").trim() + ';'
                           + gvProductOrder.batchEditApi.GetCellValue(igv1[g], "ColorCode").trim() + ';' + gvProductOrder.batchEditApi.GetCellValue(igv1[g], "ClassCode").trim() + ';'
                           + gvProductOrder.batchEditApi.GetCellValue(igv1[g], "SizeCode").trim() + ';')
                }
            }
        }
        
        var sku;

        try{
            sku = gvProductOrder.batchEditApi.GetCellValue(gvProdindex, "ItemCode").trim() + ';'
                               + gvProductOrder.batchEditApi.GetCellValue(gvProdindex, "ColorCode").trim() + ';' + gvProductOrder.batchEditApi.GetCellValue(gvProdindex, "ClassCode").trim() + ';'
                               + gvProductOrder.batchEditApi.GetCellValue(gvProdindex, "SizeCode").trim() + ';';
        }
        catch(exception){
            //console.log('err')
        }

        if (isInArray2(sku, skuarr)) {
            //alert('Item,Color,Class,Size has duplicate value from SO');
            //console.log('1')
            skuarr = [];
            return true;
        }
        else {
            //console.log('2')
            skuarr = [];
            return false;
        } 
    //},500);
}

function AutoJOchanged() {
    if (chkIsAutoJO.GetChecked()) {
        speSRP.SetText(0.00);
        speSRP.SetEnabled(false);
    }
}

function gvStepCheck(s, e) {
        for (var i = 0; i < gvStepPlanning.GetColumnsCount() ; i++) {
            var column = s.GetColumn(i);
            var chckd;
            var chckd2;
            var Min;
            var Max;

            if (column.fieldName == "MinPrice") {
                var cellValidationInfo = e.validationInfo[12];
                if (!cellValidationInfo) continue;
                Min = cellValidationInfo.value;
            }

            if (column.fieldName == "MaxPrice") {
                var cellValidationInfo1 = e.validationInfo[13];
                if (!cellValidationInfo1) continue;
                Max = cellValidationInfo1.value;
            }

            if (column.fieldName == "WorkOrderPrice") {
                var cellValidationInfo = e.validationInfo[16];
                if (!cellValidationInfo) continue;
                var value = cellValidationInfo.value;

                if (Number(value) < Number(Min)) {
                    cellValidationInfo.isValid = false;
                    cellValidationInfo.errorText = "Work order price is less than the Minimum Work Order Price set for the step!";
                }

                if (Number(Max) < Number(value)) {
                    cellValidationInfo.isValid = false;
                    cellValidationInfo.errorText = "Work order price is greater than the Maximum Work Order Price set for the step!";
                }
            }

            
            //if (column.fieldName == "StepCode") {
            //    var isproductvalid = false;
            //    if (boolvalstep) {
            //        isproductvalid = ValidateSteps();
            //    }
            //    var cellValidationInfo = e.validationInfo[column.index];
            //    if (!cellValidationInfo) continue;
            //    var value = cellValidationInfo.value;
            //    if (isproductvalid && (ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) != "")) {
            //        cellValidationInfo.isValid = false;
            //        cellValidationInfo.errorText = "Duplicate Sequence";
            //        isValid = false;
            //    }
            //}

            var date;
            if (column.fieldName === "TargetDateIn") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                var cellValidationInfo = e.validationInfo[column.index];
                if (!cellValidationInfo) continue;
                var value = cellValidationInfo.value;
                date = value;
            }
            if (column.fieldName === "TargetDateOut") {//Set to skip all unnecessary columns that doesn't need validation//Column index needed to set //Example for Qty
                var cellValidationInfo = e.validationInfo[column.index];
                if (!cellValidationInfo) continue;
                var value = cellValidationInfo.value;
                CheckDifference(Date.parse(convert(value)), Date.parse(convert(date)));
                if (!isValid2 && ASPxClientUtils.IsExists(value)) {
                    cellValidationInfo.isValid = isValid2;
                    cellValidationInfo.errorText = "TargetDateOut must not be less than TargetDateIn";
                    isValid = isValid2;
                    counterror++;
                }
            }
        }
}

function ValidateSteps() {
    var igvStepPlan = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
    var steppreprod = [];
    var stepprod = [];

    for (var g = 0; g < igvStepPlan.length; g++) {
        if (igvStepPlan[g] != gvStepPlanIndex) {
            var key = gvProductOrder.GetRowKey(igvStepPlan[g]);
            if (!gvStepPlanning.batchEditApi.IsDeletedRow(key)) {
                //console.log("this row " + igvStepPlan[g] + ' ' + gvStepPlanning.batchEditApi.GetCellValue(igvStepPlan[g], "Sequence"));
                if (gvStepPlanning.batchEditApi.GetCellValue(gvStepPlanIndex, "PreProd") == false) {
                    if (gvStepPlanning.batchEditApi.GetCellValue(igvStepPlan[g], "PreProd") == false)
                        stepprod.push(gvStepPlanning.batchEditApi.GetCellValue(igvStepPlan[g], "Sequence") + ';'
                               + gvStepPlanning.batchEditApi.GetCellValue(igvStepPlan[g], "StepCode") + ';')
                }
                else {
                    if (gvStepPlanning.batchEditApi.GetCellValue(igvStepPlan[g], "PreProd") == true)
                        steppreprod.push(gvStepPlanning.batchEditApi.GetCellValue(igvStepPlan[g], "Sequence") + ';'
                               + gvStepPlanning.batchEditApi.GetCellValue(igvStepPlan[g], "StepCode") + ';')
                }
            }
        }
    }

        var stepsc;
        try {
            stepsc = gvStepPlanning.batchEditApi.GetCellValue(gvStepPlanIndex, "Sequence") + ';'
                       + gvStepPlanning.batchEditApi.GetCellValue(gvStepPlanIndex, "StepCode").trim() + ';';
        }
        catch (exception) {
            //console.log('err')
        }
        //console.log(steppreprod);
        //console.log(stepsc)
        var finarray = [];
        if (gvStepPlanning.batchEditApi.GetCellValue(gvStepPlanIndex, "PreProd") == false)
            finarray = stepprod;
        else
            finarray = steppreprod;

        if (isInArray3(stepsc, finarray)) {
            //alert('Item,Color,Class,Size has duplicate value from SO');
            //console.log('1')
            steppreprod = [];
            stepprod = [];
            finarray = [];
            return true;
        }
        else {
            //console.log('2')
            steppreprod = [];
            stepprod = [];
            stepprod = [];
            return false;
        }
}

function isInArray3(value, array) {
    if (value == undefined) return;
    var valspl = value.split(';');
    for (var i = 0; i < array.length; i++) {
        if (array[i][0] == valspl[0]) {
            var arrsplit = array[i].split(';');
            
            if (arrsplit[1].toUpperCase().trim() != valspl[1].toUpperCase().trim() && arrsplit[1] != "null") {
                console.log(arrsplit[1].toUpperCase().trim() + '-' + valspl[1].toUpperCase().trim())
                return true;
                break;
            }
        }
    }
}

function ValidateStepSequence() {
    var igvStepPlan = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
    var steppreprod = [];
    var stepprod = [];

    for (var g = 0; g < igvStepPlan.length; g++) {
            var key = gvProductOrder.GetRowKey(igvStepPlan[g]);
            if (!gvStepPlanning.batchEditApi.IsDeletedRow(key)) {
                //console.log("this row " + igvStepPlan[g] + ' ' + gvStepPlanning.batchEditApi.GetCellValue(igvStepPlan[g], "Sequence"));
                if (gvStepPlanning.batchEditApi.GetCellValue(igvStepPlan[g], "PreProd") == false) {
                    stepprod.push(gvStepPlanning.batchEditApi.GetCellValue(igvStepPlan[g], "Sequence"))
                }
                else if (gvStepPlanning.batchEditApi.GetCellValue(igvStepPlan[g], "PreProd") == true){
                        steppreprod.push(gvStepPlanning.batchEditApi.GetCellValue(igvStepPlan[g], "Sequence"))
                }
            }
    }

    if (steppreprod != [])
        steppreprod = steppreprod.sort(compareNumbers);
    if (stepprod != [])
        stepprod = stepprod.sort(compareNumbers);


    var prodbool1 = true;
    var prodbool2 = true;
    for (var i = 1; i < stepprod.length; i++) {
	if (stepprod[i] - stepprod[i - 1] == 0) continue;
        if (stepprod[i] - stepprod[i - 1] != 1) {
            prodbool1 = false;
        }
    }

    for (var i = 1; i < steppreprod.length; i++) {
	if (steppreprod[i] - steppreprod[i - 1] == 0) continue;
        if (steppreprod[i] - steppreprod[i - 1] != 1) {
            prodbool2 = false;
        }
    }
    console.log(prodbool1, prodbool2)
    
    if (prodbool1 && prodbool2) {
        return true;
    }
    else {
        return false;
    }
}

function convert(str) {
    var date = new Date(str),
        mnth = ("0" + (date.getMonth() + 1)).slice(-2),
        day = ("0" + date.getDate()).slice(-2);
    return [mnth, day, date.getFullYear()].join("/");
}

var arrayGrid = new Array();
var isValid2 = false;
var Okay = true;
var isValid3 = true;
function checkGrid() {
    var indicies = gvStepPlanning.batchEditApi.GetRowVisibleIndices();
    var Keyfield;
    var errormsg = "";
    for (var i = 0; i < indicies.length; i++) {
        var key = gvStepPlanning.GetRowKey(indicies[i]);
        if (!gvStepPlanning.batchEditApi.IsDeletedRow(key)) {
            Keyfield = gvStepPlanning.batchEditApi.GetCellValue(indicies[i], "TargetDateOut") + '|' + gvStepPlanning.batchEditApi.GetCellValue(indicies[i], "TargetDateIn");
            step = gvStepPlanning.batchEditApi.GetCellValue(indicies[i], "StepCode");
            sequence = gvStepPlanning.batchEditApi.GetCellValue(indicies[i], "Sequence");

            //console.log(Keyfield)
            if (i == 0) {
                arrayGrid.push(Keyfield);
            }
            else {
                //console.log(arrayGrid[0]);
                var check1 = arrayGrid[0].split('|');
                var check2 = Keyfield.split('|');

                if (!isNaN(Date.parse(convert(check2[1]))) && check2[1] != "null" && gvStepPlanning.batchEditApi.GetCellValue(indicies[i - 1], "TargetDateIn") != null)
                    CheckDifference2(Date.parse(convert(check1[1])), Date.parse(convert(check2[1])));

                //console.log(Date.parse(convert(check1[1])), Date.parse(convert(check2[1])));
                if (isValid3 == false) {
                    errormsg += sequence + ":" + step + "'s TargetDateIn must not be less than the previous step's TargetDateIn. \n";
                    //console.log('here');
                }

                isValid3 = true;
                            
                //console.log(Date.parse(convert(check1[0])), Date.parse(convert(check2[0]))); if(check2[0] != "null")
                if (!isNaN(Date.parse(convert(check2[0]))) && check2[0] != "null" && gvStepPlanning.batchEditApi.GetCellValue(indicies[i - 1], "TargetDateOut") != null)
                    CheckDifference2(Date.parse(convert(check1[0])), Date.parse(convert(check2[0])));

                if (isValid3 == false) {
                    errormsg += sequence + ":" + step + "'s TargetDateOut must not be less than the previous step's TargetDateOut. \n";
                    //console.log('here');
                }

                isValid3 = true;
                arrayGrid = [];
                arrayGrid.push(Keyfield);
            }
            
            gvStepPlanning.batchEditApi.ValidateRow(indicies[i]);
        }
    }
    //console.log(errormsg);
    if (errormsg == "") {
        Okay = true;
    }
    else {
        alert(errormsg);
        errormsg = null;
        Okay = false;
    }
    arrayGrid = [];
}

function CheckDifference(date, date2) {
    //console.log("date:", date, date2);
    if (date != "" && date2 != "") {
        var startDate = new Date();
        var endDate = new Date();
        var difference = -1;
        startDate = date2;
        if (startDate != null) {
            endDate = date;
            //var startTime = startDate.getTime();
            //var endTime = endDate.getTime();
            difference = (endDate - startDate) / 86400000;
        }
        if (difference >= 0) {
            isValid2 = true;
        }
        else {
            isValid2 = false;
        }
    }
}

function CheckDifference2(date, date2) {
    //console.log("date:", date, date2);
    if (date != "" && date2 != "") {
        var startDate = new Date();
        var endDate = new Date();
        var difference = -1;
        startDate = date2;
        if (startDate != null) {
            endDate = date;
            //var startTime = startDate.getTime();
            //var endTime = endDate.getTime();
            difference = (endDate - startDate) / 86400000;
            //console.log(difference);
        }
        if (difference <= 0) {
            isValid3 = true;
        }
        else {
            isValid3 = false;
        }
    }
}

function compareNumbers(a, b) {
    return a - b;
}

function calculateLead(a, b) {
    var date1 = new Date(dtpProdDate.GetValue());
    var date2 = new Date(dtpDueDate.GetValue());
    var timeDiff = Math.abs(date2.getTime() - date1.getTime());
    var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
    speLeadtime.SetValue(diffDays);
}






//Size Horizontal 
function ShowSizeHorizontal(s, e) {
    gvProductOrder.batchEditApi.EndEdit();
    //gvService.batchEditApi.EndEdit();
    var hIndex = gvProductOrder.batchEditApi.GetRowVisibleIndices();
    var hLength = hIndex.length;

    var getQty = 0.00;
    var getPrice = 0.00;

    for (var a = 0; a < hLength; a++) {
        var item = '';
        var color = '';
        var cls = '';
        var qty = 0.00;
        var price = 0.00;
        var gvDetail = '';
        var detail = Trim(itemc) + '|' + Trim(itemclr) + '|' + Trim(itemcls);

        item = gvProductOrder.batchEditApi.GetCellValue(hIndex[a], "ItemCode");
        color = gvProductOrder.batchEditApi.GetCellValue(hIndex[a], "ColorCode");
        cls = gvProductOrder.batchEditApi.GetCellValue(hIndex[a], "ClassCode");
        qty = gvProductOrder.batchEditApi.GetCellValue(hIndex[a], "JOQty");
        price = 0;

        gvDetail = Trim(item) + '|' + Trim(color) + '|' + Trim(cls);

        if (gvDetail == detail) {
            getQty += qty;
            getPrice += price;
        }
    }
    itemprice = getPrice;
    itemqty = getQty;

    //gvSizeHorizontal.batchEditApi.EndEdit();
    if (itemqty == null || isNaN(itemqty) || itemqty == '') {
        itemqty = 0;
    }

    if (itemprice == null || isNaN(itemprice) || itemprice == '') {
        itemprice = 0;
    }

    if (itemIsBulk == null || itemIsBulk == '') {
        itemIsBulk = false;
    }

    SizeHorizontalPopup.Show();
    cp.PerformCallback('CallbackSizeHorizontal|' + itemc + '|' + itemclr + '|' + itemcls + '|' + itemqty + '|' + itemprice + '|' + itemunit + '|' + itemdesc + '|' + "" + '|' + itemIsBulk);


    gvSizeHorizontal.CancelEdit();
    e.processOnServer = false;
}

function CalculateSize(s, e) {

    gvProductOrder.batchEditApi.EndEdit();
    gvService.batchEditApi.EndEdit();
    var qty = 0.00;
    var Aqty = 0.00;

    setTimeout(function () {
        var indicies = gvSizes.batchEditApi.GetRowVisibleIndices();
        var col = gvSizes.GetColumnsCount();
        var key = gvProductOrder.GetRowKey(indicies[w]);
        if (!gvProductOrder.batchEditApi.IsDeletedRow(key)) {
            for (var b = 1; b < col; b++) {
                var column = gvSizes.GetColumn(b);
                qty = gvSizes.batchEditApi.GetCellValue(index, column.fieldName);

                Aqty += qty;
            }
        }
        //alert('ter')
        gvSizeHorizontal.batchEditApi.SetCellValue(index, "OrderQtyX", Aqty);

    }, 500);
}

Number.prototype.format = function (d, w, s, c) {
    var re = '\\d(?=(\\d{' + (w || 3) + '})+' + (d > 0 ? '\\b' : '$') + ')',
        num = this.toFixed(Math.max(0, ~~d));

    return (c ? num.replace(',', c) : num).replace(new RegExp(re, 'g'), '$&' + (s || '.'));
};

function PopulateSizes(s, e) {
    var hIndex = gvProductOrder.batchEditApi.GetRowVisibleIndices();
    var hLength = hIndex.length;

    var sIndex = gvSizes.batchEditApi.GetRowVisibleIndices();
    var sLength = sIndex.length;
    var sCol = gvSizes.GetColumnsCount();

    //alert(itemc + '|' + itemclr + '|' + itemcls);
    for (var x = 1; x < sCol; x++) {

        var sizex = "";
        var qtyx = 0.00;
        var column = gvSizes.GetColumn(x);
        var detail = Trim(itemc) + '|' + Trim(itemclr) + '|' + Trim(itemcls) + '|' + Trim(column.fieldName)
        var getQty = 0.00;

        for (var a = 0; a < hLength; a++) {

            var item = '';
            var color = '';
            var cls = '';
            var size = '';
            var qty = 0.00;
            var gvDetail = '';

            item = gvProductOrder.batchEditApi.GetCellValue(hIndex[a], "ItemCode");
            color = gvProductOrder.batchEditApi.GetCellValue(hIndex[a], "ColorCode");
            cls = gvProductOrder.batchEditApi.GetCellValue(hIndex[a], "ClassCode");
            size = gvProductOrder.batchEditApi.GetCellValue(hIndex[a], "SizeCode");
            qty = gvProductOrder.batchEditApi.GetCellValue(hIndex[a], "JOQty");

            gvDetail = Trim(item) + '|' + Trim(color) + '|' + Trim(cls) + '|' + Trim(size);
            if (gvDetail == detail) {
                getQty += qty;
            }
        }

        gvSizes.batchEditApi.SetCellValue(0, column.fieldName, getQty);
    }
}

function Trim(x) {
    return x.replace(/^\s+|\s+$/gm, '');
}

var arrayGrid = new Array();
var arrayGrid2 = new Array();
var arrayGL = new Array();
var arrayGL2 = new Array();
var OnConf = false;
var glText;
var ValueChanged = false;
var deleting = false;
var SizeQty = 0;

function isInArray(value, array) {
    return array.indexOf(value) > -1;
}

function CallbackSize(s, e) {
    var itemx = "";
    var colorx = "";
    var classx = "";
    var descx = "";
    var unitx = "";
    var bulkunitx = "";
    var bybulkx;
    var pricex = 0;
    var query = "";
    var cnt = 0;
    var gvIndex = gvProductOrder.batchEditApi.GetRowVisibleIndices();
    var gvLength = gvIndex.length;
    var hIndex = gvSizeHorizontal.batchEditApi.GetRowVisibleIndices();
    var sIndex = gvSizes.batchEditApi.GetRowVisibleIndices();
    var sLength = sIndex.length;
    var sCol = gvSizes.GetColumnsCount();

    itemx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "ItemCodeX");
    descx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "FullDescX");
    colorx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "ColorCodeX");
    classx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "ClassCodeX");
    unitx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "UnitX");
    pricex = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "UnitPriceX");
    bulkunitx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "BulkUnitX");
    bybulkx = gvSizeHorizontal.batchEditApi.GetCellValue(hIndex[0], "IsByBulkX");

    for (var b = 1; b < sCol; b++) {

        var sizex = "";
        var qtyx = 0.00;
        var column = gvSizes.GetColumn(b);

        qtyx = gvSizes.batchEditApi.GetCellValue(index, column.fieldName);
        sizex = column.fieldName;

        if (qtyx != 0 && qtyx != "0.00" && qtyx != null && qtyx != "" && qtyx != '') {
            arrayGL.push(itemx + '|' + colorx + '|' + classx + '|' + sizex);
        }
    }

    checkGrid();

    for (i = 1; i < sCol; i++) {
        var s = "";
        var sizex = "";
        var qtyx = 0.00;
        var column = gvSizes.GetColumn(i);
        var item;
        var checkitem;

        qtyx = gvSizes.batchEditApi.GetCellValue(0, column.fieldName);
        sizex = column.fieldName;
        if (qtyx != 0 && qtyx != "0.00" && qtyx != null && qtyx != "" && qtyx != '') {

            s = itemx + ';' + descx + ';' + colorx + ';' + classx + ';' + sizex + ';' + qtyx + ';' + unitx + ';' + pricex + ';' + bulkunitx + ';' + bybulkx;
            item = s.split(';');
            checkitem = item[0] + '|' + item[2] + '|' + item[3] + '|' + item[4];
            //alert('ver' + isInArray(checkitem, arrayGrid));
            //alert('ter' + checkitem);
            if (isInArray(checkitem, arrayGrid)) {

                for (var q = 0; q < gvLength; q++) {
                    var exist = "";
                    gItem = gvProductOrder.batchEditApi.GetCellValue(gvIndex[q], "ItemCode");
                    gColor = gvProductOrder.batchEditApi.GetCellValue(gvIndex[q], "ColorCode");
                    gClass = gvProductOrder.batchEditApi.GetCellValue(gvIndex[q], "ClassCode");
                    gSize = gvProductOrder.batchEditApi.GetCellValue(gvIndex[q], "SizeCode");
                    exist = gItem + '|' + gColor + '|' + gClass + '|' + gSize;

                    if (exist == checkitem) {
                        gvProductOrder.batchEditApi.SetCellValue(gvIndex[q], "JOQty", qtyx);
                    }
                }
            }
            else {
                gvProductOrder.AddNewRow();
                getColSH(gvProductOrder, editorobj, item);
            }
        }

    }

    arrayGrid = [];
    arrayGL = [];
    cp.PerformCallback('CallbackSize');
    e.processOnServer = false;
    gvSizeHorizontal.CancelEdit();
    gvSizes.CancelEdit();
    //resetsizesvalue();
    console.log('3');
    calculations();
}


function getColSH(ss, ee, item) {
    for (var i = 0; i < gvProductOrder.GetColumnsCount() ; i++) {
        var column = gvProductOrder.GetColumn(i);
        if (column.visible == false || column.fieldName == undefined)
            continue;
        Bindgrid(item, ee, column, gvProductOrder);
    }
}

function Bindgrid(item, e, column, s) {

    if (column.fieldName == "ItemCode") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[0]);
    }
    if (column.fieldName == "FullDesc") {
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
    if (column.fieldName == "JOQty") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[5]);
    }
    if (column.fieldName == "Unit") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[6]);
    }
    if (column.fieldName == "UnitCost") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[7]);
    }
    if (column.fieldName == "BulkUnit") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, item[8]);
    }
    if (column.fieldName == "IsByBulk") {
        if (item[9] == "True") {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsByBulk.SetChecked = true);
        }
        else {
            s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsByBulk.SetChecked = false);
        }
    }
    if (column.fieldName == "VATCode") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "NONV");
    }
    if (column.fieldName == "IsVAT") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, glIsVAT.SetChecked = false);
    }
    if (column.fieldName == "Rate") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "0");
    }
    if (column.fieldName == "DiscountRate") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "0");
    }
    if (column.fieldName == "DeliveredQty") {
        s.batchEditApi.SetCellValue(e.visibleIndex, column.fieldName, "0");
    }
}


function checkGrid() {
    var indicies = gvProductOrder.batchEditApi.GetRowVisibleIndices();
    var Keyfield;
    for (var w = 0; w < indicies.length; w++) {
        if (gvProductOrder.batchEditApi.IsNewRow(indicies[w])) {
            Keyfield = gvProductOrder.batchEditApi.GetCellValue(indicies[w], "ItemCode") + '|' + gvProductOrder.batchEditApi.GetCellValue(indicies[w], "ColorCode") + '|' + gvProductOrder.batchEditApi.GetCellValue(indicies[w], "ClassCode") + '|' + gvProductOrder.batchEditApi.GetCellValue(indicies[w], "SizeCode");
            arrayGrid.push(Keyfield)
            gvProductOrder.batchEditApi.ValidateRow(indicies[w]);
        }
        else {
            var key = gvProductOrder.GetRowKey(indicies[w]);
            if (gvProductOrder.batchEditApi.IsDeletedRow(key))
                var ss = "";
            else {
                Keyfield = gvProductOrder.batchEditApi.GetCellValue(indicies[w], "ItemCode") + '|' + gvProductOrder.batchEditApi.GetCellValue(indicies[w], "ColorCode") + '|' + gvProductOrder.batchEditApi.GetCellValue(indicies[w], "ClassCode") + '|' + gvProductOrder.batchEditApi.GetCellValue(indicies[w], "SizeCode");
                arrayGrid.push(Keyfield)
                gvProductOrder.batchEditApi.ValidateRow(indicies[w]);
            }
        }
    }
}

function resetsizesvalue(s, e) {
    setTimeout(function () {
        console.log('Vergara: ' + gvSizes.GetColumnsCount());
        for (var j = 0; j < gvSizes.GetColumnsCount() ; j++) {
            gvSizes.batchEditApi.SetCellValue(0, gvSizes.GetColumn(j).fieldName, 0.00);
            console.log('Terence' + j + ': ' + gvSizes.GetColumn(j).fieldName);
        }
    }, 500);
}


function OnGridFocusedRowChangedStepCode() {
    var grid = dStepCode.GetGridView();
    grid.GetRowValues(grid.GetFocusedRowIndex(), 'StepCode;Inhouse;PreProd;Overhead;WorkOrderPrice;OHRate;OHType;MinPrice;MaxPrice', OnGetRowValuesStepCode);
}
function OnGetRowValuesStepCode(values) {  
        gvStepPlanning.batchEditApi.SetCellValue(indexSP, "StepCode", values[0]);
        gvStepPlanning.batchEditApi.SetCellValue(indexSP, "IsInhouse", values[1]);
        gvStepPlanning.batchEditApi.SetCellValue(indexSP, "PreProd",  values[2]);
        gvStepPlanning.batchEditApi.SetCellValue(indexSP, "Overhead", values[3]);
        gvStepPlanning.batchEditApi.SetCellValue(indexSP, "EstWorkOrderPrice", values[4]);
        gvStepPlanning.batchEditApi.SetCellValue(indexSP, "WorkOrderPrice", values[4]);
        gvStepPlanning.batchEditApi.SetCellValue(indexSP, "OHRate", values[5]);
        gvStepPlanning.batchEditApi.SetCellValue(indexSP, "OHType", values[6]);
        gvStepPlanning.batchEditApi.SetCellValue(indexSP, "MinPrice", values[7]);
        gvStepPlanning.batchEditApi.SetCellValue(indexSP, "MaxPrice", values[8]); 
    gvStepPlanning.batchEditApi.EndEdit();
}