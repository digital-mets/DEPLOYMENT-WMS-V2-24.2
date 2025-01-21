$(document).ready(function () {
    $('#txtWorkWeek_I').val(moment(new Date(), "MMDDYYYY").isoWeek());
});

// Calendar START
function OnInit(s, e) {
    var calendar = s.GetCalendar();
    calendar.owner = s;
    calendar.GetMainElement().style.opacity = '0';
}

function OnDropDown(s, e) {
    var calendar = s.GetCalendar();
    var fastNav = calendar.fastNavigation;
    fastNav.activeView = calendar.GetView(0, 0);
    fastNav.Prepare();
    fastNav.GetPopup().popupVerticalAlign = "Below";
    fastNav.GetPopup().ShowAtElement(s.GetMainElement())

    fastNav.OnOkClick = function () {
        var parentDateEdit = this.calendar.owner;
        var currentDate = new Date(fastNav.activeYear, fastNav.activeMonth, 1);
        parentDateEdit.SetDate(currentDate);
        parentDateEdit.HideDropDown();
    }

    fastNav.OnCancelClick = function () {
        var parentDateEdit = this.calendar.owner;
        parentDateEdit.HideDropDown();
    }
}

function getWeek() {
    return moment(new Date(), "MMDDYYYY").isoWeek();
}
// Calendar END

// Function MachineCP_OnStartEditing, Enable/Disable editing
function MachineCP_OnStartEditing(s, e) {
    currentColumn = e.focusedColumn;
    var cellInfo = e.rowValues[e.focusedColumn.index];

    var entry = getParameterByName('entry');

    if (entry == "V") e.cancel = true; //this will made the gridview readonly
}

