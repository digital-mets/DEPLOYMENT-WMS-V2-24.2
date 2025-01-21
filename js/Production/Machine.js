$(document).ready(function () {
    AdjustSize();
    var entry = getParameterByName('entry');

    if (entry != "N") {
        if (entry == "V" || entry == "D") {
            document.getElementById('cp_frmLayoutRouting_PC_0_btnDelete').style.display = "none";
        }
        preview();
        
        //$("#previewbtn").show();
    }
    //else if (entry == "V") {
    //    var collection = ASPxClientControl.GetControlCollection();
    //    for (var key in collection.elements) {
    //        var control = collection.elements[key];
    //        if (control != null && ASPxIdent.IsASPxClientEdit(control))
    //            control.SetEnabled(false);
    //        preview();
           
    //    }
    //    $("#cp_frmLayoutRouting_PC_0_Upload_FI0").hide();
    //    $("#cp_frmLayoutRouting_PC_0_Upload_Browse0").hide();
    //    document.getElementById('cp_frmLayoutRouting_PC_0_Upload_FI0').disabled = "disabled";
    //    document.getElementById('cp_frmLayoutRouting_PC_0_Upload_Browse0').disabled = "disabled";
        
        
    //    console.log('delete');


        
        //$("#previewbtn").show();
//} 
    else {
        $("#previewbtn").hide();
        document.getElementById('DEL').style.display = "none";
        document.getElementById("FileList").style.display = "none";
    }

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

// Header event START
function OnValidation(s, e) { //Validation function for header controls (Set this for each header controls)


    if (s.GetText() == "" || e.value == "" || e.value == null) {  
        counterror++;
        isValid = false
    }
    else {
       
        isValid = true;
    }
}




////ATTACHMENT
function imageIsLoaded(data) {
    var imgID = "cp_frmlayout1_PC_0_picture1Img";
    console.log(data);
    console.log(imgID);
    if (data.files && data.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $("#" + imgID).attr("src", e.target.result);
            console.log(document.getElementById("cp_frmlayout1_PC_0_picture1Img").src);
           
        };
        reader.readAsDataURL(data.files[0]);
        document.getElementById("cp_frmLayoutRouting_PC_0_btnSave").click();
    } else {
        $("#" + imgID).attr("src", "../Assets/img/AdminImages/default.png");
    }
}


function ImageLoad() {
    var imgID = "cp_frmlayout1_PC_0_picture1Img";
    var FName = document.getElementById("FileName").value;
    var Remarks = document.getElementById("RRemarks").value;
    $("#" + imgID).attr("src", FName);
    $("#FileName").attr("Text", FName);
    $("#RRemarksText").attr("Text", Remarks);
    console.log($("#" + imgID).attr("src", FName));
    console.log(FName);

}
function remarksLoad() {

    var Remarks = document.getElementById("cp_frmLayoutRouting_PC_0_RRemarks_I").value;

    $("#cp_frmLayoutRouting_PC_0_RRemarksText").attr("Text", Remarks);

}

//function showImage(id) {
//    var value = document.getElementById(id).src;
//    $('#img01').attr('src', value);
//    $("#myModal").modal("show");
//}

////image
//function FrontImageUploadComplete(s, e) {
//    if (e.isValid)
//        CINFrontImage2D.SetImageProperties(e.callbackData, e.callbackData, '', '');
//    var imagebinary = e.callbackData.replace('data:image/jpg;base64,', '');
//    CIN2DFrontImage64string.SetText(imagebinary);
//}

////image
//function BackImageUploadComplete(s, e) {
//    if (e.isValid)
//        CINBackImage2D.SetImageProperties(e.callbackData, e.callbackData, '', '');
//    var imagebinary = e.callbackData.replace('data:image/jpg;base64,', '');
//    CIN2DBackImage64string.SetText(imagebinary);
//}


////Attachment END


// SKUCode valuechanged event
function UpdateSKUDescription(values) {
    SKUCode = values[0];
    console.log(SKUCode);
    SKUDescription.SetText(values[1]);
}


// MachineCategory valuechanged event
function UpdateDescription(value) {
    var Category = value[1];
    var Desc = document.getElementById("cp_frmLayoutRouting_PC_0_Description_I").value;

    var brand = document.getElementById("cp_frmLayoutRouting_PC_0_Brand_I").value;
    var SerialNo = document.getElementById("cp_frmLayoutRouting_PC_0_SerialNo_I").value;
    var txtModel = document.getElementById("cp_frmLayoutRouting_PC_0_txtModel_I").value;
    var SupplyVoltage = document.getElementById("cp_frmLayoutRouting_PC_0_SupplyVoltage_I").value;

    var description = Category + '-' + brand + '-' + SerialNo + '-' + txtModel + '-' + SupplyVoltage ;
    Description.SetText(description);
    Cat.SetText(Category);

}
// MachineCategory valuechanged event
function UpdateDate(value) {
    console.log(value);

}





// MachineCategory valuechanged event
function UpdateDescr() {
    
    var Desc = document.getElementById("cp_frmLayoutRouting_PC_0_Description_I").value;

    var brand = document.getElementById("cp_frmLayoutRouting_PC_0_Brand_I").value;
    var SerialNo = document.getElementById("cp_frmLayoutRouting_PC_0_SerialNo_I").value;
    var txtModel = document.getElementById("cp_frmLayoutRouting_PC_0_txtModel_I").value;
    var SupplyVoltage = document.getElementById("cp_frmLayoutRouting_PC_0_SupplyVoltage_I").value;
    var Category = document.getElementById("cp_frmLayoutRouting_PC_0_Cat_I").value;

    var description = Category + '-' + brand + '-' + SerialNo + '-' + txtModel + '-' + SupplyVoltage ;
    Description.SetText(description);

}


//// MachineCategory valuechanged event
//function BrandDescription(value) {
//    var Brand = document.getElementById("cp_frmLayoutRouting_PC_0_Brand_I").value;
//    var Desc = document.getElementById("cp_frmLayoutRouting_PC_0_Description_I").value;

//    var description = Desc + ' | ' + Brand;
//    Description.SetText(description);

//}

//// MachineCategory valuechanged event
//function SerialNoDescription(value) {
//    var SerialNo = document.getElementById("cp_frmLayoutRouting_PC_0_SerialNo_I").value;
//    var Desc = document.getElementById("cp_frmLayoutRouting_PC_0_Description_I").value;

//    var description = Desc + ' | ' + SerialNo;
//    Description.SetText(description);

//}

//// MachineCategory valuechanged event
//function txtModelDescription(value) {
//    var txtModel = document.getElementById("cp_frmLayoutRouting_PC_0_txtModel_I").value;
//    var Desc = document.getElementById("cp_frmLayoutRouting_PC_0_Description_I").value;

//    var description = Desc + ' | ' + txtModel;
//    Description.SetText(description);

//}

//// MachineCategory valuechanged event
//function SupplyVoltageDescription(value) {
//    var SupplyVoltage = document.getElementById("cp_frmLayoutRouting_PC_0_SupplyVoltage_I").value;
//    var Desc = document.getElementById("cp_frmLayoutRouting_PC_0_Description_I").value;

//    var description = Desc + ' | ' + SupplyVoltage;
//    Description.SetText(description);

//}




// CustomerCode valuechanged event
//function UpdateCustomerName(value) {
//    CustomerName.SetText(value);
//}
// Header event END


// PMType valuechanged event
function UpdatePMType(values) {
    gvStepProcess.batchEditApi.EndEdit();
    gvStepProcess.batchEditApi.SetCellValue(index, "PMType", values[0]);
   
}
// Priority valuechanged event
function UpdatePriority(values) {
    gvStepProcess.batchEditApi.EndEdit();
    gvStepProcess.batchEditApi.SetCellValue(index, "Priority", values);
}

function UpdateStepCode2(value) {
    gvOtherMaterial.batchEditApi.EndEdit();
    gvOtherMaterial.batchEditApi.SetCellValue(index, "StepCode", value);
}

// ItemCode valuechanged event
function UpdateItemCodeBOM(values) {
    gvStepBOM.batchEditApi.EndEdit();
    gvStepBOM.batchEditApi.SetCellValue(index, "ItemCode", values[0]);
    gvStepBOM.batchEditApi.SetCellValue(index, "Description", values[1]);
    gvStepBOM.batchEditApi.SetCellValue(index, "Unit", values[2]);
}

//function calculate(s, e) {
//    var ConsumptionPerProduct = gvStepBOM.batchEditApi.GetCellValue(index, "ConsumptionPerProduct") != "" ? gvStepBOM.batchEditApi.GetCellValue(index, "ConsumptionPerProduct") : 0;
//    var TotalConsumption = (ExpectedOutputQty.GetValue() != "" ? ExpectedOutputQty.GetValue() : 0) * ConsumptionPerProduct;
//    console.log(TotalConsumption);
//    gvStepBOM.batchEditApi.SetCellValue(index, "TotalConsumption", TotalConsumption);
//}

function calculate2(s, e) {
    var ConsumptionPerProduct = gvOtherMaterial.batchEditApi.GetCellValue(index, "ConsumptionPerProduct") != "" ? gvOtherMaterial.batchEditApi.GetCellValue(index, "ConsumptionPerProduct") : 0;
    var TotalConsumption = (ExpectedOutputQty.GetValue() != "" ? ExpectedOutputQty.GetValue() : 0) * ConsumptionPerProduct;
    console.log(TotalConsumption);
    gvOtherMaterial.batchEditApi.SetCellValue(index, "TotalConsumption", TotalConsumption);
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

// BOMStandardUsage valuechanged event
function UpdateStandardUsageBOM(value) {
    gvStepBOM.batchEditApi.EndEdit();
    gvStepBOM.batchEditApi.SetCellValue(index, "StandardUsage", value);
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
    gvStepMachine.batchEditApi.SetCellValue(index, "MachineCapacityQty", values[2]);
    gvStepMachine.batchEditApi.SetCellValue(index, "MachineCapacityUnit", values[3]);
}

// Machine Unit valuechanged event
function UpdateUnitMachine(value) {
    gvStepMachine.batchEditApi.EndEdit();
    gvStepMachine.batchEditApi.SetCellValue(index, "Unit", value);
}

// Designation valuechanged event
function UpdateDesignationManpower(values) {
    gvStepManpower.batchEditApi.EndEdit();
    gvStepManpower.batchEditApi.SetCellValue(index, "Designation", values[0]);
    gvStepManpower.batchEditApi.SetCellValue(index, "StandardRate", values[1]);
    gvStepManpower.batchEditApi.SetCellValue(index, "StandardRateUnit", values[2]);
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


//START 2020-10-30 RAA Added Code for odsdetail approach
function UpdateLineNumber() {
    var _refindices = StepProcessTable.batchEditApi.GetRowVisibleIndices();
    var count = _refindices.length + 1;


        _indices = gv1.batchEditApi.GetRowVisibleIndices();

        
        gv1.batchEditApi.SetCellValue('LineNumber', count);
        

    
}

// Adjusting Size
function AdjustSize() {
    var width = Math.max(0, document.documentElement.clientWidth);
    gvStepProcess.SetWidth(width - 120);
    //gvStepBOM.SetWidth(width - 120);
    //gvStepMachine.SetWidth(width - 120);
    //gvStepManpower.SetWidth(width - 120);
    //gvOtherMaterial.SetWidth(width - 120);
    CStepProcess.SetWidth(width - 120);
}

// Function StepProcess_OnStartEditing, Enable/Disable editing
function OnStartEditing(s, e) {
    index = e.visibleIndex;
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];
    var entry = getParameterByName('entry');
    e.cancel = (entry == "V") ? true : false; //this will made the gridview readonly
}

var previndex;
function OnEndEditing(s, e) {//end edit grid function, sets text after select/leaving the current lookup
    var cellInfo = e.rowValues[currentColumn.index];

    var entry = getParameterByName('entry');

    previndex = e.visibleIndex;

    console.log(currentColumn.fieldName);

    if (currentColumn.fieldName === "PMType") {
        cellInfo.value = glPMType.GetValue();
        cellInfo.text = glPMType.GetText();
    }

    if (currentColumn.fieldName === "Priority") {
        cellInfo.value = glPriority.GetValue();
        cellInfo.text = glPriority.GetText();
    }
    if (currentColumn.fieldName === "ToolType") {
        cellInfo.value = glToolType.GetValue();
        cellInfo.text = glToolType.GetText();
    }
    if (currentColumn.fieldName === "MaterialType") {
        cellInfo.value = glMaterialType.GetValue();
        cellInfo.text = glMaterialType.GetText();
    }
}

function PutDescription(selectedValues) {
    console.log(selectedValues)
    StepProcess.batchEditApi.EndEdit();
    StepProcess.batchEditApi.SetCellValue(index, "Rate", selectedValues);
}

function StepCode_OnChange(s, e) {
    console.log(GetEditValue("StepCode"));
    console.log(e.GetEditValue("StepCode"));

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

// Gridview Button Event
function OnCustomClick(s, e) {
    // Delte Gridview row
    var entry = getParameterByName('entry');
    var transtype = getParameterByName('transtype');
    if (entry == "V" || entry == "D") {
        console.log('wad');
        alert('Can not delete detail during view');
        return;
    }

    if (e.buttonID == "Delete") gvStepProcess.DeleteRow(e.visibleIndex);
    if (e.buttonID == "BOMDelete") gvStepBOM.DeleteRow(e.visibleIndex);
    if (e.buttonID == "PMDelete") gvPMSched.DeleteRow(e.visibleIndex);
    if (e.buttonID == "MTDelete") gvMaterial.DeleteRow(e.visibleIndex);
    if (e.buttonID == "ToolDelete") gvTool.DeleteRow(e.visibleIndex);
    if (e.buttonID == "MaterialDelete") gvOtherMaterial.DeleteRow(e.visibleIndex);

    if (e.buttonID == "ViewPrint") {

        var checklist = s.batchEditApi.GetCellValue(e.visibleIndex, "ChecklistForm");
        var machineid = s.batchEditApi.GetCellValue(e.visibleIndex, "MachineID");
        var PMType = s.batchEditApi.GetCellValue(e.visibleIndex, "PMType");

        window.open("../WebReports/ReportViewer.aspx?val=~" + checklist + '&transtype=' + transtype + '&docnumber=' + machineid + '&reprinted=false_blank&pmtype='+PMType);

    }



}

function OnCustomButtonClick(s, e) {
    index = e.visibleIndex;
    s.ExpandDetailRow(index);
}

function OnEndCallback(s, e) {
    if (index != -1) {
        var i = index;
        index = -1;
        s.PerformCallback("AddDetail|" + i);
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
                //console.log('anoto')
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
        console.log('2')
        gvStepProcess.batchEditApi.EndEdit();
        gvStepProcess.batchEditApi.StartEdit(previndex, gvStepProcess.GetColumnByField(currentColumn.fieldName).index);
    }


    //loader.Hide();
}
// Gridlookup Event END

// Function UpdateDescription, Update SKU Descrption Field
//function UpdateDescription(s, e) {
//    console.log(e);
//    cp.PerformCallback('UpdateDescription');
//}

function OnFileUploadComplete(s, e) 
{


    cp_frmLayoutRouting_PC_0_FileName_I.value = e.errorText;
    document.getElementById("cp_frmLayoutRouting_PC_0_FileListN").style.display = "block";
    var FileName = e.callbackData;
    var justname = FileName.split('.');
    


    var path = '../MachineManual' + FileName;


    var mydiv = document.getElementById("FilesN");
    var span = document.createElement('span');
    var aTag = document.createElement('a');
    var br = document.createElement('br');

    aTag.setAttribute('href', path);
    aTag.innerHTML = "<img src='../Assets/img/icon/views.png' style='width:5%;' alt='StackOverflow Logo'/>";
    span.innerText = justname;


    mydiv.appendChild(aTag);
    mydiv.appendChild(span);
    mydiv.appendChild(br);



    alert("Manual Successfully Uploaded");
   
    
    
}
function Deletefile(del) {
    var val = del.value;
    console.log(val);
    var id = del.id.split(',');
    var divid = id[0];
    var src = document.getElementById('cp_frmLayoutRouting_PC_0_FileName_I').value;
    //console.log(src);
    var url = src.split(',');
    //console.log(url[divid])

    var rep = src.replace(val, '');
    var newPath = rep.replace(',', '');
    //console.log(rep);
    console.log(newPath);
 
    FileName.SetText(newPath);
    var value = sessionStorage.getItem("userid");
    console.log(value);
    document.getElementById(divid).style.display = "none";

    var data = {};
    data.Manual = newPath;
    $.ajax({
        type: "POST",
        url: "frmMachine.aspx/UpdateSession",
        data: '{name: ' + JSON.stringify(data) + ' }',
        contentType: "application/json",
        dataType: "json",
        success: function (data) {
            alert("Deleted Successfully")
        }
    });


}
function preview() {
    var src = document.getElementById('cp_frmLayoutRouting_PC_0_FileName_I').value;
    //window.open(src);
    if (src == "" || src == null) {
        document.getElementById("cp_frmLayoutRouting_PC_0_FileList").style.display = "none";
        document.getElementById("cp_frmLayoutRouting_PC_0_btnDelete").style.display = "none";
    }
            else {
    
                var url = src.split(',');

                for (var i = 0; i < url.length; i++) {
                    // Trim the excess whitespace.
                    url[i] = url[i].replace(/^\s*/, "").replace(/\s*$/, "");
                    // Add additional code here, such as:
                    var urlname = url[i].split('../MachineManual/'); 

                    var container_div = document.getElementById('Files');
                    var count = container_div.getElementsByTagName('div').length;

                    var couunt = count;
                    console.log(couunt);

                    var mydiv = document.getElementById("Files");
                    var div = document.createElement('div');
                    var del = document.createElement('button');
                    var span = document.createElement('span');
                    var aTag = document.createElement('a');
                    var br = document.createElement('br');
                    //var ico= document.createElement('i');
                    aTag.setAttribute('href', url[i]);
                    aTag.setAttribute('target', '_blank');
                    aTag.innerHTML = "<img src='../Assets/img/icon/views.png' style='width:4%; margin-top:2px;' alt='StackOverflow Logo'/>";
                    span.innerText = urlname;
                    div.setAttribute('id', couunt);
                    del.setAttribute('id', couunt + ',d');
                    del.setAttribute('value', url[i]);
                    del.setAttribute('type', 'button');
                    del.setAttribute('onclick', 'Deletefile(this)');
                    del.setAttribute('class','delbutton');
                    del.innerText = 'Delete';
       
                    mydiv.appendChild(div);
                    
                    div.appendChild(aTag);
                    
                    div.appendChild(span);
                    div.appendChild(del);
                    div.appendChild(br);
                }
        //window.open(url[i]);
    }
    

}



// PMType valuechanged event
function UpdatePMType(values) {
    gvPMSched.batchEditApi.EndEdit();
    gvPMSched.batchEditApi.SetCellValue(index, "PMType", values[0]);
    var type = values[0];

    if (type == 'Daily')
    {
      console.log('araw')
        gvPMSched.batchEditApi.SetCellValue(index, "Time", 'Daily');
        
    } 
    else if (type == 'Weekly') 
    {
        console.log('linggo')
        gvPMSched.batchEditApi.SetCellValue(index, "Time", 'of the Week');
    }
    else if (type == 'Monthly') 
    {
        console.log('buwan')
        gvPMSched.batchEditApi.SetCellValue(index, "Time", 'of the Month');
    }
    else if(type == 'Annual')
    {
        console.log('taon')
         gvPMSched.batchEditApi.SetCellValue(index, "Time", 'Yearly');
    }
    checkPMType()
}



function checkPMType(s, e) {


    setTimeout(function () {

        var iMO = gvPMSched.batchEditApi.GetRowVisibleIndices();
        var PM = '';

        for (var h = 0; h < iMO.length; h++) {
            PMT = gvPMSched.batchEditApi.GetCellValue(iMO[h], "PMType");
            PM += PMT  + ',';
          
            
        }

        const array = PM.split(",");
        var uniqueval = array.filter(function (itm, i, a) {// array of unique elements
            return i == array.indexOf(itm);
        });
        if (array.length > uniqueval.length) {
            alert("Warning! PM Schedule won't be save , Cannot insert Duplicate PMType");
        }
        else {
          
        }

    }, 500);
}


function checkIfArrayIsUnique(myArray) {
    return myArray.length === new Set(myArray).size;
}
//check unit



// DateTime valuechanged event
//function DateTime(s, e) {

//    console.log(s);
//    console.log(e);
//    //gvPMSched.batchEditApi.EndEdit();
//    //time = parseFloat(batchEditApi.GetCellValue(index, "PMType"));
//    //var times = timetime;
//    //console.log(times);
//    //if (type == 'Daily') {
//    //    console.log('araw')
//    //    gvPMSched.batchEditApi.SetCellValue(index, "Time", 'Daily');

//    //}
//    //else if (type == 'Weekly') {
//    //    console.log('linggo')
//    //    gvPMSched.batchEditApi.SetCellValue(index, "Time", 'of the Week');
//    //}
//    //else if (type == 'Monthly') {
//    //    console.log('buwan')
//    //    gvPMSched.batchEditApi.SetCellValue(index, "Time", 'of the Month');
//    //}
//    //else if (type == 'Annual') {
//    //    console.log('taon')
//    //    gvPMSched.batchEditApi.SetCellValue(index, "Time", 'Yearly');
//    //}
//}




// Priority valuechanged event
function UpdatePriority(values) {
    gvPMSched.batchEditApi.EndEdit();
    gvPMSched.batchEditApi.SetCellValue(index, "Priority", values);
    console.log('ayawdin');
}


// Priority valuechanged event
function UpdateChecklist(values) {
    gvPMSched.batchEditApi.EndEdit();
    gvPMSched.batchEditApi.SetCellValue(index, "ChecklistForm", values[1]);
    console.log('ayawsssdin');
}


// MaterialType valuechanged event
function UpdateMaterialType(values) {
    console.log(values[0]);
    gvMaterial.batchEditApi.EndEdit();
    gvMaterial.batchEditApi.SetCellValue(index, "MaterialType", values);
    
}

// ToolType valuechanged event
function UpdateToolType(values) {
    gvTool.batchEditApi.EndEdit();
    gvTool.batchEditApi.SetCellValue(index, "ToolType", values);
    console.log('ayawto');
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
            var docno = document.getElementById("cp_frmLayoutRouting_PC_0_MachineID_I").value;
            console.log(docno);

            window.location.replace('../ReferenceFile/frmMachineMaster.aspx?entry=E&transtype=REFMACM&parameters=&iswithdetail=null&docnumber=' + docno + '');
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

    //OnLoaderHide();
} //
function ShowLoginWindow() {
    pcLogin.Show();
}
function ShowCreateAccountWindow() {
    pcCreateAccount.Show();
    tbUsername.Focus();
}
function onFileUploadStart(s, e) {
    uploadInProgress = true;
    uploadErrorOccurred = false;
    UploadedFilesTokenBox.SetIsValid(true);
}
function onFilesUploadComplete(s, e) {
    uploadInProgress = false;
    for (var i = 0; i < uploadedFiles.length; i++)
        UploadedFilesTokenBox.AddToken(uploadedFiles[i]);
    updateTokenBoxVisibility();
    uploadedFiles = [];
    if (submitInitiated) {
        SubmitButton.SetEnabled(true);
        SubmitButton.DoClick();
    }
}
function onSubmitButtonInit(s, e) {
    s.SetEnabled(true);
}

function Delete() {
    s.SetEnabled(true);
}
function onSubmitButtonClick(s, e) {
    ASPxClientEdit.ValidateGroup();
    if (!formIsValid())
        e.processOnServer = false;
    else if (uploadInProgress) {
        s.SetEnabled(false);
        submitInitiated = true;
        e.processOnServer = false;
    }
}
function onTokenBoxValidation(s, e) {
    var isValid = DocumentsUploadControl.GetText().length > 0 || UploadedFilesTokenBox.GetText().length > 0;
    e.isValid = isValid;
    if (!isValid) {
        e.errorText = "No files have been uploaded. Upload at least one file.";
    }
}
function onTokenBoxValueChanged(s, e) {
    updateTokenBoxVisibility();
}
function updateTokenBoxVisibility() {
    var isTokenBoxVisible = UploadedFilesTokenBox.GetTokenCollection().length > 0;
    UploadedFilesTokenBox.SetVisible(isTokenBoxVisible);
}
function formIsValid() {
    return !ValidationSummary.IsVisible() && DescriptionTextBox.GetIsValid() && UploadedFilesTokenBox.GetIsValid() && !uploadErrorOccurred;
}
// Function OnUpdateClick, Add/Edit/Close button function
function OnUpdateClick(s, e) {
    //btn.SetEnabled(false);
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


        if (isValid && counterror < 1 || btnmode == "Close") { //check if there's no error then proceed to callback
            if (btnmode === "Delete") {
                cp.PerformCallback("Delete");
            }
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
    }, 1000);
}