function MachineCP_OnEndEditing(s, e) {
    var cellInfo = e.rowValues[currentColumn.index];

    var entry = getParameterByName('entry');
    console.log('e');
    if (currentColumn.fieldName === "Type") {
        //cellInfo.value = colType.GetValue();
        //cellInfo.text = colType.GetText();
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


    //if (valchange) {

    //    valchange = false;
    //    closing = false;
    //    for (var i = 0; i < s.GetColumnsCount() ; i++) {
    //        var column = s.GetColumn(i);
    //        if (column.visible == false || column.fieldName == undefined)
    //            continue;
    //        ProcessCells(0, e, column, s);
    //    }
    //}
}

function OnInitTrans(s, e) {

    //var BizPartnerCode = aglCustomerCode.GetText();

    //if (BizPartnerCode != null && BizPartnerCode != "" && BizPartnerCode != '') {
    //    factbox2.SetContentUrl('../FactBox/fbBizPartner.aspx?BizPartnerCode=' + BizPartnerCode);
    //}

    //AdjustSize();

    //if (s == gvProductOrder && postback) {
    //    if (gvProductOrder.GetVisibleRowsOnPage() > 0)
    //        cbacker.PerformCallback('update|' + gvProductOrder.batchEditApi.GetCellValue(0, 'ItemCode'));
    //    postback = false;
    //}
}

function OnConfirm(s, e) {//function upon saving entry 
    //if (e.requestTriggerID === "cp" || e.requestTriggerID === "cp_frmlayout1_PC_0_gvBOM")//disables confirmation message upon saving.
    e.cancel = true;
}

// Gridview button event
function OnCustomClick(s, e) {

    // Set default count to 0
    if (undefined == e.buttonID) machineCP.batchEditApi.SetCellValue(e.visibleIndex, "RoutingCount", 0);

    // Delte Gridview row
    if (e.buttonID == "deleteRow") machineCP.DeleteRow(e.visibleIndex);

    // Show Process Step Modal per Row
    if (e.buttonID == "showCPModal") {
        var id = e.buttonID.split("show")[1] + e.visibleIndex;
        var isExisting = $('#' + id).length;

        isExisting > 0 ? $('#' + id).modal('show') : createModal(id, "Sequence" + e.visibleIndex);
    }
}




// Function createModal, Create Modal per row
function createModal(id, title) {
    var crModal = "";
    var modalClass = id.split("-")[0];

    crModal = '<div class="modal fade ' + modalClass + '" id="' + id + '" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">' +
                '<div class="modal-dialog modal-xl modal-dialog-scrollable">' +
                    '<div class="modal-content">' +
                        '<div class="modal-header" style="background-color:#2A88AD;color:#fff;">' +
                            '<h5 class="modal-title" id="staticBackdropLabel">' + title + '</h5>' +
                            '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color:#fff;"></button>' +
                        '</div>' +
                        '<div class="modal-body">' +
                        '<div class="inner">' +
                            '<div class="col">' +
                                '<div class="table-responsive" style="border: solid 2px #dadada; margin-bottom: 2%; overflow: auto; max-height:300px">' +
                                    '<div class="' + modalClass + 'Table"></div>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                        '</div>' +
                        '<div class="modal-footer">' +
                            '<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
            '</div>';

    $("body").append(crModal);

    var myModal = new bootstrap.Modal(document.getElementById(id), {
        backdrop: 'static',
        keyboard: false
    });

    createRow(id, modalClass + "Table");
    myModal.show();
}

// Tables START
var clicks = 1;

// Function createRow, Create row on modal table
function createRow(id, tableClass) {
    var body = document.querySelector("#" + id + " ." + tableClass);
    var tbl = document.createElement("table");
    var tblBody = document.createElement("thead");
    var tblBody2 = document.createElement("tbody");
    var columnCount = 6;
    var columnTitle = ["", "Process Sequence", "Process Code", "Type of Machine", "Available Machine", "Machine Details", "Capacity/hr per Batch"];

    for (var i = 0; i < 1; i++) {
        var row = document.createElement("tr");
        for (var j = 0; j <= columnCount; j++) {
            var cell = document.createElement("th");
            if (j == 0) {
                var cellText = document.createElement("button");
                cellText.setAttribute('type', 'button');
                cellText.innerHTML = '<i class="fas fa-plus fa-xs"></i>';
                cellText.setAttribute('onclick', 'appendRow("' + tableClass + '","' + tableClass + id.split("-")[1] + '",' + columnCount + ',' + JSON.stringify(columnTitle) + ')');
                cellText.setAttribute('id', 'btnAppends');
                cellText.setAttribute('class', 'btn btn-sm btn-info active');
                cell.style.textAlign = "center";
                cell.appendChild(cellText);
            } else {
                var cellText = document.createElement("label");
                cellText.innerHTML = columnTitle[j];
                cell.setAttribute('class', "jdTableRow0" + j);
                cell.appendChild(cellText);
            }

            cell.setAttribute('id', "input");
            row.appendChild(cell);
        }
        tblBody.appendChild(row);
    }
    tblBody2.setAttribute('class', "tbody");
    tblBody.setAttribute('class', "thead");
    tbl.appendChild(tblBody2);
    tbl.appendChild(tblBody);
    tbl.setAttribute('class', tableClass + " table table-striped table-bordered");
    tbl.setAttribute('id', tableClass + id.split("-")[1]);
    body.appendChild(tbl);
}

// Function appendRow, Add row event
function appendRow(tableClass, tableID, length, title) {

    clicks += 1;
    var empTab = document.querySelector("." + tableClass + " #" + tableID + " .tbody");
    var rowCnt = empTab.rows.length;
    var newID = ""

    var tr = empTab.insertRow(rowCnt);

    for (var c = 0; c <= length; c++) {
        var td = document.createElement('td');
        td = tr.insertCell(c);
        var ele = document.createElement('input');
        if (c == 0) {
            var eleButton = document.createElement('button');
            eleButton.innerHTML = '<i class="fas fa-trash fa-xs"></i>';
            eleButton.setAttribute('onclick', 'removeRow(this)');
            eleButton.setAttribute('class', 'btn btn-sm btn-danger active');
            td.style.textAlign = "center";
            td.appendChild(eleButton);
        } else {
            ele.setAttribute('type', 'text');
            ele.setAttribute('value', '');
            ele.setAttribute('class', 'form-control form-control-sm');
            td.appendChild(ele);
        }
    }

    updateCount(tableID);
}

// Function removeRow, Remove row event
function removeRow(oButton) {
    var tableid = oButton.parentNode.parentNode.parentNode.parentNode.id;
    var empTab = document.getElementById(tableid);
    empTab.deleteRow(oButton.parentNode.parentNode.rowIndex);

    updateCount(tableid);
}

// Function updateCount, Update count per row on Gridview
function updateCount(tableid) {
    machineCP.batchEditApi.SetCellValue('-' + tableid.split("Table")[1], "RoutingCount", $('#' + tableid + " .tbody tr").length);
}
// Tables END

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}